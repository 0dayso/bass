<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>下载界面</title>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
		
	</head>
	<body>
		<br>
		<br>
		<center>
			<iframe style="display: none" id="iframe" src=""></iframe>
			<table align="center" width="90%">
				<tr height="40">
					<td colspan="2" align="center"><label><a href="#" onclick="down();">下载</a>
					</label></td>
				</tr>
			</table>
			<br>
		</center>
	</body>
	<script type="text/javascript">
			var PARAM_INFO = window.dialogArguments;
			var url = PARAM_INFO.downUrl;
			function down(){
				window.open(url);
				window.close();
			}
			
		</script>
</html>
