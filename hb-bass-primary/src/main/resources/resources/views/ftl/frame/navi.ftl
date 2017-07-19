<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>湖北移动经营分析系统</title>
<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-base.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext/ext-all.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext/resources/css/ext-all.css" />
<script type="text/javascript">
Ext.BLANK_IMAGE_URL = '${mvcPath}/resources/js/ext/resources/images/default/s.gif';
Ext.onReady(function(){
	Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
	var treeLoader = new Ext.tree.TreeLoader({dataUrl:"${mvcPath}/menu/${id}/children"});
	treeLoader.on("beforeload",function(treeLoader, node){
		treeLoader.dataUrl="${mvcPath}/menu/"+node.id+"/children"
	},this);
	
    var tree = new Ext.tree.TreePanel({
        el:'west',
        useArrows:true,
        autoScroll:true,
        animate:true,
        //enableDD:true,
        border:false,
        containerScroll: true, 
        loader: treeLoader
        ,root : new Ext.tree.AsyncTreeNode({
	        text: "${title}",
	        expanded:true,
	        id: ${id}
	    })
	    ,listeners: { 
			click: function(node,event){
	           if(node.leaf){
	           	if(node.attributes.kind=="菜单_内容"){
	           		Ext.get("container_content").dom.src = node.attributes.url;
	           	}else{
	           		parent.addTab(node.text,node.attributes.url);
	           	}
	           }
			}
       	}
    });
    //默认打开第一个菜单
    tree.on("expandnode"
    	,function(root){
    		var node = root.childNodes[0];
    		if(node.leaf){
	           	if(node.attributes.kind=="菜单_内容"){
	           		Ext.get("container_content").dom.src = node.attributes.url;
	           	}
	        }
	    },this);
    
    tree.render();
    
    var pn_content = new Ext.Panel({
      region:'center',border:false,
      html:'<iframe src="" id="container_content"  width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>'
	});
    
    var viewport = new Ext.Viewport({
	    layout:'border',
	    items:[{
			region:'west',
			//el:'west',
			title:'菜单',
			split:true,
			width: 200,
			minSize: 175,
			maxSize: 400,
			collapsible: true,
			autoScroll : true,
			margins:'1 0 0 3',
			layoutConfig:{
			    animate:true
			},
			items: [tree]
        },
        pn_content]
	});
	
});
</script>
</head>
<body>
	<div id="west"></div>
	<div id="center"></div>
</body>
</html>
