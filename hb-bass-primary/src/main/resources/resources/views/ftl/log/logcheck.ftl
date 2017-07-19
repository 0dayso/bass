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
			$('#log_logincheck_datagrid').datagrid({
				url : '${mvcPath}/logCheck/selectLogCheck',
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
				[[ {field : 'loginname',title : '登陆名',width :50,sortable : true}, 
				   {field : 'username',title : '用户名称',width : 50},
				   {field : 'cityname',title : '地市',width : 50,}, 
				   {field : 'visitdate2',title :'访问时间',
					   formatter : function(value, row, index) { 
						   return new Date(parseInt(value)).toLocaleString().replace(/年|月/g, "-").replace(/日/g, " "); 
					   },
					   width : 100,}, 
				   {field : 'ipaddress',title : 'IP地址',width : 100},
				   {field : 'checked',title : '审核状态', 
					   formatter : function(value, row, index) {
						  var value= formatterIsu(value);
						  return value;
				   		},
				   width : 50,},
				   {field : 'check_detail',title : '审核结果',width :50,},
				   {field : 'checkdate',title : '审核时间',width :50,},
				   {field : 'checkman',title : '审核人',width : 60,},
				]],
			});
			$('#city').combobox({ 
		 		 url: '${mvcPath}/logCheck/selectcyti' ,
	             valueField: 'cityid',  
	             textField: 'cityname',
				 editable:false ,
				 panelHeight:300, 
	          });
		});
		function formatterIsu(value){
			 if(value=="0"){
				 return "未审核";
	          }else  if(value=="1"){
	             return "一审通过";
	          }else  if(value=="2"){
	             return "二审通过";
	          }else  if(value=="3"){
	              return "一审不通过";
	          }else  if(value=="4"){
	              return "二审不通过";
	           }
		}  
		
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
			var type=$("#type").combobox('getValue');
			 if(type==2){
				 if( $('#dd').datebox('getValue')==''){
					 alert("时间不能为空");
					 return false;
				 }
			 };
			 
			$('#log_logincheck_datagrid').datagrid('load', serializeObject($('#log_logcheck_searchForm')));
		}
		function clearFun() {
			$('#log_logcheck_searchForm').form('clear');
			$('#log_logincheck_datagrid').datagrid('load', {});
		}
	</script>
  </head>
  
 
  <body>
  <div id="log_navlogview_layout" class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'north',title:'查询条件',border:false" style="height: 80px;">
		<form id="log_logcheck_searchForm" >
			<table style="text-align:center;">
			<tr>
				<td>检索登陆名(可模糊查询):</td>
				<td><input   name="loginname" style="width:125px;border:1px solid #A4BED4;"> </td>
				<td> 地市:</td>
				<td><input id=city class="easyui-combobox" name="cityid" type="text" style="width: 125px"/></td>
				<td> 审计类型：</td>
				<td>  
					<select name="checkedtype"id="type"  class="easyui-combobox"  data-options=" panelHeight:'auto', editable:false ">
                          <option value="" >--请选择--</option>
                          <option value="1">时段异常登录审计</option>
                          <option value="2">IP异常登录审计</option>
                          <option value="3">密码异常审计</option>
                     </select></td>
              </tr>
              <tr>
              	<td style="text-align:right;">周期 :</td>
              	<td><input id="dd" name="querydate" type="text" class="easyui-datebox" ></td>
                <td>状态：</td>
                <td><select name="checked" class="easyui-combobox" data-options="panelHeight:'auto', editable:false ">
                	 <option  value="" style="display:none">--请选择--</option>
                     <option value="-1">全部</option>
                     <option value="1">一审通过</option>
                     <option value="2">二审通过</option>
                     <option value="3">一审不通过</option>
                     <option value="4">二审不通过</option>
                     <option value="0">未审核</option>
                	 </select>
                </td>		
				<td><a  href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-search',plain:true" onclick="searchFun();">查询</a></td>
				<td><a href="javascript:void(0)"  class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="clearFun();">重置</a>
				</td>
              </tr> 
			</table>
		</form>
	</div>
	<div data-options="region:'center',border:false"style="padding-right:20px;">
	<table id="log_logincheck_datagrid" style="padding-right:20px;"></table>
	</div>
</div>
</body>
</html>
