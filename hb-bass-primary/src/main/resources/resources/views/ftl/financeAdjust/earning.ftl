<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html xmlns:ai>
  <head>
    <title>财务调整</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/resources/js/default/default_min.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/tabext.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/jquery/jquery.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/grid.js"></script>
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
		vault.setFormField("tableName", "NMK.FINANCE_CHARGE_ADJ_CFG_TEMP");
		vault.setFormField("columns", "TASK_ID, MONTH_ID, AREA_ID , CHARGE, KIND");
		vault.setFormField("date", taskId);
		vault.setFormField("ds","nl");
		vault.onUploadComplete = function(files) {
			var _sql = "select count(*) cnt from NMK.FINANCE_CHARGE_ADJ_CFG_TEMP where task_id='" + taskId + "'and month_id <> 0 ";
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
							//将临时表的数据插入正式表，插入时校验手机号和IMEI的长度
							var sql = encodeURIComponent("INSERT INTO NMK.FINANCE_CHARGE_ADJ_CFG(MONTH_ID, AREA_ID , CHARGE, KIND, INPUT_DATE) SELECT MONTH_ID, AREA_CODE AREA_ID , CHARGE, KIND, DATE(CURRENT TIMESTAMP) INPUT_DATE FROM NMK.FINANCE_CHARGE_ADJ_CFG_TEMP INNER JOIN NMK.REP_AREA_REGION ON TRIM(AREA_ID) = AREA_NAME WHERE MONTH_ID <> 0 ");
							// 删除临时表的数据
							sql += "&sqls=" + encodeURIComponent("DELETE FROM NMK.FINANCE_CHARGE_ADJ_CFG_TEMP ");
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
		}
	};
	
	var _header=[
	{"name":"帐期","dataIndex":"month_id","cellStyle":"grid_row_cell_text"}
	,{"name":"地市","dataIndex":"area_name","cellStyle":"grid_row_cell_text"}
	,{"name":"金额(元)","dataIndex":"charge","cellStyle":"grid_row_cell_text"}
	,{"name":"收入调整规则","dataIndex":"kind_name","cellStyle":"grid_row_cell_text"}
	,{"name":"导入时间","dataIndex":"input_date","cellStyle":"grid_row_cell_text"}
	];	
	
	function genSQL() {
		var sql = "SELECT MONTH_ID, AREA_NAME, CHARGE, KIND_NAME, INPUT_DATE FROM NMK.FINANCE_CHARGE_ADJ_CFG FC INNER JOIN  NMK.REP_AREA_REGION RA ON FC.AREA_ID = RA.AREA_CODE INNER JOIN NMK.DIM_FINANCE_CHARGE_ADJ_KIND DF ON FC.KIND = DF.KIND WHERE 1=1 ";
		if($("date1").value!=null){
			sql = sql + " AND MONTH_ID="+$("date1").value+" "
		}
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
					<td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=imei&amp;fileName=财务调整.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
						<div>导入说明：</div>
						<div>1.导入顺序为：账期,地市,金额(元),收入类调整 </div>
						<div>2.调整类型 :A1:收入,A2:收入+预存款刮刮卡(流入+划账),A3:收入+预存款刮刮卡(划账+余额),B1:折扣,B2:折扣+预存款刮刮卡(流入+划账)</div>
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
