<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>规则管理</title>
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
	$('#ruleDialog').panel({title: "新增规则"});
	$('#ruleDialog').dialog('open');
}

function enableIdRelInput(){
	$('#cycle').combobox({disabled: false});
	$('#boiCode').textbox('textbox').attr('disabled',false);
}

function clearFormValue(){
	$('#ruleCode').val('');
	$('#cycle').combobox('setValue','daily');
	$('#boiCode').textbox('setValue','');
	$('#ruleName').textbox('setValue','');
	$('#remark').textbox('setValue','');
	$('#ruleType').combobox('setValue','0');
	$('#compOper').textbox('setValue','');
	$('#val').textbox('setValue','');
	$('#procDepend').textbox('setValue','');
	$('#gbasDepend').textbox('setValue','');
	$('#ruleDef').textbox('setValue','');
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
	var rows = $('#ruleTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条规则信息','info');
		return;
	}
	setFormValue(rows[0]);
	disableIdRelInput();
	$('#ruleDialog').panel({title: "修改规则"});
	$('#ruleDialog').dialog('open');
}

function disableIdRelInput(){
	$('#cycle').combobox({disabled: true});
	$('#boiCode').textbox('textbox').attr('disabled',true);
}

function setFormValue(data){
	$('#ruleCode').val(data.rule_code);
	$('#cycle').combobox('setValue',data.cycle);
	$('#boiCode').textbox('setValue',data.boi_code);
	$('#ruleName').textbox('setValue',data.rule_name);
	$('#remark').textbox('setValue',data.remark);
	$('#ruleType').combobox('setValue',data.rule_type);
	$('#compOper').textbox('setValue',data.comp_oper);
	$('#val').textbox('setValue',data.val);
	$('#procDepend').textbox('setValue',data.proc_depend);
	$('#gbasDepend').textbox('setValue',data.gbas_depend);
	$('#ruleDef').textbox('setValue',data.rule_def);
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

function delRule(){
	var rows = $('#ruleTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条规则信息','info');
		return;
	}
	
	$.messager.confirm('提示', '您确定要删除此条规则吗?', function(r){
		if (r){
			$.ajax({
				type: "POST"
				,url: "${mvcPath}/rule/deleteRuleDef"
				,data: {
					ruleCode: rows[0].rule_code
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

function checkRuleInput(){
	var boiCode = $('#boiCode').textbox('getValue').trim();
	if(boiCode.length == 0){
		$.messager.alert('提示','请输入一经接口号','info');
		return false;
	}
	
	if(boiCode.length != 5){
		$.messager.alert('提示','一经接口号必须为5位字符','info');
		return false;
	}
	
	var ruleName = $('#ruleName').textbox('getValue').trim();
	if(ruleName.length == 0){
		$.messager.alert('提示','请输入规则名称','info');
		return false;
	}
	
	var remark = $('#remark').textbox('getValue').trim();
	if(remark.length == 0){
		$.messager.alert('提示','请输入规则描述','info');
		return false;
	}
	
	var procDepend = $('#procDepend').textbox('getValue').trim();
	if(procDepend.length == 0){
		$.messager.alert('提示','请输入依赖程序','info');
		return false;
	}
	
	var gbasDepend = $('#gbasDepend').textbox('getValue').trim();
	if(gbasDepend.length == 0){
		$.messager.alert('提示','请输入依赖的gbas指标,规则,接口','info');
		return false;
	}
	
	var ruleDef = $('#ruleDef').textbox('getValue').trim();
	if(ruleDef.length == 0){
		$.messager.alert('提示','请输入规则sql','info');
		return false;
	}
	
	var compOper = $('#compOper').textbox('getValue').trim();
	if(compOper.length == 0){
		$.messager.alert('提示','请输入比较运算符','info');
		return false;
	}
	
	var val = $('#val').textbox('getValue').trim();
	if(val.length == 0){
		$.messager.alert('提示','请输入阈值','info');
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
	
	return true;
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

function typeReplace(value){
	if(value == "0"){
		return "弱规则";
	}
	if(value == "1"){
		return "强规则";
	}
	return value;
}

function queryRule(){
	var ruleType = $("#qryRuleType").val().trim();
	var ruleCycle = $("#qryCycle").val().trim();
	var status = $("#qryStatus").val().trim();
	var ruleName = $("#qryRuleName").val().trim();
	var ruleCode = $("#qryRuleCode").val().trim();
	
	$("#ruleTable").datagrid("load", {
		ruleType : ruleType,
		ruleCycle : ruleCycle,
		status : status,
		ruleName : ruleName,
		ruleCode : ruleCode
	});
}

</script>
</head>
<body>
	<table id="ruleTable" class="easyui-datagrid" title="规则信息" style="height:auto;"
			data-options="fit:true, fitColumns : true, striped:true, pagination : true, pageSize : 10, pageList : [10, 20, 30, 50],
				rownumbers:true, singleSelect:true, checkOnSelect : false,
				url:'${mvcPath}/rule/getRuleList',toolbar:'#tb'">
		<thead>
			<tr>
				<!--<th field="itemId" checkbox="true"></th>-->
				<th data-options="field:'rule_type',width:60,formatter:typeReplace">类型</th>
				<th data-options="field:'cycle',width:60,formatter:cycleReplace">周期</th>
				<th data-options="field:'boi_code',width:80,hidden:'true'">一经接口号</th>
				<th data-options="field:'rule_code',width:110">编码</th>
				<th data-options="field:'rule_name',width:130">名称</th>
				<th data-options="field:'remark',width:180">描述</th>
				<th data-options="field:'proc_depend',width:80,hidden:'true'">依赖程序</th>
				<th data-options="field:'gbas_depend',width:80,hidden:'true'">依赖的gbas指标,规则,接口</th>
				<th data-options="field:'rule_def',width:80,hidden:'true'">规则SQL</th>
				<th data-options="field:'comp_oper',width:100">比较运算符</th>
				<th data-options="field:'val',width:100">阈值</th>
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
			<select id="qryRuleType">
				<option value="">---请选择---</option>
				<option value="0">弱规则</option>
				<option value="1">强规则</option>
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
			<span>规则名称</span>
			<input id="qryRuleName">
			<span>规则编码</span>
			<input id="qryRuleCode">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryRule()">查询</a>
		</div>
		<div>
			<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">修改</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-remove" onclick="delRule()">删除</a>
		</div>
	</div>
	
	<div id="ruleDialog" class="easyui-dialog" title="新增规则" data-options="
			modal:true,
			closed:true,
			width:430,
			height:500,
			buttons: [{
					text:'提交',
					handler:function(){
						$('#ruleDefForm').form('submit', {
							url: '${mvcPath}/rule/saveRuleDef',
							onSubmit: function(param){
								return checkRuleInput();
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
						$('#ruleDialog').dialog('close');
					}
				}]">
		<form id="ruleDefForm">
			<input id="ruleCode" name="ruleCode" type="hidden">
			<div class="mar-8" style="height:100px;">
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>规则周期:</div>
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
					<div class="inp-lab"><span style="color:red;">*</span>规则名称:</div>
					<input id="ruleName" name="ruleName" class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>规则描述:</div>
					<input id="remark" name="remark" class="easyui-textbox form-inp" data-options="multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>规则类型:</div>
					<select id="ruleType" name="ruleType" class="easyui-combobox form-inp" data-options="editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="0">弱规则</option>
						<option value="1">强规则</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>依赖程序:</div>
					<input id="procDepend" name="procDepend" class="easyui-textbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="fl" style="height: 32px;line-height: 32px; width:42%;"><span style="color:red;">*</span>依赖的gbas指标,规则,接口:</div>
					<input id="gbasDepend" name="gbasDepend" class="easyui-textbox form-inp" data-options="prompt:'多个依赖用;分割'" style="height:32px; width:57%;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>规则sql:</div>
					<input id="ruleDef" name="ruleDef" class="easyui-textbox form-inp" data-options="multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>比较运算符:</div>
					<select id="compOper" name="compOper" class="easyui-combobox form-inp" data-options="editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="&gt;">&gt;</option>
						<option value="&lt;">&lt;</option>
						<option value="&gt;=">&gt;=</option>
						<option value="&lt;=">&lt;=</option>
						<option value="==">==</option>
						<option value="!=">!=</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>阈值:</div>
					<input id="val" name="val" class="easyui-numberbox form-inp" 
						data-options="precision:2,decimalSeparator:'.'" style="width:75%;height:32px;">
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