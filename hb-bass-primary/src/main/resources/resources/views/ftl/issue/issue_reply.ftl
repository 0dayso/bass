<#assign reply_content = twis[0].content?split("#")>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>回复：${reply_content[1]}</title>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Cache-Control" content="no-cache"/>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ext-base.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ext-all.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/Ext.ux.UploadDialog.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/locale/ru.utf-8_zh.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext2.0/resources/css/ext-all.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/ext2.0/ux/UploadDialog/css/Ext.ux.UploadDialog.css" />
<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/bass_common.css" />


<script>
(function($){
$(document).ready(function(){
	Ext.QuickTips.init();

});

})(jQuery)
</script>
</head>
<body>
<div>
	<a href="${mvcPath}/issue" id="commentBtn" class="aBtn greenBtn"><b>返回</b></a>
</div>
<div>
	<#include "/ftl/issue/common.ftl">
</div>
</body>
</html>