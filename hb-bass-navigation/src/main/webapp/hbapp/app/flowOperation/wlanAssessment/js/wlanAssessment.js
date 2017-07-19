Ext.onReady(function(){
	
	var tempDate = new Date();
	var year = tempDate.getYear();
	var month = tempDate.getMonth();
	tempDate = new Date(year,month);
	tempDate.setMonth(tempDate.getMonth() - 1);//上月
	var month = tempDate.format("yyyymm");
	$('time_id').value=month;

function query(){
	loadOrderUserData();	
	loadOrderNewData();
	loadAvaFlow();
	loadAvargeDura();
	loadAvaIncome();
	loadDuraUse();
}
	
function loadOrderUserData(){    
	var time_id = $('time_id').value;
	var area_code=$('area_code').value;
	var county_code=$('county_code').value;
	var zone_code=$('zone_code').value;
	var fee_id=$('fee_id').value;
		Ext.Ajax.request({
			url:"/hbirs/action/wlanAssessment?method=getGprsOrderUser",
			params:{
				time_id:time_id,
				area_code:area_code,
				county_code:county_code,
				zone_code:zone_code,
				fee_id:fee_id
				},
			success:function(res, option){
				var ret = Ext.util.JSON.decode(res.responseText);
				Ext.fly("orderUserchart").update('');
				var xmlUser = ret.result;
				//alert(xmlUser)	
				var UserChart = new FusionCharts("/hbapp/resources/chart/chart/Line.swf?ChartNoDataText=",
							"chartName1", "460", "250", "0", "0");
				UserChart.setDataXML(xmlUser);
				UserChart.render("orderUserchart");
			}
		});
	}
	
	function loadOrderNewData(){    
	var time_id = $('time_id').value;
	var area_code=$('area_code').value;
	var county_code=$('county_code').value;
	var zone_code=$('zone_code').value;
	var fee_id=$('fee_id').value;
		Ext.Ajax.request({
			url:"/hbirs/action/wlanAssessment?method=getGprsOrderNew",
			params:{
				time_id:time_id,
				area_code:area_code,
				county_code:county_code,
				zone_code:zone_code,
				fee_id:fee_id
				},
			success:function(res, option){
				var ret = Ext.util.JSON.decode(res.responseText);
				Ext.fly("orderNewchart").update('');
				var xmlNew = ret.result;
				var NewChart = new FusionCharts("/hbapp/resources/chart/chart/Line.swf?ChartNoDataText=",
							"chartName1", "460", "250", "0", "0");
				NewChart.setDataXML(xmlNew);
				NewChart.render("orderNewchart");
			}
		});
	}
	
	function loadAvaFlow(){    
	var time_id = $('time_id').value;
	var area_code=$('area_code').value;
	var county_code=$('county_code').value;
	var zone_code=$('zone_code').value;
	var fee_id=$('fee_id').value;
		Ext.Ajax.request({
			url:"/hbirs/action/wlanAssessment?method=getAvarageFlow",
			params:{
				time_id:time_id,
				area_code:area_code,
				county_code:county_code,
				zone_code:zone_code,
				fee_id:fee_id
				},
			success:function(res, option){
				var ret = Ext.util.JSON.decode(res.responseText);
				Ext.fly("avaFlowchart").update('');
				var xmlAva = ret.result;
				//alert(xmlUser)	
				var AvaChart = new FusionCharts("/hbapp/resources/chart/chart/Line.swf?ChartNoDataText=",
							"chartName1", "300", "200", "0", "0");
				AvaChart.setDataXML(xmlAva);
				AvaChart.render("avaFlowchart");
			}
		});
	}
	function loadAvargeDura(){    
	var time_id = $('time_id').value;
	var area_code=$('area_code').value;
	var county_code=$('county_code').value;
	var zone_code=$('zone_code').value;
	var fee_id=$('fee_id').value;
		Ext.Ajax.request({
			url:"/hbirs/action/wlanAssessment?method=getAvargeDura",
			params:{
				time_id:time_id,
				area_code:area_code,
				county_code:county_code,
				zone_code:zone_code,
				fee_id:fee_id
				},
			success:function(res, option){
				var ret = Ext.util.JSON.decode(res.responseText);
				Ext.fly("avaDurationChart").update('');
				var xmlDuration = ret.result;
				//alert(xmlUser)	
				var durationChart = new FusionCharts("/hbapp/resources/chart/chart/Line.swf?ChartNoDataText=",
							"chartName1", "300", "200", "0", "0");
				durationChart.setDataXML(xmlDuration);
				durationChart.render("avaDurationChart");
			}
		});
	}
	
	function loadAvaIncome(){    
	var time_id = $('time_id').value;
	var area_code=$('area_code').value;
	var county_code=$('county_code').value;
	var zone_code=$('zone_code').value;
	var fee_id=$('fee_id').value;
		Ext.Ajax.request({
			url:"/hbirs/action/wlanAssessment?method=getAvargeIncome",
			params:{
				time_id:time_id,
				area_code:area_code,
				county_code:county_code,
				zone_code:zone_code,
				fee_id:fee_id
				},
			success:function(res, option){
				var ret = Ext.util.JSON.decode(res.responseText);
				Ext.fly("AvaIncomeChart").update('');
				var xmlIncome = ret.result;
				//alert(xmlUser)	
				var mouChart = new FusionCharts("/hbapp/resources/chart/chart/Line.swf?ChartNoDataText=",
							"chartName1", "300", "200", "0", "0");
				mouChart.setDataXML(xmlIncome);
				mouChart.render("AvaIncomeChart");
			}
		});
	}
	
	function loadDuraUse(){    
	var time_id = $('time_id').value;
	var area_code=$('area_code').value;
	var county_code=$('county_code').value;
	var zone_code=$('zone_code').value;
	var fee_id=$('fee_id').value;
		Ext.Ajax.request({
			url:"/hbirs/action/wlanAssessment?method=getDuraUse",
			params:{
				time_id:time_id,
				area_code:area_code,
				county_code:county_code,
				zone_code:zone_code,
				fee_id:fee_id
				},
			success:function(res, option){
				var ret = Ext.util.JSON.decode(res.responseText);
				Ext.fly("DuraUsechart").update('');
				var xmlUse = ret.result;
				//alert(xmlUser)	
				var UseChart = new FusionCharts("/hbapp/resources/chart/chart/Line.swf?ChartNoDataText=",
							"chartName1", "950", "270", "0", "0");
				UseChart.setDataXML(xmlUse);
				UseChart.render("DuraUsechart");
			}
		});
	}
	
	
	query();
	$("queryBtn").onclick = query;
	var area_code=$('area_code').value;
	var county_code=$('county_code').value;
	var zone_code=$('zone_code').value;
	var fee_id=$('fee_id').value;
	aihb.Util.loadmask();
	aihb.FormHelper.fillSelectWrapper({element:$('area_code'),isHoldFirst:true,sql:"select id key,name value from NWH.BUREAU_TREE where level=1 with ur"});
	var feesql="select fee_id key,fee_name value from NWH.gprs_fee where fee_id in ('EduWlan10','EduWlan20','EduWlan40','G70','G71','G2144','G2145','G2146','G220648','G220650','G220651','G220652') with ur";
	aihb.FormHelper.fillSelectWrapper({element:$('fee_id'),isHoldFirst:true,sql:feesql});
});	

function changeArea(){
				var area_code=$("area_code").value;
				if(area_code != -1){
				var sql="select id key ,name value from NWH.BUREAU_TREE where level=2 and pid='"+area_code+"' with ur";
				aihb.FormHelper.fillSelectWrapper({element:$('county_code'),isHoldFirst:true,sql:sql});				
				}else{
					$("county_code").options.length=1;
					$("county_code").value="请选择";
				}
}

function changeCounty(){
				var county_code=$("county_code").value;
				if(county_code != -1){
				var sql="select id key ,name value from NWH.BUREAU_TREE where level=3 and pid='"+county_code+"' with ur";
				//alert(sql);
				aihb.FormHelper.fillSelectWrapper({element:$('zone_code'),isHoldFirst:true,sql:sql});				
				}else{
					$("county_code").options.length=1;
					$("county_code").value="请选择";
				}
}
