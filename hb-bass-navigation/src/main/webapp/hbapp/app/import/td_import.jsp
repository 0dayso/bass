<%@ page language="java" pageEncoding="utf-8"%>

<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-终端价格导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<!--  -->
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	终端价格导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
   <tr class='dim_row' style="padding:5px;">
			<td width="450" align="center" style="color:red;font:bold">*&nbsp;时间批次:
			<input align="right" type="text" id="cycle_id" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate" />
			</td>
			<td>
			&nbsp;
			</td>
	</tr>
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="#" id="downModel"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
		<div>导入说明：</div>
		<div>导入前请先选择导入时间</div>
		<div style="color:red;font:bold">*&nbsp;价格必须是数字</div>
		<div>一次只能导入一个月份的数据</div>
	<div></div>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>

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
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">
	
		+function(window,document,undefined){
			
			//var _params = aihb.Util.paramsObj();
			var tableName="";
			
			function showPanel() {
				
				var vault = new dhtmlXVaultObject();
			    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcelForTD", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
			    vault.setFilesLimit(1);
			   	vault.create("uploadDiv");
	   	    	vault.onFileUpload=function(){
	    			loadmask.style.display="";
	    			return true;
	    		}
		   	
				vault.onAddFile = function(fileName) {
					var ext = this.getFileExtension(fileName);
					if (ext != "csv") {
						alert("本应用只支持扩展名.csv,请重新上传.");
						return false;
					}
					
					if($('cycle_id').value==""||$('cycle_id').value==null){
						alert('请选择要导入的时间批次 !');
						return false;
					}
					tableName="TERMINAL_PRICE"+"_"+$('cycle_id').value;
					vault.setFormField("tableName", "nmk."+tableName);
					vault.setFormField("columns", "EMP_ID,TRNL_ID,TRNL_MODEL,TRNL_TYPE,TRNL_PRICE,IMPORT_TIME");
					return true;
				};						
				
			   	
	    	
		    	vault.onUploadComplete = function(files) {
					loadmask.style.display="none";
					alert("数据已导入,请观察相关表核实");
					window.location.href='td_import.jsp';
		    	}
			};
			
			var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"emp_id",
					"name":["工号"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"trnl_id",
					"name":["终端类型ID"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"trnl_model",
					"name":["终端类型"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"trnl_type",
					"name":["类别"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"trnl_price",
					"name":["价格￥"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"import_time",
					"name":["导入时间"],
					"title":"",
					"cellFunc":""
				}];
			
				
			function query(){
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select emp_id,trnl_id,trnl_model,trnl_type,trnl_price,import_time from nmk."+ tableName+" order by import_time desc with ur"
					,ds:"dw"
					,isCached : false
					,callback : function() {
						
					}
				});
				grid.run();
			}
			
			
			
			var _header2= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"trnl_id",
					"name":["员工ID"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"trnl_id",
					"name":["终端类型ID"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"trnl_model",
					"name":["终端类型"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"trnl_type",
					"name":["类别"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"trnl_price",
					"name":["价格"],
					"title":"",
					"cellFunc":""
				}
				,{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"import_time",
					"name":["导入时间yyyy-mm-dd"],
					"title":"",
					"cellFunc":""
				}];
			function down(){
				aihb.AjaxHelper.down({
					sql : "select emp_id,trnl_id,trnl_model,trnl_type,trnl_price,import_time from nmk.TERMINAL_PRICE where 1=2"
					,header : _header2
					,isCached : false
					,url: "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=csv"
					,form : document.tempForm
				});
			}
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
				$("downModel").onclick = down;
			}
		
		}(window,document);
		
	</script>
</body>
</html>