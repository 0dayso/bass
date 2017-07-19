<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<html>
<head>
  <title>四网协同</title>
  	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css"/>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
 	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
  	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
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
	   deferredRender:true,
	   enableTabScroll:true,
	   activeTab:0,
	   items:[{
	   	id:'index0',
		title: "GTW网络流量分布",
		closable:false,
		autoScroll:true,
		html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="${mvcPath}/hbapp/app/flowOperation/gtwNetFlow/gtwNetFlow.jsp"></iframe>',       
		border:true
	   },
	   {
	   	id:'index1',
		title: "宽带发展",
		closable:false,
		autoScroll:true,
		html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="${mvcPath}/hbapp/app/flow/add_kuandai_report.jsp"></iframe>',       
		border:true
	   },
	   {
	   	id:'index2',
		title: "GIS展现",
		closable:false,
		autoScroll:true,
		html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="${mvcPath}/hbapp/app/flow/grid_view.jsp"></iframe>',       
		border:true
	   },
	   {
	   	id:'index3',
		title: "流量分流模型",
		closable:false,
		autoScroll:true,
		html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="${mvcPath}/hbapp/app/flow/add_six_report.jsp"></iframe>',       
		border:true
	   }
	   ]
	});
</script>
</head>
<body>
</body>
</html>