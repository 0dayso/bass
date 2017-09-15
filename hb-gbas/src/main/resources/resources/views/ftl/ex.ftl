<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>接口管理</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>
$(function(){
	$("input",$("#addExCode").next("span")).blur(function(){
	    checkExCode();  
	});
});

function checkExCode(){
	var exCode = $('#addExCode').textbox('getValue');
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/ex/checkExCode"
		,data: {
			exCode: exCode
		}
		,async:false
		,dataType : "json"
		,success: function(data){
			if(!data){
				var wind = $.messager.alert('提示','此接口编码已存在，请重新填入','info');
				wind.window({onBeforeClose:function(){
					$('#addExCode').textbox('setValue','');
				}});
			}
		}
	});
}

function openAddDialog(){
	$('#addExDialog').panel({title: "新增接口"});
	$('#addExCode').textbox('setValue','');
	$('#addExName').textbox('setValue','');
	$('#addDeveloperName').textbox('setValue','');
	$('#addDeveloperName').val('');
	$('#addExCode').textbox('textbox').attr('disabled',false);
	$("#optType").val("add");
	$('#addExDialog').dialog('open');
}

function openUpdateDevDialog(){
	var row = checkSelect();
	if(row == null){
		return;
	}
	$('#addExCode').textbox('setValue',row.ex_code);
	$('#addExName').textbox('setValue',row.ex_name);
	$('#addDeveloperName').textbox('setValue',row.developer_name);
	$('#addDeveloperName').val(row.developer);
	$('#addExCode').textbox('textbox').attr('disabled',true);
	
	$('#addExDialog').panel({title: "修改开发人"});
	$('#addExDialog').dialog('open');
	$("#optType").val("updateDev");
}

function saveEx(){
	var exCode = $('#addExCode').textbox('getValue').trim();
	if(exCode.length == 0){
		$.messager.alert('提示','接口编码不能为空','info');
		return;
	}
	var exName = $('#addExName').textbox('getValue').trim();
	if(exName.length == 0){
		$.messager.alert('提示','接口名称不能为空','info');
		return;
	}
	var developerName = $('#addDeveloperName').textbox('getValue');
	var developer = $('#addDeveloper').val();
	var optType = $("#optType").val();
	
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/ex/saveExDef"
		,data: {
			exCode: exCode,
			exName: exName,
			developerName: developerName,
			developer: developer,
			optType: optType
		}
		,dataType : "json"
		,success: function(data){
			var wind = $.messager.alert('提示','提交成功','info');
			wind.window({onBeforeClose:function(){
				queryEx();
				$('#addExDialog').dialog('close');
			}});
		}
	});
}

function enableIdRelInput(){
	//$('#cycle').combobox({disabled: false});
	$('#exCode').textbox('textbox').attr('disabled',false);
}

function clearFormValue(){
	$('#exDefForm').form('clear');
	$('#cycle').combobox('setValue','daily');
	$('#compOper').combobox('setValue','>');
	$('#dependType').combobox('setValue','1');
	$('#offlineDate').textbox('setValue','2999-12-31');
	$('#priority').textbox('setValue','99');
	$('#creater').val('${userId}');
	$('#createrName').textbox('setValue','${userName}');
}

function openEditDialog(){
	var row = checkSelect();
	if(row == null){
		return;
	}
	
	if(${isAdmin} != 1 && row.developer != '${userId}'){
		$.messager.alert('提示','您没有权限修改此接口','info');
		return;
	}

	setFormValue(row);
	disableIdRelInput();
	$("#optType").val("edit");
	$('#exDialog').panel({title: "修改接口"});
	$('#exDialog').dialog('open');
}

function disableIdRelInput(){
	//$('#cycle').combobox({disabled: true});
	$('#exCode').textbox('textbox').attr('disabled',true);
}

function setFormValue(data){
	$('#exCode').textbox('setValue',data.ex_code);
	$('#cycle').combobox('setValue',data.cycle);
	$('#boiCode').textbox('setValue',data.boi_code);
	$('#exName').textbox('setValue',data.ex_name);
	$('#exId').textbox('setValue',data.ex_id);
	$('#remark').textbox('setValue',data.remark);
	
	$('#ruleType').combobox('setValue',data.rule_type);
	$('#compOper').combobox('setValue',data.comp_oper);
	$('#dependType').combobox('setValue',data.depend_type);
	$('#ruleDef').textbox('setValue',data.rule_def);
	$('#compVal').textbox('setValue',data.comp_val);
	
	$('#procDepend').textbox('setValue',data.proc_depend);
	$('#gbasDepend').textbox('setValue',data.gbas_depend);
	$('#exDef').textbox('setValue',data.ex_def);
	$('#onlineDate').textbox('setValue',data.online_date);
	if(data.offline_date == null || data.offline_date.length == 0){
		$('#offlineDate').textbox('setValue','2999-12-31');
	}else{
		$('#offlineDate').textbox('setValue',data.offline_date);
	}
	$('#expectEndDay').textbox('setValue',data.expect_end_day);
	$('#expectEndTime').textbox('setValue',data.expect_end_time);
	$('#priority').textbox('setValue',data.priority);
	$('#createrName').textbox('setValue',data.creater_name);
	$('#creater').val(data.creater);
	$('#developerName').textbox('setValue',data.developer_name);
	$('#developer').val(data.developer);
	$('#managerName').textbox('setValue',data.manager_name);
	$('#manager').val(data.manager);
}

