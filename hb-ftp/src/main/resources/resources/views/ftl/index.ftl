<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>湖北移动数据文件安全管控平台</title>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
<script type="text/javascript">

$(function(){
	$('#tt').tree({ 
	    url:'${mvcPath}/resources/views/ftl/tree_data.json',
	    method: 'get',
	    onClick: function(node){
			if (node.attributes.url!=null) {
				var url = '${mvcPath}' +node.attributes.url;
				addTab(node.text, url);
			}
		}
	})
});

function addTab(title, url) {
	var t = $('#layout_center_tabs');
	if (t.tabs('exists', title)) {
		t.tabs('select', title);
	} else {
		var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
		t.tabs('add',{
			title:title,
			content:content,
			closable:true
		});
	}
}
</script>
</head>
<body class="easyui-layout">
	<div region="north" split="false" border="false" style="overflow: hidden; height: 30px; line-height: 30px; background: #7f99be; color: #fff; font-family: Verdana, 微软雅黑, 黑体">
		<span style="float: right; padding-right: 20px;" class="head">欢迎${userName}  <a href="${mvcPath}/outlogin" id="loginOut">安全退出</a></span> <span style="padding-left: 10px; font-size: 16px; float: left;">湖北移动数据文件安全管控平台</span>
	</div>
	<div data-options="region:'south'" style="height:20px;"></div>
	<div data-options="region:'west'" style="width:200px;">
		<div class="easyui-panel" data-options="title:'功能菜单',border:false,fit:true">
			<div class="easyui-accordion" data-options="fit:true,border:false">
				<div title="菜单" data-options="iconCls:'icon-ok'" style="overflow:auto;padding:10px;">
					<ul id="tt"></ul>  
				</div>
			</div>
		</div>
	</div>
	<div data-options="region:'center',title:'系统'" style="overflow: hidden;">
		<div id="layout_center_tabs" class="easyui-tabs" data-options="fit:true,border:false" style="overflow: hidden;">
			<div title="首页"></div>
		</div>
	</div>
</body>
</html>