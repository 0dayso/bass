<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 	
  	将地市维度的默认值改为"",方便if判断,但是没成功，改回原来的默认值0
  	选全省，按substr(channel_code,1,5),也就是地市汇总
  	选地市,按substr(channel_code,1,8),也就是县市汇总,对于本例来说，相当于没有汇总,因为所有的channal_code都是8位的
  	选某县市,不汇总,错，一样要汇总，否则sum()都要去掉，比较麻烦，再加上表中某一个县市并不是一条记录，而是两条
  	有嵌套查询存在时，子查询的字段写别名是很有好处的，特别是外层表关联时，本例中受益之处就是joinCondition不用随着地市下转而改动
  	剩余问题:待张莹确定预警方式;和张莹确定/100是否需要去掉
  --%>
    <title>社会渠道波动预警</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  </head>  
 
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> 
 <script type="text/javascript">
	
	cellfunc[1] = percentFormat;
	cellfunc[2] = percentFormat;
	cellfunc[3] = percentFormat;
	cellfunc[4] = percentFormat;
	cellfunc[5] = percentFormat;
	cellfunc[6] = percentFormat;
	cellfunc[7] = percentFormat;
	cellfunc[8] = percentFormat;
	cellfunc[9] = percentFormat;
	cellfunc[10] = percentFormat;
	cellfunc[11] = percentFormat;
	cellfunc[12] = percentFormat;
	cellfunc[13] = percentFormat;
	cellfunc[14] = percentFormat;
	cellfunc[15] = percentFormat;
	cellfunc[16] = percentFormat;
	cellfunc[17] = percentFormat;
	cellfunc[18] = percentFormat;
	function doSubmit(sortNum)
	{	
		//alert("数据有问题，原因为sql问题,待改正");//已更正 删除*100
		var joinCondition = " where a.channel_code=c.area_id and a.channel_code=b.channel_code ";
		var op_time,area_id,county_id,sql,groupbyPart;
		with(document.forms[0]) {
			//alert("city.value : " + city.value);
			//alert("county.value : " + country.value);
			area_id = city.value;
			county_id = country.value;//中文,需注意
			op_time = date.value;
		}
		//var condition = " where op_time='" + op_time + "'";
		var condition = "";
		if(county_id){
			groupbyPart = " substr(channel_code,1,8) ";
			condition += " and substr(channel_code,1,8)='" + county_id + "'";
		} else if(area_id != 0) {
			groupbyPart = " substr(channel_code,1,8)";
			condition += " and substr(channel_code,1,5)='" + area_id + "'";
		} else {
			//全省,不加地市约束
			groupbyPart = " substr(channel_code,1,5)";
		}
		//alert("condition : " + condition);
	    //condition += (county_id == '' ? (area_id == '0' ? "" : " and substr() = '" + area_id + "'") : " and country_id = '" + county_id + "'");
		//alert("condition : " + condition);
		//constantPart = " channel_name, khfz_score, xyw_score, zd_score, khfw_score, score ";
		//sql = "select " + constantPart + " from " + tableName + condition + orderSql;
		sql = " select c.area_name ," +  
	"case when b.channel_num=0 then 0 else decimal(round(double(a.channel_num-b.channel_num)/b.channel_num,2),14,2) end as channel_wave ," +
	"case when b.other_channel_num=0 then 0 else decimal(round(double(a.other_channel_num-b.other_channel_num)/b.other_channel_num,2),14,2) end as other_channel_wave ," +
	"case when b.terminal_times=0 then 0 else decimal(round(double(a.terminal_times-b.terminal_times)/b.terminal_times,2),14,2)end as terminal_wave ," +
	"case when b.bill_charge=0 then 0 else decimal(round(double(a.bill_charge-b.bill_charge)/b.bill_charge,2),14,2)end as bill_charge_wave ," +
	"case when b.xz_num=0 then 0 else decimal(round(double(a.xz_num-b.xz_num)/b.xz_num,2),14,2)end as xz_num_wave ," +
	"case when b.dd_num=0 then 0 else decimal(round(double(a.dd_num-b.dd_num)/b.dd_num,2),14,2)end as dd_num_wave ," +
	"case when b.charge_num=0 then 0 else decimal(round(double(a.charge_num-b.charge_num)/b.charge_num,2),14,2)end as charge_num_wave ," +
	"case when b.rec_times=0 then 0 else decimal(round(double(a.rec_times-b.rec_times)/b.rec_times,2),14,2)end as rec_times_wave ," +
	"case when b.null_num=0 then 0 else decimal(round(double(a.null_num-b.null_num)/b.null_num,2),14,2)end as null_num_wave ," +
	"case when b.dd_num=0 or a.dd_num=0 or b.lw_num=0 then 0 else decimal((decimal(double(a.lw_num)/a.dd_num,12,2)  -  decimal(double(b.lw_num)/b.dd_num,12,2))/decimal(double(b.lw_num)/b.dd_num,12,2),14,2) end as lw_rate_wave," +
	"case when b.dd_num=0 or a.dd_num=0 or b.larup_num=0 then 0 else decimal((decimal(double(a.larup_num)/a.dd_num,12,2)-decimal(double(b.larup_num)/b.dd_num,12,2) )/decimal(double(b.larup_num)/b.dd_num,12,2),14,2)end as larup_num_wave," +
	"case when a.dd_num=0 or b.dd_num=0 or b.hdebt_num=0 or decimal(double(b.hdebt_num)/b.dd_num,12,2)=0 then 0 else decimal((decimal(double(a.hdebt_num)/a.dd_num,12,2)-decimal(double(b.hdebt_num)/b.dd_num,12,2) )/decimal(double(b.hdebt_num)/b.dd_num,12,2),14,2)end as hdebt_num_wave," +//modified:added or decimal(double(b.hdebt_num)/b.dd_num,12,2)=0
	"case when a.terminal_times=0 or b.terminal_times=0 or b.disbind_times=0 then 0 else decimal((decimal(double(a.disbind_times)/a.terminal_times,12,2)-decimal(double(b.disbind_times)/b.terminal_times,12,2) )/decimal(double(b.disbind_times)/b.terminal_times,12,2),14,2)end as disbind_rate_wave," +
	"case when b.ts_times=0 then 0 else decimal(round(double(a.ts_times-b.ts_times)/b.ts_times,2),14,2) end as ts_times_wave ," +
	"case when b.larup_num=0 then 0 else decimal(round(double(a.larup_num-b.larup_num)/b.larup_num,2),14,2) end as larup_num_wave ," +
	"case when b.low_num=0 then 0 else decimal(round(double(a.low_num-b.low_num)/b.low_num,2),14,2) end as low_num_wave ," +
	"case when b.crw_num = 0 then 0 else decimal(round(double(a.crw_num-b.crw_num)/b.crw_num,2),14,2) end as crw_num_wave ," +
	"case when b.REWARD  = 0 then 0 else decimal(round(double(a.REWARD-b.REWARD)/b.REWARD,2),14,2)    end as REWARD_wave " +
	//"from (select " + (groupbyPart ? groupbyPart : "channel_code") + " as channel_code,sum(channel_num) as channel_num , " + 
	//substr(channel_code,1,8)
	"from (select " + dealNull(groupbyPart,-2) + " as channel_code,sum(channel_num) as channel_num , " +
	"sum(other_channel_num) as other_channel_num , sum(terminal_times) as terminal_times , " + 
	"sum(bill_charge) as bill_charge , sum(xz_num) as xz_num , sum(dd_num) as dd_num , " + 
	"sum(charge_num) as charge_num , sum(rec_times) as rec_times , sum(null_num) as null_num , " + 
	"sum(lw_num) as lw_num , sum(larup_num) as larup_num , sum(hdebt_num) as hdebt_num , " + 
	"sum(disbind_times) as disbind_times , sum(ts_times) as ts_times , sum(low_num) as low_num , " + 
	//"sum(crw_num) as crw_num , sum(REWARD) as REWARD from nmk.ai_channel_wave where op_time='" + op_time + "'" + condition + (groupbyPart ? " group by " + groupbyPart : "") + ") a ," + 
	"sum(crw_num) as crw_num , sum(REWARD) as REWARD from nmk.ai_channel_wave where op_time='" + op_time + "'" + condition + " group by " + getRollUp(groupbyPart) + ") a ," +
	"(select " + dealNull(groupbyPart,-2) + " as  channel_code,sum(channel_num) as channel_num ," + 
	" sum(other_channel_num) as other_channel_num , sum(terminal_times) as terminal_times ," +
	" sum(bill_charge) as bill_charge , sum(xz_num) as xz_num , sum(dd_num) as dd_num , " +
	" sum(charge_num) as charge_num , sum(rec_times) as rec_times , sum(null_num) as null_num ," +
	" sum(lw_num) as lw_num , sum(larup_num) as larup_num , sum(hdebt_num) as hdebt_num , " +
	" sum(disbind_times) as disbind_times , sum(ts_times) as ts_times , sum(low_num) as low_num ," +
	" sum(crw_num) as crw_num , sum(REWARD) as REWARD from nmk.ai_channel_wave where op_time='"  + getLastMonth(op_time) + "'" + condition + " group by " + getRollUp(groupbyPart) + ") b,MK.DIM_SOCIAL_CHANNEL c " + joinCondition;
	
		//var countSql ="select count(*) from " + tableName + condition;
		document.forms[0].sql.value = sql;
	 	//document.getElementById("testtest").innerHTML = sql;
	 	ajaxSubmitWrapper(sql+" fetch first " + fetchRows  + " rows only with ur",null);
	} 
	

