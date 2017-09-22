<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8"></meta>
<title>接口时限告警</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>

function openAddDialog(){
	$("#chkId").val("");
	$('#monitorForm').form('clear');
	$('#monitorDialog').panel({title: "新增告警信息"});
	$("#monitorDialog").dialog("open");
}

function openEditDialog(){
	var rows = $('#monitorTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条配置信息','info');
		return;
	}
	$("#chkId").val(rows[0].chkid);
	setFormValue(rows[0]);
	$('#monitorDialog').panel({title: "修改告警信息"});
	$("#monitorDialog").dialog("open");
}

function setFormValue(item){
	$("#name").textbox("setValue", item.name);
	$("#type").combobox("setValue", item.type);
	$("#groupId").combobox("setValues", item.group_id.split(';'));
	$("#accNbr").textbox("setValue", item.acc_nbr);
	$("#cycle").combobox("setValue", item.cycle);
	$("#warnInterval").textbox("setValue", item.warn_interval);
	$("#sqlDef").textbox("setValue", item.sql_def);
}

function queryMonitor(){
	var name = $("#qryName").val().trim();
	var cycle = $("#qryCycle").val().trim();
	
	$("#monitorTable").datagrid("load", {
		name : name,
		cycle : cycle
	});
}

function viewLog(){
	var rows = $('#monitorTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条告警信息','info');
		return;
	}
	
	var options = $('#logTable').datagrid('options');
    options.url = '${mvcPath}/monitor/getLogList';
    options.queryParams = {
		chkId: rows[0].chkid
	};
    $('#logTable').datagrid(options);
    $("#logContainer").window('open');
}

function formatStatus(value){
	if(value == "0"){
		return "待发送";
	}
	if(value == "1"){
		return "已发送";
	}
	if(value == "-1"){
		return "发送失败";
	}
	
	return value;
}
</script>
</head>
<body>
	<table id="monitorTable" class="easyui-datagrid" style="height:auto;" title="告警信息"
			data-options="fit:true, fitColumns : true, striped:true, pagination : true, pageSize : 10, pageList : [10, 20, 30, 50],
				rownumbers:true, singleSelect:true, checkOnSelect : false,
				url:'${mvcPath}/monitor/getMonitorList',toolbar:'#tb'">
		<thead>
			<tr>
				<!--<th field="id" checkbox="true"></th>-->
				<th data-options="field:'chkid',width:100,hidden:'true'">ID</th>
				<th data-options="field:'name',width:100,">名称</th>
				<th data-options="field:'type',width:60">类型</th>
				<th data-options="field:'group_id',width:60,hidden:'true'">群组ID</th>
				<th data-options="field:'acc_nbr',width:60,hidden:'true'">手机号</th>
				<th data-options="field:'cycle',width:60">间隔类型</th>
				<th data-options="field:'warn_interval',width:60,">间隔</th>
				<th data-options="field:'err_times',width:60,">错误次数</th>
				<th data-options="field:'sql_def',width:60,">sql</th>
				<th data-options="field:'create_date',width:100,">创建时间</th>
				<th data-options="field:'next_time',width:100,">下次告警时间</th>
			</tr>
		</thead>
	</table>
	
	<div id="tb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>名称</span>
			<input id="qryName" class="easyui-textbox" style="height: 27px; width: 160px;">
			<span>间隔类型</span>
			<input id="qryCycle" class="easyui-textbox" style="height: 27px; width: 160px;">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryUser()">查询</a>
		</div>
		<div>
			<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">修改</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-tip" onclick="viewLog()">查看日志</a>
		</div>
	</div>
	
	<!--告警配置弹窗开始-->
	<div id="monitorDialog" class="easyui-dialog" title="告警配置编辑" data-options="
			modal:true,
			closed:true,
			width:480,
			height:500,
			buttons: [{
					text:'提交',
					handler:function(){
						$('#monitorForm').form('submit', {
							url: '${mvcPath}/monitor/saveMonitor',
							onSubmit: function(param){
								return $(this).form('enableValidation').form('validate');
							},
							success:function(data){
								var wind = $.messager.alert('提示','提交成功','info');
								wind.window({onBeforeClose:function(){
									queryMonitor();
									$('#monitorDialog').dialog('close');
								}});
   							}
   							
						});
					}
				},{
					text:'取消',
					handler:function(){
						$('#monitorDialog').dialog('close');
					}
				}]">
		<div class="mar-8">
			<form id="monitorForm">
				<input id="chkId" name="chkId" type="hidden">
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>名称:</div>
					<input id="name" name="name" class="easyui-textbox" missingMessage="名称为必填项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>类型:</div>
					<select id="type" name="type" class="easyui-combobox form-inp" missingMessage="类型为必选项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="BOI">BOI</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab">群组:</div>
					<input id="groupId" name="groupId" class="easyui-combobox" style="width:75%;height:32px;" 
							data-options="
								url:'${mvcPath}/monitor/getGroupList',
								method:'get',
								valueField:'id',
								textField:'name',
								multiple:true,
								separator: ';'
						">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">手机号:</div>
					<input id="accNbr" name="accNbr" class="easyui-textbox" data-options="prompt:'多个手机号用;分割',multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>间隔类型:</div>
					<select id="cycle" name="cycle" class="easyui-combobox form-inp" missingMessage="间隔类型为必选项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="month">month</option>
						<option value="day">day</option>
						<option value="minute">minute</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>间隔:</div>
					<input id="warnInterval" name="warnInterval" class="easyui-numberbox" missingMessage="间隔为必填项" data-options="required:true," style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>SQL:</div>
					<input id="sqlDef" name="sqlDef" class="easyui-textbox" missingMessage="SQL为必填项" data-options="required:true,multiline:true" style="width:75%;height:60px;">
				</div>
			</form>
		</div>
	</div>
	<!--告警配置弹窗开始-->
	
	<!--查看日志开始-->
	<div id="logContainer" title="日志查看" class="easyui-window" 
		data-options="modal:true, closed:true,width: 800, height:450">
		<table id="logTable" class="easyui-datagrid" style="height:auto;"
		    data-options="fit:true,fitColumns:true,pagination : false,singleSelect:true,rownumbers:true,nowrap:false,">
		    <thead>
				<tr>
					<th data-options="field:'group_id',width:100">群组ID</th>
					<th data-options="field:'arr_nbr',width:120">手机号</th>
					<th data-options="field:'msg',width:180">信息</th>
					<th data-options="field:'status',width:60,formatter:formatStatus">状态</th>
					<th data-options="field:'create_time',width:80">创建时间</th>
					<th data-options="field:'update_time',width:80">更新时间</th>
				</tr>
		    </thead>
		</table>
	</div>
	<!--查看日志结束-->
</body>
</html>