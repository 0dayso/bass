<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<HTML>
	<HEAD>
		<TITLE>�����ƶ���Ӫ����ϵͳ</TITLE>
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
	String newUrl = "http://10.25.124.98:8000/audit/hbmSsoAuditlogin.e?userId="+userId;
	%>
</table>
</form>
</BODY>
</HTML>
<script>
  window.open('<%=newUrl%>');
</script>
