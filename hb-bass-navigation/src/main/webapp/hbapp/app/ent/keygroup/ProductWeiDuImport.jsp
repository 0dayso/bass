<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-多维度数据导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />

</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	数据导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
        <td width="450"><div id="uploadDiv"></div></td>
        <td> 请选择数据的日期
      <select id="choice_date" style="margin-top:105px">  
				<option value="13">默认时间</option> 
				<option value="0">1月份</option> 
				<option value="1">2月份</option>  
				<option value="2">3月份</option>       
				<option value="3">4月份</option>    
				<option value="4">5月份</option>  
				<option value="5">6月份</option>  
				<option value="6">7月份</option>  
				<option value="7">8月份</option>  
				<option value="8">9月份</option>  
				<option value="9">10月份</option>  
				<option value="10">11月份</option>  
				<option value="11">12月份</option>
    </select>  </td>
	<td><font color='red' size='+2'>注意事项:</font><h4>excel严格按照约定的格式，比如第一行必须是三列KM，KMSM，QMS；第二行则是数据,QMS对应的列类型必须是浮点，为避免数据录入异常，请按规则导入.</h4></td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div style="text-align:right;">
	<input type="button" id="queryBtn" class="form_button"  style="width : 120px" value="查看"/>&nbsp;
	<input type="button" id="downBtn" class="form_button" style="width : 120px" value="下载" onclick="down()">&nbsp;
</div>

<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td><img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table>
	</legend>
	<div id="grid" style="display:none;"></div>
</fieldset>
</div><br>
</form>

	<form name="tempForm" action=""></form>
	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js" charset=utf-8></script>
	<script type="text/javascript">
