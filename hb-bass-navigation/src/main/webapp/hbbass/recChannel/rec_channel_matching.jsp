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
		<title>业务受理渠道适配</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/tooltip/script.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript">
var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"业务编码","dataIndex":"c1"}
	,{"name":"业务名称","dataIndex":"c2"}
	,{"name":"实体渠道适配级别","dataIndex":"c3"}
	,{"name":"ivr热线适配级别","dataIndex":"c4"}
	,{"name":"10086人工热线适配级别","dataIndex":"c5"}
	,{"name":"网站适配级别","dataIndex":"c6"}
	,{"name":"外呼适配级别","dataIndex":"c7"}
	,{"name":"短信服务厅适配级别","dataIndex":"c8"}
	,{"name":"掌上服务厅渠道适配级别","dataIndex":"c9"}
	,{"name":"自助终端适配级别","dataIndex":"c10"}
	,{"name":"空中充值适配级别","dataIndex":"c11"}
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
	var id = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}
function genSQL(){
	var wherePart = " where 1 = 1 ";
	if($('f01').value != ""){
		wherePart +=	" and business_code = '"+$('f01').value+"'";
	}
	if($('f02').value != ""){
		wherePart +=	" and business_name = '"+$('f02').value+"'";
	}
	var sql= sql= "select '' c0,BUSINESS_CODE c1 , BUSINESS_NAME c2 , BSACHAL_MATCH_LEVEL c3 , IVR_MATCH_LEVEL c4 , BSACKF_MATCH_LEVEL c5 , BSACNB_MATCH_LEVEL c6 , OUTCALL_MATCH_LEVEL c7 , BSACSMS_MATCH_LEVEL c8 , WAP_MATCH_LEVEL c9 , BSACATSV_MATCH_LEVEL c10 , BSACAIR_MATCH_LEVEL c11 from NMK.DIM_BUSINESS_REC_CHANNEL_MATCHING"
			+ wherePart
			+" order by c1,c2"
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
									业务编码
								</td>
								<td class='dim_cell_content'>
									<input id="f01">
								</td>
								<td class='dim_cell_title'>
									业务名称
								</td>
								<td class='dim_cell_content'>
									<input id="f02">
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
	if(idArr.length > 1){
		alert("只能选择一项进行修改");
		return;
	}
	document.forms(0).action='${mvcPath}/hbirs/action/recChannel?method=deleteRecChannelMatch&business_code='+ids;
	document.forms(0).submit();
}
function add(){
	window.location = '${mvcPath}/hbbass/recChannel/rec_channel_matching_add.jsp';
}
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
	document.forms(0).action='${mvcPath}/hbirs/action/recChannel?method=getRecChannelMatch&business_code='+ids;
	document.forms(0).submit();
}
</script>