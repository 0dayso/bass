<%@ page language="java" pageEncoding="utf-8"%>

<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-结果值_分数</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
</head>
<!--  -->
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	结果值_分数导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
      <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=结果值_得分.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
		<div>导入说明：</div>
	<div>
		<ul>
			<li></li>
		</ul>
	</div>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div id="condi2">
	<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
		<tr class='dim_row'>
			<td class='dim_cell_content'>
				<div style="text-align: right; text-align: center">
					<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="查询"/>&nbsp;
					<input type="button" id="downBtn" class="form_button" style="width: 100px" value="下载">&nbsp;
				</div>
			</td>
		</tr>
	</table>
</div>

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
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">

		+function(window,document,undefined){
			
			var taskId = new Date().format("yyyymm");
			var currentTime = new Date().format("yyyymm");
			function showPanel() {
				var vault = new dhtmlXVaultObject();
			    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcel", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
			    vault.setFilesLimit(1);
			   	vault.create("uploadDiv");
	   	    	vault.onFileUpload=function(){
	    			loadmask.style.display="";
	    			return true;
	    		}
		   	
				vault.onAddFile = function(fileName) {
					var ext = this.getFileExtension(fileName);
					if (ext != "xls") {
						alert("本应用只支持扩展名.xls,请重新上传.");
						return false;
					} else return true;
				};						
				
			   	vault.setFormField("tableName", "NMK.ENT_GROUP_ASSESS_KPI_SCORE_IMPORT_TMP");
		    	vault.setFormField("columns", "TASK_ID,TIME_ID,TYPE,NUM,KPI_NAME,TYPE_SCORE,KPI_SCORE,IND1,IND2,IND3,IND4,IND5,IND6,IND7,IND8,IND9,IND10,IND11,IND12,IND13,IND14,IND15,IND16,IND17");
		    	vault.setFormField("date", taskId);  
		    	vault.setFormField("ds","dw");
		    	
		    	vault.onUploadComplete = function(files) {
		    		var _sql = "select count(*) cnt from NMK.ENT_GROUP_ASSESS_KPI_SCORE_IMPORT_TMP where task_id='" + taskId + "' ";
					var _ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/jsondata?method=query"
						,parameters : "sql="+encodeURIComponent(_sql)+"&isCached=false"+"&ds=dw"
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
									//删除表中数据
									var sql = encodeURIComponent("DELETE FROM NMK.ENT_GROUP_ASSESS_KPI_SCORE_IMPORT");
									sql += "&sqls=" + encodeURIComponent("INSERT INTO NMK.ENT_GROUP_ASSESS_KPI_SCORE_IMPORT SELECT ,TIME_ID,TYPE,NUM,KPI_NAME,TYPE_SCORE,KPI_SCORE,IND1,IND2,IND3,IND4,IND5,IND6,IND7,IND8,IND9,IND10,IND11,IND12,IND13,IND14,IND15,IND16,IND17 FROM NMK.ENT_GROUP_ASSESS_KPI_SCORE_IMPORT_TMP ");
									// 删除临时表的数据
									sql += "&sqls=" + encodeURIComponent("DELETE FROM NMK.ENT_GROUP_ASSESS_KPI_SCORE_IMPORT_TMP ");
									var ajaxAdd = new aihb.Ajax({
										url : "${mvcPath}/hbirs/action/sqlExec"
										,parameters : "sqls="+sql+"&ds=dw"
										,loadmask : false
									})
									ajaxAdd.request();
								}
								alert("成功导入"+result[0].cnt+"条记录");
								//最后再查询最新数据
								aihb.Util.loadmask();
								query();
							}catch(e){
								alert("导入失败，请查询数据是否正确");
								return;
							}
						}
					})
					_ajax.request();
		    	}
	    	
			};
			
			var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"time_id",
					"name":["时间"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"type",
					"name":["类型"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"num",
					"name":["num"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"kpi_name",
					"name":["kpi_name"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"type_score",
					"name":["type_score"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"kpi_score",
					"name":["kpi_score"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind1",
					"name":["ind1"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind2",
					"name":["ind2"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind3",
					"name":["ind3"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind4",
					"name":["ind4"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind5",
					"name":["ind5"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind6",
					"name":["ind6"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind7",
					"name":["ind7"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind8",
					"name":["ind8"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind9",
					"name":["ind9"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind10",
					"name":["ind10"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind11",
					"name":["ind11"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind12",
					"name":["ind12"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind13",
					"name":["ind13"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind14",
					"name":["ind14"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind15",
					"name":["ind15"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind16",
					"name":["ind16"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ind17",
					"name":["ind17"],
					"title":"",
					"cellFunc":""
				}
			    ];
	 			
			 		
			function query(){
				var sql = "select * from nmk.ENT_GROUP_ASSESS_KPI_SCORE_IMPORT ";
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: sql
					,ds : "dw"
					,isCached : false
					,callback : function() {
						
					}
				});
				grid.run();
			}
			
			function down(){
				aihb.AjaxHelper.down({
					sql : "select * from nmk.ENT_GROUP_ASSESS_KPI_SCORE_IMPORT with ur"
					,header : _header
					,ds : "dw"
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