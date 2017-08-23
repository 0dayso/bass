<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>指标波动性展示</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/bootstrap/easyui.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/jquery-easyui-1.5.1/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/lib/jquery/js/jquery-1.11.3.min.js"></script>
<script src="${mvcPath}/resources/lib/bootstrapMultiselect/multiselect.min.js"></script>
<script src="${mvcPath}/resources/lib/echarts/echarts.common.min.js"></script>
<script src="${mvcPath}/resources/lib/echarts/theme/macarons.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
<script src="${mvcPath}/resources/js/jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
<script src="${mvcPath}/resources/js/common.js"></script>
<script>
var gbasList = ${gbasList};
var type = "zb";
var cycle = "daily";
$(function(){
	$('#type').combobox({
	    valueField:'id',
	    textField:'text',
	    onSelect: function(rec){
	    	type = rec.id;
		    resetCodeOption();
	    }
	});
	
	$('#cycle').combobox({
	    valueField:'id',
	    textField:'text',
	    onSelect: function(rec){
	    	cycle = rec.id;
		    changeCycle();
	    }
	});
	
	initMonthPicker($("#startTimeM"));
	initMonthPicker($("#endTimeM"));
	resetCodeOption();
	$('#undo_redo').multiselect();
});

function changeCycle(){
	if(cycle == "daily"){
		$(".daily-box").show();
		$(".monthly-box").hide();
	}else{
		$(".monthly-box").show();
		$(".daily-box").hide();
	}
	resetCodeOption();
}

function resetCodeOption(){
	var codes = new Array();
	if(type == 'zb'){
		codes = gbasList.zbList;
	}
	
	var html = "";
	for(var i=0; i<codes.length; i++){
		if(codes[i].cycle == cycle){
			html += "<option value='" + codes[i].code + "'>" + codes[i].name + "</option>";
		}
	}
	$("#undo_redo").html(html);
	$("#undo_redo_to").html("");
}

function queryGbasData(){
	var gbasCodes = new Array();
	$("#undo_redo_to option").each(function(){
        gbasCodes.push($(this).val());
    });
    if(gbasCodes.length == 0){
    	$.messager.alert('提示','请选择需要分析的指标','info');
    	return;
    }
	var startTime;
	var endTime;
	if(cycle == "daily"){
		startTime = $("#startTimeD").datebox("getValue");
		endTime = $("#endTimeD").datebox("getValue");
	}else{
		startTime = $("#startTimeM").datebox("getValue");
		endTime = $("#endTimeM").datebox("getValue");
	}
	
	if(endTime != '' && startTime > endTime){
		$.messager.alert('提示','开始时间不能晚于结束时间','info');
		return;
	}
	loadMask();
	$.ajax({
		url: "${mvcPath}/analyse/getGbasData",
		type:"post",
		dataType: 'json',
		data: {
			cycle : cycle,
			gbasCodes: gbasCodes.toString(),
			startTime : startTime,
			endTime: endTime,
			type: type
		},
		success: function(data, textStatus) {
			showChar(data);
			unMask();
		},
		error:function(data, textStatus){
			alert("查询指标数据出错");
			unMask();
		}
	});
}

function showChar(data) {
    var myChart = echarts.init(document.getElementById('chartCont'), e_macarons);
    option = {
        tooltip: {
            trigger: 'axis'
        },
        legend: {
            data: data.nameList
        },
        xAxis: [{
            type: 'category',
            axisLabel: {
                interval: 0
            },
            data: data.timeList
        }],
        yAxis: [{
            type: 'value',
            name: '值',
            axisLabel: {
                formatter: '{value}'
            }
        }],
        series: []
    };
    var lineData = data.lineData;
    for (var j = 0; j < lineData.length; j++) {
        option.series.push(lineData[j]);
    }
    myChart.setOption(option);
}

function openAddDialog(){
	var gbasCodes = new Array();
	$("#undo_redo_to option").each(function(){
        gbasCodes.push($(this).val());
    });
    if(gbasCodes.length == 0){
    	$.messager.alert('提示','请先选择指标信息','info');
    	return;
    }
    $('#templateName').textbox('setValue','');
	$('#firstPageShow').combobox('setValue','1');
    $('#addDialog').dialog('open');
}

