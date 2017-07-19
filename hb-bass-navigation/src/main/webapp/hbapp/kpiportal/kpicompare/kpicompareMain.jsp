<%@ page contentType="text/html; charset=utf-8"%>
<%
String appName=request.getParameter("appName");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>KPI比较分析</title>
<script type="text/javascript">
var a = window.location+"";
a = a.substring(a.indexOf("?")+1,a.length);
var param = a.split("&");
var appName=param[0].split("=")[1];
var compareZbcode=param[1].split("=")[1];
var compareDate=param[2].split("=")[1];
var compareZbname=param[3].split("=")[1];
var compareArea=param[4].split("=")[1];
var comparePercent=param[5].split("=")[1];
</script>
</head>
<frameset rows="*" cols="200,5,*" id="exFra" name="exFra" frameborder="no" border="0" framespacing="0">
    <frame id="leftFra" src="kpicompare_left.jsp?appName=<%=appName %>" name="exLeftFrame" scrolling="auto" noresize="noresize" id="exLeftFrame" />
    <frame src="kpicompare_scroll.htm" name="exScrollFrame" scrolling="No" noresize="noresize" id="exScrollFrame" />
	<frame src="kpicompare.jsp" name="exMainFrame" id="exMainFrame" />
</frameset>
<noframes><body>
</body></noframes>
</html>
