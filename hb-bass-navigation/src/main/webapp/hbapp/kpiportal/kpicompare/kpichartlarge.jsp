<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="../../resources/old/loadmask.htm"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>KPI比较分析</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/chart/FusionCharts.js"></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
  </head>
  <script type="text/javascript">
  function chart(chartSWF)
{
	var chart = new FusionCharts(chartSWF, "ChartId", "980", "550");
	chart.setDataXML(data);
	chart.addParam("wmode","transparent");
	chart.render("chartrender0");
}
	
	function renderChart(options)
	{
		var ajax = new AIHBAjax.Request({
			url:options.url,
			loadmask : options.loadmask != undefined?options.loadmask:true, 
			param:options.param,
			callback:function(foo)
			{
				data = foo.responseText;
				if(data=="")alert("没有数据");
				else 
				{
					var chartrender = document.getElementById("chartrender");
					chartrender.innerHTML = "<div><span id='chartrender0'></span><br/><span seq=0><input type='button' value='折线图' onClick=\"javaScript:chart('../../resources/chart/Charts/FCF_MSLine.swf',this.parentNode.seq);\" class='form_button' />&nbsp;<input type='button' value='柱状图' onClick=\"javaScript:chart('../../resources/chart/Charts/FCF_MSColumn3D.swf',this.parentNode.seq);\" class='form_button' /></span></div><br/>"
					chart("../../resources/chart/Charts/FCF_MSColumn3D.swf");
				}
			}
		});
	}
	
	function kpiCompare()
	{
		var a = window.location+"";
		a = a.substring(a.indexOf("?")+1,a.length);
		renderChart({
			url: "../action.jsp?appName=<%=request.getParameter("appName")%>&method=chartkpicompare",
			loadmask : true,
			param: a + "&zoomin=true"
		});
	}
	
  </script>
  <body onload="kpiCompare()">
  <div id="chartrender" style="text-align: center;"></div>
</body>
</html>

