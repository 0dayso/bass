<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<title>金库模式访问信息输入界面</title>
<script type="text/javascript"
	src="${mvcPath}/hbapp/resources/js/jquery/jquery.js"></script>
<script type="text/javascript"
	src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
<script type="text/javascript"
	src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
<script type="text/javascript"
	src="${mvcPath}/hbapp/resources/js/tooltip/script.js"></script>
<link rel="stylesheet" type="text/css"
	href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
<link rel="stylesheet" type="text/css"
	href="${mvcPath}/hbapp/resources/css/default/default.css" />
<link rel="stylesheet" type="text/css"
	href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
<link rel="stylesheet" type="text/css"
	href="${mvcPath}/hbapp/app/flowOperation/flowPackage/css/flowPackage.css" />
<script type="text/javascript">
			function doSend(){
				var pwCode = document.getElementById('pwCode').value;
				var count = document.getElementById("count").value;
				if(pwCode == ''){
					alert('授权动态码信息不能为空。');
					return;
				}
				var PARAM_INFO = window.dialogArguments;
				var account = PARAM_INFO.account;
				var time = PARAM_INFO.maxTime;
				var approver = PARAM_INFO.cooperate;
				var appSessionId = PARAM_INFO.appSessionId;
				var clientIp = PARAM_INFO.clientIp;
				var sceneId = PARAM_INFO.sceneId;
				window.returnValue = 'next';
				
				var _ajax = new aihb.Ajax({
					url : "${mvcPath}/jinku/send"
					,parameters : "account="+account+"&time="+time+"&approver="+approver+"&optype=remoteAuth2&appSessionId="+appSessionId+"&clientIp="+clientIp+"&sceneId="+sceneId+"&pwCode="+pwCode
					,loadmask : true
					,callback : function(xmlrequest){
						var result = xmlrequest.responseText;
						result = eval("("+result+")");
						if('N' == result.isPass){
				    		count = parseInt(count)+1;
				    		document.getElementById("count").value = count;	
				    		alert("认证码不正确，您已错误"+count+"次，最多输入3次，请重新输入！");
								if(count==3){
									window.close();
									doClose();
								}
						}else{
							var RETURN_INFO = {
								isClose:'pass'
							};
							window.returnValue = RETURN_INFO;
							window.close();
						}
					}
				})
				_ajax.request();
			}
			function doClose(){
				alert("金库认证未通过，请重新认证！");
				var RETURN_INFO = {
						isClose:'close'
					};
				window.returnValue = RETURN_INFO;
				window.close();
			}
		</script>
</head>
<body>
	<br>
	<br>
	<iframe style="display: none" id="iframe" src=""></iframe>
	<center>
		<fieldset style="width: 350px; height: 180px;">
			<legend> 请输入远程授权动态码 </legend>
			<table align="center" width="90%" height="90%">
				<tr>
					<td align="center"><label> <input id="pwCode"
							type="text" style="width: 230px;">
					</label> <input id="count" type="hidden" style="width: 180px" value="0">
					</td>
				</tr>
			</table>
		</fieldset>
		<br> <br> <input type="button" value="确定" onclick="doSend()">
		&nbsp;&nbsp;&nbsp;&nbsp; 
		<input type="button" value="取消" onclick="doClose()">
	</center>
</body>

</html>
