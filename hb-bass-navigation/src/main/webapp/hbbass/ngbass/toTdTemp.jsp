<%@page contentType="text/html; charset=gb2312"%>

<%-- 
	��ʱҳ�棬����ʽ����114��ת��59NG����ҳ��
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
 	