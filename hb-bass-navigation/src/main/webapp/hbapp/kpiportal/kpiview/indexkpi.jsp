<%@ page contentType="text/html; charset=utf-8"%>
<%
String appName=request.getParameter("appName");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>湖北经分</title>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="../../resources/js/ext/resources/css/ext-all.css"/>
	<script type="text/javascript" src="../../resources/js/default/default.js"></script>
 	<script type="text/javascript" src="../../resources/js/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../../resources/js/ext/ext-all.js"></script>
	<script type="text/javascript">	
	var _params = aihb.Util.paramsObj();
	Ext.BLANK_IMAGE_URL = '../../resources/js/ext/resources/images/default/s.gif';
    Ext.onReady(function(){
    	Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
		var viewport = new Ext.Viewport({
		     layout:'border'
		     ,items:[_tabPanel]
		 });
    });
	
	var _tabPanel =new Ext.TabPanel({
	   region:'center',
	   deferredRender:false,
	   enableTabScroll:true,
	   activeTab:0,
	   items:[
<%
String title="";
if("CollegeD".equalsIgnoreCase(appName)){
	title="高校日KPI统一视图";
}else if ("CollegeM".equalsIgnoreCase(appName)){
	title="高校月KPI统一视图";
}else if ("GroupcustD".equalsIgnoreCase(appName)){
	title="集团日KPI统一视图";
}else if ("GroupcustM".equalsIgnoreCase(appName)){
	title="集团月KPI统一视图";
}else if ("ChannelM".equalsIgnoreCase(appName)){
	title="月KPI统一视图";
}else if ("ChannelD".equalsIgnoreCase(appName)){
	title="日KPI统一视图";
}else if ("CsM".equalsIgnoreCase(appName)){
	title="客服月KPI统一视图";
}else if ("CsD".equalsIgnoreCase(appName)){
	title="客服日KPI统一视图";
}
%>
		{
		   	id:'index0',
			title: "<%=title%>",
			closable:false,
			autoScroll:true,
			html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="kpiview.jsp?appName=<%=appName%>&'+_params._oriUri+'"></iframe>',       
			border:true
		   }
		 <%if ("ChannelD".equalsIgnoreCase(appName)){%>
		,{
		   	id:'index1',
			title: "区域化KPI统一视图",
			closable:false,
			autoScroll:true,
			html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="kpiview.jsp?appName=BureauD&'+_params._oriUri+'"></iframe>',       
			border:true
		   }
		,{
		   	id:'index2',
			title: "KPI层级展现",
			closable:false,
			autoScroll:true,
			html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="../kpitree/ntree.jsp?'+_params._oriUri+'"></iframe>',       
			border:true
		   }
		<%}else if ("ChannelM".equalsIgnoreCase(appName)){ %>
		,{
		   	id:'index1',
			title: "月区域化KPI统一视图",
			closable:false,
			autoScroll:true,
			html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="kpiview.jsp?appName=BureauM&'+_params._oriUri+'"></iframe>',       
			border:true
		   }
		 <%}%>
	   ]
	});
</script>
</head>
<body>
</body>
</html>
