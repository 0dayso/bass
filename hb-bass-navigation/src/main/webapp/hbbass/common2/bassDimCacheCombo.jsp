<%@ page contentType="text/html; charset=gb2312" %>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimCache"%>
<%
	String tagname = request.getParameter("tagname");
	String name = request.getParameter("name");
	//sql = new String(sql.getBytes("ISO-8859-1"),"gb2312");
	//bass.common.SQLSelect select = new bass.common.SQLSelect();
	response.setCharacterEncoding("gb2312");
	response.setContentType("text/xml; charset=gb2312");
	//out.print(bass.common2.BassDimCache.getCustomFormatResult(tagname,name));
	
	out.print(BassDimCache.getInstance().getCustomFormatResult(tagname,name));
%>