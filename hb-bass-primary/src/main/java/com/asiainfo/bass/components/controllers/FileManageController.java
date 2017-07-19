package com.asiainfo.bass.components.controllers;

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

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.multipart.MultipartFile;

import com.asiainfo.bass.components.models.DES;
import com.asiainfo.bass.components.models.DesUtil;
import com.asiainfo.bass.components.models.FtpHelper;
import com.asiainfo.bass.components.models.ConnectionManage;

/**
 * 
 * @author Mei Kefu
 * @date 2011-3-10
 */
@SuppressWarnings("unused")
@Controller
@RequestMapping(value = "/fileMgr")
public class FileManageController {

	private static Logger LOG = Logger.getLogger(FileManageController.class);

	@RequestMapping(value = "upload", method = RequestMethod.POST)
	public void uploadToFtp(@RequestParam()
	MultipartFile file) {
		LOG.debug("文件上传");
		FileOutputStream fos;
		if (!file.isEmpty()) {
			byte[] bytes;
			try {
				bytes = file.getBytes();
				fos = new FileOutputStream("d:/upload/"
						+ file.getOriginalFilename());
				fos.write(bytes);
			} catch (FileNotFoundException e) {
				
				e.printStackTrace();
			} catch (IOException e1) {
			
				e1.printStackTrace();
			}
		}
		System.out.println("name: " + file.getOriginalFilename() + "  size: "
				+ file.getSize()); // 打印文件大小和文件名称
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "listFile", method = RequestMethod.GET)
	public @ResponseBody
	Object listFiles(@RequestParam(value = "path")
	String path) {

		LOG.debug("显示文件" + path);
		FtpHelper ftp = new FtpHelper();
		List list = null;
		try {
			ftp.connect();
			list = ftp.listFiles(path);
			ftp.disconnect();
		} catch (SocketException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 从ftp服务器上面下载文件
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@RequestMapping(value = "down", method = RequestMethod.POST)
	public void downFromFtp(WebRequest request, OutputStream out) {
		String fileName = request.getParameter("fileName");
		FtpHelper ftp = new FtpHelper();
		try {
			ftp.connect();
			ftp.down(fileName, out);
			// response.flushBuffer();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			try {
				ftp.disconnect();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}
	
	/**
	 * 下载文件
	 * 
	 * @param request
	 * @param response
	 * @param sql 下载数据SQL
	 * @param ds 数据源
	 * @param fileName 文件名称
	 * @param fileType 文件类型
	 * @param spreadSheetHeader 文件表头
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "downLoad", method = RequestMethod.POST)
	public void downLoad(HttpServletRequest request, HttpServletResponse response,
			String sql, String ds, String fileName, String fileType,
			String spreadSheetHeader) throws Exception {
		//String path = System.getProperty("user.dir");
		String path=request.getSession().getServletContext().getRealPath("/")+"/download/";//下面的方法过时了
		//String path = request.getRealPath("/")+"/download/";
		boolean isExcel = "excel".equalsIgnoreCase(fileType);
		spreadSheetHeader = spreadSheetHeader == null ? "" : request
				.getParameter("spreadSheetHeader");
		String[] spreadSheetHeaderArray = null;
		if (spreadSheetHeader.length() > 0) {
			spreadSheetHeaderArray = spreadSheetHeader.split(",");
		}
		sql = DesUtil.defaultStrDec(sql);
		LOG.debug(sql);
		Statement stat = null;
		ResultSet rs = null;
		List resultList = new LinkedList();
		Connection conn = ConnectionManage.getInstance().getConnection(ds);
		try {
			stat = conn.createStatement();
			rs = stat.executeQuery(sql);
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnSize = rsmd.getColumnCount();
			while (rs.next()) {
				String[] row = new String[columnSize];
				for (int i = 0; i < columnSize; i++) {
					row[i] = (rs.getString(i + 1));
				}
				resultList.add(row);
			}
			ConnectionManage.getInstance().releaseConnection(conn);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (rs != null) {
				rs.close();
			}
			if (stat != null) {
				stat.close();
			}
		}
		BufferedWriter bw = null;
		if (!isExcel) {
			bw = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(path + fileName + ".csv"), "utf-8"),
					512 * 1024);
		}

		ByteArrayOutputStream os = null;
		os = new ByteArrayOutputStream();// 将 WritableWorkbook 写入到输出流
		WritableWorkbook wwb = null;
		jxl.write.WritableSheet ws = null;
		FileInputStream fin = null;
		try {
			wwb = Workbook.createWorkbook(os);
			ws = wwb.createSheet(fileName, 0);

			// 表头
			// 表头的样式
			WritableFont bold = new WritableFont(WritableFont.TIMES, 9,
					WritableFont.BOLD, false);
			WritableCellFormat cfBold = new WritableCellFormat(bold);
			cfBold.setAlignment(jxl.format.Alignment.CENTRE);
			cfBold.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			cfBold.setBorder(Border.ALL, BorderLineStyle.THIN);
			// 表身的样式
			WritableFont noBold = new WritableFont(WritableFont.TIMES, 9,
					WritableFont.NO_BOLD, false);
			WritableCellFormat cfNoBold = new WritableCellFormat(noBold);
			cfNoBold.setAlignment(jxl.format.Alignment.CENTRE);
			cfNoBold.setVerticalAlignment(jxl.format.VerticalAlignment.CENTRE);
			cfNoBold.setBorder(Border.ALL, BorderLineStyle.THIN);

			// 表内容
			for (int i = 1; i <= resultList.size(); i++) {
				String[] row = (String[]) resultList.get(i - 1);
				for (int j = 0; j < row.length; j++) {
					if (row[j] != null) {
						Label cell = new Label(j, i, (String) row[j], cfNoBold);
						if (isExcel) {
							ws.addCell(cell);
						} else {
							bw.write((String) row[j]);
							bw.write(",");
						}
					} else {
						Label cell = new Label(j, i, "", cfNoBold);
						if (isExcel) {
							ws.addCell(cell);
						} else {
							// bw.write((String) row[j]);
							// bw.write(",");
						}
					}
				}
				if (isExcel) {
				} else {
					bw.write("\r\n");
				}
			}
			// 添加表头内容
			if (isExcel && spreadSheetHeader.length() > 0) {
				for (int i = 0; i < spreadSheetHeaderArray.length; i++) {
					Label cell = new Label(i, 0, spreadSheetHeaderArray[i],
							cfBold);
					ws.addCell(cell);
				}

			}

			// 设置每列的宽度
			// ws.setColumnView(0, 25);
			// ws.setColumnView(1, 25);
			// ws.setColumnView(2, 25);
			// ws.setColumnView(3, 10);
			// ws.setColumnView(4, 25);
			// ws.setColumnView(5, 25);

			wwb.write();
			wwb.close();// 关闭工作薄
			// 将输出流生成文件
			if (isExcel) {
				File file = new File(path + fileName + ".xls");
				DataOutputStream dataOutputStream = new DataOutputStream(
						new FileOutputStream(file));
				os.writeTo(dataOutputStream);
			}

			if (isExcel) {
			} else {
				((BufferedWriter) bw).flush();
				((BufferedWriter) bw).close();
			}

			// 输出到response
			response.reset();

			if (isExcel) {
				response.setContentType("octet-stream; charset=UTF-8");
				response
						.addHeader("Content-Disposition",
								"attachment;filename="
										+ URLEncoder.encode(fileName + ".xls",
												"UTF-8"));
				fin = new FileInputStream(new File(path + fileName + ".xls"));
			} else {
				response.setContentType("octet-stream; charset=UTF-8");
				response
						.addHeader("Content-Disposition",
								"attachment;filename="
										+ URLEncoder.encode(fileName + ".rar",
												"UTF-8"));
				fin = new FileInputStream(new File(path + fileName + ".rar"));
			}
			int c = 0;
			while ((c = fin.read()) != -1) {
				response.getOutputStream().write(c);
			}
		} catch (java.lang.OutOfMemoryError e) {
			if (ws != null) {
				ws = null;
			}
			if (wwb != null) {
				wwb.close();
				wwb = null;
			}
			if (os != null) {
				os.close();
				os = null;
			}
			throw new Exception("系统资源不足！");
		} catch (Exception e) {
			e.printStackTrace();
			if (ws != null) {
				ws = null;
			}
			if (wwb != null) {
				wwb.close();
				wwb = null;
			}
			if (os != null) {
				os.close();
				os = null;
			}
		} finally {
			fin.close();
			os.flush();
			os.close();// 关闭输出流
			ws = null;
			wwb = null;
			os = null;
		}
	}

}
