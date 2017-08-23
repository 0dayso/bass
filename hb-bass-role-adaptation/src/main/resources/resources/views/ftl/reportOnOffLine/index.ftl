<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>报表上下线工具</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>
$(function(){
	$('#myTab').tabs({
		onSelect:function(title,index){
			if(index == 1){
				if($("#online>iframe").length==0){
					$("#online").append("<iframe src='${mvcPath}/report/onoffline/offline' frameborder='0' style='width:100%;height:98%;'></iframe>");
				}
			}
		}
	});
});
</script>
</head>
<body style="margin:0; padding: 3px 1px 0 1px; height: 100%">
	<div class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'center'">
			<div id="myTab" class="easyui-tabs" style="width:100%;" data-options="fit:true,border:false">
				<div id="offline" title="待上线报表">
					<iframe src='${mvcPath}/report/onoffline/online' frameborder='0' style='width:100%;height:98%;'></iframe>
				</div>
				<div id="online" title="已上线报表">
				</div>
			</div>
		</div>
	</div>
</body>
</html>