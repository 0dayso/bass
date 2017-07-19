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
	String[] gridMainInfo = (String[])request.getAttribute("gridMainInfo");
	if(gridMainInfo == null){
		gridMainInfo = new String[]{"","","","","","","","","","","","","","","","","","","",""};
	}
%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>修改主网格</title>
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
			<div class="divinnerfieldset" style="display: none">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif" alt=""></img>
									&nbsp;查询条件区域：
								</td>
							</tr>
						</table>
					</legend>
					<div id="dim_div">
						<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
							<tr class='dim_row'>
								<td class='dim_cell_title'>
									统计周期
								</td>
								<td class='dim_cell_content'>
									<select id="month" disabled="disabled" style="width: 70px">
										<option value="month">
										</option>
									</select>
								</td>
							</tr>
						</table>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="查询" onclick="query()">
									&nbsp;
									<input type="button" class="form_button" value="下载" onclick="down()">
									&nbsp;
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
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
							<tr class="dim_row">
								<td class="dim_cell_title" align="left">
									主网格编码
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1001' value='<%=gridMainInfo[0]%>' readonly="readonly">
								</td>
								<td class="dim_cell_title" align="left">
									主网格名称
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1002' value='<%=gridMainInfo[1]%>'>
								</td>
							</tr>
							<tr class="dim_row">
								<td class="dim_cell_title" align="left">
									主网格类型
								</td>
								<td class="dim_cell_content">
									<select id="f1003" name="f1003" style="width: 306px"">
										<option value="">
											全部
										</option>
										<option value="SPE" <%if("SPE".equals(gridMainInfo[2])) {%> selected <%} %>>
											特征主网格
										</option>
										<option value="ADMIN" <%if("ADMIN".equals(gridMainInfo[2])) {%> selected <%} %>>
											物理主网格
										</option>
									</select>
								</td>
								<td class="dim_cell_title" align="left">
									地市编码
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1004' value='<%=gridMainInfo[3]%>' readonly="readonly">
								</td>
							</tr>
							<tr class="dim_row">
								<td class="dim_cell_title" align="left">
									地市
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1005' value='<%=gridMainInfo[4]%>' readonly="readonly">
								</td>
								<td class="dim_cell_title" align="left">
									级别
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1006' value="3" readonly="readonly">
								</td>
							</tr>
							<tr class="dim_row">
								<td class="dim_cell_title" align="left">
									网格描述
								</td>
								<td class="dim_cell_content">
									<input type="text" size="42" name='f1007' value='<%=gridMainInfo[6]%>'>
								</td>
								<td class="dim_cell_title" align="left"></td>
								<td class="dim_cell_content"></td>
							</tr>
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

function save(){
	document.forms(0).action='${mvcPath}/hbirs/action/entGrid?method=updateGridMainInfo';
	document.forms(0).submit();
}

window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f1001'),isHoldFirst:true,sql:"select id key,name value from nwh.bureau_tree where level = 1 with ur"})
}
</script>