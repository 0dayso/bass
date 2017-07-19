<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.kpiportal.service.KPIPortalService"%>
<%@ include file="../../resources/old/loadmask.htm"%>
<%@page deferredSyntaxAllowedAsLiteral="true" %>
<%
String appName = request.getParameter("appName");
String zbCode = request.getParameter("zbcode");
String zbName = request.getParameter("zbname");
String area = request.getParameter("area");
if(area==null||area.length()==0){
	area = "0";
}
String date = request.getParameter("date");
if(date==null||date.length()==0){
	date = KPIPortalService.getKPIAppData(appName).getCurrent();
}
String brand = request.getParameter("brand");
String percentType = request.getParameter("percentType");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>KPI统一视图</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/js/default/tabext.js" charset=utf-8></script>
	<script type="text/javascript" src="../../resources/js/default/calendar.js"></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/fluctuating_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
  </head>
  <script type="text/javascript">
  	appName ="<%=appName%>";
  	hbbasscommonpath="../../resources/old/"
  	function footbar(){return "";}
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
	
	<%if(appName.endsWith("M")){%>
	cellfunc[1]=_value;
	cellfunc[2]=_value;
	cellfunc[3]=_value;
	cellfunc[4] =function(datas,options){return percentFormat(datas,options)+threshold.getTongbiImg(datas[options.seq]);};
	cellfunc[5] =function(datas,options){return percentFormat(datas,options)+threshold.getTongbiImg(datas[options.seq]);};
	cellfunc[6] =targetValue;
	cellfunc[7] =jindu;
	seqformat[1]="当月数值";
	<%}else{%>
	//debugger;
	seqformat[1]="当日数值";
	cellfunc[1]=_value;
	cellfunc[2]=_value;
	cellfunc[3]=_value;
	cellfunc[4]=_value;
	cellfunc[5] =function(datas,options){return percentFormat(datas,options)+threshold.getTongbiImg(datas[options.seq]);};
	cellfunc[6] =function(datas,options){return percentFormat(datas,options)+threshold.getTongbiImg(datas[options.seq]);};
	cellfunc[7] =function(datas,options){return percentFormat(datas,options)+threshold.getTongbiImg(datas[options.seq]);};
	cellfunc[8] =targetValue;
	cellfunc[9] =jindu;
	<%}%>
	
	function _value(datas,options){
		if("<%=percentType%>"=="percent"){
			return percentFormat(datas,options);
		}else {
			return numberFormatDigit2(datas,options);
		}
	}
	
	var arrSrc = [];
	arrSrc["f2"]="../kpicompare/kpitrend.jsp?appName=<%=appName%>&zbcode=<%=zbCode%>&date=<%=date%>&zbname=<%=zbName%>&area=<%=area%>&percentType=<%=percentType%>&brand=<%=brand%>";
	arrSrc["f3"]="../kpicompare/kpicompareMain.jsp?appName=<%=appName%>&zbcode=<%=zbCode%>&date=<%=date%>&zbname=<%=zbName%>&area=<%=area%>&percentType=<%=percentType%>&brand=<%=brand%>";
	arrSrc["f4"]="../kpiwave/kpiwave.jsp?appName=<%=appName%>&zbcode=<%=zbCode%>&date=<%=date%>&zbname=<%=zbName%>&area=<%=area%>&percentType=<%=percentType%>&valuetype=huanbi";
	arrSrc["f5"]="../kpiwave/kpiwave.jsp?appName=<%=appName%>&zbcode=<%=zbCode%>&date=<%=date%>&zbname=<%=zbName%>&area=<%=area%>&percentType=<%=percentType%>&valuetype=tongbi";
	
	
	var operArr=[];
	operArr["f2"]="trend";
	operArr["f3"]="compare";
	operArr["f4"]="fluctuating";
	operArr["f5"]="fluctuating";
	
	
	function initializeTab(){
		document.all.f1.src="../kpiprogress/kpiprogress.jsp?appName=<%=appName%>&zbcode=<%=zbCode%>&date=<%=date%>&zbname=<%=zbName%>&area=<%=area%>&percentType=<%=percentType%>&brand=<%=brand%>";
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
		
		var ifrs = document.getElementsByTagName("iframe");
		for(var j=0;j<ifrs.length;j++)
		{
			var curIfr = ifrs[j];
			if(curIfr.name==id){
				curIfr.style.display="";
				if(curIfr.isload=="0"){
					curIfr.src=arrSrc[id];
					curIfr.isload="1";
					logger("<%=zbCode%>",operArr[id]);
				}
			}
			else curIfr.style.display="none";
		}
	}
	
	function kpiviewDetail()
	{
		ajaxSubmit({
			url: "../action.jsp?appName=<%=appName%>&method=kpiviewDetail",
			loadmask : false,
			param: "brand=<%=brand%>&area=<%=(area!=null&&"0".equalsIgnoreCase(area))?area="HB":area%>&date=<%=date%>&zbcode=<%=zbCode%>"
		});
		
	}
	
  </script>
  <body onload="kpiviewDetail();initializeTab();">
    <div id="showResult" style="padding: 3 px;margin: 3 px"></div>
   	<div id="title_div" style="display:none;">
          	<table id="resultTable" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
			<tr class="grid_title_blue">
			   <span id =0><td class="grid_title_cell" width="30%">指标说明</td></span>
			   <span id =1><td class="grid_title_cell">#{1}</td></span>
			   
			   <%if(appName.endsWith("M")){%>
			   <span id =2><td class="grid_title_cell">上月数值</td></span>
			   <span id =3><td class="grid_title_cell">去年同期</td></span>
			   <td class="grid_title_cell">环比增长</td>
			   <td class="grid_title_cell">同比增长</td>
			   <td class="grid_title_cell">考核目标</td>
			   <%}else{ %>
			   <span id =2><td class="grid_title_cell">前日数值</td></span>
			   <span id =3><td class="grid_title_cell">上月同期</td></span>
			   <span id =4><td class="grid_title_cell">去年同期</td></span>
			   <td class="grid_title_cell">环比增长</td>
			   <td class="grid_title_cell">月同比</td>
			   <td class="grid_title_cell">年同比</td>
			   <td class="grid_title_cell">考核目标</td>
			   <%} %>
			   <td class="grid_title_cell">完成情况</td>
			</tr>
		</table>
	</div>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	   <tr>
	    <td colspan="1" valign="top">
	    	 <div>
		    	<div style="padding: 3px 5px 1px 8px;font-size: 13px;height: 20px;" >
		    		<table style="border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:#ffffff;border-top:0px;border-bottom:0px;" border=1>
					<tr height="21px" valign="top" style="padding-bottom:0px;padding-top:3px;WIDTH: 100%; border-collapse:collapse;border-color:#9AADBE;BACKGROUND-COLOR:81A3F5">
						<td class="tab" background=../../resources/image/default/tab1.png onclick='changetab("f1");'>进度监控</TD>
						<td class="tab" background=../../resources/image/default/tab2.png onclick='changetab("f2");'>趋势分析</TD>
						<%if(!appName.startsWith("EntGrid")){%>
						<td class="tab" background=../../resources/image/default/tab2.png onclick='changetab("f3");'>比较分析</TD>
						<%} %>
						<script>if("<%=zbCode%>" in hasFluctuating)document.write('<td  class="tab" background=../../resources/image/default/tab2.png onclick=\'changetab("f4");\' >环比波动分析</td><td  class="tab" background=../../resources/image/default/tab2.png onclick=\'changetab("f5");\' >同比波动分析</td>');</script>
					</tr>
					</table>
		    	</div>
		    	<div id="grid" style="margin: 0px 0 px 3 px 3 px;border: 1px solid #c3daf9;filter:alpha(opacity=90)" >
		    		<table height=470 width=99% border=0 cellspacing=0 cellpadding=0>
					<tr>
						<td>
							<iframe frameborder=0 scrolling="auto" width=100% height=100% id=f1 name=f1 isload="1"></iframe>
							<iframe frameborder=0 scrolling="auto" width=100% height=100% id=f2 name=f2 isload="0" style="display:none"></iframe>
							<iframe frameborder=0 scrolling="auto" width=100% height=100% id=f3 name=f3 isload="0" style="display:none"></iframe>
							<iframe frameborder=0 scrolling="auto" width=100% height=100% id=f4 name=f4 isload="0" style="display:none"></iframe>
							<iframe frameborder=0 scrolling="auto" width=100% height=100% id=f5 name=f5 isload="0" style="display:none"></iframe>
						</td>
					</tr>
					</table>
	        	</div>
        	</div>
	    </td>
	  </tr>
	</table>
	<style>
	.selectarea1 {
		position:absolute;
		padding: 5 0 0 5 px;
		width: 190px;
		right: 5px;
		top: 55 px;
		z-index:30;background-color: #FFFFB5;
		border:1px solid #B3A894;
		filter:alpha(opacity=80);
	}
	</style>
	<div id="tip" class="selectarea1"><b>你可能还关注以下指标：</b><span style="cursor:hand;" title="关闭" onclick="$('tip').style.display='none'">×</span><div id="indi"></div></div>
	<script>
	function tip(){
		var ajax = new aihb.Ajax({
			url : "${mvcPath}/hbirs/action/jsondata"
			,parameters : "sql="+encodeURIComponent("select target,id,appName,name||unit name,formattype,instruction from bir_indicator_correlation,FPF_IRS_INDICATOR where source=(select replace(fullname,',','') from FPF_IRS_INDICATOR where id='<%=zbCode%>' and appName='<%=appName%>') and target=replace(fullname,',','') order by value desc fetch first 30 rows only with ur")+"&ds=web"
			,callback : function(xmlrequest){
				var datas = eval(xmlrequest.responseText);
				for(var i=0;i<datas.length;i++){
					var obj=$C("div");
					obj.innerText=datas[i].target;
					obj.url="&appName="+datas[i].appname+"&zbcode="+datas[i].id+"&zbname="+datas[i].name+"&percentType="+datas[i].formattype;
					obj.title=datas[i].instruction;
					obj.text=datas[i].target;
					obj.style.cursor="hand";
					obj.onclick=function(){
						tabAdd({url:"${mvcPath}/hbapp/kpiportal/kpiview/kpiviewDetail.jsp?area=<%=request.getParameter("area")%>&promo=true&brand="+this.url ,title:this.text});
					}
					if(i>5){
						obj.style.display="none";
					}
					$("indi").appendChild(obj);
				}
				var sep = $C("div");
				sep.innerText="更多>>";
				sep.style.cursor="hand";
				sep.align="right";
				sep.onclick=function(){
					var objs = $("indi").getElementsByTagName("div");
					for(var j=0;j<objs.length;j++){
						objs[j].style.display="";
					}
				}
				$("indi").appendChild(sep);
			}
		});
		
		ajax.request();
	}
	tip();
	</script>
</body>
</html>
