<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<HTML>
	<HEAD>
		<TITLE>湖北移动经营分析系统</TITLE>
		<style type="text/css">
			<!--
			@import url(/hbbass/css/com.css);
			-->
		</style>
	</HEAD>
	<%
	String loginname=(String)session.getAttribute("loginname");
	User user = (User)session.getAttribute("user");
	String userId = user.getId();
	String newUrl = "http://10.25.124.105/dmk/loginSSO.jsp?APPCODE=jfqtSSO&userID="+userId;
	//response.sendRedirect(newUrl);
	%>
</table>
</form>
</BODY>
</HTML>
<script>
  window.location='<%=newUrl%>';
</script>
