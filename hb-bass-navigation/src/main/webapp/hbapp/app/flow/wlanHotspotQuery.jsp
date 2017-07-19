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
	obj.title="点击查看WLAN热点信息";
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
	var label = new BMap.Label(_dataJson.hotspot_name,{"offset":new BMap.Size(23, -10)});
	label.setStyle({
        //color : "red",
        fontSize : "12px"
        ,border: "0px"
        ,paddingTop: "2px"
        ,backgroundColor: "red"
    });
	_marker.setLabel(label);
	
	var data = '<div class="mhc_title">'+_dataJson.hotspot_name+'</div><div class="add_ct"><b>所属地市：</b>'+_dataJson.area_name+'</div><div class="add_ct"><b>所属县域：</b>'+_dataJson.county_name+'</div><div class="add_ct"><b>热点使用户数：</b>'+_dataJson.user_nums+'</div><div class="add_ct"><b>热点使用时长：</b>'+_dataJson.dura+'分</div><div class="add_ct"><b>热点使用流量：</b>'+_dataJson.flow+'MB</div><div class="add_ct"><b>经度：</b>'+_dataJson.lng+'</div><div class="add_ct"><b>维度：</b>'+_dataJson.lat+'</div>';
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
			"dataIndex":"hotspot_name",
			"name":["基站名称"],
			"title":"",
			"cellFunc":"_click"
		}];
function genSQL(){
	var condiPiece = "";
	if($("cycle_id").value!=""){
		month = $("cycle_id").value;
	}
	if($("HOTSPOT_NAME").value!=""){//热点名称
		condiPiece += " and HOTSPOT_NAME like '%"+$("hotspot_name").value+"%''";
	}
	if($("county_bureau").value!=""){//选了县域
			var county_name=document.getElementById("county_bureau").options[document.getElementById("county_bureau").selectedIndex].innerHTML;
			condiPiece+=" and county_name like '%"+county_name+"%'";
		}else{
			if($("city").value!=0){//地市
				condiPiece+=" and area_name in ( select name from NWH.BUREAU_TREE where id='"+aihb.Constants.getArea($("city").value).regionCode+"')";
			}
		}
	var sql = "select hotspot_name,area_name, county_name, hotspot_id, user_nums,hotspot_active_nums, value(sum_dura/60,0) as dura,  value(totalbyte/1024/1024,0) as flow,longitude as lng,latitude  as  lat";
	sql+=" from nmk.wlan_hotspot_analyse_"+month ; 
	sql+=" where hotspot_name is not null"+ condiPiece;
	//var sql = "select bureau_id,bureau_name,area_code,county_code,zone_code,longitude,latitude from NWH.DIM_BUREAU_CFG where 1=1 ";
	
	sql+=" order by hotspot_name";
	sql = sql.replace("{month}",month);
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
					<input align="right" type="text" id="cycle_id" name="date1"  style="width:160px" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
					</td>
				</tr>	
				<tr class='dim_row'>
					<td class='dim_cell_title'>地市</td><td class='dim_cell_content'><%=BassDimHelper.areaCodeHtml("city",user.getCityId(),"{areacombo(1,true);}")%></select></td>
				</tr>
				<tr class='dim_row'>
					<td class='dim_cell_title'>县域</td><td class='dim_cell_content'><%=BassDimHelper.comboSeleclHtml("county_bureau","{areacombo(2,true);}")%></td>
				</tr>
				<tr class='dim_row'>
					<td class='dim_cell_title'>WLAN热点名称</td><td class='dim_cell_content'><input type="text" id="hotspot_name" name="hotspot_name" style="width:160px" /></td>
				</tr>
				<tr>
					<td colspan=2 align=center><input id="btn_query" type="button" class="form_button" value="查询" onClick="query()"></td>
				</tr>
			</table>
		</fieldset>
	
		<div id="sidebar1">
		<fieldset>
			<legend><table><tr>
				<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏"><img flag='1' href="${mvcPath}/hb-bass-primary/image/default/ns-expand.gif"></img>&nbsp;WLAN热点列表：</td>
				<td></td>
			</tr></table></legend>
			<div id="grid" style="display:none;"></div>
		</fieldset>
		</div>
	</div>
	</form>
	<div id="gis"></div>
</div>    
</body>
</html>
