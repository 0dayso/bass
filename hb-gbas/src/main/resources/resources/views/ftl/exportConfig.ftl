<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>接口导出管理</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>

function openParamDialog(){
	var rows = $('#configTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条配置信息','info');
		return;
	}
	$("#currentConfig").val(rows[0].task_id);
	$("#sqlShow").html(rows[0].sql_describe);
	reloadParamTable();
    $("#paramContainer").window('open');
}

function reloadParamTable(){
	var taskId = $("#currentConfig").val();
	var options = $('#paramTable').datagrid('options');
    options.url = '${mvcPath}/exportConfig/getTaskParam';
    options.queryParams = {
		taskId: taskId
	};
    $('#paramTable').datagrid(options);
}
var editIndex = undefined;

function endEditing(){
	if (editIndex == undefined){return true}
	if ($('#paramTable').datagrid('validateRow', editIndex)){
		$('#paramTable').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}
		
function onClickRow(index){
	if (editIndex != index){
		if (endEditing()){
			$('#paramTable').datagrid('selectRow', index)
					.datagrid('beginEdit', index);
			editIndex = index;
		} else {
			$('#paramTable').datagrid('selectRow', editIndex);
		}
	}
}

function append(){
	if (endEditing()){
		$('#paramTable').datagrid('appendRow',{param_type:'0',param_len:'3',target_len:'10',conv_param:'0'});
		editIndex = $('#dg').datagrid('getRows').length-1;
		$('#paramTable').datagrid('selectRow', editIndex)
				.datagrid('beginEdit', editIndex);
	}
}
function removeit(){
	if (editIndex == undefined){return}
	$('#paramTable').datagrid('cancelEdit', editIndex)
			.datagrid('deleteRow', editIndex);
	editIndex = undefined;
}

function accept(){
	if (endEditing()){
		$('#paramTable').datagrid('acceptChanges');
	}
	var rows = $('#paramTable').datagrid('getRows');
	for(var i=0; i<rows.length; i++){
		if(rows[i].param_type.length == 0){
			$('#paramTable').datagrid('selectRow',i);  
			$.messager.alert('提示','param_type不能为空','info');
			return;
		}
		if(rows[i].param_len.length == 0){
			$('#paramTable').datagrid('selectRow',i);  
			$.messager.alert('提示','param_len不能为空','info');
			return;
		}
		if(rows[i].target_len.length == 0){
			$('#paramTable').datagrid('selectRow',i);  
			$.messager.alert('提示','target_len不能为空','info');
			return;
		}
		if(rows[i].conv_param.length == 0){
			$('#paramTable').datagrid('selectRow',i);  
			$.messager.alert('提示','conv_param不能为空','info');
			return;
		}
	}
	var taskId = $("#currentConfig").val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/exportConfig/saveTaskParam"
		,data: {
			taskId: taskId,
			rows: JSON.stringify(rows)
		}
		,dataType : "json"
		,success: function(data){
			var wind = $.messager.alert('提示', '保存成功','info');
			wind.window({onBeforeClose:function(){
				$("#paramContainer").window('close');
			}});
		}
	});
}

function openAddDialog(){
	$('#configDialog').panel({title: "新增导出配置"});
	$('#configForm').form('clear');
	$('#configDialog').dialog('open');
}

function openEditDialog(){
	var rows = $('#configTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条配置信息','info');
		return;
	}
	setFormValue(rows[0]);
	$('#configDialog').panel({title: "修改导出配置"});
	$('#configDialog').dialog('open');
}

function setFormValue(config){
	$('#taskId').val(config.task_id);
	$('#sqlDescribe').textbox('setValue',config.sql_describe);
	$('#remark').textbox('setValue',config.remark);
	$('#unitCode').textbox('setValue',config.unit_code);
	$('#fileStandBy').textbox('setValue',config.file_standby);
	$('#filterType').textbox('setValue',config.filter_type);
	$('#status').textbox('setValue',config.status);
	$('#taskType').textbox('setValue',config.task_type);
	$('#execPath').textbox('setValue',config.execpath);
	$('#execName').textbox('setValue',config.execname);
	$('#ftpFlag').textbox('setValue',config.ftp_flag);
	$('#createSh').textbox('setValue',config.createsh);
}

