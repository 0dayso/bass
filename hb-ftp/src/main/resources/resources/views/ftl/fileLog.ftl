<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>日志管理</title>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
<script type="text/javascript">

function searchLog(){
	var fileName = $("#fileNamel").val().trim();
	var userName = $("#userNamel").val().trim();
	var operType = $("#operTypel").val().trim();
	var startTime = $("#startTimel").datebox('getValue').trim();
	var endTime = $("#endTimel").datebox('getValue').trim();
	
	$("#logTable").datagrid("load", {
		fileName : fileName,
		userName : userName,
		operType : operType,
		startTime : startTime,
		endTime : endTime
	});
}

</script>
</head>
<body>
<div style="margin: 2px 0;"></div>
<table id="logTable" class="easyui-datagrid" title="日志信息列表"
	style="width: auto; height: auto"
	data-options="fit:true,fitColumns : true,striped:true,pagination : true,idField : 'fileid',pageSize : 10,pageList : [10, 20, 30, 50],
				rownumbers:true,singleSelect:true,checkOnSelect : false,
				url:'${mvcPath}/fileLog/getLogInfo',toolbar:'#tb'">
	<thead>
		<tr>
			<th data-options="field:'file_id',width:120">文件ID</th>
			<th data-options="field:'file_name',width:150">文件名称</th>
			<th data-options="field:'user_name',width:130">用户名</th>
			<th data-options="field:'oper_type',width:120">操作类型</th>
			<th data-options="field:'oper_time',width:140">操作时间</th>
		</tr>
	</thead>
</table>

<div id="tb">
	<div>
		文件名称: <input class="easyui-text" style="width: 120px; height:20px; line-height:20px;" id="fileNamel">
		用户ID： <input class="easyui-text" style="width: 120px; height:20px; line-height:20px;" id="userNamel">
		操作类型： <select id="operTypel" style="width: 120px; height:20px; line-height:20px;">
					<option value="">---请选择---</option>
					<option value="新增">新增</option>
					<option value="删除">删除</option>
					<option value="审核">审核</option>
					<option value="下载">下载</option>
			   </select>
		操作时间：<input class="easyui-datebox" id="startTimel" readonly="readonly"/> ~
		<input class="easyui-datebox" id="endTimel" readonly="readonly"/>
		<a href="#" class="easyui-linkbutton" iconCls="icon-search"
			onclick="searchLog()">查询</a>
	</div>
</div>
</body>
</html>