function saveTemplate(){
	var templateName = $("#templateName").val().trim();
	if(templateName.length == 0){
		$.messager.alert('提示','请输入模板名称','info');
		return;
	}
	var firstPageShow = $("#firstPageShow").val();
	var cycle = $("#cycle").combobox('getValue');
	var type = $("#type").combobox('getValue');
	var gbasCodes = new Array();
	$("#undo_redo_to option").each(function(){
        gbasCodes.push($(this).val());
    });
	$.ajax({
		url: "${mvcPath}/analyse/saveTemplate",
		type:"post",
		dataType: 'json',
		data: {
			cycle : cycle,
			name: templateName,
			isFirstPageShow : firstPageShow,
			type: type,
			gbasCode: gbasCodes.toString()
		},
		success: function(data, textStatus) {
			var wind = $.messager.alert('提示','保存成功','info');
			wind.window({onBeforeClose:function(){
				$('#addDialog').dialog('close');
			}});
		},
		error:function(data, textStatus){
			alert("保存模板出错");
		}
	});
}

function openManageDialog(){
	$("#qryTemplateName").val("")
	$('#manageDialog').dialog('open');
	var options = $('#manageTable').datagrid('options');
    options.url = '${mvcPath}/analyse/getTemplate';
    options.queryParams = {
		name : ''
	};
    $('#manageTable').datagrid(options);
}

function queryTemplate(){
	var qryTemplateName = $("#qryTemplateName").val().trim();
	$("#manageTable").datagrid("load", {
		name : qryTemplateName
	});
}

