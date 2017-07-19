<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>


<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'index.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<script type="text/javascript" src="jslib/jquery-easyui-1.3.1/jquery-1.8.0.min.js"></script>
	<script type="text/javascript" src="jslib/jquery-easyui-1.3.1/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="jslib/jquery-easyui-1.3.1/locale/easyui-lang-zh_CN.js"></script>
	<link rel="stylesheet" href="jslib/jquery-easyui-1.3.1/themes/default/easyui.css" type="text/css"></link>
	<link rel="stylesheet" href="jslib/jquery-easyui-1.3.1/themes/icon.css" type="text/css"></link>
	<script type="text/javascript">
		$(function(){
			$('#log_loginlogquery_datagrid').datagrid({
				url : '${pageContext.request.contextPath}/journal/selectlog',
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
				   {field : 'uri',title : 'URI',width : 150,}, 
				   {field : 'opertype',title : '操作类型',width : 50,}, 
				   {field : 'opername',title : '操作时间',width : 50},
				   {field : 'create_dt',title : '创建时间',width : 50,},
				   {field : 'dur_time',title : '修改时间',width : 50,},
				   {field : 'ua',title : '浏览器',width : 50,},
				]],
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
			$('#log_loginlogquery_datagrid').datagrid('load',serializeObject($("#log_loginlogquery_searchForm")));
		}
		function clearFun() {
			$('#log_loginlogquery_searchForm').form('clear');
			$('#log_loginlogquery_datagrid').datagrid('load', {});
		}
	</script>
  </head>
  
 
  <body >
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
