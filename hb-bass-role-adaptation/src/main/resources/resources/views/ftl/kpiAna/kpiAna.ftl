<!DOCTYPE html>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>指标分析</title>
<link href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/css/bootstrap-datetimepicker.css">
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/font-icon/style.css" />
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/center.css" />
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/js/bootstrap-datetimepicker.js"></script>
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/jqLoading/js/jquery-ui-jqLoding.js"></script>
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/echarts.common.min.js"></script>
<script>
$(function(){
	
	quertData('${date}');
	
	$("#searchDate").datetimepicker({
		format: 'yyyy-mm-dd',
		weekStart: 1,  
        autoclose: true,  
        startView: 2,  
        minView: 2,  
        forceParse: false,
        todayHighlight : true,
		language: 'zh-CN'
	}).on('changeDate',function(){
		quertData($('#searchDate').val());
	});
	
});


function showAreaData(){
	var text = $("#dataBtn").val()=='数据展示'?'数据隐藏':'数据展示';
	$("#dataBtn").val(text);
	$('#areaDataCon').toggle();
}

function quertData(date){
	var replaceStr = "-";
	var date = date.replace( new RegExp(replaceStr,'gm'),'' );
	$("body").jqLoading();
	$.ajax({
		url: "${mvcPath}/kpi/" + ${bocId},
		type:"get",
		dataType: 'json',
		data: {
			queryDB: '0',
			date : date,
			dimCode : 'PROV_ID',
			dimVal : 'HB'
		},
		success: function(data, textStatus) {
			$('#areaDataCon').hide();
			if(data != null && data.length >1){
				initKpiTable(data[1]);
				initChartData(data);
				initAreaTable(data);
				$("body").jqLoading("destroy");
				return;
			}
			$("#chartCont").html('暂无数据……');
			$('#cityData').html("");
			$("#kpiData").html("")
			$("body").jqLoading("destroy");
		},
		error:function(){
			alert("数据加载失败");
			$("body").jqLoading("destroy");
		}
	});
}

function initChartData(data){
	var currentArr=[];
	var yoyArr=[];
	var chainArr=[];
	var cityArr=[];
	for(var i=2; i<data.length; i++){
		cityArr.push(data[i].regionName);
		currentArr.push(data[i].dailyCurrent);
		yoyArr.push(data[i].dailyComparedLastMonth);
		chainArr.push(data[i].dailyComparedYesterday);
	}
	
	var myChart = echarts.init(document.getElementById('chartCont'));
	Option = {
		backgroundColor:'#fff',
		tooltip : {
      		trigger: 'axis'
		},
		color:['rgba(58, 160, 218, 1)','rgba(255, 102, 102, 1)','rgba(179, 226, 149, 1)'],
		calculable : false,
		legend: {	
           orient: 'horizontal',
		   x: 'right',
		   y:"top",
      	   data:['当前值','同比','环比']
		},
		xAxis : [
      	{
          type : 'category',
          axisLabel :{
			interval:0,
		  },
          data : cityArr
      	}],
		yAxis : [{
          type : 'value',
          name:'单位(万元)',
          axisLabel : {
              formatter: '{value}'
          }
      	},
      	{
          type : 'value',
          axisLabel : {
              formatter: '{value}%'
          }
  	 }
	],
	series : [
      {
          name:'当前值',
          type:'bar',
          barWidth:30,
          data:currentArr,
          itemStyle:{
          	normal:{
          		color: function (params){
                    var colorList = ['#ab78ba','#72b201','#08a9f2','#B5C334','#FCCE10','#E87C25','#27727B','#FE8463'];
                    return colorList[params.dataIndex % 8];
                }
          	}
          }
      },
      {
          name:'同比',
          type:'line',
          yAxisIndex: 1,
          data:yoyArr
      },
      {
          name:'环比',
          type:'line',
          yAxisIndex: 1,
          data:chainArr
      }
	]};
	myChart.setOption(Option);
	
}

