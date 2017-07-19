<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>湖北经分</title>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="${mvcPath}/resources/js/default/default.js"></script>
 	<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-base.js"></script>
  	<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-all.js"></script>
	<script type="text/javascript">
	Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
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
	   items:[{
	   	id:'index0',
		title: "首页",
		closable:false,
		autoScroll:true,
		html:'<iframe id="indexFrame" scrolling="auto" frameborder="0" width="100%" height="100%" src="${mvcPath}/rptNavi/'+${id}+'/main"></iframe>',       
		border:true
	   }]
	});
</script>
</head>
<body>
</body>
</html>