<!DOCTYPE html>
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hb-bass-frame/views/ftl/index/css/sys.base.css">
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/views/ftl/index/js/jquery-1.11.3.min.js"></script>
<script>

$(function(){
	var appList = ${appList};
	initAppInfo(appList);
});

function initAppInfo(appList){
	var appHtm = "";
	for(var i=0; i<appList.length; i++){
		appHtm += "<div class=\"sys-w20\">";
		appHtm += "<div class=\"sys-online-item\">";
		appHtm += "<a href=\"#\" onclick=\"openApp('" + appList[i].resource_name + "','" + appList[i].resource_uri + "')\">";
		appHtm += "<div class=\"sys-o-imgbox\"><img src=\"${mvcPath}/hb-bass-frame/views/ftl/index/images/sys-newImg01.png\"/></div>";
		appHtm += "<div class=\"sys-o-txt\" title=\""+ appList[i].resource_name +"\">" + appList[i].resource_name + "</div></a>";
		if(appList[i].ismycollect > 0){
			appHtm += "<a><div class=\"app-coll\">已收藏</div></a>";
		}else{
			appHtm += "<a href=\"#\" onclick=\"addFavorite('" + appList[i].resource_id + "')\"><div class=\"app-coll coll-col\">收藏</div></a>";
		}
		appHtm += "</div></div>";
	}
	$("#appInfo").html(appHtm);
}

function openApp(name, uri){
	window.parent.openNewPage(name, uri);
}

function queryAppInfo(){
	var appName = $("#appName").val();
	$.ajax({
        url: '${mvcPath}/appCenter/getAppInfo',
        type: "POST",
        async: false,
        dataType: 'json',
        data: {
            menuId: ${menuId},
            appName: appName
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

</script>
</HEAD>
<BODY>
	<div class="sys-wrap-l bs">
		<div class="sys-wrap-btitle">
			热门推荐
		</div>
		<ul class="sys-wrap-blist">
		<#if (hotAppList?exists) && (hotAppList?size) gt 0>
			<#list hotAppList as hotApp>
				<li class="hot"><a href='#' title='${hotApp.resource_name}' onclick="openApp('${hotApp.resource_name}','${hotApp.resource_uri}')">${hotApp.resource_name}</a></li>
			</#list>
			<#else>
				<li>暂无数据……</li>
		</#if>
		</ul>
	</div>
	<div class="sys-wrap-r">
		<div class="sys-block-item">
			<div class="sys-block-title">
				${menuName}
			</div>
			<div class="sys-block-content">
				<div class="search-wrap">
					<input id="appName" name="appName" type="text" placeholder="请输入应用名称" class="rep-search">
					<button class="sys-btn sys-btn-blue marl-10" onclick="queryAppInfo()">查询</button>
				</div>
				<div class="sys-online-wrap" id="appInfo">					
				</div>
			</div>
		</div>
	</div>
</BODY>
</HTML>