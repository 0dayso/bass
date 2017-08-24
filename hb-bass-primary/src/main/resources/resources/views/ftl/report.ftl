<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<title>${title}</title>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid_common.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/rpt_common.js"></script>	
	<script type="text/javascript" src="${mvcPath}/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/cryptojs/aes.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/cryptojs/mode-ecb-min.js"></script>
	<!--这个前台一直都是错误的<script type="text/javascript" src="${mvcPath}/resources/chart/FusionCharts.js"></script>-->
	
	<!--
	<script type="text/javascript" src="${mvcPath}/resources/js/default/click.js"></script>	
	-->
	<!--这个前台一直都是错误的<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/multiSelect/multiple-select.css" />-->
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/bass_common.css" />
	<script type="text/javascript">
window.onload=function(){
	if('${groupId}'!='26020' && '${groupId}'!='1')	{//非维护组的不能复制
		var fileref = document.createElement("script");
		fileref.setAttribute("type","text/javascript");
		fileref.setAttribute("src","${mvcPath}/resources/js/default/click.js");
		if (typeof(fileref) != "undefined"){
			document.getElementsByTagName("head")[0].appendChild(fileref);
		}
	}
}	

var $j=jQuery.noConflict();
var _currentUser = ${currentUser};
var _header= ${header};
var _corReport= ${corReport};
var grid=null;
/*
编程中重载的col与groupby，来生成SQL 等等操作
*/
function sqlInterceptor(sql){
	return genSqlPieces(sql);
}
/*
编程中重载条件生成，必须要sql之前条用
*/
function condiInterceptor(){
}
function genSQL(){
	condiInterceptor();
	var sql="${sql}";
	sql=sqlInterceptor(sql);
	sql=sqlReplace(sql);
	return sql;
}

var key  = CryptoJS.enc.Utf8.parse('o7H8uIM2O5qv65l2');//Latin1 w8m31+Yy/Nw6thPsMpO5fg==
function encode(text){
           var srcs = CryptoJS.enc.Utf8.parse(text);  
           var encrypted = CryptoJS.AES.encrypt(srcs, key, {mode:CryptoJS.mode.ECB,padding: CryptoJS.pad.Pkcs7});  
           return encrypted.toString(); 
}

function desSql(){
	return strEncode(genSQL());
}

function query(){
	grid=new aihb.${grid}({
		header:_header
		,sql: encode(encodeURIComponent(desSql()))
		,isCached : "${cache}"
		,ds : "${ds}"
		,callback:function(){
			if("${useChart}"=="true"){
				jQuery("#chartMain").fadeIn(200);
				chartIndicator();
			}
		}
	});
	grid.ajax.url="${mvcPath}/report/${sid}/query"
	grid.run();
}

function down(){
	var sid = ${sid};
	$j.ajax({
		url: "${mvcPath}/jinku/kpiCheck"
		,data : "date=checkReport&sid="+sid+"&sql="+encodeURIComponent(desSql())
		,type : "post"
		,dataType : "text"
		,success:function(resultMap){
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
					alert("无协作人，请联系4A管理员");
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
								return;
							}else if('pass' == RETRUN_INFO.isClose){
								//alert("金库认证通过,该报表已纳入文档安全管理，请确认是否安装文档安全管理软件，否则报表无法正常阅读。");
								down1();
							}
							if('remoteAuth' == RETRUN_INFO.model){
								var codeReturn = window.showModalDialog('${mvcPath}/hbapp/cooperative/code.jsp',PARAM_INFO,'dialogHeight:380px;dialogWidth:600px;resizable:No;status:No;help:No;');
								if('close' == codeReturn.isClose){
									alert("金库认证未通过，请重新认证！");
									return;
								}else if('pass' == codeReturn.isClose){
									//alert("金库认证通过,该报表已纳入文档安全管理，请确认是否安装文档安全管理软件，否则报表无法正常阅读。");
									down1();
								}
							}
						}
					}
				}	
			}else{
				alert(msg);
				var status = resultMap.status;
				if(status=='1'){
					down1();
				}else if(status=='0'){
					downNormal();
				}else{
					alert(resultMap.message);
				}
			}
		}
	});
}

function downNormal(){
	aihb.AjaxHelper.down({
		 sql : encodeURIComponent(desSql())
		 ,header : _header
		 ,url: "${mvcPath}/report/${sid}/down"
		 ,ds : "${ds}"
		 ,useExcel : "${useExcel}"
	});
}

