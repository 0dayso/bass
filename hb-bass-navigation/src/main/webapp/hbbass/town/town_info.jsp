<%@page contentType="text/html; charset=utf-8" deferredSyntaxAllowedAsLiteral="true" %>
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
		<title>乡镇基本信息维护</title>
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
	,{"name":"乡镇名称","dataIndex":"c5"}
	,{"name":"是否属行政区","dataIndex":"c6"}
	,{"name":"总人口数","dataIndex":"c7"}
	,{"name":"农业人口数","dataIndex":"c8"}
	,{"name":"从业人口数","dataIndex":"c9"}
	,{"name":"外出务工人口数","dataIndex":"c10"}
	,{"name":"男性人口数","dataIndex":"c11"}
	,{"name":"总户数","dataIndex":"c12"}
	,{"name":"GDP","dataIndex":"c13"}
	,{"name":"宗教信仰","dataIndex":"c14"}
	,{"name":"重点支柱产业","dataIndex":"c15"}
	,{"name":"人均纯收入","dataIndex":"c16"}
	,{"name":"竞争对手渠道数量","dataIndex":"c17"}
	,{"name":"移动渠道数量","dataIndex":"c18"}
	,{"name":"移动手机普及率","dataIndex":"c19"}
	,{"name":"通信市场占有率","dataIndex":"c20"}
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
	var id = options.data[options.rowIndex].c4;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}


function genSQL(){
var wherePart = " where 1 = 1 ";
if($('f1001').value != ""){
	wherePart +=	" and a.area_code = '"+$('f1001').value+"'";
}
if($('f1002').value != ""){
	wherePart +=	" and a.county_code = '"+$('f1002').value+"'";
}
if($('f1003').value != ""){
	wherePart +=	" and a.zone_code = '"+$('f1003').value+"'";
}
if($('f1005').value != ""){
	wherePart +=	" and a.town_code = '"+$('f1005').value+"'";
}
		
var sql= sql= "select '' c0,(tr.name) c1,(select tr.name from NWh.bureau_tree tr where tr.id  =  county_code ) c2,(select tr.name from NWh.bureau_tree tr where tr.id  =  zone_code ) c3,town_code c4,town_name c5,case when is_canton = '1' then '是' when is_canton = '0' then '否' end c6,total_usernum c7,agriculture_usernum c8,job_usernum c9,outward_usernum c10,man_usernum c11,total_familynum c12,gdp_num c13,user_failth c14,import_domain c15,income_average c16,competitive_chlnum c17,mobile_chlnum c18,tel_rate c19,telmarket_rate c20 from nmk.bureau_town_info a left join  NWh.bureau_tree tr on tr.id  = a.area_code "
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
									<input type="button" class="form_button" value="下载" onclick="down()">
									&nbsp;
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
						<input type="button" class="form_button" value="新增" onclick="add()">
						&nbsp;
						<input type="button" class="form_button" value="修改" onClick="update()">
						&nbsp;							
						<input type="button" class="form_button" value="删除" onclick="del()">
						&nbsp;
						<input type="button" class="form_button" value="导入" onclick="importRec()">
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
	document.forms(0).action='${mvcPath}/hbirs/action/town?method=getTownInfo&town_code='+ids;
	document.forms(0).submit();
}

function importRec(){
	tabAdd({url:'${mvcPath}/hbbass/town/town_info_import.html?loginname=<%=request.getSession().getAttribute("loginname")%>',title:'导入'});
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