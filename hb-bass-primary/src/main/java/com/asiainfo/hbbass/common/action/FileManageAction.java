package com.asiainfo.hbbass.common.action;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.SocketException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hb.web.models.User;
import com.asiainfo.hbbass.common.file.ExcelReader;
import com.asiainfo.hbbass.common.file.ExcelWriter;
import com.asiainfo.hbbass.common.file.FTPHelper;
import com.asiainfo.hbbass.common.file.FileHttpServletRequest;
import com.asiainfo.hbbass.common.file.FileHttpServletRequestHandler;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;
import com.asiainfo.util.DateUtil;

/**
 * 
 * @author Mei Kefu
 * @date 2009-11-4
 */
public class FileManageAction extends Action {

	private static Logger LOG = Logger.getLogger(FileManageAction.class);

	private JsonHelper jsonHelper = JsonHelper.getInstance();
	
	private static Map<String,String> mapAreaCode=new Hashtable<String,String>();
	
	private static final String db2LoadPath=System.getProperty("user.dir")+File.separator;
	
	static{
		mapAreaCode.put("0","270");
		mapAreaCode.put("11","270");
		mapAreaCode.put("12","714");
		mapAreaCode.put("13","711");
		mapAreaCode.put("14","717");
		mapAreaCode.put("15","718");
		mapAreaCode.put("16","719");
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void uploadToFtp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		LOG.debug("文件上传");
		FileHttpServletRequest wrapperRequest = FileHttpServletRequestHandler.parse(request);
		response.getWriter().write(jsonHelper.write(wrapperRequest.uploadToFtp()));
	}

