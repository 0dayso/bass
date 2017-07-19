<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<title>报表下载</title>
<script type="text/javascript" src="../../../resources/js/default/default.js" charset=utf-8></script>
<script type="text/javascript" src="../../../resources/js/default/scheduler.js" charset=utf-8></script>
<link rel="stylesheet" type="text/css" href="../../../resources/js/codebase/dhtmlxvault.css" />
<script language="JavaScript" type="text/javascript" src="../../../resources/js/codebase/dhtmlxvault.js"></script>		
<link rel="stylesheet" type="text/css" href="../../../resources/css/default/default.css" />
<script>
var _datePath="<%=request.getParameter("prefixPath")%>";
var _remoPath="<%=request.getParameter("prefixPath")%>";
<%User user = (User)session.getAttribute("user");%>
var cityId="<%=user.getCityId()%>";
if(_remoPath =="zhdb"){
	var cityCode = aihb.Constants.getArea(cityId).cityCode;
	_remoPath = _datePath+"/"+cityCode;
}
var result;
var url = "${mvcPath}/hbapp/app/report/down/downFromFtp1.jsp?prefixPath="+_remoPath;
var ajax=new aihb.Ajax({
	url: "${mvcPath}/jinku/kpiCheck"
	,loadmask : true
	,parameters : "date="+_datePath
	,callback : function(xmlrequest){
		var resultMap = xmlrequest.responseText;
		resultMap = eval("("+resultMap+")");
		var flag = resultMap.flag;
		var msg = resultMap.msg;
		if(!flag){
			alert(msg);
			var appSessionId = resultMap.appSessionId;
			var clientIp = resultMap.ip;
			var maxTime = resultMap.maxTime;
			var cooperate = resultMap.cooperate;
			var sceneId = resultMap.sceneId;
			var accounts = resultMap.accounts;
			var nid = resultMap.nid;
			var cooperateStatus = resultMap.cooperateStatus;
			var passFlag= false;
			var accountFlag = "N";
			if (cooperate == null || cooperate == "") {
				accountFlag = "Y";
			}
			if(cooperateStatus=="0"){
				return;
			}else{
				if(accountFlag=="N"){
					var params = {
							accounts:accounts
					}	
					var returnValue = window.showModalDialog('${mvcPath}/hbapp/cooperative/account.jsp',params,'dialogHeight:380px;dialogWidth:600px;resizable:No;status:No;help:No;');
					var accountReturn=returnValue.step;
					var account=returnValue.account;						
					if('close' == accountReturn){
						alert("金库认证未通过，请重新认证！");
						window.location = url;
						return;
					}else if('next' == accountReturn){
						var PARAM_INFO = {
							appSessionId:appSessionId,
							clientIp:clientIp,
							sceneId:sceneId,
							maxTime:maxTime,
							cooperate:cooperate,
							accounts:account,
							nid:nid
						};
						
						var RETRUN_INFO = window.showModalDialog('${mvcPath}/hbapp/cooperative/show.jsp',PARAM_INFO,'dialogHeight:380px;dialogWidth:600px;center:yes');
						if('close' == RETRUN_INFO.isClose){
							alert("金库认证未通过，请重新认证！");
							window.location = url;
							return;
						}else if('pass' == RETRUN_INFO.isClose){
							alert("金库认证通过！");
							listFiles();
						}
						if('remoteAuth' == RETRUN_INFO.model){
							var codeReturn = window.showModalDialog('${mvcPath}/hbapp/cooperative/code.jsp',PARAM_INFO,'dialogHeight:380px;dialogWidth:600px;resizable:No;status:No;help:No;');
							if('close' == codeReturn.isClose){
								alert("金库认证未通过，请重新认证！");
								window.location = url;
								return;
							}else if('pass' == codeReturn.isClose){
								alert("金库认证通过！");
								listFiles();
							}
						}
					}
				}
			}
		}else{
			listFiles();
		}
	}
});
ajax.request();

function listFiles(){
	//ajaxGetJson("${mvcPath}/hbirs/action/filemanage?method=listRemoteFiles","remotePath="+_remoPath,listFiles);
	var ajax = new aihb.Ajax({
		url : "${mvcPath}/hbirs/action/filemanage?method=listRemoteFiles"
		,parameters : "&remotePath="+_remoPath
		,callback : function(xmlrequest){
			var datas = {};
			try{
				eval("datas="+xmlrequest.responseText);
			}catch(e){}
			var str="";
			for(var i=0;i<datas.length;i++){
				str+="<div>"
				+"<a href='${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath="+_remoPath+"&fileName="+datas[i]+"' >"+datas[i]+"</a>"
				
				str+="</div>";
			}
			$("listFiles").innerHTML=str;
		}
	});
	
	ajax.request();
}

window.onload=function() {
	var _maskCont=$C("div");
	var _mask = aihb.Util.windowMask({content:_maskCont});
}
</script>
</head>
<body style="padding:10px  ;">
<input id="btnUpld" type="button" class="form_button_short" value="上传" style="display: none;">
<input id="btnSend" type="button" class="form_button_short" value="发短信" style="display: none;">
<div id="listFiles" style="font-size : 14px;line-height:20px;" ></div>

</body>
</html>
