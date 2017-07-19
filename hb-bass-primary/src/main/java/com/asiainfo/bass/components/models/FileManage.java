package com.asiainfo.bass.components.models;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.jdbc.support.rowset.SqlRowSetMetaData;
import org.springframework.stereotype.Component;

/**
 * 
 * @author Mei Kefu
 * @date 2009-11-4
 */
@SuppressWarnings("unused")
@Component
public class FileManage {

	private static Logger LOG = Logger.getLogger(FileManage.class);

	/**
	 * 
	 * @param sql
	 * @param fileName
	 * @param header
	 * @param ds
	 * @param fileType
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public void execute(JdbcTemplate jdbcTemplate, String sql, String fileName, Map header, String fileType, FilePorcess process) {
		File tempFile = null;
		try {
			tempFile = executeNotDelete(jdbcTemplate, sql, fileName, header, fileType, null);
			try {
				if (process != null)
					process.process(tempFile);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (tempFile != null) {
				LOG.debug("删除文件" + tempFile.getAbsolutePath());
				tempFile.delete();
			}
		}
	}

	/**
	 * 
	 * @param sql
	 * @param fileName
	 * @param header
	 * @param ds
	 * @param fileType
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public File executeNotDelete(JdbcTemplate jdbcTemplate, String sql, String fileName, Map header, String fileType, String sheetName) {

		String path = System.getProperty("user.dir") + "/";
		// String path = "d:"+"/";
		File tempFile = null;

		try {
			int headRows = 1;
			Iterator iterator = header.entrySet().iterator();
			if (iterator.hasNext()) {
				Map.Entry entry = (Map.Entry) iterator.next();
				Object obj = entry.getValue();

				if (obj instanceof List) {
					headRows = ((ArrayList) obj).size();
				}
			}
			Object target = null;

			List result = null;
			BufferedWriter bw = null;

			if ("excel".equalsIgnoreCase(fileType)) {
				tempFile = new File(path + fileName + ".xls");
				result = new ArrayList();
				target = result;
			} else {
				tempFile = new File(path + fileName + ".csv");
				bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(tempFile), "utf-8"), 512 * 1024);
				target = bw;
			}

			SqlRowSet rs = jdbcTemplate.queryForRowSet(sql);
			try {

				SqlRowSetMetaData rsmd = rs.getMetaData();
				List columnNames = new ArrayList();// 记录列的别名索引，避免数据库取的字段多余header的值会报错
				int size = rsmd.getColumnCount();
				String[] line = null;
				for (int j = 0; j < headRows; j++) {
					if ("excel".equalsIgnoreCase(fileType)) {
						line = new String[size];
					}
					int excelHeaderCount = 0;// excel的表头不能用i来标识，会有空的情况发生
					for (int i = 0; i < size; i++) {

						String columnName = rsmd.getColumnName(i + 1);

						if (headRows == 1) {
							String value = "";
							Object obj = header.get(columnName);

							if (obj instanceof List) {
								value = (String) ((List) obj).get(0);
							} else if (obj instanceof String) {
								value = (String) obj;
							} else {
								value = columnName;
							}

							value = (value == null ? "" : value);
							if ("excel".equalsIgnoreCase(fileType)) {
								line[i] = value;
							} else {
								bw.write(value);
								bw.write(",");
							}

						} else {
							List list = (List) header.get(columnName);
							if (list == null) {
								continue;
							}

							Object obj1 = list.get(j);

							if (obj1 == null) {
								continue;
							}

							if ("excel".equalsIgnoreCase(fileType)) {
								line[excelHeaderCount] = (String) list.get(j);
								excelHeaderCount++;
							} else {
								//  这个地方需要重构，要把header恢复成#rspan
								// #cspan，然后再这里替换成重复的名字
								bw.write((String) list.get(j));
								bw.write(",");
							}

						}
						if (j == 0) {// 只是第一次记录一次
							columnNames.add(columnName);
						}
					}
					if ("excel".equalsIgnoreCase(fileType)) {
						result.add(line);
					} else {
						bw.write("\r\n");
					}
				}
				int lineCount = 0;
				while (rs.next()) {
					if ("excel".equalsIgnoreCase(fileType)) {
						line = new String[size];
					}
					for (int j = 0; j < columnNames.size(); j++) {
						String value = rs.getString((String) columnNames.get(j));
						// Object obj =
						// rs.getObject((String)columnNames.get(j));
						// String value;
						// DecimalFormat df = new DecimalFormat( "###0");
						// DecimalFormat df1 = new DecimalFormat( "###0.00");
						// if(obj instanceof Double || obj instanceof Long ||
						// obj instanceof Integer){//防止科学计数法表示
						// value = df.format(obj);
						// }else if(obj instanceof BigDecimal){
						// value = df1.format(obj);
						// }else{
						// value = (String)obj;
						// }
						value = (value == null ? "" : value);
						if ("excel".equalsIgnoreCase(fileType)) {
							line[j] = value;
						} else {
							bw.write(value);
							bw.write(",");
						}
					}
					if ("excel".equalsIgnoreCase(fileType)) {
						result.add(line);
						lineCount++;

						if (lineCount > 60000) {
							String[] notice = new String[] { "超过6w条截断" };
							result.add(notice);
							break;
						}
					} else {
						bw.write("\r\n");
					}
				}

			} catch (IOException e) {
				e.printStackTrace();
			}

			if ("excel".equalsIgnoreCase(fileType)) {
				ExcelWriter writer = new ExcelWriter();
				writer.createBook(tempFile);
				writer.writerSheet((List) target, sheetName != null ? sheetName : fileName);
				writer.closeBook();
			} else {
				((BufferedWriter) target).flush();
				((BufferedWriter) target).close();
			}

		} catch (Exception e) {
			e.printStackTrace();
			LOG.error("生成" + sheetName + "时出错：" + e.getMessage(), e);
		}

		return tempFile;
	}

	public void outFile(HttpServletResponse response, File file) throws IOException {
		response.reset();
		response.setContentType("octet-stream; charset=UTF-8");
		response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(file.getName(), "UTF-8"));
		response.setContentLength((int) file.length());
		byte[] buffer = new byte[10240];
		OutputStream out = response.getOutputStream();
		InputStream in = null;
		try {
			in = new FileInputStream(file);
			int r = 0;
			while ((r = in.read(buffer, 0, buffer.length)) != -1) {
				out.write(buffer, 0, r);
			}

			out.flush();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (in != null)
				in.close();
			if (out != null)
				out.close();

		}
	}

	/**
	 * 
	 * 
	 * @author Mei Kefu
	 * @date 2010-7-12
	 */
	public static abstract class FilePorcess {
		public abstract void process(File file);

		public void setObject(Object object) {
		}

		public Object getObject() {
			return null;
		}
	}

}
