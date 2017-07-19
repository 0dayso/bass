<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.kpiportal.service.KPIPortalService"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimHelper"%>
<%@ include file="../../resources/old/loadmask.htm"%>
<%
//KPICustomize.init();
//处理KPI应用
String appName = "CollegeD";
String regionId=request.getParameter("college_id");
String date = request.getParameter("queryTime");
//判断看地市
String userid = (String)session.getAttribute("loginname");
if(userid==null||userid.length()==0)userid="default";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>KPI统一视图</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/chart/FusionCharts.js"></script>
	<script type="text/javascript" src="../../resources/js/default/calendar.js"></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/fluctuating_conf.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/notice.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
  </head>
  <script type="text/javascript">
  	appName ="<%=appName%>";
  	hbbasscommonpath="../../resources/old/"
  	pagenum=200;
  	rendertable=renderSelbody;
  	
	var threshold = new Threshold();
	threshold.path="../../resources/image/default/";
	cellclass[0]="grid_row_cell_text";
	cellclass[1]="grid_row_cell_number";
	cellclass[2]="grid_row_cell_number";
	cellclass[3]="grid_row_cell_number";
	cellclass[4]="grid_row_cell_number";
	cellclass[5]="grid_row_cell_number";
	cellclass[6]="grid_row_cell_number";
	cellclass[7]="grid_row_cell_number";

	function indicatorInstruction(id,obj){
		
		$("help_div").style.left = event.clientX + document.body.scrollLeft - document.body.clientLeft + 50;
		$("help_div").style.top = event.clientY + document.body.scrollTop - document.body.clientTop -20 ;
		
		var ajax = new AIHBAjax.Request({
			url:"../action.jsp?appName="+appName+"&method=instruction",
			param:"&zbcode="+id,
			sync:false,
			callback:function(xmlHttp){
				document.getElementById("help_div").style.display="";
				$("instructionText").innerText=xmlHttp.responseText;
			}
		});
	}

	<%if(appName.endsWith("M")){%>
	cellfunc[0] =function(datas,options){
		return "<img src='../../resources/image/default/detail.gif' onmouseout=\"$('help_div').style.display='none';\" onmouseover='javascript:indicatorInstruction(\""+datas[9]+"\",event)' title='指标说明' border=0>"+"<a href='#' onclick='{chartswf=\"1\";chartCurZbcode=\""+datas[9]+"\";valuetype=\"\";kpiviewProcess(\"chart\");}'>"+datas[options.seq]+"</a>";
	}
	cellfunc[1] =function(datas,options){return chartLink(datas,options,datas[9],datas[8],"");};
	cellfunc[2] =function(datas,options){return chartLink(datas,options,datas[9],datas[8],"pre");};
	cellfunc[3] =function(datas,options){return chartLink(datas,options,datas[9],datas[8],"before");};
	cellfunc[4] =function(datas,options){return "<a href='#' title='点击查看\"环比增长\"图表' onclick='{chartswf=\"2\";chartCurZbcode=\""+datas[9]+"\";valuetype=\"huanbi\";kpiviewProcess(\"chart\");}'>"+percentFormat(datas,options)+"</a>"+((datas[9] in hasFluctuating)?threshold.getHuanbiImg(datas[options.seq],datas[9],datas[0],"huanbi"):threshold.getTongbiImg(datas[options.seq],datas[9],datas[0],"huanbi"));};
	cellfunc[5] =function(datas,options){return "<a href='#' title='点击查看\"同比增长\"图表' onclick='{chartswf=\"2\";chartCurZbcode=\""+datas[9]+"\";valuetype=\"tongbi\";kpiviewProcess(\"chart\");}'>"+percentFormat(datas,options)+"</a>"+threshold.getTongbiImg(datas[options.seq],datas[9],datas[0],"tongbi");};
	cellfunc[6] =function(datas,options){if(isNumber(datas[options.seq])){var str=(datas[8]=="percent")?percentFormat(datas,options):numberFormatDigit2(datas,options);return str;}else return "--";};
	cellfunc[7] =jindu;
	
	cellfunc[8] =function(datas,options){return "<a href='#' onclick='progress(\""+datas[0]+"\",\""+datas[9]+"\",\""+datas[8]+"\");'><img src='../../resources/image/default/topmenu_icon02.gif' border='0' title='深度分析'></img></a>";};
	cellfunc[9]=_customize;
	seqformat[1]="当月数值";
	function hiddenColumns(isShow){
	
		if(!isShow)seqformat[1]="当月数值<img id='iopen' src='../../resources/image/default/right_2.gif' onmouseout=\"$('help_div').style.display='none';\" onmouseover=\"{this.src='../../resources/image/default/right_1.gif'}\" onmouseout=\"{this.src='../../resources/image/default/right_2.gif'}\" style='cursor: hand;' title='点击展开' onclick='hiddenColumns(true);'/>";
		else seqformat[1]="当月数值";
		selectColumns(2,isShow);
		selectColumns(3,isShow);
		renderGrid();
	}
	
	<%}else{%>
	seqformat[1]="当日数值";
	cellfunc[0] =function(datas,options){
		return "<img src='../../resources/image/default/detail.gif' onmouseout=\"$('help_div').style.display='none';\" onmouseover='javascript:indicatorInstruction(\""+datas[10]+"\",event)' title='指标说明' border=0>"+"<a href='#' onclick='{chartswf=\"1\";chartCurZbcode=\""+datas[10]+"\";valuetype=\"\";kpiviewProcess(\"chart\");}'>"+datas[options.seq]+"</a>";
	}
	cellfunc[1] =function(datas,options){return chartLink(datas,options,datas[10],datas[9],"");};
	cellfunc[2] =function(datas,options){return chartLink(datas,options,datas[10],datas[9],"pre");};
	cellfunc[3] =function(datas,options){return chartLink(datas,options,datas[10],datas[9],"before");};
	cellfunc[4] =function(datas,options){return chartLink(datas,options,datas[10],datas[9],"year");};
	cellfunc[5] =function(datas,options){return "<a href='#' title='点击查看\"环比增长\"图表' onclick='{chartswf=\"2\";chartCurZbcode=\""+datas[10]+"\";valuetype=\"huanbi\";kpiviewProcess(\"chart\");}'>"+percentFormat(datas,options)+"</a>"+((datas[10] in hasFluctuating)?threshold.getHuanbiImg(datas[options.seq],datas[10],datas[0],"huanbi"):threshold.getTongbiImg(datas[options.seq],datas[10],datas[0],"huanbi"));};
	cellfunc[6] =function(datas,options){return "<a href='#' title='点击查看\"月同比增长\"图表' onclick='{chartswf=\"2\";chartCurZbcode=\""+datas[10]+"\";valuetype=\"tongbi\";kpiviewProcess(\"chart\");}'>"+percentFormat(datas,options)+"</a>"+((datas[10] in hasFluctuating)?threshold.getHuanbiImg(datas[options.seq],datas[10],datas[0],"tongbi"):threshold.getTongbiImg(datas[options.seq],datas[10],datas[0],"tongbi"));};
	cellfunc[7] =function(datas,options){return "<a href='#' title='点击查看\"年同比增长\"图表' onclick='{chartswf=\"2\";chartCurZbcode=\""+datas[10]+"\";valuetype=\"yeartongbi\";kpiviewProcess(\"chart\");}'>"+percentFormat(datas,options)+"</a>"+threshold.getTongbiImg(datas[options.seq],datas[10],datas[0],"yeartongbi");};
	
	cellfunc[8] =function(datas,options){
		var progressNum = datas[options.seq].split("@")[0]
		var target = datas[options.seq].split("@")[1];
		var str=(datas[9]=="percent")?percentFormat(progressNum):numberFormatDigit2(progressNum);
		if(isNumber(progressNum))
			return "<span title='考核目标："+str+"'><a href='#' onclick='{chartswf=\"2\";valuetype=\"progress\";kpiprogressProcess(\"chart\");}'>"+percentFormat(progressNum)+"</a></span>";
		else return "--";
	};
	
	cellfunc[9] =function(datas,options){return "<a href='#' onclick='progress(\""+datas[0]+"\",\""+datas[10]+"\",\""+datas[9]+"\");'><img src='../../resources/image/default/topmenu_icon02.gif' border='0' title='深度分析'></img></a>";};
	cellfunc[10]=_customize;
	
	function hiddenColumns(isShow)
	{
		if(!isShow)seqformat[1]="当日数值<img id='iopen' src='../../resources/image/default/right_2.gif' onmouseover=\"{this.src='../../resources/image/default/right_1.gif'}\" onmouseout=\"{this.src='../../resources/image/default/right_2.gif'}\" style='cursor: hand;' title='点击展开' onclick='hiddenColumns(true);'/>";
		else seqformat[1]="当日数值";
		selectColumns(2,isShow);
		selectColumns(3,isShow);
		selectColumns(4,isShow);
		
		renderGrid();
	}
	
	<%}%>
	
	var cur_custom="all";
	gridCurZbcode = "all";
	function _customize(datas,option){
		if(new RegExp(datas[option.seq], "gi").test(cur_custom))
			return '<input type="checkbox" checked="checked" name="kpidisplay"  onclick="kpicustomeize(\''+datas[option.seq]+'\',this);">';
		else
			return '<input type="checkbox" name="kpidisplay"  onclick="kpicustomeize(\''+datas[option.seq]+'\',this);">';
	}
	
	function changetab(id){
		var obj=event.srcElement;
		while(obj.tagName!="TD") obj=obj.parentElement;
		var cellindex=obj.cellIndex;
		while(obj.tagName!="TABLE") obj=obj.parentElement;
		if(obj.lastcell) {obj.rows[0].cells[obj.lastcell].style.backgroundImage="url(../../resources/image/default/tab2.png)";}
		else{obj.rows[0].cells[0].style.backgroundImage="url(../../resources/image/default/tab2.png)";}
		obj.lastcell=cellindex;
		obj.rows[0].cells[cellindex].style.backgroundImage="url(../../resources/image/default/tab1.png)";
		
		if(id!="cust"){
			gridCurZbcode=id;
			chartCurZbcode=id;
			document.getElementById("divmore").style.display="none";
		}
		else{
			chartCurZbcode=cur_custom.split(",")[0];
			document.getElementById("divmore").style.display="";
			if(document.getElementById("divmore").flag=="0")gridCurZbcode="all";
			else gridCurZbcode=undefined;
		}
		kpiviewProcess();
	}
	
	<%if(appName!=null && appName.startsWith("Bureau")){%>
	function areacombo(i,sync)
	{
		selects = new Array();
		selects.push(document.forms[0].city);
		sqls = new Array();
		//debugger
		if(document.forms[0].county != undefined)
		{
			selects.push(document.forms[0].county);
			sqls.push("select region_id key,region_name value  from kpi_bureau_cfg where parent_id= '#value' order by 1 with ur");
		}
		
		if(document.forms[0].district!= undefined)
		{
			selects.push(document.forms[0].district);
			sqls.push("select region_id key ,region_name value  from kpi_bureau_cfg where parent_id= '#value' order by 1 with ur");
		}
		
		if(document.forms[0].town!= undefined)
		{
			selects.push(document.forms[0].town);
			sqls.push("select region_id key,region_name value  from kpi_bureau_cfg where parent_id= '#value' order by 1 with ur");
		}
		//调用联动方法
		var bl = false;
		if(sync!=undefined)bl=sync;
		combolink(selects,sqls,i,bl);
	}
	<%} else if(appName!=null && appName.startsWith("College")){%>
	function areacombo(i,sync)
	{
		selects = new Array();
		selects.push(document.forms[0].city);
		sqls = new Array();
		//debugger
		if(document.forms[0].college != undefined)
		{
			selects.push(document.forms[0].college);
			sqls.push("select college_id key,college_name value  from nwh.college_info where area_id='#value' with ur");
		}
		//调用联动方法
		var bl = false;
		if(sync!=undefined)bl=sync;
		combolink(selects,sqls,i,bl);
	}
	<%} %>
  </script>
  <body onload="kpiviewProcess('grid');">
  <form action="">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="display: none;">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div  class="portlet">
		    	<div class="title">
		    		<table width="99%"><tr>
		    		<td width="20%">维度选择</td>
		    		<td width="70%"><div id=marqueeBox style="font-size: 12px;line-height:18px;overflow:hidden;height:20 px" onmouseover="clearInterval(marqueeInterval[0])" onmouseout="marqueeInterval[0]=setInterval('startMarquee()',marqueeDelay)"></div></td>
		    		<td width="10%" align="right"><img src="../../resources/image/default/feedback.gif" style="cursor: hand;" bordor=0 onclick='{/*parent.parent.topFrame.theCreateTab.add("意见反馈,mainFrame,feedback.jsp*/");}' title="意见反馈">意见反馈</img></td>
		    		</tr></table>
		    	</div>
		    	<div id="dim" class="content">
	            	<table cellspacing="0" cellpadding="0" border="0">
						<tr class="dim_row">
							<td>时间</td>
							<td>
							<%
							if(appName.endsWith("M"))
								out.print(BassDimHelper.monthHtml("date","{kpiviewProcess('loadmask')}",KPIPortalService.getKPIAppData(appName).getCurrent(),-1));
							else
								//out.print(BassDimHelper.date("date",KPIPortalService.getKPIAppData(appName).getCurrent(),"function(){kpiviewProcess('loadmask')}"));
								out.print(BassDimHelper.date("date",date,"function(){kpiviewProcess('loadmask')}"));
							%>
							<input type="text" name="college" value="<%=regionId %>">
						</tr>
					</table>
				 </div>
        	</div>
	    </td>
	  </tr>
	</table>

		<div id="grid" class="content" style="text-align: left;">
    		<table style="border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:#ffffff;border-top:0px;border-bottom:0px;" border=1>
			<tr height="21px" valign="top" style="padding-bottom:0px;padding-top:3px;WIDTH: 100%; border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:81A3F5">
				<td  class="tab" background=../../resources/image/default/tab1.png onclick='changetab("all");'>我的定制</TD>
				<td  class="tab" background=../../resources/image/default/tab2.png onclick='changetab("user");'>用户指标</TD>
				<td  class="tab" background=../../resources/image/default/tab2.png onclick='changetab("income");'>收入指标</TD>
				<td  class="tab" background=../../resources/image/default/tab2.png onclick='changetab("traffic");'>话务指标</TD>
			</tr>
			</table>
    		<div id="showResult" style="margin-left: 0px; padding-left: 0px;float: left;width: auto;height: 375 px;overflow-y:scroll;word-break:break-all;"></div>
	    	<img style="display:none;" id="divmore" flag='1' onclick="displaymore(this);" src="../../resources/image/default/ns-expand.gif" title="显示更多指标">
	    	<div id="title_div" style="display:none;">
            	<table id="resultTable" align="left" width="100%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="grid_title_blue" style="position:relative;top:expression(this.offsetParent.scrollTop);">
					   <span id =0><td class="grid_title_cell" width="23%">指标名称</td></span>
					   <span id =1><td class="grid_title_cell">#1</td></span>
					   <span id =2><td class="grid_title_cell">前日数值</td></span>
					   <span id =3><td class="grid_title_cell">上月同期</td></span>
					   <span id =4><td class="grid_title_cell"><img id='iclose' src='../../resources/image/default/left_2.gif' onmouseover="{this.src='../../resources/image/default/left_1.gif'}" onmouseout="{this.src='../../resources/image/default/left_2.gif'}" style='cursor: hand;' title='点击隐藏' onclick="hiddenColumns(false);"/>去年同期</td></span>
					   <span id =5><td class="grid_title_cell">环比增长</td></span>
					   <span id =6><td class="grid_title_cell">月同比</td></span>
					   <span id =7><td class="grid_title_cell">年同比</td></span>
					   
					   <span id =8><td class="grid_title_cell">完成情况</td></span>
					   <span id =9><td class="grid_title_cell">深度分析</td></span>
					   <span id =10><td class="grid_title_cell">定制</td></span>
					</tr>
				</table>
			</div>
       	</div>
	</form>
</body>
</html>
<script>
selectColumns(8,false);
selectColumns(9,false);
selectColumns(10,false);
</script>
