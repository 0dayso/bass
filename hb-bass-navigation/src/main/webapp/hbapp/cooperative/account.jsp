<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>金库模式主账号选择界面</title>
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
			<fieldset style="width: 350px; height: 180px;">
				<legend>
					您在4A系统中有如下主账号
				</legend>
				<table align="center" width="90%" height="90%">
					<tr>
						<td align="center">
							<label>
								<select id="account" style="width: 230px">
								</select>
							</label>
						</td>
					</tr>
				</table>
			</fieldset>
			<br>
			<br>
			<input type="button" value="确定" onclick="doSend()">
			&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" value="取消" onclick="doClose()">
		</center>
	</body>
	<script type="text/javascript">
			var PARAM_INFO = window.dialogArguments;
			var account = document.getElementById("account");
			var accounts = eval(PARAM_INFO.accounts);  //因使用json传递，所以需要转换
			if(accounts.length > 0){
				//var accountses = accounts.split(",");
				for(var k=0;k<accounts.length;k++){
					account[k]=new Option(accounts[k],accounts[k]);
					if(k==0){
						account[k].selected=true;
					}
				}
			}else{
				account[0]=new Option(accounts,accounts);
			}
			
			function doSend(){
				var account = document.getElementById('account').value;
				if(account == ''){
					alert('主账号信息不能为空。');
					return;
				}
				var obj = new Object();
				obj.step ='next';
				obj.account=account;
				window.returnValue = obj; 
				window.close();
			}
			
			function doClose(){
				var obj = new Object();
				obj.step ='close';
				obj.account='';
				window.returnValue = obj;
				window.close();
			}
		</script>
</html>
