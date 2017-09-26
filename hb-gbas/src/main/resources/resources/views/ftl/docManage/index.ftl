<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
<title>文档管理</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>

function openAddDialog(){
	$("#docId").val("");
	$('#docForm').form('clear');
	$('#docDialog').panel({title: "新增文档"});
	$("#docDialog").dialog("open");
}

function openEditDialog(){
	var rows = $('#docTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条文档信息','info');
		return;
	}
	$("#docId").val(rows[0].id);
	setFormValue(rows[0]);
	$('#docDialog').panel({title: "修改文档信息"});
	$("#docDialog").dialog("open");
}

function setFormValue(item){
	$("#name").textbox("setValue", item.name);
	$("#desc").textbox("setValue", item.desc);
}

function delDoc(){
	var rows = $('#docTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条文档信息','info');
		return;
	}
	
	$.messager.confirm('提示', '您确定要删除所选文档信息吗?', function(r){
		if (r){
			$.ajax({
				type: "post",
				url: '${mvcPath}/docManage/delDoc',
				data: {
					docId: rows[0].id
				},
				dataType : "json",
				success: function(data){
					var wind = $.messager.alert('提示','删除成功','info');
					wind.window({onBeforeClose:function(){
						queryDoc();
					}});
				}
			});
		}
	});
}

function queryDoc(){
	var name = $("#qryName").val().trim();
	var userName = $("#qryUserName").val().trim();
	
	$("#docTable").datagrid("load", {
		userName : userName,
		name : name
	});
}

var docName = '';
function viewVersion(){
	var rows = $('#docTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条文档信息','info');
		return;
	}
	
	docName = rows[0].name;
	var options = $('#versionTable').datagrid('options');
    options.url = '${mvcPath}/docManage/getVersionList';
    options.queryParams = {
		docId: rows[0].id
	};
    $('#versionTable').datagrid(options);
    $("#versionContainer").window('open');
}

function operation(value, row, index){
	var oprHtml = "<a class='oper' href='#' onclick=openDocEditPage('" + row.doc_id + "','" + row.version + "')>打开文档</a>";
	return oprHtml;
}

function openDocEditPage(docId, version){
	window.parent.addTab('文档编辑(' + docName + '_' + version + ')' ,'${mvcPath}/docManage/markdown?docId=' + docId + '&version=' + version);
}

</script>
</head>
<body>
	<table id="docTable" class="easyui-datagrid" style="height:auto;" title="文档信息"
			data-options="fit:true, fitColumns : true, striped:true, pagination : true, pageSize : 10, pageList : [10, 20, 30, 50],
				rownumbers:true, singleSelect:true, checkOnSelect : false,
				url:'${mvcPath}/docManage/getDocInfoList',toolbar:'#tb'">
		<thead>
			<tr>
				<!--<th field="id" checkbox="true"></th>-->
				<th data-options="field:'id',width:100,hidden:true,">ID</th>
				<th data-options="field:'name',width:120,">文档名称</th>
				<th data-options="field:'desc',width:180">描述</th>
				<th data-options="field:'creator_name',width:100,">创建人</th>
			</tr>
		</thead>
	</table>
	
	<div id="tb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>文档名称</span>
			<input id="qryName" class="easyui-textbox" style="height: 27px; width: 160px;">
			<span>创建人</span>
			<input id="qryUserName" class="easyui-textbox" style="height: 27px; width: 160px;">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryDoc()">查询</a>
		</div>
		<div>
			<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">修改</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-remove" onclick="delDoc()">删除</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-list" onclick="viewVersion()">查看版本信息</a>
		</div>
	</div>
	
	<!--文档信息编辑弹窗开始-->
	<div id="docDialog" class="easyui-dialog" title="新增文档" data-options="
			modal:true,
			closed:true,
			width:400,
			height:240,
			buttons: [{
					text:'提交',
					handler:function(){
						$('#docForm').form('submit', {
							url: '${mvcPath}/docManage/saveDocInfo',
							onSubmit: function(param){
								return $(this).form('enableValidation').form('validate');
							},
							success:function(data){
								var wind = $.messager.alert('提示','提交成功','info');
								wind.window({onBeforeClose:function(){
									queryDoc();
									$('#docDialog').dialog('close');
								}});
   							}
   							
						});
					}
				},{
					text:'取消',
					handler:function(){
						$('#docDialog').dialog('close');
					}
				}]">
		<div class="mar-8">
			<form id="docForm">
				<input id="docId" name="docId" type="hidden">
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>文档名称:</div>
					<input id="name" name="name" class="easyui-textbox" missingMessage="文档名称为必填项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">备注:</div>
					<input id="desc" name="desc" class="easyui-textbox" missingMessage="备注为必填项" data-options="multiline:true" style="width:75%;height:60px;">
				</div>
			</form>
		</div>
	</div>
	<!--文档信息编辑弹窗结束-->
	
	<!--版本信息弹窗开始-->
	<div id="versionContainer" title="版本信息查看" class="easyui-window" 
		data-options="modal:true, closed:true,width: 700, height:450">
		<table id="versionTable" class="easyui-datagrid" style="height:auto;"
		    data-options="fit:true,fitColumns:true,pagination : false,singleSelect:true,rownumbers:true,nowrap:false,">
		    <thead>
				<tr>
					<th data-options="field:'doc_id',width:30, hidden:true">doc_id</th>
					<th data-options="field:'version',width:50">版本号</th>
					<th data-options="field:'creator_name',width:50">创建人</th>
					<th data-options="field:'create_time',width:90">创建时间</th>
					<th data-options="field:'updator_name',width:50">更新人</th>
					<th data-options="field:'update_time',width:90">更新时间</th>
					<th data-options="field:'oper',width:50,formatter: operation">操作</th>
				</tr>
		    </thead>
		</table>
	</div>
	<!--版本信息弹窗结束-->
</body>
</html>