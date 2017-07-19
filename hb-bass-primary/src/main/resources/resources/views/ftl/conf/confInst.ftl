<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
	<title>湖北经分</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-base.js"></script>
  	<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-all.js"></script>
	<script type="text/javascript">
	Ext.BLANK_IMAGE_URL = "${mvcPath}/resources/js/ext/resources/images/default/s.gif";
Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	var contentPanel =new Ext.TabPanel({
		region:'center',
		deferredRender:false,
		enableTabScroll:true,
		activeTab:0,
		id:"tab",
		items:[{
		  	id:'index0',
			title: '查询条件配置',
			closable:false,
			autoScroll:true,
			'html':'<iframe id="indexFrame0" scrolling="auto" frameborder="0" width="100%" height="98%" src="${mvcPath}/report/${sid}/dim"></iframe>',
			border:true
		}
		,{
		  	id:'index1',
			title: '表头设计',
			closable:false,
			autoScroll:true,
			'html':'<iframe id="indexFrame1" scrolling="auto" frameborder="0" width="100%" height="98%" src="${mvcPath}/report/${sid}/header"></iframe>',
			border:true
		}
		,{
		  	id:'index2',
			title: 'SQL配置',
			closable:false,
			autoScroll:true,
			'html':'<iframe id="indexFrame2" scrolling="auto" frameborder="0" width="100%" height="98%" src="${mvcPath}/report/${sid}/sql"></iframe>',
			border:true
		}
		,{
		  	id:'index4',
			title: '编程(可选)',
			closable:false,
			autoScroll:true,
			'html':'<iframe id="indexFrame4" scrolling="auto" frameborder="0" width="100%" height="98%" src="${mvcPath}/report/${sid}/code"></iframe>',
			border:true
		}
		,{
		  	id:'index3',
			title: '测试预览',
			closable:false,
			autoScroll:true,
			src: "${mvcPath}/report/${sid}",
			html:'<iframe id="indexFrame3" scrolling="auto" frameborder="0" width="100%" height="98%" src="${mvcPath}/report/${sid}"></iframe>',
			border:true
		}
		
		]
	});
	
	var viewport = new Ext.Viewport({
        layout:'border',
        items:[contentPanel]
    });
    
    Ext.getCmp("tab").on('tabchange',function(a,b){
		if(b.id=="index3"){
			Ext.get("indexFrame3").dom.src=b.src;
		}
	});
    
});	
</script>
	</head>
	<body>
	</body>
</html>