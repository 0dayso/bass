<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<html xmlns:ai>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<title>拆包剔除导入失败数据</title>
	<script type="text/javascript" src="${mvcPath}/hb-bass-primary/js/default/des.js" charset=utf-8></script>
	<script type="text/javascript" src="../../../hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="../../../hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<link rel="stylesheet" type="text/css" href="../../../hbapp/resources/css/default/default.css" />
	<script type="text/javascript">
	//aihb.URL="/hbapp";
	var _header= [
	{
		"cellStyle":"grid_row_cell_number",
		"dataIndex":"ser_no",
		"name":["序号"],
		"title":"",
		"cellFunc":""
	},
	{
		"cellStyle":"grid_row_cell_text",
		"dataIndex":"area_id",
		"name":["地市"],
		"title":"",
		"cellFunc":""
	},
	{
		"cellStyle":"grid_row_cell",
		"dataIndex":"acc_nbr",
		"name":["号码"],
		"title":"",
		"cellFunc":""
	},
	{
		"cellStyle":"grid_row_cell_number",
		"dataIndex":"imei",
		"name":["捆绑IMEI"],
		"title":"",
		"cellFunc":""
	},
	{
		"cellStyle":"grid_row_cell_text",
		"dataIndex":"fee_name",
		"name":["捆绑优惠包"],
		"title":"",
		"cellFunc":""
	},
	{
		"cellStyle":"grid_row_cell_text",
		"dataIndex":"bind_date",
		"name":["捆绑日期"],
		"title":"",
		"cellFunc":""
	},
	{
		"cellStyle":"grid_row_cell_text",
		"dataIndex":"reason",
		"name":["拆包返还优惠原因"],
		"title":"",
		"cellFunc":""
	},
	{
		"cellStyle":"grid_row_cell_text",
		"dataIndex":"deal_opinion",
		"name":["处理意见"],
		"title":"",
		"cellFunc":""
	},
	{
		"cellStyle":"grid_row_cell_text",
		"dataIndex":"import_date",
		"name":["导入日期"],
		"title":"",
		"cellFunc":""
	},
	{
		"cellStyle":"grid_row_cell_text",
		"dataIndex":"deal_type",
		"name":["处理方式"],
		"title":"",
		"cellFunc":""
	},
	{
		"cellStyle":"grid_row_cell_text",
		"dataIndex":"flag",
		"name":["不成功原因"],
		"title":"",
		"cellFunc":""
	}
	];
aihb.Util.loadmask();
var _params = aihb.Util.paramsObj();
//var task_id = new Date().format("yyyymmdd") + "@" + loginname;
//var taskId = new Date().format("yyyymmdd") + "@<%=user.getId()%>";
var taskId = "@<%=user.getId()%>";
function query(){
	var date = $("date1").value;
	var grid = new aihb.SimpleGrid({
		header:_header
		,sql: "select SER_NO,AREA_ID,ACC_NBR,IMEI,REASON,DEAL_OPINION,DEAL_TYPE,FLAG from NWH.IMEI_MBUSER_CS_UPLOAD where task_id like '%" + taskId + "%' and task_id like '%"+date+"%'"
		,ds:"web"
		,isCached : false
		,callback:function(){
			aihb.Util.watermark();
		}
	});
	grid.run();
}

function down(){
	var date = $("date1").value;
	aihb.AjaxHelper.down({
		sql : "select SER_NO,AREA_ID,ACC_NBR,IMEI,REASON,DEAL_OPINION,DEAL_TYPE,FLAG from NWH.IMEI_MBUSER_CS_UPLOAD where task_id like '%" + taskId + "%' and task_id like '%"+date+"%'"
		,header : _header
		,ds:"web"
		,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
	});
}

function _delete() {
	var date = $("date1").value;
	if(!window.confirm("确定要删除吗？删除前应先下载这些记录做备份"))
		return;
	var _params = aihb.Util.paramsObj();
	var sql=encodeURIComponent("delete from NWH.IMEI_MBUSER_CS_UPLOAD where task_id='" + taskId + "' and task_id like '%"+date+"%'");
	var ajax = new aihb.Ajax({
		url : "${mvcPath}/hbirs/action/sqlExec"
		,parameters : "sqls="+sql+"&ds=web"
		,loadmask : false
		,callback : function(xmlrequest){
			var result = eval("(" + xmlrequest.responseText + ")");
			alert(result.message);
			query();
		}
	});
	ajax.request();
}

window.onload=function(){
	var _d=new Date();
	$("date1").value=_d.format("yyyymm");
	aihb.Util.loadmask();
	aihb.Util.watermark();
	query();
}
	</script>
</head>
<body>
<form method="post" action=""><br>
<div style="text-align:right;">
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_content'>
				<input align="right" type="text" id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" onchange="query()" class="Wdate"/>
			</td>
			<td  class='dim_cell_content'>
				<font color=red>请下载未成功导入的数据编辑后重新上传</font>
				<input type="button" class="form_button" value="下载数据" onclick="down()">&nbsp;
				<input type="button" class="form_button" value="删除失败数据" onClick="_delete()">&nbsp;
			</td>
		</tr>
	</table>
</div>

<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏"><img flag='1' src="../../../hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table></legend>
	<div id="grid" style="display:none;"></div>
</fieldset>
</div><br>
</form>
</body>
</html>
