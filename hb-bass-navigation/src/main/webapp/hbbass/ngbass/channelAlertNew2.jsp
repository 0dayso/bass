<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 	
  	仍然完全重写,不要拉成横表
  	做成的样子
  	zb001	2
  	zb002	3
  	zboo2	5
  --%>
  <%-- 
  	refer sql :
  	select  "ZB_CODE", "ZB_NAME", sum(case when time_id='200909' then zb_value else 0 end) ,sum(case when time_id='200908' then zb_value else 0 end)
  from "NMK"."AI_CHANNEL_KPI_WAVE" WHERE channel_type = '1' 
  group by zb_code,zb_name order by 1
  
  2009.12.24 ：改了未复位预警渠道的sql,原来的似乎有问题，因为数量上大于预警渠道
  增加复位率：
  	case when (sum(case when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end))!= 0 then (   decimal((sum(case when time_id='" + op_time + "' and channel_type = '4' and a.zb_value > b.max_value then 1 else 0 end)),16,2)     /(sum(case when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end))) else 0 end
  --%>
    <title>社会渠道波动预警</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="js/common.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  </head>  
 
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> 
 <script type="text/javascript">
	for(var i = 0 ; i < 7 ;i++) {
		if(i==0 || i == 3)
			cellclass[i]="grid_row_cell_text";
		else 
			cellclass[i] = "grid_row_cell_number";
	}
	var outerCondition;//用来保存链接条件
	//最后再这样 cellfunc[2] = percentFormat;
	
	//常见的分割编码和名称
	cellfunc[0] = function(datas,options) {
		var parts = datas[0].split(",");
		return parts[1];//返回名称
	}
	cellfunc[1] = percentFormat;
	cellfunc[2] = percentFormat;
	cellfunc[6] = percentFormat;
	cellfunc[4] = function(datas,options) {
	/*
	参数包括:zb_code,来自datas数组;
			queryTime,来自outerCondition;
			area_id,来自outerCondition;
			或county_id,来自outerCondition;
			channel_code,来自outerCondition;
			counts,it is false
			*/
		return "<a href='#' onclick=window.open('alertDetail.jsp?" + outerCondition + "&zb_code=" + datas[0].split(",")[0] + "&counts=" + datas[options.seq] + "','alertDetail','width=800,height=600,status=no,resizable=yes,menubar=no,toolbar=no')>" + datas[options.seq] + "</a>";
	};
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
		outerCondition = "";//每次进来重置,这样可以保存不同的条件
		var op_time,area_id,county_id,sql,condition,tblName,innerCondition,constantPart,_channel_name;
		tblName = "nmk.ai_channel_kpi_wave";
		with(document.forms[0]) {
			area_id = city.value;
			county_id = country.value;//中文,需注意
			op_time = date.value;
			_channel_code = channel_code.value;
		}
		condition = " a.zb_code not in('SH010','SH012','SH015','SH017','SH020','SH023') and time_id in ('" + op_time + "','" + getLastMonth(op_time) + "')";
		var specialCond = " a.zb_code not in('SH010','SH012','SH015','SH017','SH020','SH023') and channel_type ='4' and time_id in ('" + op_time + "','" + getLastMonth(op_time) + "') and a.zb_value <= b.max_value ";
		condition += _channel_code && _channel_code!='支持模糊查询' ? " and channel_code like '%" + _channel_code + "%'" : "";
		specialCond += _channel_code && _channel_code!='支持模糊查询' ? " and channel_code like '%" + _channel_code + "%'" : "";
		outerCondition += "queryTime=" + op_time;//必为第一个条件，没有& 
		outerCondition += _channel_code && _channel_code!='支持模糊查询' ? "&channel_code=" + _channel_code : "&channel_code=";
		if(county_id){
			condition += " and substr(channel_code,1,8)='" + county_id + "'";
			specialCond += " and substr(channel_code,1,8)='" + county_id + "'";
			condition += " and channel_type in ('3','4')";
			innerCondition = " channel_type='3' ";
			outerCondition += "&country_id=" + county_id;//一定不是第一个条件，有&
			outerCondition += "&area_id=";
		} else if(area_id != 0) {
			condition += " and substr(channel_code,1,5)='" + area_id + "'";
			specialCond += " and substr(channel_code,1,5)='" + area_id + "'";
			condition += " and channel_type in ('2','4')";
			innerCondition = " channel_type='2' ";
			outerCondition += "&area_id=" + area_id;
			outerCondition += "&country_id=";
		} else {
			//全省,不加地市约束
			condition += " and channel_type in ('1','4')";
			innerCondition = " channel_type='1' ";
			outerCondition += "&area_id=" ;//空值
			outerCondition += "&country_id="
		}
		sql = "select col1 ,thisVal,lastVal,col4,yj_count,c.wfw," + 
		" case when (yj_count - c.wfw) != 0 then decimal((yj_count - c.wfw),16,2)/l_yj_count else 0 end " + //复位率 : 恢复的渠道个数/上月的预警个数
		" from (select  a.zb_code as zb_code,a.zb_code || ',' || a.ZB_NAME as col1 " + 
		",sum(case when time_id='" + op_time + "' and " + innerCondition + " then zb_value else 0 end) as thisVal " + 
		" ,sum(case when time_id='" + getLastMonth(op_time) + "' and " + innerCondition + " then zb_value else 0 end) as lastVal " + 
		", (select tbl.alert_level from nmk.ai_channel_kpi_threshold tbl where tbl.zb_code=a.zb_code and (sum(case when time_id='" + op_time + "' and " + innerCondition + " then zb_value else 0 end)) > tbl.min_value and (sum(case when time_id='" + op_time + "' and " + innerCondition + " then zb_value else 0 end)) <= tbl.max_value ) col4" + 
		",sum(case when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end)as yj_count" + //预警渠道个数
		",sum(case when time_id='" + op_time + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end)as l_yj_count" + //上月预警渠道个数,算复位率用
		//",count(distinct case when time_id='" + op_time + "' and channel_type = '4' and a.zb_value <= b.max_value then channel_code when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then channel_code else null end)," + 
		// ",sum(case when (case when time_id ='" + op_time + "' and channel_type = '4' and a.zb_value <= b.max_value then '' else null end) is not null  and (case when time_id ='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then '' else null end) is not null then 1 else 0 end)" + 
		//added for test
		//",sum((case when time_id ='" + op_time + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else null end))" + 
		//",sum((case when time_id ='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else null end))" + 
		// added done
		//复位率 错",case when (sum(case when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end))!= 0 then (   decimal((sum(case when time_id='" + op_time + "' and channel_type = '4' and a.zb_value > b.max_value then 1 else 0 end)),16,2)     /(sum(case when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end))) else 0 end " + 
		//",c.www " + 
		" from NMK.AI_CHANNEL_KPI_WAVE a " + 
		"left join ( select zb_code,max_value from nmk.ai_channel_kpi_threshold where alert_level = '低' ) b on a.zb_code = b.zb_code " + 
		" WHERE " + condition + "group by a.ZB_CODE, a.ZB_NAME ) tbla " + 
		" inner join (select zb_code ,count(*) wfw from (" + 
		" select a.zb_code,channel_code,count(*) from NMK.AI_CHANNEL_KPI_WAVE a left join ( select zb_code,max_value from nmk.ai_channel_kpi_threshold where alert_level = '低' ) b on a.zb_code = b.zb_code " + 
		" where " + specialCond + 
		" group by a.zb_code,channel_code having count(*)>1" + 
		") t group by zb_code ) c on c.zb_code=tbla.zb_code" ; 
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
function getRollUp(groupbyPart) {
	return "rollup(" + groupbyPart + ")";
}
function setupEvents() {
		catchEvent(document.getElementById("channel_code"),"blur",checkBlur);
		catchEvent(document.getElementById("channel_code"),"focus",checkFocus);	
}
	function dealNull(val,val2) {return "value(" + val + ",'" + val2 + "')"}
	Ext.onReady(function(){
		Ext.BLANK_IMAGE_URL = '../js/ext3/resources/images/default/s.gif';
	});
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
					<tr  class="dim_row">
						<td class="dim_cell_title">渠道编码</td>
						<td class="dim_cell_content" colspan="5">
							<input type="text" id="channel_code" name="channel_code" value="支持模糊查询" style="color:gray; font-style: italic;"/>
						</td>
					</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="预警参数配置" onclick="window.open('alertmodify.jsp','预警参数配置','width=800,height=600,status=yes,resizable=yes,menubar=no,toolbar=no')">&nbsp;
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
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 	<td class='grid_title_cell'>指标名称</td>
				 	<td class='grid_title_cell'>当月波动</td>
					<td class='grid_title_cell'>上月波动</td>
					<td class='grid_title_cell'>预警级别</td>
					<td class='grid_title_cell'>预警渠道个数</td>
					<td class='grid_title_cell'>未复位预警渠道个数</td>
					<td class='grid_title_cell'>复位率</td>
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