function updateStatus(status, content){
	var row = checkSelect();
	if(row == null){
		return;
	}
	
	if(${isAdmin} != 1 && row.developer != '${userId}'){
		$.messager.alert('提示','您没有权限提交此接口','info');
		return;
	}
	
	$.messager.confirm('提示', '您确定要' + content + '吗?', function(r){
		if (r){
			$.ajax({
				type: "POST"
				,url: "${mvcPath}/ex/updateStatus"
				,data: {
					exCode: row.ex_code,
					status: status
				}
				,dataType : "json"
				,success: function(data){
					var wind = $.messager.alert('提示', content + '成功','info');
					wind.window({onBeforeClose:function(){
						queryEx();
					}});
				}
			});
		}
	});
}

function checkSelect(){
	var rows = $('#exTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条接口信息','info');
		return null;
	}
	return rows[0];
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
	if(value == "2"){
		return "待上线";
	}
	if(value == "3"){
		return "下线";
	}
	return value;
}

function queryEx(){
	var exCycle = $("#qryCycle").combobox("getValue").trim();
	var status = $("#qryStatus").combobox("getValue").trim();
	var exName = $("#qryExName").textbox("getValue").trim();
	var exCode = $("#qryExCode").textbox("getValue").trim();
	var developer = $("#qryDeveloper").textbox("getValue").trim();
	
	$("#exTable").datagrid("load", {
		exCycle : exCycle,
		status : status,
		exName : exName,
		exCode : exCode,
		developer: developer
	});
}

function openUserDialog(userType){
	$('#userType').val(userType);
	$("#qryUserId").val('');
	$("#qryUserName").val('');
	$('#userDialog').dialog('open');
	var options = $('#userTable').datagrid('options');
    options.url = '${mvcPath}/zb/getUserList';
    options.queryParams = {
		userName : '',
		userId : ''
	};
    $('#userTable').datagrid(options);
}

function queryUser(){
	var qryUserId = $("#qryUserId").val().trim();
	var qryUserName = $("#qryUserName").val().trim();
	$("#userTable").datagrid("load", {
		userName : qryUserName,
		userId : qryUserId
	});
}

function userSelect(){
	var rows = $('#userTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一个用户','info');
		return;
	}
	
	var userType = $('#userType').val();
	if(userType == 'developer'){
		$("#developer").val(rows[0].userid);
		$("#developerName").textbox('setValue',rows[0].username);
	}else if(userType == 'updateDeveloper'){
		$("#addDeveloper").val(rows[0].userid);
		$("#addDeveloperName").textbox('setValue',rows[0].username);
	}else{
		$("#manager").val(rows[0].userid);
		$("#managerName").textbox('setValue',rows[0].username);
	}
	$('#userDialog').dialog('close');
}

