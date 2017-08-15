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
$(function(){
	$("input",$("#zbCode").next("span")).blur(function(){
	    checkZbCode();  
	});
});

function checkZbCode(){
	var zbCode = $('#zbCode').textbox('getValue');
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/zb/checkZbCode"
		,data: {
			zbCode: zbCode
		}
		,async:false
		,dataType : "json"
		,success: function(data){
			if(!data){
				var wind = $.messager.alert('提示','此指标编码已存在，请重新输入','info');
				wind.window({onBeforeClose:function(){
					$('#zbCode').textbox('setValue','');
				}});
			}
		}
	});
}

function openAddDialog(){
	clearFormValue();
	$("#optType").val("add");
	enableIdRelInput();
	$('#zbDialog').panel({title: "新增指标"});
	$('#zbDialog').dialog('open');
}

function enableIdRelInput(){
	//$('#cycle').combobox({disabled: false});
	$('#zbCode').textbox('textbox').attr('disabled',false);
}

function clearFormValue(){
	$('#zbDefForm').form('clear');
	$('#cycle').combobox('setValue','daily');
	$('#zbType').combobox('setValue','一经');
	$('#status').combobox('setValue','0');
	$('#ruleType').combobox('setValue','0');
	$('#compOper').combobox('setValue','>');
	$('#dependType').combobox('setValue','1');
	$('#offlineDate').textbox('setValue','2999-12-31');
	$('#priority').textbox('setValue','99');
	$('#creater').val('${userId}');
	$('#createrName').textbox('setValue','${userName}');
}

function openEditDialog(){
	var rows = $('#zbTable').datagrid('getSelections');
	if(rows.length != 1){
		$.messager.alert('提示','请选择一条指标信息','info');
		return;
	}
	setFormValue(rows[0]);
	disableIdRelInput();
	$("#optType").val("edit");
	$('#zbDialog').panel({title: "修改指标"});
	$('#zbDialog').dialog('open');
}

function disableIdRelInput(){
	//$('#cycle').combobox({disabled: true});
	$('#zbCode').textbox('textbox').attr('disabled',true);
}