function down1(){
	var sid = ${sid};
	//金库认证通过后验证是否通过敏感数据平台下载
	$j.ajax({
		url: "${mvcPath}/jinku/checkSensitive?rand="+Math.random()
		,data : "date=checkReport&sid="+sid
		,type : "post"
		,dataType : "text"
		,error:function(jqXHR,textStatus,errorThrown){
			alert(textStatus);
		}
		,success:function(data){
			resultMap = eval("("+data+")");
			var result = resultMap.result;
			if(result =="1"){
				alert("该报表已纳入文档安全管理，请确认是否安装文档安全管理软件，否则报表无法正常阅读。");
				downFromSensitive();
			}else{
				alert("该报表未纳入文档安全管理");
				downNormal();
			}
		}
	});

}
function downFromSensitive(){
	var sid ="${sid}";
	var ds = "${ds}";
	var fileName = "${title}";
	var useExcel = "${useExcel}";
	var fileKind = "csv";
	if(useExcel == "true" || useExcel == true){
		fileKind = "excel";
	}
	_header = transHeader(_header,(useExcel=="true" || useExcel==true));
	$j.ajax({
		url: "${mvcPath}/jinku/encryptFile"
		,data : "sid="+sid+"&sql="+encodeURIComponent(desSql())+"&header="+encodeURIComponent(_header)+"&ds="+ds+"&fileName="+fileName+"&fileKind="+fileKind
		,type : "post"
		,dataType : "text"
		,error:function(jqXHR,textStatus,errorThrown){
			alert(textStatus);
		}
		,success:function(resultMap){
			resultMap = eval("("+resultMap+")");
			var flag = resultMap.flag;
			if(flag=='1'){
				var downUrl1 = resultMap.downUrl;
				var params = {downUrl:resultMap.downUrl};
				window.showModalDialog('${mvcPath}/hbapp/cooperative/down.jsp',params,'dialogHeight:80px;dialogWidth:200px;resizable:No;status:No;help:No;');
				//window.open(downUrl1);
			}else{
				alert(resultMap.msg);
			}
		}
	});
}

	function transHeader(header,isOri){//把Grid用到header对象转成字符串，传给服务端
		if (typeof header == "string") {
			return header;
		}else if(header == undefined){
			return "";
		}else{
			var headObject={};//对象
			for(var i=0;i<header.length;i++){
				var _header=header[i];
				headObject[_header.dataIndex.toLowerCase()]=[];
				var nameList = headObject[_header.dataIndex.toLowerCase()];
				if(typeof _header.name == "string"){//字符串不处理
					//_headerStr+="\""+header.dataIndex.toLowerCase()+"\":\""+encodeURIComponent(encodeURIComponent(header.name))+"\"";
					nameList.push(_header.name);
				}else if (typeof _header.name == "object"){//复合表头处理，处理#rspan和#cspan替换成中文
					for(var j=0;j<_header.name.length;j++){
						var _colName=_header.name[j];
						if(!isOri){
							if(_header.name[j]=="#rspan"){
								var _ind=j;
								while(_colName=="#rspan"&&_ind>=1){
									_ind--;
									_colName=_header.name[_ind]
								}
							}else if(_header.name[j]=="#cspan"){
								var _ind=i;
								while(_colName=="#cspan"&&_ind>=1){
									_ind--;
									_colName=header[_ind].name[j];
								}
							}
						}
						nameList.push(_colName);
					}
				}
			}
			var _headerStr="{";
			//把对象转成字符串，可以使用Json2.js，先自行实现
			for(var idx in headObject){
				if(_headerStr.length>1){
					_headerStr+=",";
				}
				_headerStr+="\""+idx+"\":[";
				
				var nameList=headObject[idx];
				
				for(var j=0;j<nameList.length;j++){
					_headerStr+="\""+nameList[j]+"\",";
				}
				_headerStr=_headerStr.substring(0,_headerStr.length-1);
				_headerStr+="]";
			}
			_headerStr+="}";
			return _headerStr;
		}
	}

var _cont = $C("div");
var _mask = aihb.Util.windowMask({content:_cont});
function queryCaliber(){
	_cont.innerHTML="";
	var _iCali=$C("textarea");
	_iCali.id="ipt_cali";
	_iCali.cols="100";
	_iCali.rows="15";
	_iCali.value='${caliber}'||"";
	_cont.appendChild($CT("统计口径说明："));
	_cont.appendChild(_iCali);
	_mask.show();
}

${code}
aihb.Util.loadmask();
aihb.Util.watermark();

