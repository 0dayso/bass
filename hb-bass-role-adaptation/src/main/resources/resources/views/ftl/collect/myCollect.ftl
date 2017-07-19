<!DOCTYPE html>
<HTML>
<HEAD>
<link href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hb-bass-frame/views/ftl/index/css/sys.base.css">
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/css/bootstrap-datetimepicker.css">
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/views/ftl/index/js/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/views/ftl/index/js/bootstrap.js"></script>
<script type="text/javascript" src="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/js/bootstrap-datetimepicker.js"></script>

<script>
$(function(){
	var collectList = ${collectList};
	initCollectList(collectList);
	
	$("#startDate").datetimepicker({
		format: 'yyyy-mm-dd',
		weekStart: 1,  
        autoclose: true,  
        startView: 2,  
        minView: 2,  
        forceParse: false,
        todayHighlight : true,
		language: 'zh-CN'
	});
	
	$("#endDate").datetimepicker({
		format: 'yyyy-mm-dd',
		weekStart: 1,  
        autoclose: true,  
        startView: 2,  
        minView: 2,  
        forceParse: false,
        todayHighlight : true,
		language: 'zh-CN'
	});
});

function initCollectList(collectList){
	var collectHtml = "";
	for(var i=0; i < collectList.length; i++){
		collectHtml += "<tr>";
		collectHtml += "<td>" + collectList[i].row_no + "</td>";
		collectHtml += "<td><a href=\"#\" title='" + collectList[i].resource_name + "' onclick=\"openCollect('" + collectList[i].resource_name + "','" + collectList[i].resource_uri + "')\">" + collectList[i].resource_name + "</a></td>";
		collectHtml += "<td>" + collectList[i].resource_type + "</td>";
		collectHtml += "<td>" + collectList[i].create_dt + "</td>";
		collectHtml += "<td><a href=\"#\" onclick=\"delFavorite('" + collectList[i].id + "')\">取消收藏</a></td>";
		collectHtml += "</tr>";
	}
	$("#collBody").html(collectHtml);
}

function openCollect(name, uri){
	window.parent.openNewPage(name, uri);
}

function queryCollInfo(){
	var collectName = $("#collName").val();
	var resType = $("#resType").val();
	var startDate = $("#startDate").val();
	var endDate = $("#endDate").val();
	$.ajax({
        url: '${mvcPath}/myCollect/getCollectInfo',
        type: "POST",
        async: false,
        dataType: 'json',
        data: {
            menuId: ${menuId},
            resourceName: collectName,
            resType : resType,
            startDate : startDate,
            endDate : endDate
        },
        success: function(data) {
        	var collInfo = eval(data);
        	initCollectList(collInfo);
        },
    });
}

function delFavorite(rid){
	if(window.confirm("确定要取消收藏吗？")){
		$.ajax({
        url: '${mvcPath}/myCollect/delCollect',
        type: "POST",
        async: false,
        dataType: 'json',
        data: {
            rid: rid,
            menuId: ${menuId}
        },
        success: function(data, textStatus) {
            if (data.flag) {
                alert(data.msg);
                queryCollInfo();
            } else {
                alert(data.msg);
            }
        },
    });
	}
}


</script>
</HEAD>
<BODY>
	<div class="sys-wrap-l bs">
		<div class="sys-wrap-btitle">
			热门推荐
		</div>
		<ul class="sys-wrap-blist">
		<#if (hotCollects?exists) && (hotCollects?size) gt 0>
			<#list hotCollects as hotCollect>
				<li class="hot"><a href='#' title='${hotCollect.text}' onclick="openCollect('${hotCollect.text}','${hotCollect.uri}')">${hotCollect.text}</a></li>
			</#list>
			<#else>
				<li>暂无数据……</li>
		</#if>
		</ul>
	</div>
	<div class="sys-wrap-r">
		<div class="sys-block-item">
			<div class="sys-block-title">
				我的收藏
			</div>
			<div class="sys-block-content">
				<div class="search-wrap">
					<lable>收藏名称</lable>
					<input id="collName" name="collName" type="text" class="coll-sear-name">
					<lable class="marl-10">收藏类型</lable>
					<select class="coll-sear-type" id='resType'>
						<#list collectTypeList as type>
							<option value='${type.key}'>${type.value}</option>
						</#list>
					</select>
					<lable class="marl-10">周期选择</lable>
					<input id="startDate" readonly type="text" class="arrow-control coll-sear-date">~
					<input id="endDate" readonly type="text" class="arrow-control coll-sear-date">
					<button class="sys-btn sys-btn-blue marl-10" onclick="queryCollInfo()">查询</button>
				</div>
				<div class="sys-zb-con">
					<table cellspacing="0" cellspacing="0" class="report-table">
						<thead>
							<tr class="sys-zb-tbt">
								<td style="width:10%">序号</td>
								<td style="width:43%">收藏名称</td>
								<td style="width:15%">收藏类型</td>
								<td style="width:20%">收藏时间</td>
								<td style="width:12%">操作</td>
							</tr>
						</thead>
						<tbody id="collBody">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</BODY>
</HTML>