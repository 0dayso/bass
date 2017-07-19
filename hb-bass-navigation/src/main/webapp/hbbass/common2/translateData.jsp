<%@ page contentType="text/html; charset=utf-8"%>
<%
	response.setCharacterEncoding("GBK");
	response.setContentType("text/xml; charset=utf-8");
	String result = (String)request.getAttribute("result");
	out.clear();
	out.write(result);
	out.flush();
%>