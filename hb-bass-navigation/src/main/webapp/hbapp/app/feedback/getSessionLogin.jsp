<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page contentType="text/html; charset=utf-8"%>
<%
		String loginname=(String)session.getAttribute("loginname");
		User user  = (User) session.getAttribute("user");
		String city_id = user.getCityId();
		String result = loginname+"&"+city_id;
		out.print(result);
%>