function delConfig(){
	var rows = $('#configTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条配置信息','info');
		return;
	}
	$.messager.confirm('提示', '您确定要删除此条配置吗?', function(r){
		if (r){
			$.ajax({
				type: "POST"
				,url: "${mvcPath}/exportConfig/delTaskConfig"
				,data: {
					taskId: rows[0].task_id
				}
				,dataType : "json"
				,success: function(data){
					var wind = $.messager.alert('提示','删除成功','info');
					wind.window({onBeforeClose:function(){
						$('#configTable').datagrid('reload');
					}});
				}
			});
		}
	});
}
</script>
</head>
<body>
	<input id="currentConfig" type="hidden">
	<table id="configTable" class="easyui-datagrid" title="接口导出配置" style="height:auto;"
			data-options="fit:true, striped:true, pagination : true, pageSize : 10, pageList : [10, 20, 30, 50],
				rownumbers:true, singleSelect:true, checkOnSelect : false,
				url:'${mvcPath}/exportConfig/getConfigList',toolbar:'#tb'">
		<thead>
			<tr>
				<!--<th field="itemId" checkbox="true"></th>-->
				<th data-options="field:'task_id',width:40,hidden: true,">TASK_ID</th>
				<th data-options="field:'remark',width:150,">REMARK</th>
				<th data-options="field:'sql_describe',width:300,">SQL_DESCRIBE</th>
				<th data-options="field:'unit_code',width:80">UNIT_CODE</th>
				<th data-options="field:'file_standby',width:80,">FILE_STANDBY</th>
				<th data-options="field:'filter_type',width:80">FILTER_TYPE</th>
				<th data-options="field:'status',width:50,">STATUS</th>
				<th data-options="field:'task_type',width:60">TASK_TYPE</th>
				<th data-options="field:'execpath',width:150">EXECPATH</th>
				<th data-options="field:'execname',width:150">EXECNAME</th>
				<th data-options="field:'ftp_flag',width:60">FTP_FLAG</th>
				<th data-options="field:'createsh',width:100">CREATESH</th>
			</tr>
		</thead>
	</table>
	
	<div id="tb" style="padding:5px;height:auto">
		<div>
			<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">修改</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-remove" onclick="delConfig()">删除</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-setting" onclick="openParamDialog()">字段配置</a>
		</div>
	</div>
	
	<!--导出字段配置弹窗开始-->
	<div id="paramContainer" title="字段配置" class="easyui-window" 
		data-options="modal:true, closed:true,width: 700, height:500">
		<div>
			<div id="sqlShow" class="detail-box"></div>
		</div>
		<table id="paramTable" class="easyui-datagrid" style="height:356px;"
		    data-options="fitColumns:true,pagination : false,singleSelect:true,onClickRow: onClickRow,
		    	rownumbers:true,nowrap:false,toolbar:'#configTb'">
		    <thead>
				<tr>
					<th data-options="field:'param_type',width:50,editor:'numberbox'">PARAM_TYPE</th>
					<th data-options="field:'param_len',width:50,editor:'numberbox'">PARAM_LEN</th>
					<th data-options="field:'target_len',width:50,editor:'numberbox'">TARGET_LEN</th>
					<th data-options="field:'conv_param',width:50,editor:'numberbox'">CONV_PARAM</th>
				</tr>
		    </thead>
		</table>
	</div>
	
	<div id="configTb" style="height:auto">
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-reload',plain:true" onclick="reloadParamTable()">初始化</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append()">增加行</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit()">删除行</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="accept()">保存</a>
	</div>
	<!--导出字段配置弹窗结束-->
	
	<!--编辑配置弹窗开始-->
	<div id="configDialog" class="easyui-dialog" title="修改配置" data-options="
			modal:true,
			closed:true,
			width:430,
			height:500,
			buttons: [{
					text:'提交',
					handler:function(){
						$('#configForm').form('submit', {
							url: '${mvcPath}/exportConfig/saveTaskConfig',
							onSubmit: function(param){
								return $(this).form('enableValidation').form('validate');
							},
							success:function(data){
								var wind = $.messager.alert('提示','提交成功','info');
								wind.window({onBeforeClose:function(){
									$('#configTable').datagrid('reload');
									$('#configDialog').dialog('close');
								}});
   							}
   							
						});
					}
				},{
					text:'取消',
					handler:function(){
						$('#configDialog').dialog('close');
					}
				}]">
		<form id="configForm">
			<div class="mar-8" style="height:100px;">
				<input id="taskId" name="taskId" type="hidden">
				<div class="mar-b15">
					<div class="inp-lab">SQL_DESCRIBE:</div>
					<input id="sqlDescribe" name="sqlDescribe" class="easyui-textbox form-inp" data-options="multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">REMARK:</div>
					<input id="remark" name="remark" class="easyui-textbox form-inp" data-options="multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">UNIT_CODE:</div>
					<input id="unitCode" name="unitCode" class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">FILE_STANDBY:</div>
					<input id="fileStandBy" name="fileStandBy" class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">FILTER_TYPE:</div>
					<input id="filterType" name="filterType" class="easyui-numberbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">STATUS:</div>
					<input id="status" name="status" class="easyui-numberbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">TASK_TYPE:</div>
					<input id="taskType" name="taskType" class="easyui-numberbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">EXECPATH:</div>
					<input id="execPath" name="execPath" class="easyui-numberbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">EXECNAME:</div>
					<input id="execName" name="execName" class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">FTP_FLAG:</div>
					<input id="ftpFlag" name="ftpFlag" class="easyui-textbox form-inp" data-options="validType:'length[0,1]'" style="height:32px; width:75%;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">CREATESH:</div>
					<input id="createSh" name="createSh" class="easyui-textbox form-inp" data-options="validType:'length[0,1]'" style="width:75%;height:32px;">
				</div>
			</div>
		</form>
	</div>
	<!--编辑配置弹窗结束-->
	
</body>
</html>