function tempplateOper(operType){
	var tempList = $('#manageTable').datagrid('getChecked');
	if (tempList.length == 0) {
		$.messager.alert("信息", "请至少选择一条模板信息", "info");
		return false;
	}
	
	var idArr = new Array();
	for(var i=0; i<tempList.length; i++){
		idArr.push(tempList[i].id);
	}
	
	$.ajax({
		url: "${mvcPath}/analyse/templageOper",
		type:"post",
		dataType: 'json',
		data: {
			operType : operType,
			ids: idArr.toString()
		},
		success: function(data, textStatus) {
			var wind = $.messager.alert('提示','操作成功','info');
			wind.window({onBeforeClose:function(){
				queryTemplate();
			}});
		},
		error:function(data, textStatus){
			alert("操作出错");
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

function formatFirstPageShow(value){
	if(value == "0"){
		return "否";
	}
	if(value == "1"){
		return "是";
	}
	return value;
}

function formatType(value){
	if(value == "zb"){
		return "指标";
	}
	if(value == "export"){
		return "接口";
	}
	return value;
}
</script>
</head>
<body>
	<div class='wrap'>
		<div style="height:30px; line-height:30px;">
			<label>类型</label>
			<select id="type" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="height:30px;width:100px;">
				<option value='zb'>指标</option>
				<option value='export'>接口</option>
			</select>
			<label style="margin-left:15px;">周期</label>
			<select id="cycle" class="easyui-combobox" data-options="editable:false,panelHeight:'auto'" style="height:30px;width:100px;">
				<option value="daily">日</option>
				<option value="monthly">月</option>
			</select>
			<label style="margin-left:10px;">时间周期</label>
			<span class="daily-box">
				<input class="easyui-datebox" style="height:30px;width:140px;" id="startTimeD" editable="false">
				<span>~</span>
				<input class="easyui-datebox" style="height:30px;width:140px;" id="endTimeD" editable="false">
			</span>
			<span class="monthly-box" style="display:none;">
				<input class="easyui-datebox" style="height:30px; width:140px;" id="startTimeM" editable="false">
				<span>~</span>
				<input class="easyui-datebox" style="height:30px;width:140px;" id="endTimeM"  editable="false">
			</span>
			<input class="qry-btn mar-l5" onclick="queryGbasData()" type="button" value='查询'>
			<input class="qry-btn" data-toggle="modal" onclick="openAddDialog()" type="button" value='保存为模板'>
			<input class="qry-btn" data-toggle="modal" onclick="openManageDialog()" type="button" value='模板管理'>
		</div>
		<div style="margin-top:10px;"><label>指标列表</label></div>
		<div>
			<div style="width:40%; float:left;">  
                <select name="from" id="undo_redo" class="form-control" multiple="multiple">  
                </select>  
            </div>  
            <div style="width:16%; float:left; margin: 0 1%;">  
                <button type="button" id="undo_redo_rightAll" class="mult-btn">
                	<span>&gt;&gt;</span>
                </button>  
                <button type="button" id="undo_redo_rightSelected" class="mult-btn">
					<span>&gt;</span> 
                </button>  
                <button type="button" id="undo_redo_leftSelected" class="mult-btn">
                	<span>&lt;</span>
                </button>  
                <button type="button" id="undo_redo_leftAll" class="mult-btn">
                	<span>&lt;&lt;</span>
                </button>  
            </div>  
  
            <div style="width:40%; float:left;">  
                <select name="to" id="undo_redo_to" class="form-control" multiple="multiple"></select>  
            </div>  
		</div>
		<div style="clear:both;"></div>
		<div class="chart-box-title">
			<span>指标展示</span>
		</div>
		<div>
			<div id="chartCont" class="chart-container"></div>
		</div>
	</div>
	
	<!--保存模板-->
	<div id="addDialog" class="easyui-dialog" title="保存模板" data-options="
			modal:true,
			closed:true,
			width:430,
			height:200,
			buttons: [{
					text:'提交',
					handler:function(){
						saveTemplate();
					}
				},{
					text:'取消',
					handler:function(){
						$('#addDialog').dialog('close');
					}
				}]">
		<div class="mar-8" style="height:100px;">
			<div class="mar-b15">
				<div class="inp-lab"><span style="color:red;">*</span>模板名称:</div>
				<input id="templateName" name="templateName" class="easyui-textbox form-inp" style="width:75%;height:32px;">
			</div>
			<div class="mar-b15">
				<div class="inp-lab"><span style="color:red;">*</span>首页展示:</div>
				<select id="firstPageShow" name="firstPageShow" class="easyui-combobox form-inp" data-options="editable:false,panelHeight:'auto'" style="width:75%;height:32px;">
					<option value="1">是</option>
					<option value="0">否</option>
				</select>
			</div>
		</div>
	</div>
	<!--保存模板-->
	<!--模板管理-->
	<div id="manageDialog" class="easyui-dialog" title="模板管理" data-options="
			modal:true,
			closed:true,
			width:700,
			height:400,
			buttons: [{
					text:'设置首页展示',
					handler:function(){
						tempplateOper('setShow');
					}
				},{
					text:'取消首页展示',
					handler:function(){
						tempplateOper('cancelShow');
					}
				},{
					text:'删除',
					handler:function(){
						tempplateOper('del');
					}
				},{
					text:'取消',
					handler:function(){
						$('#manageDialog').dialog('close');
					}
				}]">
		<table id="manageTable" class="easyui-datagrid" style="height:auto;"
		    data-options="fit:true,fitColumns:true,singleSelect:false,rownumbers:true,toolbar:'#manageTb'">
		    <thead>
				<tr>
					<th data-options="field:'id',checkbox:true"></th>
					<th data-options="field:'name',width:120">模板名称</th>
					<th data-options="field:'type',width:60,formatter:formatType">类型</th>
					<th data-options="field:'cycle',width:60,formatter:cycleReplace">周期</th>
					<th data-options="field:'is_first_page_show',width:60,formatter:formatFirstPageShow">首页展示</th>
					<th data-options="field:'create_time',width:120">创建时间</th>
				</tr>
		    </thead>
		</table>
	</div>
	<!--模板管理-->
	<div id="manageTb" style="padding:5px;height:auto">
		<div style="padding: 3px;">
			<span>模板名称</span>
			<input id="qryTemplateName">
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="queryTemplate()">查询</a>
		</div>
	</div>
</body>
</html>