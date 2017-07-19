<%@page import="com.asiainfo.bass.components.models.DES"%>
<%@ page contentType="text/html; charset=gb2312"%>
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
	String cityId = (String)session.getAttribute("area_id");
	//String param =  DES.encode("userID="+loginname+"||"+"cityId="+cityId);
	String newUrl = " http://10.25.125.107:8088/flowMap/?cityId="+cityId+"&userID="+DES.encrypt(loginname);
	//response.sendRedirect(newUrl);
	%>
</BODY>
</HTML>
<script>
  //window.location='<%=newUrl%>';
	window.open('<%=newUrl%>','flowIos','width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+ ',top=0,left=0,resizable=yes,status=yes,menubar=no,scrollbars=yes');
</script>