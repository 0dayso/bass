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
	String newUrl = "http://10.25.124.111:8090/tas-web/authc/login?userName="+loginname+"&password=54841A7EBC6A54DA";
	
	//response.sendRedirect(newUrl);
	%>
</table>
</form>
</BODY>
</HTML>
<script>
	window.location='<%=newUrl%>';
  //http://10.25.124.111:8090/tas-web/authc/login?userName=caokai&password=54841A7EBC6A54DA
  //window.open('<%=newUrl%>','flowIos','width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+ ',top=0,left=0,resizable=yes,status=yes,menubar=no,scrollbars=yes');
</script>
