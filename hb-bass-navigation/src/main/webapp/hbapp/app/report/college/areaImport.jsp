<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%
User user = (User)session.getAttribute("user");
%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-区域化用户导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<!--
	@author:yulei3
	@date:20120918
	@desc:对区域化暂未归属用户进一步个性化改造 前台导入数据
-->
</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend>
	数据导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
        <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a id="downModel" style="text-decoration: underline;" href="#"><font color=blue><b>导入数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font> &nbsp;&nbsp;&nbsp;<img style="cursor:pointer;" onclick="javascript:window.location.href='${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=college&fileName=湖北经营分析系统-高校监控直送卡专题操作手册.doc'" src="${mvcPath}/hbapp/resources/image/default/docs.gif" title="帮助文件下载" />
        	<div>导入说明：</div>
	<div>1.重复记录:导入文件中不能有重复的记录(相同的用户ID视为重复,包括文件本身的重复记录和与已有记录重复两种情况)  </div>
	<div>2.错误记录:
		<ul>
			<li>用户编码不在用户资料表中的视为无效记录; </li>
			<li>地区和县区编码不在基站参数表的视为无效记录;</li>
			
		</ul>
	</div>
	<div>3.本程序将做基于上述规则的自动验证，只有符合要求的记录才能被导入。</div>
	<div>4.本功能目前只对武汉地区开放,别的地区暂不开放,如果需要请提申请开通。</div>
        	<td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div style="text-align:right;">
	<font color=red>请下载未成功导入的数据编辑后重新上传</font>
	<input type="button" id="logBtn" class="form_button"  style="width : 120px" value="导入日志查看"/>&nbsp;
	<input type="button" id="queryFailBtn" class="form_button"  style="width : 120px" value="未导入成功号码查看"/>&nbsp;
	<input type="button" id="downFailBtn" class="form_button" style="width : 120px" value="未导入成功号码下载" onclick="down()">&nbsp;
	<input type="button" id="querySuccBtn" class="form_button" style="width : 120px" value="成功号码查看">&nbsp;
	<input type="button" id="downSuccBtn" class="form_button" style="width : 120px" value="成功号码下载">&nbsp;
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
			var etl_cycle_id = new Date().format("yyyyMMdd") ;
			var userId='<%=user.getId()%>';
			var tableName="nmk.bureau_mbuser_nobelong_"+etl_cycle_id.substring(0,6);
			function showPanel() {
				var vault = new dhtmlXVaultObject();
			    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcelForArea", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
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
				
				//vault.enableAddButton(true);
			   	vault.setFormField("etl_cycle_id", etl_cycle_id);
		    	vault.setFormField("columns", "mbuser_id,acc_nbr,area_code,county_code,succ_flag,etl_cycle_id");
		    	vault.setFormField("tableName", tableName);  
	    	
		    	vault.onUploadComplete = function(files) {
					showPanel();
					//loadmask.style.display="none";
					alert("导入完成,正在查询未导入成功号码");
					query();
		    	}
			}
			
			var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"etl_cycle_id",
					"name":["插入日期"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"area_name",
					"name":["地方编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"start_time",
					"name":["导入开始时间"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"end_time",
					"name":["导入结束时间"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"count_all",
					"name":["导入总条数"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"count_succ",
					"name":["导入成功条数"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"count_fail",
					"name":["导入失败条数"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"staff_id",
					"name":["员工号"],
					"title":"",
					"cellFunc":""
				}
			];
		
			var _header2=[
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"mbuser_id",
					"name":["用户ID"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"acc_nbr",
					"name":["用户号码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"area_code",
					"name":["地市编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"county_code",
					"name":["区县编码"],
					"title":"",
					"cellFunc":""
				}
			];
			function query(){
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select etl_cycle_id,b.area_name,start_time,end_time,count_all,count_succ,count_fail,staff_id from bureau_mbuser_nobelong_log a,nmk.cmcc_area b where a.staff_id='"+userId+"' and a.area_code=b.area_code order by start_time desc"
					,isCached : false
				});
				grid.run();
			}
			function queryFail(){
				window.showModalDialog("queryArea.jsp?method=fail", null, 'dialogWidth:900px;dialogHeight:560px;status:no;help:no;');	
			}
			function querySucc(){
				window.showModalDialog("queryArea.jsp?method=succ", null, 'dialogWidth:900px;dialogHeight:560px;status:no;help:no;');
			}
			function downFail(){
				aihb.AjaxHelper.down({
					sql : "select mbuser_id,acc_nbr,area_code,county_code from "+tableName+" where succ_flag='0' and etl_cycle_id="+etl_cycle_id
					,header : _header2
					,isCached : false
					,url: "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}
			function downSucc(){
				aihb.AjaxHelper.down({
					sql : "select mbuser_id,acc_nbr,area_code,county_code from "+tableName+" where succ_flag='1' and etl_cycle_id="+etl_cycle_id
					,header : _header2
					,isCached : false
					,url: "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}
			function downModel(){
				aihb.AjaxHelper.down({
					sql : "select MBUSER_ID,ACC_NBR,AREA_CODE,COUNTY_CODE from NMK.BUREAU_MBUSER_INFO_201107 where county_code is not null  fetch first 10 rows only"
					,header : _header2
					,isCached : false
					,url: "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}

			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
				/*
				$("failNum").onclick=function(){
		 			tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/channel/uploadinfo.html?taskId=" + taskId + "&" +_params._oriUri})
				}
				*/
				$("queryFailBtn").onclick = queryFail;
				$("downFailBtn").onclick = downFail;
				$("querySuccBtn").onclick = querySucc;
				$("downSuccBtn").onclick = downSucc;
				$("downModel").onclick = downModel;
				$("logBtn").onclick = query;
			}
		
		}(window,document);
		
	</script>
</body>
</html>