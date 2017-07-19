<%@ page language="java" pageEncoding="utf-8"%>
<html>
<head>
<title>指标关联分析</title>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/kpireport.css"/>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>

<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/jqueryui/jquery-1.8.0.min.js"></script>
<script type="text/javascript">
var timeId;
var chanCode ='HB';
$(function(){
	var now=new Date();
	now.setMonth(now.getMonth()-1);
 	timeId = now.format("yyyymm");
	getCity();
	$('#fileMonth').val(timeId);
});

function changeMonth(){
	WdatePicker({
		readOnly:true,
		dateFmt:'yyyyMM',
		onpicked:function(){
			timeId = $('#fileMonth').val();
			getKpiInfo(chanCode);
		}
	});
}

function getCity(){
	$.ajax({
		type : "post",
		url : "${mvcPath}/kpiReport/getCity",
		dataType:"json",
		data : "ds=web",
		success:function(data){
			var cityInfo = "";
			for(var i=0; i<data.length; i++){
				cityInfo += "<option value='" + data[i].code+ "'>" + data[i].name + "</option>";
			}
			$('#channel').html(cityInfo);
			chanCode = $('#channel').val();
			getKpiInfo(chanCode);
		}
	});
}

function channalChange(){
	chanCode = $('#channel').val();
	getKpiInfo(chanCode);
}

//指标列表初始化
function getKpiInfo(channelCode){
	$('#loadMask').show();
	$.ajax({
		type : "post",
		url : "${mvcPath}/kpiReport/getKpiInfo",
		dataType:"json",
		data : "timeId=" + timeId + "&channelCode=" + channelCode + "&ds=web",
		success:function(data){
			var info = "";
			for(var i=0; i<data.length; i++){
				info += "<tr zbcode='" + data[i].zbcode + "' rowindex=" + i + " channelcode=" + data[i].channelcode + " pid="+data[i].parentid+">";
				info += addKpiTd(data[i], 0);
				info += "</tr>";
			}
			$("#kpiInfo").html(info);
			$('#reportInfo').html("");
			$('#loadMask').hide();
			$("#kpiInfo tr").bind("dblclick", function(){
				rowDbClick($(this));
			});
		}
	});
}


//地市指标信息获取
function getKpiChannelInfo(elem){
	var zbcode= elem.attr('zbcode');
	var channelCode = elem.attr('channelcode');
	$('#loadMask').show();
	$.ajax({
		type : "post",
		url : "${mvcPath}/kpiReport/getChannelKpiInfo",
		dataType:"json",
		data : "timeId=" + timeId + "&channelCode=" + channelCode + "&zbCode=" + zbcode + "&ds=web",
		success:function(data){
			if(data.length == 0){
				$('#loadMask').hide();
				return;
			}
			var channelInfo = "";
			var mLeft = elem.attr("mleft") == undefined ? 1 : parseInt(elem.attr("mleft")) + 1;
			for(var i=0; i<data.length; i++){
				channelInfo +=  "<tr mleft='" + mLeft + "' class='insertChannInfo' zbcode='" + data[i].zbcode + "' rowindex=" + i + " channelcode=" + data[i].channelcode + ">";
				channelInfo += addKpiTd(data[i], mLeft);
				channelInfo += "</tr>";
			}
			elem.after(channelInfo);
			$("tr").removeClass("currentSelectRow");
			elem.addClass("currentSelectRow");
			$('#loadMask').hide();
			$("#kpiInfo tr").unbind("dblclick");
			$("#kpiInfo tr").bind("dblclick", function(){
				rowDbClick($(this));
			});
		}
	});
}

