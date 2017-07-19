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
</head>
<body>
	<table align="center" width="90%">
		<tr height="40">
			<td colspan="2" align="center"><label> <b>金库模式访问</b>
			</label></td>
		</tr>
		<tr>
			<td align="right" width="40%"><label> *授权模式： </label></td>
			<td width="60%"><input type="radio" id="model1" name="model"
				checked="checked" onclick="changeModel()"> 远程授权 <input
				type="radio" id="model2" name="model" onclick="changeModel()">
				现场授权 <input type="radio" id="model3" name="model"
				onclick="changeModel()"> 工单授权</td>
		</tr>
		<tr height="30">
			<td align="right"><label> *申请人： </label></td>
			<td><input id="account" type="text" style="width: 180px"
				value="" readonly="readonly"></td>
		</tr>
		<tr height="30" id="timeShow">
			<td align="right"><label> *授权有效时限： </label></td>
			<td><input id="time" type="text" style="width: 180px" value=""
				readonly="readonly"></td>
		</tr>
		<tr height="30" id="workorderShow" style="display: none">
			<td align="right"><label> *工单编号： </label></td>
			<td><input id="workorderNO" type="text" style="width: 180px"
				value=""></td>
		</tr>

		<tr height="30" id="contentShow" style="display: none">
			<td align="right"><label> *操作内容： </label></td>
			<td><textarea rows="3" id="operContent" style="width: 180px"></textarea>
			</td>
		</tr>

		<tr height="30" id="approverShow">
			<td align="right"><label> *协作人员： </label></td>
			<td><select id="approver" style="width: 180px">
			</select></td>
		</tr>
		<tr height="30" id="pwShow" style="display: none">
			<td align="right"><label> *协作人员静态密码： </label></td>
			<td><input id="pwCode" type="password" style="width: 180px">
			</td>
		</tr>
		<tr>
			<td align="right"><label> *申请原因： </label></td>
			<td><textarea rows="3" id="caseDesc" style="width: 180px"></textarea>
				<input id="count" type="hidden" style="width: 180px" value="0">
			</td>
		</tr>
		<tr height="30">
			<td align="center" colspan="2"><input type="button" value="提交申请"
				onclick="doSend()"> &nbsp;&nbsp;&nbsp;&nbsp; <input
				type="button" value="取消" onclick="doClose()"></td>
		</tr>
	</table>
</body>
</html>
<script>
	var PARAM_INFO = window.dialogArguments;
	var appSessionId = PARAM_INFO.appSessionId;
	var clientIp = PARAM_INFO.clientIp;
	var sceneId = PARAM_INFO.sceneId;			
	var uri = PARAM_INFO.lastUrl;
	var maxTime = PARAM_INFO.maxTime;
	var cooperate = PARAM_INFO.cooperate;
	var accounts = PARAM_INFO.accounts;
	var nid = PARAM_INFO.nid;
	document.getElementById('account').value = accounts;
	document.getElementById('time').value = maxTime;
	var approvers = document.getElementById('approver');
	if(cooperate.indexOf(",")>-1){
		var cooperates = cooperate.split(",");
		for(var k=0;k<cooperates.length;k++){
			approvers[k]=new Option(cooperates[k],cooperates[k]);
			if(k==0){
				approvers[k].selected=true;
			}
		}
	}else{
		approvers[0]=new Option(cooperate,cooperate);
	}
					
			
	function changeModel(){
		if(document.getElementById('model1').checked){
			document.getElementById('timeShow').style.display = '';
			document.getElementById('approverShow').style.display = '';
			document.getElementById('pwShow').style.display = 'none';
			document.getElementById('workorderShow').style.display = 'none';
			document.getElementById('contentShow').style.display = 'none';
		}
		if(document.getElementById('model2').checked){
			document.getElementById('pwShow').style.display = '';
			document.getElementById('timeShow').style.display = '';
			document.getElementById('approverShow').style.display = '';
			document.getElementById('workorderShow').style.display = 'none';
			document.getElementById('contentShow').style.display = 'none';
		}
		if(document.getElementById('model3').checked){
			document.getElementById('pwShow').style.display = 'none';
			document.getElementById('timeShow').style.display = 'none';
			document.getElementById('approverShow').style.display = 'none';
			document.getElementById('workorderShow').style.display = '';
			document.getElementById('contentShow').style.display = '';
		}
	}
	function doSend(){
		var account = document.getElementById('account').value;
		var time = document.getElementById('time').value;
		var approver = document.getElementById('approver').value;
		var model = 'remoteAuth';
		var caseDesc = document.getElementById('caseDesc').value;
		var pwCode = document.getElementById('pwCode').value;
		var workorderNO = document.getElementById("workorderNO").value;
		var operContent = document.getElementById("operContent").value;
		var count = document.getElementById("count").value;
		if(document.getElementById('model3').checked){
			model = 'workOrderAuth';
			if(document.getElementById('account').value == ''){
				alert('申请人信息不能为空。');
				return;
			}
			if(document.getElementById('workorderNO').value == ''){
				alert('工单编号不能为空。');
				return;
			}
			if(document.getElementById('operContent').value == ''){
				alert('操作内容不能为空。');
				return;
			}
			if(document.getElementById('caseDesc').value == ''){
				alert('申请原因不能为空。');
				return;
			}
		}else{
			if(document.getElementById('account').value == ''){
				alert('申请人信息不能为空。');
				return;
			}
			if(document.getElementById('time').value == ''){
				alert('授权有效时限不能为空。');
				return;
			}
			if(document.getElementById('approver').value == ''){
				alert('协作人员信息不能为空。');
				return;
			}
			if(document.getElementById('model2').checked){
				model = 'siteAuth';
				if(document.getElementById('pwCode').value == ''){
					alert('协作人员静态密码信息不能为空。');
					return;
				}
			}
			if(document.getElementById('caseDesc').value == ''){
				alert('申请原因信息不能为空，请简要描述。');
				return;
			}
			
		}
		var _ajax = new aihb.Ajax({
			url : "${mvcPath}/jinku/send"
			,parameters : "account="+account+"&time="+time+"&approver="+approver+"&caseDesc="+caseDesc+"&optype="+model+"&appSessionId="+appSessionId+"&clientIp="+clientIp+"&sceneId="+sceneId+"&workorderNO="+workorderNO+"&operContent="+operContent+"&pwCode="+pwCode+"&nid="+nid
			,loadmask : true
			,callback : function(xmlrequest){
				var result = xmlrequest.responseText;
				result = eval("("+result+")");
				if('N' == result.isPass){
		    		count = parseInt(count)+1;
		    		document.getElementById("count").value = count;	
		    		alert("认证码不正确，您已错误"+count+"次，最多输入3次，请重新认证！");
						if(count==3){
							window.close();
							doClose();
						}
				}else{
					if(model!='remoteAuth'){
						var RETURN_INFO = {
							isClose:'pass',
							model:model
						};
					}else{
						var RETURN_INFO = {
							isClose:'next',
							model:model
						};
					}
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