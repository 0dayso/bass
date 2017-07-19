<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-直送卡导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<!--
	20100802 : 修改时间bug
	20100803 : 继续修改时间bug, 修改导入完成验证时关联昨天记录的bug, 增加where条件中的taskid
	20110721 : 修改”直送卡“为”直送卡“，增加删除今日导入数据的功能
-->
</head>
<body bgcolor="#EFF5FB" margin=0>
<fieldset  align="center" style="width:95%;margin: 10px 0px 0px 10px;">
 <legend>
	数据导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
        <td width="450"><div id="uploadDiv"></div></td>
        <td valign="top"><a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=college&fileName=直送卡导入.xls"><font color=blue><b>导入数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font> &nbsp;&nbsp;&nbsp;<img style="cursor:pointer;" onclick="javascript:window.location.href='${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=college&fileName=湖北经营分析系统-高校监控直送卡专题操作手册.doc'" src="${mvcPath}/hbapp/resources/image/default/docs.gif" title="帮助文件下载" />
        	<div>导入说明：</div>
	<div>1.重复记录:导入文件中不能有重复的记录(相同的手机号码视为重复,包括文件本身的重复记录和与已有记录重复两种情况) </div>
	<div>2.错误记录:
		<ul>
			<li>号码位数不为11视为号码错误; </li>
			<li>号码不以134、135、136、137、138、139、158、159、150、151、152、187、188、147、157、182、183开头视为非移动号码错误; </li>
			<li>系统找不到的高校编码或地市编码视为错误记录;</li>
			<li>高校编码前五位不等于地市编码即为高校不属于该地市的错误记录;</li>
		</ul>
	</div>
	<div>3.本程序将做基于上述规则的自动验证，只有符合要求的记录才能被导入。</div>
        	<td>
      </tr>
   </table>
</fieldset>

<form method="post" action=""><br>
<div style="width:95%;text-align:right;">
	<font color=red>请下载未成功导入的数据编辑后重新上传</font>
	<input type="button" id="queryBtn" class="form_button"  style="width : 120px" value="未导入成功号码查看"/>&nbsp;
	<input type="button" id="downBtn" class="form_button" style="width : 120px" value="未导入成功号码下载" onclick="down()">&nbsp;
	<input type="button" id="delBtn" class="form_button" value="删除非法数据" onClick="_delete()">&nbsp;
	<input type="button" id="delTodayBtn" class="form_button" style="width : 120px" value="删除今日导入数据" onClick="_deleteToday()">&nbsp;
</div>

