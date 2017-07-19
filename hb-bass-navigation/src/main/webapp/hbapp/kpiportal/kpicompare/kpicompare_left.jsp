<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.List"%>
<%@page import="com.asiainfo.hbbass.component.tree.TreeEntity"%>
<%@page import="com.asiainfo.hbbass.kpiportal.service.KPIPortalViewService"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>KPI比较分析</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../../resources/old/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="../localres/kpi.js" charset=utf-8></script>
	<script language="javascript" src="../../resources/js/extree/xtree.js"></script>
	<script language="javascript" src="../localres/js/checkboxTreeItem.js"></script>
	<link type="text/css" rel="stylesheet" href="../../resources/js/extree/xtree.css" />
	<link rel="stylesheet" type="text/css" href="../../resources/css/default/default.css" />
  </head>
  <script language="javascript">
	webFXTreeConfig.setImagePath("../../resources/js/extree/images/");
	var tree = new WebFXTree("地域", "");
	<%
		String appName = request.getParameter("appName");
		List list = KPIPortalViewService.getAreaList(appName,"0");
		TreeEntity tree = new TreeEntity();
		tree.init(list);
		tree.useExtreeCheckboxProcess();
		//tree.getProcess().setObject(new java.util.HashSet());
		tree.iterator();
		StringBuffer sb = (StringBuffer)tree.getProcess().getObject();
		out.print(sb);
	%>
  </script>
  <body onload="initialTrendDate(parent.compareDate)">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td valign="top">
        <div class="portlet">
	    	<div class="title">
	    		时间段
	    	</div>
	    	<div class="content" style="text-align: left;">
	    		<input type="text" id="dura_from" name="dura_from" class="form_input_between" value="20080924"> - <input type="text" id ="dura_to" name="dura_to" class="form_input_between" value="20081004">
		   		</div>
        	</div>
	</td>
  </tr>
  <tr>
    <td valign="top">
        <div class="portlet">
	    	<div class="title">
	    		<table width="100%">
	    		<tr>
	    		<td width="80">地域</td>
	    		<td align="left">
	    		<input type="button" style="padding: 0 px;" class="form_button_short" value="比较" 
		   		onclick="{parent.exMainFrame.kpiCompare({
		   		areas:getCheckValues(),
		   		durafrom:document.getElementById('dura_from').value,
		   		durato:document.getElementById('dura_to').value});}">
	    		</td>
	    		</tr>
	    		</table>
	    	</div>
	    	<div class="content">
	    		<script language="javascript">document.write(tree);tree.expand();</script>
        	</div>
       	</div>
	</td>
  </tr>
  </table>
  </body>
</html>

