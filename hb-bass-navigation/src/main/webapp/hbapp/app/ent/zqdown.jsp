<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%
DateFormat monthFormater1 = new SimpleDateFormat("yyyyMM");
DateFormat monthFormater2 = new SimpleDateFormat("yyyy-MM");
DateFormat monthFormater3 = new SimpleDateFormat("yyyyMMdd");
Calendar c = Calendar.getInstance();
c.add(Calendar.MONTH,-1);
c.add(Calendar.DATE,-3);
String date = monthFormater1.format(c.getTime());

String fdate = monthFormater2.format(c.getTime()) + "-01";//增加上个月第一天yyyy-MM-dd格式

c.add(Calendar.MONTH,-1);
String ldate = monthFormater1.format(c.getTime()); //增加上上个月

c.setTime(new java.util.Date());
c.add(Calendar.DATE,-2);
String currentdate=monthFormater3.format(c.getTime());
%>
<html>
  <head>
    <title>政企核酬客户运营分析类指标</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="../../css/bass21.css" />
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/js/default/tabext.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/fluctuating_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid_common.js"></script>
<script type="text/javascript">
var pieces=[];

pieces[1]={
	filename:"EntRewardGroup"
	,title:"集团产品编号,帐号,集团编号,集团名称,产品类型,集团开户日期,出账收入,实际收入,是否欠费,历史欠费"
	,sql:"select productcode,"+
"acct_id,"+
"groupcode,"+
"groupname,"+
"prod_code,"+
"group_eff_date,"+
"value(bill_charge1,0)/100,"+
"value(bill_charge2,0)/100,"+
"is_debt,"+
"value(bill_charge3,0)/100 "+
"from nmk.ent_reward_group "+
"where type = '1' "+
"and time_id = _{lastmonth} "+
"with ur"
};

pieces[2]={
	filename:"EntRewardMember"
	,title:"集团产品编号,集团编号,集团名称,产品类型,用户编号,手机号码,成员开户日期,出账收入,实际收入,是否欠费,历史欠费"
	,sql:"select productcode,"+
"groupcode,"+
"groupname,"+
"prod_code,"+
"mbuser_id,"+
"acc_nbr,"+
"member_eff_date,"+
"value(bill_charge1,0)/100,"+
"value(bill_charge2,0)/100,"+
"is_debt,"+
"value(bill_charge3,0)/100 "+
"from nmk.ent_reward_member "+
"where type = '1' "+
"and time_id = _{lastmonth} "+
"with ur"
};

pieces[3]={
	filename:"Ent_Reward_Group"
	,title:"集团产品编号,帐号,集团编号,集团名称,产品类型,集团开户日期,出账收入,实际收入,是否欠费,历史欠费"
	,sql:"select productcode,"+
"acct_id,"+
"groupcode,"+
"groupname,"+
"prod_code,"+
"group_eff_date,"+
"value(bill_charge1,0)/100,"+
"value(bill_charge2,0)/100,"+
"is_debt,"+
"value(bill_charge3,0)/100 "+
"from nmk.ent_reward_group "+
"where type = '2' "+
"and time_id = _{lastmonth} "+
"with ur"
};

pieces[4]={
	filename:"Ent_Reward_Member"
	,title:"集团产品编号,集团编号,集团名称,产品类型,用户编号,手机号码,成员开户日期,出账收入,实际收入,是否欠费,历史欠费"
	,sql:"select productcode,"+
"groupcode,"+
"groupname,"+
"prod_code,"+
"mbuser_id,"+
"acc_nbr,"+
"member_eff_date,"+
"value(bill_charge1,0)/100,"+
"value(bill_charge2,0)/100,"+
"is_debt,"+
"value(bill_charge3,0)/100 "+
"from nmk.ent_reward_member "+
"where type = '2' "+
"and time_id = _{lastmonth} "+
"with ur"
};

var _cont = $C("div");
var _mask = aihb.Util.windowMask({content:_cont});
	
var appSessionId;
var clientIp;
var maxTime;
var cooperate;
var sceneId;
var accounts;
var nid;
var cooperateStatus;
var account;

