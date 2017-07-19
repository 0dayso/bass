<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>营销资源管理</title>
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/center.css" />
<link rel="stylesheet" href="${mvcPath}/hb-power/common/ztree/zTreeStyle.css" type="text/css">
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/font-icon/style.css" />
<link href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/css/bootstrap-datetimepicker.css">
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-power/common/ztree/jquery.ztree.core-3.5.js"></script>
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/jqLoading/js/jquery-ui-jqLoding.js"></script>
<script>
var reportTree = null;
$(function(){
	initReportTree();
	$("#searchDate").datetimepicker({
		format: 'yyyy-mm',
		weekStart: 1,  
        autoclose: true,  
        startView: 3,  
        minView: 3,  
        forceParse: false,
        todayHighlight : true,
		language: 'zh-CN'
	});
	
	queryData();
});

function queryData(){
	var time = $("#searchDate").val();
	var areaCode = $("#areaSel").val();
	$("body").jqLoading();
	$.ajax({
        url: '${mvcPath}/minderApp/queryCostData',
        type: "POST",
        dataType: 'json',
        data: {
            time: time,
            areaCode: areaCode
        },
        success: function(data) {
        	data = eval(data);
            initPanel(data);
            $("body").jqLoading("destroy");
        },
        error:function(){
			alert("数据加载失败");
			$("body").jqLoading("destroy");
		}
    });
}

function initPanel(data){
	var costHtml = "";
	var costData = "";
	for(var i=0; i<data.length; i++){
		childData = data[i].child;
		costHtml +="<tr><td class='left-text' style='background-color: #f6fbfd;'>" + parseName(data[i], i) + "</td>"
					+ "<td class='right-text' style='background-color: #f6fbfd;'>" + formatMoney(data[i].cost_value) + "</td>"
					+ "<td class='right-text' style='background-color: #f6fbfd;'>" + formatMoney(data[i].lj_cost_value) + "</td>"
					+ "<td class='num' style='background-color: #f6fbfd;'>" + data[i].area_name + "</td>"
					+ "<td class='right-text' style='background-color: #f6fbfd;'>" + data[i].remark + "</td>"
					+ "</tr>";
		for(var j=0; j<data[i].child.length; j++){
			costHtml +="<tr class='child-item" + i + "' style='display:none;'><td class='left-text'>" + parseName(childData[j]) + "</td>"
					+ "<td class='right-text'>" + formatMoney(childData[j].cost_value) + "</td>"
					+ "<td class='right-text'>" + formatMoney(childData[j].lj_cost_value) + "</td>"
					+ "<td class='num'>" + childData[j].area_name + "</td>"
					+ "<td class='right-text'>" + childData[j].remark + "</td>"
					+ "</tr>";
		}
	}
	$("#costBody").html(costHtml);
}

var iconStyle= "display: inline-block;width: 15px;height: 15px;background-color: #C8E8FB;text-align: center;line-height: 15px;color: #fff;";
function parseName(coseData, index){
	var name ="";
	if(coseData.level == 0 && coseData.child.length>0){
		name = "<div><span id='item" + index + "' onclick='childItemCont(" + index + ");' class='icon-add span-btn' style='" + iconStyle + "'></span>" + coseData.cost_name + "</div>";
	}
	if(coseData.level == 0 && coseData.child.length==0){
		name = "<div><div class='blank-span'></div>" + coseData.cost_name + "</div>";
	}
	if(coseData.level == 1){
		name = "<div class='child-name-b'>" + coseData.cost_name + "</div>";
	}
	return name;
}

//格式化金额
function formatMoney(num) {
	var a = "" + num;
	var number = a;
	var numPoint = "00";
	if(a.indexOf(".")>0){
		var numArr = a.split(".");
		number = numArr[0];
		numPoint = numArr[1].length == 2?numArr[1]:(numArr[1]+'0');
	}
    if (number.length <= 3)
        return number + "." + numPoint;
    else {
        var mod = number.length % 3;
        var output = (mod == 0 ? '' : (number.substring(0, mod)));
        for (i = 0; i < Math.floor(number.length / 3); i++) {
            if ((mod == 0) && (i == 0))
                output += number.substring(mod + 3 * i, mod + 3 * i + 3);
            else
                output += ',' + number.substring(mod + 3 * i, mod + 3 * i + 3);
        }
        return (output + "." + numPoint);
    }
}

function childItemCont(index){
	var obj = $("#item" + index);
	if(obj.hasClass("icon-add")){
		obj.removeClass("icon-add");
		obj.addClass("icon-lessen");
	}else{
		obj.removeClass("icon-lessen");
		obj.addClass("icon-add");
	}
	
	$(".child-item" + index).toggle();
}


