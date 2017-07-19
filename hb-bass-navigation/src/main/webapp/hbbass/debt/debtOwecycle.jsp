<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools2"%>
<HTML xmlns:ai>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
	<TITLE>用户欠费帐龄情况分析</TITLE>
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
				<td class="dim_cell_title">指标</td>
				<td class="dim_cell_content">
					<select name="indicator" class="form_select">
						<option value="debtcharge_users">用户数(户)</option>
						<option value="debtcharge_sum">欠费(万元)</option>
					</select>
				</td>
				<td class="dim_cell_content" colspan="4">细分县市<input type="checkbox" name="detailCounty">
				用户类别<input type="checkbox" name="detailMcust">
				用户状态<input type="checkbox" name="detailState"></td>
			</tr>
		</table>
		<table align="center" width="99%">
			<tr class="dim_row_submit">
				<td>注：细分用户状态后可点击正常在用查看清单</td>
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
		   <span id=2><td class="grid_title_blue_noimage">用户类别</td></span>
		   <span id=3><td class="grid_title_blue_noimage">用户状态</td></span>
		   <span id=4><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">欠费1-3个月<ai:piece></ai:piece></a></td></span>
		   <span id=5><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">占比<ai:piece></ai:piece></a></td></span>
		   <span id=6><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">增幅<ai:piece></ai:piece></a></td></span>
		   <span id=7><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">欠费4-6个月<ai:piece></ai:piece></a></td></span>
		   <span id=8><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">占比<ai:piece></ai:piece></a></td></span>
		   <span id=9><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">增幅<ai:piece></ai:piece></a></td></span>
		   <span id=10><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">欠费7-12个月<ai:piece></ai:piece></a></td></span>
		   <span id=11><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">占比<ai:piece></ai:piece></a></td></span>
		   <span id=12><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">增幅<ai:piece></ai:piece></a></td></span>
		   <span id=13><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">欠费12个月以上<ai:piece></ai:piece></a></td></span>
		   <span id=14><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">占比<ai:piece></ai:piece></a></td></span>
		   <span id=15><td class="grid_title_blue_noimage"><a href='#' onclick="doSubmit(this)">增幅<ai:piece></ai:piece></a></td></span>	   
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
	
	cellfunc[3]=function(datas,options){
		if(datas[options.seq]=="正常在用"){
			return "<a href='#' title='欠费在网用户清单' onclick=add('debtOwecycleDetail','欠费在网用户清单','debtOwecycleDetail.jsp')>正常在用</a>"
		}
		return datas[options.seq];
	}
	
	cellfunc[4]=numberFormatDigit2;
	cellfunc[5]=percentFormat;
	cellfunc[6]=percentFormat;
	cellfunc[7]=numberFormatDigit2;
	cellfunc[8]=percentFormat;
	cellfunc[9]=percentFormat;
	cellfunc[10]=numberFormatDigit2;
	cellfunc[11]=percentFormat;
	cellfunc[12]=percentFormat;
	cellfunc[13]=numberFormatDigit2;
	cellfunc[14]=percentFormat;
	cellfunc[15]=percentFormat;
	
	function doSubmit()
	{
		var date = document.forms[0].date.value;
		var condition="1=1 ";
		var ddd = new Date(parseInt(date.substring(0,4),10), parseInt(date.substring(4,6),10) ,01);
		ddd.setMonth(ddd.getMonth()-1);
		var date1=ddd.getYear()*100+ddd.getMonth();
		var group="area_id";
		var placeholder="(select cityname from FPF_user_city where dm_county_id='-1' and dm_city_id=area_id)";
		var orderby=" 1 desc";
		
		if(document.forms[0].city.value!="0"){
			if(document.forms[0].county.value!="")condition +=" and county_id='"+document.forms[0].county.value+"'";
			else condition +=" and area_id='"+document.forms[0].city.value+"'";
			group += ",county_id"
			placeholder+=",(select cityname from FPF_user_city where dm_county_id=county_id )";
			selectColumns(0,false);
			selectColumns(1,true);
		}else{
			if(document.forms[0].detailCounty.checked){
				group += ",county_id"
				placeholder+=",(select cityname from FPF_user_city where dm_county_id=county_id )";
			}else {
				placeholder+=",'--'";
				selectColumns(0,true);
				selectColumns(1,false);
			}
		}
		
		if(document.forms[0].detailCounty.checked){
			selectColumns(0,true);
			selectColumns(1,true);
		}
		
		if(document.forms[0].detailMcust.checked){
			group += ",mcust_lid"
			placeholder+=",case when mcust_lid='1' then '金卡' when mcust_lid='2' then '银卡' when mcust_lid='8' then '钻卡' else '无卡' end";
			selectColumns(2,true);
		}else{
			placeholder+=",'--'";
			selectColumns(2,false);
		}
		if(document.forms[0].detailState.checked){
			group += ",state_tid"
			placeholder+=",(select rowname from nmk.VDIM_SERVSTATE where rowid=state_tid)";
			selectColumns(3,true);
		}else{
			placeholder+=",'--'";
			selectColumns(3,false);
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
			+(document.forms[0].indicator.value=="debtcharge_users"?" ,sum(cur_c1)":" ,decimal(sum(cur_c1),16,2)/10000000")               
			+" ,case when sum(cur_tot)=0 then 0 else decimal(sum(cur_c1),16,2)/sum(cur_tot) end"
			+" ,case when sum(pre_c1)=0 then 0 else decimal(sum(cur_c1),16,2)/sum(pre_c1)-1 end"
			+(document.forms[0].indicator.value=="debtcharge_users"?" ,sum(cur_c2)":" ,decimal(sum(cur_c2),16,2)/10000000")
			+" ,case when sum(cur_tot)=0 then 0 else decimal(sum(cur_c2),16,2)/sum(cur_tot) end"
			+" ,case when sum(pre_c2)=0 then 0 else decimal(sum(cur_c2),16,2)/sum(pre_c2)-1 end"
			+(document.forms[0].indicator.value=="debtcharge_users"?" ,sum(cur_c3)":" ,decimal(sum(cur_c3),16,2)/10000000")
			+" ,case when sum(cur_tot)=0 then 0 else decimal(sum(cur_c3),16,2)/sum(cur_tot) end"
			+" ,case when sum(pre_c3)=0 then 0 else decimal(sum(cur_c3),16,2)/sum(pre_c3)-1 end"
			+(document.forms[0].indicator.value=="debtcharge_users"?" ,sum(cur_c4)":" ,decimal(sum(cur_c4),16,2)/10000000")
			+" ,case when sum(cur_tot)=0 then 0 else decimal(sum(cur_c4),16,2)/sum(cur_tot) end"
			+" ,case when sum(pre_c4)=0 then 0 else decimal(sum(cur_c4),16,2)/sum(pre_c4)-1 end"
			+" from ("
			+" select area_id,county_id,mcust_lid,state_tid"
			+" ,sum(case when etl_cycle_id=%date% then %indicator% end) cur_tot"
			+" ,sum(case when etl_cycle_id=%date% and owecycle_lid=1 then %indicator% end) cur_c1"
			+" ,sum(case when etl_cycle_id=%date% and owecycle_lid=2 then %indicator% end) cur_c2"
			+" ,sum(case when etl_cycle_id=%date% and owecycle_lid=3 then %indicator% end) cur_c3"
			+" ,sum(case when etl_cycle_id=%date% and owecycle_lid=4 then %indicator% end) cur_c4"
			+" ,sum(case when etl_cycle_id=%date1% and owecycle_lid=1 then %indicator% end) pre_c1"
			+" ,sum(case when etl_cycle_id=%date1% and owecycle_lid=2 then %indicator% end) pre_c2"
			+" ,sum(case when etl_cycle_id=%date1% and owecycle_lid=3 then %indicator% end) pre_c3"
			+" ,sum(case when etl_cycle_id=%date1% and owecycle_lid=4 then %indicator% end) pre_c4"
			+" from nmk.st_debt_owecycle_mm"
			+" where etl_cycle_id in (%date%,%date1%)"
			+" group by area_id,county_id,mcust_lid,state_tid) t where "
			+ condition
			+" group by %group%"
			+ " order by " + orderby;
		
		sql = sql.replace(/%indicator%/gi,document.forms[0].indicator.value).replace(/%group%/gi,group).replace(/%date%/gi,date).replace(/%date1%/gi,date1);
		document.forms[0].sql.value=sql + " with ur";
		
		ajaxSubmitWrapper(sql);
	}
</script>