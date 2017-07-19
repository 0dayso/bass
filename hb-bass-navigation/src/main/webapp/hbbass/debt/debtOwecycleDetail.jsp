<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>用户欠费帐龄情况分析-欠费在网用户清单</TITLE>
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
	<style>
.dim_cell_title {
	font-family: "宋体";
	font-size: 12px;
	line-height: 20px;
	font-weight: normal;
	font-variant: normal;
	color: #000000;
	width:  auto;
	background-color: #D9ECF6;
}
/* 查询条件值  */
.dim_cell_content {
	font-family: "宋体";
	font-size: 12px;
	line-height: 20px;
	color: #000000;
	width: auto;
	background-color:#EFF5FB;
}
.form_select{
	width:120px;
}
	</style>
</HEAD>
 <body onload="{doSubmit();}">
<form method="post" action="">
<div id="hidden_div">
	<input type="hidden" id="allPageNum" name="allPageNum" value="">
	<input type="hidden" id="sql" name="sql" value="">
	<input type="hidden" name="filename" value="">
	<input type="hidden" name="order"  value="channel_id">
	<input type="hidden" name="title" value="">
</div>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;查询条件区域：</td>
	</tr></table></legend>
	<div id="dim_div">
		<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
			<tr class="dim_row">
				<td class="dim_cell_title">日期</td>
				<td class="dim_cell_content"><%=QueryTools2.getDateYMHtml("date",12)%></td>
				<td class="dim_cell_title">地市</td>
				<td class="dim_cell_content"><%=bass.common.QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("KPI_CITY"),"areacombo(1)")%></td>
				<td class="dim_cell_title">县市</td>
				<td class="dim_cell_content"><%=bass.common.QueryTools2.getCountyHtml("county","areacombo(2)")%></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">欠费月份</td>
				<td class="dim_cell_content" colspan="5">
					<select name="owecycle" class="form_select">
						<option value="12-999">欠费12个月以上</option>
						<option value="7-12">欠费7-12个月</option>
						<option value="4-6">欠费4-6个月</option>
						<option value="1-3">欠费1-3个月</option>
					</select>
				</td>
			</tr>
		</table>
		<table align="center" width="99%">
			<tr class="dim_row_submit">
				<td align="right">
					<input type="button" class="form_button" value="查询" onClick="doSubmit()">&nbsp;
					<input type="button" class="form_button" value="下载" onclick="toDown()">&nbsp;
				</td>
			</tr>
		</table>
	</div>
</fieldset>
</div><br>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table></legend>
	<div id="show_div"><div id="showSum"></div><div id="showResult"></div></div>
	<div id="title_div" style="display:none;">
    <table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
		<tr class="grid_title_blue">
		   <span id=0><td class="grid_title_cell">地市</td></span>
		   <span id=1><td class="grid_title_cell">县市</td></span>
		   <span id=2><td class="grid_title_cell">用户类别</td></span>
		   <span id=3><td class="grid_title_cell">用户状态</td></span>
		   <span id=4><td class="grid_title_cell">用户号码</td></span>
		  </tr>
	</table>
</div>
</fieldset>
</div><br>
<div id="title_div" style="display:none;">
</div>
</form>
<%@ include file="/hbbass/common2/loadmask.htm"%></body>
</html>
<script type="text/javascript">
	cellclass[0]="grid_row_cell_text";
	cellclass[1]="grid_row_cell_text";
	fetchRows=500;
	function doSubmit()
	{
		var owecycle=document.forms[0].owecycle.value.split("-");
		var condition = " and owe_cycles between "+owecycle[0]+" and "+owecycle[1];
		if(document.forms[0].city.value!="0"){
			if(document.forms[0].county.value!="")condition +=" and county_id='"+document.forms[0].county.value+"'";
			else condition +=" and area_id='"+document.forms[0].city.value+"'";
		}
		
		var sql="select (select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id),(select cityname from FPF_user_city where dm_county_id=county_id ),case when mcust_lid='1' then '金卡' when mcust_lid='2' then '银卡' when mcust_lid='8' then '钻卡' else '无卡' end"
		+",'正常在用',acc_nbr from nmk.mbuser_debt_"+document.forms[0].date.value +" where STATE_TID='US10' "+condition;
		var countSql="select count(*) from nmk.mbuser_debt_"+document.forms[0].date.value +" where STATE_TID='US10' "+condition+" with ur";
		document.forms[0].sql.value=sql + " with ur";
		
		ajaxSubmitWrapper(sql+" fetch first "+fetchRows+" rows only with ur",countSql);
	}
</script>