function initReportTree(){
	var setting = {
		view: {
			showLine: true,
			selectedMulti: false,
			dblClickExpand: false
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		callback: {
			onClick: onClickReport
		}
	};
	var zNodes =[
			{ id:1, pId:0, name:"相关报表", open:true},
			{ id:11, pId:1, name:"总体营销资源", open:true},
			{ id:9856, pId:11, name:"总体营销资源",uri:"../report/9856"},
			{ id:12, pId:1, name:"折扣资源", open:true},
			{ id:18947, pId:12, name:"折扣营销资源监控表",uri:"http://10.25.124.109:8080/doota/ve/18947"},
			{ id:18003, pId:12, name:"折扣营销资源监控表(分APRU)",uri:"http://10.25.124.109:8080/doota/ve/18003"},
			{ id:13, pId:1, name:"促销费", open:true},
			{ id:17976, pId:13, name:"促销费营销资源监控表(电子卷)",uri:"http://10.25.124.109:8080/doota/ve/17976"},
			{ id:17974, pId:13, name:"促销费营销资源监控表(除电子卷)",uri:"http://10.25.124.109:8080/doota/ve/17974"},
			{ id:14,pId:1,name:"酬金",open:true},
			{ id:18832, pId:14, name:"酬金营销资源监控表",uri:"http://10.25.124.109:8080/doota/ve/18832"},
			{ id:15,pId:1,name:"终端",open:true},
			{ id:9861, pId:15, name:"终端资源监控表",uri:"../report/9861"},
			{ id:9862, pId:15, name:"不同销售方式的终端资源使用情况",uri:"../report/9862"},
			{ id:9863, pId:15, name:"不同销售方式终端销量",uri:"../report/9863"},
			{ id:9864, pId:15, name:"不同档次终端的资源使用情况",uri:"../report/9864"},
			{ id:9865, pId:15, name:"不同档次终端的销量情况",uri:"../report/9865"},
			{ id:9866, pId:15, name:"不同ARPU分层的终端补贴使用情况",uri:"../report/9866"},
			{ id:16,pId:1,name:"BA全省营销方案分析",open:true},
			{ id:9179, pId:16, name:"BA全省营销方案分析",uri:"../report/9179"},
			{ id:17,pId:1,name:"营销活动评估",open:true},
			{ id:15454, pId:17, name:"积分兑换分业务报表",uri:"../report/15454"},
			{ id:15603, pId:17, name:"营销活动评估-终端类",uri:"../report/15603"},
			{ id:15604, pId:17, name:"营销活动评估-非终端类",uri:"../report/15604"},
			{ id:18,pId:1,name:"营销活动监控",open:true},
			{ id:15576, pId:18, name:"各个营销案资源使用进度日报",uri:"../report/15576"},
			{ id:15575, pId:18, name:"各地市资源使用进度日报",uri:"../report/15575"}
		];
	reportTree = $.fn.zTree.init($("#repTree"), setting, zNodes);		
}

function onClickReport(treeNode){
	var nodes = reportTree.getSelectedNodes();
	window.parent.addTab(nodes[0].id,nodes[0].name,nodes[0].uri);
}
</script>
</head>
<body>
<div class="minder-wrap">
	<div class="minder-left">
	<form class="row-fluid toolbar form-inline form_personal" style="width: auto;">
			<div class="field-group " id="startdate_totalRevenue">
				<div class="field-lable">
					<lable>账期</lable>
				</div>
				<div class="field date">
					<input id="searchDate" value="${defaultTime}" class="form-control arrow-control" style="width: 120px;" type="text" placeholder="请选择时间">
				</div>
			</div>
			<div class="field-group " id="area_totalRevenue">
				<div class="field-lable">
					<lable>归属地域</lable>
				</div>
				<select id="areaSel" style="width: 120px; padding:3px 10px;" class="form-control">
					<#list cityList as city>
						<option value="${city.area_code}">${city.area_name}</option>
					</#list>
				</select>
			</div>
			<div class="field-group " id="bnt_totalRevenue_qry">
				<button class="minder-btn" type="button" onclick="queryData();">查询</button>
			</div>
		</form>
		<div>
			<table class="report-table">
				<thead>
					<tr>
						<td class="num" style="width:20%">收支费用项名称</td>
						<td class="num" style="width:13%">收支费用（元）</td>
						<td class="num" style="width:13%">年累计收支费用（元）</td>
						<td class="num" style="width:6%">区域名称</td>
						<td class="num" style="width:48%">口径</td>
					</tr>
				</thead>
				<tbody id="costBody">
				</tbody>
			</table>
		</div>
	</div>
	<div class="minder-right">
		<div style="width:100%;" id="repTree" class="ztree"></div>
	</div>
</div>
</body>
</html>