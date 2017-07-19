<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>湖北移动数据文件安全管控平台</title>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/zclip/jquery.zclip.js"></script>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
<script type="text/javascript" src="${mvcPath}/resources/js/jquery.form.js"></script>

<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ext-base.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ext-all.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/Ext.ux.UploadDialog.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/locale/ru.utf-8_zh.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/datepicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext2.0/resources/css/ext-all.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/css/Ext.ux.UploadDialog.css" />
<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
<!--<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/bass_common.css" />-->

</head>
<body class="easyui-layout">
	<div region="north" split="false" border="false" style="overflow: hidden; height: 30px; line-height: 30px; background: #7f99be; color: #fff; font-family: Verdana, 微软雅黑, 黑体">
		<span style="float: right; padding-right: 20px;" class="head">欢迎${userName}  <a href="${mvcPath}/outlogin" id="loginOut">安全退出</a></span> <span style="padding-left: 10px; font-size: 16px; float: left;">湖北移动数据文件安全管控平台</span>
	</div>
	<div data-options="region:'south'" style="height:20px;"></div>
	<div data-options="region:'west'" style="width:200px;">
		<#include "/ftl/west.ftl"></include>
	</div>
	<div data-options="region:'center',title:'系统'" style="overflow: hidden;">
		<#include "/ftl/center.ftl"></include>
	</div>

	
</body>
</html>