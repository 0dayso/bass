<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
<title>集中化省级经分质量管控平台</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>
function addTab(title, url){
	
	if(url == ''){
		alert('正在开发中……');
		return;
	}
	
	if ($('#myTab').tabs('exists', title)){
		$('#myTab').tabs('select', title);
	} else {
		var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:100%;height:100%;"></iframe>';
		$('#myTab').tabs('add',{
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
		<span style="float: right; padding-right: 20px;" class="head">欢迎${userName}  <a href="${mvcPath}/outlogin" id="loginOut"><span style="color:lightblue">安全退出</span></a></span> <span style="padding-left: 10px; font-size: 16px; float: left;">集中化省级经分质量管控平台</span>
	</div>
	<div data-options="region:'south'" style="height:20px;"></div>
	<div data-options="region:'west'" style="width:200px;">
		<div class="easyui-panel" data-options="title:'功能菜单',border:false,fit:true">
			<div id="menu" class="easyui-accordion" data-options="fit:true,border:false">
				<div title='基本配置'>
					<ul style="padding: 0 10px;">
						<li><a href='#' onclick="addTab('指标配置', '${mvcPath}/zb/index')"><span>指标配置</span></a></li>
						<li><a href='#' onclick="addTab('接口配置', '')"><span>接口配置</span></a></li>
						<li><a href='#' onclick="addTab('接口时限告警', '')"><span>接口时限告警</span></a></li>
						<li><a href='#' onclick="addTab('短信告警人配置', '${mvcPath}/smsConfig/user/index')"><span>短信告警人配置</span></a></li>
						<li><a href='#' onclick="addTab('短信告警群组配置', '${mvcPath}/smsConfig/group/index')"><span>短信告警群组配置</span></a></li>
						<li><a href='#' onclick="addTab('违反稽核告警配置', '')"><span>违反稽核告警配置</span></a></li>
					</ul>
				</div>
		
				<div title='业务'>
					<ul style="padding: 0 10px;">
						<li><a href='#' onclick="addTab('任务运行概况', '${mvcPath}/task/index')"><span>任务运行概况</span></a></li>
						<li><a href='#' onclick="addTab('程序运行分析', '"><span>程序运行分析</span></a></li>
						<li><a href='#' onclick="addTab('指标波动性展示', '${mvcPath}/analyse/zbFluctuate')"><span>指标波动性展示</span></a></li>
						<li><a href='#' onclick="addTab('平台健康度监控', '')"><span>平台健康度监控</span></a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div data-options="region:'center'" style="overflow: hidden;">
		<div id="myTab" class="easyui-tabs" style="height:100%;">
			<div title="首页" style="padding:2px; overflow: hidden;">
				<iframe scrolling="auto" frameborder="0"  src="${mvcPath}/analyse/index/daily" style="width:100%;height:100%;"></iframe>
			</div>
		</div>
	</div>

</body>
</html>