<!DOCTYPE html>
<HTML>
<HEAD>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hb-bass-frame/views/ftl/index/css/sys.base.css">
<script type="text/javascript" src="${mvcPath}/hb-bass-frame/views/ftl/index/js/jquery-1.11.3.min.js"></script>
<script>
$(function(){
	var reportList = ${reportList};
	initReportTable(reportList);
});

function initReportTable(reportList){
	var reportHtml = '';
	for(var i=0; i<reportList.length; i++){
		reportHtml += "<tr><td colspan='5' class='tl rep-sort'>" + reportList[i].name + "（共" + reportList[i].num + "张）</td></tr>";
		var childList = reportList[i].child;
		for(var j=0; j < childList.length; j++){
			reportHtml += "<tr>";
			reportHtml += "<td class='tl pdl5'><a href=\"#\" title='" + childList[j].rname + "' onclick=\"openReport('" + childList[j].rname + "','" + childList[j].ruri + "')\">" + childList[j].rname + "</a></td>";
			reportHtml += "<td class='rep-name' title='" + childList[j].rdesc + "'>" + childList[j].rdesc + "</td>";
			reportHtml += "<td>" + childList[j].lastupd + "</td>";
			var cycle="";
			if(childList[j].cycle=='day'){
				cycle="日报表";
			}else if(childList[j].cycle=='month'){
				cycle="月报表";
			}
			reportHtml += "<td>" + cycle + "</td>";
			if(parseInt(childList[j].favsnum)>0){
				reportHtml += "<td>已收藏</td>";
			}else{
				reportHtml += "<td><a href=\"#\" onclick=\"addFavorite('" + childList[j].rid + "')\"><div class=\"coll-col\">收藏</div></a></td>";
			}
			reportHtml += "</tr>";
		}
	}
	$('#repBody').html(reportHtml);
}

function openReport(name, uri){
	window.parent.openNewPage(name, uri);
}

function queryReportList(){
	var reportName = $("#reportName").val();
	$.ajax({
        url: '${mvcPath}/reportCenter/getReportInfo',
        type: "POST",
        async: false,
        dataType: 'json',
        data: {
            menuId: ${menuId},
            reportName: reportName
        },
        success: function(data) {
        	var reportInfo = eval(data);
        	initReportTable(reportInfo);
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
                queryReportList();
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
		<#if (hotReports?exists) && (hotReports?size) gt 0>
			<#list hotReports as hotreport>
				<li class="hot"><a href='#' title='${hotreport.text}' onclick="openReport('${hotreport.text}','${hotreport.uri}')">${hotreport.text}</a></li>
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
					<input id="reportName" name="reportName" type="text" placeholder="请输入报表名称" class="rep-search">
					<button class="sys-btn sys-btn-blue marl-10" onclick="queryReportList()">查询</button>
				</div>
				<div class="sys-zb-con">
					<table cellspacing="0" cellspacing="0" class="report-table">
						<thead>
							<tr class="sys-zb-tbt">
								<td style="width:27%">报表名称</td>
								<td style="width:37%">描述</td>
								<td style="width:13%">更新时间</td>
								<td style="width:13%">报表类型</td>
								<td style="width:10%">操作</td>
							</tr>
						</thead>
						<tbody id="repBody">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</BODY>
</HTML>