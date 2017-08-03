<html style="margin: 0;padding: 0; border: 0 none; overflow: hidden; height: 100%;">
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8">

	<link rel="stylesheet" href="${mvcPath}/resources/js/ztree/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="${mvcPath}/resources/js/ztree/js/jquery-1.8.3.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/ztree/js/jquery.ztree.core.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/lib/layer2.1/layer.min.js"></script>
	<style>
	.x-viewport, .x-viewport body {
    margin: 0;
    padding: 0;
    border: 0 none;
    overflow: hidden;
    height: 100%;
}
.x-border-layout-ct {
    background: #dfe8f6;
}
		.x-border-panel {
    position: absolute;
    left: 0;
    top: 0;
}

.x-panel {
    border-style: solid;
    border-color: #99bbe8;
    border-width: 0;
}

.x-panel-header {
    overflow: hidden;
    zoom: 1;
}

.x-panel-header {
    overflow: hidden;
    zoom: 1;
    color: #15428b;
    font: bold 11px tahoma,arial,verdana,sans-serif;
    padding: 5px 3px 4px 5px;
    border: 1px solid #99bbe8;
    line-height: 15px;
    background: transparent url(${mvcPath}/hbapp/resources/js/ext/resources/images/default/panel/white-top-bottom.gif) repeat-x 0 -1px;
}
.x-tool-collapse-west {
    background-position: 0 -180px;
}
.x-tool-toggle {
    background-position: 0 -60px;
}
.x-tool {
    overflow: hidden;
    width: 15px;
    height: 15px;
    float: right;
    cursor: pointer;
    background: transparent url(${mvcPath}/hbapp/resources/js/ext/resources/images/default/panel/tool-sprites.gif) no-repeat;
    margin-left: 2px;
}
.x-unselectable, .x-unselectable * {
    -moz-user-select: none;
    -khtml-user-select: none;
}
.x-panel-body {
    overflow: hidden;
    zoom: 1;
}
.x-panel-body {
    border: 1px solid #99bbe8;
    border-top: 0 none;
    overflow: hidden;
    background: white;
    position: relative;
}
.x-border-panel {
    position: absolute;
    left: 0;
    top: 0;
}
.x-panel {
    border-style: solid;
    border-color: #99bbe8;
    border-width: 0;
}
.x-panel-bwrap {
    overflow: hidden;
    zoom: 1;
}
x-panel-noborder .x-panel-body-noborder {
    border-width: 0;
}
.x-panel-body {
    overflow: hidden;
    zoom: 1;
}
.x-panel-body-noheader, .x-panel-mc .x-panel-body {
    border-top: 1px solid #99bbe8;
}
.x-panel-body {
    border: 1px solid #99bbe8;
    border-top: 0 none;
    overflow: hidden;
    background: white;
    position: relative;
}
.x-layout-collapsed{
	background-color: #d2e0f2;
    overflow: hidden;
    border: 1px solid #98c0f4;
}
	</style>
	<SCRIPT type="text/javascript">
		<!--
		var setting = {
			view: {
			selectedMulti: false, //设置设置不允许同时选中多个节点
			showLine: false
		},
		data: {
		 	key: {
		 		title:"t"
		    },
			simpleData: {
				enable: true
			}
		},
		callback: {
			beforeClick: function(treeId, treeNode) {
				console.log(treeNode.isParent);
				console.log(treeNode.children);
				var zTree = $.fn.zTree.getZTreeObj("treeDemo");
				if(treeNode.isParent&&treeNode.children==undefined){
					addChildrens(zTree,treeNode);
				}
				if (treeNode.isParent) {
					zTree.expandNode(treeNode);
					return false;
				}
			},
			beforeExpand:function(treeId,treeNode){
				var zTree = $.fn.zTree.getZTreeObj("treeDemo");
				if(treeNode.isParent&&treeNode.children==undefined){
					addChildrens(zTree,treeNode);
				}
			},
			
			onClick:function(event,treeId,node){
				window.parent.addTab(node.id,node.name,node.file);
			}
		}
		};
		
		
	function createMenuNodes(data,zNodes)
	{
		var zNodes = [];
	var json = eval(data);
     for (var i = 0; i < json.length; i++) {
        var MENUITEMID;
        var MENUITEMTITLE;
        var PARENTID;
        var URL;
        var FLAG=false;
        for (var key in json[i]) {
           if(key=="menuitemid")
           {
                MENUITEMID=json[i][key];
           }else if(key=="menuitemtitle")
           {
               MENUITEMTITLE=json[i][key];
           }else if(key=="parentid")
           {
               PARENTID=json[i][key];
           }else if(key=="url")
           {
               URL=json[i][key];
               if(URL==null||URL.length==0){
               		FLAG = true;
               }else{
               		if(URL.indexOf('?')<0){
						URL = URL+'?menuid='+MENUITEMID;
					}else{
						URL = URL+'&menuid='+MENUITEMID;
					}
               }
           }
         }
         zNodes.push({id:MENUITEMID, pId:PARENTID, name:MENUITEMTITLE,t:MENUITEMTITLE,file:URL,isParent:FLAG});
      }
      return zNodes;
}
		function addChildrens(treeObj,node){
			$.ajax({
				type: "POST"
				,url: "${mvcPath}/menu/"+node.id+"/children"
				,data: {}
				,dataType : "json"
				,success: function(data){
					var cNodes=	createMenuNodes(data);
					treeObj.addNodes(node,cNodes,true);
					}
				,error: function(XMLHttpRequest, textStatus, errorThrown) {
					if(XMLHttpRequest.status==200){
						$.msg("登录超时,请重新登录",{icon: 0 ,time : 5000});
					}else{
						$.msg("加载菜单失败(errorCode:"+XMLHttpRequest.status+")"+"<br>请联系系统管理员!",{icon: 0 ,time : 5000});
						}
				}
			});
		}

		var zNodes =[
		{id:"${id}",pId:'pid',name:"${title}", t:"${title}",file:'',isParent:true,open:true}
		];
		$(document).ready(function(){
			var treeObj = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
			var node = treeObj.getNodes()[0];
			 addChildrens(treeObj,node);
			
			$("#ext-gen20").click(function(){
				$("#left-order").hide();
				$("#ext-gen16-1").show();
				$("#ext-comp-1002").css("left","38px");
			});
			
			$("#ext-gen20-1").click(function(){
				$("#ext-gen16-1").hide();
				$("#left-order").show();
				$("#ext-comp-1002").css("left","208px");
			});
		});
		
		//-->
	</SCRIPT>
