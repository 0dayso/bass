<%@ page contentType="text/html; charset=utf-8"%>
<%@ include file="../../resources/old/loadmask.htm"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>一经报表</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/chart/FusionCharts.js"></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
  </head>
  <script type="text/javascript">
  function chart(chartSWF)
{
	var chart = new FusionCharts(chartSWF, "ChartId", "680", "580");
	chart.setDataXML(data);
	chart.addParam("wmode","transparent");
	chart.render("chartrender");
}
	
	function kpiCompare(columnName,titlename,date)
	{
		var ajax = new AIHBAjax.Request({
			url: "action.jsp?method=chartkpiconntrywide",
			//loadmask : true,
			param: "&name="+encodeURIComponent(encodeURIComponent(titlename))+"&sql=select province_name,"+columnName+",'DDDDDD' from kpi_countrywide where time_id = '"+ date+"' order by 2 desc",
			callback:function(foo)
			{
				data = foo.responseText;
				if(data=="")alert("没有数据");
				else
				{
					chart("../../resources/chart/Charts/FCF_Bar2D.swf");
				}
			}
		});
	}
  </script>
  <body>
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
</body>
</html>

