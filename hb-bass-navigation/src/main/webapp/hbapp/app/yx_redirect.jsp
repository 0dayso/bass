<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%
String url = "http://10.25.124.29:8088/jeecms/jeeadmin/jeecms/loginDb2app55.jspx?returnUrl=/jeeadmin/jeecms/index.do&usercode=";
User user = (User)session.getAttribute("user");
String userName = user.getName();
String userId = user.getId();
String cityId = user.getCityId();
String cityName = "省公司";
url +=(userId+"&password=111");

%>
<script>
window.location.href="<%=url%>";
</script>
