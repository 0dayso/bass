<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 	
  	完全重写
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
	for(var i = 0 ; i < 17 ;i++) {
		if(i==0)
			cellclass[i]="grid_row_cell_text";
		else 
			cellclass[i] = "grid_row_cell_number";
	}
	cellfunc[0] = function(datas,options) {
		return datas[options.seq] ? datas[options.seq] : ' 合计';
	}
	cellfunc[1] = percentFormat;
	cellfunc[2] = function(datas,options) {
		return '0%';
	}
	
	//最后再这样 cellfunc[2] = percentFormat;
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
		var op_time,area_id,county_id,sql,condition,tblName,constantPart;
		tblName = "nmk.ai_channel_kpi_wave";
		constantPart = " (select area_name from MK.DIM_SOCIAL_CHANNEL where area_id=channel_code), sum(case when zb_code='SH001' then zb_value else 0 end)," + 
		"sum(case when zb_code='SH002' then zb_value else 0 end),sum(case when zb_code='SH003' then zb_value else 0 end)," + 
		"sum(case when zb_code='SH004' then zb_value else 0 end),sum(case when zb_code='SH005' then zb_value else 0 end)," + 
		"sum(case when zb_code='SH006' then zb_value else 0 end),sum(case when zb_code='SH007' then zb_value else 0 end)," + 
		"sum(case when zb_code='SH008' then zb_value else 0 end),sum(case when zb_code='SH009' then zb_value else 0 end)," + 
		"sum(case when zb_code='SH011' then zb_value else 0 end),sum(case when zb_code='SH013' then zb_value else 0 end)," + 
		"sum(case when zb_code='SH014' then zb_value else 0 end),sum(case when zb_code='SH016' then zb_value else 0 end)," + 
		"sum(case when zb_code='SH018' then zb_value else 0 end),sum(case when zb_code='SH019' then zb_value else 0 end)," + 
		"sum(case when zb_code='SH021' then zb_value else 0 end),sum(case when zb_code='SH022' then zb_value else 0 end) " ;
		with(document.forms[0]) {
			area_id = city.value;
			county_id = country.value;//中文,需注意
			op_time = date.value;
		}
		condition = " where time_id='" + op_time + "'";
		if(county_id){
			condition += " and substr(channel_code,1,8)='" + county_id + "'";
			condition += " and channel_type in ('3','4')";
		} else if(area_id != 0) {
			condition += " and substr(channel_code,1,5)='" + area_id + "'";
			condition += " and channel_type in ('2','3')";
		} else {
			//全省,不加地市约束
			condition += " and channel_type in ('1','2')";
		}
		sql = " select " + constantPart + " from " + tblName   + condition + " group by channel_code " + " order by 1 asc";
		var countSql = " select count(*) from " + tblName + condition;
		document.forms[0].sql.value = sql;
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
		sqls.push("select AREA_ID, AREA_NAME  from MK.STAT_AREA where PARENT_ID='#{value}' order by AREA_ID");
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
			<table id="resultTable" align="center" width="140%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 	<td class='grid_title_cell'>地域</td>
				 	<td class='grid_title_cell'>社会渠道</br>数量波动</td>
					<td class='grid_title_cell'>区域内竞争对</br>手渠道数量波动</td>
					<td class='grid_title_cell'>定制终端销</br>售数量波动</td>
					<td class='grid_title_cell'>帐务总收</br>入波动</td>
					<td class='grid_title_cell'>新增客户</br>数波动</td>
					<td class='grid_title_cell'>在网客户</br>数波动</td>
					<td class='grid_title_cell'>计费客户</br>数波动</td>
					<td class='grid_title_cell'>业务受理量(除</br>入网缴费)波动</td>
					<td class='grid_title_cell'>零次率</br>波动</td>
					<td class='grid_title_cell'>离网率</br>波动</td>
					<td class='grid_title_cell'>低RPU客户</br>占比波动</td>
					<td class='grid_title_cell'>高额欠费客</br>户数波动</td>
					<td class='grid_title_cell'>定制终端拆</br>包率波动</td>
					<td class='grid_title_cell'>客户投诉</br>量波动</td>
					<td class='grid_title_cell'>低收益客</br>户数波动</td>
					<td class='grid_title_cell'>低价值客户</br>占比波动</td>
					<td class='grid_title_cell'>重入网客</br>户数波动</td>
				 	<%-- old one
				 	<td class='grid_title_cell'>社会渠道数量波动</td>
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
				 	--%>
				 </tr>
			</table>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
