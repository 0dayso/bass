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
		<title>资费档案库模型管理</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[
	 {"name":"字段代码","dataIndex":"c1"}
	,{"name":"字段名称","dataIndex":"c2"}
	,{"name":"字段类型","dataIndex":"c3"}
	,{"name":"字段长度","dataIndex":"c4"}
	,{"name":"字段类别","dataIndex":"c5"}
	,{"name":"字段定义","dataIndex":"c6"}
	,{"name":"备注","dataIndex":"c7"}
];

function setId(dataIndex,options){
	var id = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}

function setLink(dataIndex,options){
	var str = options.data[options.rowIndex].c1;
	var feeName = options.data[options.rowIndex].c2;
	return "<a href='#' onclick=\"tabAdd({url:'/hbbass/fee/fee_info_detail.jsp?fee_id="+str+"',title:'资费明细'})\">"+feeName+"</a>";
}

function genSQL(){
	var sql="select FIELD_CODE c1,FIELD_NAME c2,FIELD_TYPE c3,FIELD_LENGTH c4,FIELD_CATEGORY c5,FIELD_MEAN c6,FIELD_REMARK c7 from FEE_INFO_CONFIG order by FIELD_ID asc "; 
		aihb.AjaxHelper.parseCondition()
		+"with ur";
	return sql;
}
function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,ds : "web"
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
}	
		</script>
	</head>
	<body>
		<form method="post" action="">
			<input type="hidden" name="header">
			<br>
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
					<div id="grid" style="display: '';">
						<TABLE class=grid-tab-blue cellSpacing=1 cellPadding=0 width=99% align=center border=0>
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">字段代码</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60">&nbsp;</TD>
							</TR>							
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">字段名称</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60">&nbsp;</TD>
							</TR>
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">字段类型</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60">&nbsp;</TD>
							</TR>	
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">字段长度</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60">&nbsp;</TD>
							</TR>	
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">字段类别</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60">&nbsp;</TD>
							</TR>
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">字段定义</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60">&nbsp;</TD>
							</TR>	
							<TR class=grid_row_blue>
								<TD class=grid_title_blue width="30%" align="center">字段备注</TD>
								<TD class=grid_row_cell width="30%"><input type="text" size="60">&nbsp;</TD>
							</TR>										
						</TABLE>
					</div>		
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
</script>