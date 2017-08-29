<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>报表上线工具</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/report.css">
<script src="${mvcPath}/resources/js/jquery-1.8.3.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script>
$(function(){
	$('#menuSel').combobox({
	    valueField:'id',
	    textField:'text',
	    onSelect: function(rec){
		    reloatSortCombo(rec.id);
	    }
	});
});

var toolbar = [{
	text:'新增分类',
	iconCls:'icon-add',
	handler:function(){
		openAddDialog("add");
	}
},'-',{
	text:'修改分类',
	iconCls:'icon-edit',
	handler:function(){
		openEditListDialog();
	}
},'-',{
	text:'删除分类',
	iconCls:'icon-remove',
	handler:function(){
		openDelListDialog();
	}
}];

function openAddDialog(type){
	if(type == 'add'){
		$("#currentId").val("");
		$("#addName").textbox('setValue', "");
		$("#addSort").textbox('setValue', "");
		$('#addDialog').panel({title: "新增分类"});
	}else{
		var rows = $('#editTable').datagrid('getSelections');
		if(rows.length != 1){
			$.messager.alert('提示','请选择一条分类信息','info');
			return;
		}
		$("#currentId").val(rows[0].id);
		$("#addMenuSel").combobox('setValue', rows[0].menu_id);
		$("#addName").textbox('setValue', rows[0].name);
		$("#addSort").textbox('setValue', rows[0].sort);
		$('#addDialog').panel({title: "修改分类"});
	}
	$('#addDialog').dialog('open');
}

function openEditListDialog(){
	$("#qrySortName").val("");
	$('#editListDialog').dialog('open');
	var options = $('#editTable').datagrid('options');
    options.url = '${mvcPath}/report/onoffline/getSortList';
    options.queryParams = {
		menuId : '',
		sortName : ''
	};
    $('#editTable').datagrid(options);
}

function openDelListDialog(){
	$("#delName").val("");
	$('#delListDialog').dialog('open');
	var options = $('#delTable').datagrid('options');
    options.url = '${mvcPath}/report/onoffline/getSortList';
    options.queryParams = {
		menuId : '',
		sortName : ''
	};
    $('#delTable').datagrid(options);
}

function querySort(){
	var qrySortName = $("#qrySortName").val().trim();
	$("#editTable").datagrid("load", {
		sortName : qrySortName,
		menuId : ''
	});
}

function queryDel(){
	var delName = $("#delName").val().trim();
	$("#delTable").datagrid("load", {
		sortName : delName,
		menuId : ''
	});
}

function addSort(){
	var menuId = $("#addMenuSel").combobox('getValue');
	if(menuId.length == 0){
		$.messager.alert('提示','请选择业务分类','info');
		return;
	}
	var name = $("#addName").textbox('getValue').trim();
	if(name.length == 0){
		$.messager.alert('提示','请选择业务分类','info');
		return;
	}
	var sortNum = $("#addSort").textbox('getValue');
	var sortId = $("#currentId").val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/report/onoffline/addRptSort"
		,data: {
			menuId: menuId,
			sortNum: sortNum,
			name: name,
			sortId: sortId
		}
		,dataType : "json"
		,success: function(data){
			var wind = $.messager.alert('提示','提交成功','info');
			wind.window({onBeforeClose:function(){
				$('#addDialog').dialog('close');
				if(sortId.length != 0){
					querySort();
				}
			}});
		}
	});
}

function delSort(){
	var sortList = $('#delTable').datagrid('getChecked');
	if (sortList.length == 0) {
		$.messager.alert("信息", "请至少选择一条分类信息", "info");
		return false;
	}
	var idArr = new Array();
	for(var i=0; i<sortList.length; i++){
		idArr.push(sortList[i].id);
	}
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/report/onoffline/delRptSort"
		,data: {
			ids: idArr.toString()
		}
		,dataType : "json"
		,success: function(data){
			var wind = $.messager.alert('提示','删除成功','info');
			wind.window({onBeforeClose:function(){
				queryDel();
			}});
		}
	});
}

