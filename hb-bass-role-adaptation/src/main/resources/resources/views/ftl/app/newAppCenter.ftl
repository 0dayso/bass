<!DOCTYPE html>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>应用中心</title>
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/center.css" />
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/lib/font-icon/style.css" />
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/jquery-1.11.1.min.js"></script>
<script src="${mvcPath}/hb-bass-frame/views/ftl/index2/js/main.js"></script>
<script>
$(function(){
	var appList = ${appList};
	initAppInfo(appList);
	
	$(".order-type").on({
		click:function(){
			$(".order-type").removeClass("order-act");
			$(this).addClass("order-act");
			queryAppInfo();
		}
	});
	
	$("#appName").keypress(function(e){
		var key = e.keyCode;
		if(key==13){
			queryAppInfo();
		}
	});
});

function initAppInfo(appList){
	var appHtml ="";
	for(var i=0; i<appList.length; i++){
		appHtml +="<div class=\"item-box\">";
		appHtml +="<a href=\"#\" data-uri='" + appList[i].resource_uri + "' onclick=\"openRelaApps('" + appList[i].resource_id + "','" + appList[i].resource_name + "',this)\">";
		appHtml +="<img src=\"${mvcPath}/hb-bass-frame/views/ftl/index2/img/table/u1050.png\" class=\"item_img\"/>";
     	appHtml +="<div class=\"item-text\" title='" + appList[i].resource_name + "'>" + appList[i].resource_name + "</div>";
     	appHtml +="</a>";
     	if(appList[i].ismycollect > 0){
	     	appHtml +="<div class=\"item-coll\">已收藏</div>";
     	}else{
     		appHtml +="<div class=\"item-coll\"><a href=\"#\" class=\"act\" onclick=\"addFavorite('" + appList[i].resource_id + "')\">收藏</a></div>";
     	}
     	appHtml +="</div>";
	}
	if(appHtml.length == 0){
		appHtml = "<div class=\"no-data\">暂无数据……</div>"
	}
	$("#appInfo").html(appHtml);
}

function queryAppInfo(){
	var appName = $("#appName").val();
	var appType = $("#appType").val();
	var orderType = $(".order-act").attr("value");
	$.ajax({
        url: '${mvcPath}/appCenter/getAppInfo',
        type: "POST",
        async: false,
        dataType: 'json',
        data: {
            menuId: ${menuId},
            appName: appName,
            appType: appType,
            orderType: orderType
        },
        success: function(data) {
        	var appList = eval(data);
        	initAppInfo(appList);
        },
    });
}

function addFavorite(rid){
	$.ajax({
        url: '${mvcPath}/myCollect/addCollect',
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
                queryAppInfo();
            } else {
                alert(data.msg);
            }
        },
    });
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
	<div class="wrap">
		<div class="left">
			<div class="container-box">
				<div class="con-title pl5">
					<span class="con-title-text">应用中心</span>
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
						<#if (hotAppList?exists) && (hotAppList?size) gt 0>
							<#list hotAppList as hotApp>
								<li class="hot"><div class="hot-text"><a href='#' title='${hotApp.resource_name}' data-uri="${hotApp.resource_uri?trim}" onclick="openRelaApps('${hotApp.resource_id}','${hotApp.resource_name}',this)">${hotApp.resource_name}</a></div></li>
							</#list>
							<#else>
								<li>暂无数据……</li>
						</#if>
					<ul>
				</div>
			</div>
			
		</div>
		<div class="right-container">
			<div class="con-title pl2">
				<span id="menuName" class="con-title-text">${menuName}</span>
				<div class="ser-name-box">
					<input class="ser-inp" placeholder="请输入您要搜索的内容" id="appName">
					<span class="icon-search ser-btn" onclick="queryAppInfo()"></span>
				</div>
				<span class="sear-cond" style="position:absolute; right:3%;">
					<span>类型</span>
					<select class="sear-cond" id="appType" onChange="queryAppInfo()">
					<#list apptypelist as apptype>
						<option value="${apptype.key}">${apptype.value}</option>
					</#list>
					</select>
					<span style="padding-left:8px;">排列:</span>
					<span class="order-type order-act" value="ROWID">相关性</span>
					<span style="padding:0 3px;">|</span>
					<span class="order-type" value="ROWID">最多浏览</span>
					<span style="padding:0 3px;">|</span>
					<span class="order-type" value="TIMEROWS">最新上线</span>
				</span>
			</div>
			<div id="appInfo"></div>
		</div>
	</div>
</BODY>
</HTML>