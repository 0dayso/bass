<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>报表上线工具</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/report.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>

//日期格式化
function formatter(value, row, index) {
	if (value != null) {
		return new Date(parseInt(value)).toLocaleString().replace(/年|月/g, "-").replace(/日/g, " ");
	} else {
		return "";
	}
}

function queryErrorPage(){
	var menuitemtitle = $("#menuitemtitle").textbox('getValue').trim();
	var startDate = $("#startDate").textbox('getValue').trim();
	var endDate = $("#endDate").textbox('getValue').trim();
	
	$("#errorInfoPage").datagrid("load", {
		menuitemtitle : menuitemtitle,
		startDate : startDate,
		endDate : endDate
	});
}

function operation(value, row, index){
	var oprHtml = "<a class='oper' href='#' onclick=delErrorInfo('" + row.errorpageid + "')>删除</a>";
	return oprHtml;
}

function delErrorInfo(errorPageId){
	console.log(errorPageId);
	$.messager.confirm('确认删除?', '确认删除所选项么?', function(r) {
		$.post('delErrorUrl', {
			errorPageIds : errorPageId
		}, function(result) {
			$.messager.alert('操作结果', '删除成功');
			$('#errorInfoPage').datagrid('load'); // reload the user data 
		}, 'json');
	});
}

</script>
</head>
<body>
	<div class="qry-line" id="search">
		<label style="margin-left: 15px;">错误页面：</label>
		<input id="menuitemtitle" class="easyui-textbox" style="height:28px;"/>
		<label style="margin-left: 15px;">错误日期：</label>
		<input id="startDate" class="easyui-datebox" style="height:28px;"/>
		—至—
		<input id="endDate" class="easyui-datebox" style="height:28px;"/>
		<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryErrorPage()">查询</a>
	</div>
	<table id="errorInfoPage" class="easyui-datagrid" title="文件信息列表" style="width: auto; height: auto"
	data-options="fit:true,fitColumns : true,striped:true,pagination : true,idField : 'fileid',pageSize : 10,pageList : [ 10, 20, 30, 50 ],
				sortName : 'create_time',rownumbers:true,singleSelect:false,checkOnSelect : false,
				selectOnCheck : true,url:'getAllErrorUrlInfo',toolbar:'#search'">
		<thead>
			<tr>
			
				<th data-options="field:'errorpageid',hidden:true"></th>
				<th data-options="field:'menuitemid',width:40">错误页面ID</th>
				<th data-options="field:'menuitemtitle',width:60">错误页面</th>
				<th data-options="field:'url',width:100">路径</th>
				<th data-options="field:'errorcode',width:30">错误代码</th>
				<th data-options="field:'errormessage',width:100">详细信息</th>
				<th data-options="field:'errordate',width:90,formatter:formatter">错误日期</th>
				<th data-options="field:'opt',width:20,formatter: operation">操作</th>
			</tr>
		</thead>
	</table>
</body>
</html>