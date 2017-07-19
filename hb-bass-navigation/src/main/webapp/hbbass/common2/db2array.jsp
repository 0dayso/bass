<%@ page contentType="text/html; charset=utf-8" %>
<%@page import = "bass.common.SQLSelect"%>
<%@page import="org.apache.log4j.Logger"%>
<%!private static Logger LOG = Logger.getLogger("db2array"); %>
<%
try{
	String sql = request.getParameter("sql");
	sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8");
	//sql = new String(sql.getBytes("ISO-8859-1"),"gb2312");
	
	String ds = request.getParameter("ds");
	if("web".equalsIgnoreCase(ds))ds ="jdbc/AiomniDB";
	else if("am".equalsIgnoreCase(ds))ds ="jdbc/JDBC_AM";
	LOG.info("ds:"+ds+",sql:"+sql);
	SQLSelect select = ds!=null&&ds.length()>0? new SQLSelect(ds):new SQLSelect();
	
	response.setCharacterEncoding("gbk");
	response.setContentType("text/xml; charset=utf-8");
	String result =select.getCustomFormatResult(sql);
	//LOG.debug(result);
	out.print(result);
}catch(Exception e){
	e.printStackTrace();
	throw e;
}
%>