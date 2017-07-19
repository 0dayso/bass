<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css"/>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/xtheme-slate.css" />
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
    <script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css"/>
	<script type="text/javascript">
//aihb.URL="/hbapp";
window.onload=function(){
	query("1");
}
function abb(value,options) {
	var obj=$C("span");
	if(value.length>25){
		obj.appendChild($CT(value.substring(0,24)+"..."));
		obj.title=value.replace(/;/g,"\n");
	}else{
		obj.appendChild($CT(value));
	}
	return obj;
}
var _header=[
	{"name":"指标代码","dataIndex":"zb_code","cellStyle":"grid_row_cell_text","cellFunc":""}
	,{"name":"指标名称","dataIndex":"zb_name","cellStyle":"grid_row_cell_text","cellFunc":""}
	,{"name":"指标说明","dataIndex":"remark","cellStyle":"grid_row_cell_text","cellFunc":""}
	,{"name":"阀值","dataIndex":"level","cellStyle":"grid_row_cell_text","cellFunc":"aihb.Util.numberFormat"}
	,{"name":"权重","dataIndex":"weight","cellFunc":"aihb.Util.numberFormat","cellStyle":"grid_row_cell_number"}
	,{"name":"操作","dataIndex":"oper","cellStyle":"grid_row_cell","cellFunc" : function(value,options) {
			var _span = $C("span");
			var _editlink = $C("a");
			_editlink.appendChild($CT("编辑"));
			_editlink.href="javascript:void(0)";
			_editlink.onclick = function() {
				createFormPanel([
					{label : "指标代码：",type : "text",value : options.record.zb_code,id : "temp_name_01",disabled:true}
					,{label : "指标名称：",cols:45,rows:2,eleType : "textarea",value : options.record.zb_name,id : "temp_desc_01",disabled:true}
					,{label : "阀值",type : "text",value : options.record.level,id : "temp_id_01"}
					,{label : "权重：",type : "text",value : options.record.weight,id : "temp_contacts_01"}
					,{label : "备注：",cols:45,rows:2,eleType : "textarea",value : options.record.remark,id : "temp_remark_01"}
					,{label : "",type : "button",value : "保存",className : "form_button_short"
						,onclick : function(){
							if(!confirm("确认要修改吗?"))
								return;
							var _sql=encodeURIComponent("update nmk.chl_alert_cfg set level="+$("temp_id_01").value+", weight="+$("temp_contacts_01").value+",remark='"+$("temp_remark_01").value+"' where zb_code='"+$("temp_name_01").value+"'");
							var ajax = new aihb.Ajax({
								url : "${mvcPath}/hbirs/action/sqlExec"
								,parameters : "sqls="+_sql
								,callback : function(xmlrequest){
									alert(xmlrequest.responseText);
									location.reload();
								}
							});
							ajax.request();
						}
					}
				]);
			}
			
			var _dellink = $C("a");
			_dellink.appendChild($CT("删除告警任务"));
			_dellink.href="javascript:void(0)";
			_dellink.onclick =function() {
				if(!confirm("确认要删除本条信息吗？"))
					return;
				var ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/kpiCustomize?method=deleteAuditJob"
						,parameters : "id=" + encodeURIComponent(options.record.ids)
						,callback : function(xmlrequest){
							alert(xmlrequest.responseText);
							location.reload();
						}
				});
				ajax.request();
			}
			
			
			var _div=$C("a");
			_div.sid=options.record.ids;
			_div.appName=options.record.app_name;
			_div.href="javascript:void(0)";
			_div.title="告警指标编辑";
			_div.appendChild($CT("该告警任务指标编辑"));
			_div.onclick=function(){
				_cont.innerHTML="";
				id=this.sid;
				var _obj=$C("div");
				_cont.appendChild(_obj);
				render(_obj,this.appName);
				_mask.style.display="";
				//tabAdd({title:this.title,url:"${mvcPath}/hbapp/kpiportal/customize/audit.htm?id="+this.sid});
			}
			
			//_span.appendChild(_div);
			//_span.appendChild($CT("  "));
			_span.appendChild(_editlink);
			//_span.appendChild($CT("  "));
			//_span.appendChild(_dellink);
			return _span;
			
	}}
];
<% User user = (User)session.getAttribute("user");%>
var loginname="<%=user.getId()%>";
var cityId="<%=user.getCityId()%>";
function query(id){
	var sql = "select ZB_CODE,ZB_NAME,LEVEL,WEIGHT,remark,'编辑' oper from nmk.chl_alert_cfg where type='"+id+"' with ur";
	
	var grid = new aihb.SimpleGrid({
		header:_header
		,sql: sql
		,isCached : false
	});
	grid.run();
}
var _cont = $C("div");
var _mask = aihb.Util.windowMask({content:_cont});

