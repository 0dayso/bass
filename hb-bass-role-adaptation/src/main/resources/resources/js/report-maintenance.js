var mvcPath = $("#mvcPath").val();
function check(){
	if($("#reportId").textbox('getText').length==0){
		$.messager.alert('报表维护信息',"您必须填写报表ID",'error');
		return false;
	}
	if($("#reportName").textbox('getText').length==0){
		$.messager.alert('报表维护信息',"您必须填写报表名称",'error');
		return false;
	}
	if($("#procedureName").textbox('getText').length==0){
		$.messager.alert('报表维护信息',"您必须填写后台程序名",'error');
		return false;
	}
	if($("#developerName").textbox('getText').length==0){
		$.messager.alert('报表维护信息',"您必须填写开发人员",'error');
		return false;
	}
	if($("#manager").textbox('getText').length==0){
		$.messager.alert('报表维护信息',"您必须填写负责人",'error');
		return false;
	}
	
	if($("#manager").textbox('getText').length==0){
		$.messager.alert('报表维护信息',"您必须填写负责人",'error');
		return false;
	}

	if($("#level").combobox('getValue').length==0){
		$.messager.alert('报表维护信息',"您必须选择重要级别",'error');
		return false;
	}
	

	if($("#online").combobox('getValue').length==0){
		$.messager.alert('报表维护信息',"您必须选择是否上线",'error');
		return false;
	}
	

	if($("#maintenance").combobox('getValue').length==0){
		$.messager.alert('报表维护信息',"您必须选择是否交维",'error');
		return false;
	}
	
	if($("#expectationDate").datebox('getValue').length==0){
		$.messager.alert('报表维护信息',"您必须填写期望日期",'error');
		return false;
	}
	return true;
}
function getSaveData(){
	var data = {};
	data.id = $("#id").val();
	data.reportId = $("#reportId").textbox('getText')||'';
	data.reportName = $("#reportName").textbox('getText')||'';
	data.procedureName = $("#procedureName").textbox('getText')||'';
	data.developerName = $("#developerName").textbox('getText')||'';
	data.manager = $("#manager").textbox('getText')||'';
	data.levelVal = $("#level").combobox('getValue')||'';
	data.onlineVal = $("#online").combobox('getValue')||'';
	data.maintenanceVal = $("#maintenance").combobox('getValue')||'';
	data.expectationDate = $("#expectationDate").datebox('getValue')||'';
	return data;
}
function getSelectRow(){
	var row = $("#reportMaintenance").datagrid('getSelected');
	if(!row){
		$.messager.alert('报表维护信息',"您必须选择一条数据",'error');
	}
	return row;
}
function getQueryData(){
	var data ={};
	
	var reportId = $("#q_reportId").textbox('getText');
	if(reportId){
		data.reportId = reportId;
	}
	var reportName = $("#q_reportName").textbox('getText');
	if(reportName){
		data.reportName = reportName;
	}
	var procedureName = $("#q_procedureName").textbox('getText');
	if(procedureName){
		data.procedureName = procedureName;
	}
	var developerName = $("#q_developerName").textbox('getText');
	if(developerName){
		data.developerName = developerName;
	}
	var manager = $("#q_manager").textbox('getText');
	if(manager){
		data.manager = manager;
	}
	
	
	var levelVal =  $("#q_level").combobox('getValue');
	if(levelVal && levelVal!='-1'){
		data.levelVal = levelVal;
	}
	var onlineVal =  $("#q_online").combobox('getValue');
	if(onlineVal && onlineVal!='-1'){
		data.onlineVal = onlineVal;
	}
	var maintenanceVal =  $("#q_maintenance").combobox('getValue');
	if(maintenanceVal && maintenanceVal!='-1'){
		data.maintenanceVal = maintenanceVal;
	}
	return data
}
function loadData(row){
	$("#id").val(row.id);
	$("#reportId").textbox('setText',row.reportId);
	$('#reportName').textbox('setText',row.reportName);
	$('#procedureName').textbox('setText',row.procedureName);
	$('#developerName').textbox('setText',row.developerName);
	$('#manager').textbox('setText',row.manager);
	$('#level').combobox('setValue',row.levelVal);
	$('#online').combobox('setValue',row.onlineVal);
	$('#maintenance').combobox('setValue',row.maintenanceVal);
	$('#expectationDate').datebox('setValue', row.expectationDate);
}
function clean(){
	$("#id").val('');
	$("#reportId").textbox('setText','');
	$('#reportName').textbox('setText','');
	$('#procedureName').textbox('setText','');
	$('#developerName').textbox('setText','');
	$('#manager').textbox('setText','');
	$('#level').combobox('setValue','0');
	$('#online').combobox('setValue','0');
	$('#maintenance').combobox('setValue','0');
	$('#expectationDate').datebox('setValue', '2017-08-04');
}
$(function(){	
	$('#expectationDate').datebox('setValue', '2017-08-04');
	$('#level').combobox({
		data: [{
				"id": "0",
				"selected": true,
				"text": "低"
			},
			{
				"id": "1",
				"text": "中"
			},
			{
				"id": "2",
				"text": "高"
			}
		],
		width: 180,
		valueField: 'id',
		textField: 'text'
	});
	$('#q_level').combobox({
		data: [{
				"id": "-1",
				"selected": true,
				"text": "请选择重要级别"
			},{
				"id": "0",
				"text": "低"
			},
			{
				"id": "1",
				"text": "中"
			},
			{
				"id": "2",
				"text": "高"
			}
		],
		width: 180,
		valueField: 'id',
		textField: 'text'
	});
	$('#online').combobox({
		data: [{
				"id": "0",
				"selected": true,
				"text": "未上线"
			},
			{
				"id": "1",
				"text": "上线"
			},
			{
				"id": "2",
				"text": "下线"
			}
		],
		width: 180,
		valueField: 'id',
		textField: 'text'
	});
	$('#q_online').combobox({
		data: [{
				"id": "-1",
				"selected": true,
				"text": "请选择是否上线"
			},{
				"id": "0",
				"text": "未上线"
			},
			{
				"id": "1",
				"text": "上线"
			},
			{
				"id": "2",
				"text": "下线"
			}
		],
		width: 180,
		valueField: 'id',
		textField: 'text'
	});
	
	$('#maintenance').combobox({
		data: [{
				"id": "0",
				"selected": true,
				"text": "未交维"
			},
			{
				"id": "1",
				"text": "已交维"
			}
		],
		width: 100,
		valueField: 'id',
		textField: 'text'
	});
	$('#q_maintenance').combobox({
		data: [{
				"id": "-1",
				"selected": true,
				"text": "请选择是否交维"
			},{
				"id": "0",
				"text": "未交维"
			},
			{
				"id": "1",
				"text": "已交维"
			}
		],
		width: 180,
		valueField: 'id',
		textField: 'text'
	});
	
	$("#query").click(function(){
		var queryData = getQueryData();
		$('#reportMaintenance').datagrid({queryParams:queryData});
		$('#reportMaintenance').datagrid('load');
	});
	$("#reportMaintenance").datagrid({
		url:mvcPath+'/report/maintenance/list',   
		method:'post',
	    columns:[[    
	    	    {field:'id',title:'ID',hidden:true},
	        {field:'reportId',title:'报表ID',width:50},    
	        {field:'reportName',title:'报表名称',width:100},    
	        {field:'procedureName',title:'后台程序名',width:100},
	        {field:'developerName',title:'开发人员',width:100},
	        {field:'manager',title:'负责人',width:100},
	        {field:'level',title:'重要级别',width:50},
	        {field:'levelVal',title:'重要级别',hidden:true},
	        {field:'expectationDate',title:'期望日期',width:50},
	        {field:'actualDate',title:'实际日期',width:50},
	        {field:'online',title:'是否云化上线',width:50},
	        {field:'onlineVal',title:'是否云化上线',hidden:true},
	        {field:'maintenance',title:'是否交维',width:50},
	        {field:'maintenanceVal',title:'是否交维',hidden:true}
	    ]],
	    fitColumns: true,
	    singleSelect:true,
	    pagination:true,
	    onLoadSuccess: function (data) {
            if (data.total == 0) {
                //添加一个新数据行，第一列的值为你需要的提示信息，然后将其他列合并到第一列来，注意修改colspan参数为你columns配置的总列数
                $(this).datagrid('appendRow', { reportId: '<div style="text-align:center;color:red">没有相关记录！</div>' }).datagrid('mergeCells', { index: 1, field: 'reportId', colspan: 14 })
                //隐藏分页导航条，这个需要熟悉datagrid的html结构，直接用jquery操作DOM对象，easyui datagrid没有提供相关方法隐藏导航条
                $(this).closest('div.datagrid-wrap').find('div.datagrid-pager').hide();
            }else{
            	//如果通过调用reload方法重新加载数据有数据时显示出分页导航容器
            	$(this).closest('div.datagrid-wrap').find('div.datagrid-pager').show();
            }
        },
	    toolbar:[{
			text:'新建',
			iconCls:'icon-add',
			handler:function(){
				clean();
				$('#addReportWind').dialog('open');
				$("#addReportWind").dialog("move",{top:$(document).scrollTop() + ($(window).height()-400) * 0.3});
			}
		},'-',{
			text:'修改',
			iconCls:'icon-edit',
			handler:function(){
				var row = getSelectRow();
				if(row){
					$('#addReportWind').dialog({title:'修改报表维护信息'});
					$('#addReportWind').dialog('open');
					$("#addReportWind").dialog("move",{top:$(document).scrollTop() + ($(window).height()-400) * 0.3});
					loadData(row);
				}
			}
		},'-',{
			text:'删除',
			iconCls:'icon-remove',
			handler:function(){
				var row = getSelectRow();
				if(row){
					$.messager.confirm('报表维护信息', '您确定删除该报表维护信息吗？', function(r){
						if (r){
						    $.ajax({
								url : mvcPath+'/report/maintenance/delete/' +row.id,
								type:"post",
								success:function(data){
									if(data.status){
										$.messager.alert('报表维护信息',data.msg,'info');
										$("#reportMaintenance").datagrid('reload');
									}else{
										$.messager.alert('报表维护信息',data.msg,'warning');
									}
								}
							});
						}
					});
				}
			}
		}]
	});
	
	$('#addReportWind').dialog({
		width: 600,
		height: 400,
		modal: true,
		closed: true,
		closable: true,
		maximizable: false,
		minimizable: false,
		collapsible: false,
		title: '新增报表维护信息',
		onOpen:function(){
			console.log("open dialog");
		},
		buttons: [{
			text: '保存',
			iconCls: 'icon-ok',
			handler: function() {
				if(check()){
					var data = getSaveData();
					$.ajax({
						url : mvcPath+'/report/maintenance/save',
						data : JSON.stringify(data),
						dataType: 'json',
						contentType:'application/JSON;charset=UTF-8', 
						type:"post",
						success:function(data){
							if(data.status){
								$.messager.alert('报表维护信息',data.msg,'info');
								$('#addReportWind').dialog('close');
								$("#reportMaintenance").datagrid('reload');
								clean();
							}else{
								$.messager.alert('报表维护信息',data.msg,'error');
							}
						}
					});
				}
			}
		}, {
			text: '取消',
			handler: function() {
				$('#addReportWind').dialog('close');
			}
		}]
	});
});