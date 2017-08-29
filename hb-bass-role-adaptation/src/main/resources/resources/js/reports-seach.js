var mvcPath = $("#mvcPath").val();
var defaultDate = $("#defaultDate").val();
var reportId = $("#reportId").val();
var columnLength;
/**
 * 获取checkbox选中的值,返回值是一个数组
 * 
 * @param {Object}
 *            name
 */
function getCheckBoxValue(name) {
	var values = new Array();
	$('input[name="' + name + '"]:checked').each(function() {
		values.push($(this).val());
	});
	return values;
}
/**
 * 校验查询参数
 */
function checkData() {
	var kpiDate = $("#kpi_date").datebox('getValue');
	if (!kpiDate) {
		$.messager.alert('自定义报表查询', '请选择统计周期', 'info');
		return false;
	}
	return true;
}

/**
 * 查询县市下拉框
 * @returns
 */
function queryCountyList(record){
	if ($("#countyX").is(":checked")) { // 选中
		var areaCode = $("#cityList").combobox('getValue');
		if(record){
			areaCode = record.id;
		}
		if (areaCode) {
			var data ={};
			data.areaCode = areaCode;
			$("#countyList").combobox({
				disabled : false,
				url : 'getCountyList',
				width : 120,
				dataType:'json',
				onBeforeLoad: function (param) {  
                    param.areaCode = areaCode;  
                }, 
				valueField : 'id',
				textField : 'name',
				onSelect : function(record) {
				}
			});
		} else {
			$("#countyList").combobox({
				disabled : false
			});
		}

	} else {
		$("#countyList").combobox({
			disabled : true
		});
	}
}

function getQueryParameters() {
	var data = {};
	//自定义指标id
	data.reportId = $("#reportId").val()||'';
	var kpiDate = $("#kpi_date").datebox('getValue') || '';
	// 统计周期
	data.kpiDate = kpiDate;
	// 省市
	data.areaCode = $("#cityList").combobox('getValue') || '';
	// 是否细分县市
	var countyX = getCheckBoxValue("countyX");
	var countyXVal = '';
	if(countyX){
		countyXVal = countyX.join(",");
	}
	data.countyX = countyXVal;
	// 县市信息
	data.countyList = $("#countyList").combobox('getValue') || '';
	// 是否细分营销中心
	var marktingX = getCheckBoxValue("marktingX");
	var marktingXVal = '';
	if(marktingX){
		marktingXVal = marktingX.join(",");
	}
	data.marktingX = marktingXVal;
	// 营销中心信息 TODO $("#marketing_center").combobox('getValue') ||
	data.marketingCenters =  '';
	return data;
}

window.onload = function (){
	$("#kpi_date").datebox('setValue', $("#defaultDate").val());
}

$(function() {
	var type = $("#type").val();
	if(type == "MONTH_TYPE"){
		$("#kpi_date").datebox({
			formatter:monthFormat,
			parser:monthParse,
			required : true
		});
		
	}else{
		$("#kpi_date").datebox({
			formatter:dayFormat,
			parser:dayParse,
			required : true
		});
	}
	// 设置报表周期
	$("#kpi_date").datebox('setValue', defaultDate);
	// 查询省市信息
	$("#cityList").combobox({
		url : 'getCityList',
		width : 120,
		valueField : 'id',
		textField : 'name',
		onSelect : function(record) {
			queryCountyList(record);
		}
	});
	// 默认禁用县市细分
	$("#countyList").combobox({
		disabled : true
	});
	// 县市细分按钮
	$("#countyX").change(function(data) {
		if(getCheckBoxValue("countyX")){
			queryCountyList();
		} 
	});
	// 默认禁用营销中心细分
	$("#marketing_center").combobox({
		disabled : true
	});
	// 营销中心细分按钮
	$("#marktingX").change(function() {
		if ($("#marktingX").is(":checked")) { // 选中
			$("#marketing_center").combobox({
				disabled : false
			});
		} else {
			$("#marketing_center").combobox({
				disabled : true
			});
		}
	});

	$("#query").click(function() {
		if (checkData()) {
			$.ajax({
				url : 'query',
				method : 'post',
				type : 'json',
				
				data : getQueryParameters(),
				success : function(data) {
					if(data.header){
						columnLength = data.header.length;
						$('#reportDataGrid').datagrid({   
						    url: 'reportPageList',
						    columns:[data.header],
						    fitColumns: true,
						    pagination: true,
						    
						    onLoadSuccess: function (data) {
					            if (data.total == 0) {
					                //添加一个新数据行，第一列的值为你需要的提示信息，然后将其他列合并到第一列来，注意修改colspan参数为你columns配置的总列数
					                $(this).datagrid('appendRow', { CITY: '<div style="text-align:center;color:red">没有相关记录！</div>' }).datagrid('mergeCells', { index: 0, field: 'CITY', colspan: columnLength })
					                //隐藏分页导航条，这个需要熟悉datagrid的html结构，直接用jquery操作DOM对象，easyui datagrid没有提供相关方法隐藏导航条
					                $(this).closest('div.datagrid-wrap').find('div.datagrid-pager').hide();
					            }else{
					            	//如果通过调用reload方法重新加载数据有数据时显示出分页导航容器
					            	$(this).closest('div.datagrid-wrap').find('div.datagrid-pager').show();
					            }
					        },
						    queryParams: getQueryParameters()
						});
					}
				}
			});
		}
	});
	$("#download").click(function() {
		if (checkData()) {
			$.messager.alert("自定义报表查询", "下载报表信息", 'info');
		}
	});
});