function download(sSeq)
{
	var piece=pieces[sSeq];
	if(piece.sql.indexOf("currentdate")>-1){
		var cd='<%=currentdate%>';
		document.forms[0].filename.value=piece.filename+cd
	}else{
		document.forms[0].filename.value=piece.filename;
	}
	document.forms[0].title.value=piece.title;
	document.forms[0].sql.value=piece.sql.replace(/_{month}/gi,document.forms[0].date.value).replace(/_{lmonth}/gi,document.forms[0].ldate.value).replace(/_{fdate}/gi,document.forms[0].fdate.value).replace(/_{currentdate}/gi,document.forms[0].currentdate.value).replace(/_{lastmonth}/gi,document.forms[0].ldate.value);
	
	if(document.forms[0].sql.value.toLowerCase().indexOf("with ur")==0){
		document.forms[0].sql.value+= " with ur "
	}
	// document.getElementById("sqlview").innerHTML=document.forms[0].sql.value;
	var ajax=new aihb.Ajax({
		url: "${mvcPath}/jinku/kpiCheck"
		,loadmask : true
		,parameters : "date="+sSeq
		,callback : function(xmlrequest){
			var resultMap = xmlrequest.responseText;
			resultMap = eval("("+resultMap+")");
			var flag = resultMap.flag;
			var msg = resultMap.msg;
			if(!flag){
				alert(msg);
				appSessionId = resultMap.appSessionId;
				clientIp = resultMap.ip;
				maxTime = resultMap.maxTime;
				cooperate = resultMap.cooperate;
				sceneId = resultMap.sceneId;
				accounts = resultMap.accounts;
				nid = resultMap.nid;
				cooperateStatus = resultMap.cooperateStatus;
				var passFlag= false;
				var accountFlag = "N";
				if (cooperate == null || cooperate == "") {
					accountFlag = "Y";
				}
				if(cooperateStatus=="0"){
					alert("无协作人，请联系4A管理员");
					return;
				}else{
					if(accountFlag=="N"){						
						openAccountDialog();
					}
				}	
			}else{
				toDown();
			}
		}
	});
	ajax.request();
}

function openAccountDialog(){
	accounts = eval(accounts);
	var content = "<fieldset style=\"width: 350px; height: 180px; margin: 0 10px 10px 10px;\">"+
				"<legend>"+
					"您在4A系统中有如下主账号"+
				"</legend>"+
				"<table align=\"center\" width=\"90%\" height=\"90%\">"+
					"<tr>"+
						"<td align=\"center\">"+
							"<label>"+
								"<select id=\"accountSel\" style=\"width: 230px\">"+
								"</select>"+
							"</label>"+
						"</td>"+
					"</tr>"+
				"</table>"+
			"</fieldset>"+
			"<br>"+
			"<div align=\"center\" style='margin-bottom:8px;'><input type=\"button\" value=\"确定\" onclick=\"doSendAccount()\">"+
			"&nbsp;&nbsp;&nbsp;&nbsp;"+
			"<input type=\"button\" value=\"取消\" onclick=\"doClose()\"></div>";
	_cont.innerHTML = content;
	var account = document.getElementById("accountSel");
	if(accounts.length > 0){
		for(var k=0;k<accounts.length;k++){
			account[k]=new Option(accounts[k],accounts[k]);
			if(k==0){
				account[k].selected=true;
			}
		}
	}else{
		account[0]=new Option(accounts,accounts);
	}
	_mask.show();
}

function doClose(){
	alert("金库认证未通过，请重新认证！");
	document.getElementById('closeImg').parentNode.parentNode.parentNode.style.display='none';
	return;
}

function doSendAccount(){
	account = document.getElementById('accountSel').value;
	if(account == ''){
		alert('主账号信息不能为空。');
		return;
	}
	openShowDialog();
}