aihb.Util.addEventListener(window,"load",function(){
	timelineTip(${timeline});
});
</script>
<style>
.aTwi{padding: 5 px 0;width: 90%;border-bottom:1px dashed #CCC;overflow:hidden;cursor:pointer;}
.aTwi li{float:left;margin:3 5 0 0;}
</style>
</head>
<body oncopy="alert('禁止复制!');return false;">
<form method="post" action="">
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏"><img flag='1' src="${mvcPath}/resources/image/default/ns-expand.gif"></img>&nbsp;查询条件区域：</td>
	</tr></table></legend>
	<div id="dim_div">
		${dimension}
	<table align="center" width="99%">
		<tr class="dim_row_submit">
			<td><span id="tipDiv"></span></td>
			<td align="right">
				<div id="Btn">
				<input id="btn_query" type="button" class="form_button" value="查询" onClick="query()">
				<input id="btn_down" type="button" class="form_button" value="下载" onclick="down();this.disabled=true;setTimeout('document.forms[0].btn_down.disabled=false',10000);">
				<input id="btn_caliber" type="button" class="form_button" value="口径" onClick="queryCaliber()" disabled=true>
				</div>
			</td>
		</tr>
	</table>
	</div>
</fieldset>
</div>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏"><img flag='1' src="${mvcPath}/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table></legend>
	<div id="gridBtn" style="display:none;"></div>
	<div id="grid" style="display:none;"></div>
</fieldset>
</div>
<div class="divinnerfieldset" id="chartMain" style="display:none;">
<fieldset>
	<legend><table><tr>
		<td title="点击隐藏" onclick="hideTitle(document.getElementById('chart_div_img'),'chart_div')"><img id="chart_div_img" flag='1' src="${mvcPath}/resources/image/default/ns-expand.gif"></img>&nbsp;图形展现区域：</td>
		<td></td>
	</tr></table></legend>
	
	<div id="chart_div" style="display: none;">
	<div style="float: left;margin: 5px;"><select id="chart_oper" multiple="multiple" size="11" style="width:160px;"></select></div>
	<div style="float: left;" id="chart"></div>
	</div>
</fieldset>
</div>
</form>


<script>
(function($){

var dialog = new aihb.Dialog({
	el:"container"
	,height:260
	,width:430
	,title:"发评论"
});

$("#commentBtn").click(function(){
	dialog.open();
});

$("#submit").click(function(){
	$.ajax({
		url: "${mvcPath}/comment"
		,data : "state=评论&content="+encodeURIComponent($("#content").val().trim())+"&replyId=${sid}&reply=${title}"
		,type : "post"
		,dataType : "json"
		,success:function(data){
			dialog.close();
			$("#content").val("");
			renderComments(data);
		}
	});
});

function renderComments(data){
	$("#comments").empty();
	
	var res = data.comments;
	for(var i=0;i<res.length;i++){
		var li = $("<li/>").append(
			$("<ul/>",{"class":"aTwi"}
			).append(
				$("<li/>",{"style":"width:33px;height:30px;border:#bbb 1px solid;padding:2px;background-color: #fff;"}).append($("<img/>",{src:"${mvcPath}/resources/image/default/default_face.gif",width:33,height:29}))
			).append(
				$("<li/>")
				.append($("<a/>",{href:"#",style:"color: #6EAFD5;",text:res[i].user.name}))
				.append($("<span/>",{text:"："+res[i].content}))
				.append($("<div/>",{text:res[i].dateContent}))
			)
		);
		$("#comments").append(li);
	}
	$(".commentsCount").text(data.totalEl);
	$("#commentsDiv").empty().append(
		aihb.Util.paging({
			currentPage: data.currentPage
			,totalEl: data.totalEl
			,pageSize: data.pageSize
			,createAElement :function(page,text){
				return $("<a>",{
					pageNum : page
					,text:text
					,href :"javascript:void(0)"
					,click:function(){
						comments($(this).attr("pageNum"));
					}
				});
			}
		})
	);
}

$(".commentsCount").css("color","red");

function comments(page){
	$.ajax({
		url: "${mvcPath}/comment/${sid}"
		,data : "page="+page
		,type : "post"
		,dataType : "json"
		,success:function(data){
			dialog.close();
			renderComments(data);
		}
	});
}

comments(1);

})(jQuery)

if('${caliber}'!=''&&'${caliber}'!=null){
	var caliber=document.getElementById("btn_caliber");
	caliber.disabled = false;
}
//在金库审批通过以后，触发下载报表
	if('${downPass}' != null && '${downPass}' == "Y"){
		//document.getElementById("btn_down").click();
		alert("金库审批通过，请选择有数据的查询时间以后，再次点击下载");
	}
</script>

</body>
</html>