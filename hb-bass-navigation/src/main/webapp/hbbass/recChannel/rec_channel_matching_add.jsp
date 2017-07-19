<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%%>
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>新增业务受理渠道适配参数</title>
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
aihb.Util.watermark();
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
							<tr class="grid_row_blue">
								<td class="grid_title_blue" width="40%" align="center">
									业务编码
								</td>
								<td class="grid_row_cell" width="60%">
									<input type="text" size="42" id="f01" name="f01">
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									业务名称
								</td>
								<td class="grid_row_cell">
									<input type="text" size="42" id="f02" name="f02">
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									实体渠道适配级别
								</td>
								<td class="grid_row_cell">
									<select id="f03" name="f03" style="width: 305px">
										<option value="优先适配">优先适配</option>
										<option value="适配">适配</option>
										<option value="不适配">不适配</option>
									</select>
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									ivr热线适配级别
								</td>
								<td class="grid_row_cell">
									<select id="f04" name="f04" style="width: 305px">
										<option value="优先适配">优先适配</option>
										<option value="适配">适配</option>
										<option value="不适配">不适配</option>
									</select>
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									10086人工热线适配级别
								</td>
								<td class="grid_row_cell">
									<select id="f05" name="f05" style="width: 305px">
										<option value="优先适配">优先适配</option>
										<option value="适配">适配</option>
										<option value="不适配">不适配</option>
									</select>
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									网站适配级别
								</td>
								<td class="grid_row_cell">
									<select id="f06" name="f06" style="width: 305px">
										<option value="优先适配">优先适配</option>
										<option value="适配">适配</option>
										<option value="不适配">不适配</option>
									</select>
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									外呼适配级别
								</td>
								<td class="grid_row_cell">
									<select id="f07" name="f07" style="width: 305px">
										<option value="优先适配">优先适配</option>
										<option value="适配">适配</option>
										<option value="不适配">不适配</option>
									</select>
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									短信服务厅适配级别
								</td>
								<td class="grid_row_cell">
									<select id="f08" name="f08" style="width: 305px">
										<option value="优先适配">优先适配</option>
										<option value="适配">适配</option>
										<option value="不适配">不适配</option>
									</select>
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									掌上服务厅渠道适配级别
								</td>
								<td class="grid_row_cell">
									<select id="f09" name="f09" style="width: 305px">
										<option value="优先适配">优先适配</option>
										<option value="适配">适配</option>
										<option value="不适配">不适配</option>
									</select>
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									自助终端适配级别
								</td>
								<td class="grid_row_cell">
									<select id="f10" name="f10" style="width: 305px">
										<option value="优先适配">优先适配</option>
										<option value="适配">适配</option>
										<option value="不适配">不适配</option>
									</select>
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									空中充值适配级别
								</td>
								<td class="grid_row_cell">
									<select id="f11" name="f11" style="width: 305px">
										<option value="优先适配">优先适配</option>
										<option value="适配">适配</option>
										<option value="不适配">不适配</option>
									</select>
								</td>
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
	if(el.flag ==0){
		el.src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif";
		el.flag = 1;
		el.title="点击隐藏";
		obj.style.display = "";
	}
	else{
		el.src="${mvcPath}/hbapp/resources/image/default/ns-collapse.gif";
		el.flag = 0;
		el.title="点击显示";
		obj.style.display = "none";			
	}
}
function save(){
	if($('f01').value == ""){
		alert('业务编码不能为空');
		return;
	}
	document.forms(0).action='${mvcPath}/hbirs/action/recChannel?method=saveRecChannelMatch';
	document.forms(0).submit();
}
</script>