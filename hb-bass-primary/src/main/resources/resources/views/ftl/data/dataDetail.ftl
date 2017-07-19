<!DOCTYPE html>
<head> 
<title>数据清单</title> 
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/js/default/grid_common.js"></script>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
<script type="text/javascript">
var timeId;
$(function(){
	timeId =  $("#queryTime").val().trim();
	$('#dataList').datagrid({
	    url: '${mvcPath}/dataDetail/getListData',
	    queryParams:{
	    	timeId: timeId
		},
	    pagination : true,
		pageSize : 20,
		pageList : [ 10, 20, 30, 50 ],
	    fit: true,
	    rownumbers: true,
	    singleSelect: true,
	    toolbar:'#tb'
	}).datagrid({loadFilter: pagerFilter});
});

function pagerFilter(data) {  
    if (typeof data.length == 'number' && typeof data.splice == 'function') {   // is array  
        data = {  
            total: data.length,  
            rows: data  
        }  
    }  
    var dg = $(this);  
    var opts = dg.datagrid('options');  
    var pager = dg.datagrid('getPager');  
    pager.pagination({  
        onSelectPage: function (pageNum, pageSize) {  
            opts.pageNumber = pageNum;  
            opts.pageSize = pageSize;  
            pager.pagination('refresh', {  
                pageNumber: pageNum,  
                pageSize: pageSize  
            });  
            dg.datagrid('loadData', data);  
        }  
    });  
    if (!data.originalRows) {  
        data.originalRows = (data.rows);  
    }  
    var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);  
    var end = start + parseInt(opts.pageSize);  
    data.rows = (data.originalRows.slice(start, end));  
    return data;  
}  

function doSearch(){
	if($("#queryTime").val().trim().length == 0){
		alert('请选择时间');
		return;
	}
	timeId = $("#queryTime").val().trim();
	$('#dataList').datagrid('load', {
	    timeId: $("#queryTime").val()
	});
}

function down(regionId){
	$("#downRegion").val(regionId);
	$("#downTime").val(timeId);
	document.tempForm.submit();
}

function operation(value, row, index){
   return "<a href='#' onclick=down('" + row.region_id + "')>明细数据</a>";
}
</script>
</head>
<body>
	<div class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'center'">
			<table id="dataList" title="统计数据">
				<thead>
					<tr>
						<th data-options="field:'region_id',width:120">地市</th>
						<th data-options="field:'county',width:130">县域</th>
						<th data-options="field:'county_type',width:120">区域属性</th>
						<th data-options="field:'connect_type',width:140">接入方式</th>
						<th data-options="field:'install_flag',width:140">安装情况</th>
						<th data-options="field:'installmaintain',width:120">装维公司</th>
						<th data-options="field:'y_cnt',width:100">已维护数量</th>
						<th data-options="field:'n_cnt',width:100">未维护数量</th>
						<th data-options="field:'opt',width:120,formatter: operation">操作</th>
					</tr>
				</thead>
			</table>
			<div id="tb" style="padding:5px;height:auto">
				<div>
					<select id="queryTime" style="width:113px; height:22px; line-height:22px;">
						<#if (timeList?exists) && (timeList?size) gt 0>
							<#list timeList as time>
								<#if (time.timeid?length==8) >
									<option value='${time.timeid}'>${time.timeid?substring(0,4)}-${time.timeid?substring(4,6)}-${time.timeid?substring(6,8)}</option>
								<#else>
									<option value='${time.timeid}'>${time.timeid}</option>
								</#if>
							</#list>
						</#if>
					</select>
					<a href="#" class="easyui-linkbutton" onclick="doSearch()">查询</a>
				</div>
			</div>
		</div>
	</div>
	<form name="tempForm" action="${mvcPath}/dataDetail/downLoad" method="POST">
		<input id="downRegion" name="downRegion" value="" type="hidden">
		<input id="downTime" name="downTime" value="" type="hidden">
	</form>
</body>
</html>