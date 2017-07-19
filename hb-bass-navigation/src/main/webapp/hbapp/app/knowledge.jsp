<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.asiainfo.hb.web.models.User"%>
<%
	User user = (User)session.getAttribute("user");
	String staffCode = user.getId();
	String url = "http://10.25.124.29:8088/jeecms/jeeadmin/jeecms/loginDb2app55.jspx?returnUrl=/jeeadmin/jeecms/index.do&usercode="+staffCode+"&password=111";
	response.sendRedirect(url);
%>