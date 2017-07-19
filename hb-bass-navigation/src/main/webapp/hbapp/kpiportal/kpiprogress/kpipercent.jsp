<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimHelper"%>
<%@ include file="../../resources/old/loadmask.htm"%>
<%
//处理KPI应用
String appName = request.getParameter("appName");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>KPI进度监控</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/chart/FusionCharts.js"></script>
	<script type="text/javascript" src="../../resources/js/default/calendar.js"></script>
	<script type="text/javascript" src="../../resources/js/default/tabext.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/fluctuating_conf.js" charset=utf-8></script>
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
  	var kpiname = "<%=request.getParameter("zbname")/*new String(request.getParameter("zbname").getBytes("iso-8859-1"),"gbk")*/%>";
  	var appName = "<%=appName%>"
	chartCurZbcode = "<%=request.getParameter("zbcode")%>";
	cellclass[0]="grid_row_cell_text";
	cellclass[1]="grid_row_cell_number";
	cellclass[2]="grid_row_cell_number";
	cellclass[3]="grid_row_cell_number";
	cellclass[4]="grid_row_cell_number";
	cellclass[5]="grid_row_cell_number";
	cellclass[6]="grid_row_cell_number";
	cellclass[7]="grid_row_cell_number";
	
	<%String percentType=request.getParameter("percentType");%>
	
	function judgeValue(datas,options){
		if(isNumber(datas[options.seq])){var str=("<%=percentType%>"=="percent")?percentFormat(datas,options):numberFormatDigit2(datas,options);return str;}else return "--";
	}
	
	function chartLink(datas,options,valuetype){
		var str=judgeValue(datas,options);
		return chartLink2("5",valuetype,str);
	}
	
	function chartLink2(charttype,valuetype,str){return "<a href='#' onclick='{chartswf=\""+charttype+"\";valuetype=\""+valuetype+"\";kpiprogressProcess(\"chart\");}'>"+str+"</a>";}
	
	//function bodong(datas,options){return "<a href='#' ><img src='images/topmenu_icon01.gif' border='0' title='波动分析'></img></a>";}
	
	var threshold = new Threshold();
	threshold.path="../../resources/image/default/";
	cellfunc[0] =function(datas,options){return datas[0].split("@")[1];};
	cellfunc[1] =function(datas,options){return chartLink(datas,options,"");};
	cellfunc[2] =function(datas,options){return chartLink(datas,options,"pre");};
	cellfunc[3] =function(datas,options){return chartLink(datas,options,"before");};
	<%
	String date = request.getParameter("date");
	if(date.length()==8)
	{
	%>
	cellclass[8]="grid_row_cell_number";
	cellclass[9]="grid_row_cell_number";
	cellclass[10]="grid_row_cell_number";
	//arguments[0][arguments[1].seq]
	cellfunc[4] =function(datas,options){return chartLink(datas,options,"year");};
	cellfunc[5] =function(datas,options){return chartLink2("5","huanbi",percentFormat(datas,options))+((chartCurZbcode in hasFluctuating)?threshold.getHuanbiImg(datas[options.seq],chartCurZbcode,kpiname,"huanbi",datas[0]):threshold.getTongbiImg(datas[options.seq],chartCurZbcode,kpiname,"huanbi",datas[0]));};
	cellfunc[6] =function(datas,options){return chartLink2("5","tongbi",percentFormat(datas,options))+((chartCurZbcode in hasFluctuating)?threshold.getHuanbiImg(datas[options.seq],chartCurZbcode,kpiname,"tongbi",datas[0]):threshold.getTongbiImg(datas[options.seq],chartCurZbcode,kpiname,"tongbi",datas[0]));};
	cellfunc[7] =function(datas,options){return chartLink2("5","yeartongbi",percentFormat(datas,options))+threshold.getTongbiImg(datas[options.seq],chartCurZbcode,kpiname,"yeartongbi",datas[0]);};
	
	cellfunc[8] =judgeValue;
	cellfunc[9] =jindu;
	//cellfunc[10]=bodong;
	cellfunc[10]=gap;
	<%}else{%>
	
	cellfunc[4] =function(datas,options){return chartLink2("5","huanbi",percentFormat(datas,options))+((chartCurZbcode in hasFluctuating)?threshold.getHuanbiImg(datas[options.seq],chartCurZbcode,kpiname,"huanbi",datas[0]):threshold.getTongbiImg(datas[options.seq],chartCurZbcode,kpiname,"huanbi",datas[0]));};
	cellfunc[5] =function(datas,options){return chartLink2("5","tongbi",percentFormat(datas,options))+threshold.getTongbiImg(datas[options.seq],chartCurZbcode,kpiname,"tongbi",datas[0]);};
	
	cellfunc[6] =judgeValue;
	cellfunc[7] =jindu;
	cellfunc[8]=gap;
	//cellfunc[8] =bodong;
	<%}%>
	var detailoffice = false;
	function detailOffice(obj)
	{
		if(document.forms[0].county.value=="")
		{
			detailoffice=obj.checked;
			kpiprogressProcess();
		}
		else
		{
			detailoffice="false";
		}
	}
	
	function toDown()
	{
		var str="";
		var titlerows = arguments[0]||1;
		for(var k=0;k<titlerows;k++)
		{
			var objCell=resultTableDown.rows[k];
			if(str.length>0)str += "\r\n";
			for(var j=0;j<objCell.cells.length;j++)str+= objCell.cells[j].innerText.replace("\r\n","")+",";
	  	}
		var sArea = getAreaCode();
		
		var sDate = document.forms[0].date.value;
		document.forms[0].action = "../action.jsp?appName="+appName+"&method=down&area="+sArea+"&date="+sDate+"&detailoffice="+detailoffice+"&zbcode="+chartCurZbcode+"&filename="+"kpiexport"+"&title="+str;
		document.forms[0].target = "_top";
		document.forms[0].submit();
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
  <body>
  <form action="" method="post">
  <table width="99%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div  class="portlet">
		    	<div class="title">
		    		维度选择
		    	</div>
		    	<div id="dim" class="content">
	            	<table cellspacing="0" cellpadding="0" border="0">
						<tr class="dim_row">
						<td >时间</td>
						<td>
						<%
						if(date.length()==8)
							out.print(BassDimHelper.date("date",date,"function(){kpiprogressProcess('loadmask')}"));
						else if(date.length()==6) 
							out.print(BassDimHelper.monthHtml("date","kpiprogressProcess('loadmask')",date));
						%>
						</td>
						<%if(appName!=null && !appName.startsWith("EntGrid")) {%>
						<td >地市</td>
						<td><%=BassDimHelper.areaCodeHtml("city","0","{areacombo(1,true);kpiprogressProcess()}")%></td>
						<%}%>	
						<%if(appName!=null && appName.startsWith("College")) {%>
						<td>高校</td>
						<td><%=BassDimHelper.comboSeleclHtml("college","kpiprogressProcess()")%></td>
						<td>品牌</td>
						<td><%=BassDimHelper.selectHtml("brands","","{kpiprogressProcess('loadmask')}")%></td>
						<%}else if(appName!=null && appName.startsWith("Bureau")){%>
							<td>县域</td>
							<td><%=BassDimHelper.comboSeleclHtml("county_bureau","{areacombo(2,true);kpiprogressProcess()}")%></td>
							<td>营销中心</td>
							<td><%=BassDimHelper.comboSeleclHtml("marketing_center","{areacombo(3,true);kpiprogressProcess()}")%></td>
							<td>乡镇</td>
							<td><%=BassDimHelper.comboSeleclHtml("town")%></td>
							<td><input type="button" class="form_button" value="导出数据" onclick="toDown()"></td>
						<%}else if (appName!=null && appName.startsWith("Groupcust")){%>
							<td>县域</td>
							<td><%=BassDimHelper.comboSeleclHtml("entCounty","{areacombo(2,true);kpiprogressProcess()}")%></td>
							<td>客户经理</td>
							<td><%=BassDimHelper.comboSeleclHtml("custmgr")%></td>
						<%}else if (appName!=null && appName.startsWith("Channel")){%>
							<td>县域</td>
							<td><%=BassDimHelper.comboSeleclHtml("county","{areacombo(2,true);kpiprogressProcess()}")%></td>
							<td>营业网点</td>
							<td><%=BassDimHelper.comboSeleclHtml("office")%></td>
							<td >细分网点</td>
							<td ><input type="checkbox" name="detailofficee" onclick="detailOffice(this)"></td>
							<td ><input type="button" class="form_button" value="导出数据" onclick="toDown()"></td>
						<%}%>
						<%if(appName!=null && appName.startsWith("EntGrid")) {%>
							<td>网格<input type="text" id="selNodeName" value="" onclick="selGrid()" readonly="readonly">
									<input type="hidden" id="selNodeId" name="node" value=""></td>
							<td ><input type="button" class="form_button_short" value="查询" onclick="kpiprogressProcess()"></td>
						<%}%>						
						</tr>
					</table>
				 </div>
        	</div>
	    </td>
	  </tr>
	</table>
    <table width="99%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td>
	        <div class="portlet">
		    	<div class="title" >
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
		    	<div id="kpititle" class="title">
		    	</div>
		    	<div id="grid" class="content">
			    	<div id="showResult" style="overflow:auto;height:200px;"></div>
		            <div id="title_div" style="display:none;">
		            	<table id="resultTable" align="center" width="96%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
							<tr class="grid_title_blue" style="position:relative;top:expression(this.offsetParent.scrollTop);">
								<%
							   if(date.length()==8){
							   %>
							   <td class="grid_title_cell">地域</td>
							   <td class="grid_title_cell">当日数值</td>
							   <td class="grid_title_cell">前日数值</td>
							   <td class="grid_title_cell">上月同期</td>
							   <td class="grid_title_cell">去年同期</td>
							   <td class="grid_title_cell">环比增长</td>
							   <td class="grid_title_cell">月同比增长</td>
							   <td class="grid_title_cell">年同比增长</td>
							   <td class="grid_title_cell">考核目标</td>
							   <td class="grid_title_cell">完成进度</td>
							   <td class="grid_title_cell">进度差距</td>
							   <%}else{%>
							   <td class="grid_title_cell">地域</td>
							   <td class="grid_title_cell">当月数值</td>
							   <td class="grid_title_cell">上月数值</td>
							   <td class="grid_title_cell">去年同期</td>
							   <td class="grid_title_cell">环比增长</td>
							   <td class="grid_title_cell">同比增长</td>
							   <td class="grid_title_cell">考核目标</td>
							   <td class="grid_title_cell">完成进度</td>
							   <td class="grid_title_cell">进度差距</td>
							   <%}%>
							</tr>
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
		areacombo(1,true);kpiprogressProcess();
		<%}%>
	</script>
</body>
</html>
