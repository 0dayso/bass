<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<%-- 
	copied from debtHighDetail.jsp
--%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>欠费且有余额用户清单</TITLE>
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
	<input type="hidden" name="order"  value="acc_nbr">
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
				<td class="dim_cell_content"><%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("KPI_CITY"),"areacombo(1)")%></td>
				<td class="dim_cell_title">县市</td>
				<td class="dim_cell_content"><%=QueryTools2.getCountyHtml("county","areacombo(2)")%></td>
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
		<!-- changed -->
		   <span id=0><td class="grid_title_cell">用户号码</td></span>
		   <span id=1><td class="grid_title_cell">地市</td></span>
		   <span id=2><td class="grid_title_cell">县市</td></span>
		   <span id=3><td class="grid_title_cell">累计欠费</td></span>
		   <span id=4><td class="grid_title_cell">用户余额</td></span>
		   <span id=5><td class="grid_title_cell">赠送余额</td></span>
		   <span id=6><td class="grid_title_cell">非赠送余额</td></span>
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
	cellclass[3]="grid_row_cell_number";
	cellclass[4]="grid_row_cell_number";
	cellclass[5]="grid_row_cell_number";
	cellclass[6]="grid_row_cell_number";
	cellfunc[3]=numberFormatDigit2;
	cellfunc[4]=numberFormatDigit2;
	cellfunc[5]=numberFormatDigit2;
	cellfunc[6]=numberFormatDigit2;
	fetchRows=500;
	function doSubmit()
	{
		var condition = " 1=1 ";
		if(document.forms[0].city.value!="0"){
			if(document.forms[0].county.value!="")condition +=" and county_id='"+document.forms[0].county.value+"'";
			else condition +=" and area_id='"+document.forms[0].city.value+"'";
		}
		
		var sql="select acc_nbr,(select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id),(select cityname from FPF_user_city where dm_county_id=county_id ),decimal(debtcharge_sum,16,2)/1000,decimal(balance_sum,16,2)/1000,decimal(present_balance,16,2)/1000,decimal(real_balance,16,2)/1000 from nmk.st_debt_balance_list_"+document.forms[0].date.value +" where "+condition;
		var countSql="select count(*) from nmk.st_debt_balance_list_"+document.forms[0].date.value +" where "+condition+" with ur";
		
		document.forms[0].sql.value=sql + " with ur";
		ajaxSubmitWrapper(sql+" fetch first "+fetchRows+" rows only with ur",countSql);
	}
</script>