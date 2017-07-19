<%@ page language="java" import="java.util.*" pageEncoding="Utf-8"%>


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>GTW网络流量</title>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/js/ext/resources/css/ext-all.css" />
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-base.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/js/ext/ext-all.js"></script>
		<script type="text/javascript"
			src="${mvcPath}/hbapp/resources/chart/FusionCharts.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/resources/css/default/default.css" />
		<link rel="stylesheet" type="text/css"
			href="${mvcPath}/hbapp/app/flowOperation/gtwNetFlow/css/gtwNetFlow.css" />
		<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/util.js" charset=utf-8></script>
<script type="text/javascript">
Ext.onReady(function(){
	var tempDate = new Date();
	var year = tempDate.getYear();
	var month = tempDate.getMonth();
	tempDate = new Date(year,month);
	tempDate.setMonth(tempDate.getMonth() - 1);//上月
	var month = tempDate.format("yyyymm");
	$('time_id').value=month;
	
function query(){
	loadGridData();	
	loadPieData();
	loadLineData();
}
	function loadGridData(){
		var time_id = $('time_id').value;
		var cityCode=$('cityCode').value;
		Ext.Ajax.request({
			url:"${mvcPath}/hbapp/app/flowOperation/gtwNetFlow/gtwNetFlowGridData.jsp",
			params:{
				time_id:$('time_id').value,
				cityCode:$('cityCode').value
				},
			success:function(res, option){
				var ret = Ext.util.JSON.decode(res.responseText);
				var gridData = ret.gridData;
				var arr = gridData.split("|");
				$("area").innerHTML=arr[7];
				$("gsm_v").innerHTML=arr[0]+"G";
				$("g_per").innerHTML=arr[1];
				$("td_v").innerHTML=arr[2]+"G";
				$("t_per").innerHTML=arr[3];
				$("wlan_v").innerHTML=arr[4]+"G";
				$("w_per").innerHTML=arr[5];
				$("total").innerHTML=arr[6]+"G";
			}
		});
	
	}

	function loadPieData(){    
	var time_id = $('time_id').value;
	var cityCode=$('cityCode').value;
		Ext.Ajax.request({
			url:"${mvcPath}/hbapp/app/flowOperation/gtwNetFlow/gtwNetFlowPieData.jsp",
			params:{
				time_id:$('time_id').value,
				cityCode:$('cityCode').value
				},
			success:function(res, option){
				var ret = Ext.util.JSON.decode(res.responseText);
				Ext.fly("piechart").update('');
				var xmlPie = ret.xmldata;	
				var pieChart = new FusionCharts("${mvcPath}/hbapp/resources/chart/chart/Pie2D.swf?ChartNoDataText=暂无统计数据",
							"chartName1", "400", "240", "0", "0");
				pieChart.setDataXML(xmlPie);
				pieChart.render("piechart");
			}
		});
	}
	
	function loadLineData(){    
	var time_id = $('time_id').value;
	var cityCode=$('cityCode').value;
	//alert(cityCode);
		Ext.Ajax.request({
			url:"${mvcPath}/hbapp/app/flowOperation/gtwNetFlow/gtwNetFlowLineData.jsp",
			params:{
				time_id:$('time_id').value,
				cityCode:$('cityCode').value
				},
			success:function(response){
				var ret = Ext.util.JSON.decode(response.responseText);
				var xmlPie = ret.xmldata;				
				Ext.fly("linechars").update('');
				var lineChart = new FusionCharts("${mvcPath}/hbapp/resources/chart/chart/MSLine.swf?ChartNoDataText=暂无统计数据",
							"chartName1", "500", "240", "0", "0");
				lineChart.setDataXML(xmlPie);
				lineChart.render("linechars");
			}
		});
	}
	query();
	$("queryBtn").onclick = query;
	aihb.Util.loadmask();
	aihb.FormHelper.fillSelectWrapper({element:$('cityCode'),isHoldFirst:true,sql:"select area_code key,area_name value from mk.bt_area with ur"});
});	
</script>
	</head>
	<body>
		<div id="gtwNetFlow">
			<div class="header">
				<div id="dim_div">
					<table align='center' width='960px' class='grid-tab-blue'
						cellspacing='1' cellpadding='0' border='0' style="display: ''">
						<tr class='dim_row'>
							<td class=''>统计周期</td>
							<td class='' >
								<input align="right" type="text" id="time_id" name="time_id" value="201202" style="width:100px" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
							</td>
							<td class=''>
								地市
							</td>
							<td class=''>
								<select name='cityCode' id='cityCode' style="width: 200px">
									<option value="" >
										全省
									</option>
								</select>
							</td>
							<td>
								<input type="button"  type="button" id="queryBtn" class="form_button" value="查询">
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="bodyStyle">
				<div class="headerGrid">
					<div>
						<table class="tableData">
							<tr>
								<th>区域</th>
								<th>G网流量 </th>
								<th>GSM占比 </th>
								<th>T网流量 </th>
								<th>TD占比 </th>
								<th>WLAN流量</th>
								<th>WLAN占比 </th>
								<th>总流量 </th>
							</tr>
							<tr>
								<td class="area_td" id="area" name="area"></td>
								<td id="gsm_v" name="gsm_v"></td>
								<td id="g_per" name="g_per"></td>
								<td id="td_v" name="td_v"></td>
								<td id="t_per" name="t_per"></td>
								<td id="wlan_v" name="wlan_v"></td>
								<td id="w_per" name="w_per"></td>
								<td id="total" name="total"></td>
							</tr>
						</table>
						<div class=""></div>
					</div>
				</div>
				<div class="leftFusion" >
					<div id="piechart"></div>
					<div class="picTitle"></div>
				</div>
				<div class="rightFusion" >
					<div id="linechars"></div>
					<div class="picTitle"></div>
				</div>
			</div>
		</div>
	</body>
</html>
