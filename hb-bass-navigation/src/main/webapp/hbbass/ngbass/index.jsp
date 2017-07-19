<%@ page contentType="text/html; charset=gb2312"%>
<%
String reportid=request.getParameter("reportid");
String reportname=request.getParameter("reportname");
reportname=new String(reportname.getBytes("ISO-8859-1"),"gb2312");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>湖北移动经营分析系统</title>
</head>
<frameset rows="30,*" id="mainFra" cols="*" frameborder="no" border="0" framespacing="0">
    <frame src="indexTop.jsp?reportid=<%=reportid%>&reportname=<%=reportname%>" name="topFrame" scrolling="no" noresize="noresize" id="topFrame" />
    <frame src="" name="mainFrame" scrolling="no" id="mainFrame" />
</frameset>
</html>
