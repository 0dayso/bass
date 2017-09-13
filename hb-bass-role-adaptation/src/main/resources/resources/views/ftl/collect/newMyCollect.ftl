<!DOCTYPE html>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>我的收藏</title>
<link href="${mvcPath}/resources/lib/bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/center.css" />
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/font-icon/style.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/css/bootstrap-datetimepicker.css">
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="${mvcPath}/hbBassRoleAdaptation/views/ftl/datepicker/js/bootstrap-datetimepicker.js"></script>
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/main.js"></script>
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
        clearBtn: true,
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
        clearBtn: true,
        todayHighlight : true,
		language: 'zh-CN'
	});
});

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

function initCollectList(collectList){
	var collectHtml = "";
	for(var i=0; i < collectList.length; i++){
		collectHtml += "<tr>";
		collectHtml += "<td class=\"num\">" + (i+1) + "</td>";
		collectHtml += "<td class=\"coll-text\"><a href=\"#\" title='" + collectList[i].name + "' data-uri='" + collectList[i].uri + "' onclick=\"openRelaApps('" + collectList[i].id + "','" + collectList[i].name + "',this)\">" + collectList[i].name + "</a></td>";
		collectHtml += "<td class=\"coll-text\">" + collectList[i].type + "</td>";
		collectHtml += "<td class=\"num\">" + collectList[i].create_dt + "</td>";
		collectHtml += "<td class=\"num\"><a class=\"act\" href=\"#\" onclick=\"delFavorite('" + collectList[i].type + "','" + collectList[i].id + "')\">取消收藏</a></td>";
		collectHtml += "</tr>";
	}
	$("#collBody").html(collectHtml);
}

function delFavorite(type, rid){
	if(window.confirm("确定要取消收藏吗？")){
		$.ajax({
        url: '${mvcPath}/myCollect/delCollect',
        type: "POST",
        async: false,
        dataType: 'json',
        data: {
            rid: rid,
            menuId: ${menuId},
            type: type
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

function changeMenuType(id){
	location.href = id;
}


function openRelaApps(id,title,th){
	var uri = $(th).attr("data-uri");
	if(uri.indexOf('renderpageSpecialTopic:')>-1){
		window.parent.addTab(id,title,"../appCenter/subSpecialTopic?resId=" + id);
	}else if(uri.indexOf('renderPageZtShow:')>-1){
		window.parent.addTab(id,title,'../appCenter/appzt?menuId='+id)
	}else{
		window.parent.addTab(id,title,uri)
	}
}

</script>
</HEAD>
<BODY>
	<div class="coll-wrap">
		<div class="coll-left">
			<div class="container-box">
				<div class="con-title pl5">
					<span class="con-title-text">我的收藏</span>
				</div>
				<div>
					<ul class="menu-type">
						<#list menuTypes as menuType>
							<li><a 
							<#if '${menuType.id}'=='${menuId}'>
								class="active"
							</#if>
							 id="menu_${menuType.id}" href="#" onclick="changeMenuType('${menuType.id}')">${menuType.name}</a></li>
						</#list>
					</ul>
				</div>
			</div>
			
			<div class="container-box" style="margin-top:15px;">
				<div class="con-title pl5">
					<span class="con-title-text">热门推荐</span>
				</div>
				<div style="padding-bottom:3px;">
					<ul class="menu-type">
						<#if (hotCollects?exists) && (hotCollects?size) gt 0>
							<#list hotCollects as hotCollect>
								<li class="hot"><div class="hot-text"><a href='#' title='${hotCollect.text}' data-uri="${hotCollect.uri?trim}" onclick="openRelaApps('${hotCollect.id?trim}','${hotCollect.text?trim}',this)">${hotCollect.text}</a></div></li>
							</#list>
							<#else>
								<li>暂无数据……</li>
						</#if>
					<ul>
				</div>
			</div>
			
		</div>
		<div class="coll-right-container">
			<div class="con-title pl2">
				<span id="menuName" class="con-title-text">${menuName}</span>
				<div>
					<span class="sear-cond">收藏标题</span>
					<input id="collName" class="inp-box">
					<span class="sear-cond" style="margin-left:8px;">收藏类型</span>
					<select class="sear-cond" id="resType">
						<option value='0'>全部</option>
						<option value='报表'>报表</option>
						<option value='应用'>应用</option>
					</select>
					<span class="sear-cond" style="margin-left:8px;">周期选择</span>
					<input id="startDate" readonly class="arrow-control inp-box date-inp">
					<span class="sear-cond">至</span>
					<input id="endDate" readonly class="arrow-control inp-box date-inp">
					<button class="sear-btn" onclick="queryCollInfo()">查询</button>
				</div>
			</div>
			<div>
				<table class="report-table">
					<thead>
						<tr>
							<td class="num" style="width:10%">序号</td>
							<td class="coll-text" style="width:43%">收藏名称</td>
							<td class="coll-text" style="width:15%">收藏类型</td>
							<td class="num" style="width:20%">收藏时间</td>
							<td class="num" style="width:12%">操作</td>
						</tr>
					</thead>
					<tbody id="collBody">
					</tbody>
				</table>
			</div>
		</div>
	</div>
</BODY>
</HTML>