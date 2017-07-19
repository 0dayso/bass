<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%String zb_code=request.getParameter("zb_code").toString(); %>
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
	{"name":"指标代码","dataIndex":"zb_code","cellStyle":"grid_row_cell_text","cellFunc":""}
	,{"name":"指标名称","dataIndex":"zb_name","cellStyle":"grid_row_cell_text","cellFunc":""}
	,{"name":"天阈值","dataIndex":"t_threshold","cellStyle":"grid_row_cell_text","cellFunc":""}
	,{"name":"月阈值","dataIndex":"m_threshold","cellStyle":"grid_row_cell_text","cellFunc":""}
	,{"name":"年阈值","dataIndex":"y_threshold","cellStyle":"grid_row_cell_text","cellFunc":""}
	,{"name":"操作","dataIndex":"oper","cellStyle":"grid_row_cell","cellFunc" : function(value,options) {
			var _span = $C("span");
			var _editlink = $C("a");
			_editlink.appendChild($CT("编辑"));
			_editlink.href="javascript:void(0)";
			_editlink.onclick = function() {
				createFormPanel([
					{label : "指标代码：",type : "text",value : options.record.zb_code,id : "temp_zb_code",disabled:true}
					,{label : "指标名称：",type : "text",value : options.record.zb_name,id : "temp_zb_name",disabled:true}
					,{label : "天阈值",type : "text",value : options.record.t_threshold,id : "temp_t_threshold"}
					,{label : "月阈值",type : "text",value : options.record.m_threshold,id : "temp_m_threshold"}
					,{label : "年阈值",type : "text",value : options.record.y_threshold,id : "temp_y_threshold"}
					,{label : "",type : "button",value : "保存",className : "form_button_short"
						,onclick : function(){
							if(!confirm("确认要修改吗?"))
								return;
							
							var _sql=encodeURIComponent("update dim_kpi_threshold set t_threshold="+$("temp_t_threshold").value+", m_threshold="+$("temp_m_threshold").value+",y_threshold="+$("temp_y_threshold").value+" where zb_code='"+$("temp_zb_code").value+"'");
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
	var zb_code='<%=zb_code%>';
	var sql = "select ZB_CODE,ZB_NAME,t_threshold,m_threshold,y_threshold,'编辑' oper from dim_kpi_threshold where zb_code='"+zb_code+"' with ur";
	
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

	</script>
  </head>
  <body>
  	<div id="grid" style="display:none;"></div>
  </body>
</html>
