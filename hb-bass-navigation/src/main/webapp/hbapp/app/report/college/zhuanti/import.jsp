<%@ page language="java" import="java.util.*,com.asiainfo.hb.web.models.User" pageEncoding="utf-8"%>
<%User user = (User)session.getAttribute("user");%>
<HTML>                                                                                                                                                                                                                                                                                                                   
<HEAD>
<TITLE>湖北移动经营分析系统-”高校开学营销季“外部数据导入</TITLE>
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.css" />
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
<!--
	2010.08.12 : copied from jiajikaImport.html
	2010.08.16 : taskId此时应该和具体选择的数据绑定，而不再和当前日期绑定，也就是说，我今天和明天选同一个数据周期导入的话，taskId应该是同一个
-->
<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
</head>
<body bgcolor="#EFF5FB" margin=0>
<!-- 
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend style="cursor : pointer" onclick="javascript: var status = this.nextSibling.style.display; status =='none' ? this.nextSibling.style.display = '' : this.nextSibling.style.display='none'">
	MM发展情况导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0" >
      <tr style="padding:5px;"> 
        <td width="450"><div id="mmUploadDiv"></div></td>
		
        <td valign="top">
		<div>
		<b>数据周期(天)</b>选择：<input align="right" type="text" id="mmDate" name="mmDate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate" width="10px"/>
		</div>
		<a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=college/zhuanti&fileName=MM发展情况导入模板.xls"><font color=blue><b>导入数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font> 
        	
			<div>导入说明：</div>
	<div>
		<ul>
			<li>导入前选择具体的数据周期(天)</li>
			<li>对于同一数据周期内的多次导入，系统会自动更新上一次数据</li>
		</ul>
	</div>
        	</td>
      </tr>
   </table>
</fieldset>



<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend style="cursor : pointer" onclick="javascript: var status = this.nextSibling.style.display; status =='none' ? this.nextSibling.style.display = '' : this.nextSibling.style.display='none'">
	新同学老相识跟踪导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
        <td width="450"><div id="xtxUploadDiv"></div></td>
		
        <td valign="top">
		<div>
		<b>数据周期(周)</b>选择：<input align="right" type="text" id="xtxDate" name="xtxDate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd 第WW周',isShowWeek:true})" class="Wdate" width="10px"/>
		</div>
		<a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=college/zhuanti&fileName=新同学老相识活动跟踪导入模板.xls"><font color=blue><b>导入数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
			<div>导入说明：</div>
	<div>
		<ul>
			<li>导入前选择具体的数据周期(周)</li>
			<li>对于同一数据周期内的多次导入，系统会自动更新上一次数据</li>
		</ul>
	</div>
        	</td>
      </tr>
   </table>
</fieldset>

 -->

	
	
<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend style="cursor : pointer" onclick="javascript: var status = this.nextSibling.style.display; status =='none' ? this.nextSibling.style.display = '' : this.nextSibling.style.display='none'">
	高校营销之开学季--》前置营销--》直送卡综合信息导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0" >
      <tr style="padding:5px;"> 
        <td width="450"><div id="jjkUploadDiv"></div></td>
		
        <td valign="top">
        <%if(user.getCityId().equals("0")){
        %>
        <a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=import&fileName=直送卡综合信息导入(市场部).xls"><font color=blue><b>导入数据模板(Excel)</b></font></a>	
        <%}else{ %>
        <a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=import&fileName=直送卡综合信息导入(地市).xls"><font color=blue><b>导入数据模板(Excel)</b></font></a>
        <%}%>
		
		
		&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font> 
        	
			<div>导入说明：</div>
	<div>
		<ul>
			<li>每日0~9点允许导入</li>
			<li>对于同一天内的多次导入，系统会自动更新上一次数据</li>
		</ul>
	</div>
        	</td>
      </tr>
   </table>
<form method="post" action="">
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td><img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table>
	</legend>
	<div id="jjkUploadDiv_grid" style="display:none;"></div>
</fieldset>
</div><br>
</form>   
</fieldset>

