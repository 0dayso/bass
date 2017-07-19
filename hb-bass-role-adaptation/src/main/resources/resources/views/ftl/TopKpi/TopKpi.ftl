<html> 
<head> 
    <title>日志审计</title> 
    <script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
	<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
	<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
	<script type="text/javascript">
		$(function(){
			$("#topkpi_datagrid").datagrid({
				url:"${mvcPath}/TopkpiCenter/topkpiIndex",
				fit : true,
				fitColumns : true,
				striped:true,
				pagination : true,
				idField : 'id',
				pageSize : 20,
				pageList : [ 10, 20, 30, 50 ],
				sortName : 'ct',
				sortOrder : 'desc',
				nowrap:false,
				checkOnSelect : false,
				selectOnCheck : false,
				columns :
				[[ {field : 'kpiname',title : 'kpi名称',width : 50},
				   {field : 'ct',title : '数量',width : 190},
				 
				]],
			});
		});
		
		
		function queryNotice() {
			$('#topkpi_datagrid').datagrid('load',{
				newstitle:$("#kpiname").val()
			});
		}
		
		function resetQuery() {
			$('#topkpi_searchForm').form('clear');
			$('#topkpi_datagrid').datagrid('load', {});
		}
	</script>
</head>
<body>
	<div id="topkpi_layout" class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'north',title:'Top',border:false" style="height: 50px;">

		</div>
		<div data-options="region:'center',border:false"style="padding-right:20px;">
			<table id="topkpi_datagrid" style="padding-right:20px;"></table>
		</div>
	</div>
</body>
</html>