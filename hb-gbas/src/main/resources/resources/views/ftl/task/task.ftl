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
<script src="${mvcPath}/resources/js/common.js"></script>
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
	var rows = $('#runTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条任务信息','info');
		return;
	}
	
	var options = $('#statusTable').datagrid('options');
    options.url = '${mvcPath}/task/getDepsProcStatus';
    options.queryParams = {
		etlCycle: rows[0].etl_cycle_id,
		gbasCode: rows[0].gbas_code
		
	};
    $('#statusTable').datagrid(options);
    $("#statusContainer").window('open');
}

function viewLog(){
	var rows = $('#runTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条任务信息','info');
		return;
	}
	
	var options = $('#logTable').datagrid('options');
    options.url = '${mvcPath}/task/getLog';
    options.queryParams = {
		id: rows[0].id
	};
    $('#logTable').datagrid(options);
    $("#logContainer").window('open');
}

function updateStatus(status, content){
	var rows = $('#runTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条任务信息','info');
		return;
	}
	
	$.messager.confirm('提示', '您确定要' + content + '吗?', function(r){
		if (r){
			$.ajax({
				type: "POST"
				,url: "${mvcPath}/task/updateStatus"
				,data: {
					id: rows[0].id,
					status: status
				}
				,dataType : "json"
				,success: function(data){
					var wind = $.messager.alert('提示', content + '申请提交成功','info');
					wind.window({onBeforeClose:function(){
						queryTask();
					}});
				}
			});
		}
	});
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

function formatStatusIcon(value){
	if(value == 3){
		return "<span><img src='${mvcPath}/resources/images/ok.png'></img></span>";
	}
	return "<span><img src='${mvcPath}/resources/images/cancel.png'></img></span>";
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
				<th data-options="field:'id',width:50,hidden: true,">类型</th>
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
				<option value="1">强制开始执行</option>
				<option value="2">数据依赖已满足</option>
				<option value="3">开始执行指标计算</option>
				<option value="4">指标计算完成</option>
				<option value="5">强规则稽核失败</option>
				<option value="6">完成</option>
			</select>
			<span>程序名称</span>
			<input id="qryName" class="easyui-textbox" style="height: 27px; width: 160px;">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryTask()">查询</a>
		</div>
		<div>
			<a href="#" class="easyui-linkbutton" iconCls="icon-branch" onclick="viewExecCondition()">查看执行条件</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-list" onclick="viewDependCondition()">查看依赖条件</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-tip" onclick="viewLog()">查看日志</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-do" onclick="updateStatus('1', '强制执行')">强制执行</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-redo" onclick="updateStatus('0', '重新执行')">重新执行</a>
		</div>
	</div>
	
	<div id="execCond">
		<div id="dataSvg"></div>
	</div>
	
	<!--查看日志开始-->
	<div id="logContainer" title="日志查看" class="easyui-window" 
		data-options="modal:true, closed:true,width: 700, height:450">
		<table id="logTable" class="easyui-datagrid" style="height:auto;"
		    data-options="fit:true,fitColumns:true,pagination : false,singleSelect:true,rownumbers:true,nowrap:false,">
		    <thead>
				<tr>
					<th data-options="field:'err_time',width:30">报错时间</th>
					<th data-options="field:'err_msg',width:100">报错信息</th>
				</tr>
		    </thead>
		</table>
	</div>
	<!--查看日志结束-->
	
	<!--查看依赖条件开始-->
	<div id="statusContainer" title="依赖条件" class="easyui-window" 
		data-options="modal:true, closed:true,width: 500, height:450">
		<table id="statusTable" class="easyui-datagrid" style="height:auto;"
		    data-options="fit:true,fitColumns:true,pagination : false,singleSelect:true,rownumbers:true,">
		    <thead>
				<tr>
					<th data-options="field:'proc',width:40">名称</th>
					<th data-options="field:'status',width:20, formatter:formatStatusIcon,align:'center'">检测通过</th>
				</tr>
		    </thead>
		</table>
	</div>
	<!--查看依赖条件结束-->
	
</body>
</html>