//画趋势图
function chartTrend(kpiid){
	sArea = "'"+area+"'";
	durato=curDate;
	var _date=new Date(curDate.substring(0,4),curDate.substring(4,6)-1,curDate.substring(6,8));
	_date.setDate(_date.getDate()-10);
	durafrom=_date.format();
	chartWrapper({
		url: "/hbirs/action/kpi?method=chartCompare"
		,loadmask : true
		,param: "appName="+appName+"&area="+sArea+"&durafrom="+durafrom+"&durato="+durato+"&zbcode="+(kpiid||"G00004")
		,chartid:"trend"
		,chartSWF:"/hbapp/resources/chart/Charts/FCF_MSLine.swf"
		,width:document.body.offsetWidth/2-30
		,height:240
		,dataFilter: function(charData){
			var pattern=new RegExp(curDate.substr(0,4),"gm");
			return charData.replace(pattern,""); 
		}
	});
}

/**
url:
param:
loadmask:
chartid:
chartSWF:
width:
height:
*/
function chartWrapper(options){
	var ajax = new aihb.Ajax({
		url : options.url
		,parameters : options.param
		,loadmask : options.loadmask != undefined?options.loadmask:true
		,callback : function(xmlrequest){
			var data = xmlrequest.responseText;
			if(data==""){
			//alert("没有数据");
			}else{
				options.chartData=options.dataFilter?options.dataFilter(data):data;
				
				renderChart(options);
			}
		}
	});
	
	ajax.request();
}
/**
chartid:
chartSWF:
width:
height:
chartData:
*/
function renderChart(options){
	var chart = new FusionCharts(options.chartSWF, "ChartId", options.width, options.height);
	chart.setDataXML(encodeURIComponent(options.chartData.replace("%25","%")));
	chart.addParam("wmode","transparent");
	$(options.chartid).innerHTML = "";
	chart.render(options.chartid);
}

aihb.Grid.prototype.getPaging=function(){
	return undefined;
}
aihb.Util.watermark();

function cellFormat(val,options){
	return options.record.formatType!="percent"?aihb.Util.numberFormat(val):aihb.Util.percentFormat(val);		
}