<div class="divinnerfieldset">
<fieldset style="width:95%;margin: 10px 0px 0px 10px;">
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
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"></script>
	<script type="text/javascript" src="${mvcPath}/resources/js/default/des.js" charset=utf-8></script>
	<script type="text/javascript">
		+function(window,document,undefined){
			
			var _params = aihb.Util.paramsObj();
			
			var taskId = new Date().format("yyyymmdd") + "@" + '<%=user.getId()%>';
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
					*/
				//	if(time <= new Date(2011,08,31) && time >= new Date(2011,07,1) && time.getHours() >= 9)
				if(time.getHours() >= 9 ){
					if(time.getMonth()+1 >= 7 && time.getDate() >= 1){
						return true;	
					}else if(time.getMonth()+1 <= 9 && time.getDate() <= 30){
						return true;	
					}
					else {
						alert("当前时间禁止导入。导入时间为8月1日至9月30日之9:00~24:00");
						$("delTodayBtn").disabled=true;
						return false;
					}
				}
				else {
					alert("当前时间禁止导入。导入时间为8月1日至9月30日之9:00~24:00");
					$("delTodayBtn").disabled=true;
					return false;
				}
					
				}(new Date()));
			   	vault.setFormField("tableName", "COLLEGE_JIAJIKA_IMPORT_TEMP");
		    	vault.setFormField("columns", "taskid,area_id,college_id,acc_nbr");
		    	vault.setFormField("date", taskId);  
	    	
		    	vault.onUploadComplete = function(files) {
					//debugger;
		    		var tempDate = new Date();
		    		tempDate.setMonth(tempDate.getMonth() - 1);//上个月的
		    		tempDate.setDate(tempDate.getDate() - 2); //推迟两天
					var _date = tempDate.format("yyyymm");
		    		//var sql=encodeURIComponent("update COLLEGE_JIAJIKA_IMPORT_TEMP set flag='成功' where taskid='" + taskId + "'"); //先全部置为成功
		    		/*
		    		sql += "&sqls=" + encodeURIComponent("update NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_UPLOADTEMP set flag='已存在相同渠道编码' where taskid='" + taskId + "' and channel_id in (select distinct channel_id from NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_" + _date + " )");
					sql += "&sqls=" + encodeURIComponent("insert into  NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_" + _date + " (CHANNEL_ID,Customer_service_score,Competitive_strategy_score,Image_score,Development_strategy_score) select CHANNEL_ID,round(Customer_service_score,2),round(Competitive_strategy_score,2),round(Image_score,2),round(Development_strategy_score,2) from NMK.CHL_SOCIAL_VALUE_IMPORT_SCORE_UPLOADTEMP where taskid='" + taskId + "' and flag='成功'");
					*/
					var sql= encodeURIComponent("delete from COLLEGE_JIAJIKA_IMPORT_TEMP where taskid='" + taskId + "' and acc_nbr='直送卡号码'");//删除表头
					
					sql += "&sqls=" + encodeURIComponent("update COLLEGE_JIAJIKA_IMPORT_TEMP set flag=flag || '手机号码与已有记录重复;' where taskid='" + taskId + "' and acc_nbr in (select distinct acc_nbr from COLLEGE_JIAJIKA_IMPORT )");
					 /* temp表中存在重复的acc_nbr */
					sql += "&sqls=" + encodeURIComponent("update COLLEGE_JIAJIKA_IMPORT_TEMP set flag=flag || '手机号码与其他记录重复;' where taskid='" + taskId + "' and acc_nbr in (select acc_nbr from college_jiajika_import_temp where taskid='" + taskId + "' group by acc_nbr having count(*) >1)");
					 /* 手机号码位数不为11位 */
					sql += "&sqls=" + encodeURIComponent("update COLLEGE_JIAJIKA_IMPORT_TEMP set flag=flag || '手机号码位数错误;' where  taskid='" + taskId + "' and length(acc_nbr) != 11");
					 /* 手机号码不以移动号码域开头 */
					sql += "&sqls=" + encodeURIComponent("update COLLEGE_JIAJIKA_IMPORT_TEMP set flag=flag || '非移动号码;' where  taskid='" + taskId + "' and substr(acc_nbr,1,3) not in ('134','135','136','137','138','139','158','159','150','151','152','187','188','147','157','182','183')");
					 /* 高校编码不对应地市编码 */
					sql += "&sqls=" + encodeURIComponent("update COLLEGE_JIAJIKA_IMPORT_TEMP set flag=flag || '高校不属于该地市;' where taskid='" + taskId + "' and substr(college_id,1,5) != area_id");
					 /* 高校编码有误 */
					sql += "&sqls=" + encodeURIComponent("update COLLEGE_JIAJIKA_IMPORT_TEMP set flag=flag || '高校编码有误;' where taskid='" + taskId + "' and college_id not in(select distinct college_id from nwh.college_info where state=1)");
					 /* 地市编码有误 */
					sql += "&sqls=" + encodeURIComponent("update COLLEGE_JIAJIKA_IMPORT_TEMP set flag=flag || '地市编码有误;' where taskid='" + taskId + "' and area_id not in(select area_code from mk.bt_area)");
					 /* 剩余就是成功 */
					sql += "&sqls=" + encodeURIComponent("insert into COLLEGE_JIAJIKA_IMPORT(acc_nbr,area_id,college_id,user_id) select acc_nbr,area_id,college_id,'" + '<%=user.getId()%>' + "' from COLLEGE_JIAJIKA_IMPORT_TEMP where taskid='" + taskId + "' and (flag = '' or flag is null) ");
					 /* 删除成功记录 */
					sql += "&sqls=" + encodeURIComponent("delete from COLLEGE_JIAJIKA_IMPORT_TEMP where taskid='" + taskId + "' and (flag = '' or flag is null) ");
					
					var ajax = new aihb.Ajax({
					url : "${mvcPath}/hbirs/action/sqlExec"
					,parameters : "sqls="+sql
					,loadmask : false
					,callback : function(xmlrequest){
						alert("导入完成,正在查询未导入成功号码");
						query();
						//loadmask.style.display="none";
						//tabAdd({title:'未导入成功号码',url:"${mvcPath}/hbapp/app/report/college/uploadinfo.html?taskId=" + taskId + "&" + _params._oriUri});
					}
				});
					ajax.request();
		    	}
			};
			
			var _header= [
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"area_id",
					"name":["地市编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"college_id",
					"name":["高校编码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"acc_nbr",
					"name":["直送卡号码"],
					"title":"",
					"cellFunc":""
				},
				{
					"cellStyle":"grid_row_cell_text",
					"dataIndex":"flag",
					"name":["未成功原因"],
					"title":"",
					"cellFunc":""
				}
			];
		
			function query(){
				var grid = new aihb.SimpleGrid({
					header:_header
					,sql: "select taskid, acc_nbr, area_id, college_id, date(import_time)as import_time,flag from COLLEGE_JIAJIKA_IMPORT_TEMP where taskid='" + taskId + "'"
					,isCached : false
					,callback : function() {
						var _length = grid.grid.data.length;
						if(_length == 0)
							alert("本次导入全部成功!") 
						else {
							alert("本次有" + _length + "条记录没有导入成功!");
						}
					}
				});
				grid.run();
			}
			function down(){
				aihb.AjaxHelper.down({
					sql : "select  acc_nbr, area_id, college_id from COLLEGE_JIAJIKA_IMPORT_TEMP where taskid='" + taskId + "'"
					,header : _header
					,isCached : false
					,url: "${mvcPath}/hbirs/action/jsondata?method=down&fileKind=excel"
					,form : document.tempForm
				});
			}

			function _delete() {
				if(!window.confirm("确定要删除吗？删除前应先下载这些记录做备份"))
					return;
				var sql=encodeURIComponent("delete from COLLEGE_JIAJIKA_IMPORT_TEMP where taskid='" + taskId + "'");
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
			function _deleteToday(){
				if(!window.confirm("确定要删除您今日导入的数据吗？"))
					return;
				var _currentDate = new Date().format("yyyy-mm-dd");
				var sql=encodeURIComponent("delete from COLLEGE_JIAJIKA_IMPORT where user_id='"+'<%=user.getId()%>'+"' and date(import_time)='"+_currentDate+"'");
				sql += "&sqls=" + encodeURIComponent("delete from COLLEGE_JIAJIKA_IMPORT_TEMP  where taskid='" + taskId + "'"); 
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
				$("delTodayBtn").onclick = _deleteToday;
			}
		
		}(window,document);
		
	</script>
</body>
</html>