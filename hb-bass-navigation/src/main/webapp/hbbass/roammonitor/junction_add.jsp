<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>新增交通枢纽</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[];
function genSQL(){
	var sql="" 
		aihb.AjaxHelper.parseCondition()
		+"with ur";
	return sql;
}
function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
	});
	grid.run();
}
function down(){
	var _fileName=document.title;
	aihb.AjaxHelper.down({url: "${mvcPath}/hbirs/action/jsondata?method=down&sql="+genSQL()+"&fileName="+_fileName});
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
	//query();
}	
		</script>
	</head>
	<body>
		<form method="post" action="" name="form1">
			<input type="hidden" name="header">
			<br>
			<div class="divinnerfieldset">
				<td></td>
				<tr></tr>
				<table></table>
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'grid')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif" alt=""></img>
									&nbsp;数据展现区域：
								</td>
							</tr>
						</table>
					</legend>
					<div id="grid" style="display: '';">
						<table class="grid-tab-blue" cellspacing="1" cellpadding="0" width="99%" align="center" border="0">
							<tbody>
							<tr class="dim_row">
								<td class="dim_cell_title" width="50%" align="center">交通枢纽名称</td>
								<td class="dim_cell_content" align="center" width="50%">
									<input type="text" name="f1001">
								</td>
							</tr>	
							<tr class="dim_row">
								<td class="dim_cell_title" align="center">交通枢纽类型</td>
								<td class="dim_cell_content" align="center">
									<input type="text" name="f1002">
								</td>
							</tr>	
							</tbody>	
						</table>
						<br>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="center">
									<input type="button" class="form_button" value="保存" onclick="save()">
									&nbsp;
									<input type="button" class="form_button" value="返回" onclick="history.back();">
									&nbsp;
								</td>
							</tr>
						</table>						
					</div>				
				</fieldset>
				<br>
			</div>
			<br>
		</form>
	</body>
</html>
<script type="text/javascript">
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
function addBureau(){
	var rv = window.open('/hbbass/roammonitor/bureau_info.jsp','_addBureau');
	//alert(rv[0]);
}
function impBureau(msg){
	//alert(msg);
	var rows = msg.split(",");
	//alert(rows[0]);
	if(rows){
		for(var i = 0;i<rows.length;i++){
			addNameTR(rows[i]);
		}
	}
}
function addNameTR(rowData) {
	var row = rowData.split("_");
    var table = document.getElementById("tableBody");   

    var tr = document.createElement('tr');   
    tr.id = "nameTr";
    tr.className = "dim_row";
    table.appendChild(tr);   

    var td1 = document.createElement('td');   
    td1.className = "dim_cell_title";
    td1.align = "center";
    td1.style.display = "none";
    tr.appendChild(td1);   
    td1.appendChild(document.createTextNode(row[0]));   

    var td2 = document.createElement('td');   
    td2.className = "dim_cell_content"; 
    td2.align = "center";
    tr.appendChild(td2);   
    td2.appendChild(document.createTextNode(row[1]));   
}
function save(){
	document.forms(0).action='${mvcPath}/hbirs/action/roamMonitor?method=saveJunction';
	document.forms(0).submit();
}
window.onload=function(){
	//aihb.FormHelper.fillSelectWrapper({element:$('f1004'),isHoldFirst:false,sql:"select bureau_id key,bureau_name value from nwh.dim_bureau_cfg fetch first 20 rows only with ur"})
}
</script>