<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="com.asiainfo.hbbass.ws.common.Constant"%>

<%
	PrintWriter outs = response.getWriter();
	StringBuffer buf = new StringBuffer();
	String passFlag = (String) session.getAttribute("passFlag");
	if (Constant.TRUE.equals(passFlag)) {
		session.setAttribute("filterFlag", Constant.TRUE);
	} else {
		session.setAttribute("filterFlag", Constant.FALSE);
	}
	buf.append("{Info:[{msg:'").append(passFlag).append("'}]}");
	outs.write(buf.toString());
%>