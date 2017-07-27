<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>指标管理</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>

function openAddDialog(){
	clearFormValue();
	enableIdRelInput();
	$('#zbDialog').panel({title: "新增指标"});
	$('#zbDialog').dialog('open');
}

function enableIdRelInput(){
	$('#cycle').combobox({disabled: false});
	$('#boiCode').textbox('textbox').attr('disabled',false);
}

function clearFormValue(){
	$('#zbCode').val('');
	$('#cycle').combobox('setValue','daily');
	$('#boiCode').textbox('setValue','');
	$('#zbName').textbox('setValue','');
	$('#remark').textbox('setValue','');
	$('#zbType').combobox('setValue','一经');
	$('#depends').textbox('setValue','');
	$('#zbDef').textbox('setValue','');
	$('#status').combobox('setValue','0');
	$('#onlineDate').textbox('setValue','');
	$('#offlineDate').textbox('setValue','2999-12-31');
	$('#expectEndDay').textbox('setValue','');
	$('#expectEndTime').textbox('setValue','');
	$('#priority').textbox('setValue','99');
	$('#creater').textbox('setValue','${userId}');
	$('#developer').textbox('setValue','');
	$('#manager').textbox('setValue','');
}

function openEditDialog(){
	var rows = $('#zbTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条指标信息','info');
		return;
	}
	setFormValue(rows[0]);
	disableIdRelInput();
	$('#zbDialog').panel({title: "修改指标"});
	$('#zbDialog').dialog('open');
}

function disableIdRelInput(){
	$('#cycle').combobox({disabled: true});
	$('#boiCode').textbox('textbox').attr('disabled',true);
}

function setFormValue(data){
	$('#zbCode').val(data.zb_code);
	$('#cycle').combobox('setValue',data.cycle);
	$('#boiCode').textbox('setValue',data.boi_code);
	$('#zbName').textbox('setValue',data.zb_name);
	$('#remark').textbox('setValue',data.remark);
	$('#zbType').combobox('setValue',data.zb_type);
	$('#depends').textbox('setValue',data.depends);
	$('#zbDef').textbox('setValue',data.zb_def);
	$('#status').combobox('setValue',data.status);
	$('#onlineDate').textbox('setValue',data.online_date);
	$('#offlineDate').textbox('setValue',data.offline_date);
	$('#expectEndDay').textbox('setValue',data.expect_end_day);
	$('#expectEndTime').textbox('setValue',data.expect_end_time);
	$('#priority').textbox('setValue',data.priority);
	$('#creater').textbox('setValue',data.creater);
	$('#developer').textbox('setValue',data.developer);
	$('#manager').textbox('setValue',data.manager);
}

function delZb(){
	var rows = $('#zbTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条指标信息','info');
		return;
	}
	
	$.messager.confirm('提示', '您确定要删除此条指标吗?', function(r){
		if (r){
			$.ajax({
				type: "POST"
				,url: "${mvcPath}/zb/deleteZbDef"
				,data: {
					zbCode: rows[0].zb_code
				}
				,dataType : "json"
				,success: function(data){
					var wind = $.messager.alert('提示','删除成功','info');
					wind.window({onBeforeClose:function(){
						window.location.reload();
					}});
				}
			});
		}
	});
}

function checkZbInput(){
	var boiCode = $('#boiCode').textbox('getValue').trim();
	if(boiCode.length == 0){
		$.messager.alert('提示','请输入一经接口号','info');
		return false;
	}
	
	if(boiCode.length != 5){
		$.messager.alert('提示','一经接口号必须为5位字符','info');
		return false;
	}
	
	var zbName = $('#zbName').textbox('getValue').trim();
	if(zbName.length == 0){
		$.messager.alert('提示','请输入指标名称','info');
		return false;
	}
	
	var remark = $('#remark').textbox('getValue').trim();
	if(remark.length == 0){
		$.messager.alert('提示','请输入指标描述','info');
		return false;
	}
	
	var depends = $('#depends').textbox('getValue').trim();
	if(depends.length == 0){
		$.messager.alert('提示','请输入依赖程序','info');
		return false;
	}
	
	var zbDef = $('#zbDef').textbox('getValue').trim();
	if(zbDef.length == 0){
		$.messager.alert('提示','请输入指标sql','info');
		return false;
	}
	
	var onlineDate = $('#onlineDate').textbox('getValue').trim();
	if(onlineDate.length == 0){
		$.messager.alert('提示','请输入上线日期','info');
		return false;
	}
	
	var offlineDate = $('#offlineDate').textbox('getValue').trim();
	if(offlineDate.length == 0){
		$.messager.alert('提示','请输入下线日期','info');
		return false;
	}
	
	var expectEndDay = $('#expectEndDay').textbox('getValue').trim();
	if(expectEndDay.length == 0){
		$.messager.alert('提示','请输入预期完成日期','info');
		return false;
	}
	
	var expectEndTime = $('#expectEndTime').textbox('getValue').trim();
	if(expectEndTime.length == 0){
		$.messager.alert('提示','请输入预期完成时间','info');
		return false;
	}
	
	var priority = $('#priority').textbox('getValue').trim();
	if(priority.length == 0){
		$.messager.alert('提示','请输入优先级','info');
		return false;
	}
}

function cycleReplace(value){
	if(value == "daily"){
		return "日";
	}
	if(value == "monthly"){
		return "月";
	}
	return value;
}

function statusReplace(value){
	if(value == "0"){
		return "开发";
	}
	if(value == "1"){
		return "上线";
	}
	return value;
}