function setFormValue(data){
	$('#zbCode').textbox('setValue',data.zb_code);
	$('#cycle').combobox('setValue',data.cycle);
	$('#boiCode').textbox('setValue',data.boi_code);
	$('#zbName').textbox('setValue',data.zb_name);
	$('#remark').textbox('setValue',data.remark);
	$('#zbType').combobox('setValue',data.zb_type);
	
	$('#ruleType').combobox('setValue',data.rule_type);
	$('#compOper').combobox('setValue',data.comp_oper);
	$('#dependType').combobox('setValue',data.depend_type);
	$('#ruleDef').textbox('setValue',data.rule_def);
	$('#compVal').textbox('setValue',data.comp_val);
	
	$('#procDepend').textbox('setValue',data.proc_depend);
	$('#gbasDepend').textbox('setValue',data.gbas_depend);
	$('#zbDef').textbox('setValue',data.zb_def);
	$('#status').combobox('setValue',data.status);
	$('#onlineDate').textbox('setValue',data.online_date);
	$('#offlineDate').textbox('setValue',data.offline_date);
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
	}else{
		$("#manager").val(rows[0].userid);
		$("#managerName").textbox('setValue',rows[0].username);
	}
	$('#userDialog').dialog('close');
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
				
				<th data-options="field:'rule_type',width:80,hidden:'true'">规则类型</th>
				<th data-options="field:'rule_def',width:80,hidden:'true'">规则配置</th>
				<th data-options="field:'comp_oper',width:80,hidden:'true'">比较运算符</th>
				<th data-options="field:'comp_val',width:80,hidden:'true'">阈值</th>
				<th data-options="field:'depend_type',width:80,hidden:'true'">依赖类型</th>
				
				<th data-options="field:'proc_depend',width:80,hidden:'true'">依赖程序</th>
				<th data-options="field:'gbas_depend',width:80,hidden:'true'">依赖的gbas指标,规则,接口</th>
				<th data-options="field:'zb_def',width:80,hidden:'true'">指标SQL</th>
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
								return $(this).form('enableValidation').form('validate');
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
			<input id="optType" name="optType" type="hidden">
			<div class="mar-8" style="height:100px;">
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标编码:</div>
					<input id="zbCode" name="zbCode" class="easyui-textbox form-inp" missingMessage="指标编码为必输项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标名称:</div>
					<input id="zbName" name="zbName" class="easyui-textbox form-inp" missingMessage="指标名称为必输项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>一经接口号:</div>
					<input id="boiCode" name="boiCode" class="easyui-textbox form-inp" missingMessage="一经接口号为必输项" data-options="required:true,prompt:'多个接口号用;分割'" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标类型:</div>
					<select id="zbType" name="zbType" class="easyui-combobox form-inp" missingMessage="指标类型为必选项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="一经">一经</option>
						<option value="省内">省内</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标周期:</div>
					<select id="cycle" name="cycle" class="easyui-combobox form-inp" missingMessage="指标周期为必选项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="daily">日</option>
						<option value="monthly">月</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标描述:</div>
					<input id="remark" name="remark" class="easyui-textbox form-inp" missingMessage="指标描述为必输项" data-options="required:true,multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>指标sql:</div>
					<input id="zbDef" name="zbDef" class="easyui-textbox form-inp" missingMessage="指标sql为必输项" data-options="required:true,multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>规则类型:</div>
					<select id="ruleType" name="ruleType" class="easyui-combobox form-inp" missingMessage="规则类型为必选项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="0">弱规则</option>
						<option value="1">强规则</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>规则配置:</div>
					<input id="ruleDef" name="ruleDef" class="easyui-textbox form-inp" missingMessage="规则配置为必输项" data-options="required:true,multiline:true" style="width:75%;height:60px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>比较运算符:</div>
					<select id="compOper" name="compOper" class="easyui-combobox form-inp" missingMessage="比较运算符为必选项项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
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
					<input id="compVal" name="compVal" class="easyui-numberbox form-inp"  missingMessage="阈值为必输项" 
						data-options="required:true,precision:2,decimalSeparator:'.'" style="width:75%;height:32px;">
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
					<div class="inp-lab"><span style="color:red;">*</span>依赖程序:</div>
					<input id="procDepend" name="procDepend" class="easyui-textbox form-inp"  missingMessage="依赖程序为必输项" data-options="required:true" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="fl" style="height: 32px;line-height: 32px; width:42%;"><span style="color:red;">*</span>依赖的gbas指标,规则,接口:</div>
					<input id="gbasDepend" name="gbasDepend" class="easyui-textbox form-inp" missingMessage="依赖的gbas指标,规则,接口为必输项" data-options="required:true,prompt:'多个依赖用;分割'" style="height:32px; width:57%;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>状态:</div>
					<select id="status" name="status" class="easyui-combobox form-inp" missingMessage="状态为必选项" data-options="required:true,editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
						<option value="0">开发</option>
						<option value="1">上线</option>
					</select>
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>上线日期:</div>
					<input id="onlineDate" name="onlineDate" editable="false" missingMessage="上线日期为必输项" data-options="required:true" class="easyui-datebox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>下线日期:</div>
					<input id="offlineDate" name="offlineDate" editable="false" missingMessage="下线日期为必输项" data-options="required:true" class="easyui-datebox form-inp" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>预期完成日期:</div>
					<input id="expectEndDay" name="expectEndDay" class="easyui-numberbox form-inp"  missingMessage="预期完成日期为必输项" 
						data-options="required:true,min:0,max:31,prompt:'0表示每日,1-31表示1-31日'" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>预期完成时间:</div>
					<input id="expectEndTime" name="expectEndTime" class="easyui-numberbox form-inp"  missingMessage="预期完成时间为必输项" 
						data-options="required:true,min:0,max:24,precision:2,decimalSeparator:'.',prompt:'例：8.5表示8点半'" style="width:75%;height:32px;">
				</div>
				<div class="mar-b15">
					<div class="inp-lab"><span style="color:red;">*</span>优先级:</div>
					<input id="priority" name="priority" class="easyui-numberbox form-inp" missingMessage="优先级为必输项" data-options="required:true" style="width:75%;height:32px;">
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