</script>
</head>
<body>
	<table id="exTable" class="easyui-datagrid" title="接口信息" style="height:auto;"
			data-options="fit:true, fitColumns : true, striped:true, pagination : true, pageSize : 10, pageList : [10, 20, 30, 50],
				rownumbers:true, singleSelect:true, checkOnSelect : false,
				url:'${mvcPath}/ex/getExList',toolbar:'#tb'">
		<thead>
			<tr>
				<!--<th field="itemId" checkbox="true"></th>-->
				<th data-options="field:'cycle',width:60,formatter:cycleReplace">周期</th>
				<th data-options="field:'ex_code',width:80">编码</th>
				<th data-options="field:'ex_name',width:120">名称</th>
				<th data-options="field:'ex_id',width:80">接口ID</th>
				<th data-options="field:'boi_code',width:80,hidden:'true'">一经接口号</th>
				<th data-options="field:'remark',width:180">描述</th>
				
				<th data-options="field:'depend_type',width:80,hidden:'true'">依赖类型</th>
				
				<th data-options="field:'proc_depend',width:80,hidden:'true'">依赖程序</th>
				<th data-options="field:'gbas_depend',width:80,hidden:'true'">依赖的gbas指标,规则,接口</th>
				<th data-options="field:'ex_def',width:80,hidden:'true'">接口SQL</th>
				<th data-options="field:'status',width:60,formatter:statusReplace">状态</th>
				<th data-options="field:'online_date',width:100">上线日期</th>
				<th data-options="field:'offline_date',width:100">下线日期</th>
				<th data-options="field:'expect_end_day',width:80,hidden:'true'">预期完成日期</th>
				<th data-options="field:'expect_end_time',width:80,hidden:'true'">预期完成时间</th>
				<th data-options="field:'priority',width:80,hidden:'true'">优先级</th>
				<th data-options="field:'creater',width:80, hidden:true,">创建人</th>
				<th data-options="field:'developer',width:80, hidden:true,">开发人</th>
				<th data-options="field:'manager',width:80, hidden:true,">当前责任人</th>
				<th data-options="field:'creater_name',width:80,">创建人</th>
				<th data-options="field:'developer_name',width:80,">开发人</th>
				<th data-options="field:'manager_name',width:80,">当前责任人</th>
			</tr>
		</thead>
	</table>
	
	<div id="tb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>周期</span>
			<select id="qryCycle" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="height: 27px; width: 100px;">
				<option value="">---请选择---</option>
				<option value="daily">日</option>
				<option value="monthly">月</option>
			</select>
			<span>状态</span>
			<select id="qryStatus" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="height: 27px; width: 100px;">
				<option value="">---请选择---</option>
				<option value="0">开发</option>
				<option value="1">上线</option>
				<option value="2">待上线</option>
				<option value="3">下线</option>
			</select>
			<span>接口名称</span>
			<input id="qryExName" class="easyui-textbox" style="height: 27px; width: 150px;">
			<span>接口编码</span>
			<input id="qryExCode" class="easyui-textbox" style="height: 27px; width: 150px;">
			<span>开发者</span>
			<input id="qryDeveloper" class="easyui-textbox" style="height: 27px; width: 150px;">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryEx()">查询</a>
		</div>
		<div>
			<#if isAdmin == 1>
				<a href="#" class="easyui-linkbutton" iconCls="icon-add" onclick="openAddDialog()">新增</a>
				<a href="#" class="easyui-linkbutton" iconCls="icon-user" onclick="openUpdateDevDialog()">修改开发人</a>
			</#if>
				<a href="#" class="easyui-linkbutton" iconCls="icon-edit" onclick="openEditDialog()">修改接口</a>
				<a href="#" class="easyui-linkbutton" iconCls="icon-submit" onclick="updateStatus('2','提交申请')">提交申请</a>
			<#if isAdmin == 1>
				<a href="#" class="easyui-linkbutton" iconCls="icon-ok" onclick="updateStatus('1','上线')">上线</a>
				<a href="#" class="easyui-linkbutton" iconCls="icon-cancel" onclick="updateStatus('3','下线')">下线</a>
			</#if>
		</div>
	</div>
	
	<!--新增接口结束-->
	<div id="addExDialog" class="easyui-dialog" title="新增接口" data-options="
			modal:true,
			closed:true,
			width:430,
			height:250,
			buttons: [{
					text:'提交',
					handler:function(){
						saveEx();
					}
				},{
					text:'取消',
					handler:function(){
						$('#addExDialog').dialog('close');
					}
				}]">
			<div class="mar-8" style="height:100px;">
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>接口编码:</div>
					<input id="addExCode" name="addExCode" class="easyui-textbox form-inp" missingMessage="接口编码为必填项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>接口名称:</div>
					<input id="addExName" name="addExName" class="easyui-textbox form-inp" missingMessage="接口名称为必填项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">开发人:</div>
					<input id="addDeveloperName" name="addDeveloperName" class="easyui-textbox form-inp" data-options="editable:false," style="width:55%;height:32px;">
					<input id="addDeveloper" name="addDeveloper" type="hidden" value="">
					<a href="#" class="user-qry" onclick="openUserDialog('updateDeveloper')">选择用户</a>
				</div>
			</div>
		
	</div>
	<!--新增接口结束-->	
	<!--修改接口-->		
	<div id="exDialog" class="easyui-dialog" title="修改接口" data-options="
			modal:true,
			closed:true,
			width:430,
			height:500,
			buttons: [{
					text:'提交',
					handler:function(){
						$('#exDefForm').form('submit', {
							url: '${mvcPath}/ex/saveExDef',
							onSubmit: function(param){
								return $(this).form('enableValidation').form('validate');
							},
							success:function(data){
								var wind = $.messager.alert('提示','提交成功','info');
								wind.window({onBeforeClose:function(){
									queryEx();
									$('#exDialog').dialog('close');
								}});
   							}
   							
						});
					}
				},{
					text:'取消',
					handler:function(){
						$('#exDialog').dialog('close');
					}
				}]">
		<form id="exDefForm">
			<input id="optType" name="optType" type="hidden">
			<div class="mar-8" style="height:100px;">
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>接口编码:</div>
					<input id="exCode" name="exCode" class="easyui-textbox form-inp" missingMessage="接口编码为必填项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>接口名称:</div>
					<input id="exName" name="exName" class="easyui-textbox form-inp" missingMessage="接口名称为必填项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>一经接口号:</div>
					<input id="boiCode" name="boiCode" class="easyui-textbox form-inp" missingMessage="一经接口号为必填项" data-options="required:true,prompt:'多个接口号用;分割'" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>接口ID:</div>
					<input id="exId" name="exId" class="easyui-numberbox form-inp" missingMessage="接口ID为必填项" data-options="required:true," style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>接口周期:</div>
					<select id="cycle" name="cycle" class="easyui-combobox form-inp" missingMessage="接口周期为必选项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="daily">日</option>
						<option value="monthly">月</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>接口描述:</div>
					<input id="remark" name="remark" class="easyui-textbox form-inp" missingMessage="接口描述为必填项" data-options="required:true,multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>依赖类型:</div>
					<select id="dependType" name="dependType" class="easyui-combobox form-inp" missingMessage="依赖类型为必选项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="1">默认</option>
						<option value="2">顺序启动</option>
						<option value="3">不判断依赖</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab">依赖程序:</div>
					<input id="procDepend" name="procDepend" class="easyui-textbox form-inp" data-options="prompt:'多个依赖用;分割'" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="fl" style="height: 32px;line-height: 32px; width:42%;">依赖的gbas指标,规则,接口:</div>
					<input id="gbasDepend" name="gbasDepend" class="easyui-textbox form-inp"  data-options="prompt:'多个依赖用;分割'" style="height:32px; width:57%;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>上线日期:</div>
					<input id="onlineDate" name="onlineDate" editable="false" missingMessage="上线日期为必填项" data-options="required:true" class="easyui-datebox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>下线日期:</div>
					<input id="offlineDate" name="offlineDate" editable="false" missingMessage="下线日期为必填项" data-options="required:true" class="easyui-datebox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">预期完成日期:</div>
					<input id="expectEndDay" name="expectEndDay" class="easyui-numberbox form-inp"
						data-options="min:0,max:31,prompt:'0表示每日,1-31表示1-31日'" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">预期完成时间:</div>
					<input id="expectEndTime" name="expectEndTime" class="easyui-numberbox form-inp"  
						data-options="min:0,max:24,precision:2,decimalSeparator:'.',prompt:'例：8.5表示8点半'" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">优先级:</div>
					<input id="priority" name="priority" class="easyui-numberbox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">创建人:</div>
					<input id="createrName" name="createrName" class="easyui-textbox form-inp" data-options="editable:false," style="width:75%;height:32px;">
					<input id="creater" name="creater" type="hidden" value="">
				</div>
				<div class="mar-b15">
					<div class="inp-lab">开发人:</div>
					<input id="developerName" name="developerName" class="easyui-textbox form-inp" data-options="editable:false," style="width:55%;height:32px;">
					<input id="developer" name="developer" type="hidden" value="">
					<a href="#" class="user-qry" onclick="openUserDialog('developer')">选择用户</a>
				</div>
				<div class="mar-b15">
					<div class="inp-lab">当前责任人:</div>
					<input id="managerName" name="managerName" class="easyui-textbox form-inp" data-options="editable:false," style="width:55%;height:32px;">
					<input id="manager" name="manager" type="hidden" value="">
					<a href="#" class="user-qry" onclick="openUserDialog('manager')">选择用户</a>
				</div>
			</div>
		</form>
	</div>
	
	<input type="hidden" id="userType">
	<!--选择用户-->
	<div id="userDialog" class="easyui-dialog" title="用户选择" data-options="
			modal:true,
			closed:true,
			width:500,
			height:430,
			buttons: [{
					text:'选择',
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
		    data-options="fit:true,fitColumns:true,singleSelect:true,pagination : true, pageSize : 10, pageList : [10, 20, 30, 50],
		    	rownumbers:true,toolbar:'#userTb'">
		    <thead>
				<tr>
					<th data-options="field:'userid',width:60">用户ID</th>
					<th data-options="field:'username',width:80">用户名</th>
					<th data-options="field:'areaname',width:60">地市</th>
				</tr>
		    </thead>
		</table>
	</div>
	<!--模板管理-->
	<div id="userTb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>用户ID</span>
			<input id="qryUserId" style="width: 120px;">
			<span>用户名</span>
			<input id="qryUserName" style="width: 120px;">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryUser()">查询</a>
		</div>
	</div>
	
</body>
</html>