var mvcPath = $("#mvcPath").val();
function check(){
	if($("#reportName").textbox('getText').length==0){
		$.messager.alert('自定义报表',"您必须填写报表名称",'error');
		return false;
	}
	
	if($("#selectValues")[0].length==0){
		$.messager.alert('自定义报表',"您必须选择一个以上的指标",'error');
		return  false;
	}
	return true;
}
function getSaveData(){
	var elems = $("#selectValues")[0];
	var reportMapList = new Array();
	for(var i=0; i<elems.options.length;i++){
		var e = $(elems.options[i]);
		reportMapList.push({
			indicatorMenuId : e.attr("value"),
			kpiCode : e.attr("code")
		})
	}
	var data = {};
	data.reportMapList = reportMapList;
	data.reportId = $("#reportId").val()||'';
	data.reportName = $("#reportName").textbox('getText')||'';
	data.reportDesc = $("#reportDesc").textbox('getText')||'';
	return data;
}
function getSelectRow(){
	var row = $("#customReports").datagrid('getSelected');
	if(!row){
		$.messager.alert('自定义报表',"您必须选择一条数据",'error');
		return;
	}
	return row;
}
		
function loadData(row){
	$("#reportId").val(row.reportId);
	$('#reportName').textbox('setText',row.reportName);
	$('#reportDesc').textbox('setText',row.reportDesc);
	var data={};
	data.reportId = row.reportId;
	$.ajax({
		url:mvcPath+'/custom/reports/querySelectReport',   
		method:'post',
		data: data,
		success:function(data){
			if(data && data.length>0){
				$("#selectValues").empty();
				for (var i = 0; i < data.length; i++) {
					$("#selectValues").append("<option value="+data[i].indicatorMenuId+" code='"+data[i].kpiCode+"' title='"+data[i].id+"'>"+data[i].id+"</option>");
				}
			}
		}
	});
}
function clean(){
	$("#reportId").val('');
	$('#reportName').textbox('setText','');
	$("#reportDesc").textbox('setText','');
	$("#appValues").empty();
	$("#selectValues").empty();
}
$(function(){			
	$("#customReports").datagrid({
		url:mvcPath+'/custom/reports/list',   
		method:'post',
		checkbox	:true,
		singleSelect:true,
	    columns:[[    
	      	{field:'ck',checkbox:true}, 
	        {field:'reportId',title:'自定义报表ID',width:100},    
	        {field:'reportName',title:'自定义报表名称',width:200},    
	        {field:'reportDesc',title:'自定义报表描述',width:400,align:'right'}    
	    ]],
	    fitColumns: true,
	    singleSelect:true,
	    pagination:true,
	    selectOnCheck:true,
	    onLoadSuccess: function (data) {
            if (data.total == 0) {
                //添加一个新数据行，第一列的值为你需要的提示信息，然后将其他列合并到第一列来，注意修改colspan参数为你columns配置的总列数
                $(this).datagrid('appendRow', { reportId: '<div style="text-align:center;color:red">没有相关记录！</div>' }).datagrid('mergeCells', { index: 0, field: 'reportId', colspan: 3 })
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
					$('#addReportWind').dialog({title:'修改自定义报表'});
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
					$.messager.confirm('自定义报表', '您确定删除该自定义报表吗？', function(r){
						if (r){
						    $.ajax({
								url : mvcPath+'/custom/reports/delete/' +row.reportId,
								type:"post",
								success:function(data){
									if(data.status){
										$.messager.alert('自定义报表',data.msg,'info');
										$("#customReports").datagrid('reload');
									}else{
										$.messager.alert('自定义报表',data.msg,'warning');
									}
								}
							});
						}
					});
				}
			}
		},'-',{
			text:'查看报表',
			handler:function(){
				var row = getSelectRow();
				if(row){
					window.parent.addTab(row.reportId,row.reportName,mvcPath+'/custom/reports/'+row.reportId);
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
		title: '新增自定义报表',
		buttons: [{
			text: '保存',
			iconCls: 'icon-ok',
			handler: function() {
				if(check()){
					var data = getSaveData();
					$.ajax({
						url : mvcPath+'/custom/reports/save',
						data : JSON.stringify(data),
						dataType: 'json',
						contentType:'application/JSON;charset=UTF-8', 
						type:"post",
						success:function(data){
							if(data.status){
								$.messager.alert('自定义报表',data.msg,'info');
								$('#addReportWind').dialog('close');
								$("#customReports").datagrid('reload');
								clean();
							}else{
								$.messager.alert('自定义报表',data.msg,'error');
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
	$('#kpiApp').combobox({
		data: [{
				"id": "daily_code",
				"selected": true,
				"text": "日指标"
			},
			{
				"id": "daily_cumulate_code",
				"text": "日累计指标"
			},
			{
				"id": "monthly_code",
				"text": "月指标"
			},
			{
				"id": "monthly_cumulate_code",
				"text": "月累计指标"
			}
		],
		width: 180,
		label: '指标类型:',
		valueField: 'id',
		textField: 'text',
		onSelect: function(record){
			console.log(record);
			codeType = record.id;
			selectKpiList();
		}
	});
	$('#kpiType').combobox({
		url: mvcPath+'/custom/reports/getCategory',
		width: 250,
		label: '指标应用:',
		valueField: 'id',
		textField: 'text',
		onSelect: function(record){
			console.log(record);
			category = record.id;
			selectKpiList();
		}
	});
});

function moveOptionLeft() {
	if($("#selectValues option").is(":selected"))
    {
		$("#selectValues option:selected").appendTo("#appValues");
    }
}

function moveOptionRight() {
	if($("#appValues option").is(":selected"))
    {
		var kpiAppType = $('#kpiApp').combobox('getValue');
		if($("#selectValues option").size()==0){
			var type = "DAY";
			if(kpiAppType=='daily_code'||kpiAppType=='daily_cumulate_code'){
				type = "DAY";
			}else{
				type="MONTH";
			}
			$("#selectValues").attr("type",type)
		}else{
			var type = $("#selectValues").attr("type");
			if(type=='DAY' &&!(kpiAppType=='daily_code'||kpiAppType=='daily_cumulate_code')){
				$.messager.alert('自定义报表',"只能选择日报表/日累计报表",'error');
				return;
			}
			
			if(type=='MONTH' &&!(kpiAppType=='monthly_code'||kpiAppType=='monthly_cumulate_code')){
				$.messager.alert('自定义报表',"只能选择月报表/月累计报表",'error');
				return;
			}
		}
		$("#appValues option:selected").appendTo("#selectValues"); 
    }
}
/*
 *  将列表中的元素向下移动位置
 * @e 操作的列表
 * 
 */
function moveDown(e) {
	i = e.selectedIndex;
	if(i < 0 || i >= (e.options.length - 1))
		return;
	var o = e.options[i];
	var o1 = e.options[i + 1];
	e.options.remove(i);
	e.options.remove(i);
	e.add(o1, i);
	e.add(o, i + 1);
}

/*
 *  将列表中的元素向上移动位置
 *  @e 操作的列表
 * 
 */
function moveUp(e) {
	i = e.selectedIndex;
	if(i <= 0)
		return;
	var o = e.options[i];
	var o1 = e.options[i - 1];
	e.options.remove(i);
	e.options.remove(i - 1);
	e.add(o, i - 1);
	e.add(o1, i);
}
var codeType = 'daily_code';//默认日指标
var category = '';
var menuIds = new Array();
var reportId = $("#reportId").val();
function selectKpiList(){
	if(!category){
		$.ajax({
			'url':mvcPath+'/custom/reports/getCategory',
			method: 'post',
			success:function(data){
				if(data&&data.length>0){
					category = data[0].id;
					initAppValues();//加载未选择的指标列表
				}
			}
		}); 
	}else {
		initAppValues();//加载未选择的指标列表
	}
}

function selectItems(){
	//从selectValue 下拉框中获取
	var elems = $("#selectValues")[0];
	var reportMapList = new Array();
	//清空数组
	menuIds = new Array();
	for(var i=0; i<elems.options.length;i++){
		var e = $(elems.options[i]);
		menuIds.push(e.attr("value"));
	}
}
function initAppValues(){
	selectItems();//获取已经选择的指标
	$.ajax({
		'url':mvcPath+'/custom/reports/getReportTypeList',   
		data:{
			codeType : codeType,
			category : category,
			menuIds : menuIds.join(",")
		},
		method: 'post',
		success:function(data){
			$("#appValues").empty();
			console.log(data);
			for (var i = 0; i < data.length; i++) {
				$("#appValues").append("<option value="+data[i].id+" code='"+data[i].kpicode+"' title='"+data[i].text+"'>"+data[i].text+"</option>");
			}
		}
	});
}