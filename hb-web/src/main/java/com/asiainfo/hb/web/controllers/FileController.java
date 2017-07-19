package com.asiainfo.hb.web.controllers;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.HttpHostConnectException;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.InputStreamEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.asiainfo.hb.core.models.Configuration;
import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * @author: 张东升 pst_core 2011-11-28
 * 
 * @author：Mei Kefu 增加新的上传方法
 * @author zhangdongsheng 新增文件下载方法
 */
@Controller
@SessionAttributes({SessionKeyConstants.USER})
public class FileController {
	private String defaultPath = Configuration.getInstance().getProperty("com.asiainfo.pst.controllers.defaultPath");
	
	private static Logger LOG = Logger.getLogger(FileController.class);
	 
	@RequestMapping("/fileMgr")
	public @ResponseBody Object fileManager(HttpServletResponse response, HttpServletRequest request) {
		String cmd = request.getParameter("cmd");
		try {
			if (cmd != null) {
				cmd = cmd.trim();
				String filepath = request.getParameter("filepath");
				String fileName = request.getParameter("filename");
				String path = request.getSession().getServletContext().getRealPath(filepath);
				if (filepath != null) {
					path = spellRightUrl(defaultPath, filepath);
				}
				File file = new File(path + File.separatorChar + fileName);
				
				if (!file.exists()) {
					LOG.warn("文件不存在:"
							+ path
							+ File.separatorChar
							+ fileName
							+ ",请检查pst_web.propertites配置com.asiainfo.pst.controllers.defaultPath");
					try {
						response.getWriter().write("文件不存在:" + path + File.separatorChar+ fileName);
						response.flushBuffer();
					} catch (IOException e) {
						e.printStackTrace();
					}
					return "文件不存在:" + path + File.separatorChar + fileName;
				}
				if (cmd.equalsIgnoreCase("download")) {
					download(file,response);
				}else if (cmd.equalsIgnoreCase("showHtml")){
					return showHtml(file,response);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public String showHtml(File file,HttpServletResponse response){
		InputStream input = null;
		BufferedReader reader = null;
		StringBuffer sbf = new StringBuffer("");
		try {
			input = new FileInputStream(file);
			String line;
			reader = new BufferedReader(new InputStreamReader(input));
			line = reader.readLine();    
	        while (line != null) {    
	        	sbf.append(line);
	        	sbf.append("\t\n<br>");
	            line = reader.readLine();
	        } 
		} catch (Exception e) {
			LOG.error(e.getMessage());
		} finally {
			try {
				if (input != null)
					input.close();
				if (reader != null)
					reader.close();
			} catch (IOException e) {
				LOG.error(e.getMessage());
			}
		}
		return sbf.toString();
	}

	public void download(File file,HttpServletResponse response){
		String fileName = file.getName();
		try {
			fileName=new String(fileName.getBytes("utf-8"),"iso-8859-1");
		} catch (UnsupportedEncodingException e1) {
			
			e1.printStackTrace();
		}
		response.reset();
		response.setContentType("application/octet-stream;charset=utf-8");
		response.addHeader("Content-Disposition", "attachment;filename="+fileName);
		response.setContentLength((int) file.length());
		byte[] buffer = new byte[10240];
		OutputStream out = null;
		InputStream input = null;
		try {
			out = response.getOutputStream();
			input = new FileInputStream(file);
			int r = 0;
			while ((r = input.read(buffer, 0, buffer.length)) != -1) {
				out.write(buffer, 0, r);
			}
			response.flushBuffer();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (input != null)
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
	}

	@RequestMapping("/fileupload")
	public void processImageUpload(MultipartHttpServletRequest request, @ModelAttribute(SessionKeyConstants.USER) User user,Writer writer) {
		String absolutePath = null;
		String uploadPath = request.getParameter("uploadPath");
		String paths = "";
		if (uploadPath != null) {
			paths = spellRightUrl(defaultPath, uploadPath);
			absolutePath = uploadPath;
		} else {
			paths = spellRightUrl(defaultPath, Configuration.getInstance().getProperty("uploadTempDirectory"));
		}
		List<MultipartFile> files = request.getFiles("file");
		
		//baidu编辑插件使用
		if (files.size() == 0){
			files = request.getFiles("picdata");
		}
		
		MultipartFile file = files.get(0);
        
		String fileName = null;
		String filelevel = (String) request.getParameter("filelevel");
		if (filelevel != null) {
			fileName = getNewFileName(file.getOriginalFilename());
		}

		Map<String, Object> returnVal = new HashMap<String, Object>();
		returnVal.put("success", false);
		FileOutputStream fos = null;
		try {
			if (!file.isEmpty()) {
				File fileDir = new File(paths);
				if (!fileDir.exists()) {// 创建目录
					fileDir.mkdirs();
				}
				byte[] bytes = file.getBytes();
				fos = new FileOutputStream(paths
						+ File.separator
						+ (fileName == null ? file.getOriginalFilename()
								: fileName));
				fos.write(bytes); // 写入文件
				fos.close();
				if (fileName != null && !filelevel.equalsIgnoreCase("2")) {
					saveFileList(paths, uploadPath, file.getOriginalFilename(),
							fileName, "上传完成",user);// 写入fileList表
				}
				
				returnVal.put("title", (fileName == null ? file.getOriginalFilename(): fileName));
				returnVal.put("state", "SUCCESS");
				
				returnVal.put("success", true);
				returnVal.put("message", "完成");

				Map<String, String> map = new HashMap<String, String>();
				map.put("parent", absolutePath);
				map.put("child", fileName == null ? file.getOriginalFilename()
						: fileName);
				List<Map<String, String>> data = new ArrayList<Map<String, String>>();
				data.add(map);
				returnVal.put("data", data);
			} else {
				returnVal.put("message", "没有要上传的附件!");
			}
		} catch (IOException e) {
			returnVal.put("message", e.getMessage());
			e.printStackTrace();
		} finally {
			if (fos != null)
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		// return returnVal;
		try {
			writer.write(JsonHelper.getInstance().write(returnVal));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public String getNewFileName(String filename) {
		Calendar ca = Calendar.getInstance();
		int year = ca.get(Calendar.YEAR);// 获取年份
		int month = ca.get(Calendar.MONTH);// 获取月份
		int day = ca.get(Calendar.DATE);// 获取日
		int minute = ca.get(Calendar.MINUTE);// 分
		int hour = ca.get(Calendar.HOUR);// 小时
		int second = ca.get(Calendar.SECOND);// 秒
		int milsecond = ca.get(Calendar.MILLISECOND);
		String newFileName = year + "_" + (month + 1) + "_" + day + "_" + hour + "_" + minute + "_" + second + "_" + milsecond;

		String suffix = getSuffixType(filename);
		newFileName += (suffix == null ? "" : suffix);
		return newFileName;
	}

	public String getSuffixType(String filename) {
		if (filename != null) {
			return filename.substring(filename.lastIndexOf("."),
					filename.length());
		}
		return null;
	}

	public void saveFileList(String realPath, String fileDir,
			String clientFile, String serverFile, String state,User user) {
		File file = new File(realPath + File.separator + serverFile);
		Long file_size = Long.valueOf(0);
		String suffix = null;
		if (file.exists()) {
			file_size = file.length();
			suffix = getSuffixType(serverFile);
		}
		new JdbcTemplate("dataSource")
				.update("insert into MD.PSTFILELIST(FILEDIR,CLIENT_FILENAME,SERVER_FILENAME,FILE_SUFFIX,FILESIZE,STATE,CREATER) values(?,?,?,?,?,?,?)",
						new Object[] { fileDir, clientFile, serverFile, suffix,
								file_size, state ,user.getId()});
	}

	private static Pattern s = Pattern.compile("(^/|^\\\\)");
	private static Pattern e = Pattern.compile("/$|\\\\$");

	public String spellRightUrl(String start, String end) {
		return e.matcher(start).replaceFirst("") + File.separator
				+ s.matcher(end).replaceFirst("");
	}
	
	//--------------------------------------------
	@SuppressWarnings("static-access")
	@RequestMapping(value="file/upload",method=RequestMethod.POST)
	public void ajaxUpload(HttpServletRequest request,HttpServletResponse response){
		
		String path = request.getSession().getServletContext().getRealPath("upload");
		String absFileName="";
		try {
			String oriFileName = getFileName(request);
			String fileName = oriFileName;
			Pattern pattern = Pattern.compile("[\\s\\S]*\\.(png|jpeg|jpg|gif)");
			Matcher m = pattern.matcher(oriFileName);
			if(m.matches()){
				String extName = m.group(1);
				fileName = Long.toHexString(System.currentTimeMillis())+"."+extName;
			}
			absFileName=ajaxFileUpload(path,fileName,request, response);
			uploadFileServer(absFileName);
			
			response.setStatus(response.SC_OK);
			response.getWriter().print("{success: true,fileName:'"+fileName+"',oriFileName:'"+oriFileName+"',url:'"+fileserverUri+"/upload/"+fileName+"'}");
			response.getWriter().flush();
			response.getWriter().close();
		} catch (RuntimeException e) {
			e.printStackTrace();
			try {
				response.setStatus(response.SC_OK);
				response.getWriter().print("{success: false,msg:'"+e.getMessage()+"'}");
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			File file = new File(absFileName);
			if(file.exists())
				file.delete();
		}
	}
	
	@SuppressWarnings("static-access")
	public String ajaxFileUpload(String path,String fileName,HttpServletRequest request,HttpServletResponse response){
		PrintWriter writer = null;
		FileOutputStream fos = null;
		String absFileName="";
		try {
			writer = response.getWriter();
		} catch (IOException ex) {
			LOG.error("has thrown an exception: "+ ex.getMessage());
		}
		try {
			File file = new File(path);
			if(!file.isDirectory()){
				file.mkdirs();
			}
			absFileName = path +"/"+ fileName.replaceAll(" ", "_");
			fos = new FileOutputStream(absFileName);
			makeFile(request, fos);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			response.setStatus(response.SC_INTERNAL_SERVER_ERROR);
			writer.print("{success: false,msg:'"+e.getMessage()+"'}");
			LOG.error("has thrown an exception: "+ e.getMessage());
		} catch (IOException e) {
			response.setStatus(response.SC_INTERNAL_SERVER_ERROR);
			writer.print("{success: false,msg:'"+e.getMessage()+"'}");
			LOG.error("has thrown an exception: "+ e.getMessage());
		} finally {
			try {
				fos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return absFileName;
	}
	
	
	private String fileserverUri=Configuration.getInstance().getProperty("com.asiainfo.pst.util.fileServerAddr");
	
	/**
	 * 上传文件到文件服务器
	 * @throws FileNotFoundException 
	 */
	private void uploadFileServer(String fileName) throws RuntimeException, FileNotFoundException{

		try {
			CloseableHttpClient httpClient = HttpClients.createDefault();
			HttpPost post = new HttpPost(fileserverUri+"/fileserver");
			File file = new File(fileName);
			InputStreamEntity entity = new InputStreamEntity(new FileInputStream(file),file.length(),ContentType.APPLICATION_OCTET_STREAM);  
			post.setHeader("X-File-Name",URLEncoder.encode(file.getName(),"utf-8"));
			post.setEntity(entity);
			HttpResponse response = httpClient.execute(post);
			int successCode=response.getStatusLine().getStatusCode();
			LOG.info("上传到文件服务器表示："+successCode);
			if(HttpStatus.SC_OK!=successCode){
	        	LOG.error(EntityUtils.toString(response.getEntity()));
	        }
	       /* httpClient.getConnectionManager().shutdown();*/
	        httpClient.close();
	        
		} catch (ClientProtocolException e) {
			e.printStackTrace();
			throw new RuntimeException("文件服务器异常不能上传"+e.getMessage());
		}catch(HttpHostConnectException e){
			e.printStackTrace();
			throw new RuntimeException("文件服务器异常不能上传"+e.getMessage());
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException("文件上传异常"+e.getMessage());
		}
	}

	private void makeFile(HttpServletRequest request,FileOutputStream fos) throws IOException{
		if( isMultipart(request)){
			MultipartFile multipartFile = getMultipartFile(request);
			if(multipartFile!=null && !multipartFile.isEmpty())
				fos.write(getMultipartFile(request).getBytes());
		}else{
			InputStream is = request.getInputStream();
			try{
				IOUtils.copy(is, fos);
			}finally{
				is.close();
			}
		}
	}
	
	String getFileName(HttpServletRequest request){
		String fileName="";
		if( isMultipart(request)){
			MultipartFile multipartFile = getMultipartFile(request);
			if(multipartFile!=null)
				fileName=getMultipartFile(request).getOriginalFilename().trim();
			else
				return "nofile";
		}else{
			fileName= request.getHeader("X-File-Name").trim();
		}
		try {
			fileName=  URLDecoder.decode(fileName,"utf-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return fileName;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private MultipartFile getMultipartFile(HttpServletRequest request){
		Map<String,MultipartFile> map = ((MultipartHttpServletRequest)request).getFileMap();
		
		for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry<String,MultipartFile> type = (Map.Entry<String,MultipartFile>) iterator.next();
			return type.getValue();
		}
		return null;
	}
	
	private boolean isMultipart(HttpServletRequest request){
		return request instanceof MultipartHttpServletRequest;
	}
	
	@RequestMapping(value="file/download/{fileName:.+(?=\\.\\w{1,6})?}",method=RequestMethod.GET)
	public void fileDownload(@PathVariable String fileName,HttpServletRequest request,HttpServletResponse response){
		String path = request.getSession().getServletContext().getRealPath("upload");
		download(new File(path+"/"+fileName),response);
	}
	
}
