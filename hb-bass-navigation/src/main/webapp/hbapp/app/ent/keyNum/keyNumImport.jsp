<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-集团导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<!--
	20100802 : 修改时间bug
	20100803 : 继续修改时间bug, 修改导入完成验证时关联昨天记录的bug, 增加where条件中的taskid
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
		var tempDate = new Date();
		var year = tempDate.getYear();
		var month = tempDate.getMonth();
		tempDate = new Date(year,month);
		tempDate.setMonth(tempDate.getMonth() - 1);//上月
		//debugger;
		var _date = tempDate.format("yyyymm");
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
				/*
				vault.enableAddButton(function(time){
					
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
					
					return true;
				}(new Date()));
				*/
			   	vault.setFormField("tableName", "nmk.ent_key_num_temp");
		    	vault.setFormField("columns", "taskid,area_name,key_num");
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
					 /* 删除当前月份记录,可能没有 */
					var sql= encodeURIComponent("delete from nmk.ent_key_num where time_id="+_date);
					 /* 插入新记录 */
					sql += "&sqls=" + encodeURIComponent("insert into nmk.ent_key_num(area_name,key_num,time_id,area_code) select a.area_name,a.key_num,"+_date+",b.area_code from nmk.ent_key_num_temp as a,(select case when area_name='襄樊' then '襄阳' else area_name end area_name,area_code from nmk.rep_area_region) as b where a.area_name=b.area_name");
					/* 删除零时表 */
					sql += "&sqls=" + encodeURIComponent("delete from nmk.ent_key_num_temp");
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
					"dataIndex":"area_name",
					"name":["地市"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"key_num",
					"name":["在册员工数"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"time_id",
					"name":["月份"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"area_code",
					"name":["地市编码"],
					"title":"",
					"cellFunc":""
				}
			];
		
			function query(){
				//loadmask.style.display="";
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select area_name,key_num,time_id,area_code from nmk.ent_key_num where time_id="+_date
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
					sql : "select area_name,key_num,time_id,area_code from nmk.ent_key_num where time_id="+_date
					,header : _header
					,isCached : false
					,"url" : "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}

			function _delete() {
				if(!window.confirm("确定要删除吗？删除前应先下载这些记录做备份"))
					return;
				var sql=encodeURIComponent("delete from nmk.ent_key_num where time_id="+_date);
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
				//$("delBtn").onclick = _delete;
				$("downBtn").onclick = down;
			}
		
		}(window,document);
		
	</script>
</body>
</html>