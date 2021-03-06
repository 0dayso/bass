var mvcPath = $("#mvcPath").val();
function ww4(date){  
    var y = date.getFullYear();  
    var m = date.getMonth()+1;  
    var d = date.getDate();  
    var h = date.getHours();  
    return  y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+(h<10?('0'+h):h);  
      
}  
function w4(s){  
	if (!s) return new Date();  
    var y = s.substring(0,4);  
    var m =s.substring(5,7);  
    var d = s.substring(8,10);  
    var h = s.substring(11,14);  
    var min = s.substring(15,17);  
    var sec = s.substring(18,20);  
    if (!isNaN(y) && !isNaN(m) && !isNaN(d) && !isNaN(h) && !isNaN(min) && !isNaN(sec)){  
        return new Date(y,m-1,d,h,min,sec);  
    } else {  
        return new Date();  
    }   
}
function monthFormat(date) {
	var y = date.getFullYear();
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var h = date.getHours();
	var minute = date.getMinutes();
	return(d < 10 ? ('0' + d) : d) + ' ' + (h < 10 ? ('0' + h) : h) + ":" + (minute < 10 ? ('0' + minute) : minute);
}
var myview = $.extend({}, $.fn.datagrid.defaults.view, {
	onAfterRender: function(target) {
		$.fn.datagrid.defaults.view.onAfterRender.call(this, target);
		var opts = $(target).datagrid('options');
		var vc = $(target).datagrid('getPanel').children('div.datagrid-view');
		vc.children('div.datagrid-empty').remove();
		if(!$(target).datagrid('getRows').length) {
			var d = $('<div class="datagrid-empty"></div>').html(opts.emptyMsg || 'no records').appendTo(vc);
			d.css({
				position: 'absolute',
				left: 0,
				top: 50,
				width: '100%',
				textAlign: 'center'
			});
		}
	}
});
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
	
	var expectationDate;
	var t = $("input[name='type']:checked").val();
	
	if(t==0){
		expectationDate = $("#time0").timespinner('getValue');
	}else if(t==1){
		expectationDate = $("#time1").combobox('getValue');
	}else if(t==2){
		expectationDate = $("#time2").datetimebox('getValue');
	}
	
	if(!expectationDate){
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
	var expectationDate;
	var t = $("input[name='type']:checked").val();
	
	if(t==0){
		expectationDate = $("#time0").timespinner('getValue');
	}else if(t==1){
		expectationDate = $("#time1").combobox('getValue');
	}else if(t==2){
		expectationDate = $("#time2").datetimebox('getValue');
	}
	data.expectationDate = expectationDate||'';
	return data;
}
function getSelectRow(){
	var row = $("#reportMaintenance").datagrid('getSelected');
	if(!row){
		$.messager.alert('报表维护信息',"您必须选择一条数据",'error');
		return;
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
	setExpectationDate(row);
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
	setExpectationDate();
}
function setExpectationDate(data){
	if(data && data.expectationDate){
		//修改
		//getAjaxType(data.reportId)
		var expectationDate = data.expectationDate;
		var length = expectationDate.length;
		if(length==5){
			$("input[name='type']").get(0).checked=true;
			$("#time0").timespinner('setValue',expectationDate);
			$("#date_div0").css("display","block");
		}
		if(length>=1 && length<=2){// 月报表   日
			$("input[name='type']").get(1).checked=true;
			$("#time1").combobox('setValue',expectationDate);
			$("#date_div1").css("display","block");
		}
		if(length==8){
			$("input[name='type']").get(2).checked=true;
			$("#time2").datetimebox('setValue',expectationDate);
			$("#date_div2").css("display","block");
		}
	}else{ // 清除数据
		$("input[name='type'][value=0]").attr("checked",false); 
		$("#time0").timespinner('setValue','');
		$("input[name='type'][value=1]").attr("checked",false); 
		$("#time1").combobox('setValue','');
		$("input[name='type'][value=2]").attr("checked",false); 
		$("#time2").datetimebox('setValue','');
	}
}

//ajax校验报表ID的报表类型
function getAjaxType(reportId){
	$.ajax({
		url : mvcPath+'/report/maintenance/getReportType',
		type:"post",
		data:{
			reportId: reportId
		},
		success:function(data){
			if(data){
				if(data=='day'){
					$("input[name='type']").get(0).checked=true;
				}else if(data=='month'){
					$("input[name='type']").get(2).checked=true;
				}
			}
		}
	});
}
$(function(){	
	setExpectationDate();
	//失去焦点判断报表类型
	$("input",$("#reportId").next("span")).blur(function(){  
		var reportId = $(this).val();
		if(reportId){
			getAjaxType(reportId);
		}
	});
	//单选按钮点击事件
	$(":radio").click(function() {
		var v = $(this).val();
		$("#date_div0").css("display","none");
		$("#date_div1").css("display","none");
		$("#date_div2").css("display","none");
		$("#date_div"+v).css("display","block");
	});
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
		width: 200,
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
		width: 132,
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
		width: 200,
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
		width: 132,
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
		width: 200,
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
		width: 132,
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
		view: myview,
		checkbox	:true,
		singleSelect:true,
		emptyMsg: '<span style="color:red;font-size:16px;">没有相关记录!<span>',
	    columns:[[    
	    	    {field:'ck',checkbox:true},
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
	    toolbar:[{
			text:'新建',
			iconCls:'icon-add',
			handler:function(){
				clean();
				$('#addReportWind').dialog({title:'新增报表维护信息'});
				$('#addReportWind').dialog('open');
				$("#addReportWind").dialog("move",{top:$(document).scrollTop() + ($(window).height()-400) * 0.3});
				$("#date_div0").css("display","none");
				$("#date_div1").css("display","none");
				$("#date_div2").css("display","none");
				$("input[name='type'][value=0]").attr("checked",false); 
				$("input[name='type'][value=1]").attr("checked",false); 
				$("input[name='type'][value=2]").attr("checked",false); 
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
					$("#date_div0").css("display","none");
					$("#date_div1").css("display","none");
					$("#date_div2").css("display","none");
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
		width: 400,
		height: 470,
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