function queryZb(){
	var zbType = $("#qryZbType").val().trim();
	var zbCycle = $("#qryCycle").val().trim();
	var status = $("#qryStatus").val().trim();
	var zbName = $("#qryZbName").val().trim();
	var zbCode = $("#qryZbCode").val().trim();
	
	$("#zbTable").datagrid("load", {
		zbType : zbType,
		zbCycle : zbCycle,
		status : status,
		zbName : zbName,
		zbCode : zbCode
	});
}

</script>
</head>
<body>
	<table id="zbTable" class="easyui-datagrid" title="指标信息" style="height:auto;"
			data-options="fit:true, fitColumns : true, striped:true, pagination : true, pageSize : 10, pageList : [10, 20, 30, 50],
				rownumbers:true, singleSelect:true, checkOnSelect : false,
				url:'${mvcPath}/zb/getZbList',toolbar:'#tb'">
		<thead>
			<tr>
				<!--<th field="itemId" checkbox="true"></th>-->
				<th data-options="field:'zb_type',width:60">类型</th>
				<th data-options="field:'cycle',width:60,formatter:cycleReplace">周期</th>
				<th data-options="field:'boi_code',width:80,hidden:'true'">一经接口号</th>
				<th data-options="field:'zb_code',width:80">编码</th>
				<th data-options="field:'zb_name',width:120">名称</th>
				<th data-options="field:'remark',width:180">描述</th>
				<th data-options="field:'depends',width:80,hidden:'true'">依赖程序</th>
				<th data-options="field:'zb_def',width:80,hidden:'true'">指标SQL</th>
				<th data-options="field:'status',width:60,formatter:statusReplace">状态</th>
				<th data-options="field:'online_date',width:100">上线日期</th>
				<th data-options="field:'offline_date',width:100">下线日期</th>
				<th data-options="field:'expect_end_day',width:80,hidden:'true'">预期完成日期</th>
				<th data-options="field:'expect_end_time',width:80,hidden:'true'">预期完成时间</th>
				<th data-options="field:'priority',width:80,hidden:'true'">优先级</th>
				<th data-options="field:'creater',width:80">创建人</th>
				<th data-options="field:'developer',width:80">开发人</th>
				<th data-options="field:'manager',width:80">当前责任人</th>
			</tr>
		</thead>
	</table>
	
	<div id="tb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>类型</span>
			<select id="qryZbType">
				<option value="">---请选择---</option>
				<option value="一经">一经</option>
				<option value="省内">省内</option>
			</select>
			<span>周期</span>
			<select id="qryCycle">
				<option value="">---请选择---</option>
				<option value="daily">日</option>
				<option value="monthly">月</option>
			</select>
			<span>状态</span>
			<select id="qryStatus">
				<option value="">---请选择---</option>
				<option value="0">开发</option>
				<option value="1">上线</option>
			</select>
			<span>指标名称</span>
			<input id="qryZbName">
			<span>指标编码</span>
			<input id="qryZbCode">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryZb()">查询</a>
		</div>
		<div>
			<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">修改</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-remove" onclick="delZb()">删除</a>
		</div>
	</div>
	
	<div id="zbDialog" class="easyui-dialog" title="新增指标" data-options="
			modal:true,
			closed:true,
			width:430,
			height:500,
			buttons: [{
					text:'提交',
					handler:function(){
						$('#zbDefForm').form('submit', {
							url: '${mvcPath}/zb/saveZbDef',
							onSubmit: function(param){
								return checkZbInput();
							},
							success:function(data){
								var wind = $.messager.alert('提示','提交成功','info');
								wind.window({onBeforeClose:function(){
									window.location.reload();
								}});
   							}
   							
						});
					}
				},{
					text:'取消',
					handler:function(){
						$('#zbDialog').dialog('close');
					}
				}]">
		<form id="zbDefForm">
			<input id="zbCode" name="zbCode" type="hidden">
			<div class="mar-8" style="height:100px;">
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标周期:</div>
					<select id="cycle" name="cycle" class="easyui-combobox form-inp" data-options="editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="daily">日</option>
						<option value="monthly">月</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>一经接口号:</div>
					<input id="boiCode" name="boiCode" class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标名称:</div>
					<input id="zbName" name="zbName" class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标描述:</div>
					<input id="remark" name="remark" class="easyui-textbox form-inp" data-options="multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标类型:</div>
					<select id="zbType" name="zbType" class="easyui-combobox form-inp" data-options="editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="一经">一经</option>
						<option value="省内">省内</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>依赖程序:</div>
					<input id="depends" name="depends" class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标sql:</div>
					<input id="zbDef" name="zbDef" class="easyui-textbox form-inp" data-options="multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>状态:</div>
					<select id="status" name="status" class="easyui-combobox form-inp" data-options="editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="0">开发</option>
						<option value="1">上线</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>上线日期:</div>
					<input id="onlineDate" name="onlineDate" editable="false" class="easyui-datebox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>下线日期:</div>
					<input id="offlineDate" name="offlineDate" editable="false" class="easyui-datebox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>预期完成日期:</div>
					<input id="expectEndDay" name="expectEndDay" class="easyui-numberbox form-inp" 
						data-options="min:0,max:31,prompt:'0表示每日,1-31表示1-31日'" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>预期完成时间:</div>
					<input id="expectEndTime" name="expectEndTime" class="easyui-numberbox form-inp" 
						data-options="min:0,max:24,precision:2,decimalSeparator:'.',prompt:'例：8.5表示8点半'" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>优先级:</div>
					<input id="priority" name="priority" class="easyui-numberbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">创建人:</div>
					<input id="creater" name="creater" disabled class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">开发人:</div>
					<input id="developer" name="developer" class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">当前责任人:</div>
					<input id="manager" name="manager" class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
			</div>
		</form>
	</div>
</body>
</html>