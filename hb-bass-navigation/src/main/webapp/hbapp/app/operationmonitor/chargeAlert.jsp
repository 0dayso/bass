<%@ page contentType="text/html; charset=utf-8" deferredSyntaxAllowedAsLiteral="true"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIAppData"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIPortalContext"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimHelper"%>
<%@ include file="../../resources/old/loadmask.htm"%>
<%
// 用户登录超时判断
String loginname="";
if(session.getAttribute("loginname")==null)
{
  response.sendRedirect("/hbbass/error/loginerror.jsp");
  return;
}
else
{
  loginname=(String)session.getAttribute("loginname");
}	

%>
<%
KPIAppData appData = null;
try {
	 appData = (KPIAppData)KPIPortalContext.getKpiApp().get("ChannelD");
} catch (Exception e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>收入告警分析</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/chart/FusionCharts.js"></script>
	<script type="text/javascript" src="../../kpiportal/localres/kpi.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
  </head>
  <script type="text/javascript">
  	pagenum=31;
	hbbasscommonpath="../../resources/old/"
  	function footbar(){return "";}
  	var threshold = new Threshold();
  	threshold.path="../../resources/image/default/";
  	cellclass[1]="grid_row_cell_number";
	cellclass[2]="grid_row_cell_number";
	cellclass[3]="grid_row_cell_number";
	cellclass[4]="grid_row_cell_number";
	cellclass[5]="grid_row_cell_number";
	cellclass[6]="grid_row_cell_number";
	
	cellfunc[1]=numberFormatDigit2;
	cellfunc[2]=numberFormatDigit2;
	cellfunc[3]=numberFormatDigit2;
	
	function arrow(datas,options){return percentFormat(datas,options)+threshold.getTongbiImg(datas[options.seq]);}
	
	cellfunc[4]=arrow;
	cellfunc[5]=arrow;
	cellfunc[6]=arrow;
	
	function chargeAlert()
	{
		var date = document.forms[0].date.value;
		var date1 ="<%=appData.getCurrent()%>";
		var ddd = new Date(parseInt(date.substring(0,4),10), parseInt(date.substring(4,6),10) ,01);
	  	ddd.setMonth(ddd.getMonth()-1);
	  	var date2=(ddd.getYear()*100+ddd.getMonth());
		if(date!=date1.substring(0,6)){
			date1=date+"31";
			date2+="31";
		}else {		
	  		date2+=date1.substring(6,8);
	  	}
		var condition="";
		var area=document.forms[0].city.value;
		if(area!="0")condition += " and channel_code like '"+area+"%'"
		
		var sql=" select t"
			+",value(decimal(d1,16,2)/10000,0),value(decimal(c1,16,2)/10000,0),value(decimal(c1,16,2)/d1*100,0)"
			+",value(decimal(d1,16,2)/d2-1,0),value(decimal(c1,16,2)/c2-1,0),value(decimal(c1,16,2)/d1*d2/c2-1,0)"
			+" from(select '"+ date.substring(0,4)+"'||substr('#{date1}',5,2)||substr(time_id,7,2) t"
			+" ,sum(case when substr(time_id,5,2)=substr('#{date1}',5,2) and zb_code='K10002' then value end) c1,sum(case when substr(time_id,5,2)=substr('#{date2}',5,2) and zb_code='K10002' then value end) c2"
			+" ,sum(case when substr(time_id,5,2)=substr('#{date1}',5,2) and zb_code='K10006' then value end) d1,sum(case when substr(time_id,5,2)=substr('#{date2}',5,2) and zb_code='K10006' then value end) d2"
			+" from nmk.kpi_wave_daily where (time_id between substr('#{date1}',1,6)||'01' and '#{date1}' or time_id between substr('#{date2}',1,6)||'01' and '#{date2}') and ((ZB_CODE='K10002' and charge_type in ('LOCAL','TOLL','ROAM','IP')) or zb_code='K10006') "
			+ condition
			+" group by substr(time_id,7,2)) m order by 1 with ur";
			
		sql=sql.replace(/#{date1}/gi,date1).replace(/#{date2}/gi,date2);
		ajaxSubmitWrapper(sql);
		renderChart({
			url: "action.jsp?method=chargeAlert",
			param: "zbCode="+document.forms[0].zbCode.value+"&date1="+date1+"&date2="+date2+"&area="+area,
			width : "880",
			height : "230",
			chartid:"chartrender",
			chartSWF : ChartSwf["4"]
		});
	}
  </script>
  <body onload='chargeAlert()'>
  <form action="">
    <table width="99%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td valign="top">
	        <div class="portlet">
		    	<div class="title">
		    		维度选择
		    	</div>
		    	<div class="content">
	            	月份 <%=BassDimHelper.monthHtml("date","","",0) %>
	            	地市 <%=BassDimHelper.areaCodeHtml("city",(String)session.getAttribute("area_id"),"")%>
	            	指标 <select name='zbCode' class='form_select' onchange=""><option value='K10002' selected='selected' >日出帐语音收入</option><option value='K10006'>日计费时长</option></select>
	            	<input type="button" class="form_button" value="查询" onClick="chargeAlert()">
	        	</div>
        	</div>
		</td>
	  </tr>
	</table>
    <table width="99%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td valign="top">
	        <div class="portlet">
		    	<div class="title">
		    		图表
		    	</div>
		    	<div class="content">
	            	<div id="chartrender" style="text-align: center;"></div>
	        	</div>
        	</div>
		</td>
	  </tr>
	</table>
	<table width="99%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div  class="portlet">
		    	<div class="title" >
		    		数据
		    	</div>
		    	<div id="grid" class="content" style="width: 100%;">
			    	<div id="showResult" style="margin-left: 0px; padding-left: 0px;float: left;overflow-x:scroll;height: auto; width: 100%;word-break:break-all;"></div>
		            <div id="title_div" style="display:none;">
		            	<table id="resultTable" align="center" width="100%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
							<tr class="grid_title_blue">
							   <td class="grid_title_cell">时间</td>
							   <td class="grid_title_cell">时长(万分钟)</td>
							   <td class="grid_title_cell">收入(万元)</td>
							   <td class="grid_title_cell">平均单价(分)</td>
							   <td class="grid_title_cell">时长同比增长</td>
							   <td class="grid_title_cell">收入同比增长</td>
							   <td class="grid_title_cell">单价同比增长</td>
							</tr>
						</table>
					</div>
	        	</div>
        	</div>
	    </td>
	  </tr>
	</table>
	</form>
</body>
</html>