//ng版级联函数，主要是sql不同，也就是表名不同
function areacombo(i,sync)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();
	if(document.forms[0].country != undefined)
	{
		selects.push(document.forms[0].country);
		sqls.push("select AREA_ID, AREA_NAME  from MK.STAT_AREA where PARENT_ID='#{value}'   order by AREA_ID");
	}
	//调用联动方法
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}
//从'yyyyMM'格式的日期中得到上个月的日起值
function getLastMonth(thisDate) {
	var thisMonth = thisDate.substr(4,thisDate.length);
	if(thisMonth == 1) return (thisDate.substr(0,4)-1) + "12";
	else return thisDate.substr(0,4) + ((thisMonth-1)<10 ? ("0" +(thisMonth-1)):(""+(thisMonth-1)));
}
function getRollUp(groupbyPart) {
	return "rollup(" + groupbyPart + ")";
}
function dealNull(val,val2) {return "value(" + val + ",'" + val2 + "')"}
	Ext.onReady(function(){
		Ext.BLANK_IMAGE_URL = '../js/ext3/resources/images/default/s.gif';
	});
  </script>
  <body>
  <form action="" method="post">
	  <div id="hidden_div">
		<input type="hidden" id="allPageNum" name="allPageNum" value="">
		<input type="hidden" id="sql" name="sql" value="">
		<input type="hidden" name="filename" value="">
		<input type="hidden" name="order"  value="">
		<input type="hidden" name="title" value="">
	</div>
	
	<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
							<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;查询条件区域：
						</td>
					</tr>
				</table>
			</legend>
			<div id="dim_div">
				<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="dim_row">
						<td class="dim_cell_title">时间</td>
						<td class="dim_cell_content">
							<%=NgbassTools.getQueryDate("date","yyyyMM")%>
						</td>
						
						<td class="dim_cell_title">归属地市</td>
						<td class="dim_cell_content"> 
						<%-- 默认值是0,从波涛工具中看到 --%>
							<%=bass.common.QueryTools2.getAreaCodeHtml("city","0","areacombo(1)")%>
						</td>
						<td class="dim_cell_title">归属县市<!-- (ng) --></td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getCountyHtml("country","")%>
						</td>
					</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="查询" onclick="doSubmit()">&nbsp;
							<input type="button" class="form_button" value="下载" onclick="toDown(1)">&nbsp;
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	<br/>
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏">
								<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
								&nbsp;数据展现区域：
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="show_div">
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
			</fieldset>
		</div>
		<br>
	
		<div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="130%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 	<td class='grid_title_cell'>地域</td>
				 	<td class='grid_title_cell'>社会渠道<br>数量波动</td>
				 	<td class='grid_title_cell'>区域内竞争对手<br>渠道数量波动</td>
				 	<td class='grid_title_cell'>定制终端销<br>售数量波动</td>
				 	<td class='grid_title_cell'>帐务总收<br>入波动</td>
				 	<td class='grid_title_cell'>新增客户<br>数波动</td>
				 	<td class='grid_title_cell'>在网客户<br>数波动</td>
				 	<td class='grid_title_cell'>计费客户<br>数波动</td>
				 	<td class='grid_title_cell'>业务受理量(除<br>入网缴费)波动</td>
				 	<td class='grid_title_cell'>零次率<br>波动</td>
				 	<td class='grid_title_cell'>离网率<br>波动</td>
				 	<td class='grid_title_cell'>低RPU客户<br>占比波动</td>
				 	<td class='grid_title_cell'>高额欠费客<br>户数波动</td>
				 	<td class='grid_title_cell'>定制终端拆<br>包率波动</td>
				 	<td class='grid_title_cell'>客户投诉<br>量波动</td>
				 	<td class='grid_title_cell'>低收益客<br>户数波动</td>
				 	<td class='grid_title_cell'>低价值客户<br>占比波动</td>
				 	<td class='grid_title_cell'>重入网客<br>户数波动</td>
				 	<td class='grid_title_cell'>应付酬<br>金波动</td>
				 </tr>
			</table>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
