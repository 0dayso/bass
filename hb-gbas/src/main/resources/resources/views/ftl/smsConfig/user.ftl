<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
<title>短信告警人配置</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>

function openAddDialog(){
	$("#alarmId").val("");
	$('#userForm').form('clear');
	$('#userDialog').panel({title: "新增告警人"});
	$("#userDialog").dialog("open");
}

function openEditDialog(){
	var rows = $('#userTable').datagrid('getChecked');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条数据','info');
		return;
	}
	$("#alarmId").val(rows[0].id);
	setFormValue(rows[0]);
	$('#userDialog').panel({title: "修改告警人"});
	$("#userDialog").dialog("open");
}

function setFormValue(item){
	$("#userName").textbox("setValue", item.user_name);
	$("#accNbr").textbox("setValue", item.acc_nbr);
	$("#userRemark").textbox("setValue", item.user_remark);
}

function saveAlarmUser(){
	var checkFlag = $("#userForm").form('enableValidation').form('validate');
	if(!checkFlag){
		return;
	}
	
	var userName = $("#userName").textbox("getValue").trim();
	if(userName.length == 0){
		$.messager.alert('提示','告警人姓名不能为空','info');
		return;
	}
	var accNbr = $("#accNbr").textbox("getValue").trim();
	if(accNbr.length != 11){
		$.messager.alert('提示','请输入11位手机号','info');
		return;
	}
	var userRemark = $("#userRemark").textbox("getValue").trim();
	if(userRemark.length == 0){
		$.messager.alert('提示','备注不能为空','info');
		return;
	}
	
	var alarmId = $("#alarmId").val();
	$.ajax({
		type: "post",
		url: '${mvcPath}/smsConfig/saveAlarmUser',
		data: {
			alarmId: alarmId,
			userName: userName,
			accNbr: accNbr,
			userRemark: userRemark
		},
		dataType : "json",
		success: function(data){
			if(data.flag == -1){
				$.messager.alert('错误', data.msg,'error');
				return false;
			}
			var wind = $.messager.alert('提示','提交成功','info');
			wind.window({onBeforeClose:function(){
				$("#userDialog").dialog("close");
				queryUser();
			}});
		}
	});
}

function delUser(){
	var rows = $('#userTable').datagrid('getChecked');
	if(rows.length == 0){
		$.messager.alert('提示','请至少选择一条告警人信息','info');
		return;
	}
	
	$.messager.confirm('提示', '您确定要删除所选告警人吗?', function(r){
		if (r){
			var ids = new Array();
			for(var i=0; i<rows.length; i++){
				ids.push(rows[i].id);
			}
			$.ajax({
				type: "post",
				url: '${mvcPath}/smsConfig/delAlarmUser',
				data: {
					alarmsIds: ids.toString()
				},
				dataType : "json",
				success: function(data){
					if(data.flag == -1){
						$.messager.alert('错误', data.msg,'error');
						return false;
					}
					var wind = $.messager.alert('提示','删除成功','info');
					wind.window({onBeforeClose:function(){
						queryUser();
					}});
				}
			});
		}
	});
}

function queryUser(){
	var userName = $("#qryName").val().trim();
	var num = $("#qryNum").val().trim();
	
	$("#userTable").datagrid("load", {
		userName : userName,
		num : num
	});
}
</script>
</head>
<body>
	<table id="userTable" class="easyui-datagrid" style="height:auto;" title="告警人信息"
			data-options="fit:true, fitColumns : true, striped:true, pagination : true, pageSize : 10, pageList : [10, 20, 30, 50],
				rownumbers:true, singleSelect:false, checkOnSelect : false,
				url:'${mvcPath}/smsConfig/getAlarmUserList',toolbar:'#tb'">
		<thead>
			<tr>
				<th field="id" checkbox="true"></th>
				<th data-options="field:'user_name',width:60,">告警人姓名</th>
				<th data-options="field:'acc_nbr',width:60">手机号码</th>
				<th data-options="field:'user_remark',width:100,">备注</th>
			</tr>
		</thead>
	</table>
	
	<div id="tb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>告警人姓名</span>
			<input id="qryName" class="easyui-textbox" style="height: 27px; width: 160px;">
			<span>手机号</span>
			<input id="qryNum" class="easyui-textbox" style="height: 27px; width: 160px;">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryUser()">查询</a>
		</div>
		<div>
			<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">修改</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-remove" onclick="delUser()">删除</a>
		</div>
	</div>
	
	<div id="userDialog" class="easyui-dialog" title="新增告警人" data-options="
			modal:true,
			closed:true,
			width:400,
			height:260,
			buttons: [{
					text:'提交',
					handler:function(){
						saveAlarmUser();
					}
				},{
					text:'取消',
					handler:function(){
						$('#userDialog').dialog('close');
					}
				}]">
		<div class="mar-8">
			<form id="userForm">
				<input id="alarmId" name="alarmId" type="hidden">
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>告警人姓名:</div>
					<input id="userName" name="userName" class="easyui-textbox" missingMessage="告警人姓名为必填项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>手机号:</div>
					<input id="accNbr" name="accNbr" class="easyui-numberbox" missingMessage="电话为必填项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>备注:</div>
					<input id="userRemark" name="userRemark" class="easyui-textbox" missingMessage="备注为必填项" data-options="required:true,multiline:true" style="width:75%;height:60px;">
				</div>
			</form>
		</div>
	</div>
</body>
</html>