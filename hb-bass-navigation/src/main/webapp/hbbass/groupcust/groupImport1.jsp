<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-智慧旅游目标客户清单导入</TITLE>
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
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&amp;remotePath=import&amp;fileName=智慧旅游目标客户清单.xls"><font color="blue"><b>数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
			<div>说明：</div>
			<div>请在每月1号前按照模版导入相关数据，表格中不能有特殊符号和回车符号</div>
		</td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div>
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


	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
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
			if (ext != "xls") {
				alert("本应用只支持扩展名.xls,请重新上传.");
				return false;
			} else return true;
		};
		vault.setFormField("tableName", "nmk.dw_ent_import1_temp");
		vault.setFormField("columns", "task_id, sequence_id, o_area_name , o_group_name, groupcode, info_ext1, info_ext2, info_ext3, info_ext4, info_ext5, info_ext6");
		vault.setFormField("date", taskId);
		vault.setFormField("ds","dw");
		vault.onUploadComplete = function(files) {
			var _sql = "select count(*) cnt from nmk.dw_ent_import1_temp where task_id='" + taskId +"' ";
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
							var sql = encodeURIComponent("delete from nmk.dw_ent_import1");
							sql += "&sqls=" + encodeURIComponent("insert into nmk.dw_ent_import1(sequence_id, o_area_name , o_group_name, groupcode, info_ext1, info_ext2, info_ext3, info_ext4, info_ext5, info_ext6, info_ext7, info_ext8, info_ext9) select sequence_id, o_area_name , o_group_name, groupcode, info_ext1, info_ext2, info_ext3, info_ext4, info_ext5, info_ext6, info_ext7, info_ext8, info_ext9 FROM nmk.dw_ent_import1_temp ");
										// 删除临时表的数据
										sql += "&sqls=" + encodeURIComponent("delete from nmk.dw_ent_import1_temp ");
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
		}//end onUploadComplete
	};
	
	var _header=[
	{"name":"序号","dataIndex":"sequence_id","cellStyle":"grid_row_cell_text"}
	,{"name":"分公司","dataIndex":"o_area_name","cellStyle":"grid_row_cell_text"}
	,{"name":"集团单位名称","dataIndex":"o_group_name","cellStyle":"grid_row_cell_text"}
	,{"name":"集团单位ID","dataIndex":"groupcode","cellStyle":"grid_row_cell_text"}
	,{"name":"集团单位类型(A/B/C)","dataIndex":"info_ext1","cellStyle":"grid_row_cell_text"}
	,{"name":"2012年省级重点关注集团（是/否）","dataIndex":"info_ext2"}
	,{"name":"归属营业部（县公司）","dataIndex":"info_ext3"}
	,{"name":"集团客户经理","dataIndex":"info_ext4"}
	,{"name":"产品集成经理","dataIndex":"info_ext5"}
	,{"name":"质量保障经理","dataIndex":"info_ext6"}
	];	
	
	function genSQL() {
		var sql = "SELECT sequence_id, o_area_name , o_group_name, groupcode, info_ext1, info_ext2, info_ext3, info_ext4, info_ext5, info_ext6, info_ext7, info_ext8, info_ext9  FROM nmk.dw_ent_import1 WHERE 1= 1 order by 1";
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