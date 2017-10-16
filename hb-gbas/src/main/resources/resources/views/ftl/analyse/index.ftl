<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>波动性展示</title>
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
var cycle = '${cycle}';
$(function(){
	getTemplAnalyseData();
	if(cycle == 'monthly'){
		initMonthPicker($("#startDate"));
		initMonthPicker($("#endDate"));
	}
});

function getTemplAnalyseData(){
	var startTime = $("#startDate").datebox("getValue");
	var endTime = $("#endDate").datebox("getValue");
	if(endTime != '' && startTime > endTime){
		$.messager.alert('提示','开始时间不能晚于结束时间','info');
		return;
	}
	loadMask();
	$.ajax({
		url: "${mvcPath}/analyse/getTemplAnalyse",
		type:"post",
		dataType: 'json',
		data: {
			cycle : cycle,
			startTime: startTime,
			endTime: endTime
		},
		success: function(data, textStatus) {
			if(data.flag == -1){
				$.messager.alert('错误',data.msg,'error');
				unMask();
				return false;
			}
			if(data.length == 0){
				unMask();
				return false;
			}
			$("#templAna").html("");
			var charHtml = "";
			for(var i=0; i<data.length; i++){
				charHtml = "<div class='item-box'><div class='item-title'>" + data[i].name + "</div>"
					+ "<div id='templ_" + i + "' class='chart-item'></div></div>";
				$("#templAna").append(charHtml);
				initChar(data[i].anaData, 'templ_' + i);
			}
			unMask();
		},
		error:function(data, textStatus){
			unMask();
		}
	});
}

function initChar(data, id) {
    var myChart = echarts.init(document.getElementById(id), e_macarons);
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
                interval: 0,
                rotate: 20
            },
            data: data.timeList
        }],
        yAxis: [{
            type: 'value',
            name: '值',
            axisLabel: {
                formatter: '{value}',
                textStyle:{
                	color: '#333'
                }
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
</script>
</head>
<body class='wrap'>
	<div style="margin-bottom: 8px;">
		<label>时间周期：</label>
		<input id="startDate" name="startDate" editable="false" class="easyui-datebox form-inp" style="width:150px;height:30px;">
		<label>~</label>
		<input id="endDate" name="endDate" editable="false" class="easyui-datebox form-inp" style="width:150px;height:30px;">
		<input class="qry-btn mar-l5" onclick="getTemplAnalyseData()" type="button" value='查询'>
	</div>
	<div class="ana-box">
		<div class="ana-title">指标展示</div>
		<div id="templAna" class="ana-content"></div>
	</div>
</body>
</html>