<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPICustomize"%>
<%@page import="com.asiainfo.hbbass.kpiportal.service.KPIPortalService"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimHelper"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIPortalContext"%>
<%@page deferredSyntaxAllowedAsLiteral="true" %>
<%
//KPICustomize.init();
//处理KPI应用
//KPIPortalService.refreshKPIEntities("BureauD","20100707");
String appName = request.getParameter("appName");
String kind = request.getParameter("kind");
if(kind==null){
	kind="";
}
//KPIPortalContext.resetDate("BureauD","20100804");
//KPIPortalContext.resetDate("GroupcustD","20100707");
//if("BureauD".equalsIgnoreCase(appName))KPIPortalService.getKPIAppData(appName).setCurrent("20090503");
//if("ChannelM".equalsIgnoreCase(appName))KPIPortalService.getKPIAppData(appName).setCurrent("200811");
//if("CollegeD".equalsIgnoreCase(appName))KPIPortalService.getKPIAppData(appName).setCurrent("20090828");
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
	<script type="text/javascript" src="../../../hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="../../resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<!--  script type="text/javascript" src="../localres/click.js" charset=utf-8></script-->
	<script type="text/javascript" src="../localres/fluctuating_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
	<script type="text/javascript" src="../../resources/js/default/default.js"></script>
	<script type="text/javascript" src="../../resources/js/default/autocomplete.js"></script>
	<script type="text/javascript" src="../../resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="../../resources/js/default/timeline.js"></script>
  </head>
  <style type="text/css">
  .form_input{width:120px;}.form_select{width:120px;}
  </style>
  <script type="text/javascript">
  //判断是否能复制
	if('<%=userid%>' != 'lizj')	{
		var fileref = document.createElement("script");
		fileref.setAttribute("type","text/javascript");
		fileref.setAttribute("src","../localres/click.js");
		if (typeof(fileref) != "undefined"){
			document.getElementsByTagName("head")[0].appendChild(fileref);
		}
	}
  var $j=jQuery.noConflict();
  appName ="<%=appName%>";
  var kind="<%=kind%>";
  var ori={
		"ChannelD":{responsible:"孟晓莉",timeline:"每日10点",contact:"13807150018"}
		,"ChannelM":{responsible:"孟晓莉",timeline:"每月6号12点",contact:"13807150018"}
		,"BureauD":{responsible:"孟晓莉",timeline:"每日16点",contact:"13807150018"}
		,"BureauM":{responsible:"孟晓莉",timeline:"每月7号12点",contact:"13807150018"}
		,"GroupcustD":{responsible:"颜海涛",timeline:"每日16点",contact:"13807150018"}
		,"GroupcustM":{responsible:"颜海涛",timeline:"每月7号12点",contact:"13807150018"}
		,"CollegeD":{responsible:"张韬",timeline:"每日16点",contact:"13807150018"}
		,"CollegeM":{responsible:"张韬",timeline:"每月7号12点",contact:"13807150018"}
		,"CsD":{responsible:"张韬",timeline:"每日17点",contact:"13807150018"}
		,"CsM":{responsible:"张韬",timeline:"每月6号14点",contact:"13807150018"}
	}
  
  
  aihb.Util.addEventListener(window,"load",function(){
		timelineTip(ori[appName]);
	});
	
  	hbbasscommonpath="../../resources/old/"
  	pagenum=200;
  	rendertable=renderSelbody;
  	var _params = aihb.Util.paramsObj();
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
		return "<img src='../../resources/image/default/detail.gif' onclick='redirect(\""+datas[9]+"\")' onmouseout=\"$('help_div').style.display='none';\" onmouseover='javascript:indicatorInstruction(\""+datas[9]+"\",event)' title='指标说明' border=0>"+"<a href='#' onclick='{chartswf=\"1\";chartCurZbcode=\""+datas[9]+"\";valuetype=\"\";kpiviewProcess(\"chart\");}'>"+datas[options.seq]+"</a>";
	}
	cellfunc[1] =function(datas,options){return chartLink(datas,options,datas[9],datas[8],"");};
	cellfunc[2] =function(datas,options){return chartLink(datas,options,datas[9],datas[8],"pre");};
	cellfunc[3] =function(datas,options){return chartLink(datas,options,datas[9],datas[8],"before");};
	cellfunc[4] =function(datas,options){return "<a href='#' title='点击查看\"环比增长\"图表' onclick='{chartswf=\"2\";chartCurZbcode=\""+datas[9]+"\";valuetype=\"huanbi\";kpiviewProcess(\"chart\");}'>"+percentFormat(datas,options)+"</a>"+((datas[9] in hasFluctuating)?threshold.getHuanbiImg(datas[options.seq],datas[9],datas[0],"huanbi"):threshold.getTongbiImg(datas[options.seq],datas[9],datas[0],"huanbi"));};
	//cellfunc[5] =function(datas,options){return "<a href='#' title='点击查看\"同比增长\"图表' onclick='{chartswf=\"2\";chartCurZbcode=\""+datas[9]+"\";valuetype=\"tongbi\";kpiviewProcess(\"chart\");}'>"+percentFormat(datas,options)+"</a>"+threshold.getTongbiImg(datas[options.seq],datas[9],datas[0],"tongbi");};
	cellfunc[5] =function(datas,options){return "<a href='#' title='点击查看\"同比增长\"图表' onclick='{chartswf=\"2\";chartCurZbcode=\""+datas[9]+"\";valuetype=\"tongbi\";kpiviewProcess(\"chart\");}'>"+percentFormat(datas,options)+"</a>"+((datas[9] in hasFluctuating)?threshold.getHuanbiImg(datas[options.seq],datas[9],datas[0],"tongbi"):threshold.getTongbiImg(datas[options.seq],datas[9],datas[0],"tongbi"));};
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
		return "<img src='../../resources/image/default/detail.gif' onclick='redirect(\""+datas[10]+"\")' onmouseout=\"$('help_div').style.display='none';\" onmouseover='javascript:indicatorInstruction(\""+datas[10]+"\",event)' title='指标说明' border=0>"+"<a href='#' onclick='{chartswf=\"1\";chartCurZbcode=\""+datas[10]+"\";valuetype=\"\";kpiviewProcess(\"chart\");}'>"+datas[options.seq]+"</a>";
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
		var str=(datas[9]=="percent")?percentFormat(target):numberFormatDigit2(target);
		if(progressNum!="--")
			return "<span title='考核目标："+str+"'><a href='#' onclick='{chartswf=\"2\";chartCurZbcode=\""+datas[10]+"\";valuetype=\"progress\";kpiprogressProcess(\"chart\");}'>"+percentFormat(progressNum)+"</a></span>";
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
	
	var cur_custom="<%=KPICustomize.getUserCustomizeKpiToString(userid,appName)%>";
	//cur_custom = "C20001"
	chartCurZbcode = cur_custom.split(",")[0];
	
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
		
		if(id=="cust" || id=="appraisal"){
			chartCurZbcode=cur_custom.split(",")[0];
			document.getElementById("divmore").style.display="";
			if(document.getElementById("divmore").flag=="0"){
				gridCurZbcode="all";
				if($("kind").value!="") gridCurZbcode="ch";
			}			
			else gridCurZbcode=undefined;
		}else{
			gridCurZbcode=id;
			chartCurZbcode=id;
			document.getElementById("divmore").style.display="none";
		}
		kpiviewProcess();
	}
	
	window.onload=function(){
		
		var ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/bir?method=suggest"
			,parameters : "catacode="+encodeURIComponent("经分信息检索")
			,callback : function(xmlrequest){
				var _suggest = [];
				try{
					eval("_suggest="+xmlrequest.responseText)
				}catch(e){}
				var obj = actb($('kw'),_suggest);
			}
		});
		ajax.request();
		if($("kpicust"))
		$("kpicust").onclick=function(){
			tabAdd({title:"KPI预警平台",url:"${mvcPath}/hbapp/kpiportal/customize/main.jsp?"+_params._oriUri,order:"top"})
		}
		if($("kpirpt"))
		$("kpirpt").onclick=function(){
			tabAdd({id:"1125",title:"自定义报表",url:"${mvcPath}/hbapp/kpiportal/report/index.htm?"+_params._oriUri,order:"top"})
		}
		
		//setTimeout('initNotice(\"<%=userid%>\")',3000);
		
		<%if(appName!=null && (appName.startsWith("College") || appName.startsWith("Cs"))){%>
		swichContent($("chartrender"),$("img2"));
		swichContent($("mapdiv"),$("img1"));
		<%}%>
		
		kpiviewProcess('loadmask');
	}
	function _s(){
		if(document.forms[0].kw.value.length==0){
			tabAdd({url:'/hbapp/bir/main.htm',title:'经分信息检索'});
		}else{
			tabAdd({url:"${mvcPath}/hbapp/bir/search.htm?kw="+document.forms[0].kw.value ,title:"经分信息检索_"+document.forms[0].kw.value});
		}
	}

	function selectDate(){
		kpiviewProcess('loadmask');
	}
	//跳转到知识库
	function redirect(indicator_id){
		//debugger;
		//查映射表
		var _sql=encodeURIComponent("select knowitemid,auditstate from indicator_zb_map where indicator_id='"+indicator_id+"' and appName='"+appName+"'");
		var ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/jsondata?method=query"
			,parameters : "ds=web&isCached=false&sql="+_sql
			,callback : function(xmlrequest){
				var _suggest = [];
				try{
					eval("_suggest="+xmlrequest.responseText);
					
					if(_suggest.length==0){
						createFormPanel1(indicator_id);
					}else{
						if(_suggest[0].auditstate==0){
							alert("审核中");	
							return;
						}
						tabAdd({url:"${mvcPath}/hbapp/app/req_redirect.jsp?method=reply&ITEMID="+_suggest[0].knowitemid,title:'指标信息'});
					}
					
				}catch(e){}
			}
		});
		ajax.request();
		
	}
	var _cont = $C("div");
	var _mask = aihb.Util.windowMask({content:_cont});

	function createFormPanel(options) {
		_cont.innerHTML="";
		var count=0;
		for(var indx in options) {
			if(options.hasOwnProperty(indx)) {
				count++;
				var currentObj = options[indx];
				var formElement;
				if(currentObj.el) {
					formElement = currentObj.el;
				} else {
				
					if(!currentObj.eleType) {
						formElement = $C("input");
					} else {
						formElement = $C(currentObj.eleType); //textarea ,select , div等只有eleType
					}
					for(var prop in currentObj) {
						if(prop != "eleType" && prop != "label")
							formElement[prop] = currentObj[prop];
					}
				}
				_cont.appendChild($CT(currentObj.label));
				_cont.appendChild(formElement);
				if(count==1)
				_cont.appendChild($C("BR"));
			}
			
		}
		_mask.style.display="";
	}

	function createFormPanel1(indicator_id) {
		createFormPanel([
		{label : "提示：该指标信息还未创建,您可以:",eleType:"div"}
		,{label : "",eleType : "button",value:"去指标库",id:"zbk"
			,onclick : function(){
				_mask.style.display="none";
				tabAdd({url:"${mvcPath}/hbapp/app/req_redirect.jsp?method=meta&indicator_id="+indicator_id+"&appName="+appName,title:'指标库'});
			}
		}
		,{label : "",eleType : "button",id : "zsk",value:"去知识库"
			,onclick : function(){
				_mask.style.display="none";
				tabAdd({url:"${mvcPath}/hbapp/app/req_redirect.jsp?method=dqitemList&indicator_id="+indicator_id+"&appName="+appName,title:'知识库'});
			}
		}
	]);
	}
	</script>
	
  <body>
  <form action="">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td valign="top">
	    	 <div class="portlet">
		    	<div class="title" >
		    		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		    		<tr>
		    		<td>
		    		
		    		
		    		
		    		<table cellspacing="0" cellpadding="0" border="0">
						<tr class="dim_row">
							<td>统计周期 </td>
							<td>
							<%
							String dateFormat="yyyyMMdd";
							if(appName.endsWith("M")){
								//out.print(BassDimHelper.monthHtml("date","{kpiviewProcess('loadmask')}",KPIPortalService.getKPIAppData(appName).getCurrent(),-1));
								dateFormat="yyyyMM";
								
							}
							%>
							<input type="text" style="width:120px;" value="<%=KPIPortalService.getKPIAppData(appName).getCurrent() %>" class="Wdate" id="date" name="date" onchange="selectDate()" onfocus="WdatePicker({dateFmt:'<%=dateFormat %>'})"/>
							<td>地市</td>
							<td><%=BassDimHelper.areaCodeHtml("city","0","{areacombo(1,true);kpiviewProcess()}")%></td>
							
							<%if(appName!=null && appName.startsWith("College")) {%>
							<td>高校<font color="red" size="1">(请先选择地市)</font></td>
							<td><%=BassDimHelper.comboSeleclHtml("college","kpiviewProcess()")%></td>
							<td>品牌</td>
							<td><%=BassDimHelper.selectHtml("brands","","{kpiviewProcess('loadmask')}")%></td>
							<%}else if(appName!=null && appName.startsWith("Bureau")){%>
							<td>县域</td>
							<td><%=BassDimHelper.comboSeleclHtml("county_bureau","{if($('town')) $('town').value='';areacombo(2,true);kpiviewProcess()}")%></td>
							<td>营销中心</td>
							<td><%=BassDimHelper.comboSeleclHtml("marketing_center","{areacombo(3,true);kpiviewProcess()}")%></td>
							<td>乡镇(街道)</td>
							<td><%=BassDimHelper.comboSeleclHtml("town")%></td>
							<%}else if (appName!=null && appName.startsWith("Groupcust")){%>
							<td>县域</td>
							<td><%=BassDimHelper.comboSeleclHtml("entCounty","{areacombo(2,true);kpiviewProcess()}")%></td>
							<td>客户经理</td>
							<td><%=BassDimHelper.comboSeleclHtml("custmgr")%></td>
							<%}else if (appName!=null && appName.startsWith("Channel")){%>
							<td>县域</td>
							<td><%=BassDimHelper.comboSeleclHtml("county","{document.getElementsByName('county')[0].disabled=true;areacombo(2,true);kpiviewProcess()}")%></td>
							<td>营业网点</td>
							<td><%=BassDimHelper.comboSeleclHtml("office")%></td>
							<%}else if (appName!=null && appName.startsWith("Cs")){%>
							<td>县域</td>
							<td><%=BassDimHelper.comboSeleclHtml("county","{kpiviewProcess()}")%></td>
							<td>品牌</td>
							<td><%=BassDimHelper.selectHtml("brands","","{kpiviewProcess('loadmask')}")%></td>
							<%}%>
						</tr>
					</table>
		    		
		    		
		    		
		    		</td>
		    		
		    		<!--  <td><div id="kpititle"></div></td>   -->
		    		
		    		
		    			<td align="right">
							
							<TABLE width="100%" cellpadding="0" cellspacing="0" style="padding:0px;margin:0px;">
							<TR valign="bottom" style="padding:0px 5px 0px 8px;" align="right">
								<TD>
									<IMG src="${mvcPath}/hbapp/bir/bir_m.gif" border="0" width="43" height="20" style="padding:0px;margin:0px;cursor:hand;" alt="经分信息检索" onclick="tabAdd({url:'../../bir/main.htm',title:'经分信息检索'});">
									<INPUT name="kw" id="kw" size="46" maxlength="100" style="width:215px;line-height:16px;padding:3px;margin:0px;font:16px arial"> 
									<img src="../../resources/image/default/search_icon.gif" bordor=0 title="经分搜索" onclick="_s()" style="cursor:hand;"></img>
								</TD>
							</TR>
							</TABLE>
							
							
						</td>
						
		    		
		    		<td align="right">
		    		<!-- <img src="../../resources/image/default/feedback.gif" style="cursor: hand;" bordor=0 onclick='{/*parent.parent.topFrame.theCreateTab.add("意见反馈,mainFrame,feedback.jsp*/");}' title="意见反馈">意见反馈</img>
		    		 -->
		    		  <%if("meikefu".equalsIgnoreCase(userid)||"mengxiaoli".equalsIgnoreCase(userid)||"vyanhaitao".equalsIgnoreCase(userid)||"zhaozheng".equalsIgnoreCase(userid)){ %><span title="KPI预警平台" id='kpicust' style="cursor: hand;" ><img src="../../resources/image/default/icon_tab02_01.gif" bordor=0>预警平台</img></span>
		    		  <%} %>
		    		 <!--  <span title="基于KPI指标的自定义动态报表" id='kpirpt' style="cursor: hand;" ><img src="../../resources/image/default/custrpt.gif" bordor=0>自定义报表</img></span>  -->
		    		</td>
		    		<!--<td align="right" style="padding-right: 5px;"><img style="cursor: hand;" src="../../resources/image/default/icon_tab02_01.gif" title="定制短信"></img></td>-->
		    		</tr>
		    		</table>
		    	</div>
		    	<div id="grid" class="content" style="text-align: left;">
		    	
		    		<table style="border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:#ffffff;border-top:0px;border-bottom:0px;" border=1>
					<tr height="21px" valign="top" style="padding-bottom:0px;padding-top:3px;WIDTH: 100%; border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:81A3F5">
						<%if (appName.startsWith("Channel")){%>						  	
						<td  class="tab" background=../../resources/image/default/tab1.png onclick='changetab("appraisal");'><span id="dpLabel" label="考核类" >考核类</></TD>
						<%}else { %>
						<td  class="tab" background=../../resources/image/default/tab1.png onclick='changetab("cust");'><span id="dpLabel" label="我的定制" >我的定制</></TD>
						<%}
						if(kind.equals("")){
							if(appName.startsWith("Cs")){%>
						<td  class="tab" background=../../resources/image/default/tab2.png onclick='changetab("user");'>投诉类</TD>		
							<%}else{%>
						<td  class="tab" background=../../resources/image/default/tab2.png onclick='changetab("income");'>收入类</TD>
						<td  class="tab" background=../../resources/image/default/tab2.png onclick='changetab("user");'>用户类</TD>
						<td  class="tab" background=../../resources/image/default/tab2.png onclick='changetab("traffic");'>话务类</TD>
						<td  class="tab" background=../../resources/image/default/tab2.png onclick='changetab("vas");'>新业务</TD>
							<%}
						}else{%>
						<td  class="tab" background=../../resources/image/default/tab2.png onclick='changetab("chlrec");'>受理类</TD>	
						<td  class="tab" background=../../resources/image/default/tab2.png onclick='changetab("chluser");'>用户类</TD>
						<%}
						%>
						
						</tr>
					</table>
					
		    		<div id="showResult" style="margin-left: 0px; padding-left: 0px;float: left;width: auto;height: 195 px;overflow-y:scroll;word-break:break-all;"></div>
			    	<img id="divmore" flag='1' onclick="displaymore(this);" src="../../resources/image/default/ns-expand.gif" title="显示更多指标">
			   
			    	<div id="title_div" style="display:none;">
		            	<table id="resultTable" align="left" width="100%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
							<tr class="grid_title_blue" style="position:relative;top:expression(this.offsetParent.scrollTop);">
							   <span id =0><td class="grid_title_cell" width="23%">指标名称</td></span>
							   <span id =1><td class="grid_title_cell">#{1}</td></span>
							   
							   <%if(appName.endsWith("M")){%>
							   <span id =2><td class="grid_title_cell">上月数值</td></span>
							   <span id =3><td class="grid_title_cell"><img id='iclose' src='../../resources/image/default/left_2.gif' onmouseover="{this.src='../../resources/image/default/left_1.gif'}" onmouseout="{this.src='../../resources/image/default/left_2.gif'}" style='cursor: hand;' title='点击隐藏' onclick="hiddenColumns(false);"/>去年同期</td></span>
							   <td class="grid_title_cell">环比增长</td>
							   <td class="grid_title_cell">同比增长</td>
							   <td class="grid_title_cell">考核目标</td>
							   <%}else{ %>
							   <span id =2><td class="grid_title_cell">前日数值</td></span>
							   <span id =3><td class="grid_title_cell">上月同期</td></span>
							   <span id =4><td class="grid_title_cell"><img id='iclose' src='../../resources/image/default/left_2.gif' onmouseover="{this.src='../../resources/image/default/left_1.gif'}" onmouseout="{this.src='../../resources/image/default/left_2.gif'}" style='cursor: hand;' title='点击隐藏' onclick="hiddenColumns(false);"/>去年同期</td></span>
							   <td class="grid_title_cell">环比增长</td>
							   <td class="grid_title_cell">月同比</td>
							   <td class="grid_title_cell">年同比</td>
							   <%} %>
							   <td class="grid_title_cell">完成情况</td>
							   <td class="grid_title_cell">深度分析</td>
							   <td class="grid_title_cell">定制</td>
							</tr>
						</table>
					</div>
	        	</div>
        	</div> 
	    </td>
	  </tr>
	</table>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="35%" valign="top">
	    	<div class="portlet">
		    	<div class="title">
		    		<table width="99%" height="16"><tr><td>地图</td><td align="right" width="20 px" title="隐藏/显示" style="cursor: hand" ><img id="img1" src="../../resources/image/default/expand.gif" onclick='swichContent($("chartrender"),$("img2"));swichContent($("mapdiv"),$("img1"));'/></td></tr></table>
		    	</div>
		    	<div class="content">
		    	<div id="mapdiv">
		    		<object id="map1" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="swflash.cab#version=6,0,0,0" width="350" height="180">
		    		<param name="movie" value="../localres/swf/0.swf"/>
		    		<param name="wmode" value="transparent"/>
		    		</object>
		    	</div>
		    	</div>
        	</div>
		</td>
	    <td valign="top">
	        <div class="portlet">
		    	<div class="title" >
		    		<table width="99%"  height="16"><tr><td>图表</td><td align="right" width="20 px" title="隐藏/显示" style="cursor: hand" ><img id="img2" src="../../resources/image/default/expand.gif" onclick='swichContent($("chartrender"),$("img2"));swichContent($("mapdiv"),$("img1"));'/></td></tr></table>
		    	</div>
		    	<div class="content">
	            	<div id="chartrender" style="text-align: center;"></div>
	        	</div>
        	</div>
		</td>
	  </tr>
	</table>
	<input id=kind type="hidden" value="<%=kind%>">
	</form>
	<div id="help_div" class="selectarea" style="display: none;">
	<div class="close"><img src='../../resources/image/default/tab-close.gif' onclick="{this.parentNode.parentNode.style.display='none';}"></img></div>
	<div id="instructionText">帮助口径</div>
	</div>
</body>
</html>
<script>
aihb.Util.loadmask();
aihb.Util.watermark();
</script>