//查询下级指标信息
function queryKpiInfo(kid, channelcode){
	var elem = $('#kpi'+ kid);
	$('#loadMask').show();
	$.ajax({
		type : "post",
		url : "${mvcPath}/kpiReport/getKpiInfo",
		dataType:"json",
		data : "timeId=" + timeId + "&channelCode=" + channelcode + "&kId=" + kid + "&ds=web",
		success:function(data){
			elem.attr("src", "${mvcPath}/hbapp/resources/image/default/row-expand.gif");
			elem = elem.parent().parent().parent();
			var kpiLevelInfo = "";
			var mLeft = elem.attr("mleft") == undefined ? 1 : parseInt(elem.attr("mleft")) + 1;
			for(var i=0; i<data.length; i++){
				kpiLevelInfo +=  "<tr mleft='" + mLeft + "' class='insertKpiInfo' zbcode='" + data[i].zbcode + "' rowindex=" + i + " channelcode=" + data[i].channelcode + " pid=" + data[i].parentid + ">";
				kpiLevelInfo += addKpiTd(data[i], mLeft);
				kpiLevelInfo += "</tr>";
			}
			elem.after(kpiLevelInfo);
			$("tr").removeClass("currentSelectRow");
			elem.addClass("currentSelectRow");
			$('#loadMask').hide();
			$("#kpiInfo tr").unbind("dblclick");
			$("#kpiInfo tr").bind("dblclick", function(){
				rowDbClick($(this));
			});
		}
	});
}

function addKpiTd(_data, mLeft){
	var marginLeft = "";
	if(mLeft != 0){
		marginLeft = "margin-left:" + parseInt(mLeft)*18 + "px;";
	}
	var info = "<td style='width:260px;'>";
	info +="<div style='" + marginLeft + "'>";
	if(_data.childcnt != null && _data.childcnt >0){
		info +="<img class='collImg' id='kpi" + _data.id + "' src='/hbapp/resources/image/default/row-collapse.gif' onclick=onIconClick(" + _data.id + ",'" + _data.channelcode + "');></img>" ;
	}else{
		info +="<span class='marl19'></span>";
	}
	info += _data.name + "</div></td>";
			
	info += "<td style='width:140px;'>" + _data.value + "</td>";
	if(_data.lastmonth != null){
		info += "<td style='width:140px;'>" + _data.lastmonth + "</td>";
	}else{
		info += "<td style='width:140px;'>-</td>";
	}
	
	if(_data.lastyear != null){
		info += "<td style='width:140px;'>" + _data.lastyear + "</td>";
	}else{
		info += "<td style='width:140px;'>-</td>";
	}
	
	if(_data.refid != null){
		info += "<td style='width:120px;'><a class='optBtn' onclick=getResourceInfo('" + _data.refid + "')>报表</a></td>";
	}else{
		info += "<td style='width:120px;'></td>";
	}
	return info;
}

//双击行
function rowDbClick(elem){
	var mleft = elem.attr("mleft") == undefined ? 0 : elem.attr("mleft");
	var removeCnt = 0;
	
	var elemChannelCode = elem.attr('channelcode');
	var elemZbCode = elem.attr('zbcode');
	var lastChannelCode = $("tr.currentSelectRow").attr('channelcode');
	var lastZbCode = $("tr.currentSelectRow").attr('zbcode');
	var hasCurrClass = $("tr").hasClass("currentSelectRow");

	changeDivIcon(mleft);
	
	$.each($("tr[mleft]"), function(){
		if(parseInt($(this).attr('mleft')) > parseInt(mleft)){
			$(this).remove();
			if($(this).hasClass("insertChannInfo")){
				removeCnt ++;
			}
		}
		
	});
	if(!hasCurrClass
			|| (!elem.hasClass("currentSelectRow") && ((elemChannelCode == chanCode && elemZbCode != lastZbCode)
					|| (elemChannelCode != chanCode && (elemZbCode != lastZbCode ||elemChannelCode != lastChannelCode ))))
			|| (removeCnt == 0 && elem.hasClass("currentSelectRow"))){
		getKpiChannelInfo(elem);
	}
	
}

//收缩、展开图标事件
function onIconClick(kid, channelcode){
	var elem = $('#kpi'+ kid);
	var mleft = elem.parent().parent().parent().attr("mleft") == undefined ? 0 : elem.parent().parent().parent().attr("mleft");
	var flag = false;
	
	$.each($("tr[mleft]"), function(){
		if(parseInt($(this).attr('mleft')) > parseInt(mleft)){
			//表示移除的是自己的下级指标
			if($(this).attr('pid') == kid){
				flag = true;
			}
			$(this).remove();
		}
	});
	
	changeDivIcon(mleft);
	
	if(!flag){
		queryKpiInfo(kid, channelcode);
	}
}

