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
<%User user = (User)session.getAttribute("user");%>
var _remoPath="<%=request.getParameter("prefixPath")%>";
var loginname="<%=user.getId()%>";
var cityId="<%=user.getCityId()%>";
var hasRight=false;//具有操作权限
if(_remoPath=="finance"){
	var cityCode = cityId=="0"?"HB.WH":aihb.Constants.getArea(cityId).cityCode;
	if(cityCode=="HB"){
		cityCode="HB.QJ";
	}
	_remoPath+="/"+cityCode;
	hasRight=(loginname=="wanchun"||loginname=="lizj"||loginname=="zhaojing");
}else if("countyRank"==_remoPath){
	hasRight=(loginname=="xiekun"||loginname=="zhangtao2"||loginname=="lizj");
}

var result;
var url = "${mvcPath}/hbapp/app/report/down/downFromFtp.jsp?prefixPath="+_remoPath;
var ajax=new aihb.Ajax({
	url: "${mvcPath}/jinku/kpiCheck"
	,loadmask : true
	,parameters : "date="+_remoPath
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
			var str="";
			for(var i=0;i<datas.length;i++){
				str+="<div>"
				+"<a href='/hbirs/action/filemanage?method=downFromFtp&remotePath="+_remoPath+"&fileName="+datas[i]+"' target='_blank'>"+datas[i]+"</a>"
				
				if("countyRank"==_remoPath && hasRight){//县域排名需要删除
					str +=" <a href='#' onclick='delFile(\""+datas[i]+"\")'>删除</a>";
				}
				str+="</div>";
			}
			$("listFiles").innerHTML=str;
		}
	});
	
	ajax.request();
}

function delFile(fileName){
	if(confirm("确定？")){
		//aihb.AjaxHelper.log({params: encodeURI(_params._oriUri)+"&opertype=delete&opername="+encodeURIComponent(fileName)})
		var ajax = new aihb.Ajax({
			url: "${mvcPath}/hbirs/action/filemanage?method=delFromFtp&remotePath="+_remoPath 
			,parameters : "&fileName="+encodeURIComponent(fileName)
			,callback:function(xmlHttp){
				listFiles();
			}
		});
		ajax.request();
	}
}

window.onload=function() {

	var _maskCont=$C("div");
	var _mask = aihb.Util.windowMask({content:_maskCont});
	if("countyRank"==_remoPath){//县市排名下载专用
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
	}else if(hasRight){//财务报表下载
		/**
		var sched = new aihb.Scheduler({container:_maskCont,sql:"values '[经分系统温馨提示]@month月财务报表已经放到前台，请各位同事及时下载。'",ds:"web",contacts:"13476080947;13607153889;13971888686;13907210001;13733590303;13607201698;13971759996;13971723789;13971820000;13872888612;13807269192;13808688881;13972258567;13797211999;13507225882;15871520058"});
		sched.render();
		$("btnSend").style.display="";
	   	$("btnSend").onclick=function(){
	   		_mask.style.display="";
		};
		**/
		$("btnSend").style.display="";
	   	$("btnSend").onclick=function(){
	   		_mask.style.display="";
	   		var ajax = new aihb.Ajax({
				url: "/hbirs/service/message?contacts=13476080947;13607153889;13971888686;13907210001;13733590303;13607201698;13971759996;13971723789;13971820000;13872888612;13807269192;13808688881;13972258567;13797211999;13507225882;15871520058&content=[经分系统温馨提示]月度财务报表已经放到前台，请各位同事及时下载。"
				,parameters : ""
				,callback:function(xmlHttp){
				}
			});
			ajax.request();
		};
	}
}
</script>
</head>
<body style="padding:10px;">
<input id="btnUpld" type="button" class="form_button_short" value="上传" style="display: none;">
<input id="btnSend" type="button" class="form_button_short" value="发短信" style="display: none;">
<div id="listFiles" style="font-size : 14px;line-height:20px;"></div>
</body>
</html>
