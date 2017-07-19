<%@page import="com.asiainfo.hb.web.models.User"%>
<%@ page contentType="text/html; charset=utf-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>湖北移动经营分析系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css"/>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/xtheme-slate.css" />
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
    <script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css"/>
	
  </head>
  <body>
		<table
			style="border-collapse: collapse; border-color: #9AADBE; BACKGROUND-COLOR: #ffffff; border-top: 0px; border-bottom: 0px; margin-left: 6px"
			border=1>
			<tr height="21px" valign="top"
				style="padding-bottom: 0px; padding-top: 3px; WIDTH: 10%; border-collapse: collapse; border-color: #9AADBE; BACKGROUND-COLOR: 81A3F5">
				<td class="tab" background=${mvcPath}/hbapp/resources/image/default/tab1.png
					onclick='changetab("f1");'>
					&nbsp;客户发展质量预警阈值和权重配置
				</TD>
				<td class="tab" background=${mvcPath}/hbapp/resources/image/default/tab2.png
					onclick='changetab("f2");'>
					疑似养卡预警阈值和权重配置
				</TD>
				<input type="hidden" id="selType" value="toDo">
			</tr>
		</table>
<table height=100% width=100% border=1 bordercolor=91aed0 style="border-collapse:collapse;color:000206;font-size:12px" cellspacing=0 cellpadding=4>
<tr>
	<td>
		<iframe frameborder=0 scrolling="auto" width=100% height=100% id=f1 name=f1 isload="1" ></iframe>
		<iframe frameborder=0 scrolling="auto" width=100% height=100% id=f2 name=f2 isload="0" style="display:none"></iframe>
	</td>
</tr>
</table>
  </body>
<script type="text/javascript">
	document.all.f1.src="chl_alert_cfg_detail1.jsp";	
var arrSrc = [];
arrSrc["f1"]="chl_alert_cfg_detail1.jsp";
arrSrc["f2"]="chl_alert_cfg_detail2.jsp";
function changetab(id){
	var obj=event.srcElement;
	while(obj.tagName!="TD") obj=obj.parentElement;
	var cellindex=obj.cellIndex;
	while(obj.tagName!="TABLE") obj=obj.parentElement;
	if(obj.lastcell) {obj.rows[0].cells[obj.lastcell].style.backgroundImage="url(${mvcPath}/hbapp/resources/image/default/tab2.png)";}
	else{obj.rows[0].cells[0].style.backgroundImage="url(${mvcPath}/hbapp/resources/image/default/tab2.png)";}
	obj.lastcell=cellindex;
	obj.rows[0].cells[cellindex].style.backgroundImage="url(${mvcPath}/hbapp/resources/image/default/tab1.png)";
	
	$('selType').value = id;
	
	var ifrs = document.getElementsByTagName("iframe");
	for(var j=0;j<ifrs.length;j++)
	{
		var curIfr = ifrs[j];
		if(curIfr.name==id)
		{
			curIfr.style.display="";
			if(curIfr.isload=="0"){curIfr.src=arrSrc[id];curIfr.isload="1";}
		}
		else curIfr.style.display="none";
	}
	
}

	</script>  
</html>