</HEAD>

<BODY class=" ext-safari x-border-layout-ct">

	<div class="x-panel x-border-panel " id="left-order" style="width: 200px; position: absolute; visibility: visible; left: 3px; top: 1px; z-index: 1;">
		<div class="x-panel-header x-unselectable" id="ext-gen16">
		<div class="x-tool" id="ext-gen20" style="background-position: 0 -180px;">&nbsp;</div>
		<span class="x-panel-header-text" id="ext-gen24">菜单</span></div>
		
		<div class="x-panel-bwrap" id="ext-gen17">
		 <div class="x-panel-body" id="ext-gen18" style="overflow: auto; width: 198px; height: 639px;">
			<ul id="treeDemo" class="ztree"></ul>
		 </div>
		</div>
	</div>
	<div id="ext-gen16-1" class="x-layout-collapsed" style="display: none; width: 20px; height: 663px; position: absolute; visibility: visible; top: 1px; z-index: 20;">
		<div id="ext-gen20-1" class="x-tool" style="margin-right: 2px;margin-top: 3px;background-position: 0 -165px;"></div>
	</div>
	<div id="ext-comp-1002" class="x-panel x-border-panel x-panel-noborder" style="left: 208px; top: 0px; width: 1158px;">
		<div class="x-panel-bwrap" id="ext-gen31">
			<div class="x-panel-body x-panel-body-noheader x-panel-body-noborder" id="ext-gen32" style="width: 1158px; height: 667px;">
				<iframe src="" id="container_content" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>
			</div>
		</div>
	</div>

</BODY>
</HTML>
