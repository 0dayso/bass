<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>指标波动性展示</title>
<link rel="stylesheet" href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css"/>
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/lib/bootstrapDatepicker/css/bootstrap-datetimepicker.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/gbas.css">
<script src="${mvcPath}/resources/lib/jquery/js/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/bootstrapDatepicker/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/lib/bootstrapMultiselect/multiselect.min.js"></script>
<script src="${mvcPath}/resources/lib/echarts/echarts.common.min.js"></script>
<script src="${mvcPath}/resources/lib/echarts/theme/macarons.js"></script>
<script>
var gbasList = ${gbasList};
$(function(){
	initDatePicker();
	resetCodeOption();
	$('#undo_redo').multiselect();
});

function changeCycle(){
	var cycle = $("#cycle").val();
	if(cycle == "daily"){
		$(".daily-time").show();
		$(".monthly-time").hide();
	}else{
		$(".monthly-time").show();
		$(".daily-time").hide();
	}
	resetCodeOption();
}

function resetCodeOption(){
	var type = $("#type").val();
	var cycle = $("#cycle").val();
	var codes = new Array();
	if(type == 'zb'){
		codes = gbasList.zbList;
	}else if(type == 'rule'){
		codes = gbasList.ruleList;
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
    	alert("请选择需要分析的指标");
    	return;
    }
    var type = $("#type").val();
	var cycle = $("#cycle").val();
	var startTime;
	var endTime;
	if(cycle == "daily"){
		startTime = $("#startTimeD").val();
		endTime = $("#endTimeD").val();
	}else{
		startTime = $("#startTimeM").val();
		endTime = $("#endTimeM").val();
	}
	
	if(endTime != '' && startTime > endTime){
		alert("开始时间需晚于结束时间");
		return;
	}
	$.ajax({
		url: "${mvcPath}/analyse/getGbasData",
		type:"get",
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
		},
		error:function(data, textStatus){
			alert("查询指标数据出错");
		}
	});
}

function showChar(data){
	var myChart = echarts.init(document.getElementById('chartCont'),e_macarons);
	Option = {
		tooltip : {
	        trigger: 'axis'
	    },
	    legend: {
	        data:data.nameList
	    },
		xAxis : [
      	{
          type : 'category',
          axisLabel :{
			interval:0,
		  },
          data : data.timeList
      	}],
		yAxis : [{
          type : 'value',
          name:'值',
          axisLabel : {
              formatter: '{value}'
          }
      	}
	],
	series : [
	]};
	var lineData = data.lineData;
	for(var j=0; j<lineData.length; j++){
		Option.series.push(lineData[j]);
	}
	myChart.setOption(Option);
}

function initDatePicker(){
	$("#startTimeD").datetimepicker(datePickerOption('yyyy-mm-dd', 2, 2));
	$("#endTimeD").datetimepicker(datePickerOption('yyyy-mm-dd', 2, 2));
	$("#startTimeM").datetimepicker(datePickerOption('yyyy-mm', 3, 3));
	$("#endTimeM").datetimepicker(datePickerOption('yyyy-mm', 3, 3));
}

function datePickerOption(format, startView, minView){
	return {
		format: format,
		weekStart: 1,  
        autoclose: true,  
        startView: startView,  
        minView: minView,
        forceParse: false,
        clearBtn: true,
        todayHighlight : true,
		language: 'zh-CN'
	};
}

function saveTemplate(){
	
}
</script>
</head>
<body>
	<div class='wrap'>
		<div>
			<label>类型</label>
			<select id="type" style="width:100px;height:30px;line-height:30px;" onchange="resetCodeOption()">
				<option value='zb'>指标</option>
				<option value='rule'>规则</option>
				<option value='export'>接口</option>
			</select>
			<label style="margin-left:15px;">周期</label>
			<select id="cycle" style="width:100px;height:30px;line-height:30px;" onchange="changeCycle()">
				<option value="daily">日</option>
				<option value="monthly">月</option>
			</select>
			<label style="margin-left:10px;">时间周期</label>
			<input class="arrow-control daily-time" type="text" id="startTimeD" readonly style="height:30px;line-height:30px;">
			<input class="arrow-control monthly-time" type="text" id="startTimeM" readonly style="display:none;height:30px;line-height:30px;">
			<span>~</span>
			<input class="arrow-control daily-time" type="text" id="endTimeD" readonly style="height:30px;line-height:30px;">
			<input class="arrow-control monthly-time" type="text" id="endTimeM" readonly style="display:none;height:30px;line-height:30px;">
			<input class="qry-btn" onclick="queryGbasData()" type="button" value='查询'>
			<input class="qry-btn" onclick="saveTemplate()" type="button" value='保存为模板'>
			<div style="margin-top:10px;"><label>指标列表</label></div>
		</div>
		
		<div>
			<div style="width:40%; float:left;">  
                <select name="from" id="undo_redo" class="form-control" size="7" multiple="multiple">  
                </select>  
            </div>  
  
            <div style="width:16%; float:left; margin: 0 1%;">  
                <button type="button" id="undo_redo_rightAll" class="btn btn-default btn-block">  
                    <i class="glyphicon glyphicon-forward"></i>  
                </button>  
                <button type="button" id="undo_redo_rightSelected" class="btn btn-default btn-block">  
                    <i class="glyphicon glyphicon-chevron-right"></i>  
                </button>  
                <button type="button" id="undo_redo_leftSelected" class="btn btn-default btn-block">  
                    <i class="glyphicon glyphicon-chevron-left"></i>  
                </button>  
                <button type="button" id="undo_redo_leftAll" class="btn btn-default btn-block">  
                    <i class="glyphicon glyphicon-backward"></i>  
                </button>  
            </div>  
  
            <div style="width:40%; float:left;">  
                <select name="to" id="undo_redo_to" class="form-control" size="7" multiple="multiple"></select>  
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
</body>
</html>