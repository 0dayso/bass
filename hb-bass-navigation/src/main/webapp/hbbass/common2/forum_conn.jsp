<%@ page contentType="text/html; charset=gb2312"%>
<%
	String loginName = (String)session.getAttribute("loginname");
	String password = "12345";
		
%>
<html>
	<head>
	<%-- 090901:将cookie有效期设置成1天 --%>
		
	</head>
	<body>
	<%--
<center>
<h1>新版交流平台</h1>
 本机测试
<h2><a target="_blank"  href="http://localhost:8888/bbscs8/login.bbscs?action=login&username=<%=loginName%>&passwd=<%=password%>&tourl=http://localhost:8888/bbscs8/main.bbscs&authCode=1111&cookieTime=-1">

 <h2><a target="_blank"  href="http://10.25.124.46:8081/bbscs8/login.bbscs?action=login&username=<%=loginName%>&passwd=<%=password%>&tourl=http://10.25.124.46:8081/bbscs8/main.bbscs&authCode=1111&cookieTime=-1">
点击进入</a></h2>
</center>
 --%>
 <%
 	//好像只能是重定向request.getRequestDispatcher("http://10.25.124.46:8081/bbscs8/login.bbscs?action=login&username=loginName&passwd=password&tourl=http://10.25.124.46:8081/bbscs8/main.bbscs&authCode=1111&cookieTime=-1").forward(request,response);
 	//不能在新页面打开response.sendRedirect("http://10.25.124.46:8081/bbscs8/login.bbscs?action=login&username=" + loginName + "&passwd=" + password + "&tourl=http://10.25.124.46:8081/bbscs8/main.bbscs&authCode=1111&cookieTime=-1");
 %>
 	<script type="text/javascript">
 		window.open("http://10.25.124.46:8081/bbscs8/login.bbscs?action=login&username=<%=loginName%>&passwd=<%=password%>&tourl=http://10.25.124.46:8081/bbscs8/main.bbscs&authCode=1111&cookieTime=86400");
 	</script>
	</body>
</html>
