<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>Ƿ���ʷѷֲ�ר�����--�ʷ�����</TITLE>
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script language="javascript" src="debt.js"></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
	<style>
.dim_cell_title {
	font-family: "����";
	font-size: 12px;
	line-height: 20px;
	font-weight: normal;
	font-variant: normal;
	color: #000000;
	width:  auto;
	background-color: #D9ECF6;
}
/* ��ѯ����ֵ  */
.dim_cell_content {
	font-family: "����";
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
 <body>
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
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="�������"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;��ѯ��������</td>
	</tr></table></legend>
	<div id="dim_div">
		<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
			<tr class="dim_row">
				<td class="dim_cell_title">����</td>
				<td class="dim_cell_content"><%=QueryTools2.getDateYMHtml("date",12)%></td>
				<td class="dim_cell_title">����</td>
				<td class="dim_cell_content"><%=bass.common.QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%></td>
				<td class="dim_cell_title">����</td>
				<td class="dim_cell_content"><%=bass.common.QueryTools2.getCountyHtml("county","areacombo(2)")%></td>
			</tr>
			
			<!-- added -->
			<tr class="dim_row">
				<td class="dim_cell_title">�����Ż�(ģ��)
				</td>
				<td class="dim_cell_content" colspan="5">
					<input name="feeType" id="feeType" type="text"> 
				</td>
			</tr>
		</table>
		<table align="center" width="99%">
			<tr class="dim_row_submit">
				<td align="right">
					<input type="button" class="form_button" value="��ѯ" onClick="doSubmit()">&nbsp;
					<input type="button" class="form_button" value="����" onclick="toDown()">&nbsp;
				</td>
			</tr>
		</table>
	</div>
</fieldset>
</div><br>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'show_div')" title="�������"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;����չ������</td>
		<td></td>
	</tr></table></legend>
	<div id="show_div"><div id="showSum"></div><div id="showResult"></div></div>
	
	<div id="title_div" style="display:none;">
    <table id="resultTable" align="center" width="130%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
		<tr class="grid_title_blue">
		   <td class="grid_title_cell">����</td>
		   <td class="grid_title_cell">����</td>
		   <td class="grid_title_cell">Ʒ��</td>
		   <td class="grid_title_cell">�����Ż�</td>
		   <span id=4><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">�����û�ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=5><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">����<ai:piece></ai:piece></a></td></span>
		   <span id=6><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">����ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=7><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">����<ai:piece></ai:piece></a></td></span>
		   <span id=8><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">�ۼ�Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=9><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">����<ai:piece></ai:piece></a></td></span>
		   <span id=10><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">����Ƿ��ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=11><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">����<ai:piece></ai:piece></a></td></span>
		   <span id=12><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">ͨ����ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=13><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">����<ai:piece></ai:piece></a></td></span>
		   <span id=14><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">����ռ��<ai:piece></ai:piece></a></td></span>
		   <span id=15><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">����<ai:piece></ai:piece></a></td></span>
		   <span id=16><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">GPRSռ��<ai:piece></ai:piece></a></td></span>
		   <span id=17><td class="grid_title_cell"><a href='#' onclick="doSubmit(this)">����<ai:piece></ai:piece></a></td></span>
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
	cellclass[1]="grid_row_cell_text";
	cellclass[3]="grid_row_cell_text";
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
	cellclass[16]="grid_row_cell_number";
	cellclass[17]="grid_row_cell_number";
	cellfunc[4]=percentFormat;
	cellfunc[5]=percentFormat;
	cellfunc[6]=percentFormat;
	cellfunc[7]=percentFormat;
	cellfunc[8]=percentFormat;
	cellfunc[9]=percentFormat;
	cellfunc[10]=percentFormat;
	cellfunc[11]=percentFormat;
	cellfunc[12]=percentFormat;
	cellfunc[13]=percentFormat;
	cellfunc[14]=percentFormat;
	cellfunc[15]=percentFormat;
	cellfunc[16]=percentFormat;
	cellfunc[17]=percentFormat;
	fetchRows=500;
	function doSubmit()
	{
		var condition = "";
		var feeType = document.forms[0].feeType.value;
		if(feeType != null && feeType.trim().length>0) {
			condition += " and nbilling_tid in (select fee_id from nwh.fee where fee_name like '%" + feeType + "%')";
		}
		
		if(document.forms[0].city.value!="0"){
			if(document.forms[0].county.value!="")condition +=" and county_id='"+document.forms[0].county.value+"'";
			else condition +=" and area_id='"+document.forms[0].city.value+"'";
		}
		var date = document.forms[0].date.value;
		var ddd = new Date(parseInt(date.substring(0,4),10), parseInt(date.substring(4,6),10) ,01);
		ddd.setMonth(ddd.getMonth()-2);
		var date1=ddd.getYear()*100+ddd.getMonth()+1;
		
		var orderby=" 5 desc";
		
		if(arguments.length>0){
			var seq=arguments[0].parentNode.parentNode.id;
			var nodes = document.getElementsByTagName("piece");
			for(var i=0;i<nodes.length;i++){
				if(nodes[i].parentNode.parentNode.parentNode.id==seq)nodes[i].innerHTML="��";
				else nodes[i].innerHTML="";
			}
			orderby = (parseInt(seq,10)+1)+" desc ";
		}
		
		var sql=" select (select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id),(select cityname from FPF_user_city where dm_county_id=county_id ),case when brand_id=1 then 'ȫ��ͨ' when brand_id=2 then '������' else '���еش�' end,(select fee_name from nwh.fee where fee_id=nbilling_tid)"
			+" ,value(decimal(sum(case when etl_cycle_id=%date% then dd_users end),16,2)/(select sum(t2.dd_users) from nmk.st_debt_all_MM t2 where t2.etl_cycle_id=%date% and t1.area_id=t2.area_id and t1.county_id=t2.county_id),0)"
			+" ,value(case when sum(case when etl_cycle_id=%date1% then dd_users end)=0 then 0 else decimal(sum(case when etl_cycle_id=%date% then dd_users end),16,2)/sum(case when etl_cycle_id=%date1% then dd_users end)-1 end,0)"
			+" ,value(decimal(sum(case when etl_cycle_id=%date% then P1_bill_charge end),16,2)/(select sum(t2.P1_bill_charge) from nmk.st_debt_all_MM t2 where t2.etl_cycle_id=%date% and t1.area_id=t2.area_id and t1.county_id=t2.county_id),0)"
			+" ,value(case when sum(case when etl_cycle_id=%date1% then P1_bill_charge end)=0 then 0 else decimal(sum(case when etl_cycle_id=%date% then P1_bill_charge end),16,2)/sum(case when etl_cycle_id=%date1% then P1_bill_charge end)-1 end,0)"
			+" ,value(decimal(sum(case when etl_cycle_id=%date% then debtcharge_sum end),16,2)/(select sum(t2.debtcharge_sum) from nmk.st_debt_all_MM t2 where t2.etl_cycle_id=%date% and t1.area_id=t2.area_id and t1.county_id=t2.county_id),0)"
			+" ,value(case when sum(case when etl_cycle_id=%date1% then debtcharge_sum end)=0 then 0 else decimal(sum(case when etl_cycle_id=%date% then debtcharge_sum end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_sum end)-1 end,0)"
			+" ,value(decimal(sum(case when etl_cycle_id=%date% then debtcharge_m end),16,2)/(select sum(t2.debtcharge_m) from nmk.st_debt_all_MM t2 where t2.etl_cycle_id=%date% and t1.area_id=t2.area_id and t1.county_id=t2.county_id),0)"
			+" ,value(case when sum(case when etl_cycle_id=%date1% then debtcharge_m end)=0 then 0 else decimal(sum(case when etl_cycle_id=%date% then debtcharge_m end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_m end)-1 end,0)"
			+" ,value(case when sum(case when etl_cycle_id=%date% then debtcharge_sum end)=0 then 0 else decimal(sum(case when etl_cycle_id=%date% then debtcharge_call_s end),16,2)/sum(case when etl_cycle_id=%date% then debtcharge_sum end) end,0)"
			+" ,value(case when sum(case when etl_cycle_id=%date1% then debtcharge_call_s end)=0 then 0 else decimal(sum(case when etl_cycle_id=%date% then debtcharge_call_s end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_call_s end)-1 end,0)"
			+" ,value(case when sum(case when etl_cycle_id=%date% then debtcharge_sum end)=0 then 0 else decimal(sum(case when etl_cycle_id=%date% then debtcharge_data_sms_s end),16,2)/sum(case when etl_cycle_id=%date% then debtcharge_sum end) end,0)"
			+" ,value(case when sum(case when etl_cycle_id=%date1% then debtcharge_data_sms_s end)=0 then 0 else decimal(sum(case when etl_cycle_id=%date% then debtcharge_data_sms_s end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_data_sms_s end)-1 end,0)"
			+" ,value(case when sum(case when etl_cycle_id=%date% then debtcharge_sum end)=0 then 0 else decimal(sum(case when etl_cycle_id=%date% then debtcharge_data_gprs_s end),16,2)/sum(case when etl_cycle_id=%date% then debtcharge_sum end) end,0)"
			+" ,value(case when sum(case when etl_cycle_id=%date1% then debtcharge_data_gprs_s end)=0 then 0 else decimal(sum(case when etl_cycle_id=%date% then debtcharge_data_gprs_s end),16,2)/sum(case when etl_cycle_id=%date1% then debtcharge_data_gprs_s end)-1 end,0)"
			+" from nmk.st_debt_all_MM t1 where etl_cycle_id in (%date%,%date1%)"
			+condition
			+" group by area_id,county_id,brand_id,nbilling_tid"
			+ " order by " + orderby;
		sql = sql.replace(/%date%/gi,date).replace(/%date1%/gi,date1);
		var countSql = "select count(*)  from( select 1 from nmk.st_debt_all_MM where etl_cycle_id=%date% "+condition+" group by area_id,county_id,brand_id,nbilling_tid) t with ur";
		countSql = countSql.replace(/%date%/gi,date);
		document.forms[0].sql.value=sql + " with ur";
		ajaxSubmitWrapper(sql+" fetch first "+fetchRows+" rows only with ur",countSql);
	}
</script>