+function(window,document,undefined){
	var now=new Date();
    now.setMonth(now.getMonth()-1);
	var taskId = now.format("yyyymm");
	var _params = aihb.Util.paramsObj();
	function showPanel() {
		var vault = new dhtmlXVaultObject();
		vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
		vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcel", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
		vault.setFilesLimit(1);
		vault.create("uploadDiv");
		vault.onFileUpload=function(){
			return true;
		}
		vault.onAddFile = function(fileName) {
			var ext = this.getFileExtension(fileName);
			if (ext != 'xls') {
				alert("本应用只支持扩展名.xls,请重新上传.");
				return false;
			} else return true;
		};
		vault.setFormField("tableName", "USER_VALUE_FINANCE_IMP_tmp");
		vault.setFormField("columns", "TASK_ID,PROD_CODE,PROD_NAME,TOTAL_FEE");
		vault.setFormField("date", taskId);
		vault.setFormField("ds","web");
		vault.onUploadComplete = function(files) {
			var taskId=getChoice_date();
			var now1=new Date();
			now1.setMonth(now1.getMonth()-1);
			var tmp_date = now1.format("yyyymm");
			var _sql = "select count(*) cnt from USER_VALUE_FINANCE_IMP_tmp where task_id='" + tmp_date + "' and  PROD_CODE NOT LIKE '%KM%'";
			var _ajax = new aihb.Ajax({
				url : "${mvcPath}/hbirs/action/jsondata?method=query"
				,parameters : "sql="+strEncode(_sql)+"&isCached=false"+"&ds=web"
				,loadmask : true
				,callback : function(xmlrequest){
					try{
						var result = xmlrequest.responseText;
						result = eval(result);
						//如果导入数为空，则导入失败
						if(!result || !result[0].cnt){
							alert("导入失败，请查询数据是否正确");
							return;
						}else{
							alert("有"+result[0].cnt+"条记录将导入正式表");
						}
						if(confirm("您确定要将这批数据入库吗?")){
							//删除正式表选定日期已导入数据
							var sql = encodeURIComponent("delete from USER_VALUE_FINANCE_IMP where task_id="+taskId);
							var ajaxAdd = new aihb.Ajax({
								url : "${mvcPath}/hbirs/action/sqlExec"
								,parameters : "sqls="+sql+"&ds=web"
								,asynchronous: true
								,loadmask : false
								,callback : function(xmlrequest){
									 if(xmlrequest.responseText=='{\"message\":\"执行成功\"}'&&xmlrequest.status==200){
												sql += "&sqls=" + encodeURIComponent("insert INTO USER_VALUE_FINANCE_IMP (TASK_ID,PROD_CODE,PROD_NAME,TOTAL_FEE) SELECT '"+taskId+"',PROD_CODE,PROD_NAME,TOTAL_FEE FROM USER_VALUE_FINANCE_IMP_TMP where PROD_CODE NOT LIKE '%KM%'");
												// 删除临时表的数据
												sql += "&sqls=" + encodeURIComponent("DELETE FROM USER_VALUE_FINANCE_IMP_TMP");
												var ajaxAdd = new aihb.Ajax({
													url : "${mvcPath}/hbirs/action/sqlExec"
													,parameters : "sqls="+sql+"&ds=web"
													,asynchronous: true
													,loadmask : false
													,callback : function(xmlrequest){
														//当执行成功的时候删除正式表ENTER_KEYMEMBER_STAFF_TMP_"+taskId
															 if(xmlrequest.responseText=='{\"message\":\"执行成功\"}'&&xmlrequest.status==200){
																alert("成功导入"+result[0].cnt+"条记录至正式表");
																//最后再查询最新数据
																aihb.Util.loadmask();
																query();
															}
														}

												})
												ajaxAdd.request();

										}

								}

							})
							ajaxAdd.request();
						}
				
						
					}catch(e){
						alert("导入失败，请查询数据是否正确");
						return;
					}
				}
			})
			_ajax.request();
		}
	};
					

	var _header=[
	{"name":"导入日期","dataIndex":"task_id","cellStyle":"grid_row_cell_text"}
	,{"name":"PROD_CODE","dataIndex":"prod_code","cellStyle":"grid_row_cell_text"}
	,{"name":"PROD_NAME","dataIndex":"prod_name","cellStyle":"grid_row_cell_text"}
	,{"name":"TOTAL_FEE","dataIndex":"total_fee","cellStyle":"grid_row_cell_text"}
	];	
	function getChoice_date()
	{
		//根据选择的日期删除并建表
			var select = document.getElementById("choice_date"); //定位id
			var index = select.selectedIndex; // 选中索引
			var text = select.options[index].text; // 选中文本
			var value = select.options[index].value; // 选中值
			var now=new Date();
			var taskId ="";
			 //系统时间月份-1
			if(value==13){
			  now.setMonth(now.getMonth()-1);
			  taskId = now.format("yyyymm");
			}
			//选择1月份时间
			if(value==0){
			  now.setMonth(11);
			  now.setYear(now.getFullYear()-1);
			  taskId = now.format("yyyymm");
			}
			if(value==1){
			  now.setMonth(0);
			  taskId = now.format("yyyymm");
			}
			if(value==2){
			  now.setMonth(1);
			  taskId = now.format("yyyymm");
			}
			if(value==3){
			  now.setMonth(2);
			  taskId = now.format("yyyymm");
			}
			if(value==4){
			   now.setMonth(3);
			  taskId = now.format("yyyymm");
			}
			if(value==5){
			  now.setMonth(4);
			  taskId = now.format("yyyymm");
			}
			if(value==6){
			  now.setMonth(5);
			  taskId = now.format("yyyymm");
			}
			if(value==7){
			  now.setMonth(6);
			  taskId = now.format("yyyymm");
			}
			if(value==8){
			  now.setMonth(7);
			  taskId = now.format("yyyymm");
			}
			if(value==9){
			  now.setMonth(8);
			  taskId = now.format("yyyymm");
			}
			if(value==10){
			   now.setMonth(9);
			  taskId = now.format("yyyymm");
			}
			if(value==11){
			  now.setMonth(10);
			  taskId = now.format("yyyymm");
			}
			return taskId;
	}
	function genSQL() {
	    var taskId=getChoice_date();
		var sql = "SELECT TASK_ID,PROD_CODE,PROD_NAME,TOTAL_FEE FROM USER_VALUE_FINANCE_IMP WHERE task_id=" + taskId;
		return sql;
	}
		
	function query(){
		var grid = new aihb.AjaxGrid({
			header:_header
			,sql: genSQL()
			,ds:"web"
			,isCached : false
		});
		grid.run();
	}
	
	function down(){
		aihb.AjaxHelper.down({
			sql : genSQL()
			,header : _header
			,ds : "web"
			,isCached : false
			,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
			,form : document.tempForm
		});
	}

	window.onload=function(){
		aihb.Util.loadmask();
		showPanel();
		$("queryBtn").onclick = query;
		$("downBtn").onclick = down;
	}
			
}(window,document);
</script>
</body>
</html>