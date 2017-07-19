<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="com.asiainfo.hbbass.component.json.JsonHelper"%>
<%@page contentType="text/html; charset=utf-8"%>
<%
User user = (User)session.getAttribute("user");
out.print(JsonHelper.getInstance().write(user));
%>
