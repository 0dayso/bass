<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>Ƿ�ѻ���ϸ������</TITLE>
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
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
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="�������"><img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;��ѯ��������</td>
	</tr></table></legend>
	<div id="dim_div">
		<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
			<tr class="dim_row">
				<td class="dim_cell_title">����</td>
				<td class="dim_cell_content"><%=QueryTools2.getDateYMHtml("date",12)%></td>
				<td class="dim_cell_title">����</td>
				<td class="dim_cell_content"><%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%></td>
				<td class="dim_cell_content">ϸ������<input type="checkbox" name="detailCounty"></td>
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
    <table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
		<tr class="grid_title_blue">
		   <span id=0><td class="grid_title_blue_noimage" rowspan="2">����</td></span>
		   <span id=1><td class="grid_title_blue_noimage" rowspan="2">����</td></span>
		   <td class="grid_title_blue_noimage" colspan="3">#{0}���ڻ���</td>
		   <td class="grid_title_blue_noimage" colspan="3">#{1}���ڻ���</td>
		   <td class="grid_title_blue_noimage" colspan="3">#{2}���ڻ���</td>
		   </tr>
		   <tr>
		   <span id=2><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">����Ƿ<br>��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=3><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">���Ϳ�<br>Ŀռ��<ai:piece></ai:piece></a></td></span>
		   <span id=4><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">������<br>��Ŀռ��<ai:piece></ai:piece></a></td></span>
		   <span id=5><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">����Ƿ<br>��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=6><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">���Ϳ�<br>Ŀռ��<ai:piece></ai:piece></a></td></span>
		   <span id=7><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">������<br>��Ŀռ��<ai:piece></ai:piece></a></td></span>
		   <span id=8><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">����Ƿ<br>��(��Ԫ)<ai:piece></ai:piece></a></td></span>
		   <span id=9><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">���Ϳ�<br>Ŀռ��<ai:piece></ai:piece></a></td></span>
		   <span id=10><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">������<br>��Ŀռ��<ai:piece></ai:piece></a></td></span>
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
	
	cellfunc[2]=numberFormatDigit2;
	cellfunc[3]=percentFormat;
	cellfunc[4]=percentFormat;
	cellfunc[5]=numberFormatDigit2;
	cellfunc[6]=percentFormat;
	cellfunc[7]=percentFormat;
	cellfunc[8]=numberFormatDigit2;
	cellfunc[9]=percentFormat;
	cellfunc[10]=percentFormat;
	cellfunc[11]=numberFormatDigit2;
	cellfunc[12]=percentFormat;
	cellfunc[13]=percentFormat;
	
	function doSubmit()
	{
		var date = document.forms[0].date.value;
		var condition="1=1 ";
		var ddd = new Date(parseInt(date.substring(0,4),10), parseInt(date.substring(4,6),10) ,01);
		ddd.setMonth(ddd.getMonth()-1);
		var date1=ddd.getYear()*100+ddd.getMonth();
		ddd.setMonth(ddd.getMonth()-1);
		var date2=ddd.getYear()*100+ddd.getMonth();
		seqformat[0]=date;
		seqformat[1]=date1;
		seqformat[2]=date2;
		var group="area_id";
		var placeholder="(select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id)";
		var orderby=" 1 desc";
		if(!document.forms[0].detailCounty.checked){
			if(document.forms[0].city.value!="0"){
				condition +=" and area_id='"+document.forms[0].city.value+"'";
				group += ",county_id"
				placeholder+=",(select cityname from FPF_user_city where dm_county_id=county_id )";
				selectColumns(0,false);
				selectColumns(1,true);
			}else{
				placeholder+=",'--'";
				selectColumns(0,true);
				selectColumns(1,false);
			}
		}else{
			if(document.forms[0].city.value!="0"){
				condition +=" and area_id='"+document.forms[0].city.value+"'";
			}
			group += ",county_id"
			placeholder+=",(select cityname from FPF_user_city where dm_county_id=county_id )";
			selectColumns(0,true);
			selectColumns(1,true);
		}
		if(arguments.length>0){
			var seq=arguments[0].parentNode.parentNode.id;
			var nodes = document.getElementsByTagName("piece");
			for(var i=0;i<nodes.length;i++){
				if(nodes[i].parentNode.parentNode.parentNode.id==seq)nodes[i].innerHTML="��";
				else nodes[i].innerHTML="";
			}
			orderby = (parseInt(seq,10)+1)+" desc ";
		}
		
		var sql=" select "+placeholder
			+" ,decimal(sum(m1)+sum(m1r),16,2)/10000"
			+" ,case when (sum(m1)+sum(m1r))=0 then 0 else decimal(sum(m1r),16,2)/decimal(sum(m1)+sum(m1r),16,2) end"
			+" ,case when (sum(m1)+sum(m1r))=0 then 0 else decimal(sum(m1),16,2)/decimal(sum(m1)+sum(m1r),16,2) end"
			+" ,decimal(sum(m2)+sum(m2r),16,2)/10000"
			+" ,case when (sum(m2)+sum(m2r))=0 then 0 else decimal(sum(m2r),16,2)/decimal(sum(m2)+sum(m2r),16,2) end"
			+" ,case when (sum(m2)+sum(m2r))=0 then 0 else decimal(sum(m2),16,2)/decimal(sum(m2)+sum(m2r),16,2) end"
			+" ,decimal(sum(m3)+sum(m3r),16,2)/10000"
			+" ,case when (sum(m3)+sum(m3r))=0 then 0 else decimal(sum(m3r),16,2)/decimal(sum(m3)+sum(m3r),16,2) end"
			+" ,case when (sum(m3)+sum(m3r))=0 then 0 else decimal(sum(m3),16,2)/decimal(sum(m3)+sum(m3r),16,2) end"
			
			+" from ("
			+" select area_id,county_id"
			+" ,decimal(sum(case when etl_cycle_id=%date% then callback_charge end),16,2)/10000  m1"
			+" ,decimal(sum(case when etl_cycle_id=%date% then callback_charge_r end),16,2)/10000 m1r"
			+" ,decimal(sum(case when etl_cycle_id=%date1% then callback_charge end),16,2)/10000 m2"
			+" ,decimal(sum(case when etl_cycle_id=%date1% then callback_charge_r end),16,2)/10000 m2r"
			+" ,decimal(sum(case when etl_cycle_id=%date2% then callback_charge end),16,2)/10000 m3"
			+" ,decimal(sum(case when etl_cycle_id=%date2% then callback_charge_r end),16,2)/10000 m3r"
			+" from nmk.st_debt_callback_mm where etl_cycle_id in (%date%,%date1%,%date2%)"
			+" group by area_id,county_id )t where "
			+ condition
			+" group by %group%"
			+ " order by " + orderby;
		
		sql = sql.replace(/%group%/gi,group).replace(/%date%/gi,date).replace(/%date1%/gi,date1).replace(/%date2%/gi,date2);
		document.forms[0].sql.value=sql + " with ur";
		
		ajaxSubmitWrapper(sql);
	}
</script>