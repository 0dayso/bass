<html> 
<head> 
    <title>登陆日志</title> 
    <script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
	<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
	<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
	<script type="text/javascript">
		$(function(){
			$('#log_loginlogquery_datagrid').datagrid({
				url : '${mvcPath}/journal/selectlog',
				fit : true,
				fitColumns : true,
				striped:true,
				pagination : true,
				idField : 'id',
				pageSize : 20,
				pageList : [ 10, 20, 30, 50 ],
				sortName : 'loginname',
				sortOrder : 'asc',
				checkOnSelect : false,
				selectOnCheck : false,
				columns : 
				[[ {field : 'loginname',title : '登陆名',width : 50,sortable : true}, 
				   {field : 'ipaddr',title : 'IP地址',width : 50},
				   {field : 'uri',title : 'URI',width : 100,}, 
				   {field : 'opertype',title : '操作类型',width : 50,}, 
				   {field : 'opername',title : '操作名称',width : 50},
				   {field : 'create_dt',title : '创建时间',
				   formatter : function(value, row, index) {
				   		if(value!=null){
				   			return new Date(parseInt(value)).toLocaleString().replace(/年|月/g, "-").replace(/日/g, " ");
				   		}else{
				   			return "";
				   		}
				   		 
					},
				   width : 100,},
				   {field : 'dur_time',title : '持续时间',width : 50,},
				   {field : 'ua',title : '浏览器',width : 50,},
				]],
			});
			
		});
		serializeObject=function(from){
			var o={};
			$.each(from.serializeArray(),function(index){
				if(o[this['name']]){
					o[this['name']]=o[this['name']]+","+this['value'];
					
				}else{
					o[this['name']]=this['value'];
				}
			});
			return o;
		};
		function searchFun() {
			$('#log_loginlogquery_datagrid').datagrid('load',serializeObject($("#log_loginlogquery_searchForm")));
		}
		function clearFun() {
			$('#log_loginlogquery_searchForm').form('clear');
			$('#log_loginlogquery_datagrid').datagrid('load', {});
		}
	</script>
</head> 
<body> 
   <div id="log_loginlogquery_layout" class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'north',title:'查询条件',border:false" style="height: 50px;">
		<form id="log_loginlogquery_searchForm">
			检索用户名称(可模糊查询):<input name="loginname" />
			 uri:<input name="uri">
			 <a  class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchFun();">查询</a>
			 <a  class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="clearFun();">重置</a>
		</form>
	</div>
	<div data-options="region:'center',border:false"style="padding-right:20px;">
	<table id="log_loginlogquery_datagrid" style="padding-right:20px;"></table>
	</div>
 </div>
</body> 
</html> 