function reloatSortCombo(menuId){
	$('#sortSel').combobox('reload','${mvcPath}/report/onoffline/getSortList?menuId=' + menuId);
}
function operation(value, row, index){
	var oprHtml = "<a class='oper' href='#' onclick=openOnLineDialog('" + row.id + "')>上线</a>";
	return oprHtml;
}

function queryReport(){
	var rid = $("#qryId").textbox('getValue').trim();
	var name = $("#qryName").textbox('getValue').trim();
	
	$("#onLineTable").datagrid("load", {
		rid : rid,
		name : name
	});
}

function openOnLineDialog(){
	var menuId = $("#menuSel").combobox('getValue');
	reloatSortCombo(menuId);
	$('#onlineDialog').dialog('open');
}

function onLineReport(){
	var menuId = $("#menuSel").combobox('getValue');
	if(menuId.length == 0){
		$.messager.alert('提示','请选择业务分类','info');
		return;
	}
	var sortId = $("#sortSel").combobox('getValue');
	if(menuId.length == 0){
		$.messager.alert('提示','请选择报表分类','info');
		return;
	}
	var rptCycle = $("#rptCycle").combobox('getValue');
	if(rptCycle.length == 0){
		$.messager.alert('提示','请选择报表周期','info');
		return;
	}
	
	var rows = $('#onLineTable').datagrid('getSelections');
	var rid = rows[0].id;
	var sortNum = $('#sortNum').textbox('getValue');
	var keyWord = $('#keyWord').textbox('getValue');
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/report/onoffline/onLineRpt"
		,data: {
			rid: rid,
			sortId: sortId,
			menuId: menuId,
			sortNum: sortNum,
			keyWord: keyWord,
			rptCycle: rptCycle
		}
		,dataType : "json"
		,success: function(data){
			var wind = $.messager.alert('提示','上线成功','info');
			wind.window({onBeforeClose:function(){
				$('#onlineDialog').dialog('close');
				queryReport();
			}});
		}
	});
}

