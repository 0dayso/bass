<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
<title>短信告警群组配置</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script src="${mvcPath}/resources/js/treegrid-pagination.js"></script>
<script>
$(function(){
	$('#groupTable').treegrid().treegrid('clientPaging');
	
	$("input",$("#addGroupId").next("span")).blur(function(){
	    checkGroupId();  
	});
});

function checkGroupId(){
	var groupId = $('#addGroupId').textbox('getValue');
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/smsConfig/checkGroupId"
		,data: {
			groupId: groupId
		}
		,async:false
		,dataType : "json"
		,success: function(data){
			if(!data){
				var wind = $.messager.alert('提示','此群组ID已存在，请重新填入','info');
				wind.window({onBeforeClose:function(){
					$('#addGroupId').textbox('setValue','');
				}});
			}
		}
	});
}

function queryGroup(){
	var qryGroupId = $("#qryGroupId").textbox("getValue").trim();
	var qryGroupName = $("#qryGroupName").textbox("getValue").trim();
	var qryUserName = $("#qryUserName").textbox("getValue").trim();
	var qryNum = $("#qryNum").textbox("getValue").trim();
	
	$("#groupTable").treegrid("load", {
		groupId : qryGroupId,
		groupName : qryGroupName,
		userName : qryUserName,
		num : qryNum
	});
}

function openAddDialog(){
	$("#groupType").combobox('setValue', 'SMS');
	$("#addDialog").dialog("open");
	var options = $('#addUserTable').datagrid('options');
    options.url = '${mvcPath}/smsConfig/getAlarmUserList';
    $('#addUserTable').datagrid(options);
}

function openEditDialog(){
	var row = $('#groupTable').treegrid('getSelected');
	if(row == null){
		$.messager.alert('提示','请选择一条群组信息','info');
		return;
	}
	
	$("#groupId").textbox("setValue", row.id);
	$("#groupName").textbox("setValue", row.name);
	$("#groupType").combobox("setValue", row.type);
	$('#groupId').textbox('textbox').attr('disabled',true);
	$("#editDialog").dialog("open");
	initGroupUser();
}

function delGroup(){
	var row = $('#groupTable').treegrid('getSelected');
	if(row == null){
		$.messager.alert('提示','请选择一条群组信息','info');
		return;
	}
	
	$.messager.confirm('提示', '您确定要删除群组<' + row.name + '>吗?', function(r){
		if (r){
			$.ajax({
				type: "post",
				url: '${mvcPath}/smsConfig/delAlarmGroup',
				data: {
					groupId: row.id
				},
				dataType : "json",
				success: function(data){
					var wind = $.messager.alert('提示','删除成功','info');
					wind.window({onBeforeClose:function(){
						queryGroup();
					}});
				}
			});
		}
	});
}

function initGroupUser(){
	var groupId = $("#groupId").textbox("getValue");
	var options = $('#groupUserTable').datagrid('options');
    options.url = '${mvcPath}/smsConfig/getUserByGroupId';
    options.queryParams = {
		groupId : groupId
	};
    $('#groupUserTable').datagrid(options);
}

function addAlarmGroup(){
	var checkFlag = $("#addForm").form('enableValidation').form('validate');
	if(!checkFlag){
		return;
	}
	
	var groupId = $("#addGroupId").textbox("getValue").trim();
	if(groupId.length == 0){
		$.messager.alert('提示','请输入群组ID','info');
		return;
	}
	var groupName = $("#addGroupName").textbox("getValue").trim();
	if(groupName.length == 0){
		$.messager.alert('提示','请输入群组名称','info');
		return;
	}
	
	var rows = $('#addUserTable').datagrid('getChecked');
	if(rows.length == 0){
		$.messager.alert('提示','请至少选择一条告警人信息','info');
		return;
	}
	
	var ids = new Array();
	for(var i=0; i<rows.length; i++){
		ids.push(rows[i].id);
	}
	var groupType = $("#groupType").combobox('getValue');
	saveGroup('add', groupId, groupName, groupType, ids.toString());
}

function saveGroup(operType, groupId, groupName, groupType,userIds){
	$.ajax({
		type: "post",
		url: '${mvcPath}/smsConfig/saveAlarmGroup',
		data: {
			operType: operType,
			groupId: groupId,
			groupName: groupName,
			groupType: groupType,
			userIds: userIds
		},
		dataType : "json",
		success: function(data){
			var wind = $.messager.alert('提示','提交成功','info');
			wind.window({onBeforeClose:function(){
				queryGroup();
				$("#addDialog").dialog("close");
				$("#editDialog").dialog("close");
			}});
		}
	});
}