//收缩与扩展图标控制
function changeDivIcon(mleft){
	$.each($("tr[mleft]"), function(){
		if(parseInt($(this).attr('mleft')) == parseInt(mleft)){
			if($(this).find("img").length >0){
				var iconImg = $(this).find("img").attr("src", "${mvcPath}/hbapp/resources/image/default/row-collapse.gif");
// 				$(iconDiv).removeClass("iconExpand");
// 				$(iconDiv).addClass("iconCollapse");
			}
		}
	});
	
	if(parseInt(mleft) == 0){
		$.each($("tr:not([mleft])"), function(){
			if($(this).find("img").length >0){
				var iconImg = $(this).find("img").attr("src", "${mvcPath}/hbapp/resources/image/default/row-collapse.gif");
// 				$(iconDiv).removeClass("iconExpand");
// 				$(iconDiv).addClass("iconCollapse");
			}
		});
	}
}

function getResourceInfo(refid){
	$('#loadMask').show();
	$.ajax({
		type : "post",
		url : "${mvcPath}/kpiReport/getRportInfo",
		dataType:"json",
		data : "refId=" + refid + "&isNext=no&ds=web" ,
		success:function(data){
			var resInfo = "";
			for(var i=0; i<data.length; i++){
				resInfo += "<tr id=" + data[i].id+">";
				resInfo += addResourceTd(data[i], 0);
				resInfo += "</tr>";
			}
			$('#reportInfo').html(resInfo);
			$('#loadMask').hide();
			$("#reportInfo tr").bind("dblclick", function(){
				reportDbClick($(this));
			});
		}
	});
}

function getNextLevelReportInfo(element){
	var refid = element.attr("id");
	$('#loadMask').show();
	$.ajax({
		type : "post",
		url : "${mvcPath}/kpiReport/getRportInfo",
		dataType:"json",
		data : "refId=" + refid + "&isNext=yes&ds=web" ,
		success:function(data){
			var resInfo = "";
			var mLeft = element.attr("marleft") == undefined ? 1 : parseInt(element.attr("marleft")) + 1;
			for(var i=0; i<data.length; i++){
				resInfo += "<tr marleft='" + mLeft + "' id=" + data[i].id+">";
				resInfo += addResourceTd(data[i], mLeft);
				resInfo += "</tr>";
			}
			element.after(resInfo);
			$('#loadMask').hide();
			$("#reportInfo tr").unbind("dblclick");
			$("#reportInfo tr").bind("dblclick", function(){
				reportDbClick($(this));
			});
		}
	});
}

function addResourceTd(_data, mleft){
	var marginLeft = "";
	if(mleft != 0){
		marginLeft = "margin-left:" + parseInt(mleft)*18 + "px;";
	}
	
	var info = "<td style='padding-left:10px;'><div style='" + marginLeft + "'>" + _data.name + "</div></td>";
	info += "<td>" + _data.describe + "</td>";
	info += "<td><a class='optBtn' onclick=openReport('" + _data.name + "','" + _data.url + "')>查看</a></td>";
	return info;
}

function reportDbClick(element){
	var mleft = element.attr("marleft") == undefined ? 0 : element.attr("marleft");
	var removeCnt = 0;
	
	$.each($("tr[marleft]"), function(){
		if(parseInt($(this).attr('marleft')) > parseInt(mleft)){
			$(this).remove();
			removeCnt ++;
		}
		
	});
	if(removeCnt == 0){
		getNextLevelReportInfo(element);
	}
}

function openReport(name,url){
	$(".wrap").hide();
	var iframe = $('#ifm');
	$('#reportName').html(name);
	iframe.attr('src', url);
	$('#reportDetail').show();
	$('#loadMask').show();
	iframe.load(function(){
    	$('#loadMask').hide();
	});
	
}

function backHome(){
	$(".wrap").show();
	$('#reportDetail').hide();
}

