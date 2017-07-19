<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 	
  	最新渠道波动预警的详单页面
  --%>
    <title>波动预警详单</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="js/common.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<%--
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  	 --%>
  </head>  
 <%
 	String zbCode = request.getParameter("zb_code");
 	String queryTime = request.getParameter("queryTime");
 	String countryId = request.getParameter("country_id");
 	String areaId = request.getParameter("area_id");
 	String channelCode = request.getParameter("channel_code");
 	String counts = request.getParameter("counts");
 	log.debug("queryTime : " + queryTime);
 	log.debug("zb_code : " + zbCode);
 	log.debug("countryId : " + countryId);
 	log.debug("areaId : " + areaId);
 	log.debug("channelCode : " + channelCode);
 %>
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> 
 <script type="text/javascript">
	for(var i = 0 ; i < 6 ;i++) {
		if(i==0 || i == 3)
			cellclass[i]="grid_row_cell_text";
		else 
			cellclass[i] = "grid_row_cell_number";
	}
	
	//最后再这样 cellfunc[2] = percentFormat;
	/*
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
	*/
	function doSubmit(sortNum)
	{	
		var zb_code = '<%=zbCode%>';
		var op_time = '<%=queryTime%>';
		var county_id = '<%=countryId%>';
		var area_id = '<%=areaId%>';
		var channel_code = '<%=channelCode%>';
		var counts = '<%=counts%>';
		var condition = " channel_type='4' and zb_code='" + zb_code + "' and time_id in ('" + op_time +"','" + getLastMonth(op_time) + "')";
		condition += county_id ? " and substr(channel_code,1,8)='" + county_id + "'" : (area_id ? " and substr(channel_code,1,5)='" + area_id + "'" : "");
		condition += channel_code ? " and channel_code like '%" + channel_code + "%'" : "";
		//alert(condition);
		var sql = " select (select area_name from MK.DIM_SOCIAL_CHANNEL where area_id=a.channel_code) ,a.channel_code," + 
		"a.thisVal,a.lastVal,b.alert_level from (" + 
	 	" SELECT zb_code,channel_code,sum(case when time_id='" + op_time + "' then  zb_value else 0 end)as thisVal,sum(case when time_id='" + getLastMonth(op_time) + "' then  zb_value else 0 end) as lastVal" + 
	 	" FROM NMK.AI_CHANNEL_KPI_WAVE  where " + condition + 
		" group by zb_code,channel_code" + 
		") a,nmk.ai_channel_kpi_threshold b" + 
		" where a.zb_code=b.zb_code and a.thisVal >b.min_value and a.thisVal <= b.max_value";
		/*using a false one instead
		var countSql = " select count(*) from (" + 
	 	" SELECT zb_code,channel_code,sum(case when time_id='" + op_time + "' then  zb_value else 0 end)as thisVal,sum(case when time_id='" + getLastMonth(op_time) + "' then  zb_value else 0 end) as lastVal" + 
	 	" FROM NMK.AI_CHANNEL_KPI_WAVE  where " + condition + 
		" group by zb_code,channel_code" + 
		") a,nmk.ai_channel_kpi_threshold b" + 
		" where a.zb_code=b.zb_code and a.thisVal >b.min_value and a.thisVal <= b.max_value";*/
		var countSql = " select " + counts + " from nmk.ai_channel_kpi_threshold ";
		document.forms[0].sql.value = sql;
	 	ajaxSubmitWrapper(sql+" fetch first " + fetchRows  + " rows only with ur",countSql);
	} 
	

//ng版级联函数，主要是sql不同，也就是表名不同
function setupEvents() {
	doSubmit();
}
	catchEvent(window,"load",setupEvents);
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
	<%--
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
							<%=bass.common.QueryTools2.getAreaCodeHtml("city","0","areacombo(1)")%>
						</td>
						<td class="dim_cell_title">归属县市<!-- (ng) --></td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getCountyHtml("country","")%>
						</td>
					</tr>
					<tr  class="dim_row">
						<td class="dim_cell_title">渠道名称</td>
						<td class="dim_cell_content" colspan="5">
							<input type="text" id="channel_name" name="channel_name" value="支持模糊查询" style="color:gray; font-style: italic;"/>
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
	 --%>
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
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 	<td class='grid_title_cell'>渠道名称</td>
				 	<td class='grid_title_cell'>渠道编码</td>
					<td class='grid_title_cell'>当前波动</td>
					<td class='grid_title_cell'>上月波动</td>
					<td class='grid_title_cell'>预警级别</td>
				 </tr>
			</table>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
