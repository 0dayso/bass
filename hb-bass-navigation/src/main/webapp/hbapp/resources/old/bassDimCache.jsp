<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimCache"%>
<%
	String name = request.getParameter("name");
	out.clear();
	out.print(BassDimCache.getInstance().getArray(name));
%>