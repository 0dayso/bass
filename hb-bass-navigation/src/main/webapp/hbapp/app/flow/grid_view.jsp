<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%@page import="com.asiainfo.hbbass.component.dimension.BassDimHelper"%>
<%User user = (User)session.getAttribute("user");
if(null == user){
	user = new User();
	user.setCityId("0");
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>湖北移动经营分析系统</title>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/bass21.css" />
<script type="text/javascript" src="http://api.map.baidu.com/api?key=9e62ccb3e5cf42f31598904c01abae5b&v=1.2" ></script>
<style>
.tabs {
    background-image:url( /hbapp/resources/image/default/tabs.gif ) !important;
}
.x-panel-header  {
	background-image:url(img/banner.png) ! important;
	background-repeat:repeat-x ! important;
	background-attachment:scroll ! important;
	background-position:right ! important;
}
.bannerTitle{
	position:relative;height:15px;
	color: #ffffff;
}
.x-border-layout-ct{background:#ffffff ! important;}

body { font-family:Verdana; font-size:14px; margin:0;}

#container {margin:0 auto; width:100%;height:100%;}
#sidebar { float:left; width:24%; height:100%;}
#sidebar1 { width:100%; }
#gis{ float:right;width:76%; height:98%;border:1px solid gray }
.mhc_title {
    height:24px;
    font-family:"宋体";
    color:blue;
}
.add_ct {
    color:#666;
    height:23px;
    font-size:12;
}
</style>
<script type="text/javascript">
var cityId = '<%=user.getCityId()%>';
var cityCode = cityId=="0"?"HB":aihb.Constants.getArea(cityId).cityCode;
var cityName = cityId=="0"?"湖北":aihb.Constants.getArea(cityId).cityName;
var map = undefined;
var grid=null;
var tempDate = new Date();
var year = tempDate.getYear();
var month = tempDate.getMonth();
tempDate = new Date(year,month);
tempDate.setMonth(tempDate.getMonth() - 1);//上月
var month = tempDate.format("yyyymm");
var _iw;
function _click(val,options){
	var obj=$C("a");
	obj.href="javascript:void(0)";
	obj.title="点击查看基站信息";
	obj.appendChild($CT(val));
	obj.onclick=function(){
		var point = addMakerPoint(options.record);
		//map.setCenter(point);
	    map.centerAndZoom(point, 15);
	    map.openInfoWindow(_iw,point);
		
	}
	return obj;
}

function addMakerPoint(_dataJson){
	var _point = new BMap.Point(_dataJson.lng, _dataJson.lat);
	var _marker = new BMap.Marker(_point);
	var label = new BMap.Label(_dataJson.bureau_name,{"offset":new BMap.Size(23, -10)});
	label.setStyle({
        //color : "red",
        fontSize : "12px"
        ,border: "0px"
        ,paddingTop: "2px"
        ,backgroundColor: "red"
    });
	_marker.setLabel(label);
	
	var data = '<div class="mhc_title">'+_dataJson.bureau_name+'</div><div class="add_ct"><b>使用次数：</b>'+_dataJson.gprs_times+'</div><div class="add_ct"><b>使用时长：</b>'+_dataJson.gprs_dura+'</div><div class="add_ct"><b>总流量：</b>'+_dataJson.totalbyte+'</div><div class="add_ct"><b>上行流量：</b>'+_dataJson.totalbyte_up+'</div><div class="add_ct"><b>下行流量：</b>'+_dataJson.totalbyte_down+'</div><div class="add_ct"><b>cmnet流量：</b>'+_dataJson.cmnet_totalbyte+'</div><div class="add_ct"><b>cmwap流量：</b>'+_dataJson.cmwap_totalbyte+'</div><div class="add_ct"><b>T网流量：</b>'+_dataJson.td_totalbyte+'</div><div class="add_ct"><b>G网流量：</b>'+_dataJson.gsm_totalbyte+'</div>';
	_iw = new BMap.InfoWindow(data);
	_marker.addEventListener("click",function(){
		this.openInfoWindow(_iw);
	});
	_iw.addEventListener("open",function(){
		_marker.getLabel().hide();
	})
	_iw.addEventListener("close",function(){
		_marker.getLabel().show();
	})
	label.addEventListener("click",function(){
		_marker.openInfoWindow(_iw);
	})
	map.addOverlay(_marker);
	return _point;
}
var _header= [
			 {
			"cellStyle":"grid_row_cell_text",
			"dataIndex":"bureau_name",
			"name":["基站名称"],
			"title":"",
			"cellFunc":"_click"
		}];
function genSQL(){
	var condiPiece = "";
	var condiPiece1 = "";
	var sql = "select b.town_name||'-'||b.bureau_name bureau_name,b.bureau_name name,b.lng,b.lat,sum(gprs_times) gprs_times, sum(gprs_dura) gprs_dura, sum(totalbyte) totalbyte,sum(totalbyte_up) totalbyte_up, sum(totalbyte_down) totalbyte_down, sum(cmnet_totalbyte) cmnet_totalbyte, sum(cmwap_totalbyte) cmwap_totalbyte,sum(td_totalbyte) td_totalbyte,sum(gsm_totalbyte) gsm_totalbyte ";
	sql+=" from nwh.gms_cell_gprs_{month} a "; 
	sql+=" ,(select bureau_name,lac_hex lac,cellid_hex cell,area_code,county_code,zone_code,town_name,longitude lng, latitude lat from nwh.dim_bureau_cfg where 1=1 {condiPiece}) b "; 
	sql+=" where a.lac=b.lac and a.cell = b.cell {condiPiece1} ";
	sql+=" group by bureau_name,town_name,lng,lat";
	//var sql = "select bureau_id,bureau_name,area_code,county_code,zone_code,longitude,latitude from NWH.DIM_BUREAU_CFG where 1=1 ";
	if($("bureau_name").value!=""){//
		condiPiece1 += " and name like %"+$("bureau_name").value+"%";
	}
	if($("marketing_center").value!=""){//选了营销中心
		condiPiece += " and zone_code='"+$("marketing_center").value+"'";
	}else{
		if($("county_bureau").value!=""){//选了县域
			condiPiece+=" and county_code='"+$("county_bureau").value+"'";
		}else{
			if($("city").value!=0){
				condiPiece+=" and area_code='"+aihb.Constants.getArea($("city").value).regionCode+"'";
			}
		}
	} 
	if($("cycle_id").value!=""){
		month = $("cycle_id").value;
	}
	if($("type").value!=""){
		if($("type").value=='G'){
			condiPiece1+=" and td_totalbyte=0";	
		}else{
			condiPiece1+=" and gsm_totalbyte =0";
		}
	}
	sql = sql.replace("{month}",month).replace("{condiPiece}",condiPiece).replace("{condiPiece1}",condiPiece1);
	return sql;
}		
function query(){
	grid=new aihb.AjaxGrid({
		header:_header
		,sql: genSQL()
		,isCached : ""
		,ds : ""
		,pageSize:15
		,map:true
		,callback:function(){
		}
	});
	//grid.ajax.url="/mvc/report/7675/query";
	grid.run();
}
aihb.Util.loadmask();
		
window.onload=function(){
	$("cycle_id").value=month;
	initMap();
}

function initMap(lng,lat){
    createMap(lng,lat);//创建地图
    setMapEvent();//设置地图事件
    addMapControl();//向地图添加控件
}

//创建地图函数：
function createMap(longitude,latitude){
    var map = new BMap.Map("gis");//在百度地图容器中创建一个地图
    var point;
  	//根据登陆工号的地市默认中心位置
	if(longitude){
		point = new BMap.Point(longitude,latitude);//定义一个中心点坐标	
	}else{
		var area = aihb.Constants.getArea(cityId);
		point = new BMap.Point(area.lng,area.lat);//定义一个中心点坐标
	}
    map.centerAndZoom(point,15);//设定地图的中心点和坐标并将地图显示在地图容器中
    window.map = map;//将map变量存储在全局
}

//地图事件设置函数：
function setMapEvent(){
    map.enableScrollWheelZoom();//启用地图滚轮放大缩小
    //map.enableKeyboard();//启用键盘上下左右键移动地图
}

//地图控件添加函数：
function addMapControl(){
	//向地图中添加缩放控件
	map.addControl(new BMap.NavigationControl());
	//向地图中添加比例尺控件
	map.addControl(new BMap.ScaleControl());
	map.addControl(new BMap.OverviewMapControl());
}

</script>
</head>
<body>
<div id="container">
	<form action="">
		<div id="sidebar">
		<fieldset>
		<legend><table><tr>
			<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏"><img flag='1' href="${mvcPath}/hb-bass-primary/image/default/ns-expand.gif"></img>&nbsp;查询条件区域：</td>
		</tr></table></legend>
		
			<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
				<tr class='dim_row'>
					<td class='dim_cell_title'>统计周期</td>
					<td class='dim_cell_content'>
					<input align="right" type="text" id="cycle_id" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
					</td>
				</tr>	
				<tr class='dim_row'>
					<td class='dim_cell_title'>地市</td><td class='dim_cell_content'><%=BassDimHelper.areaCodeHtml("city",user.getCityId(),"{areacombo(1,true);}")%></select></td>
				</tr>
				<tr class='dim_row'>
					<td class='dim_cell_title'>县域</td><td class='dim_cell_content'><%=BassDimHelper.comboSeleclHtml("county_bureau","{areacombo(2,true);}")%></td>
				</tr>
				<tr class='dim_row'>
					<td class='dim_cell_title'>营销中心</td><td class='dim_cell_content'><%=BassDimHelper.comboSeleclHtml("marketing_center","")%></td>
				</tr>
				<tr class='dim_row'>
					<td class='dim_cell_title'>网络</td><td class='dim_cell_content'><select id="type"><option value="">全部</option><option value="G">G网</option><option value="T">T网</option></select></td>
				</tr>
				<tr class='dim_row'>
					<td class='dim_cell_title'>基站名称</td><td class='dim_cell_content'><input type="text" id="bureau_name" name="bureau_name"/></td>
				</tr>
				<tr >
					<td colspan=2 align=center><input id="btn_query" type="button" class="form_button" value="查询" onClick="query()"></td>
				</tr>
			</table>
		</fieldset>
	
		<div id="sidebar1">
		<fieldset>
			<legend><table><tr>
				<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏"><img flag='1' href="${mvcPath}/hb-bass-primary/image/default/ns-expand.gif"></img>&nbsp;基站列表：</td>
				<td></td>
			</tr></table></legend>
			<div id="grid" style="display:none;"></div>
		</fieldset>
		</div>
	</div>
	</form>
<!-- 
	<div id="content">
		<div id="data">
			<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
				<tr class='dim_row'>
					<td class='dim_cell_title'>总流量</td><td class='dim_cell_content'><input type="text" id="c1" name="" readonly/></td>
					<td class='dim_cell_title'>上网时长</td><td class='dim_cell_content'><input type="text" id="c2" name="" readonly/></td>
				</tr>
				<tr class='dim_row'>
					<td class='dim_cell_title'>上网次数</td><td class='dim_cell_content'><input type="text" id="c3" name="" readonly/></td>
					<td class='dim_cell_title'>使用人数</td><td class='dim_cell_content'><input type="text" id="c4" name="" readonly/></td>
				</tr>
				<tr class='dim_row'>
					<td class='dim_cell_title'>投诉量</td><td class='dim_cell_content'><input type="text" id="c5" name="" readonly/></td>
					<td class='dim_cell_title'>平均流量</td><td class='dim_cell_content'><input type="text" id="c6" name="" readonly/></td>
				</tr>
				<tr class='dim_row'>
					<td class='dim_cell_title'>平均上网时长</td><td class='dim_cell_content'><input type="text" id="c7" name="" readonly/></td>
					<td class='dim_cell_title'>平均上网次数</td><td class='dim_cell_content'><input type="text" id="c8" name="" readonly/></td>
				</tr>
			</table>
		</div>
	</div>
 -->		
	<div id="gis"></div>
</div>    
</body>
</html>