function createFormPanel(options) {
	_cont.innerHTML="";
	
	for(var indx in options) {
		if(options.hasOwnProperty(indx)) {
			var currentObj = options[indx];
			var formElement;
			if(currentObj.el) {
				formElement = currentObj.el;
			} else {
			
				if(!currentObj.eleType) {
					formElement = $C("input");
				} else {
					formElement = $C(currentObj.eleType); //textarea ,select , div等只有eleType
				}
				for(var prop in currentObj) {
					if(prop != "eleType" && prop != "label")
						formElement[prop] = currentObj[prop];
				}
			}
			_cont.appendChild($CT(currentObj.label));
			_cont.appendChild(formElement);
			_cont.appendChild($C("BR"));
		}
		
	}
	_mask.style.display="";
}

function createFormPanel1() {
	createFormPanel([
	{label : "名称：",type : "text",id : "ipt_name"}
	,{label : "描述：",eleType : "textarea",cols:45,rows:2,id : "ipt_desc"}
	,{label : "号码：",eleType : "textarea",id : "ipt_contacts",cols:45,rows:3}
	,{label : "  ",eleType : "div",innerHTML : "使用‘;’分隔多个手机号码"}
	,{label : "指标应用：",el : kpiSelect.appNameSelection({id:"sel_app_name"})}
	,
	{	label : "",type : "button",value : "保存",className : "form_button_short"
		,onclick : function(){
			if($("ipt_name").value.length>0){
				var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/kpiCustomize?method=save"
					,parameters : "name="+encodeURIComponent($("ipt_name").value)+"&desc="+encodeURIComponent($("ipt_desc").value)+"&appName="+$("sel_app_name").value+"&contacts="+$("ipt_contacts").value
					,callback : function(xmlrequest){
						alert(xmlrequest.responseText);
						location.reload();
					}
				});
				ajax.request();
			}else{
				alert("名称必须填写？");
			}
		}
	}
]);
}

function mapping(val,options){
	var appNames=kpiSelect.appNames;
	for(var i=0;i<appNames.length;i++){
		if(appNames[i][0]==val)
			return appNames[i][1];
	}
}

function edit(val,options){
	var _div=$C("a");
	_div.sid=options.record.ids;
	_div.appName=options.record.app_name;
	_div.href="javascript:void(0)";
	_div.title=val;
	_div.appendChild($CT(val));
	_div.onclick=function(){
		_cont.innerHTML="";
		id=this.sid;
		var _obj=$C("div");
		_cont.appendChild(_obj);
		render(_obj,this.appName);
		_mask.style.display="";
		//tabAdd({title:this.title,url:"${mvcPath}/hbapp/kpiportal/customize/audit.htm?id="+this.sid});
	}
	return _div
}

/*================   audit======================*/
var id=0;

function add(){
	if(_cont.innerHTML.length==0){
		auditPiece({container:_cont})
	}
	_mask.style.display="";
}

function process(){
	var ajax = new aihb.Ajax({
		url : "${mvcPath}/hbirs/action/kpiCustomize?method=text"
		,parameters : "pid="+id
		,callback : function(xmlrequest){
			alert(xmlrequest.responseText);
		}
	});
	ajax.request();
}
	</script>
  </head>
  <body>
		<div id="grid" style="display:none;"></div>
  </body>
</html>