function editAlarmGroup(){
	var checkFlag = $("#editForm").form('enableValidation').form('validate');
	if(!checkFlag){
		return;
	}
	var groupName = $("#groupName").textbox("getValue").trim();
	if(groupName.length == 0){
		$.messager.alert('提示','请输入群组名称','info');
		return;
	}
	var groupType = $("#groupType").combobox('getValue');
	var groupId = $("#groupId").textbox("getValue").trim();
	saveGroup('edit', groupId, groupName, groupType,'');
}

function queryUser(){
	var groupId = $("#groupId").textbox("getValue").trim();
	var qryUserNum = $("#qryUserNum").val().trim();
	var qryUserName = $("#qryUserName").val().trim();
	$("#userTable").datagrid("load", {
		userName : qryUserName,
		num : qryUserNum,
		groupId: groupId
	});
}

function userSelect(){
	var rows = $('#userTable').datagrid('getChecked');
	if(rows.length == 0){
		$.messager.alert('提示','请至少选择一条告警人信息','info');
		return;
	}
	
	var ids = new Array();
	for(var i=0; i<rows.length; i++){
		ids.push(rows[i].id);
	}
	
	var groupInfo = $('#groupTable').treegrid('getSelected');
	$.ajax({
		type: "post",
		url: '${mvcPath}/smsConfig/saveAlarmGroup',
		data: {
			operType: 'add',
			groupId: groupInfo.id,
			groupName: groupInfo.name,
			groupType: groupInfo.type,
			userIds: ids.toString()
		},
		dataType : "json",
		success: function(data){
			$("#userDialog").dialog("close");
			initGroupUser();
		}
	});
}

function addGroupUser(){
	$("#qryUserNum").val('');
	$("#qryUserName").val('');
	$('#userDialog').dialog('open');
	var groupId = $("#groupId").textbox("getValue").trim();
	var options = $('#userTable').datagrid('options');
    options.url = '${mvcPath}/smsConfig/getNotInUserList';
    options.queryParams = {
		userName : '',
		num : '',
		groupId: groupId
	};
    $('#userTable').datagrid(options);
}

function delGroupUser(){
	var rows = $('#groupUserTable').datagrid('getChecked');
	if(rows.length == 0){
		$.messager.alert('提示','请至少选择一条告警人信息','info');
		return;
	}
	var allRows = $('#groupUserTable').datagrid('getRows');
	if(rows.length == allRows.length){
		$.messager.alert('提示','请至少保留一条告警人信息','info');
		return;
	}
	
	var nums = new Array();
	for(var i=0; i<rows.length; i++){
		nums.push(rows[i].acc_nbr);
	}
	var groupId = $("#groupId").textbox("getValue").trim();
	$.ajax({
		type: "post",
		url: '${mvcPath}/smsConfig/delGroupUser',
		data: {
			groupId: groupId,
			nums: nums.toString()
		},
		dataType : "json",
		success: function(data){
			var wind = $.messager.alert('提示','删除成功','info');
			wind.window({onBeforeClose:function(){
				initGroupUser();
			}});
		}
	});
}

