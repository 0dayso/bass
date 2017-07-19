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
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
	<script type="text/javascript">
//aihb.URL="/hbapp";
window.onload=function(){
	query();
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
	{"name":"指标代码","dataIndex":"zb_code","cellStyle":"grid_row_cell_text","cellFunc":"edit"}
	,{"name":"指标名称","dataIndex":"zb_name","cellStyle":"grid_row_cell_text","cellFunc":""}
	,{"name":"酬金标准","dataIndex":"reward","cellStyle":"grid_row_cell_text","cellFunc":""}
	,{"name":"操作","dataIndex":"oper","cellStyle":"grid_row_cell","cellFunc" : function(value,options) {
			var _span = $C("span");
			var _editlink = $C("a");
			_editlink.appendChild($CT("编辑"));
			_editlink.href="javascript:void(0)";
			_editlink.onclick = function() {
				createFormPanel([
					{label : "指标代码：",type : "text",value : options.record.zb_code,id : "temp_name_01",disabled:true}
					,{label : "指标名称：",cols:45,rows:2,eleType : "textarea",value : options.record.zb_name,id : "temp_desc_01",disabled:true}
					,{label : "酬金标准",type : "text",value : options.record.reward,id : "temp_id_01"}
					,{label : "备注：",cols:45,rows:2,eleType : "textarea",value : options.record.remark||'',id : "temp_contacts_01"}
					,{label : "",type : "button",value : "保存",className : "form_button_short"
						,onclick : function(){
							if(!confirm("确认要修改吗?"))
								return;
							var _sql=encodeURIComponent("update nmk.chl_reward_cfg set REWARD="+$("temp_id_01").value+", remark='"+$("temp_contacts_01").value+"' where zb_code='"+$("temp_name_01").value+"'");
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
function query(){
	var sql = "select ZB_CODE,ZB_NAME,REWARD,remark,'编辑' oper from nmk.chl_reward_cfg with ur";
	
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
function render(container,appName){
	var sql = "select zb_code,name,app_name,area_code,value(exp,'')exp,a.sort from kpi_audit a,FPF_IRS_INDICATOR where zb_code=id and appname=app_name and pid="+id+" order by sort with ur";
	
	var ajax = new aihb.Ajax({
		url : "${mvcPath}/hbirs/action/jsondata?method=query"
		,parameters : "sql="+encodeURIComponent(sql) + "&ds=web"+"&isCached=false"
		,loadmask : true
		,callback : function(xmlrequest){
			//$("grid").style.display="";
			var res = {}
			try{
				eval("res="+xmlrequest.responseText);
				debugger;
			}catch(e){debugger;}
			
			var addBtn=$C("input");
			addBtn.type="button";
			addBtn.className="form_button_short";
			addBtn.style.width="55px"
			addBtn.value="增加指标";
			var addHidPiece=$C("div");
			addHidPiece.style.display="none";
			
			container.appendChild(addBtn);
			
			
			
			var proBtn=$C("input");
			proBtn.type="button";
			proBtn.className="form_button_short";
			proBtn.style.width="55px"
			proBtn.value="查看文本";
			container.appendChild($CT(" "));
			container.appendChild(proBtn);
			proBtn.onclick=function(){
				process();
			}
			
			var pushBtn=$C("input");
			pushBtn.type="button";
			pushBtn.className="form_button_short";
			pushBtn.style.width="55px"
			pushBtn.value="立即推送";
			container.appendChild($CT(" "));
			container.appendChild(pushBtn);
			pushBtn.onclick=function(){
				var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/kpiCustomize?method=push"
					,parameters : "pid="+id
					,callback : function(xmlrequest){
						alert(xmlrequest.responseText);
					}
				});
				ajax.request();
			}
			
			
			container.appendChild(addHidPiece);
			addBtn.onclick=function(){
				if(addHidPiece.childNodes.length==0)
					auditPiece({container:addHidPiece,appNameDefault:appName});
				if(addHidPiece.style.display=="none"){
					addHidPiece.style.display="";
				}else{
					addHidPiece.style.display="none";
				}
			}
			
			for(var i=0;i<res.length;i++){
				
				var _obj=res[i];
				var _hidPiece=$C("div");
				_hidPiece.style.display="none";
				_obj.container=_hidPiece;
				var _img1=$C("img");
				_obj.delBtn=_img1
				_obj.appNameDefault=appName;
				auditPiece(_obj);
				var _piece=$C("div");
				var _disPiece=$C("span");
				//_disPiece.appendChild();
				var _img=$C("img");
				_img.src="${mvcPath}/hbapp/resources/image/default/right_2.gif";
				_disPiece.appendChild(_img);
				_disPiece.appendChild($CT(_obj.zb_code+" "+_obj.name+" "));
				
				
				_img1.src="${mvcPath}/hbapp/resources/image/default/delete.gif";
				_img1.title="删除";
				_img1.style.cursor="hand";
				
				_disPiece.onclick=function(_hidPiece,_img){return function(){
					if(_hidPiece.style.display=="none"){
						_hidPiece.style.display="";
						_img.src="${mvcPath}/hbapp/resources/image/default/expand.gif";
						_img.width="12"
						_img.height="11";
					}else{
						_hidPiece.style.display="none";
						_img.src="${mvcPath}/hbapp/resources/image/default/right_2.gif";
						_img.width="15"
						_img.height="15";
					}
				};}(_hidPiece,_img);
				_disPiece.style.cursor="hand";
				_piece.appendChild(_disPiece);
				_piece.appendChild(_img1);
				_piece.appendChild(_hidPiece);
				
				container.appendChild(_piece);
				
			}
			
			
		}
	});
	ajax.request();
}

//var _cont = $C("div");
//var _mask = aihb.Util.windowMask({content:_cont});

function auditPiece(options){
	options=options||{};
	var _div=$C("div");
	_div.style.cssText="border:1px solid #cccccc;padding:2px;margin-bottom:8px;margin-top:2px;"
	var _table=$C("table");
	_div.appendChild(_table);
	options.container.appendChild(_div);
	var _tr=_table.insertRow();
	
	var _td=$C("td");
	_td.width="68";
	_td.appendChild($CT("指标应用："));
	_tr.appendChild(_td);
	
	var _td1=$C("td");
	_td1.colSpan=2;
	_tr.appendChild(_td1);
	
	_tr=_table.insertRow();
	_td=$C("td");
	_td.appendChild($CT("指标名称："));
	_tr.appendChild(_td);
	_td=$C("td");
	_td.colSpan=2;
	var iptZb=$C("select");
	iptZb.defaultKey=options.zb_code||"";
	_td.appendChild(iptZb);
	_tr.appendChild(_td);
	
	_tr=_table.insertRow();
	
	_td=$C("td");
	_td.vAlign="top";
	_td.appendChild($CT("稽核公式："));
	_tr.appendChild(_td);
	_td=$C("td");
	_td.colSpan=2;
	_tr.appendChild(_td);
	var iptExp=$C("textarea");
	iptExp.cols=50;
	iptExp.rows=2;
	iptExp.value=options.exp||"";
	_td.appendChild(iptExp);
	_td.appendChild($C("br"));
	_td.appendChild($CT("例:(同比>0.05 or 同比<=-0.05) and (环比<=-0.03 or 年同比 <=0)"));
	
	_tr=_table.insertRow();
	_td=$C("td");
	_td.appendChild($CT("地域选择："));
	_tr.appendChild(_td);
	_td=$C("td");
	_tr.appendChild(_td);
	var iptArea=$C("<select>");
	//debugger
	if(cityId!="0"){
		var cityObj=aihb.Constants.getArea(cityId);
		iptArea[0]=new Option(cityObj.cityName,cityCode);
	}else{
		var areas=aihb.Constants.area;
		for(var m=0;m<areas.length;m++){
			iptArea[m]=new Option(areas[m].cityName,areas[m].cityCode);
			if(!options.area_code&&areas[m].cityId==cityId ){
				iptArea[m].selected=true;
			}else if (options.area_code==areas[m].cityCode){
				iptArea[m].selected=true;
			}
		}
	}
	//iptArea.value=options.area_code||"HB";
	_td.appendChild(iptArea);
	
	_tr=_table.insertRow();
	_td=$C("td");
	_td.appendChild($CT("排序："));
	_tr.appendChild(_td);
	_td=$C("td");
	var _ipt = $C("input");
	_ipt.type="text";
	_ipt.value = options.sort || "0";
	_ipt.style.width = "20px";
	_ipt.onblur = function() {
		var pattern = /^\d{1,2}$/;
		if(this.value.match(pattern) == null) {
			alert("排序值只能是1-2位数字");
			this.value = "0";
		}
	}
	_td.appendChild(_ipt);
	_tr.appendChild(_td);
	
	
	var iptAppName=kpiSelect.select({container: _td1,kpiContainer:iptZb,appNameDefault:options.appNameDefault});
	iptAppName.onmouseover = function(){this.setCapture();};   
    iptAppName.onmouseout = function(){this.releaseCapture();};
    iptAppName.onclick = function(){alert("不能选择");};  
	//alert(_table.outerHTML);
	var iBtn=$C("input");
	iBtn.type="button";
	iBtn.className="form_button_short";
	iBtn.style.width="55px";
	iBtn.value="保存指标";
	
	iBtn.onclick=function(iptAppName,iptZb,iptArea,iptExp,_ipt){
		return function(){
			var ajax = new aihb.Ajax({
				url : "${mvcPath}/hbirs/action/kpiCustomize?method=saveAudit"
				,parameters : "pid="+id+"&appName="+iptAppName.value+"&zbCode="+iptZb.value+"&areaCode="+iptArea.value+"&exp="+encodeURIComponent(iptExp.value) + "&sort=" + encodeURIComponent(_ipt.value)
				,callback : function(xmlrequest){
					alert(xmlrequest.responseText);
					//location.reload();
					
					_cont.innerHTML="";
					var _obj=$C("div");
					_cont.appendChild(_obj);
					render(_obj,options.appNameDefault);
					_mask.style.display="";
				}
			});
			ajax.request();
		}
	}(iptAppName,iptZb,iptArea,iptExp,_ipt);
	
	
	if(options.delBtn){
		options.delBtn.onclick=function(iptAppName,iptZb){
			
			return function(){
				if(confirm("确定？")){
					var ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/kpiCustomize?method=deleteAudit"
						,parameters : "pid="+id+"&appName="+iptAppName.value+"&zbCode="+iptZb.value
						,callback : function(xmlrequest){
							alert(xmlrequest.responseText);
							//location.reload();
							_cont.innerHTML="";
							var _obj=$C("div");
							_cont.appendChild(_obj);
							render(_obj,options.appNameDefault);
							_mask.style.display="";
						}
					});
					ajax.request();
				}
			}
		}(iptAppName,iptZb)
	}
	
	_td=$C("td");
	_td.align="right";
	_tr.appendChild(_td);
	_td.appendChild(iBtn);
	//options.container.appendChild(iBtn);
}

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
