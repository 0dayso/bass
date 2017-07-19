<html> 
<head> 
<title>最新上线</title> 
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
<link rel="stylesheet" href="${mvcPath}/hb-bass-frame/views/ftl/index2/css/index.css" />
<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
<script type="text/javascript">
	$(function(){
		$("#lastestOnline_datagrid").datagrid({
			url:"${mvcPath}/LastestOnline/LastestOnlineIndex",
			fit : true,
			fitColumns : true,
			striped:true,
			pagination : true,
			idField : 'rid',
			pageSize : 20,
			pageList : [ 10, 20, 30, 50 ],
			sortName : 'dt',
			sortOrder : 'desc',
			nowrap:false,
			checkOnSelect : false,
			selectOnCheck : false,
			columns :
			[[ {field : 'name',title : '报表名称',width : 60},
			   {field : 'desc',title : '描述',width : 160},
			   {field : 'dt',title : '最后更新时间',width : 20,sortable : true},
			   {field : 'rid',title : '操作',width : 20,align:'center',
				   formatter: function(value,row,index){
					   return '<a href="javascript:;" onclick="window.parent.addTab(\'online'+row.rid+'\',\''+row.name+'\',\''+row.url+'\')">详细</a>';  
					} 
			   },
			]],
		});
	});
	function openReport(index){
		$("#lastestOnline_datagrid").datagrid('selectRow',index);
		var row = $('#lastestOnline_datagrid').datagrid('getSelected');
	    if (row){
	    	addTab("'online"+row.rid+"','"+row.name+"','../report/"+row.rid+"'");
	    }
	}
	
	function queryNotice() {
		$('#lastestOnline_datagrid').datagrid('load',{
			name:$("#name").val()
		});
	}
	
	function resetQuery() {
		$('#lastestOnline_searchForm').form('clear');
		$('#lastestOnline_datagrid').datagrid('load', {});
	}
</script>
</head>
<body>
<div id="lastestOnline_layout" class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'north',title:'查询条件',border:false" style="height: 50px;">
		<form id="lastestOnline_searchForm">
			&nbsp;&nbsp;&nbsp;报表名称:<input id="name" type="text" name="name"/>
		 	<a href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="queryNotice();">查询</a>
		 	<a href="javascript:;" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="resetQuery();">重置</a>
		</form>
	</div>
	<div data-options="region:'center',border:false"style="padding-right:20px;">
		<table id="lastestOnline_datagrid" style="padding-right:20px;"></table>
	</div>
</div>
</body>
</html>