<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
 <legend style="cursor : pointer" onclick="javascript: var status = this.nextSibling.style.display; status =='none' ? this.nextSibling.style.display = '' : this.nextSibling.style.display='none'">
	高校营销之开学季--》前置营销--》wlan进度
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
        <td width="450"><div id="wlanUploadDiv"></div></td>
		
        <td valign="top">
		<div>
		<b>数据周期</b>选择：<input align="right" type="text" id="wlanDate" name="wlanDate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd 第WW周',isShowWeek:true})" class="Wdate" width="10px"/>
		</div>
		<a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=college/zhuanti&fileName=WLAN外部数据模板.xls"><font color=blue><b>导入数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
			<div>导入说明：</div>
	<div>
		<ul>
			<li>每周五中午12点~周六中午12点允许导入</li>
			<li>对于同一数据周期内的多次导入，系统会自动更新上一次数据</li>
		</ul>
	</div>
        	</td>
      </tr>
   </table>
   <form method="post" action="">
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td><img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table>
	</legend>
	<div id="wlanUploadDiv_grid" style="display:none;"></div>
</fieldset>
</div><br>
</form> 
</fieldset>

<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
<legend style="cursor : pointer" onclick="javascript: var status = this.nextSibling.style.display; status =='none' ? this.nextSibling.style.display = '' : this.nextSibling.style.display='none'">
	高校营销之开学季--》前置营销--》进场准备进度
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
        <td width="450"><div id="jczbUploadDiv"></div></td>
		
        <td valign="top">
		<div>
		<b>数据周期</b>选择：<input align="right" type="text" id="jczbDate" name="jczbDate" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyy-MM-dd 第WW周',isShowWeek:true})" class="Wdate" width="10px"/>
		</div>
		<a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=college/zhuanti&fileName=进场准备进度外部数据模板.xls"><font color=blue><b>导入数据模板(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
        	
			<div>导入说明：</div>
	<div>
		<ul>
			<li>每周五中午12点~周六中午12点允许导入</li>
			<li>对于同一数据周期内的多次导入，系统会自动更新上一次数据</li>
		</ul>
	</div>
        	</td>
      </tr>
   </table>
   <form method="post" action="">
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td><img src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table>
	</legend>
	<div id="jczbUploadDiv_grid" style="display:none;"></div>
</fieldset>
</div><br>
</form>   
</fieldset>

<fieldset width="96%" align="center" style="margin: 10px 0px 0px 10px;">
<legend style="cursor : pointer" onclick="javascript: var status = this.nextSibling.style.display; status =='none' ? this.nextSibling.style.display = '' : this.nextSibling.style.display='none'">
	高校营销之开学季--》前置营销--》直送卡、进场协议、WLAN工作情况导入
</legend>
   <table border=0 cellpadding="0" cellspacing="0">
      <tr style="padding:5px;"> 
        <td width="450"><div id="zskxgUploadDiv"></div></td>
		
        <td valign="top">
		<a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=import&fileName=直送卡、进场协议、WLAN工作情况导入数据模板.xls"><font color=blue><b>导入数据模板(Excel)</b></font></a>&nbsp;&nbsp;<a style="text-decoration: underline;" href="${mvcPath}/hbirs/action/filemanage?method=downFromFtp&remotePath=import&fileName=高校列表.xls"><font color=blue><b>高校列表(Excel)</b></font></a>&nbsp;<font color="red">请单击或右键点击“目标另存为”下载</font>
        	
			<div>导入说明：</div>
	<div>
		<ul>
			<li>每日0~9点钟导入</li>
			<li>对于同一天内的多次导入，系统会自动更新上一次数据</li>
			<li>导入完成后请查看未导入成功记录，如果存在导入失败的数据，需要进行修正后重新导入</li>
		</ul>
	</div>
        	</td>
      </tr>
   </table>
