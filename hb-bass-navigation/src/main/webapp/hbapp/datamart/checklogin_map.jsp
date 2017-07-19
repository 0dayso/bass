<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="com.asiainfo.bass.components.models.DES"%>
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
	User user = (User)session.getAttribute("user");
	String userIdJm = DES.encode(user.getId());
	String userNameJm = DES.encode(user.getName());
	String regionIdJm = DES.encode(user.getRegionId());
	
	String param = "userId="+userIdJm+"&userName="+userNameJm+"&regionId="+regionIdJm;
	System.out.println(param);
	String newUrl = "http://10.25.125.92:8088/DMC-IDX-WEB/dev/module/gisDisplay/cellValueMap.html?" + param;
	%>
</table>
</form>
</BODY>
</HTML>
<script>
  window.open('<%=newUrl%>');
</script>
