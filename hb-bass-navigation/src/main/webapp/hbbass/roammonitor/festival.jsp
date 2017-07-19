<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>节假日配置</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/tooltip/script.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"节日ID","dataIndex":"c1"}
	,{"name":"节日名称","dataIndex":"c2"}
	,{"name":"节日开始日期","dataIndex":"c3"}
	,{"name":"节日结束日期","dataIndex":"c4"}
	,{"name":"节日年份","dataIndex":"c5"}
];
function setId(dataIndex,options){
	var id = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}
function genSQL(){
var wherePart = " where 1 = 1 ";
var fStartDate = $('fStartDate').value;
var fName = $('fName').value;
if(fStartDate){
	wherePart += " and char(start_date) like '%" + fStartDate + "%'";
}
if(fName){
	wherePart += " and feast_name like '%" + fName + "%'";
}
var sql = "select '' c0,feast_id c1, feast_name c2, start_date c3, end_date c4, feast_year c5 from nmk.dim_feast_day "
		+ wherePart
		+ " order by c3"
		+ " with ur ";
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
									节日日期
								</td>
								<td class='dim_cell_content'>
									<input type="text" id="fStartDate">
								</td>
								<td class='dim_cell_title'>
									节日名称
								</td>
								<td class='dim_cell_content'>
									<input type="text" id="fName">
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
									<input type="button" class="form_button" value="下载" onclick="down()">
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
							<input type="button" class="form_button" value="新增" onclick="add()">
							&nbsp;
							<input type="button" class="form_button" value="修改" onClick="update()">
							&nbsp;							
							<input type="button" class="form_button" value="删除" onclick="del()">
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
//新增
function add(){
	window.location = '/hbbass/roammonitor/festival_add.jsp';
}
//修改
function update(){
	var ids = "";
	var n = document.getElementsByName('cbox').length;
	for(var i = 0;i<n;i++){
		if(document.getElementsByName('cbox')[i].checked){
			var id = document.getElementsByName('cbox')[i].value;
			if(ids == ""){
				ids += id;
			}else{
				ids += "," + id;
			}
		}
	}
	var idArr = ids.split(",");	
	if(ids == ""){
		alert("请先选择一项");
		return;
	}		
	if(idArr.length > 1){
		alert("只能选择一项进行修改");
		return;
	}
	document.forms(0).action='${mvcPath}/hbirs/action/roamMonitor?method=getFestival&fId='+ids;
	document.forms(0).submit();
}
//删除
function del(){
	if(!confirm("确定要删除吗?")){
		return;
	}
	var ids = "";
	var n = document.getElementsByName('cbox').length;
	for(var i = 0;i<n;i++){
		if(document.getElementsByName('cbox')[i].checked){
			var id = document.getElementsByName('cbox')[i].value;
			if(ids == ""){
				ids += id;
			}else{
				ids += "," + id;
			}
		}
	}
	var idArr = ids.split(",");	
	if(ids == ""){
		alert("请先选择一项");
		return;
	}		
	var sql = "delete from NMK.FESTIVAL_CFG where FESTIVAL_ID in (" + ids + ")";
	//alert(sql);
	var ajax = new aihb.Ajax({
								url : "${mvcPath}/hbirs/action/sqlExec"
								,parameters : "sqls="+sql
								,loadmask : true
								,callback : function(xmlrequest){
									//alert(xmlrequest.responseText);
									query();
								}
							});
	ajax.request();									
}
</script>