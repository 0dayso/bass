<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>历史账期调整</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/datepicker/WdatePicker.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/util.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default.js"></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/css/default/default.css" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/resources/js/codebase/dhtmlxvault.css" />
	<form name="tempForm" action=""></form>
	<script type="text/javascript">
+function(window,document,undefined){
	var _params = aihb.Util.paramsObj();
	var taskId = new Date().format("yyyymmdd");
	function showPanel() {
		var vault = new dhtmlXVaultObject();
		vault.setImagePath("${mvcPath}/resources/js/codebase/imgs/");
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
		vault.setFormField("tableName", "NWH.DW_ACCT_ITEM_ADJ_LOAD");
		vault.setFormField("columns", "TASK_ID, MONTH_ID, ADJ_MONTH_ID , ACCT_ID, SERV_ID, ACCT_ITEM_TID, BILL_CHARGE, KIND, TAXRATE, TAX");
		vault.setFormField("date", taskId);
		vault.setFormField("ds","nl");
		vault.onUploadComplete = function(files) {
			//判断此次导入的账期是否已经存在，如果存在则导入失败，否则继续导入
//			var _ajaxCheck = new aihb.Ajax({
//				url : "/hbirs/action/jsondata?method=check"
//				,loadmask : true
//				,callback : function(xmlrequest){
//					var resultCheck = xmlrequest.responseText;
//					resultCheck = eval(resultCheck);
//					if(resultCheck[0].count==0){
						//查询临时表有多少条合法记录待此次导入
						
//					}else {
//						alert("账期已存在,导入失败");
//					}
//				}
//			});
//			_ajaxCheck.request();
			
			var _sql = "select count(*) cnt from NWH.DW_ACCT_ITEM_ADJ_LOAD where task_id='" + taskId + "'and month_id <> 0 ";
						var _ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/jsondata?method=query"
							,parameters : "sql="+strEncode(_sql)+"&isCached=false"+"&ds=nl"
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
										var sql = encodeURIComponent("insert into NWH.DW_ACCT_ITEM_ADJ_HIST(MONTH_ID, ADJ_MONTH_ID , ACCT_ID, SERV_ID, ACCT_ITEM_TID, BILL_CHARGE, TAXRATE, TAX, KIND) select MONTH_ID, ADJ_MONTH_ID , ACCT_ID, SERV_ID, ACCT_ITEM_TID, BILL_CHARGE, TAXRATE, TAX, KIND FROM NWH.DW_ACCT_ITEM_ADJ_LOAD WHERE MONTH_ID <> 0 ");
										// 删除临时表的数据
										sql += "&sqls=" + encodeURIComponent("delete from NWH.DW_ACCT_ITEM_ADJ_LOAD ");
										var ajaxAdd = new aihb.Ajax({
											url : "${mvcPath}/hbirs/action/sqlExec"
											,parameters : "sqls="+sql+"&ds=nl"
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
		}//end onUploadComplete
	};
	
	var _header=[
	{"name":"帐期","dataIndex":"month_id","cellStyle":"grid_row_cell_text"}
	,{"name":"调整帐期","dataIndex":"adj_month_id","cellStyle":"grid_row_cell_text"}
	,{"name":"账户id","dataIndex":"acct_id","cellStyle":"grid_row_cell_text"}
	,{"name":"用户id","dataIndex":"serv_id","cellStyle":"grid_row_cell_text"}
	,{"name":"账单科目","dataIndex":"acct_item_tid","cellStyle":"grid_row_cell_text"}
	,{"name":"金额(分)","dataIndex":"bill_charge","cellStyle":"grid_row_cell_text"}
	,{"name":"税率","dataIndex":"taxrate","cellStyle":"grid_row_cell_text"}
	,{"name":"税","dataIndex":"tax","cellStyle":"grid_row_cell_text"}
	,{"name":"调整类型","dataIndex":"kind"}
	];	
	
	function genSQL() {
		var sql = "SELECT MONTH_ID, ADJ_MONTH_ID , ACCT_ID, SERV_ID, ACCT_ITEM_TID, BILL_CHARGE, value(TAXRATE,0) TAXRATE, value(TAX,0) TAX, (CASE WHEN KIND = 1 THEN '手工出调整报表,本月核查体现' WHEN KIND = 2 THEN '本月出账体现' ELSE  '' END) KIND  FROM NWH.DW_ACCT_ITEM_ADJ_HIST WHERE 1= 1 AND MONTH_ID = "+ $("date1").value;
		return sql;
	}
		
	function query(){
		var grid = new aihb.AjaxGrid({
			header:_header
			,sql: genSQL()
			,ds:"nl"
			,isCached : false
			,url : "${mvcPath}/hbirs/action/jsondata?method=query&qType=limit"
		});
		grid.run();
	}
	
	function down(){
		aihb.AjaxHelper.down({
			sql : genSQL()
			,header : _header
			,ds : "nl"
			,isCached : false
			,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
			,form : document.tempForm
		});
	}

	window.onload=function(){
		aihb.Util.loadmask();
		showPanel();
		var _d=new Date();
		$("date1").value=_d.format("yyyymm");
		$("queryBtn").onclick = query;
		$("downBtn").onclick = down;
	}
			
}(window,document);
</script>
  </head>
  <body>
  	<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
			<legend>
				数据导入
			</legend>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr style="padding: 5px;">
					<td width="450"><div id="uploadDiv"></div></td>
					<td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=imei&amp;fileName=历史账期调整.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
						<div>导入说明：</div>
						<div>1.导入顺序为：账期,调整账期,用户ID,账单科目,金额,调整类型 </div>
						<div>2.调整类型 1:手工出调整报表,本月核查体现 2:本月出账体现 3:以销帐金额调整</div>
						<div>3.调增收入金额取正数,调减收入金额取负数</div>
						<div>4.如果在导入过程中出现故障，请联系万纯(13476080947)</div>
					</td>
				</tr>
			</table>
		</fieldset>
<form method="post" action="">
	<div>
		<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>
			<tr class='dim_row'>
				<td class='dim_cell_title'>导入月份</td>
				<td class='dim_cell_content'>
					<input align="right" type="text" id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMM'})" class="Wdate"/>
				</td>
				<td class='dim_cell_title'>操作</td>
				<td class='dim_cell_content'>
					<div style="text-align: right; text-align: center">
						<input type="button" id="queryBtn" class="form_button"  style="width: 100px" value="导入数据查询"/>&nbsp;
						<input type="button" id="downBtn" class="form_button" style="width: 100px" value="导入数据下载">&nbsp;
					</div>
				</td>
			</tr>
		</table>
	</div>
  	<div class="divinnerfieldset">
  		<fieldset>
			<legend>
				<table>
					<tr>
						<td>
  							<img src="${mvcPath}/resources/image/default/ns-expand.gif" alt=""></img>&nbsp;数据展现区域：
  						</td>
  					</tr>
  				</table>
  			</legend>
  			<div id="grid" style="display:none;"></div>
  		</filedset>	
  	</div>
</form>
  </body>
</html>