function openShowDialog(){
	var content = "<table align='center' width='400px;' style='margin: 10px 0;'>  "+
		"<tr height='40'>"+
			"<td colspan='2' align='center'><label> <b>金库模式访问</b>"+
			"</label></td>"+
		"</tr>"+
		"<tr>"+
			"<td align='right' width='40%'><label> *授权模式： </label></td>"+
			"<td width='60%'><input type='radio' id='model1' name='model' "+
				"checked='checked' onclick='changeModel()'> 远程授权 <input "+
				"type='radio' id='model2' name='model' onclick='changeModel()'>"+
				"现场授权 <input type='radio' id='model3' name='model'"+
				"onclick='changeModel()'> 工单授权</td>"+
		"</tr>"+
		"<tr height='30'>"+
			"<td align='right'><label> *申请人： </label></td>"+
			"<td><input id='account' type='text' style='width: 180px' "+
				"value='' readonly='readonly'></td>"+
		"</tr>"+
		"<tr height='30' id='timeShow'>"+
			"<td align='right'><label> *授权有效时限： </label></td>"+
			"<td><input id='maxTime' type='text' style='width: 180px'"+
				"value='' readonly='readonly'></td>"+
		"</tr>"+
		"<tr height='30' id='workorderShow' style='display: none' >"+
			"<td align='right'><label> *工单编号： </label></td>"+
			"<td><input id='workorderNO' type='text' style='width: 180px' "+
				"value=''></td>"+
		"</tr>"+

		"<tr height='30' id='contentShow' style='display: none'>"+
			"<td align='right'><label> *操作内容： </label></td>"+
			"<td><textarea rows='3' id='operContent' style='width: 180px'></textarea>"+
			"</td>"+
		"</tr>"+

		"<tr height='30' id='approverShow'>"+
			"<td align='right'><label> *协作人员： </label></td>"+
			"<td><select id='approver' style='width: 180px'>"+
			"</select></td>"+
		"</tr>"+
		"<tr height='30' id='pwShow' style='display: none'>"+
			"<td align='right'><label> *协作人员静态密码： </label></td>"+
			"<td><input id='pwCode' type='password' style='width: 180px'>"+
			"</td>"+
		"</tr>"+
		"<tr>"+
			"<td align='right'><label> *申请原因： </label></td>"+
			"<td><textarea rows='3' id='caseDesc' style='width: 180px'></textarea>"+
				"<input id='count' type='hidden' style='width: 180px' value='0'>"+
			"</td>"+
		"</tr>"+
		"<tr height='30'>"+
			"<td align='center' colspan='2'><input type='button' value='提交申请'"+
				"onclick='doShowSend()'> &nbsp;&nbsp;&nbsp;&nbsp; <input "+
				"type='button' value='取消' onclick='doClose()'></td>"+
		"</tr>"+
	"</table>";
_cont.innerHTML = content;
initParamValue();
_mask.show();
}

function initParamValue(){
	document.getElementById('account').value = account;
	document.getElementById('maxTime').value = maxTime;
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

function doShowSend(){
	var account = document.getElementById('account').value;
	var time = document.getElementById('maxTime').value;
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
		if(document.getElementById('maxTime').value == ''){
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
						doClose();
					}
			}else{
				if(model!='remoteAuth'){
					document.getElementById('closeImg').parentNode.parentNode.parentNode.style.display='none';
					toDown();
				}else{
					showCodeDialog();
				}
			}
		}
	})
	_ajax.request();
}

function showCodeDialog(){
	var content = "<div style='margin: 0 10px 10px 10px' >"
		+"<fieldset style='width: 350px; height: 180px;'>"
			+"<legend> 请输入远程授权动态码 </legend>"
			+"<table align='center' width='90%' height='90%'>"
				+"<tr>"
					+"<td align='center'><label> <input id='pwCode1'"
							+" type='text' style='width: 230px;'>"
					+"</label> <input id='count1' type='hidden' style='width: 180px' value='0'>"
					+"</td>"
				+"</tr>"
			+"</table>"
		+"</fieldset>"
		+"<br><div align='center' style='margin-bottom:8px;'><input type='button' value='确定' onclick='doCodeSend()'>"
		+"&nbsp;&nbsp;&nbsp;&nbsp; "
		+"<input type='button' value='取消' onclick='doClose()'></div>"
	+"</div>";
	_cont.innerHTML = content;
	_mask.show();
}