	public void listRemoteFiles(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String remotePath = request.getParameter("remotePath");
		LOG.debug("显示文件" + remotePath);
		FTPHelper ftp = new FTPHelper();
		if (remotePath != null)
			ftp.setRemotePath(remotePath);

		try {
			ftp.connect();
			if (remotePath.startsWith("satisfaction")) {
				response.getWriter().write(jsonHelper.write(ftp.listFiles1()));
			} else {
				response.getWriter().write(jsonHelper.write(ftp.listFiles()));
			}

			ftp.disconnect();
		} catch (SocketException e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} catch (IOException e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
	}

	/**
	 * 从ftp服务器上面下载文件
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void downFromFtp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String fileName = request.getParameter("fileName");
		String remotePath = request.getParameter("remotePath");
		// fileName = URLDecoder.decode(fileName, "UTF-8");
		response.reset();
		response.setContentType("octet-stream; charset=UTF-8");
		response.addHeader("Content-Disposition", "attachment;filename=" + URLEncoder.encode(fileName, "utf-8"));
		// response.setContentLength((int) file.length());
		FTPHelper ftp = new FTPHelper();
		if (remotePath != null)
			ftp.setRemotePath(remotePath);
		OutputStream out = null;
		try {
			ftp.connect();
			out = response.getOutputStream();
			ftp.down(out, fileName);
			// response.flushBuffer();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (out != null)
				out.close();
			ftp.disconnect();
		}

	}

	/**
	 * 本地文件下载
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void downFile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String path = request.getParameter("path");
		String fileName = request.getParameter("fileName");
		// fileName = URLDecoder.decode(fileName, "UTF-8");
		File file = new File(path + "/" + fileName);

		try {
			outFile(response, file);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	@ActionMethod(isLog = false)
	public static void outFile(HttpServletResponse response, File file) throws IOException {
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

	/**
	 * 生成单个sheet或者单个csv的方法
	 * 
	 * @param target
	 *            :输入是list(excel sheet使用)或者是bufferedWriter(csv文件使用)
	 * @param sql
	 *            ： 取数的SQL语句
	 * @param header
	 *            ： 表头 Map<dataIndex , [nameList(包含#rspan,#cspan)]>
	 * @param isExcel
	 *            : 是否是excel
	 * @param conn
	 *            ： 数据库连接
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void genResult(Object target, String sql, Map header, boolean isExcel, Connection conn) {
		int headRows = 1;
		// boolean headNameisArray=false;//name字段是String还是List
		Iterator iterator = header.entrySet().iterator();
		if (iterator.hasNext()) {
			Map.Entry entry = (Map.Entry) iterator.next();
			Object obj = entry.getValue();

			if (obj instanceof List) {
				headRows = ((ArrayList) obj).size();
			}
		}

		List result = null;
		BufferedWriter bw = null;

		if (isExcel) {
			result = (List) target;
		} else {
			bw = (BufferedWriter) target;
		}
		Statement stat = null;
		ResultSet rs = null;
		try {

			stat = conn.createStatement();
			rs = stat.executeQuery(sql);

			ResultSetMetaData rsmd = rs.getMetaData();
			List columnNames = new ArrayList();// 记录列的别名索引，避免数据库取的字段多余header的值会报错
			int size = rsmd.getColumnCount();
			String[] line = null;
			for (int j = 0; j < headRows; j++) {
				if (isExcel) {
					line = new String[size];
				}

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
						if (isExcel) {
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

						if (isExcel) {
							line[i] = (String) list.get(j);
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
				if (isExcel) {
					result.add(line);
				} else {
					bw.write("\r\n");
				}
			}

			while (rs.next()) {
				if (isExcel) {
					line = new String[size];
				}
				for (int j = 0; j < columnNames.size(); j++) {
					String value = rs.getString((String) columnNames.get(j));
					value = (value == null ? "" : value);
					if (isExcel) {
						line[j] = value;
					} else {
						bw.write(value);
						bw.write(",");
					}
				}
				if (isExcel) {
					result.add(line);
				} else {
					bw.write("\r\n");
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(sql, e);
		} finally {

			try {
				if (rs != null)
					rs.close();
				if (stat != null)
					stat.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
	}

	/**
	 * 通过
	 * 
	 * @param process
	 * @param sql
	 * @param fileName
	 * @param map
	 * @param ds
	 * @param isExcel
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	@ActionMethod(isLog = false)
	public static void genFile(FilePorcess process, String sql, String fileName, Map header, String ds, boolean isExcel) throws ServletException, IOException {

		String path = System.getProperty("user.dir") + "/";
		File tempFile = null;
		Object target = null;
		if (isExcel) {
			tempFile = new File(path + fileName + ".xls");
			target = new ArrayList();
		} else {
			tempFile = new File(path + fileName + ".csv");
			target = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(tempFile), "gbk"), 512 * 1024);
		}

		if ("web".equalsIgnoreCase(ds))
			ds = "jdbc/AiomniDB";
		else if ("am".equalsIgnoreCase(ds))
			ds = "jdbc/JDBC_AM";
		else if ("nl".equalsIgnoreCase(ds))
			ds = "jdbc/JDBC_NL";
		else
			ds = "jdbc/JDBC_HB";

		Connection conn = ConnectionManage.getInstance().getConnection(ds);

		try {

			genResult(target, sql, header, isExcel, conn);

			if (isExcel) {
				ExcelWriter writer = new ExcelWriter();
				writer.createBook(tempFile);
				writer.writerSheet((List) target, fileName);
				writer.closeBook();
			} else {
				((BufferedWriter) target).flush();
				((BufferedWriter) target).close();
			}

			process.process(tempFile);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
			if (tempFile != null) {
				LOG.debug("删除文件" + tempFile.getAbsolutePath());
				tempFile.delete();
			}
		}
	}

	/**
	 * 上传文件到本地，使用完成后清理文件
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void upload(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		FileHttpServletRequest wrapperRequest = FileHttpServletRequestHandler.parse(request);
		LOG.debug(wrapperRequest.getParameter("abc"));
		response.getWriter().print(wrapperRequest.getParameter("abc"));
		wrapperRequest.clearFiles();
	}

	/**
	 * 删除FTP服务器的文件
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void delFromFtp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String fileName = request.getParameter("fileName");
		String remotePath = request.getParameter("remotePath");
		// fileName = URLDecoder.decode(fileName, "UTF-8");
		String resMsg = "删除成功";
		FTPHelper ftp = new FTPHelper();
		if (remotePath != null)
			ftp.setRemotePath(remotePath);
		try {
			ftp.connect();
			ftp.delete(fileName);

		} catch (IOException e) {
			resMsg = "删除失败，" + e.getMessage();
			e.printStackTrace();
		} finally {
			ftp.disconnect();
		}
		response.getWriter().print(resMsg);
	}

	/**
	 * 导入Excel文件，使用preparedStatement导入；导入的数据可以通过时间字段来标识
	 * 
	 * fileName : excel 的名称 sheetName : sheet的名称 tableName：表名 ds ： 那个数据库
	 * 
	 * columns ： 字段的序列，第一个必须是时间字段 date ： 导入的所有数据的时间周期
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void importExcel(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		FileHttpServletRequest wrapperRequest = FileHttpServletRequestHandler.parse(request);
		Map map = wrapperRequest.getFileParameterMap();
		LOG.info("FileMap.size" + map.size());

		if (map.size() == 1) {
			String fileName = "";
			for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();
				fileName = (String) ((List) entry.getValue()).get(0);
			}

			String ds = wrapperRequest.getParameter("ds");
			String sheetName = wrapperRequest.getParameter("sheetName");
			String tableName = wrapperRequest.getParameter("tableName");
			String columns = wrapperRequest.getParameter("columns");// 第一个为时间周期字段
			String date = wrapperRequest.getParameter("date");

			LOG.info("ds:" + ds + " sheetName:" + sheetName + " tableName:" + tableName + " columns:" + columns + " date:" + date);

			if (columns.startsWith(",")) {
				columns = columns.substring(1);
			}
			if (columns.endsWith(",")) {
				columns = columns.substring(0, columns.length() - 1);
			}
			ExcelReader reader = null;
			Connection conn = null;
			try {

//				if ("web".equalsIgnoreCase(ds)) {
//					conn = ConnectionManage.getInstance().getWEBConnection();
//				} else {
//					conn = ConnectionManage.getInstance().getDWConnection();
//				}
				if ("web".equalsIgnoreCase(ds))
					ds = "jdbc/AiomniDB";
				else if ("am".equalsIgnoreCase(ds))
					ds = "jdbc/JDBC_AM";
				else if ("nl".equalsIgnoreCase(ds))
					ds = "jdbc/JDBC_NL";
				else
					ds = "jdbc/JDBC_HB";

				conn = ConnectionManage.getInstance().getConnection(ds);
				conn.setAutoCommit(false);

				// 得到字段的元数据
				String sql = "select " + columns + " from " + tableName + " fetch first 1 rows only with ur";
				LOG.info("SQL" + sql);
				Statement stat = conn.createStatement();

				ResultSet rs = stat.executeQuery(sql);

				ResultSetMetaData rsmd = rs.getMetaData();

				String[] colMapping = columns.split(",");

				int[] colTypes = new int[colMapping.length - 1];// 第一个时间字段省略
				int type = rsmd.getColumnType(1);// 判断时间字段
				for (int i = 1; i <= colTypes.length; i++) {
					colTypes[i - 1] = rsmd.getColumnType(i + 1);
				}

				rs.close();

				StringBuffer sb = new StringBuffer("delete from ");
				sb.append(tableName).append(" where ").append(colMapping[0]).append("=");
				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("'");
				}
				sb.append(date);

				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("'");
				}
				stat.execute(sb.toString());

				LOG.warn("删除的SQL：" + sb.toString() + ",影响的条数：" + stat.getUpdateCount());

				stat.close();

				// 导入数据
				sb = new StringBuffer("insert into ");
				sb.append(tableName).append("(").append(columns).append(") values(");

				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("'");
				}
				sb.append(date);

				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("'");
				}

				for (int i = 0; i < colTypes.length; i++) {
					sb.append(",?");
				}
				sb.append(")");

				reader = new ExcelReader();
				reader.openWorkbook(fileName);

				List datas = reader.sheetDataList(sheetName);

				PreparedStatement ps = conn.prepareStatement(sb.toString());
				LOG.info("执行SQL=" + sb.toString() + " 总行数:" + datas.size());
				int succCnt = 0;// 成功行数
				int failCnt = 0;// 失败的行数

				for (int i = 0; i < datas.size(); i++) {
					String[] lines = (String[]) datas.get(i);
					boolean isPass = false;
					int max = lines.length;
					for (int j = 0; j < colTypes.length; j++) {
						type = colTypes[j];
						if(j+1 > max){
							ps.setNull(j+1, type);
						}else{
							if (Types.INTEGER == type || Types.SMALLINT == type || Types.BIGINT == type) {
								
								if (lines[j].matches("[+|-]?[0-9]+") || lines[j].length() == 0) {
									String str = lines[j];
									if (str.length() == 0) {
										str = "0";
									}
									
									if (Types.BIGINT == type) {
										ps.setLong(j + 1, Long.parseLong(str));
									} else {
										ps.setInt(j + 1, Integer.parseInt(str));
									}
								} else {
									isPass = true;
									LOG.warn("第" + i + "行,第" + j + "列验证整数不通过，该行略过," + lines[j]);
									break;
								}
								
							} else if (Types.DECIMAL == type || Types.FLOAT == type || Types.DOUBLE == type) {
								
								if (lines[j].matches("[+|-]?[0-9]+(\\.[0-9]+)?") || lines[j].length() == 0) {
									
									String str = lines[j];
									if (str.length() == 0) {
										str = "0";
									}
									
									ps.setDouble(j + 1, Double.parseDouble(str));
								} else {
									isPass = true;
									LOG.warn("第" + i + "行,第" + j + "列验证浮点数不通过，该行略过" + lines[j]);
									break;
								}
								
							} else {
								ps.setString(j + 1, lines[j]);
							}
						}
					}
					if (isPass) {
						failCnt++;
						continue;
					}
					try {
						ps.execute();//是否需要逐条提交
						succCnt++;
					} catch (Exception e) {
						LOG.error("第" + i + "行更新不成功", e);
						failCnt++;
					}
				}
				System.out.println("更新数据条数：" + ps.getUpdateCount());
				ps.close();
				conn.commit();
				response.getWriter().print("导入成功：" + succCnt + "条,失败：" + failCnt + "条");

			} catch (SQLException e) {
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				LOG.error(e.getMessage(), e);
				e.printStackTrace();

			} catch (Exception e) {// added by higherzl
				e.printStackTrace();
				LOG.error(e.getMessage(), e);
			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
				if (reader != null)
					reader.closeWorkbook();
				wrapperRequest.clearFiles();
			}
		}

	}
	
	/**
	 * 导入Excel文件，使用preparedStatement导入；导入的数据可以通过时间字段来标识
	 * 
	 * fileName : excel 的名称 sheetName : sheet的名称 tableName：表名 ds ： 那个数据库
	 * 
	 * columns ： 字段的序列，第一个必须是时间字段 date ： 导入的所有数据的时间周期
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void importExcelForSubject(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		FileHttpServletRequest wrapperRequest = FileHttpServletRequestHandler.parse(request);
		Map map = wrapperRequest.getFileParameterMap();
		LOG.info("FileMap.size" + map.size());

		if (map.size() == 1) {
			String fileName = "";
			for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();
				fileName = (String) ((List) entry.getValue()).get(0);
			}

			String ds = wrapperRequest.getParameter("ds");
			String sheetName = wrapperRequest.getParameter("sheetName");
			String tableName = wrapperRequest.getParameter("tableName");
			String columns = wrapperRequest.getParameter("columns");// 第一个为时间周期字段
			String date = wrapperRequest.getParameter("date");
			String subjectId =  wrapperRequest.getParameter("subjectId");
//			if(!"".equals(date) && date!=null){
//				if(date.indexOf("#")>-1){
//					String[] str = date.split("#");
//					date = str[0];
//					subjectId = str[1];
//				}
//			}

			LOG.info("ds:" + ds + " sheetName:" + sheetName + " tableName:" + tableName + " columns:" + columns + " date:" + date + " subjectId:" + subjectId);

			if (columns.startsWith(",")) {
				columns = columns.substring(1);
			}
			if (columns.endsWith(",")) {
				columns = columns.substring(0, columns.length() - 1);
			}
			ExcelReader reader = null;
			Connection conn = null;
			try {

//				if ("web".equalsIgnoreCase(ds)) {
//					conn = ConnectionManage.getInstance().getWEBConnection();
//				} else {
//					conn = ConnectionManage.getInstance().getDWConnection();
//				}
				if ("web".equalsIgnoreCase(ds))
					ds = "jdbc/AiomniDB";
				else if ("am".equalsIgnoreCase(ds))
					ds = "jdbc/JDBC_AM";
				else if ("nl".equalsIgnoreCase(ds))
					ds = "jdbc/JDBC_NL";
				else
					ds = "jdbc/JDBC_HB";

				conn = ConnectionManage.getInstance().getConnection(ds);

				// 得到字段的元数据
				String sql = "select " + columns + " from " + tableName + " fetch first 1 rows only with ur";
				LOG.info("SQL" + sql);
				Statement stat = conn.createStatement();

				ResultSet rs = stat.executeQuery(sql);

				ResultSetMetaData rsmd = rs.getMetaData();

				String[] colMapping = columns.split(",");

				int[] colTypes = new int[colMapping.length - 2];// 第一个时间字段省略
				int type = rsmd.getColumnType(1);// 判断时间字段
				for (int i = 1; i <= colTypes.length; i++) {
					colTypes[i - 1] = rsmd.getColumnType(i + 1);
				}

				rs.close();

				StringBuffer sb = new StringBuffer("delete from ");
				sb.append(tableName).append(" where ").append(colMapping[0]).append("=");
				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("'");
				}
				sb.append(date);
				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("' and ");
				}
				
				sb.append(colMapping[1]).append("=");
				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("'");
				}
				sb.append(subjectId);

				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("'");
				}
				stat.execute(sb.toString());

				LOG.warn("删除的SQL：" + sb.toString() + ",影响的条数：" + stat.getUpdateCount());

				stat.close();

				// 导入数据
				sb = new StringBuffer("insert into ");
				sb.append(tableName).append("(").append(columns).append(") values(");

				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("'");
				}
				sb.append(date);

				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("'");
				}
				
				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append(",'");
				}
				sb.append(subjectId);
				
				if (Types.VARCHAR == type || Types.CHAR == type) {
					sb.append("'");
				}

				for (int i = 0; i < colTypes.length; i++) {
					sb.append(",?");
				}
				sb.append(")");

				reader = new ExcelReader();
				reader.openWorkbook(fileName);

				List datas = reader.sheetDataList(sheetName);

				PreparedStatement ps = conn.prepareStatement(sb.toString());
				LOG.info("执行SQL=" + sb.toString() + " 总行数:" + datas.size());
				int succCnt = 0;// 成功行数
				int failCnt = 0;// 失败的行数

				for (int i = 0; i < datas.size(); i++) {
					String[] lines = (String[]) datas.get(i);
					boolean isPass = false;
					for (int j = 0; j < colTypes.length; j++) {
						type = colTypes[j];

						if (Types.INTEGER == type || Types.SMALLINT == type || Types.BIGINT == type) {

							if (lines[j].matches("[+|-]?[0-9]+") || lines[j].length() == 0) {
								String str = lines[j];
								if (str.length() == 0) {
									str = "0";
								}

								if (Types.BIGINT == type) {
									ps.setLong(j + 1, Long.parseLong(str));
								} else {
									ps.setInt(j + 1, Integer.parseInt(str));
								}
							} else {
								isPass = true;
								LOG.warn("第" + i + "行,第" + j + "列验证整数不通过，该行略过," + lines[j]);
								break;
							}

						} else if (Types.DECIMAL == type || Types.FLOAT == type || Types.DOUBLE == type) {

							if (lines[j].matches("[+|-]?[0-9]+(\\.[0-9]+)?") || lines[j].length() == 0) {

								String str = lines[j];
								if (str.length() == 0) {
									str = "0";
								}

								ps.setDouble(j + 1, Double.parseDouble(str));
							} else {
								isPass = true;
								LOG.warn("第" + i + "行,第" + j + "列验证浮点数不通过，该行略过" + lines[j]);
								break;
							}

						} else {
							ps.setString(j + 1, lines[j]);
						}
					}
					if (isPass) {
						failCnt++;
						continue;
					}
					try {
						ps.execute();//  是否需要逐条提交
						succCnt++;
					} catch (Exception e) {
						LOG.error("第" + i + "行更新不成功", e);
						failCnt++;
					}
				}
				ps.close();
				conn.commit();
				response.getWriter().print("导入成功：" + succCnt + "条,失败：" + failCnt + "条");

			} catch (SQLException e) {
				try {
					conn.rollback();
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				LOG.error(e.getMessage(), e);
				e.printStackTrace();

			} catch (Exception e) {// added by higherzl
				e.printStackTrace();
				LOG.error(e.getMessage(), e);
			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
				if (reader != null)
					reader.closeWorkbook();
				wrapperRequest.clearFiles();
			}
		}

	}

	@ActionMethod(isLog = false)
	public void getInfoHandler(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.getWriter().println(request.getSession().getAttribute("FileUpload.Progress." + request.getParameter("sessionId").toString().trim()));
	}

	@ActionMethod(isLog = false)
	public void getIdHandler(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String id = request.getSession().getId().toString().trim();
		response.getWriter().println(id);
		request.getSession().setAttribute("FileUpload.Progress." + id, "0");
	}
	/**
	 * @author yulei
	 * @since 2012-09-18
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 * @desc 区域化暂未归属用户提供上传execl文件方法
	 */
	@SuppressWarnings("rawtypes")
	public void importExcelForArea(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		//获取当前时间
		String startTime=DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss");
		//上传文件
		FileHttpServletRequest wrapperRequest = FileHttpServletRequestHandler.parse(request);
		Map map = wrapperRequest.getFileParameterMap();
		LOG.info("FileMap.size" + map.size());
		
		if(map.size()==1){
			String fileName="";
			for(Iterator it=map.entrySet().iterator();it.hasNext();){
				Map.Entry entry = (Map.Entry) it.next();
				fileName = (String) ((List) entry.getValue()).get(0);
			}
			String etl_cycle_id=wrapperRequest.getParameter("etl_cycle_id");
			String ds = wrapperRequest.getParameter("ds");
			String columns=wrapperRequest.getParameter("columns");
			String tableName=wrapperRequest.getParameter("tableName");
			User user=(User)wrapperRequest.getSession().getAttribute("user");
			
			ExcelReader reader = null;
			Connection conn = null;
			
			try{
				if ("web".equalsIgnoreCase(ds))
					ds = "jdbc/AiomniDB";
				else if ("am".equalsIgnoreCase(ds))
					ds = "jdbc/JDBC_AM";
				else if ("nl".equalsIgnoreCase(ds))
					ds = "jdbc/JDBC_NL";
				else
					ds = "jdbc/JDBC_HB";

				conn = ConnectionManage.getInstance().getConnection(ds);
				
				conn.setAutoCommit(false);
				//获取表字段类型start
				Statement st=conn.createStatement();
				
				ResultSet rs=st.executeQuery("select "+columns+" from "+tableName+" fetch first 1 rows only with ur");
				
				ResultSetMetaData rsmd = rs.getMetaData();
				
				String[] colMapping = columns.split(",");
				
				int[] colTypes=new int[colMapping.length];
				
				for(int k=0;k<colTypes.length;k++){
					colTypes[k]=rsmd.getColumnType(k+1);
				}
				
				rs.close();
				//获取表字段类型end
				
				//导入数据
				StringBuffer sb=new StringBuffer("insert into ").append(tableName).append("(").append(columns).append(") values(");
		
				for(int i=0;i<colTypes.length;i++){
					sb.append("?,");
				}
				sb=new StringBuffer(sb.toString().substring(0,sb.length()-1)+")");
				
				
				PreparedStatement pst=conn.prepareStatement(sb.toString());
				reader=new ExcelReader();
				reader.openWorkbook(fileName);
				
				List datas=reader.sheetDataList(null);
				
//				int succCnt=0;
				int failCnt=0;
				
				//判断第一行如果为标识(汉字)则删除，避免报错
				if(((String[])datas.get(0))[0].getBytes().length!=((String[])datas.get(0))[0].length()){
					datas.remove(0);
				}
				
				
				for(int i=0;i<datas.size();i++){
					String[] row=(String[])datas.get(i);
					boolean isPass=true;
					for(int j=0;j<row.length;j++){
						if(colTypes[j]==Types.BIGINT||colTypes[j]==Types.SMALLINT||colTypes[j]==Types.INTEGER){
							if(row[j]==null||row[j].equals("")){
								isPass=false;
								break;
							}
							
							if (Types.BIGINT == colTypes[j]) {
								pst.setLong(j + 1, Long.parseLong(row[j]));
							} else {
								pst.setInt(j + 1, Integer.parseInt(row[j]));
							}
						}else if(colTypes[j]==Types.DECIMAL||colTypes[j]==Types.FLOAT||colTypes[j]==Types.DOUBLE){
							if(row[j]==null||row[j].equals("")){
								isPass=false;
								break;
							}
							pst.setDouble(j + 1, Double.parseDouble(row[j]));
						}else{
							if(row[j]==null||"".equals(row[j])){
								isPass=false;
								break;
							}
							pst.setString(j+1, row[j]);
						}
					}
					//如果execl文件中有字段为空，则剔除不做持久操作
					if(isPass){
						pst.setString(5, "1");
						pst.setString(6, etl_cycle_id);
						try{
							pst.execute();
						}catch(SQLException ex){
							LOG.error("row column not enough", ex);
							failCnt++;
							continue;	
						}
					}else{
						failCnt++;
						LOG.warn("execl文件中字段为空");
						continue;
					}
				}			
				pst.close();
				conn.commit();
				
				//校检字段开始
				
				StringBuffer sAreaCode=new StringBuffer("update "+tableName+" set succ_flag='0' " +
						"where area_code not in (select distinct(area_code) from nwh.dim_bureau_cfg where zone_code like '%888%')"+
						"and etl_cycle_id ="+etl_cycle_id+" and succ_flag='1' ");
				StringBuffer sCountyCode=new StringBuffer("update "+tableName+" set succ_flag='0' " +
						"where county_code not in (select county_code from nwh.dim_bureau_cfg where zone_code like '%888%') " +
						"and etl_cycle_id ="+etl_cycle_id+" and succ_flag='1' ");
				StringBuffer sMbUser_id=new StringBuffer("update "+tableName+" set succ_flag='0' "+
						"where mbuser_id not in(select mbuser_id from nmk.mb_accnbr_"+etl_cycle_id.substring(0,6)+
						" where area_code='"+mapAreaCode.get(user.getCityId())+"') "+
						" and etl_cycle_id ="+etl_cycle_id+" and succ_flag='1' and area_code='"+mapAreaCode.get(user.getCityId())+"'");
				
				java.sql.PreparedStatement pVail=conn.prepareStatement(sAreaCode.toString());
				
				failCnt+=pVail.executeUpdate();
				
				failCnt+=pVail.executeUpdate(sCountyCode.toString());
				
				failCnt+=pVail.executeUpdate(sMbUser_id.toString());
				
				pVail.close();
				conn.commit();
				
				
				//记录日志BUREAU_MBUSER_NOBELONG_LOG
				StringBuffer sbf=new StringBuffer("insert into BUREAU_MBUSER_NOBELONG_LOG(ETL_CYCLE_ID,AREA_CODE,START_TIME,END_TIME,COUNT_ALL,COUNT_SUCC,COUNT_FAIL,STAFF_ID) values(?,?,?,?,?,?,?,?)");
				String endTime=DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss");
				PreparedStatement pstm=conn.prepareStatement(sbf.toString());
				
				pstm.setDouble(1, Double.parseDouble(etl_cycle_id));
				pstm.setString(2, user.getRegionId()==null?"":user.getRegionId());
				pstm.setString(3, startTime);
				pstm.setString(4, endTime);
				pstm.setString(5, String.valueOf(datas.size()));
				pstm.setString(6, String.valueOf(datas.size()-failCnt));
				pstm.setString(7, String.valueOf(failCnt));
				pstm.setString(8, user.getId()==null?"":user.getId());
				
				pstm.execute();
				pstm.close();
				conn.commit();
				
			}catch(Exception ex){
				ex.printStackTrace();
				try{
					conn.rollback();
				}catch(SQLException e){
					e.printStackTrace();
				}
			}finally{
				try{
					conn.setAutoCommit(true);
					ConnectionManage.getInstance().releaseConnection(conn);
					if (reader != null)reader.closeWorkbook();
					wrapperRequest.clearFiles();
				}catch(SQLException ex){
					ex.printStackTrace();
				}
			}
		}
	}
	
	/**
	 * 导入csv文件，通过Runtime.exec执行db2 load命令
	 * 效率比jdbc addBatch快很多
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void importForWxcs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		//上传文件
		FileHttpServletRequest wrapperRequest = FileHttpServletRequestHandler.parse(request);
		Map map = wrapperRequest.getFileParameterMap();
		LOG.debug("FileMap.size" + map.size());
		
		//获取参数
		String tableName=wrapperRequest.getParameter("tableName");
		String columns=wrapperRequest.getParameter("columns");

		if(map.size()>0){
			String fileName="";
			for(Iterator it=map.entrySet().iterator();it.hasNext();){
				Map.Entry entry = (Map.Entry) it.next();
				fileName = (String) ((List) entry.getValue()).get(0);
			}
			try{
				execDB2LoadForWxcs(fileName,tableName,columns);
			}catch(Exception ex){
				ex.printStackTrace();
			}
			wrapperRequest.clearFiles();
		}
		
	}
	
	/**
	 * 导入csv文件，通过Runtime.exec执行db2 load命令
	 * 效率比jdbc addBatch快很多
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void importForStock(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		//上传文件
		FileHttpServletRequest wrapperRequest = FileHttpServletRequestHandler.parse(request);
		Map map = wrapperRequest.getFileParameterMap();
		LOG.debug("FileMap.size" + map.size());
		
		//获取参数
		String tableName=wrapperRequest.getParameter("tableName");
		String columns=wrapperRequest.getParameter("columns");

		if(map.size()>0){
			String fileName="";
			for(Iterator it=map.entrySet().iterator();it.hasNext();){
				Map.Entry entry = (Map.Entry) it.next();
				fileName = (String) ((List) entry.getValue()).get(0);
			}
			try{
				execDB2LoadForStock(fileName,tableName,columns);
			}catch(Exception ex){
				ex.printStackTrace();
			}
			wrapperRequest.clearFiles();
		}
		
	}

	/**
	 * 判断当前运行时系统类型window/linux
	 * @return
	 */
	public boolean isWindows(){
		String osName=System.getProperty("os.name");
		
		if(osName.indexOf("Window")>-1){
			return true;
		}
		return false;
	}
	
	/**
	 * 检查输入月份表是否存在
	 * @param request
	 * @param response
	 */
	public void checkForWxcs(HttpServletRequest request, HttpServletResponse response){
		String result="";
		
		String sql=request.getParameter("sql");
		
		String ds=request.getParameter("ds");
		
		Connection conn=null;
		
		PreparedStatement pst=null;
		
		ResultSet rs=null;
		
		
		
		if ("web".equalsIgnoreCase(ds))
			ds = "jdbc/AiomniDB";
		else if ("am".equalsIgnoreCase(ds))
			ds = "jdbc/JDBC_AM";
		else if ("nl".equalsIgnoreCase(ds))
			ds = "jdbc/JDBC_NL";
		else
			ds = "jdbc/JDBC_HB";
		if(sql==null){
			result="-1";
		}else{
			try{
				conn=ConnectionManage.getInstance().getConnection(ds);
				
				pst=conn.prepareStatement(sql);
				
				rs=pst.executeQuery();
				
				if(rs.next()){
					result=rs.getString(1);
				}
				
				pst.close();
				rs.close();
				conn.close();
				
			}catch(SQLException ex){
				result="-1";
				ex.printStackTrace();
			}
		}
		
		PrintWriter out;
		try{
			out = response.getWriter();
			out.print(result);
		}catch(IOException ex){
			ex.printStackTrace();
		}
		
	}
	
	/**
	 * 无线城市ddl语句执行，如果表存在就drop掉再create，如果不存在就create
	 * @param request
	 * @param response
	 */
	@SuppressWarnings("unused")
	public void ddlForWxcs(HttpServletRequest request, HttpServletResponse response){
		String result="";
		
		String sql=request.getParameter("sql");
		
		String[] sqls=sql.split(";");
		
		String ds=request.getParameter("ds");
		
		Connection conn=null;
		
		PreparedStatement pst=null;
		
		
		if ("web".equalsIgnoreCase(ds))
			ds = "jdbc/AiomniDB";
		else if ("am".equalsIgnoreCase(ds))
			ds = "jdbc/JDBC_AM";
		else if ("nl".equalsIgnoreCase(ds))
			ds = "jdbc/JDBC_NL";
		else
			ds = "jdbc/JDBC_HB";
		
		if(sql==null){
			result="-1";
		}else{
			for(int i=0;i<sqls.length;i++){
				try{
					conn=ConnectionManage.getInstance().getConnection(ds);
					
					pst=conn.prepareStatement(sqls[i]);
					
					pst.execute();
					
					pst.close();
					
					conn.close();
					
					result="0";
				}catch(SQLException ex){
					ex.printStackTrace();
					result="-1";
				}
			}
		}
		
		PrintWriter out;
		try{
			out = response.getWriter();
			out.print(result);
		}catch(IOException ex){
			ex.printStackTrace();
		}
	}
	/**
	 * 无线城市核心功能，根据系统不同，执行相应的命令调用load
	 * @param fileName
	 * @param tableName
	 * @param columns
	 * @throws IOException
	 * @throws InterruptedException
	 */
	public void execDB2LoadForWxcs(String fileName,String tableName,String columns) throws IOException,InterruptedException{
		
			StringBuffer batContent=new StringBuffer("");
			
//			String 
			
			//dwdb,dwtestdb
			batContent.append("db2 connect to dwdb user pt using Ptmm221*\r\n");
			batContent.append("db2 \"load client from ").append(fileName).append(" of DEL insert into ")
			.append(tableName).append("(");
			if(columns.indexOf(",")>-1){
				String[] column = columns.split(",");
				for(int i=0;i<column.length;i++){
					if(i==0){
						batContent.append(column[i]);
					}else{
						batContent.append(",").append(column[i]);
					}
				}
			}else{
				batContent.append(columns);
			}
			batContent.append(") ")
			.append("nonrecoverable\"\r\n");
			batContent.append("db2 RUNSTATS ON TABLE ").append(tableName).append("\r\n");
			batContent.append("db2 disconnect all\r\n").append("exit\r\n");
			File file = new File(db2LoadPath+System.currentTimeMillis()+".bat"); // 创建文件
			file.createNewFile();
			java.io.FileWriter fileWriter = new java.io.FileWriter(file);
			fileWriter.write(batContent.toString()); // 写内容
			fileWriter.close();

			if(isWindows()){

				Runtime.getRuntime().exec("db2cmd "+file.getAbsolutePath());

			}else{

				Runtime.getRuntime().exec(new String[]{"/bin/sh","-c","sh "+file.getAbsolutePath()});

			}
			//等待数据导入，不然wrapperRequest.clearFiles();清楚不了文件
			Thread.sleep(1000*10);
			
//			file.delete();
		
	}
	
	/**
	 * 存量客户信息导入
	 * @param fileName
	 * @param tableName
	 * @param columns
	 * @throws IOException
	 * @throws InterruptedException
	 */
	public void execDB2LoadForStock(String fileName,String tableName,String columns) throws IOException,InterruptedException{
		
		StringBuffer batContent=new StringBuffer("");
			
		//dwdb,dwtestdb
		batContent.append("db2 connect to wbdb user pt using Ptmm217*\r\n");
		batContent.append("db2 \"load client from ").append(fileName).append(" of DEL insert into ")
		.append(tableName).append("(");
		if(columns.indexOf(",")>-1){
			String[] column = columns.split(",");
			for(int i=0;i<column.length;i++){
				if(i==0){
					batContent.append(column[i]);
				}else{
					batContent.append(",").append(column[i]);
				}
			}
		}else{
			batContent.append(columns);
		}
		batContent.append(") ")
		.append("nonrecoverable\"\r\n");
		batContent.append("db2 RUNSTATS ON TABLE ").append(tableName).append("\r\n");
		batContent.append("db2 disconnect all\r\n").append("exit\r\n");
		String batFilePath = db2LoadPath+System.currentTimeMillis()+".bat";
		File file = new File(batFilePath); // 创建文件
		file.createNewFile();
		java.io.FileWriter fileWriter = new java.io.FileWriter(file);
		fileWriter.write(batContent.toString()); // 写内容
		fileWriter.close();
		if(isWindows()){
			Runtime.getRuntime().exec("db2cmd "+file.getAbsolutePath());
		}else{
			Runtime.getRuntime().exec(new String[]{"/bin/sh","-c","sh "+file.getAbsolutePath()});
		}
		//等待数据导入，不然wrapperRequest.clearFiles();清楚不了文件
		Thread.sleep(1000*10);
			
//		file.delete();
		LOG.info("导入完成功。");
			
		//验证是否是湖北移动号码，如果不是则删除
		Connection connection = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Statement stat = null;
		Statement stat1 = null;
		Statement stat2 = null;
		connection = ConnectionManage.getInstance().getConnection("jdbc/AiomniDB");
		String sql = "select acc_nbr from nmk.manager_mbuser_tmp with ur";
		LOG.info("查询导入临时表数据");
		try {
			ps = connection.prepareStatement(sql);
			rs = ps.executeQuery();
			stat = connection.createStatement();
			stat1 = connection.createStatement();
			stat2 = connection.createStatement();
			while (rs.next()) {
				String acc_nbr = rs.getString(1);
				boolean flag = isMobileNumber(acc_nbr);
				if(!flag){
					String _sql = "delete from nmk.manager_mbuser_tmp where acc_nbr = '"+acc_nbr+"'";
					stat.execute(_sql);
				}
			}
			LOG.info("删除临时表重复数据");
			//把剩余数据插入正是表中
			String insertSql = "INSERT INTO NMK.MANAGER_MBUSER(TIME_ID,ACC_NBR,MANAGER_ACCNBR) SELECT INT(subStr(TASK_ID,1,6)),ACC_NBR,MANAGER_ACCNBR FROM NMK.MANAGER_MBUSER_TMP";
			stat1.execute(insertSql);
			LOG.info("插入正是表");
			//删除临时表数据
			String deleteSql = "DELETE FROM NMK.MANAGER_MBUSER_TMP";
			LOG.info("删除临时表");
			stat2.execute(deleteSql);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally{
			try {
				if (rs != null)
					rs.close();
				if (stat != null)
					stat.close();
				if (stat1 != null)
					stat1.close();
				if (stat2 != null)
					stat2.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		
	}
	
	//判断是否是湖北移动号码
	public static boolean isMobileNumber(String phone) {
        boolean isExist = false;

        phone = phone.trim();
        if (phone == null || phone.length() < 7) {
            try {
                throw new Exception("wrong phone length");
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        String code = phone.substring(0, 7);// 暂时保留2009-01-16 16:30

        if (code.startsWith("134") || code.startsWith("135")
                || code.startsWith("136") || code.startsWith("137")
                || code.startsWith("138") || code.startsWith("139")
                || code.startsWith("159") || code.startsWith("158")
                || code.startsWith("150") || code.startsWith("157")
                || code.startsWith("151") || code.startsWith("188")
                || code.startsWith("189")) {
            isExist = true;
        }
        return isExist;

    }
	
	/**
	 * TD价格导入
	 * @date 2013-02-04
	 */
	@SuppressWarnings("rawtypes")
	public void importExcelForTD(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		//上传文件
		FileHttpServletRequest wrapperRequest = FileHttpServletRequestHandler.parse(request);
		Map map = wrapperRequest.getFileParameterMap();
		StringBuffer sb=new StringBuffer("db2 connect to dwdb user pt using Ptmm221*\r\n");
		
		if(map.size()==1){
			String fileName="";
			for(Iterator it=map.entrySet().iterator();it.hasNext();){
				Map.Entry entry = (Map.Entry) it.next();
				fileName = (String) ((List) entry.getValue()).get(0);
			}
			String realFile=removeTitle(new File(fileName)).getAbsolutePath();
			String columns=wrapperRequest.getParameter("columns");
			String tableName=wrapperRequest.getParameter("tableName");
			
			sb.append("db2 \"create table "+tableName+" like nmk.TERMINAL_PRICE\"\r\n");
			sb.append("db2 RUNSTATS ON TABLE ").append(tableName).append("\r\n");
			sb.append("db2 \"load client from ").append(realFile).append(" of DEL insert into ")
			.append(tableName).append("(").append(columns).append(") nonrecoverable\"\r\n");
			sb.append("db2 RUNSTATS ON ").append(tableName).append("\r\n");
			sb.append("db2 disconnect all\r\n").append("exit\r\n");
			
			File file = new File(db2LoadPath+System.currentTimeMillis()+".bat"); // 创建文件
			file.createNewFile();
			java.io.FileWriter fileWriter = new java.io.FileWriter(file);
			fileWriter.write(sb.toString()); // 写内容
			fileWriter.close();

			if(isWindows()){

				Runtime.getRuntime().exec("db2cmd "+file.getAbsolutePath());

			}else{

				Runtime.getRuntime().exec(new String[]{"/bin/sh","-c","sh "+file.getAbsolutePath()});

			}
		}
		wrapperRequest.clearFiles();
	}
	
	/**
	 * td价格导入剔除文件中的第一行表头
	 * @param file
	 * @return
	 */
	private File removeTitle(File file){
		String fileName=file.getName().substring(0,file.getName().indexOf("csv")-1)+"_title.csv";
		
		File rtnFile=new File(db2LoadPath+fileName);
		try{
			BufferedReader br=new BufferedReader(new FileReader(file));
			
			FileWriter fw=new FileWriter(rtnFile);
			
			String str=null;
			int i=0;
			while((str=br.readLine())!=null){
				if(i!=0){
					fw.write(str);
					fw.write("\n");
				}
				i++;
			}
			fw.flush();
			
			fw.close();
			br.close();
		}catch(Exception ex){
			LOG.info("td价格导入删除标题失败",ex);
		}
		return rtnFile;
	}
	
	/**
	 * @desc 不强制第一个字段必须是时间字段，根据参数column来插入
	 * @author yulei
	 * @date 2013-06-20
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void importExcelAny(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		FileHttpServletRequest wrapperRequest = FileHttpServletRequestHandler.parse(request);
		Map map = wrapperRequest.getFileParameterMap();
		LOG.info("FileMap.size" + map.size());

		if (map.size() == 1) {
			String fileName = "";
			for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();
				fileName = (String) ((List) entry.getValue()).get(0);
			}

			String ds = wrapperRequest.getParameter("ds");
			String sheetName = wrapperRequest.getParameter("sheetName");
			String tableName = wrapperRequest.getParameter("tableName");
			String columns = wrapperRequest.getParameter("columns");// 第一个为时间周期字段
			String date = wrapperRequest.getParameter("date");

			LOG.info("ds:" + ds + " sheetName:" + sheetName + " tableName:" + tableName + " columns:" + columns + " date:" + date);

			if (columns.startsWith(",")) {
				columns = columns.substring(1);
			}
			if (columns.endsWith(",")) {
				columns = columns.substring(0, columns.length() - 1);
			}
			ExcelReader reader = null;
			Connection conn = null;
			try {

//				if ("web".equalsIgnoreCase(ds)) {
//					conn = ConnectionManage.getInstance().getWEBConnection();
//				} else {
//					conn = ConnectionManage.getInstance().getDWConnection();
//				}
				if ("web".equalsIgnoreCase(ds))
					ds = "jdbc/AiomniDB";
				else if ("am".equalsIgnoreCase(ds))
					ds = "jdbc/JDBC_AM";
				else if ("nl".equalsIgnoreCase(ds))
					ds = "jdbc/JDBC_NL";
				else
					ds = "jdbc/JDBC_HB";

				conn = ConnectionManage.getInstance().getConnection(ds);
				conn.setAutoCommit(false);

				// 得到字段的元数据
				String sql = "select " + columns + " from " + tableName + " fetch first 1 rows only with ur";
				LOG.info("SQL" + sql);
				Statement stat = conn.createStatement();

				ResultSet rs = stat.executeQuery(sql);

				ResultSetMetaData rsmd = rs.getMetaData();

				String[] colMapping = columns.split(",");
				
				int[] colTypes=new int[colMapping.length];
				for (int i = 0; i < colMapping.length; i++) {
					colTypes[i] = rsmd.getColumnType(i+1);
				}

				stat.close();
				rs.close();

				// 导入数据
				StringBuffer sb = new StringBuffer("insert into ");
				sb.append(tableName).append("(").append(columns).append(") values(");

				for (int i = 0; i < colMapping.length; i++) {
					if(i==0){
						sb.append("?");
					}else{
						sb.append(",?");
					}
				}
				sb.append(")");

				reader = new ExcelReader();
				reader.openWorkbook(fileName);

				List datas = reader.sheetDataList(sheetName);

				PreparedStatement ps = conn.prepareStatement(sb.toString());
				LOG.info("执行SQL=" + sb.toString() + " 总行数:" + datas.size());
				int succCnt = 0;// 成功行数
				int failCnt = 0;// 失败的行数

				int type=0;
				for (int i = 0; i < datas.size(); i++) {
					String[] lines = (String[]) datas.get(i);
					boolean isPass = false;
					for (int j = 0; j < colTypes.length; j++) {
						type = colTypes[j];

						if (Types.INTEGER == type || Types.SMALLINT == type || Types.BIGINT == type) {

							if (lines[j].matches("[+|-]?[0-9]+") || lines[j].length() == 0) {
								String str = lines[j];
								if (str.length() == 0) {
									str = "0";
								}

								if (Types.BIGINT == type) {
									ps.setLong(j + 1, Long.parseLong(str));
								} else {
									ps.setInt(j + 1, Integer.parseInt(str));
								}
							} else {
								isPass = true;
								LOG.warn("第" + i + "行,第" + j + "列验证整数不通过，该行略过," + lines[j]);
								break;
							}

						} else if (Types.DECIMAL == type || Types.FLOAT == type || Types.DOUBLE == type) {

							if (lines[j].matches("[+|-]?[0-9]+(\\.[0-9]+)?") || lines[j].length() == 0) {

								String str = lines[j];
								if (str.length() == 0) {
									str = "0";
								}

								ps.setDouble(j + 1, Double.parseDouble(str));
							} else {
								isPass = true;
								LOG.warn("第" + i + "行,第" + j + "列验证浮点数不通过，该行略过" + lines[j]);
								break;
							}

						} else {
							ps.setString(j + 1, lines[j]);
						}
					}
					if (isPass) {
						failCnt++;
						continue;
					}
					try {
						ps.execute();//  是否需要逐条提交
						succCnt++;
					} catch (Exception e) {
						LOG.error("第" + i + "行更新不成功", e);
						failCnt++;
					}
				}
				ps.close();
				conn.commit();
				response.getWriter().print("导入成功：" + succCnt + "条,失败：" + failCnt + "条");

			} catch (SQLException e) {
				try {
					conn.rollback();
					conn.setAutoCommit(true);
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
				LOG.error(e.getMessage(), e);
				e.printStackTrace();

			} catch (Exception e) {// added by higherzl
				e.printStackTrace();
				LOG.error(e.getMessage(), e);
			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
				if (reader != null)
					reader.closeWorkbook();
				wrapperRequest.clearFiles();
			}
		}

	}
}
