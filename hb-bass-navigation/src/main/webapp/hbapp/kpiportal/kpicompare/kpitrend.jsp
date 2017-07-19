<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimHelper"%>
<%@ include file="../../resources/old/loadmask.htm"%>
<%@page deferredSyntaxAllowedAsLiteral="true" %>
<%
String appName = request.getParameter("appName");
String zbCode = request.getParameter("zbcode");
String zbName = request.getParameter("zbname");
String area = request.getParameter("area");
String brand = request.getParameter("brand");
String date = request.getParameter("date");
String percentType = request.getParameter("percentType");
%>
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
	<style type="text/css">
	 .form_input{
		width:130px;}
	 .form_select{
		width:130px;}
	</style>
  </head>
<script type="text/javascript">
hbbasscommonpath="../../resources/old/"
rendertable=renderCompbody;
var appName = "<%=appName%>";

function chart(chartSWF){
	var chart = new FusionCharts(chartSWF, "ChartId", "780", "250");
	chart.setDataXML(data);
	chart.addParam("wmode","transparent");
	chart.render("chartrender0");
}

var comparecellfunc = ("<%=percentType%>"=="percent")?percentFormat:numberFormatDigit2;
	
function renderChart(options){
	var ajax = new AIHBAjax.Request({
		url:options.url,
		loadmask : options.loadmask != undefined?options.loadmask:true, 
		param:options.param,
		callback:function(foo){
			data = foo.responseText;
			if(data=="")alert("没有数据");
			else{
				var chartrender = document.getElementById("chartrender");
				chartrender.innerHTML = "<div><span id='chartrender0'></span>"
				chart("../../resources/chart/Charts/FCF_MSLine.swf");
			}
		}
	});
}

function kpiCompare(){
	var sArea= getAreaCode();
	sArea = "'"+sArea+"'";
	durafrom = $('dura_from').value;
	durato = $('dura_to').value;
	var sZbcode = "<%=zbCode%>"
	ajaxSubmit({
		url: "../action.jsp?appName=<%=appName%>&method=kpicompare",
		loadmask : true,
		param: "area="+sArea+"&durafrom="+durafrom+"&durato="+durato+"&zbcode="+sZbcode
	});
	
	renderChart({
		url: "../action.jsp?appName=<%=appName%>&method=chartkpicompare",
		loadmask : true,
		param: "area="+sArea+"&durafrom="+durafrom+"&durato="+durato+"&zbcode="+sZbcode+"&zbname=<%=zbName%>"
	});
}
function selGrid(){
	//tabAdd({url:"${mvcPath}/hbapp/app/ent/grid/grid_sel.htm?cityId=0" ,title:"选择网格"});
	var gridId = window.showModalDialog("${mvcPath}/hbapp/app/ent/grid/grid_sel.htm?cityId=<%=request.getParameter("area")%>","","dialogWidth=800px;dialogHeight=600px;location=no");
	if(gridId){
		var result = gridId.split("@");
		$("node").value = result[0];
		$("selNodeName").value = result[1];
	}
}
</script>
<body onload="initialTrendDate('<%=date%>');">
<form action="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top">
        <div class="portlet">
	    	<div class="title">
	    		维度选择
	    	</div>
	    	<div class="content" style="text-align: left;">
	    		<table cellspacing="0" cellpadding="0" border="0">
					<tr class="dim_row">
						<td style="padding-right:10px;">
						<input type="text" id="dura_from" name="dura_from" class="form_input_between" value="20080924"> - <input type="text" id ="dura_to" name="dura_to" class="form_input_between" value="20081004">
						</td>
						<%if(appName!=null && !appName.startsWith("EntGrid")) {%>
						<td>地市</td>
						<td><%=BassDimHelper.areaCodeHtml("city","0","{areacombo(1,true);}")%></td>
						<%} %>
						<%if(appName!=null && appName.startsWith("College")){%>
						<td>高校</td>
						<td><%=BassDimHelper.comboSeleclHtml("college","")%></td>
						<td>品牌</td>
						<td><%=BassDimHelper.selectHtml("brands","","")%></td>
						<%}else if(appName!=null && appName.startsWith("Bureau")){%>
						<td>县域</td>
						<td><%=BassDimHelper.comboSeleclHtml("county_bureau","{areacombo(2,true);}")%></td>
						<td>营销中心</td>
						<td><%=BassDimHelper.comboSeleclHtml("marketing_center","{areacombo(3,true);}")%></td>
						<td>乡镇</td>
						<td><%=BassDimHelper.comboSeleclHtml("town")%></td>
						<%}else if (appName!=null && appName.startsWith("Groupcust")){%>
						<td>县域</td>
						<td><%=BassDimHelper.comboSeleclHtml("entCounty","{areacombo(2,true);}")%></td>
						<td>客户经理</td>
						<td><%=BassDimHelper.comboSeleclHtml("custmgr")%></td>
						<%}else if (appName!=null && appName.startsWith("Channel")){%>
						<td>县域</td>
						<td><%=BassDimHelper.comboSeleclHtml("county","{areacombo(2,true);}")%></td>
						<td>营业网点</td>
						<td><%=BassDimHelper.comboSeleclHtml("office")%></td>
						<%}else if (appName!=null && appName.startsWith("Cs")){%>
							<td>县域</td>
							<td><%=BassDimHelper.comboSeleclHtml("county","{areacombo(2,true);kpiviewProcess()}")%></td>
							<td>品牌</td>
							<td><%=BassDimHelper.selectHtml("brands","","{kpiviewProcess('loadmask')}")%></td>
							<%}%>
						<%if(appName!=null && appName.startsWith("EntGrid")) {%>
							<td>网格<input type="text" id="selNodeName" value="" onclick="selGrid()" readonly="readonly">
									<input type="hidden" id="selNodeId" name="node" value=""></td>
							<td >
						<%}%>
						<input type="button" class="form_button_short" value="查询" onclick="kpiCompare()">					
					</tr>
				</table>
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
		    		<table width="99%"><tr><td>图表</td></table>
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
	<script type="text/javascript">
		<%if(request.getParameter("area")!=null){%>
		var sArea = "<%=request.getParameter("area")%>";
		document.forms[0].city.value = sArea;
		areacombo(1,true);
		<%}%>
	</script>
</body>
</html>

