<%@ page contentType="text/html; charset=utf-8"%>
<%@page deferredSyntaxAllowedAsLiteral="true" %>
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
	<script type="text/javascript" src="../../resources/js/default/default.js"></script>
  </head>
  <script type="text/javascript">
  rendertable=renderCompbody;
  function chart(chartSWF)
{
	var chart = new FusionCharts(chartSWF, "ChartId", "780", "280");
	chart.setDataXML(data);
	chart.addParam("wmode","transparent");
	chart.render("chartrender0");
}

 var comparecellfunc = (parent.comparePercent=="percent")?percentFormat:numberFormatDigit2;
	
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
	var sArea="";
	var appName = parent.appName;
	function kpiCompare(options)
	{
		var areas = options.areas;
		
		if(1>areas.length)
		{	
			alert("请选择地域");
		}
		else
		{
			sArea="";
			for(var a=0;a<areas.length;a++)
			{
				if(sArea.length>0)sArea+=",";
				sArea+="'"+areas[a].replace(/_/gi,".")+"'";
			}
			durafrom = options.durafrom;
			durato = options.durato;
			
			var sZbcode = parent.compareZbcode;
			ajaxSubmit({
			url: "../action.jsp?appName="+appName+"&method=kpicompare",
			loadmask : true,
			param: "area="+sArea+"&durafrom="+durafrom+"&durato="+durato+"&zbcode="+sZbcode
			});
			
			renderChart({
			url: "../action.jsp?appName="+appName+"&method=chartkpicompare",
			loadmask : true,
			param: "area="+sArea+"&durafrom="+durafrom+"&durato="+durato+"&zbcode="+sZbcode+"&zbname="+parent.compareZbname
			});
		}
	}
	
	function zoomin()
	{
		if(sArea!="")
		{
			var url = "kpichartlarge.jsp?appName="+appName+"&area="+sArea+"&durafrom="+durafrom+"&durato="+durato+"&zbcode="+parent.compareZbcode+"&zbname="+encodeURIComponent(parent.compareZbname)
			window.open(url);
		}
		else alert("请先点击比较");
	}
  </script>
  <body>
  <form action="">
    <table width="99%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td valign="top">
	        <div class="portlet">
		    	<div class="title">
		    		<table width="97%"><tr><td>图表</td><td align="right"><img src="../../resources/image/default/zoomin.gif" onclick="zoomin()" style="cursor: hand" >放大</img></td></tr></table>
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
		            	<table id="resultTable" align="left" width="#{width}"  class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">	
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
<script>
aihb.Util.loadmask();
aihb.Util.watermark();
</script>
