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
		<title>新增SP企业代码信息</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/calendar.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
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
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">SP企业代码      </td><td class="grid_row_cell"><input type="text" size="42" name='f1001'></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">SP企业名称      </td><td class="grid_row_cell"><input type="text" size="42" name='f1002'></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">服务代码        </td><td class="grid_row_cell"><input type="text" size="42" name='f1003'></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">SP业务类型      </td><td class="grid_row_cell"><select style="width: 306px" name='f1004'></select></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">SP结算类型      </td><td class="grid_row_cell"><select style="width: 306px" name='f1005'></select></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">归属省          </td><td class="grid_row_cell"><input type="text" size="42" name='f1006'></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">结算省          </td><td class="grid_row_cell"><input type="text" size="42" name='f1007'></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">自有业务标识    </td><td class="grid_row_cell"><select style="width: 306px" name='f1008'><option value="1">是</option><option value="0">否</option></select></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">SP状态          </td><td class="grid_row_cell"><input type="text" size="42" name='f1009'></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">SP维护状态      </td><td class="grid_row_cell"><input type="text" size="42" name='f1010'></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">生效日期        </td><td class="grid_row_cell"><input type="text" size="42" name='f1011' onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">失效日期        </td><td class="grid_row_cell"><input type="text" size="42" name='f1012' onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd'})" class="Wdate"></td></tr>
<tr class="grid_row_blue"><td class="grid_title_blue" align="center">是否参与结算标识</td><td class="grid_row_cell"><select style="width: 306px" name='f1013'><option value="1">是</option><option value="0">否</option></select></td></tr>

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
	if($('f1005').value == ""){
		alert('SP代码不能为空');
		return;
	}
	document.forms(0).action='${mvcPath}/hbirs/action/spcode?method=saveSpCode';
	document.forms(0).submit();
}
window.onload=function(){
	aihb.FormHelper.fillSelectWrapper({element:$('f1004'),isHoldFirst:false,sql:"select sp_busi_type key,sp_busi_name value from nwh.vdim_sp_busi_type with ur"});
	aihb.FormHelper.fillSelectWrapper({element:$('f1005'),isHoldFirst:false,sql:"select sp_type key,sp_type_name value from nwh.vdim_sp_type with ur"});
}
</script>