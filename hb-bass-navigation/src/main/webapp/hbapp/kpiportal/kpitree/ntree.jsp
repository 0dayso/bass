<%@page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.kpiportal.service.KPIPortalService"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimHelper"%>
<%
String appName = "ChannelD";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>KPI波动分析</title>
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/chart/FusionCharts.js"></script>
	<script type="text/javascript" src="../../resources/js/default/calendar.js"></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/js/default/default.js"></script>
	<script type="text/javascript" src="../localres/fluctuating_conf.js" charset=utf-8></script>
	<script language="javascript" src="ntree.js"></script>
	<link rel="stylesheet" type="text/css" href="../localres/ntree.css" />
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
	<style type="text/css">
.box {
	width : auto;
	margin: 5 px 0 px;
	padding: 3 px;
	z-index:30;background-color: #EFF5FB;
	border:1px solid #c3daf9;
}
.box .inner {
	margin: 0 px;
	padding: 3 px 5 px;
	font-size:12 px;
	background-color: #FFFFFF;
	border:1px solid #c3daf9;
}
	</style>
	<script type="text/javascript">
	var dirNum = 3 ;//用来临时存储子节点的数量,初始值设为3 
	var appName="<%=appName%>"
	var condition ="" ;//条件
	var curCompareName="环比";
	var curConfDim=false;
	hbbasscommonpath="../../resources/old/"
	var normalformat = [];
	
	var zhanbiformat = [];
	
	var cellformat = normalformat;
	
	var zbname = "测试";
	nodepath="../localres/images/";
	curConfDim=[];
	var threshold = new Threshold();
	threshold.path="../../resources/image/default/";
	function search()
	{
		dirNum=3;
		
		document.getElementById("odiv").style.display="";
		document.getElementById("odiv").innerHTML ="";
		aa = new System.UI.ntree($("odiv"),initTable(zbname),funcarr["0"]);
		
		submitWrapper();
	}
	
	function submitWrapper(kind)
	{
		var sArea ="HB";
		if(document.forms[0].county.value!="")sArea=document.forms[0].county.value;
		else if(document.forms[0].city.value!="0")sArea=document.forms[0].city.value;
		if(sArea=="HB")document.getElementById("chartrender").innerHTML="";
		
		var ajax = new AIHBAjax.Request({
			url:"../action.jsp?appName="+appName+"&method=tree",
			param:"date="+document.forms[0].date.value+"&area="+sArea+"&kind="+kind,
			sync:true,
			callback:function(xmlHttp){eval( "list ="+xmlHttp.responseText );}
		});
		
		renderTable(list);
		
		if(document.getElementById("citystr"))document.getElementById("citystr").innerText=sArea=="HB"?"全省":mappingArea(sArea);
	}
	</script>
  </head>
  <body onload="search()"><form action="#" method="post">
  <div class="portlet">
	<div class="title">
		维度选择
	</div>
	<div class="content">
	<table width="97%" cellspacing="0" cellpadding="0" border="0">
		<tr class="dim_row">
			<td>时间</td>
			<td><%=BassDimHelper.date("date",KPIPortalService.getKPIAppData(appName).getCurrent()) %>
			<td>地市</td>
			<td><%=BassDimHelper.areaCodeHtml("city","0","areacombo(1)")%></td>
			<td>县域</td>
			<td><%=BassDimHelper.comboSeleclHtml("county")%></td>
			<td>
			<input type="button" class="form_button" value="查询" onclick="search()">
			</td>
		</tr>
	</table>
	<br>
	注：为便于更形象监控收入变化，特推出“KPI指标层级展现”栏目，该栏目按收入三大驱动力对指标进行分类监控，现进行试运行，欢迎各位领导和同仁多提宝贵意见。试运行期间原统一视图保持不变。
	</div>
  </div>
  <div class="portlet">
  	<div class="title" style="height: 23 px;font-weight:bold;">
  		KPI指标分层级展现
  	</div>
  	<div class="content">
  		<div id="odiv"></div>
    </div>
  </div>
  <div class="portlet">
   	<div class="title" >
   		<table width="100%"><tr>
   		<td>地域展现</td>
   		<td align="right"></td>
   		</tr></table>
   	</div>
   	<div class="content">
          	<div id="chartrender" style="text-align: center;"></div>
      	</div>
   </div>
  </form>
</body>
</html>
<script>
aihb.Util.loadmask();
aihb.Util.watermark();
</script>