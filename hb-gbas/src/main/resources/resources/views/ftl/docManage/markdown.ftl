<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>文档编辑</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" href="${mvcPath}/resources/lib/editormd/css/editormd.css" />
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/lib/editormd/editormd.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script src="${mvcPath}/resources/js/common.js"></script>
<style>
body{
	margin: 0;
	padding-top: 3px;
}

</style>
</head>
<body>
<div id="my-editormd">                
    <textarea id="mdContent" style="display:none;">${content!}</textarea>
</div>
<script type="text/javascript">
$(function() {
    var testEditor = editormd("my-editormd", {
        width  : "99%",
        height : $(window).height() -10,
        flowChart : true,
        path   : '${mvcPath}/resources/lib/editormd/lib/',
        onSave : function() {
        	saveContent();
        },
        onSubmit: function(){
        	submit();
        }
    });
});

var docId = ${docId};
var version = '${version}';

function saveContent(){
	var content = $("#mdContent").html();
	loadMask();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/docManage/saveMdContent"
		,data: {
			content: content,
			docId: docId,
			version: version
		}
		,dataType : "json"
		,success: function(data){
			unMask();
			if(data.flag == -1){
				$.messager.alert('错误', data.msg,'error');
				return false;
			}
			$.messager.alert('提示','保存成功','info');
		},
		error:function(data, textStatus){
			unMask();
			$.messager.alert('错误', '操作失败，错误码：' + data.status,'error');
		}
	});
}

function submit(){
	var content = $("#mdContent").html();
	loadMask();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/docManage/submitMdContent"
		,data: {
			content: content,
			docId: docId
		}
		,dataType : "json"
		,success: function(data){
			unMask();
			if(data.flag == -1){
				$.messager.alert('错误', data.msg,'error');
				return false;
			}
			var wind = $.messager.alert('提示','提交成功','info');
			wind.window({onBeforeClose:function(){
				window.parent.tabClose();
			}});
		},
		error:function(data, textStatus){
			unMask();
			$.messager.alert('错误', '操作失败，错误码：' + data.status,'error');
		}
	});
}

</script>
</body>
</html>