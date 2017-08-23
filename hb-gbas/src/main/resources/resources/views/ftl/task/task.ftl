<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>任务运行概况</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>

function viewExecCondition(){
	var rows = $('#runTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条任务信息','info');
		return;
	}
	var url = '${mvcPath}/task/execCondition?gbasCode=' + rows[0].gbas_code;
	var content = '<iframe scrolling="auto" frameborder="0"  src="'+url+'" style="width:880px;height:460px;"></iframe>';
	$("#dataSvg").html(content);
	$('#execCond').window({
		title: '执行条件',
	    width:900,
	    height:500,
	    modal:true
	});
}

function viewDependCondition(){
	alert(111);
}

function formatCycle(value){
	if(value == "daily"){
		return "日";
	}
	if(value == "monthly"){
		return "月";
	}
	return value;
}

function formatStatus(value){
	if(value == "0"){
		return "等待";
	}
	if(value == "1"){
		return "强制开始执行";
	}
	if(value == "2"){
		return "数据依赖已满足";
	}
	if(value == "3"){
		return "开始执行指标计算";
	}
	if(value == "4"){
		return "指标计算完成";
	}
	if(value == "5"){
		return "强规则稽核失败";
	}
	if(value == "6"){
		return "完成";
	}
	return value;
}

function formatType(value){
	if(value == "zb"){
		return "指标";
	}
	if(value == "rule"){
		return "规则";
	}
	if(value == "export"){
		return "接口";
	}
	return value;
}

function queryTask(){
	var type = $("#qryType").combobox("getValue").trim();
	var cycle = $("#qryCycle").combobox("getValue").trim();
	var status = $("#qryStatus").combobox("getValue").trim();
	var name = $("#qryName").textbox("getValue").trim();
	
	$("#runTable").datagrid("load", {
		type : type,
		cycle : cycle,
		status : status,
		name : name
	});
}

</script>
</head>
<body>
	<table id="runTable" class="easyui-datagrid" title="任务运行概况" style="height:auto;"
			data-options="fit:true, fitColumns : true, striped:true, pagination : true, pageSize : 10, pageList : [10, 20, 30, 50],
				rownumbers:true, singleSelect:true, checkOnSelect : false,
				url:'${mvcPath}/task/getTaskList',toolbar:'#tb'">
		<thead>
			<tr>
				<!--<th field="itemId" checkbox="true"></th>-->
				<th data-options="field:'type',width:50,formatter:formatType">类型</th>
				<th data-options="field:'gbas_code',width:60">程序名称</th>
				<th data-options="field:'cycle',width:40,formatter:formatCycle">周期</th>
				<th data-options="field:'etl_cycle_id',width:60">批次号</th>
				<th data-options="field:'etl_status',width:70,formatter:formatStatus">状态</th>
				<th data-options="field:'dispatch_time',width:100">发布时间</th>
				<th data-options="field:'exec_start_time',width:100">开始执行时间</th>
				<th data-options="field:'exec_end_time',width:100">执行结束时间</th>
			</tr>
		</thead>
	</table>
	
	<div id="tb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>类型</span>
			<select id="qryType" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="height: 27px; width: 100px;">
				<option value="">---请选择---</option>
				<option value="zb">指标</option>
				<option value="rule">规则</option>
				<option value="export">接口</option>
			</select>
			<span>周期</span>
			<select id="qryCycle" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="height: 27px; width: 100px;">
				<option value="">---请选择---</option>
				<option value="daily">日</option>
				<option value="monthly">月</option>
			</select>
			<span>状态</span>
			<select id="qryStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="height: 27px; width: 100px;">
				<option value="">---请选择---</option>
				<option value="0">等待</option>
				<option value="1">开始执行</option>
			</select>
			<span>程序名称</span>
			<input id="qryName" class="easyui-textbox" style="height: 27px; width: 160px;">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryTask()">查询</a>
		</div>
		<div>
			<a href="#" class="easyui-linkbutton" iconCls="icon-branch" onclick="viewExecCondition()">查看执行条件</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-list" onclick="viewDependCondition()">查看依赖条件</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-tip" onclick="viewLog()">查看日志</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-do" onclick="run()">强制执行</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="stop()">强制停止</a>
		</div>
	</div>
	
	<div id="execCond">
		<div id="dataSvg"></div>
	</div>
</body>
</html>