function initKpiTable(kpiData){
	var dataHtml = "<tr><td class='num'>" + valueNum(kpiData.dailyCurrent) + "</td>"
				 + "<td class='num'>" + valueParse(kpiData.dailyComparedYesterday) + "</td>"
				 + "<td class='num'>" + valueParse(kpiData.dailyComparedLastMonth) + "</td>"
				 + "<td class='num'>" + valueNum(kpiData.dailyAccumulation) + "</td>"
				 + "<td class='num'>" + valueParse(kpiData.dailyAccumulationComparedLastMonth) + "</td>"
				 + "<td class='num'>" + valueParse(kpiData.dailyAccumulationComparedLastYear) + "</td></tr>";
	$("#kpiData").html(dataHtml);
}

function initAreaTable(areaData){
	var areaHtml = "";
	for(var i=2; i<areaData.length ; i++){
		areaHtml += "<tr><td class='num'>" + areaData[i].regionName + "</td>"
				 + "<td class='num'>" + valueNum(areaData[i].dailyCurrent) + "</td>"
				 + "<td class='num'>" + valueParse(areaData[i].dailyComparedYesterday) + "</td>"
				 + "<td class='num'>" + valueParse(areaData[i].dailyComparedLastMonth) + "</td>"
				 + "<td class='num'>" + valueNum(areaData[i].dailyAccumulation) + "</td>"
				 + "<td class='num'>" + valueParse(areaData[i].dailyAccumulationComparedLastMonth) + "</td>"
				 + "<td class='num'>" + valueParse(areaData[i].dailyAccumulationComparedLastYear) + "</td></tr>"
	}
	$('#cityData').html(areaHtml);
}

function valueNum(value){
	var reVal = "--";
	if(value != null && value!='' && value!=undefined){
		reVal = value;
	}
	return reVal;
}

function valueParse(value){
	var reVal = "--"
	if(value != null && value!='' && value!=undefined ){
		if(value == 0){
			reVal = value + "<span class='icon-swap-right' style='color:#777'></span>";
		}else if(value >0){
			reVal = value + "%<span class='icon-swap-up' style='color:#4BB901'></span>";
		}else if(value <0){
			reVal = value + "%<span class='icon-swap-down' style='color:red'></span>";
		}
	}
	return reVal;
}
</script>
</HEAD>
<BODY>
	<div class="coll-wrap">
		<div class="kpi-container">
			<div class="con-title">
				<span id='kpiName' class="con-title-text pl2">${kpiName}</span> 
				日期：<input id="searchDate" readonly value='${date}' class="arrow-control inp-box date-inp">
			</div>
			<div>
				<table class="report-table">
					<thead>
						<tr>
							<td class="num" style="width: 16.6%">日</td>
							<td class="num" style="width: 16.6%">较昨日</td>
							<td class="num" style="width: 16.6%">较上月同期</td>
							<td class="num" style="width: 16.6%">日累计</td>
							<td class="num" style="width: 16.6%">较昨日</td>
							<td class="num" style="width: 16.6%">较去年同期</td>
						</tr>
					</thead>
					<tbody id="kpiData">
					</tbody>
				</table>
			</div>
			<div>
				<input id="dataBtn" type="button" class="btn-search" onclick="showAreaData();" value="数据展示" style="margin-left:2%;">
				<input type="button" class="btn-search" onclick="downAreaData();" value="数据导出" style="display:none;">
				<div id="chartCont" class="chart-container"></div>
				<div id="areaDataCon" class="data-table-cont" style="display:none;">
					<table class="report-table">
						<thead>
							<tr>
								<td class="num" style="width: 14.2%">区域</td>
								<td class="num" style="width: 14.3%">日</td>
								<td class="num" style="width: 14.3%">较昨日</td>
								<td class="num" style="width: 14.3%">较上月同期</td>
								<td class="num" style="width: 14.3%">日累计</td>
								<td class="num" style="width: 14.3%">较昨日</td>
								<td class="num" style="width: 14.3%">较去年同期</td>
							</tr>
						</thead>
						<tbody id="cityData">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</BODY>
</HTML>