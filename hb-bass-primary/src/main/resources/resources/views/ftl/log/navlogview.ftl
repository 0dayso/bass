<html> 
<head> 
    <title>浏览器变更</title> 
    <script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
	<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
	<link rel="stylesheet" href="${mvcPath}/resources/jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
	<script type="text/javascript">
		$(function(){
			$('#log_navlogview_datagrid').datagrid({
				url : '${mvcPath}/navlogview/selectnavlogview',
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
				[[ {field : 'loginname',title : '登陆名',width :100,sortable : true},
				   {field : 'username',title : '用户名', width : 50,},
				   {field : 'logtime',title :'变更时间',width : 200,}, 
				   {field : 'navname',title : '浏览器',width : 100},
				   {field : 'cityname',title : '地市',width :50,},
				   
				]],
			});
			$('#city').combobox({ 
		 		 url: '${mvcPath}/navlogview/selectCity' ,
	             valueField: 'cityid',  
	             textField: 'cityname',
				 editable:false ,
				 panelHeight:300, 
	          });
		});
		
		
		//将from中的数据序列化成对象方便传值
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
			$('#log_navlogview_datagrid').datagrid('load', serializeObject($('#log_navlogview_searchForm')));
			
		}
		function clearFun() {
			$('#log_navlogview_searchForm').form('clear');
			$('#log_navlogview_datagrid').datagrid('load', {});
		}
		
	</script>
  </head>
  
 
  <body style="font-size:12px">
  <div id="log_navlogview_layout" class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'north',title:'查询条件',border:false" style="height: 50px;">
		<form id="log_navlogview_searchForm">
			 地市:<input id=city class="easyui-combobox" name="cityid" type="text"/>
			时间：<input id="dd" name="date" type="text" class="easyui-datebox" >
			 <a  class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchFun();">查询</a>
			 <a  class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="clearFun();">重置</a>
		</form>
	</div>
	<div data-options="region:'center',border:false"style="padding-right:20px;">
	<table id="log_navlogview_datagrid" style="padding-right:20px;"></table>
	</div>
</div>
</body>
</html>
