package com.asiainfo.hb.ftp.controllers;

import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.SocketException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jxl.Workbook;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableWorkbook;

import org.apache.camel.model.dataformat.SyslogDataFormat;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.RequestContext;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.servlet.ServletRequestContext;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.multipart.MultipartFile;

import com.asiainfo.hb.ftp.util.FtpUtil;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@SuppressWarnings("unused")
@Controller
@RequestMapping(value = "/uploadfile")
public class UploadController {

	private static Logger LOG = Logger.getLogger(UploadController.class);

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "upload")
	public @ResponseBody String upload(HttpServletRequest request, HttpServletResponse response, @ModelAttribute(SessionKeyConstants.USER) User user) throws Exception {
		String textcomminute = ""; // 文本分隔符
		// 临时文件夹路径
		String path = System.getProperty("user.dir") + "/";
		String txtType = "utf-8"; // 文本读取,导出格式
		File file = new File(path); // 实例化文件夹
		if (file.exists()) {
			LOG.info("该文件目录已经存在不需要创建！！");
		} else {
			// 创建文件夹
			file.mkdirs();
		}
		request.setCharacterEncoding(txtType); // 设置request返回格式为utf-8
		RequestContext requestContext = new ServletRequestContext(request);

		if (FileUpload.isMultipartContent(requestContext)) {

			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setRepository(new File(path));
			ServletFileUpload upload = new ServletFileUpload(factory);
			upload.setHeaderEncoding(txtType); // 设置传递文本数据格式为utf-8
			upload.setSizeMax(2000000);
			List items = new ArrayList();
			try {
				items = upload.parseRequest(request);
			} catch (FileUploadException e1) {
				LOG.info("文件上传发生错误" + e1.getMessage());
			}
			Iterator it = items.iterator();
			while (it.hasNext()) {
				FileItem fileItem = (FileItem) it.next();
				boolean flag = false;
				if (fileItem.getName().endsWith(".doc")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".docx")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".xls")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".xlsx")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".ppt")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".ppts")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".txt")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".png")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".bmp")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".jpg")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".jpeg")) {
					flag = true;
				} else if (fileItem.getName().endsWith(".gif")) {
					flag = true;
				}
				if (flag) {
					String fileName = "";
					String uploadFileName = "";
					// 循环获取表单提交所有字段文本
					if ("textcomminute".equals(fileItem.getFieldName())) {

						// 如果文本分隔符id:textcomminute等于当前循环的文本id
						textcomminute = new String(fileItem.getString().getBytes("iso8859-1"), "utf-8"); // 获取文本value
						LOG.info("文本分隔符:" + textcomminute + ";长度:" + textcomminute.length());
						// 获取表单"文本分隔符"字段
					}
					if (fileItem.isFormField()) {
						LOG.info(fileItem.getFieldName() + "   " + fileItem.getName() + "   " + new String(fileItem.getString().getBytes("iso8859-1"), "utf-8"));

					} else {
						LOG.info(fileItem.getFieldName() + "   " + fileItem.getName() + "   " + fileItem.isInMemory() + "    " + fileItem.getContentType() + "   " + fileItem.getSize());
						if (fileItem.getName() != null && fileItem.getSize() != 0) {
							fileName = fileItem.getName();
							fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);
							
							SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
							String time=sdf.format(new Date());
							String[] nameArr = fileName.split("\\.");
							if(nameArr.length == 2){
								uploadFileName = nameArr[0] + "_" + time + "." + nameArr[1];
							}else{
								uploadFileName = fileName +"_" + time; // 获取文件名
							}
							try {
								// 在服务器端写入文件流,创建文件
								fileItem.write(new File(path + uploadFileName));
							} catch (Exception e) {
								e.printStackTrace();
								LOG.info(e.getMessage().toString());
							}
							
							FtpUtil ftp = new FtpUtil("yh:yh@10.31.81.246:21");
							try {
								ftp.connect();
								String filePath = "safetyFile/";
								LOG.info("filePath=" + filePath);
								File tempFile = new File(uploadFileName);
								ftp.upload(filePath + uploadFileName, tempFile);
								tempFile.delete();
								response.getWriter().print("{\"success\":true,\"message\":'上传成功',\"newFileName\":'" + uploadFileName + "'}");
							} catch (Exception e) {
								e.printStackTrace();
								LOG.info(e.getMessage().toString());
								response.getWriter().print("{\"success\":false,\"message\":'上传失败'}");
							} finally {
								try {
									ftp.disconnect();
								} catch (IOException e) {
									e.printStackTrace();
								}
							}
							LOG.info("上传FTP成功");
						} else {
							LOG.info("文件没有选择 或 文件内容为空");
							response.getWriter().print("{\"success\":false,\"message\":'文件内容为空'}");
						}
					}
					
				} else {
					response.getWriter().print("{\"success\":false,\"message\":'上传失败,此类文件不允许上传'}");
				}

			}
		}
		return null;
	}
	

}