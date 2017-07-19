<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<HTML>
	<HEAD>
	</HEAD>
	<%
	User user = (User)session.getAttribute("user");
	String cityId = user.getCityId();
	String newUrl = "http://10.25.124.114:10010/ebook/mis.jsp?cityId="+cityId;
	//response.sendRedirect(newUrl);
	%>
</table>
</form>
</BODY>
</HTML>
<script>
	window.location='<%=newUrl%>';
</script>
