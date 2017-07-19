<%@page contentType="text/html; charset=gb2312"%>

<%-- 
	临时页面，从正式环境114跳转到59NG配置页面
--%>

<%
String remoteIp = "10.25.124.59";
	String port = "";
	try{
	response.sendRedirect("http://" + remoteIp  + port + "/" + "hbbass/ngbass/content.jsp?reportid=" + request.getParameter("reportid"));
	} catch(Exception e) {
	    e.printStackTrace();
	}
%> 
 	