function doCodeSend(){
	var pwCode = document.getElementById('pwCode1').value;
	var count = document.getElementById("count1").value;
	if(pwCode == ''){
		alert('授权动态码信息不能为空。');
		return;
	}
	
	var _ajax = new aihb.Ajax({
		url : "${mvcPath}/jinku/send"
		,parameters : "account="+account+"&time="+maxTime+"&approver="+cooperate+"&optype=remoteAuth2&appSessionId="+appSessionId+"&clientIp="+clientIp+"&sceneId="+sceneId+"&pwCode="+pwCode
		,loadmask : true
		,callback : function(xmlrequest){
			var result = xmlrequest.responseText;
			result = eval("("+result+")");
			if('N' == result.isPass){
	    		count = parseInt(count)+1;
	    		document.getElementById("count1").value = count;	
	    		alert("认证码不正确，您已错误"+count+"次，最多输入3次，请重新输入！");
				if(count==3){
					doClose();
				}
			}else{
				document.getElementById('closeImg').parentNode.parentNode.parentNode.style.display='none';
				toDown();
			}
		}
	});
	_ajax.request();
}

function toDown()
{
	document.forms[0].action = "gcdownAction.jsp";
	document.forms[0].target = "_top";
	document.forms[0].submit();
}
</script>
  </head>
  <body>
  	<div style="margin: 20 px;text-align: center;font-size: 22px;font-weight: bold;font-family: 黑体">政企核酬客户运营分析类指标</div>
	<form action="" method="post">
  	<input type="hidden" name="sql" value="">
  	<input type="hidden" name="title" value="">
  	<input type="hidden" name="filename" value="">
  	<div style="padding: 10 px;"></div>
  
  	<table align="center" width="83%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
	  <tr class="grid_title_blue" height="26">
	    <td width="10%" class="grid_title_cell">序号</td>
	    <td width="18%" class="grid_title_cell">跟踪产品</td>
	    <td width="52%" class="grid_title_cell">描述</td>
	    <td width="10%" class="grid_title_cell">下载</td>
	  </tr>
	  <tr class="grid_row_alt_blue" height="26" >
	  	<td width="10%" class="grid_row_cell"></td>
	  	<td colspan="3" class="grid_row_cell_text">月份 ：<%=date%>
	  		<input type="hidden" name="date" value="<%=date %>">
	  		<input type="hidden" name="ldate" value="<%= ldate%>" />
	  		<input type="hidden" name="fdate" value="<%= fdate%>" />
	  		<input type="hidden" name="currentdate" value="<%=currentdate%>" />
	  		</td>
	  </tr>
	  	
	  	 <tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">1</td>
	    <td class="grid_row_cell_text">政企核酬新增集团订购集团产品数据</td>
	    <td class="grid_row_cell_text">政企核酬新增集团订购集团产品数据下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(1)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">2</td>
	    <td class="grid_row_cell_text">政企核酬新增成员订购集团产品数据</td>
	    <td class="grid_row_cell_text">政企核酬新增成员订购集团产品数据下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(2)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">3</td>
	    <td class="grid_row_cell_text">政企核酬续签集团订购集团产品数据</td>
	    <td class="grid_row_cell_text">政企核酬续签集团订购集团产品数据下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(3)"></td>
	  	</tr>
	  	
	  	<tr class="grid_row_alt_blue" height="26">
	    <td class="grid_row_cell">4</td>
	    <td class="grid_row_cell_text">政企核酬续签成员订购集团产品数据</td>
	    <td class="grid_row_cell_text">政企核酬续签成员订购集团产品数据下载</td>
	     <td class="grid_row_cell">
	     	<input type="button" class="form_button_short" value="下载" onclick="download(4)"></td>
	  	</tr>
	  	
	</table>
		</form>
  </body>
</html>
<%@ include file="/hbapp/resources/old/loadmask.htm"%>
<div id="sqlview"></div>