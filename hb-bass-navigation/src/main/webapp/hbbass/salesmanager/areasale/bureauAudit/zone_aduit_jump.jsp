<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%
    String userid = (String)session.getAttribute("loginname");  
    boolean flag = false ;
    String url ="zone_aduit.html" ;
    if (userid.equalsIgnoreCase("meikefu") || userid.equalsIgnoreCase("maowenjun")){
         url += "?EDIT=TRUE" ;
         response.sendRedirect(url);
    }else{
         response.sendRedirect(url);
    }
%>
<script type="text/javascript">
   
</script>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>My JSP 'zone_aduit_jump.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
</head>
<body></body>
</html>



