<%@ page language="java"  pageEncoding="utf-8"%>
<%
String cityId=request.getParameter("city");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>修改高校审核人配置</title>
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
							
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center" width="50%">
									一级审核人
								</td>
								<td class="grid_row_cell">
									<select id="audit1" style="width: 350px"></select>(点击下拉框以后请稍候)
								</td>
							</tr>
							<tr class="grid_row_blue">
								<td class="grid_title_blue" align="center">
									二级审核人
								</td>
								<td class="grid_row_cell">
									<select id="audit2" style="width: 350px"></select>(点击下拉框以后请稍候)
								</td>
							</tr>
						</table>
						<br>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="center">
									<input type="button" class="form_button" value="保存" onclick="save()">
									<input type="button" class="form_button" value="返回" onclick="history.back();">
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
var cityId='<%=cityId%>';
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
	var audit1 = document.getElementById("audit1").value;
	var audit2 = document.getElementById("audit2").value;
	if(!audit1){
		alert("请选择一级审核人");
		return;
	}
	if(!audit2){
		alert("请选择二级审核人");
		return;
	}
	//alert(cityId + " " + audit1+" "+audit2);
	//document.forms(0).action='${mvcPath}/hbirs/action/areaSaleManage?method=updateCollegeAuditFlow&cityId='+cityId+"&audit1="+audit1+"&audit2="+audit2;
	//document.forms(0).submit();
	var _ajax = new aihb.Ajax({
		url : "${mvcPath}/hbirs/action/college?method=updateCollegeAuditFlow"
		,parameters : "cityId="+cityId+"&audit1="+audit1+"&audit2="+audit2
		,callback : function(xmlrequest){
			alert("修改成功");
		}
	});
	_ajax.request();
}
window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('audit1'),isHoldFirst:true,sql:"select userid key,username||' <'||userid||'>'||' <'||mobilephone||'>' value from FPF_USER_USER where cityid='"+cityId+"' order by userid with ur",ds:'web',isCache:false});
	aihb.FormHelper.fillSelectWrapper({element:$('audit2'),isHoldFirst:true,sql:"select userid key,username||' <'||userid||'>'||' <'||mobilephone||'>' value from FPF_USER_USER where cityid='"+cityId+"' order by userid with ur",ds:'web',isCache:false});
};

</script>