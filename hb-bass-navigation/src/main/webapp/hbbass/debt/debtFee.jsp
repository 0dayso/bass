<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>欠费资费分布专题分析</TITLE>
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script language="javascript" src="debt.js"></script>
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
				<td class="dim_cell_content"><%=bass.common.QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%></td>
				<td class="dim_cell_title">县市</td>
				<td class="dim_cell_content"><%=bass.common.QueryTools2.getCountyHtml("county","areacombo(2)")%></td>
			</tr>
			
			<tr class="dim_row">
				<td class="dim_cell_title">基本优惠(模糊)
				</td>
				<td class="dim_cell_content" colspan="5">
					<input name="feeType" id="feeType" type="text"> 
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
    <table id="resultTable" align="center" width="130%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
		<tr class="grid_title_blue">
		   <td class="grid_title_cell">基本优惠</td>
		   <span id=1><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">用户到<br>达数(户)<ai:piece></ai:piece></a></td></span>
		   <span id=2><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">用户<br>收入(万元)<ai:piece></ai:piece></a></td></span>
		   <span id=3><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">ARPU<br>(元/户)<ai:piece></ai:piece></a></td></span>
		   <span id=4><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">累计<br>欠费(万元)<ai:piece></ai:piece></a></td></span>
		   <span id=5><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">累计欠费<br>用户数<ai:piece></ai:piece></a></td></span>
		   <span id=6><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">累计欠费用户<br>均欠费(元/户)<ai:piece></ai:piece></a></td></span>
		   <span id=7><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">当月欠费(万元)<ai:piece></ai:piece></a></td></span>
		   <span id=8><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">当月欠费<br>用户数<ai:piece></ai:piece></a></td></span>
		   <span id=9><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">当月欠费用户<br>均欠费(元/户)<ai:piece></ai:piece></a></td></span>
		   <span id=10><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">通话费<br>欠费(万元)<ai:piece></ai:piece></a></td></span>
		   <span id=11><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">通话费欠费户<br>均欠费(元/户)<ai:piece></ai:piece></a></td></span>
		   <span id=12><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">短信欠费(万元)<ai:piece></ai:piece></a></td></span>
		   <span id=13><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">短信欠费户均<br>欠费(元/户)<ai:piece></ai:piece></a></td></span>
		   <span id=12><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">GPRS欠费(万元)<ai:piece></ai:piece></a></td></span>
		   <span id=13><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">GPRS欠费户<br>均欠费(元/户)<ai:piece></ai:piece></a></td></span>
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
	cellclass[1]="grid_row_cell_number";
	cellclass[2]="grid_row_cell_number";
	cellclass[3]="grid_row_cell_number";
	cellclass[4]="grid_row_cell_number";
	cellclass[5]="grid_row_cell_number";
	cellclass[6]="grid_row_cell_number";
	cellclass[7]="grid_row_cell_number";
	cellclass[8]="grid_row_cell_number";
	cellclass[9]="grid_row_cell_number";
	cellclass[10]="grid_row_cell_number";
	cellclass[11]="grid_row_cell_number";
	cellclass[12]="grid_row_cell_number";
	cellclass[13]="grid_row_cell_number";
	cellclass[14]="grid_row_cell_number";
	cellclass[15]="grid_row_cell_number";
	
	cellfunc[1]=numberFormatDigit2;
	cellfunc[2]=numberFormatDigit2;
	cellfunc[3]=numberFormatDigit2;
	cellfunc[4]=numberFormatDigit2;
	cellfunc[5]=numberFormatDigit2;
	cellfunc[6]=numberFormatDigit2;
	cellfunc[7]=numberFormatDigit2;
	cellfunc[8]=numberFormatDigit2;
	cellfunc[9]=numberFormatDigit2;
	cellfunc[10]=numberFormatDigit2;
	cellfunc[11]=numberFormatDigit2;
	cellfunc[12]=numberFormatDigit2;
	cellfunc[13]=numberFormatDigit2;
	cellfunc[14]=numberFormatDigit2;
	cellfunc[15]=numberFormatDigit2;
	fetchRows=500;
	function doSubmit()
	{
		var condition = "";
		
		//added
		//one way
		var feeType = document.forms[0].feeType.value;
		/*another way
		var feeTypeObj = document.getElementById("feeType");
		var feeType = feeTypeObj.value;
		*/
		//alert(feeType);
		if(feeType != null && feeType.trim().length>0) {
			condition += " and nbilling_tid in (select fee_id from nwh.fee where fee_name like '%" + feeType + "%')";
		}
		
		if(document.forms[0].city.value!="0"){
			if(document.forms[0].county.value!="")condition +=" and county_id='"+document.forms[0].county.value+"'";
			else condition +=" and area_id='"+document.forms[0].city.value+"'";
		}
		var date = document.forms[0].date.value;
		var sql="select (select fee_name from nwh.fee where fee_id=nbilling_tid),sum(dd_users),decimal(sum(P1_bill_charge),16,2)/10000000,decimal(sum(P1_bill_charge),16,2)/sum(dd_users)/1000,decimal(sum(debtcharge_sum),16,2)/10000000,sum(debtcharge_users),decimal(sum(debtcharge_sum),16,2)/sum(debtcharge_users)/1000,decimal(sum(debtcharge_m),16,2)/10000000,sum(debtcharge_users_m),case when sum(debtcharge_users_m)=0 then 0 else decimal(sum(debtcharge_m),16,2)/sum(debtcharge_users_m)/1000 end,decimal(sum(debtcharge_call_s),16,2)/10000000,decimal(sum(debtcharge_call_s),16,2)/sum(debtcharge_users)/1000,decimal(sum(debtcharge_data_sms_s),16,2)/10000000,decimal(sum(debtcharge_data_sms_s),16,2)/sum(debtcharge_users)/1000,decimal(sum(debtcharge_data_gprs_s),16,2)/10000000,decimal(sum(debtcharge_data_gprs_s),16,2)/sum(debtcharge_users)/1000 from nmk.st_debt_all_MM where etl_cycle_id=%date% "+condition+" group by nbilling_tid having sum(dd_users)>0 and sum(debtcharge_users)>0 "
		var orderby=" 2 desc";
		sql = sql.replace(/%date%/gi,date);
		if(arguments.length>0){
			var seq=arguments[0].parentNode.parentNode.id;
			var nodes = document.getElementsByTagName("piece");
			for(var i=0;i<nodes.length;i++){
				if(nodes[i].parentNode.parentNode.parentNode.id==seq)nodes[i].innerHTML="↓";
				else nodes[i].innerHTML="";
			}
			orderby = (parseInt(seq,10)+1)+" desc ";
		}
		sql+=" order by "+orderby;
		var countSql = "select count(distinct nbilling_tid) from nmk.st_debt_all_MM where etl_cycle_id=%date% "+condition+"  with ur";
		countSql = countSql.replace(/%date%/gi,date);
		document.forms[0].sql.value=sql + " with ur";
		ajaxSubmitWrapper(sql+" fetch first "+fetchRows+" rows only with ur",countSql);
	}
</script>