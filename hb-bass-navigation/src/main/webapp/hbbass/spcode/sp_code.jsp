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
		<title>SP企业代码信息</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/tooltip/script.js"></script>
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/tooltip/style.css" />
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<script type="text/javascript"><!--
var _header=[
	{"name":"选择","dataIndex":"c0",cellFunc:"setId",cellStyle:"grid_row_cell"}
	,{"name":"SP企业代码","dataIndex":"c1"}
	,{"name":"SP企业名称","dataIndex":"c2"}
	,{"name":"服务代码","dataIndex":"c3"}
	,{"name":"SP业务类型","dataIndex":"c4"}
	,{"name":"SP结算类型","dataIndex":"c5"}
	,{"name":"自有业务标志","dataIndex":"c6"}
	,{"name":"是否参与结算","dataIndex":"c7"}
];
function setId(dataIndex,options){
	var id = options.data[options.rowIndex].c1;
	return "<input type='checkbox' name='cbox' value=\""+id+"\">";
}
function genSQL(){
var wherePart = " where 1 = 1 ";
if($('f1001').value != ""){
	wherePart +=	" and a.sp_busi_type = '"+$('f1001').value+"'";
}
if($('f1002').value != ""){
	wherePart +=	" and a.sp_type = '"+$('f1002').value+"'";
}
if($('f1003').value != ""){
	wherePart +=	" and a.sp_sett_flag = '"+$('f1003').value+"'";
}
if($('f1004').value != ""){
	wherePart +=	" and a.owner_flag = '"+$('f1004').value+"'";
}
var sql= sql= "select '选择' c0,a.sp_code c1,value(a.sp_name,'未知') c2,value(a.serv_code,'-') c3, value(b.sp_busi_name,'未知') c4,value(c.sp_type_name,'未知') c5,value(d.owner_name,'未知') c6,  case when sp_sett_flag ='Y' then  '参与结算' else '不参与结算' end  c7  from nwh.dim_sett_sp_code a  left join nwh.vdim_sp_busi_type b on value(a.sp_busi_type,'-1') = b.sp_busi_type left join nwh.vdim_sp_type c on value(a.sp_type,'99') = c.sp_type left join nwh.vdim_sp_owner_flag d on value(a.owner_flag,'-1') = d.owner_flag "
		+ wherePart
		+" "
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
	aihb.AjaxHelper.down({
		sql : genSQL()
		,header : _header
	});
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
		--></script>
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
									SP业务类型
								</td>
								<td class='dim_cell_content'>
									<select id="f1001" name="f1001"  style="width: 200px">
										<option value="">全部</option>
									</select>
								</td>
								<td class='dim_cell_title'>
									SP结算类型
								</td>
								<td class='dim_cell_content'>
									<select id="f1002" name="f1002" style="width: 200px">
										<option value="">全部</option>
									</select>
								</td>
								<td class='dim_cell_title'>
									是否参与结算标识
								</td>
								<td class='dim_cell_content'>
									<select id="f1003" name="f1003" style="width: 200px">
										<option value="">全部</option>
										<option value="Y">是</option>
										<option value="N">否</option>
									</select>
								</td>
							</tr>
							<tr class='dim_row'>
								<td class='dim_cell_title'>
									自有业务标识
								</td>
								<td class='dim_cell_content'>
									<select id="f1004" name="f1004" style="width: 200px">
										<option value="">全部</option>
										<option value="Y">是</option>
										<option value="N">否</option>
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
			<table align="center" width="97%">
				<tr class="dim_row_submit">
					<td align="right">
						<!-- input type="button" class="form_button" value="新增" onclick="add()">
						&nbsp; -->
						<input type="button" class="form_button" value="修改" onClick="update()">
						&nbsp;							
						<!--input type="button" class="form_button" value="删除" onclick="del()">
						&nbsp; -->
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
function add(){
	window.location = '/hbbass/spcode/sp_code_add.jsp';
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
	document.forms(0).action='${mvcPath}/hbirs/action/spcode?method=getSpCode&spCode='+ids;
	document.forms(0).submit();
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
	document.forms(0).action='${mvcPath}/hbirs/action/spcode?method=deleteSpCode&spCode='+ids;
	document.forms(0).submit();
}
window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f1001'),isHoldFirst:true,sql:"select sp_busi_type key,sp_busi_name value from nwh.vdim_sp_busi_type with ur"});
	aihb.FormHelper.fillSelectWrapper({element:$('f1002'),isHoldFirst:true,sql:"select sp_type key,sp_type_name value from nwh.vdim_sp_type with ur"});
}
</script>