var _header=[
         	{"name":"月份","dataIndex":"time_id","cellStyle":"grid_row_cell_text"}
         	,{"name":"地市","dataIndex":"channel_name","cellStyle":"grid_row_cell_text"}
         	,{"name":"父级指标编码","dataIndex":"parent_zb_code","cellStyle":"grid_row_cell_text"}
         	,{"name":"父级指标名称","dataIndex":"parent_zb_name","cellStyle":"grid_row_cell_text"}
         	,{"name":"指标编码","dataIndex":"zb_code","cellStyle":"grid_row_cell_text"}
         	,{"name":"指标名称","dataIndex":"zb_name","cellStyle":"grid_row_cell_text"}
         	,{"name":"月","dataIndex":"value","cellStyle":"grid_row_cell_text"}
         	,{"name":"上月","dataIndex":"last_month","cellStyle":"grid_row_cell_text"}
         	,{"name":"去年同期","dataIndex":"last_year","cellStyle":"grid_row_cell_text"}
         	];	
         	
function getSQL(){
	var sql = "select zbgl.time_id,  zbgl.channel_name,"
		 	+ "(select resource_id from kpi_report_indicator where id=le.parent_id) as parent_zb_code,"
		 	+ "(select name from kpi_report_indicator where id=le.parent_id) as parent_zb_name,"
		 	+ "zbgl.zb_code, zbgl.zb_name, zbgl.value, zbgl.last_month, zbgl.last_year from kpi_total_monthly_zbglfx zbgl"
			+ " left join kpi_report_indicator le on zbgl.zb_code=le.resource_id "
		 	+ "where time_id='" + timeId +"' order by zb_code, channel_code";
	return sql;
}

function downData(){
	aihb.AjaxHelper.down({
		sql : getSQL()
		,header : _header
		,ds : "web"
		,isCached : false
		,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
		,form : document.tempForm
	});
}

</script>
</head>
<body>
	<form name="tempForm" action=""></form>
	<div class="wrap">
		<div id="searchPanle" class="topBar1" >
			<div class='searchPad'>
				<div class="search">
	                <input type="text" class='Wdate wid150' id="fileMonth" onclick='changeMonth();'/>
	            </div>
				<div class="search marl19">
					<select id="channel" onchange="channalChange();">
					</select>
				</div>
				<div class='downD'>
					<a class='downBtn' onclick='downData();'>数据下载</a>
				</div>
			</div>
		</div>
		<div class='content1'>
			<table cellpadding="0" cellspacing="1" border="0" class='tableInfo'>
				<thead>
					<tr>
						<td class='tbHead' style='width:600px;'>指标名称</td>
						<td class='tbHead' style='width:150px;'>月</td>
						<td class='tbHead' style='width:150px;'>上月</td>
						<td class='tbHead' style='width:150px;'>去年同期</td>
						<td class='tbHead' style='width:120px;'>操作</td>
					</tr>
				</thead>
				<tbody id="kpiInfo">
				</tbody>
			</table>
		</div>
		<div class="topBar1 mart14">
			<div class='marl10'>相关报表</div>
		</div>
		<div class="content1">
			<table cellpadding="0" cellspacing="1" border="0" class='tableInfo'>
				<thead>
					<tr>
						<td class='tbHead' style='width:380px;'>报表名称</td>
						<td class='tbHead' style='width:650px;'>描述</td>
						<td class='tbHead' style='width:120px;'>操作</td>
					</tr>
				</thead>
				<tbody id="reportInfo">
				</tbody>
			</table>
		</div>
	</div>
	<div id="reportDetail" style="display: none;">
		<div id="detailTop">
			<ul class='detailTop'>
				<li class='topTitle'>当前位置：</li>
				<li>
					<a id='homePage' onclick='backHome()'>
						<div class='homeIcon'></div>首页
					</a>
				</li>
				<li class='divide'>></li>
				<li>
					<span id='reportName'></span>
				</li>
			</ul>
		</div>
		<div id="detailContent">
			<div class='ifmContainer'>
				<iframe id='ifm' width="100%" height="600" frameborder="0" marginwidth="0" marginheight="0" scrolling="auto"></iframe>
			</div>
		</div>
	</div>
	<div id='loadMask' style="display: none;">
		<div class='maskBody'>
			<span class='loadingIcon'></span>
			<div class='mart14'>加载中请稍候...</div>
		</div>
	</div>
</body>
</html>