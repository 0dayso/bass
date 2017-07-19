<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-重点关注集团关键人每月数据更新导入</TITLE>
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
	<script type="text/javascript">
+function(window,document,undefined){
	var _params = aihb.Util.paramsObj();
	var taskId = new Date().format("yyyymmdd");
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
			if (ext != 'xls') {
				alert("本应用只支持扩展名.xls,请重新上传.");
				return false;
			} else return true;
		};
		vault.setFormField("tableName", "NMK.ENT_120KEYMEMBER_CFG_TMP");
		vault.setFormField("columns", "TASK_ID, PROFESS_NAME, AREA_NAME , HEAD_GROUPNAME, GROUPCODE, LEVEL,STAFF_NAME,DEPARTMENT");
		vault.setFormField("date", taskId);
		vault.setFormField("ds","dw");
		vault.onUploadComplete = function(files) {
			var _sql = "select count(*) cnt from NMK.ENT_120KEYMEMBER_CFG_TMP where task_id='" + taskId + "' ";
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
							//删除正式表
							var sql = encodeURIComponent("DELETE FROM NMK.ENT_120KEYMEMBER_CFG");
							//将临时表的数据插入正式表
							sql += "&sqls=" + encodeURIComponent("INSERT INTO NMK.ENT_120KEYMEMBER_CFG(PROFESS_NAME, AREA_NAME , HEAD_GROUPNAME, GROUPCODE, LEVEL,STAFF_NAME,DEPARTMENT) SELECT PROFESS_NAME, AREA_NAME , HEAD_GROUPNAME, GROUPCODE, LEVEL,STAFF_NAME,DEPARTMENT FROM NMK.ENT_120KEYMEMBER_CFG_TMP ");
							// 删除临时表的数据
							sql += "&sqls=" + encodeURIComponent("DELETE FROM NMK.ENT_120KEYMEMBER_CFG_TMP ");
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
	
	var _header=[
	{"name":"PROFESS_NAME","dataIndex":"PROFESS_NAME","cellStyle":"grid_row_cell_text"}
	,{"name":"AREA_NAME","dataIndex":"AREA_NAME","cellStyle":"grid_row_cell_text"}
	,{"name":"HEAD_GROUPNAME","dataIndex":"HEAD_GROUPNAME","cellStyle":"grid_row_cell_text"}
	,{"name":"GROUPCODE","dataIndex":"GROUPCODE","cellStyle":"grid_row_cell_text"}
	,{"name":"LEVEL","dataIndex":"LEVEL","cellStyle":"grid_row_cell_text"}
	,{"name":"STAFF_NAME","dataIndex":"STAFF_NAME","cellStyle":"grid_row_cell_text"}
	,{"name":"DEPARTMENT","dataIndex":"DEPARTMENT","cellStyle":"grid_row_cell_text"}
	];	
	
	function genSQL() {
		var sql = "SELECT PROFESS_NAME, AREA_NAME , HEAD_GROUPNAME, GROUPCODE, LEVEL,STAFF_NAME,DEPARTMENT FROM NMK.ENT_120KEYMEMBER_CFG WHERE 1=1 ";
		return sql;
	}
		
	function query(){
		var grid = new aihb.AjaxGrid({
			header:_header
			,sql: genSQL()
			,ds:"dw"
			,isCached : false
		});
		grid.run();
	}
	
	function down(){
		aihb.AjaxHelper.down({
			sql : genSQL()
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