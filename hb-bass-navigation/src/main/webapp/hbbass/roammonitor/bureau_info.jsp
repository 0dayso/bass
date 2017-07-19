<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%
String junctionId = (String)request.getParameter("junctionId");
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>选择基站</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/tooltip/script.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"地市","dataIndex":"c1"}
	,{"name":"县市","dataIndex":"c2"}
	,{"name":"营销中心","dataIndex":"c3"}
	,{"name":"乡镇代码","dataIndex":"c4"}
	,{"name":"基站ID","dataIndex":"c5"}
	,{"name":"基站名称","dataIndex":"c6"}
];

function setTip(crtVal,options) {
 	var length = 10;
	if(!crtVal)return ""; //返回空字符串就是一种处理,如果return ;，页面上就是undefined
	var span = $C("span") ;
	crtVal = crtVal.trim();
	if(crtVal.length > length) {
		span.appendChild($CT(crtVal.substr(0,length) + "..."));
		span.onmouseover=function() {tooltip.show(crtVal);}
		span.onmouseout=tooltip.hide;
		return span;
	} else {
		span.appendChild($CT(crtVal)); //不加不行
	}
	return span;
}

function setId(dataIndex,options){
	var id = options.data[options.rowIndex].c5;
	var name = options.data[options.rowIndex].c6;
	return "<input type='checkbox' name='cbox' value=\""+id+"_"+name+"\">";
}


function genSQL(){
var wherePart = " where 1 = 1 ";
if($('f1001').value != ""){
	wherePart +=	" and area_code = '"+$('f1001').value+"'";
}
if($('f1002').value != ""){
	wherePart +=	" and county_code = '"+$('f1002').value+"'";
}
if($('f1003').value != ""){
	wherePart +=	" and zone_code = '"+$('f1003').value+"'";
}
if($('f1005').value != ""){
	wherePart +=	" and town_code = '"+$('f1005').value+"'";
}
		
var sql= sql= "select '' c0,area_name c1,county_name c2,zone_name c3,town_name c4,bureau_id c5,bureau_name c6 from nwh.dim_bureau_cfg "
		+ wherePart
		+" order by c1,c2,c3,c5 "
aihb.AjaxHelper.parseCondition()
		+" with ur ";
	//alert(sql);
	return sql;
}
function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		,isCached : false
	});
	grid.run();
}

function down(){
	var _fileName=document.title;
	aihb.AjaxHelper.down({url: "${mvcPath}/hbirs/action/jsondata?method=down&sql="+encodeURIComponent(genSQL())+"&fileName="+_fileName});
}

aihb.Util.loadmask();

window.onload=function(){
	var _headerStr="";
	
	for(var i=0;i<_header.length;i++){
		var header=_header[i];
		if(_headerStr.length>0){
			_headerStr+=",";
		}
		_headerStr+="\""+header.dataIndex.toLowerCase()+"\":\""+header.name+"\"";
	}
	_headerStr="{"+_headerStr+"}";
	
	document.forms[0].header.value=_headerStr;
}	
		</script>
	</head>
	<body>
		<form method="post" action="">
			<input type="hidden" name="header">
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
									&nbsp;查询条件区域：
								</td>
							</tr>
						</table>
					</legend>
					<div id="dim_div">
						<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0' style="display: ''">
							<tr class='dim_row'>
								<td class='dim_cell_title'>
									地市
								</td>
								<td class='dim_cell_content'>
									<select id="f1001" name="f1001"  style="width: 200px" onchange="areaCombo(1)">
										<option value="">全部</option>
									</select>
								</td>
								<td class='dim_cell_title'>
									县市
								</td>
								<td class='dim_cell_content'>
									<select id="f1002" name="f1002" style="width: 200px" onchange="areaCombo(2)">
										<option value="">全部</option>
									</select>
								</td>
								<td class='dim_cell_title'>
									区域
								</td>
								<td class='dim_cell_content'>
									<select id="f1003" name="f1003" style="width: 200px" onchange="areaCombo(3)">
										<option value="">全部</option>
									</select>
								</td>
							</tr>
							<tr class='dim_row'>
								<td class='dim_cell_title'>
									乡镇
								</td>
								<td class='dim_cell_content'>
									<select id="f1005" name="f1005" style="width: 200px">
										<option value="">全部</option>
									</select>
								</td>
								<td class='dim_cell_title'>
								</td>
								<td class='dim_cell_content'>
								</td>
								<td class='dim_cell_title'>
								</td>
								<td class='dim_cell_content'>
								</td>
							</tr>	
						</table>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="查询" onClick="query()">
									&nbsp;
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
			<div>
				<table align="center" width="97%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="导入" onclick="importRec()">
							&nbsp;
						</td>
					</tr>
				</table>
			</div>			
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'grid')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
									&nbsp;数据展现区域：
								</td>
							</tr>
						</table>
					</legend>	
					<div id="grid" style="display: none;"></div>
				</fieldset>
			</div>
			<br>
		</form>
	</body>
</html>
<script>
var win = null;
function hideTitle(el,objId){
	var obj = document.getElementById(objId);
	if(el.flag ==0)
	{
		el.src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif";
		el.flag = 1;
		el.title="点击隐藏";
		obj.style.display = "";
	}
	else
	{
		el.src="${mvcPath}/hbapp/resources/image/default/ns-collapse.gif";
		el.flag = 0;
		el.title="点击显示";
		obj.style.display = "none";			
	}
}

function importRec(){
	var ids = "";
	var n = document.getElementsByName('cbox').length;
	for(var i = 0;i<n;i++){
		if(document.getElementsByName('cbox')[i].checked){
			var v = document.getElementsByName('cbox')[i].value;
			var id = v[0];
			var name = v[1];
			if(ids == ""){
				ids += v;
			}else{
				ids += "," + v;
			}
		}
	}
	var idArr = ids.split(",");	
	if(ids == ""){
		alert("请先选择一项");
		return;
	}
	window.opener.form1.action='${mvcPath}/hbirs/action/roamMonitor?method=saveJunctionBureau&bureauParas='+ids+'&junctionId='+<%=junctionId%>;
	window.opener.form1.submit();
	window.close();
}


function areaCombo( level , sync ) {
	var _elements = [];
	var sqls = [];
	
	_elements.push($('f1001'));
	if($('f1002')){
		_elements.push($('f1002'));
		sqls.push("select id key,name value from nwh.bureau_tree where pid = '#{value}' with ur");
	}
	if($('f1003')){
		_elements.push($('f1003'));
		sqls.push("select id key,name value from nwh.bureau_tree where pid = '#{value}' with ur");
	}
	if($('f1005')){
		_elements.push($('f1005'));
		sqls.push("select id key,name value from nwh.bureau_tree where pid = '#{value}' with ur");
	}
	aihb.FormHelper.comboLink({
		elements : _elements
		,datas : sqls
		,level : level
	});
}

window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f1001'),isHoldFirst:true,sql:"select id key,name value from nwh.bureau_tree where level = 1 with ur"})
}
</script>