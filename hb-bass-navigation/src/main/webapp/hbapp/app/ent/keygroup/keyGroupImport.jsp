<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-集团导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<!--
	20110927修改sql，数据导入NMK.ENT_KEY_INFOTREE_TEMP
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
        
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div style="text-align:right;">
	<input type="button" id="queryBtn" class="form_button"  style="width : 120px" value="查看"/>&nbsp;
	<input type="button" id="downBtn" class="form_button" style="width : 120px" value="下载" onclick="down()">&nbsp;
	<input type="button" id="delBtn" class="form_button" value="删除数据" onClick="_delete()">&nbsp;
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
			var taskId = new Date().format("yyyymmdd") + "@<%=user.getId()%>";
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
				
				/*
				（4）导入周期：不定期，但每日导入时间为早上9:00-当日24:00前，以免生成和导入数据不同步。
				（5）允许导入时间范围：7月15日至9月30日
				*/
				
				vault.enableAddButton(function(time){
					/*
					if(time.getHours() >  9 &&
					   ((time.getMonth()+1) >= 7 && time.getDate() >= 15) &&
					   ((time.getMonth()+1) <= 9 && time.getDate() <= 30)
					)
					
					if(time <= new Date(2010,08,31) && time >= new Date(2010,06,15) && time.getHours() >= 9)
						return true;
					else {
						alert("当前时间禁止导入。导入时间为7月15日至9月30日之9:00~24:00");
						return false;
					}
					*/
					return true;
				}(new Date()));
				
			   	vault.setFormField("tableName", "NMK.ENT_KEY_INFOTREE_TEMP");
		    	//vault.setFormField("columns", "taskid,row_id,group_type,area_name,groupname,groupcode");
		    	vault.setFormField("columns", "taskid,ROW_ID ,GROUPCODE ,GROUPNAME ,CITY_ID ,CITY_NAME ,PGROUPCODE ,PGROUPNAME ,PPGROUPCODE ,PPGROUPNAME ,HEAD_ID ,HEAD_NAME ,LEVEL ,TYPE ,INDUSTRY_NAME ,INDUSTY_TYPE ");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
					//debugger;
		    		//var tempDate = new Date();
		    		//tempDate.setMonth(tempDate.getMonth() - 1);//上个月的
		    		//tempDate.setDate(tempDate.getDate() - 2); //推迟两天
					//var _date = tempDate.format("yyyymm");
		    		//var sql=encodeURIComponent("update college_jiajika_import_temp set flag='成功' where taskid='" + taskId + "'"); //先全部置为成功
		    		/*
		    		sql += "&sqls=" + encodeURIComponent("update NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_UPLOADTEMP set flag='已存在相同渠道编码' where taskid='" + taskId + "' and channel_id in (select distinct channel_id from NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_" + _date + " )");
					sql += "&sqls=" + encodeURIComponent("insert into  NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_" + _date + " (CHANNEL_ID,Customer_service_score,Competitive_strategy_score,Image_score,Development_strategy_score) select CHANNEL_ID,round(Customer_service_score,2),round(Competitive_strategy_score,2),round(Image_score,2),round(Development_strategy_score,2) from NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_UPLOADTEMP where taskid='" + taskId + "' and flag='成功'");
					*/
					//第0行,第0列验证浮点数不通过，该行略过序号
					 /* 删除老记录 为什么要删除老记录需要确认？从目前表里的数据来看，并不是一个人导入全部地市的数据，而是分批导的。*/
					var sql= encodeURIComponent("delete from NMK.ENT_KEY_INFOTREE ");
					 /* 插入新记录 */
					sql += "&sqls=" + encodeURIComponent("insert into NMK.ENT_KEY_INFOTREE(ROW_ID,GROUPCODE,GROUPNAME,CITY_ID,CITY_NAME,PGROUPCODE,PGROUPNAME,PPGROUPCODE,PPGROUPNAME,HEAD_ID,HEAD_NAME,LEVEL,TYPE,INDUSTRY_NAME,INDUSTY_TYPE) select distinct ROW_ID,GROUPCODE,GROUPNAME,CITY_ID,CITY_NAME,PGROUPCODE,PGROUPNAME,PPGROUPCODE,PPGROUPNAME,HEAD_ID,HEAD_NAME,LEVEL,TYPE,INDUSTRY_NAME,INDUSTY_TYPE from NMK.ENT_KEY_INFOTREE_TEMP ");
					/* 删除零时表 */
					sql += "&sqls=" + encodeURIComponent("delete from nmk.ent_key_group ");
					
					sql += "&sqls=" + encodeURIComponent("insert into nmk.ent_key_group(row_id,group_type,area_name,groupname,groupcode) select distinct row_id,TYPE,CITY_NAME,groupname,groupcode from NMK.ENT_KEY_INFOTREE_TEMP ");
					
					sql += "&sqls=" + encodeURIComponent("delete from NMK.ENT_KEY_INFOTREE_TEMP ");
					var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/sqlExec"
					,parameters : "sqls="+sql
					,loadmask : false
					,callback : function(xmlrequest){
						alert("导入完成");
						//query();
						loadmask.style.display="none";
						//tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/report/college/uploadinfo.html?taskId=" + taskId + "&" + _params._oriUri});
					}
				});
					ajax.request();
		    	}
			};
			
			var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"row_id",
					"name":["序号"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"groupcode",
					"name":["集团客户编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"groupname",
					"name":["集团客户名称"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"city_id",
					"name":["地市编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"city_name",
					"name":["地市名称"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"pgroupcode",
					"name":["上一级集团客户编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"pgroupname",
					"name":["上一级集团客户名称"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ppgroupcode",
					"name":["上两级集团客户编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"ppgroupname",
					"name":["上两级集团客户名称"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"head_id",
					"name":["总部集团客户编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"head_name",
					"name":["总部集团客户名称"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"level",
					"name":["集团客户级别"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"type",
					"name":["集团客户类型"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"industry_name",
					"name":["集团客户所属行业类别1"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"industy_type",
					"name":["集团客户所属行业类别2"],
					"title":"",
					"cellFunc":""
				}
			];
		
			function query(){
				//loadmask.style.display="";
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select row_id  ,groupcode  ,groupname  ,city_id  ,city_name  ,pgroupcode  ,pgroupname  ,ppgroupcode  ,ppgroupname  ,head_id  ,head_name  ,level  ,type  ,industry_name  ,industy_type  from nmk.ent_key_infotree order by row_id"
					,isCached : false
					,callback : function() {
						//alert("导入成功!") 
						//loadmask.style.display="none";
					}
				});
				grid.run();
			}

			function down(){
				aihb.AjaxHelper.down({
					sql : "select row_id  ,groupcode  ,groupname  ,city_id  ,city_name  ,pgroupcode  ,pgroupname  ,ppgroupcode  ,ppgroupname  ,head_id  ,head_name  ,level  ,type  ,industry_name  ,industy_type  from nmk.ent_key_infotree order by row_id"
					,header : _header
					,isCached : false
					,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}

			function _delete() {
				if(!window.confirm("确定要删除吗？删除前应先下载这些记录做备份"))
					return;
				var sql=encodeURIComponent("delete from nmk.ent_key_infotree ");
				var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/sqlExec"
					,parameters : "sqls="+sql
					,loadmask : false
					,callback : function(xmlrequest){
						var result = eval("(" + xmlrequest.responseText + ")");
						alert(result.message);
					}
				});
				ajax.request();
			}
			
			window.onload=function(){
				aihb.Util.loadmask();
				showPanel();
				/*
				$("failNum").onclick=function(){
		 			tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/channel/uploadinfo.html?taskId=" + taskId + "&" +_params._oriUri})
				}
				*/
				$("queryBtn").onclick = query;
				$("delBtn").onclick = _delete;
				$("downBtn").onclick = down;
			}
		
		}(window,document);
		
	</script>
</body>
</html>