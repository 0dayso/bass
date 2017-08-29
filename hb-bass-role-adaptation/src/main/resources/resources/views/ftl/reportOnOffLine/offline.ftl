<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>报表下线工具</title>
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
		    $('#sortSel').combobox('reload','${mvcPath}/report/onoffline/getSortList?menuId=' + rec.id);
	    }
	});
});

function queryReport(){
	var menuId = $("#qryMenu").combobox('getValue');
	var reportName = $("#qryName").textbox('getValue').trim();
	var reportId = $("#qryId").textbox('getValue').trim();
	
	$("#onlineTable").datagrid("load", {
		menuId : menuId,
		reportName : reportName,
		reportId: reportId
	});
}

function offLineReport(resourceName, resourceId, resourceUri){
	$.messager.confirm('消息', '您确定要下线报表<' + resourceName + '>吗?', function(r){
		if (r){
			$.ajax({
				type: "POST"
				,url: "${mvcPath}/report/onoffline/offlineRpt"
				,data: {
					reportId: resourceId,
					resourceUri: resourceUri
				}
				,dataType : "json"
				,success: function(data){
					var wind = $.messager.alert('提示','下线成功','info');
					wind.window({onBeforeClose:function(){
						queryReport();
					}});
				}
			});
		}
	});
}

function operation(value, row, index){
	var oprHtml = "<a class='oper' href='#' onclick=offLineReport('" + row.resource_name + "','" + row.resource_id + "','" + row.resource_uri + "')>下线</a>"
				+ "<a class='oper' style='margin-left:5px;' href='#' onclick=openChangeDia('" + row.resource_id + "','" + row.menu_id + "','" + row.sort_id + "')>修改路径</a>";
	return oprHtml;
}

function openChangeDia(rid,menuId, sortId){
	$("#currentId").val(rid);
	$('#menuSel').combobox("setValue", menuId);
	$('#changeDialog').dialog('open');
}

function changeMenu(){
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
	var rid = $("#currentId").val();
	$.ajax({
		type: "POST"
		,url: "${mvcPath}/report/onoffline/changeSort"
		,data: {
			rid: rid,
			sortId: sortId,
			menuId: menuId
		}
		,dataType : "json"
		,success: function(data){
			var wind = $.messager.alert('提示','提交成功','info');
			wind.window({onBeforeClose:function(){
				$('#changeDialog').dialog('close');
				queryReport();
			}});
		}
	});
}
</script>
</head>
<body>
	<input id="currentId" type="hidden"></input>
	<div class="qry-line">
		<label style="margin-left: 5px;">业务分类：</label>
		<select id="qryMenu" class="easyui-combobox" data-options="editable:false" style="height:28px;">
			<option value=''>---请选择---</option>
			<#if menuList?exists>
				<#list menuList as menuItem>
				<option value='${menuItem.id}'>${menuItem.name}</option>
				</#list>
			</#if>
		</select>
		<label style="margin-left: 15px;">报表名称：</label>
		<input id="qryName" class="easyui-textbox" style="height:28px;"/>
		<label style="margin-left: 15px;">报表ID：</label>
		<input id="qryId" class="easyui-textbox" style="height:28px;"/>
		<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryReport()">查询</a>
	</div>
	<table id="onlineTable" class="easyui-datagrid" style="height:auto;"
			data-options="fitColumns : true, striped:true, pagination : true, pageSize : 20, pageList : [10, 20, 30, 50],
				rownumbers:true, singleSelect:true, checkOnSelect : false,
				url:'${mvcPath}/report/onoffline/getHasOnlineReport'">
		<thead>
			<tr>
				<th data-options="field:'resource_id',width:40">报表ID</th>
				<th data-options="field:'resource_uri',width:40, hidden:true,">报表路径</th>
				<th data-options="field:'menu_name',width:60">业务分类</th>
				<th data-options="field:'menu_id',width:60,hidden:true,">业务分类ID</th>
				<th data-options="field:'sort_name',width:80">报表分类</th>
				<th data-options="field:'sort_id',width:80,hidden:true,">报表分类ID</th>
				<th data-options="field:'resource_name',width:100">报表名称</th>
				<th data-options="field:'lastupdate',width:60">上线日期</th>
				<th data-options="field:'resource_desc',width:120">报表描述</th>
				<th data-options="field:'opt',width:60,formatter: operation">操作</th>
			</tr>
		</thead>
	</table>
	
	<div id="changeDialog" class="easyui-dialog" title="报表上线" data-options="
			modal:true,
			closed:true,
			width:340,
			height:200,
			buttons: [{
					text:'提交',
					handler:function(){
						changeMenu();
					}
				},{
					text:'取消',
					handler:function(){
						$('#changeDialog').dialog('close');
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
	</div>
	
</body>
</html>