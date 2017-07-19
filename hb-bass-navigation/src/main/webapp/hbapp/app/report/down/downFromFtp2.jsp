<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
<title>满意度ppt上传下载</title>
<script type="text/javascript" src="../../../resources/js/default/default.js" charset=utf-8></script>
<script type="text/javascript" src="../../../resources/js/default/scheduler.js" charset=utf-8></script>
<link rel="stylesheet" type="text/css" href="../../../resources/js/codebase/dhtmlxvault.css" />
<script language="JavaScript" type="text/javascript" src="../../../resources/js/codebase/dhtmlxvault.js"></script>		
<link rel="stylesheet" type="text/css" href="../../../resources/css/default/default.css" />
<script>
<%User user = (User)session.getAttribute("user");%>
var prefixPath="<%=request.getParameter("prefixPath")%>";
var loginname="<%=user.getId()%>";
var _remoPath="satisfaction/"+prefixPath;
var hasRight=false;//具有操作权限
if(loginname=='meikefu'|| loginname=='chengfan')
	hasRight=true;
	
var result;
var url = "${mvcPath}/hbapp/app/report/down/downFromFtp2.jsp?prefixPath="+_remoPath;
var ajax=new aihb.Ajax({
	url: "${mvcPath}/jinku/kpiCheck"
	,loadmask : true
	,parameters : "date="+prefixPath
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
					var returnValue = window.showModalDialog('/hbapp/cooperative/account.jsp',params,'dialogHeight:380px;dialogWidth:600px;resizable:No;status:No;help:No;');
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
						
						var RETRUN_INFO = window.showModalDialog('/hbapp/cooperative/show.jsp',PARAM_INFO,'dialogHeight:380px;dialogWidth:600px;center:yes');
						if('close' == RETRUN_INFO.isClose){
							alert("金库认证未通过，请重新认证！");
							window.location = url;
							return;
						}else if('pass' == RETRUN_INFO.isClose){
							alert("金库认证通过！");
							listFiles();
						}
						if('remoteAuth' == RETRUN_INFO.model){
							var codeReturn = window.showModalDialog('/hbapp/cooperative/code.jsp',PARAM_INFO,'dialogHeight:380px;dialogWidth:600px;resizable:No;status:No;help:No;');
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
			var datas = {}
			try{
				eval("datas="+xmlrequest.responseText);
			}catch(e){}
			var str="<table class=grid-tab-blue align='center' width='99%'  cellspacing='1' cellpadding='0' border='0'><THEAD><TR class=grid_title_blue><TD class=grid_title_cell><A id=label>文件名称</A></TD><TD class=grid_title_cell><A id=name >上传时间</A></TD><TBODY>";
			for(var i=0;i<datas.length;i++){
				str+="<tr class=grid_row_blue><td class='grid_title_cell' align=center>"
				+"<a href='/hbirs/action/filemanage?method=downFromFtp&remotePath="+_remoPath+"&fileName="+datas[i].fileName+"' target='_blank'>"+datas[i].fileName+"</a>"
				str+="</td><td class='grid_title_cell' align=center>"+datas[i].modifyTime+"</td>";
				str+="</tr>";
			}
			str+="</table>";
			$("listFiles").innerHTML=str;
		}
	});
	
	ajax.request();
}

window.onload=function() {
	var _maskCont=$C("div");
	var _mask = aihb.Util.windowMask({content:_maskCont});
	var vault = new dhtmlXVaultObject();
	   vault.setImagePath("../../../resources/js/codebase/imgs/");
	   vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=uploadToFtp&remotePath="+_remoPath, "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
	   //vault.setFilesLimit(1);
	  	vault.create(_maskCont);
	   
	   vault.onUploadComplete=function(){
	   	listFiles();
	   	_mask.style.display='none';
		this.removeAllItems();
	   }
	if(hasRight){
	   	$("btnUpld").style.display="";
	   	$("btnUpld").onclick=function(){
	   		_mask.style.display='';
	};
	}
}
</script>
</head>
</body>
<input id="btnUpld" type="button" class="form_button_short" value="上传" style="display:none;FONT-SIZE: 18px;width:50px;height:25px;">
<div id="listFiles" style="font-size : 14px;line-height:20px;"></div>
</html>
