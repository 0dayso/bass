<%@ page contentType="text/html; charset=utf-8"%>
<%
	response.setCharacterEncoding("UTF-8");
	response.setContentType("text/xml; charset=utf-8");
	String result = (String)request.getAttribute("result");
	out.clear();
	out.write(result);
	out.flush();
%>