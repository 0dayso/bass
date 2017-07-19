<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>欠费回收总体情况</TITLE>
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
				<td class="dim_cell_content"><%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%></td>
				<td class="dim_cell_content">细分县市<input type="checkbox" name="detailCounty"></td>
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
		   <span id=0><td class="grid_title_blue_noimage">地市</td></span>
		   <span id=1><td class="grid_title_blue_noimage">县市</td></span>
		   <span id=2><td class="grid_title_blue_noimage" title="当月回收总额/上月出帐收入"><a href='#' onclick="doSubmit(this)">综合回收率<ai:piece></ai:piece></a></td></span>
		   <span id=3><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">增幅<ai:piece></ai:piece></a></td></span>
		   <span id=4><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">同比<ai:piece></ai:piece></a></td></span>
		   <span id=5><td class="grid_title_blue_noimage" title="当月回收上帐期总额/上月出帐收入"><a href='#' onclick="doSubmit(this)">当月回收率<ai:piece></ai:piece></a></td></span>
		   <span id=6><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">增幅<ai:piece></ai:piece></a></td></span>
		   <span id=7><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">同比<ai:piece></ai:piece></a></td></span>
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
	
	cellfunc[2]=percentFormat;
	cellfunc[3]=percentFormat;
	cellfunc[4]=percentFormat;
	cellfunc[5]=percentFormat;
	cellfunc[6]=percentFormat;
	cellfunc[7]=percentFormat;
	
	function doSubmit()
	{
		var date = document.forms[0].date.value;
		var condition="1=1 ";
		var ddd = new Date(parseInt(date.substring(0,4),10), parseInt(date.substring(4,6),10) ,01);
		ddd.setMonth(ddd.getMonth()-1);
		var date1=ddd.getYear()*100+ddd.getMonth();
		ddd.setMonth(ddd.getMonth()+1);
		ddd.setYear(ddd.getYear()-1);
		var date2=ddd.getYear()*100+ddd.getMonth();
		
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
				if(nodes[i].parentNode.parentNode.parentNode.id==seq)nodes[i].innerHTML="↓";
				else nodes[i].innerHTML="";
			}
			orderby = (parseInt(seq,10)+1)+" desc ";
		}
		
		var sql=" select "+placeholder
			+" ,case when sum(cur_bchg)=0 then 0 else decimal(sum(cur),16,2)/sum(cur_bchg) end"
			+" ,case when sum(cur_bchg)*sum(pre)=0 then 0 else  decimal(sum(cur),16,2)*sum(pre_bchg)/(sum(cur_bchg)*sum(pre))-1 end"
			+" ,case when sum(cur_bchg)*sum(before)=0 then 0 else  decimal(sum(cur),16,2)*sum(before_bchg)/(sum(cur_bchg)*sum(before))-1 end"
			+" ,case when sum(cur_bchg)=0 then 0 else decimal(sum(cur_m1),16,2)/sum(cur_bchg) end"
			+" ,case when sum(cur_bchg)*sum(pre_m1)=0 then 0 else  decimal(sum(cur_m1),16,2)*sum(pre_bchg)/(sum(cur_bchg)*sum(pre_m1))-1 end"
			+" ,case when sum(cur_bchg)*sum(before_m1)=0 then 0 else  decimal(sum(cur_m1),16,2)*sum(before_bchg)/(sum(cur_bchg)*sum(before_m1))-1 end"
			+" from ("
			+" select area_id,county_id"
			+" ,sum(case when etl_cycle_id=%date% then callback_charge+callback_charge_r end) cur"
			+" ,sum(case when etl_cycle_id=%date% then callback_charge_m1+callback_charge_r_m1 end) cur_m1"
			+" ,sum(case when etl_cycle_id=%date% then p1_bill_charge end) cur_bchg"
			+" ,sum(case when etl_cycle_id=%date1% then callback_charge+callback_charge_r end) pre"
			+" ,sum(case when etl_cycle_id=%date1% then callback_charge_m1+callback_charge_r_m1 end) pre_m1"
			+" ,sum(case when etl_cycle_id=%date1% then p1_bill_charge end) pre_bchg"
			+" ,sum(case when etl_cycle_id=%date2% then callback_charge+callback_charge_r end) before"
			+" ,sum(case when etl_cycle_id=%date2% then callback_charge_m1+callback_charge_r_m1 end) before_m1"
			+" ,sum(case when etl_cycle_id=%date2% then p1_bill_charge end) before_bchg"
			+" from nmk.st_debt_callback_mm"
			+" where etl_cycle_id in (%date%,%date1%,%date2%)"
			+" group by area_id,county_id) t where "
			+ condition
			+" group by %group%"
			+ " order by " + orderby;
		
		sql = sql.replace(/%group%/gi,group).replace(/%date%/gi,date).replace(/%date1%/gi,date1).replace(/%date2%/gi,date2);
		document.forms[0].sql.value=sql + " with ur";
		
		ajaxSubmitWrapper(sql);
	}
</script>