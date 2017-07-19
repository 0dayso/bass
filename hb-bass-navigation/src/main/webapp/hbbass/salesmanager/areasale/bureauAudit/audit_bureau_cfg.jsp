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
		<title>区域化基站审核人配置</title>
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
	,{"name":"地市ID","dataIndex":"c1_1"}
	,{"name":"一级审核人","dataIndex":"c2"}
	,{"name":"二级审核人","dataIndex":"c3"}
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
	var id = options.data[options.rowIndex].c1_2;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}


function genSQL(){
var wherePart = " where 1 = 1 ";
var city = $('f1001').value;
if(city){
	wherePart += "and cityid='"+city+"'";
}
		
var sql= sql= "select '' c0,value((select new_code from mk.bt_area where char(area_id)=cityid),0) c1_1,cityid c1_2, CITYNAME c1, value((select username||' ['||u.userid||']'||' ['||mobilephone||']' from FPF_USER_USER u where u.userid=OPERATOR),'') c2, value((select username||' ['||userid||']'||' ['||mobilephone||']' from FPF_USER_USER where userid=OPERATOR2),'') c3 from FPF_AUDIT_FLOW"
		+ wherePart
		+" order by c1,c2,c3 "
aihb.AjaxHelper.parseCondition()
		+" with ur ";
	//alert(sql);
	//document.write(sql);
	return sql;
}
function query(){
	var grid = new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		,ds : 'web'
		,isCached : false
	});
	grid.run();
}

function down(){
	var _fileName=document.title;
	aihb.AjaxHelper.down({url: "${mvcPath}/hbirs/action/jsondata?method=down&sql="+encodeURIComponent(genSQL())+"&fileName="+encodeURIComponent(_fileName)});
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
									<select id="f1001" name="f1001"  style="width: 200px" onchange="selCity()">
										<option value="">请选择</option>
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
									<input type="button" class="form_button" value="下载" onclick="down()">
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
			<br>
			<table align="center" width="97%">
				<tr class="dim_row_submit">
					<td align="right">
						<input type="button" class="form_button" value="修改" onClick="update()">
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
	document.forms(0).action='${mvcPath}/hbirs/action/town?method=deleteTownInfo&town_code='+ids;
	document.forms(0).submit();
}

function add(){
	window.location = '${mvcPath}/hbbass/town/town_info_add.jsp';
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
	document.forms[0].action='${mvcPath}/hbbass/salesmanager/areasale/bureauAudit/audit_bureau_cfg_update.jsp?city='+ids;
	document.forms[0].submit();
}

function importRec(){
	tabAdd({url:'${mvcPath}/hbbass/town/town_info_import.html?loginname=<%=request.getSession().getAttribute("loginname")%>',title:'乡镇基本信息导入'});
}


window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f1001'),isHoldFirst:true,sql:"select area_id key,area_name value from mk.bt_area with ur"});
	
	query();
};

function selCity(){
	
}
</script>