</script>
</head>
<body>
	<div class="qry-line">
		<label style="margin-left: 15px;">报表ID：</label>
		<input id="qryId" class="easyui-textbox" style="height:28px;"/>
		<label style="margin-left: 15px;">报表名称：</label>
		<input id="qryName" class="easyui-textbox" style="height:28px;"/>
		<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryReport()">查询</a>
	</div>
	<table id="onLineTable" class="easyui-datagrid" style="height:auto;"
			data-options="fitColumns : true, striped:true, pagination : true, pageSize : 20, pageList : [10, 20, 30, 50],
				rownumbers:true, singleSelect:true, checkOnSelect : false,toolbar: toolbar,
				url:'${mvcPath}/report/onoffline/getWaitOnLineReport'">
		<thead>
			<tr>
				<th data-options="field:'id',width:40">报表ID</th>
				<th data-options="field:'name',width:100">报表名称</th>
				<th data-options="field:'state',width:40">状态</th>
				<th data-options="field:'descr',width:120">描述</th>
				<th data-options="field:'create_dt',width:70">创建时间</th>
				<th data-options="field:'opt',width:40,formatter: operation">操作</th>
			</tr>
		</thead>
	</table>
	
	<div id="onlineDialog" class="easyui-dialog" title="报表上线" data-options="
			modal:true,
			closed:true,
			width:340,
			height:350,
			buttons: [{
					text:'上线',
					handler:function(){
						onLineReport();
					}
				},{
					text:'取消',
					handler:function(){
						$('#onlineDialog').dialog('close');
					}
				}]">
			<div class="mar-b15 mar-t15">
				<div class="inp-lab"><span style="color:red;">*</span>业务类型:</div>
				<select id="menuSel" name="menuSel" class="easyui-combobox" style="width:70%;height:32px;" 
					data-options="editable:false," >
					<#if menuList?exists>
						<#list menuList as menuItem>
							<option value='${menuItem.id}'>${menuItem.name}</option>
						</#list>
					</#if>
				</select>
			</div>
			<div class="mar-b15">
				<div class="inp-lab"><span style="color:red;">*</span>报表分类:</div>
				<select id="sortSel" name="sortSel" class="easyui-combobox" data-options="valueField:'id',textField:'name',editable:false," style="width:70%;height:32px;">
				</select>
			</div>
			<div class="mar-b15">
				<div class="inp-lab"><span style="color:red;">*</span>报表周期:</div>
				<select id="rptCycle" name="rptCycle" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="width:70%;height:32px;">
					<option value='day'>日</option>
					<option value='month'>月</option>
				</select>
			</div>
			<div class="mar-b15">
				<div class="inp-lab">报表排序:</div>
				<input id="sortNum" name="sortNum" class="easyui-numberbox" style="width:70%;height:32px;">
			</div>
			<div class="mar-b15">
				<div class="inp-lab">关键字:</div>
				<input id="keyWord" name="keyWord" class="easyui-textbox" style="width:70%;height:32px;">
			</div>
	</div>
	
	<div id="addDialog" class="easyui-dialog" title="新增分类" data-options="
			modal:true,
			closed:true,
			width:340,
			height:250,
			buttons: [{
					text:'提交',
					handler:function(){
						addSort();
					}
				},{
					text:'取消',
					handler:function(){
						$('#addDialog').dialog('close');
					}
				}]">
			<div class="mar-b15 mar-t15">
				<div class="inp-lab"><span style="color:red;">*</span>业务类型:</div>
				<select id="addMenuSel" name="menuSel" class="easyui-combobox" style="width:70%;height:32px;" 
					data-options="editable:false," >
					<#if menuList?exists>
						<#list menuList as menuItem>
							<option value='${menuItem.id}'>${menuItem.name}</option>
						</#list>
					</#if>
				</select>
			</div>
			<div class="mar-b15">
				<div class="inp-lab"><span style="color:red;">*</span>分类名称:</div>
				<input id="addName" name="addName" class="easyui-textbox" style="width:70%;height:32px;">
			</div>
			<div class="mar-b15">
				<div class="inp-lab">报表排序:</div>
				<input id="addSort" name="addSort" class="easyui-numberbox" style="width:70%;height:32px;">
			</div>
	</div>
	<div id="editListDialog" class="easyui-dialog" title="编辑分类" data-options="
			modal:true,
			closed:true,
			width:450,
			height:500,
			buttons: [{
					text:'修改',
					handler:function(){
						openAddDialog();
					}
				},{
					text:'取消',
					handler:function(){
						$('#editListDialog').dialog('close');
					}
				}]">
			<input id="currentId" type="hidden">
			<table id="editTable" class="easyui-datagrid" style="height:auto;"
		    data-options="fit:true,fitColumns:true,singleSelect:true,rownumbers:true,toolbar:'#editTb'">
		    <thead>
				<tr>
					<th data-options="field:'id',hidden:true,">分类ID</th>
					<th data-options="field:'menu_id',hidden:true,">业务ID</th>
					<th data-options="field:'menu_name',width:60,">业务类型</th>
					<th data-options="field:'name',width:100">分类名称</th>
					<th data-options="field:'sort',width:40,">排序</th>
				</tr>
		    </thead>
		</table>
	</div>
	
	<!--编辑查询-->
	<div id="editTb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>分类名称</span>
			<input id="qrySortName">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="querySort()">查询</a>
		</div>
	</div>
	
	<div id="delListDialog" class="easyui-dialog" title="删除分类" data-options="
			modal:true,
			closed:true,
			width:450,
			height:500,
			buttons: [{
					text:'删除',
					handler:function(){
						delSort();
					}
				},{
					text:'取消',
					handler:function(){
						$('#delListDialog').dialog('close');
					}
				}]">
			<table id="delTable" class="easyui-datagrid" style="height:auto;"
		    data-options="fit:true,fitColumns:true,singleSelect:false,rownumbers:true,toolbar:'#delTb'">
		    <thead>
				<tr>
					<th data-options="field:'id',checkbox:true">分类ID</th>
					<th data-options="field:'menu_id',hidden:true,">业务ID</th>
					<th data-options="field:'menu_name',width:60,">业务类型</th>
					<th data-options="field:'name',width:100">分类名称</th>
					<th data-options="field:'sort',width:40,">排序</th>
				</tr>
		    </thead>
		</table>
	</div>
	
	<!--删除查询-->
	<div id="delTb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>分类名称</span>
			<input id="delName">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryDel()">查询</a>
		</div>
	</div>			
</body>
</html>