</script>
</head>
<body>
	<table id="groupTable" class="easyui-treegrid" style="height:auto;" title="告警群组信息"
			data-options="fit:true, fitColumns : true, singleSelect:true, idField:'id',treeField:'name',toolbar:'#tb',
			pagination : true, pageSize : 10, pageList : [ 10, 20, 30, 50 ],
				url:'${mvcPath}/smsConfig/getAlarmGroup'">
		<thead>
			<tr>
				<th data-options="field:'id',width:60,hidden:true,">群组ID</th>
				<th data-options="field:'name',width:100">名称(群组ID)</th>
				<th data-options="field:'type',width:60,">类型/电话</th>
				<th data-options="field:'remark',width:100,">备注</th>
			</tr>
		</thead>
	</table>
	<div id="tb">
		<div style="padding: 3px;">
			<span>群组ID</span>
			<input id="qryGroupId" class="easyui-textbox" style="height: 27px; width: 160px;">
			<span>群组名称</span>
			<input id="qryGroupName" class="easyui-textbox" style="height: 27px; width: 160px;">
			<span>告警人姓名</span>
			<input id="qryUserName" class="easyui-textbox" style="height: 27px; width: 160px;">
			<span>手机号</span>
			<input id="qryNum" class="easyui-textbox" style="height: 27px; width: 160px;">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryGroup()">查询</a>
		</div>
		<div>
			<a href="#" class="easyui-linkbutton" iconCls="icon-undo" onclick="$('#groupTable').treegrid('expandAll');">全部展开</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-redo" onclick="$('#groupTable').treegrid('collapseAll');">全部收起</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">修改</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-remove" onclick="delGroup()">删除</a>
		</div>
	</div>
	
	<!--新增弹窗-->
	<div id="addDialog" class="easyui-dialog" title="新增告警人" data-options="
			modal:true,
			closed:true,
			width:800,
			height:450,
			buttons: [{
					text:'提交',
					handler:function(){
						addAlarmGroup();
					}
				},{
					text:'取消',
					handler:function(){
						$('#addDialog').dialog('close');
					}
				}]">
		<div class="mar-8">
			<div class="mar-b15">
				<form id="addForm">
					<span><span style="color:red;">*</span>群组ID:</span>
					<input id="addGroupId" name="addGroupId" class="easyui-textbox" missingMessage="群组ID为必填项" data-options="required:true" style="width:150px;height:32px;">
					<span style="margin-left:10px;"><span style="color:red;">*</span>群组名称:</span>
					<input id="addGroupName" name="addGroupName" class="easyui-textbox" missingMessage="群组名称为必填项" data-options="required:true" style="width:200px;height:32px;">
					<span style="margin-left:10px;"><span style="color:red;">*</span>类型:</span>
					<select id="addGroupType" name="addGroupType" class="easyui-combobox" missingMessage="类型为必选项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:150px;height:32px;">
						<option value="SMS">SMS</option>
						<option value="EMAIL">EMAIL</option>
					</select>
				</form>
			</div>
			<table id="addUserTable" class="easyui-datagrid" style="height:300px;width:760px;"
		    data-options="singleSelect:false,rownumbers:true">
			    <thead>
					<tr>
						<th data-options="field:'id',checkbox:true"></th>
						<th data-options="field:'user_name',width:210">告警人名称</th>
						<th data-options="field:'acc_nbr',width:210">电话</th>
						<th data-options="field:'user_remark',width:250">备注</th>
					</tr>
			    </thead>
			</table>
		</div>
	</div>
	<!--新增弹窗结束-->
	
	<!--编辑弹窗-->
	<div id="editDialog" class="easyui-dialog" title="修改告警群组" data-options="
			modal:true,
			closed:true,
			width:800,
			height:450,
			buttons: [{
					text:'增加告警人',
					handler:function(){
						addGroupUser();
					}
				},{
					text:'删除告警人',
					handler:function(){
						delGroupUser();
					}
				},{
					text:'提交',
					handler:function(){
						editAlarmGroup();
					}
				},{
					text:'取消',
					handler:function(){
						$('#editDialog').dialog('close');
					}
				}]">
		<div class="mar-8">
			<div class="mar-b15">
				<form id="editForm">
					<span><span style="color:red;">*</span>群组ID:</span>
					<input id="groupId" name="groupId" class="easyui-textbox" missingMessage="群组ID为必填项" data-options="required:true" style="width:150px;height:32px;">
					<span style="margin-left:10px;"><span style="color:red;">*</span>群组名称:</span>
					<input id="groupName" name="groupName" class="easyui-textbox" missingMessage="群组名称为必填项" data-options="required:true" style="width:200px;height:32px;">
					<span style="margin-left:10px;"><span style="color:red;">*</span>类型:</span>
					<select id="groupType" name="type" class="easyui-combobox" missingMessage="类型为必选项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:150px;height:32px;">
						<option value="SMS">SMS</option>
						<option value="EMAIL">EMAIL</option>
					</select>
				</form>
			</div>
			
			<table id="groupUserTable" class="easyui-datagrid" style="height:300px;width:760px;"
		    data-options="singleSelect:false,rownumbers:true">
			    <thead>
					<tr>
						<th data-options="field:'id',checkbox:true"></th>
						<th data-options="field:'user_name',width:210">告警人名称</th>
						<th data-options="field:'acc_nbr',width:210">电话</th>
						<th data-options="field:'user_remark',width:250">备注</th>
					</tr>
			    </thead>
			</table>
		</div>
	</div>
	<!--编辑弹窗结束-->
	
	<!--告警用户选择框-->
	<div id="userDialog" class="easyui-dialog" title="用户选择" data-options="
			modal:true,
			closed:true,
			width:500,
			height:430,
			buttons: [{
					text:'确定',
					handler:function(){
						userSelect();
					}
				},{
					text:'取消',
					handler:function(){
						$('#userDialog').dialog('close');
					}
				}]">
		<table id="userTable" class="easyui-datagrid" style="height:auto;"
		    data-options="fit:true,fitColumns:true,singleSelect:false, rownumbers:true,toolbar:'#userTb'">
		    <thead>
				<tr>
					<th data-options="field:'id',checkbox:true"></th>
						<th data-options="field:'user_name',width:210">告警人名称</th>
						<th data-options="field:'acc_nbr',width:210">电话</th>
						<th data-options="field:'user_remark',width:250">备注</th>
				</tr>
		    </thead>
		</table>
	</div>
	
	<div id="userTb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>用户名</span>
			<input id="qryUserName" style="width: 120px;">
			<span>手机号</span>
			<input id="qryUserNum" style="width: 120px;">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryUser()">查询</a>
		</div>
	</div>
	<!--告警用户选择框结束-->
</body>
</html>