package com.asiainfo.hbbass.common.action;

import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.file.CSVReader;
import com.asiainfo.hbbass.common.file.ExcelReader;
import com.asiainfo.hbbass.common.file.FileHttpServletRequest;
import com.asiainfo.hbbass.common.file.FileHttpServletRequestHandler;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;

/**
 * 
 * @author xie liangsong
 * @date 2012-08-08
 */
@SuppressWarnings({"unused", "rawtypes" })
public class CSVManageAction extends Action {

	private static Logger LOG = Logger.getLogger(CSVManageAction.class);

	private JsonHelper jsonHelper = JsonHelper.getInstance();


	/**
	 * 导入CSV文件，使用preparedStatement导入；导入的数据可以通过时间字段来标识
	 * 
	 * fileName : CSV 的名称 sheetName : sheet的名称 tableName：表名 ds ： 那个数据库
	 * 
	 * columns ： 字段的序列，第一个必须是时间字段 date ： 导入的所有数据的时间周期
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void importCSV(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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

				CSVReader c = new CSVReader(new FileReader(fileName), ',',  '\"', 1); 
				List datas = c.readAll(); 
				
				//reader = new ExcelReader();
				//reader.openWorkbook(fileName);
				//List datas = reader.sheetDataList(sheetName);

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
						ps.execute();// 是否需要逐条提交
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
	
	public void csvLoadFile(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException{
		FileHttpServletRequest wrapperRequest = FileHttpServletRequestHandler.parse(request);
		Map map = wrapperRequest.getFileParameterMap();
		LOG.debug("FileMap.size" + map.size());
		FileManageAction fileManage = new FileManageAction();
		
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
				fileManage.execDB2LoadForWxcs(fileName,tableName,columns);
			}catch(Exception ex){
				ex.printStackTrace();
			}
			wrapperRequest.clearFiles();
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
}