<form method="post" action="">
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
</fieldset>

	<script language="JavaScript" type="text/javascript" src="${mvcPath}/hbapp/resources/js/codebase/dhtmlxvault.js"></script>
	<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js" charset=utf-8></script>
	<script type="text/javascript">
	var timeId = new Date().format("yyyymmdd");
	var tempDate = new Date();
	tempDate.setMonth(tempDate.getMonth() - 1);//上个月的
	tempDate.setDate(tempDate.getDate() - 2); //推迟两天
	var _date = tempDate.format("yyyymm");
	var taskId = timeId + "@" + '<%=user.getId()%>';
	var cityId = '<%=user.getCityId()%>';
	function getThisWeekLastDay(_date){
		/* wanted : a week start from monday to sunday in China, and the getDay() return 0 if it is monday ,return 6 if it is sunday 
		*/
		// way 1 : var DayOfWeekChina = _date.getDay() == 0 ? 7 : _date.getDay();
		var lastDayOfWeekChina = 7;
		var dayOfWeekChina = _date.getDay() || 7; // way 1 simpler
		_date.setDate(_date.getDate() + (lastDayOfWeekChina - dayOfWeekChina)); 
		return _date;
	}
		+function(window,document,undefined){
			
			var _params = aihb.Util.paramsObj();
			_params.loginname='<%=user.getId()%>';
			function crtVault(divId) {
				var vault = new dhtmlXVaultObject();
			    vault.setImagePath("${mvcPath}/hbapp/resources/js/codebase/imgs/");
			    vault.setServerHandlers("${mvcPath}/hbirs/action/filemanage?method=importExcel", "${mvcPath}/hbirs/action/filemanage?method=getInfoHandler", "${mvcPath}/hbirs/action/filemanage?method=getIdHandler");
			    vault.setFilesLimit(1);
			   	vault.create(divId);
	   	    	
				vault.onAddFile = function(fileName) {
					var ext = this.getFileExtension(fileName);
					if (ext != "xls") {
						alert("本应用只支持扩展名.xls,请重新上传.");
						return false;
					} else return true;
				};
				return vault;
			}
			
			
			
			function showPanels() {
				!function(){
					var jjkVault = crtVault("jjkUploadDiv");
					jjkVault.onFileUpload=function(){
						/**
						if(!(timeId = $("jjkDate").value)) {
							alert("请先选择一个数据周期。");
							$("jjkDate").focus();
							return false;
						} else {
							taskId = timeId +  "@" + _params.loginname;
							jjkVault.setFormField("date", taskId);  
							loadmask.style.display="";
							return true;
						}
						*/
						return true;
					}
					//每天0-9点允许导入
					jjkVault.enableAddButton(function(time){
						if(time.getHours()>=0 && time.getHours() <= 9)
							return true;
						else {
							return false;
						}
					}(new Date()));
					jjkVault.setFormField("tableName", "jjk_import_load");
					//校验：市场部校验地市 应导入量是否为整数
					if(cityId==0){
						jjkVault.setFormField("columns", "taskid,area_id,target");
						jjkVault.setFormField("date",taskId);
						jjkVault.onUploadComplete = function(files) {
							var sql = encodeURIComponent("update jjk_import_load set time_id='" + timeId + "',message='成功' where taskid='" + taskId + "' ");
							//删除之前导的
							sql+="&sqls="+encodeURIComponent("delete from jjk_import_temp  where taskid='" + taskId + "' ");
							sql+="&sqls="+encodeURIComponent("update jjk_import_load set message='地市有误' where area_id not in (select areaname from FPF_USER_USER)");
							sql+="&sqls="+encodeURIComponent("insert into jjk_import_temp(taskid,time_id,area_id,target) select taskid,time_id,area_id,target from jjk_import_load where message ='成功' and taskid='" + taskId + "'");
							//sql+="&sqls="+encodeURIComponent("update jjk_import_load set message='" + timeId + "',message='成功' where taskid='" + taskId + "' ");
							var ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/sqlExec"
							,parameters : "sqls="+sql
							,loadmask : false
							,callback : function(xmlrequest){
								alert("导入完成,请查看导入结果");
								jjkUploadDiv_query0();
								loadmask.style.display = "none";
							}
						});
							ajax.request();
						}
					}else{
						jjkVault.setFormField("columns", "taskid,area_id,wh_cnt,sucs_wh_cnt,missing_cnt,sms_care_cnt,mail139_care_cnt,cu_cnt,ct_cnt");
						jjkVault.setFormField("date",taskId);
						jjkVault.onUploadComplete = function(files) {
							var sql = encodeURIComponent("update jjk_import_load set time_id='" + timeId + "',message='成功' where taskid='" + taskId + "' ");
							//删除之前导的
							sql+="&sqls="+encodeURIComponent("delete from jjk_import_temp  where taskid='" + taskId + "' ");
							
							sql+="&sqls="+encodeURIComponent("update jjk_import_load set message='地市有误' where area_id not in (select areaname from FPF_USER_USER)");
							sql+="&sqls="+encodeURIComponent("insert into jjk_import_temp(taskid,time_id,area_id,wh_cnt,sucs_wh_cnt,missing_cnt,sms_care_cnt,mail139_care_cnt,cu_cnt,ct_cnt) select taskid,time_id,area_id,wh_cnt,sucs_wh_cnt,missing_cnt,sms_care_cnt,mail139_care_cnt,cu_cnt,ct_cnt from jjk_import_load where message='成功' and taskid='" + taskId + "'");
							
							var ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/sqlExec"
							,parameters : "sqls="+sql
							,loadmask : false
							,callback : function(xmlrequest){
								alert("导入完成,请查看导入结果");
								jjkUploadDiv_query();
								loadmask.style.display = "none";
							}
						});
							ajax.request();
						}
					}
					
				}();
				
				/**
				!function(){
					var mmVault = crtVault("mmUploadDiv"),
					timeId,
					taskId;
					mmVault.onFileUpload=function(){
						if(!(timeId = $("mmDate").value)) {
							alert("请先选择一个数据周期。");
							$("mmDate").focus();
							return false;
						} else {
							taskId = timeId +  "@" + _params.loginname;
							mmVault.setFormField("date", taskId);  
							loadmask.style.display="";
							return true;
						}
						
					}
					mmVault.setFormField("tableName", "cust_college_import");
					
					mmVault.setFormField("columns", "task_id,dim1,ind1,ind2");
				
					mmVault.onUploadComplete = function(files) {
						// 第一步删除上一次记录已被java端在插入前做了 	
						var sql= encodeURIComponent("delete from report_total where report_code='College_MM_Dev' and time_id=" + timeId);
						sql += "&sqls=" + encodeURIComponent("insert into report_total(report_code,time_id,dim1,ind1,ind2) select 'College_MM_Dev',"+timeId+",dim1,ind1,ind2 from cust_college_import where task_id='" + taskId + "'");
						sql += "&sqls=" + encodeURIComponent("delete from cust_college_import where task_id='" + taskId + "' ");
						var ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/sqlExec"
						,parameters : "sqls="+sql
						,loadmask : false
						,callback : function(xmlrequest){
							alert("导入完成!");
							loadmask.style.display = "none";
						}
					});
						ajax.request();
					}
				}();
				
				
				!function(){
					var xtxVault = crtVault("xtxUploadDiv"),
					timeId,
					taskId;
					xtxVault.onFileUpload=function(){
						if(!$("xtxDate").value){
							alert("请先选择一个数据周期。");
							$("xtxDate").focus();
							return false;
						} else {
							timeId = $("xtxDate").value.substr(0,10);
							timeId = getThisWeekLastDay(new Date(timeId.replace(/-/g,"/"))); //得到本周的最后一天
							timeId = timeId.format("yyyymmdd"); //得到字符串格式
							taskId = timeId +  "@" + _params.loginname;
							xtxVault.setFormField("date", taskId);  
							loadmask.style.display="";
							return true;
						}
						
					}
					xtxVault.setFormField("tableName", "cust_college_import");
					
					xtxVault.setFormField("columns", "task_id,dim1,ind1,ind2,ind3,ind4,ind5,ind6,ind7,ind8,ind9");
				
					xtxVault.onUploadComplete = function(files) {
						//* 第一步删除上一次记录已被java端在插入前做了 	
						var sql= encodeURIComponent("delete from report_total where report_code='College_XTX' and time_id=" + timeId);
						sql += "&sqls=" + encodeURIComponent("insert into report_total(report_code,time_id,dim1,ind1,ind2,ind3,ind4,ind5,ind6,ind7,ind8,ind9) select 'College_XTX',"+timeId+",dim1,ind1,ind2,ind3,ind4,ind5,ind6,ind7,ind8,ind9 from cust_college_import where task_id='" + taskId + "'");
						sql += "&sqls=" + encodeURIComponent("delete from cust_college_import where task_id='" + taskId + "' ");
						var ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/sqlExec"
						,parameters : "sqls="+sql
						,loadmask : false
						,callback : function(xmlrequest){
							alert("导入完成!");
							loadmask.style.display = "none";
						}
					});
						ajax.request();
					}
				}();
				*/
				
				!function(){
					var wlanVault = crtVault("wlanUploadDiv"),
					_timeId,
					_taskId;
					wlanVault.onFileUpload=function(){
						if(!$("wlanDate").value){
							alert("请先选择一个数据周期。");
							$("wlanDate").focus();
							return false;
						} else {
							_timeId = $("wlanDate").value.substr(0,10);
							_timeId = getThisWeekLastDay(new Date(_timeId.replace(/-/g,"/"))); //得到本周的最后一天
							_timeId = _timeId.format("yyyymmdd"); //得到字符串格式
							_taskId = _timeId +  "@" + _params.loginname;
							wlanVault.setFormField("date", _taskId);  
							loadmask.style.display="";
							return true;
						}
						
					}
					//允许导入
					wlanVault.enableAddButton(function(time){
						//return true;
						//alert(time.getDay())
						if((time.getDay())==5 && time.getHours() > 12)
							return true;
						if((time.getDay())==6 && time.getHours() < 12)
							return true;
						
							return false;
						
					}(new Date()));
					wlanVault.setFormField("tableName", "wlan_import_load");
					wlanVault.setFormField("columns", "taskid,area_id,pre_crtwk_cnt,pre_lstwk_cnt,doing_crtwk_cnt,doing_lstwk_cnt,done_crtwk_cnt,done_lstwk_cnt,wfdc_crtwk_cnt,wfdc_lstwk_cnt,plan_cnt,sum_lstwk_cnt,sum_crtwk_cnt");
				
					wlanVault.onUploadComplete = function(files) {
						/* 第一步删除上一次记录已被java端在插入前做了 */	
						var sql= encodeURIComponent("delete from wlan_import_load where taskid='" + _taskId + "' and area_id = '地市' or area_id like '%示例%'");//删除表头
						sql += "&sqls=" +encodeURIComponent("delete from wlan_import_temp where taskid='" + _taskId + "'");
						/* update temp表 中的time_id */
						sql += "&sqls=" + encodeURIComponent("update wlan_import_load set time_id='" + _timeId + "',message='成功',import_time=current timestamp where taskid='" + _taskId + "' ");
						sql += "&sqls=" + encodeURIComponent("update wlan_import_load set message='地市有误' where taskid='" + _taskId + "' and area_id not in(select areaname from FPF_USER_USER)");
						sql += "&sqls=" + encodeURIComponent("insert into wlan_import_temp select taskid,time_id,area_id,pre_crtwk_cnt,pre_lstwk_cnt,doing_crtwk_cnt,doing_lstwk_cnt,done_crtwk_cnt,done_lstwk_cnt,wfdc_crtwk_cnt,wfdc_lstwk_cnt,plan_cnt,sum_lstwk_cnt,sum_crtwk_cnt,import_time from wlan_import_load where taskid='" + _taskId + "' and message='成功'");
						//保留导入日志
						//sql += "&sqls=" + encodeURIComponent("update wlan_import_load set message='历史' where message='成功' and taskid='" + _taskId + "' ");
						
						var ajax = new aihb.Ajax({
						url : "${mvcPath}/hbirs/action/sqlExec"
						,parameters : "sqls="+sql
						,loadmask : false
						,callback : function(xmlrequest){
							alert("导入完成,请查看导入结果");
							wlanUploadDiv_query(_taskId);
							loadmask.style.display = "none";
						}
					});
						ajax.request();
					}
				}();
				
				!function(){
					var jczbVault = crtVault("jczbUploadDiv"),
					_timeId,
					_taskId;
					jczbVault.onFileUpload=function(){
						if(!$("jczbDate").value){
							alert("请先选择一个数据周期。");
							$("jczbDate").focus();
							return false;
						} else {
							_timeId = $("jczbDate").value.substr(0,10);
							_timeId = getThisWeekLastDay(new Date(_timeId.replace(/-/g,"/"))); //得到本周的最后一天
							_timeId = _timeId.format("yyyymmdd"); //得到字符串格式
							_taskId = _timeId +  "@" + _params.loginname;
							jczbVault.setFormField("date", _taskId);  
							loadmask.style.display="";
							return true;
						}
						
					}
					//允许导入
					jczbVault.enableAddButton(function(time){
						//return true;
						//alert(time.getDay())
						if((time.getDay())==5 && time.getHours() > 12)
							return true;
						if((time.getDay())==6 && time.getHours() < 12)
							return true;
						
							return false;
						
					}(new Date()));
					jczbVault.setFormField("tableName", "jczb_import_load");
					jczbVault.setFormField("columns", "taskid,area_id,signed_crtwk,signed_lstwk,doing_crtwk,doing_lstwk,fail_crtwk,fail_lstwk,fail_cu,fail_ct,fail_cuct,fail_all");
				
					jczbVault.onUploadComplete = function(files) {
						/* 第一步删除上一次记录已被java端在插入前做了,还好是做了删除不然不知道怎么搞了 */	
						var sql= encodeURIComponent("delete from jczb_import_load where taskid='" + _taskId + "' and area_id = '地市' or area_id like '%示例%'");//删除表头
						sql+= "&sqls=" + encodeURIComponent("delete from jczb_import_temp where taskid='" + _taskId + "'");
						//sql+= "&sqls=" + encodeURIComponent("delete from jczb_import_load where taskid='" + _taskId + "'");
						/* update temp表 中的time_id */
						sql += "&sqls=" + encodeURIComponent("update jczb_import_load set time_id='" + _timeId + "',message='成功',import_time=current timestamp where taskid='" + _taskId + "' ");
						sql += "&sqls=" + encodeURIComponent("update jczb_import_load set message='地市有误' where taskid='" + _taskId + "' and area_id not in(select areaname from FPF_USER_USER) ");
						sql += "&sqls=" + encodeURIComponent("insert into  jczb_import_temp select taskid,time_id,area_id,signed_crtwk,signed_lstwk,doing_crtwk,doing_lstwk,fail_crtwk,fail_lstwk,fail_cu,fail_ct,fail_cuct,fail_all,import_time from jczb_import_load where taskid='" + _taskId + "' ");
						//sql += "&sqls=" + encodeURIComponent("delete from   jczb_import_load where taskid='" + _taskId + "'");
						
						var ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/sqlExec"
							,parameters : "sqls="+sql
							,loadmask : false
							,callback : function(xmlrequest){
								alert("导入完成,请查看导入结果");
								jczbUploadDiv_query(_taskId);
								loadmask.style.display = "none";
							}
						});
						ajax.request();
					}
				}();
				
				!function(){
					var jczbVault = crtVault("zskxgUploadDiv");
					jczbVault.onFileUpload=function(){
						return true;
					}
					//每天0-9点允许导入
					jczbVault.enableAddButton(function(time){
						//return true;
						if(time.getHours()>=0 && time.getHours() <= 9)
							return true;
						else {
							return false;
						}
					}(new Date()));
					jczbVault.setFormField("tableName", "College_Important_Job_load");
					jczbVault.setFormField("columns", "taskid,area_name,college_name,jjk_Cnt,jjk_Send_Cnt,wss_cnt,Agreement_MB,Agreement_UN,Agreement_FIX,WLAN_built,WLAN_Building,WLAN_Negotiation");
					jczbVault.setFormField("date", taskId);  
					//高校的表：select college_name from nwh.college_info where state=1
					jczbVault.onUploadComplete = function(files) {
						/* 第一步删除上一次记录已被java端在插入前做了 */	
						//删除正式表
						var sql =encodeURIComponent("delete from College_Important_Job where taskid='" + taskId + "' ");
						//更新ETL_CYCLE_ID
						sql+= "&sqls=" + encodeURIComponent("update College_Important_Job_load set ETL_CYCLE_ID=" + timeId + ",message='成功' where taskid='" + taskId + "' ");
						//标记不存在的高校名称
						sql += "&sqls=" + encodeURIComponent("update College_Important_Job_load set message='高校编码不存在' where taskid='" + taskId + "' and college_name not in (select distinct college_id from nwh.college_info)");
						//地市输入是否正确(襄阳会有问题)
						sql += "&sqls=" + encodeURIComponent("update College_Important_Job_load set message='地市填写错误' where taskid='" + taskId + "' and area_name not in(select areaname from FPF_USER_USER)");
						//判断 我方情况（是/否）	联通情况（是/否）	电信情况（是/否）
						sql += "&sqls=" + encodeURIComponent("update College_Important_Job_load set message='进场协议签订情况错误' where taskid='" + taskId + "' and (agreement_mb not in('是','否') or agreement_un not in('是','否') or agreement_fix not in('是','否'))");
						//插入正确记录
						sql += "&sqls=" + encodeURIComponent("insert into College_Important_Job select taskid,ETL_CYCLE_ID,area_name,college_name,jjk_Cnt,jjk_Send_Cnt,wss_cnt,Agreement_MB,Agreement_UN,Agreement_FIX,WLAN_built,WLAN_Building,WLAN_Negotiation from College_Important_Job_load where message='成功' and taskid='" + taskId + "' ");
						//删除临时表正确记录
						//sql += "&sqls=" + encodeURIComponent("delete from College_Important_Job_load where message and taskid='" + taskId + "' ");
						var ajax = new aihb.Ajax({
							url : "${mvcPath}/hbirs/action/sqlExec"
							,parameters : "sqls="+sql
							,loadmask : false
							,callback : function(xmlrequest){
								alert("导入完成,请查看导入结果");
								zskxgUploadDiv_query();
								loadmask.style.display = "none";
							}
						});
						ajax.request();
					}
				}();
			};
			var jjkUploadDiv_header= [
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"area_id",
								"name":["地市"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"wh_cnt",
								"name":["已外呼总量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"sucs_wh_cnt",
								"name":["其中呼通总量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"missing_cnt",
								"name":["外呼号码中发现收到通知书但未收到直送号码数量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"sms_care_cnt",
								"name":["通过短信关怀总量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"mail139_care_cnt",
								"name":["通过139邮件关怀总量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"cu_cnt",
								"name":["联通已直送量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"ct_cnt",
								"name":["电信已直送量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"message",
								"name":["导入结果"],
								"title":"",
								"cellFunc":""
							}
						];
			var jjkUploadDiv_header0= [
										{
											"cellStyle":"grid_row_cell_text",
											"dataIndex":"area_id",
											"name":["地市"],
											"title":"",
											"cellFunc":""
										},
										{
											"cellStyle":"grid_row_cell_text",
											"dataIndex":"target",
											"name":["应导入量"],
											"title":"",
											"cellFunc":""
										},
										{
											"cellStyle":"grid_row_cell_text",
											"dataIndex":"message",
											"name":["导入结果"],
											"title":"",
											"cellFunc":""
										}
									];
			function jjkUploadDiv_query0(){				
				var _sql = "select area_id,target,message from jjk_import_load where taskid='" + taskId + "' with ur" ;
				var grid = new aihb.AjaxGrid({
					header:jjkUploadDiv_header0
					,isCached : false
					,sql: _sql
					,el:"jjkUploadDiv_grid"
				});
				grid.run();
			}
			function jjkUploadDiv_query(){				
				var _sql = "select area_id,wh_cnt,sucs_wh_cnt,missing_cnt,sms_care_cnt,mail139_care_cnt,cu_cnt,ct_cnt,message from  jjk_import_load where taskid='"+taskId+"'" ;
				var grid = new aihb.AjaxGrid({
					header:jjkUploadDiv_header
					,isCached : false
					,sql: _sql
					,el:"jjkUploadDiv_grid"
				});
				grid.run();
			}
			var wlanUploadDiv_header=[{"name":["时间","#rspan"],"dataIndex":"time_id","cellFunc":"","cellStyle":"","title":""}
			,{"name":["地市","#rspan"],"dataIndex":"area_id","cellFunc":"","cellStyle":"","title":""}
			,{"name":["洽谈中","本周到达数"],"dataIndex":"pre_crtwk_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","上周到达数"],"dataIndex":"pre_lstwk_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["施工中","本周到达数"],"dataIndex":"doing_crtwk_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","上周到达数"],"dataIndex":"doing_lstwk_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["已完工","本周到达数"],"dataIndex":"done_crtwk_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","上周到达数"],"dataIndex":"done_lstwk_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["无法入场","本周到达数"],"dataIndex":"wfdc_crtwk_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","上周到达数"],"dataIndex":"wfdc_lstwk_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["后期WLAN覆盖规划","#rspan"],"dataIndex":"plan_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["上周合计","#rspan"],"dataIndex":"sum_lstwk_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["本周合计","#rspan"],"dataIndex":"sum_crtwk_cnt","cellFunc":"","cellStyle":"","title":""}
			,{"name":["导入结果","#rspan"],"dataIndex":"message","cellFunc":"","cellStyle":"","title":""}]
			function wlanUploadDiv_query(_taskId){
				var _sql = "select area_id,pre_crtwk_cnt,pre_lstwk_cnt,doing_crtwk_cnt,doing_lstwk_cnt,done_crtwk_cnt,done_lstwk_cnt,wfdc_crtwk_cnt,wfdc_lstwk_cnt,plan_cnt,sum_lstwk_cnt,sum_crtwk_cnt,message from wlan_import_load where taskid='" + _taskId + "' with ur" ;
				var grid = new aihb.AjaxGrid({
					header:wlanUploadDiv_header
					,isCached : false
					,sql: _sql
					,el:"wlanUploadDiv_grid"
				});
				grid.run();
			}
			var jczbUploadDiv_header=[{"name":["地市","#rspan"],"dataIndex":"area_id","cellFunc":"","cellStyle":"","title":""}
			,{"name":["已签署","本周到达数"],"dataIndex":"signed_crtwk","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","上周到达数"],"dataIndex":"signed_lstwk","cellFunc":"","cellStyle":"","title":""}
			,{"name":["洽谈中","本周到达数"],"dataIndex":"doing_crtwk","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","上周到达数"],"dataIndex":"doing_lstwk","cellFunc":"","cellStyle":"","title":""}
			,{"name":["不能签署","本周到达数"],"dataIndex":"fail_crtwk","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","上周到达数"],"dataIndex":"fail_lstwk","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","其中联通独家"],"dataIndex":"fail_cu","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","其中电信独家"],"dataIndex":"fail_ct","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","联通电信同时"],"dataIndex":"fail_cuct","cellFunc":"","cellStyle":"","title":""}
			,{"name":["#cspan","三家都不能进入"],"dataIndex":"fail_all","cellFunc":"","cellStyle":"","title":""}
			,{"name":["导入结果","#rspan"],"dataIndex":"message","cellFunc":"","cellStyle":"","title":""}]
			function jczbUploadDiv_query(_taskId){
				var _sql = "select taskid,time_id, area_id,signed_crtwk,signed_lstwk,doing_crtwk,doing_lstwk,fail_crtwk,fail_lstwk,fail_cu,fail_ct,fail_cuct,fail_all,import_time,message from jczb_import_load where taskid='" + _taskId + "' with ur" ;
				var grid = new aihb.AjaxGrid({
					header:jczbUploadDiv_header
					,isCached : false
					,sql: _sql
					,el:"jczbUploadDiv_grid"
				});
				grid.run();
			}
											
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
								"dataIndex":"college_name",
								"name":["高校名称"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"jjk_cnt",
								"name":["计划寄送量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"jjk_send_cnt",
								"name":["已寄送量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"wss_cnt",
								"name":["网厅活动受理量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"agreement_mb",
								"name":["我方情况（是/否"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"agreement_un",
								"name":["联通情况（是/否）"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"agreement_fix",
								"name":["电信情况（是/否）"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"wss_cnt",
								"name":["网厅活动受理量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"wlan_built",
								"name":["已建成数量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"wlan_building",
								"name":["在建数量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"wlan_negotiation",
								"name":["正在谈判数量"],
								"title":"",
								"cellFunc":""
							},
							{
								"cellStyle":"grid_row_cell_text",
								"dataIndex":"message",
								"name":["导入结果"],
								"title":"",
								"cellFunc":""
							}
						];
			function zskxgUploadDiv_query(){
				var _sql = "select area_name,college_name,jjk_Cnt,jjk_Send_Cnt,wss_cnt,Agreement_MB,Agreement_UN,Agreement_FIX,WLAN_built,WLAN_Building,WLAN_Negotiation,message from College_Important_Job_load where taskid='"+taskId+"' with ur" ;
				var grid = new aihb.AjaxGrid({
					header:_header
					,isCached : false
					,sql: _sql
				});
				grid.run();
			}
			window.onload=function(){
				aihb.Util.loadmask();
				showPanels();
				var timeId = new Date().format("yyyy/mm/dd");
				timeId = getThisWeekLastDay(new Date(timeId));
				$("wlanDate").value=timeId.format("yyyy-mm-dd");
				$("wlanDate").disabled=true;
				
				$("jczbDate").value=timeId.format("yyyy-mm-dd");
				$("jczbDate").disabled=true;
			}
		
		}(window,document);
		
	</script>
</body>
</html>