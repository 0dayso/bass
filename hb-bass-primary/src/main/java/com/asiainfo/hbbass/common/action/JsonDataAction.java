package com.asiainfo.hbbass.common.action;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.bass.components.models.DesUtil;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.dimension.BassDimCache;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;

/**
 * 
 * @author Mei Kefu
 * @date 2009-9-15
 */
public class JsonDataAction extends Action {

	private static Logger LOG = Logger.getLogger(JsonDataAction.class);

	public void query(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		run(request, response);
	}

	/**
	 *  为了记录日志改用query来命名
	 */
	@ActionMethod(isLog = false)
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		run(request, response);
	}

	/**
	 * 为了不记日志
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@ActionMethod(isLog = false)
	public void run(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sql = request.getParameter("sql");
		String lowerCase = sql.toLowerCase();
		LOG.info("sql1:" +sql);
		if((lowerCase.indexOf("select")<0)&&(lowerCase.indexOf("update")<0)&&(lowerCase.indexOf("insert")<0)&&(lowerCase.indexOf("delete")<0)){
			sql = DesUtil.defaultStrDec(sql);
			LOG.info("sql2:" +sql);
		}

		String result = "";

		if (sql == null || sql.length() == 0) {
			result = "[]";
		} else {

			String queryType = request.getParameter("qType");// 确定是否分页查询，放在一个方法是为了记录日志

			String ds = request.getParameter("ds");

			SQLQuery sqlQuery = SQLQuery.NULL;

			boolean isCached = !"false".equalsIgnoreCase(request.getParameter("isCached"));// 是否缓存，除非制定不缓存，其他的都默认缓存
			if (!isCached)
				LOG.info("没有使用缓存");
			if ("limit".equalsIgnoreCase(queryType)) {
				int limit = 0;
				int start = 1;
				String limitStr = request.getParameter("limit");
				if (limitStr != null && limitStr.matches("[0-9]+")) {
					limit = Integer.parseInt(limitStr);
				}
				String startStr = request.getParameter("start");
				if (startStr != null && startStr.matches("[0-9]+")) {
					start = Integer.parseInt(startStr);
				}

				sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_LIMIT, ds, isCached);
				result = (String) sqlQuery.query(sql, limit, start);

			} else if ("piece".equalsIgnoreCase(queryType)) {
				int rows = 0;
				String rowsStr = request.getParameter("rows");
				if (rowsStr != null && rowsStr.matches("[0-9]+")) {
					rows = Integer.parseInt(rowsStr);
				}
				sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_PIECE, ds, isCached);
				result = (String) sqlQuery.query(sql, rows);
			} else {

				if (sql.trim().length() > 7 && sql.trim().substring(0, 7).equalsIgnoreCase("select ")) {

					sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON, ds, isCached);
					result = (String) sqlQuery.query(sql);
				} else {
					result = BassDimCache.getInstance().getArray(sql);
				}
			}
		}
		//helei 2012-4-12 添加
		response.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		LOG.debug(result);
		out.print(result);
	}

	/**
	 * 支持csv和xls下载使用参数fileKind=excel来判断 下载没用使用缓存，是否需要缓存，如果下载几百M的数据缓存也要挂掉
	 * 下载是先生成临时文件，然后下载文件，最后删除文件 支持复合表头的判断，但是在excel下载中没有合并，下次重构excel的复合表头合并问题
	 * 
	 * @param request参数
	 *            ：sql header fileName ds(可选) fileKind(可选)
	 * 
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void down(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String sql = request.getParameter("sql");
		String lowerCase = sql.toLowerCase();
		LOG.info("sql1:" +sql);
		if((lowerCase.indexOf("select")<0)&&(lowerCase.indexOf("update")<0)&&(lowerCase.indexOf("insert")<0)&&(lowerCase.indexOf("delete")<0)){
			sql = DesUtil.defaultStrDec(sql);
			LOG.info("sql2:" +sql);
		}
		String headerStr = request.getParameter("header");
		// header = URLDecoder.decode(header, "UTF-8");
		// sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8");
		// sql = new String(sql.getBytes("ISO-8859-1"),"gb2312");

		LOG.debug(sql);

		String fileName = request.getParameter("fileName");
		// fileName=URLEncoder.encode(fileName,"UTF-8");
		// response.addHeader("Content-Disposition","attachment; filename="+fileName+".csv");

		JsonHelper jsonHelper = JsonHelper.getInstance();
		/**
		 * key:dataIndex,value:name {dataIndex:name, }
		 * 
		 * 先把header 转成全大写
		 */
		System.out.println(jsonHelper);
		System.out.println(headerStr);
		Map header = (Map) jsonHelper.read(headerStr.toUpperCase());
		if(header==null) header = new HashMap();
		String ds = request.getParameter("ds");
		boolean isExcel = "excel".equalsIgnoreCase(request.getParameter("fileKind"));

		FileManageAction.FilePorcess process = new FileManageAction.FilePorcess() {

			HttpServletResponse response;

			public void setObject(Object object) {
				this.response = (HttpServletResponse) object;
			}

			public void process(File file) {
				try {
					FileManageAction.outFile(response, file);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		};
		process.setObject(response);

		FileManageAction.genFile(process, sql, fileName, header, ds, isExcel);

		/*
		 * String sql = request.getParameter("sql"); String header =
		 * request.getParameter("header"); //header = URLDecoder.decode(header,
		 * "UTF-8"); //sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8");
		 * //sql = new String(sql.getBytes("ISO-8859-1"),"gb2312");
		 * 
		 * LOG.debug(sql);
		 * 
		 * String fileName=request.getParameter("fileName");
		 * //fileName=URLEncoder.encode(fileName,"UTF-8");
		 * //response.addHeader("Content-Disposition"
		 * ,"attachment; filename="+fileName+".csv");
		 * 
		 * JsonHelper jsonHelper = JsonHelper.getInstance();
		 */
		/**
		 * key:dataIndex,value:name {dataIndex:name, }
		 * 
		 * 先把header 转成全大写
		 */
		/*
		 * Map map = (Map)jsonHelper.read(header.toUpperCase()); int headRows=1;
		 * boolean headNameisArray=false;//name字段是String还是List Iterator iterator
		 * = map.entrySet().iterator(); if ( iterator.hasNext()) { Map.Entry
		 * entry = (Map.Entry) iterator.next(); Object obj = entry.getValue();
		 * 
		 * if(obj instanceof ArrayList){ headNameisArray=true;
		 * headRows=((ArrayList)obj).size(); } }
		 * 
		 * boolean
		 * isExcel="excel".equalsIgnoreCase(request.getParameter("fileKind"));
		 * 
		 * String path = System.getProperty("user.dir")+"/"; File tempFile =
		 * null; List result = null; BufferedWriter bw = null; if(isExcel){
		 * tempFile = new File(path+fileName+".xls"); result = new ArrayList();
		 * }else{ tempFile = new File(path+fileName+".csv"); bw = new
		 * BufferedWriter(new OutputStreamWriter(new
		 * FileOutputStream(tempFile),"gbk"),512*1024); }
		 * 
		 * String ds = request.getParameter("ds");
		 * if("web".equalsIgnoreCase(ds))ds ="jdbc/AiomniDB"; else
		 * if("am".equalsIgnoreCase(ds))ds ="jdbc/JDBC_AM"; else ds =
		 * "jdbc/JDBC_HB";
		 * 
		 * Connection conn = ConnectionManage.getInstance().getConnection(ds);
		 * 
		 * try {
		 * 
		 * Statement stat = conn.createStatement(); ResultSet rs =
		 * stat.executeQuery(sql);
		 * 
		 * ResultSetMetaData rsmd = rs.getMetaData();
		 * 
		 * int size = rsmd.getColumnCount(); String[] line = null; for (int j =
		 * 0; j < headRows; j++) { if(isExcel){ line = new String[size]; }
		 * 
		 * for (int i = 0; i < size; i++) {
		 * 
		 * String columnName=rsmd.getColumnName(i + 1);
		 * 
		 * if(headRows==1){ String value = ""; Object obj= map.get(columnName);
		 * if(obj!=null){ if(headNameisArray){ value=(String)((List)obj).get(0);
		 * }else{ value = (String)obj; } }else{ value=columnName; }
		 * value=(value==null?"":value); if(isExcel){ line[i]=value; }else{
		 * bw.write(value); bw.write(","); }
		 * 
		 * }else{ List list =(List)map.get(columnName); if(isExcel){
		 * line[i]=(String)list.get(j); }else{ bw.write((String)list.get(j));
		 * bw.write(","); } } } if(isExcel){ result.add(line); }else{
		 * bw.write("\r\n"); } }
		 * 
		 * while(rs.next()){ if(isExcel){ line = new String[size]; } for( int j
		 * = 0; j < size; j++ ){ String value=rs.getString(j + 1);
		 * value=(value==null?"":value); if(isExcel){ line[j]=value; }else{
		 * bw.write(value); bw.write(","); } } if(isExcel){ result.add(line);
		 * }else{ bw.write("\r\n"); } }
		 * 
		 * rs.close(); stat.close();
		 * 
		 * if(isExcel){ ExcelWriter writer = new ExcelWriter();
		 * writer.createBook(tempFile); writer.writerSheet(result, fileName);
		 * writer.closeBook(); }else{ bw.flush(); bw.close(); }
		 * 
		 * FileManageAction.outFile(response, tempFile);
		 * 
		 * } catch (Exception e) { e.printStackTrace(); }finally{
		 * ConnectionManage.getInstance().releaseConnection(conn);
		 * if(tempFile!=null){ LOG.debug("删除文件"+tempFile.getAbsolutePath());
		 * tempFile.delete(); } }
		 */
	}

	/**
	 * 下载方法没用先下载成文件的形式 下载没用使用缓存 复合表头和多行下载的问题没有解决
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	/*
	 * public void down(HttpServletRequest request, HttpServletResponse
	 * response) throws ServletException, IOException { String sql =
	 * request.getParameter("sql"); String header =
	 * request.getParameter("header"); //header = URLDecoder.decode(header,
	 * "UTF-8"); //sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8"); //sql =
	 * new String(sql.getBytes("ISO-8859-1"),"gb2312");
	 * 
	 * LOG.debug(sql);
	 * 
	 * String fileName=request.getParameter("fileName");
	 * fileName=URLEncoder.encode(fileName,"UTF-8"); PrintWriter out =
	 * response.getWriter();
	 * response.addHeader("Content-Disposition","attachment; filename="
	 * +fileName+".csv");
	 * 
	 * JsonHelper jsonHelper = JsonHelper.getInstance();
	 * 
	 * //key:dataIndex,value:name {dataIndex:name, }
	 * 
	 * //先把header 转成全大写
	 * 
	 * Map map = (Map)jsonHelper.read(header.toUpperCase());
	 * 
	 * String ds = request.getParameter("ds"); if("web".equalsIgnoreCase(ds))ds
	 * ="jdbc/AiomniDB"; else if("am".equalsIgnoreCase(ds))ds ="jdbc/JDBC_AM";
	 * else ds = "jdbc/JDBC_HB";
	 * 
	 * Connection conn = ConnectionManage.getInstance().getConnection(ds);
	 * 
	 * StringBuilder buffer = new StringBuilder();
	 * 
	 * try { Statement stat = conn.createStatement(); ResultSet rs =
	 * stat.executeQuery(sql);
	 * 
	 * ResultSetMetaData rsmd = rs.getMetaData();
	 * 
	 * int size = rsmd.getColumnCount();
	 * 
	 * for (int i = 0; i < size; i++) { if(buffer.length()>0){
	 * buffer.append(","); } String columnName=rsmd.getColumnName(i + 1);
	 * buffer.append(map.get(columnName)); }
	 * 
	 * out.println(buffer.toString()); buffer.delete(0,buffer.length());
	 * 
	 * while(rs.next()){
	 * 
	 * for( int j = 0; j < size; j++ ){ String cell=rs.getString(j + 1);
	 * buffer.append(cell==null?"":cell).append(","); }
	 * out.println(buffer.toString());
	 * 
	 * buffer.delete(0,buffer.length()); } rs.close(); stat.close();
	 * 
	 * } catch (Exception e) { e.printStackTrace(); }finally{
	 * ConnectionManage.getInstance().releaseConnection(conn); }
	 * 
	 * //response.flushBuffer();
	 * 
	 * }
	 */
	/**
	 * 下载excel文件 更down很多重复，下次重构，而且
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	/*
	 * public void downXls(HttpServletRequest request, HttpServletResponse
	 * response)throws ServletException, IOException { String sql =
	 * request.getParameter("sql"); String header =
	 * request.getParameter("header"); LOG.debug(sql);
	 * 
	 * String fileName=request.getParameter("fileName");
	 * response.addHeader("Content-Disposition"
	 * ,"attachment; filename="+URLEncoder.encode(fileName,"UTF-8")+".xls");
	 * 
	 * JsonHelper jsonHelper = JsonHelper.getInstance();
	 * 
	 * Map map = (Map)jsonHelper.read(header.toUpperCase());
	 * 
	 * String ds = request.getParameter("ds"); if("web".equalsIgnoreCase(ds))ds
	 * ="jdbc/AiomniDB"; else if("am".equalsIgnoreCase(ds))ds ="jdbc/JDBC_AM";
	 * else ds = "jdbc/JDBC_HB";
	 * 
	 * Connection conn = ConnectionManage.getInstance().getConnection(ds); List
	 * result = new ArrayList(); try { Statement stat = conn.createStatement();
	 * ResultSet rs = stat.executeQuery(sql);
	 * 
	 * ResultSetMetaData rsmd = rs.getMetaData();
	 * 
	 * int size = rsmd.getColumnCount(); String[] line = new String[size]; for
	 * (int i = 0; i < size; i++) { String columnName=rsmd.getColumnName(i + 1);
	 * line[i]=(String)map.get(columnName); } result.add(line);
	 * 
	 * while(rs.next()){ line = new String[size]; for( int j = 0; j < size; j++
	 * ){ String cell=rs.getString(j + 1); line[j]=cell==null?"":cell; }
	 * result.add(line); } rs.close(); stat.close(); ExcelWriter writer = new
	 * ExcelWriter(); writer.createBook(response.getOutputStream());
	 * writer.writerSheet(result, fileName); writer.closeBook();
	 * 
	 * } catch (Exception e) { e.printStackTrace(); }finally{
	 * ConnectionManage.getInstance().releaseConnection(conn); }
	 * 
	 * 
	 * 
	 * }
	 */
	public static void main(String[] args) {
	}
}
