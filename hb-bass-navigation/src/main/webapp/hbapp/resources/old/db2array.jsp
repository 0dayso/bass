<%@ page contentType="text/html; charset=utf-8" %>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext"%>
<%@page import="java.util.List"%>
<%
	String sql = request.getParameter("sql");
	sql = new String(sql.getBytes("ISO-8859-1"),"UTF-8");
	//sql = new String(sql.getBytes("ISO-8859-1"),"gb2312");
	System.out.println(sql);
	String ds = request.getParameter("ds");
	if("web".equalsIgnoreCase(ds))ds ="java:comp/env/jdbc/AiomniDB";
	else if("am".equalsIgnoreCase(ds))ds ="java:comp/env/jdbc/JDBC_AM";
	
	SQLQuery sqlQuery = null;
	
	if(ds!=null&&ds.length()>0){
		sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list",ds);
	}else 
		sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");

	List list = (List)sqlQuery.query(sql);
	StringBuffer sb = new StringBuffer("[");
	for(int i = 0; i < list.size(); i++){
		String[] lines = (String[])list.get(i);
		sb.append("[");
		for(int j = 0; j < lines.length; j++){
			sb.append("\"").append(lines[j]).append("\",");
		}
		sb.delete(sb.length()-1, sb.length());
		sb.append("],");
	}
	sb.delete(sb.length()-1, sb.length());
	sb.append("]");
	out.clear();
	out.print(sb.toString());
%>