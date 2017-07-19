<%@ page contentType="text/html; charset=utf-8" deferredSyntaxAllowedAsLiteral="true"%>
<%@ include file="../../resources/old/loadmask.htm"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
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
<html>
  <head>
    <title>收入预测分析</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/chart/FusionCharts.js"></script>
	<script type="text/javascript" src="../../kpiportal/localres/kpi.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
  </head>
  <script type="text/javascript">
  	
	hbbasscommonpath="../../resources/old/";

	function chargeAlert()
	{
		renderChart({
			url: "action.jsp?method=chargeForecast&type=chart",
			param: "",
			width : "880",
			height : "220",
			chartid:"chartrender",
			chartSWF : ChartSwf["4"]
		});
	}
	
var arrSrc = [];
arrSrc["f2"]="chargeForecastGrid.jsp?type=city";

function changetab(id)
{
  var obj=event.srcElement;
	while(obj.tagName!="TD") obj=obj.parentElement;
	var cellindex=obj.cellIndex;
	while(obj.tagName!="TABLE") obj=obj.parentElement;
	if(obj.lastcell) {obj.rows[0].cells[obj.lastcell].style.backgroundImage="url(../../resources/image/default/tab2.png)";}
	else{obj.rows[0].cells[0].style.backgroundImage="url(../../resources/image/default/tab2.png)";}
	obj.lastcell=cellindex;
	obj.rows[0].cells[cellindex].style.backgroundImage="url(../../resources/image/default/tab1.png)";
	
	var ifrs = document.getElementsByTagName("iframe");
	for(var j=0;j<ifrs.length;j++)
	{
		var curIfr = ifrs[j];
		if(curIfr.name==id)
		{
			curIfr.style.display="";
			if(curIfr.attributes["isload"].nodeValue=="0"){curIfr.src=arrSrc[id];curIfr.setAttribute("isload","1");}
		}
		else curIfr.style.display="none";
	}
}
  </script>
  <body onload='chargeAlert()'>
  <form action="">
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
		    		<table style="border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:#ffffff;border-top:0px;border-bottom:0px;" border=1>
					<tr height="21px" valign="top" style="padding-bottom:0px;padding-top:3px;WIDTH: 100%; border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:81A3F5">
						<td nowrap class="tab" background=../../resources/image/default/tab1.png onclick='changetab("f1");'>预测收入</TD>
						<td nowrap class="tab" background=../../resources/image/default/tab2.png onclick='changetab("f2");'>分地市</TD>
					</tr>
					</table>
		    	</div>
		    	<div id="grid" class="content" style="width: 100%; height: 300px;">
		    		
		    		<table height=100% width=100% border=1 bordercolor=91aed0 style="border-collapse:collapse;color:000206;font-size:12px" cellspacing=0 cellpadding=4>
					<tr>
						<td>
							<iframe frameborder=0 scrolling="no" width=100% height=100% id=f1 name=f1 src="chargeForecastGrid.jsp" isload="1"></iframe>
							<iframe frameborder=0 scrolling="no" width=100% height=100% id=f2 name=f2 isload="0" style="display:none"></iframe>
						</td>
					</tr>
					</table>
	        	<!-- <div style="padding: 3 px;">算法：200910月收入=（200901～200909最后一天的收入/200901～200909倒数第2天的收入）×20091030的收入</div> -->
        	</div>
	    </td>
	  </tr>
	</table>
	</form>
</body>
</html>

