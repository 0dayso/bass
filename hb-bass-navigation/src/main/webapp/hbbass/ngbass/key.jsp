<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  copied from preorder.jsp
   OWN_ORG_ID，截取当做地市和县市的判断条件
  --%>
    <title>VIP及关键人员类预警</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<style type="text/css">
 		#massage_box{ position:absolute;  left:expression((body.clientWidth-550)/2); top:expression((body.clientHeight-300)/2); width:350px; height:50px;filter:dropshadow(color=#B0D7EC,offx=2,offy=2,positive=2); z-index:2; visibility:hidden;filter:alpha(opacity=80)}
 		#mask{ position:absolute; top:0; left:0; width:expression(body.clientWidth); height:expression(body.clientHeight); background:#ccc; filter:ALPHA(opacity=30); z-index:1; visibility:hidden}
 		.massage{border:#D9ECF6 solid; border-width:1 1 2 1; width:95%; height:95%; background:#fff; color:#036; font-size:12px; line-height:150%}
		.header{background:#A8D2EA; height:12%; font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px; padding:3 5 0 5; color:#000}
 	</style>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  	<script type="text/javascript" src="../js/datepicker/WdatePicker.js"></script>
  	
  </head>   
 
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> <script type="text/javascript">
 	<%
 		//每个客户经理只能查看他管辖范围内的记录，为此，应该在session中得到loginname
 		String loginname = (String)session.getAttribute("loginname");
 	%>
 	cellclass[0]="grid_row_cell_text";
	cellclass[1]="grid_row_cell_text";
	cellclass[2]="grid_row_cell_text";
	cellclass[3]="grid_row_cell_text";
	cellclass[4]="grid_row_cell_text";
	cellclass[5]="grid_row_cell_text";
	cellclass[6]="grid_row_cell_text";
	function doSubmit()
	{	
		var condition = " where 1=1 ";
		var op_time;
		var area_id;
		var county_id;
		var tableName;
		var alertType;
		var remainType;
		var sql;
		var loginName = '<%= loginname%>';
		/*先做屏蔽处理 091120
		if(loginName)
			condition += " and staff_id in (select distinct staff_id from user_config where user_id = '" + loginName + "')";
		*/
		with(document.forms[0]){
			area_id = city.value;
			county_id = county.value;
			op_time = date.value;
			tableName = "Nmk.AI_ENT_VIP_KEY_Alert_" + op_time;
		}
	    condition += (county_id == '' ? (area_id == '0' ? "" : " and substr(OWN_ORG_ID,1,5) = '" + area_id + "'") : " and substr(OWN_ORG_ID,1,8) = '" + county_id + "'");
		var alertTypes = document.getElementsByName("alerttype");
		for(var i = 0; i < alertTypes.length; i++) {
			if(alertTypes[i].checked) {
				condition += alertTypes[i].value == "complain" ? " and complaintimes > 10" : "";
				condition += alertTypes[i].value == "stop" ? " and stopdays > 0" : "";
				condition += alertTypes[i].value == "nocall" ? " and nocalldays > 7" : "";
			} else continue;
		}
			
		//condition += " and complaintimes > " + complainTimes;
		//condition += " and stopdays > " + stopDays;
		//condition += " and nocalldays > " + noCallDays;
		//alert("condition : " + condition);
		sql = " select  ACC_NBR, CUST_NAME, CHANNEL_CODE, GROUPNAME, STAFF_NAME, COMPLAINTIMES,STOPDAYS, NOCALLDAYS"
		+ " from " + tableName + condition;
		var countSql ="select count(*) from " + tableName + condition;
		//alert("sql : " + sql);
		//alert("countSql : " + countSql);
		document.forms[0].sql.value = sql;
	 	ajaxSubmitWrapper(sql+" fetch first 1000 rows only with ur",countSql);
	}

//ng版级联函数，主要是sql不同，也就是表名不同
function areacombo(i,sync)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();
	if(document.forms[0].county != undefined)
	{
		selects.push(document.forms[0].county);
		//#和配置工具无关以及配置工具中的变量无关
		//sql使用的是波涛工具中的，所以表名也是如此，这里的表明并非dongyong给我的维表mk.dim_areacity/county
	  sqls.push("select AREA_ID, AREA_NAME  from MK.STAT_AREA where PARENT_ID='#{value}'   order by AREA_ID");
	}
	//调用联动方法
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}

	function catchEvent(eventObj, event, eventHandler) {
		if (eventObj.addEventListener) {
			eventObj.addEventListener(event, eventHandler,false);
		}
		 else if (eventObj.attachEvent) {
			event = "on" + event;
			eventObj.attachEvent(event, eventHandler);
		}
	}
	
	function setupEvents() {
		var checkBoxes1 = document.getElementsByName("alerttype");
		var checkBoxes2 = document.getElementsByName("remaintype");//信息推送类型
		for(var i = 0; i < checkBoxes1.length; i++) {
			catchEvent(checkBoxes1[i],"change",checkSelect);
		} 
		/*取消对推送类型的检查
		for(var i = 0; i < checkBoxes2.length; i++) {
			catchEvent(checkBoxes2[i],"change",checkSelect);
		}
		*/
		
	}
	function checkSelect(evt) {
		var theEvent = evt ? evt : window.event;
		var theSrc = theEvent.target ? theEvent.target : theEvent.srcElement;
		if(theSrc.name == "alerttype") {
			var checkBoxes1 = document.getElementsByName("alerttype");
			var unselectAll = true;
			for(var i = 0; i < checkBoxes1.length; i++) {
				if(checkBoxes1[i].checked) unselectAll = false;
			} 
			if(unselectAll) {
				Ext.Msg.alert("注意!","您至少需要选择一种预警类型");
				theSrc.checked = true;
			}
		}
		/*
			取消对推送类型的判断
		 else if(theSrc.name == "remaintype") {
			var checkBoxes2 = document.getElementsByName("remaintype");
			var unselectAll = true;
			for(var i = 0; i < checkBoxes2.length; i++) {
				if(checkBoxes2[i].checked) unselectAll = false;
			} 
			if(unselectAll) {
				Ext.Msg.alert("注意!","您至少需要选择一种信息推送类型");
				//alert("您至少需要选择一种信息推送类型");
				theSrc.checked = true;
			}
		}
		*/
		
	}
	catchEvent(window,"load",setupEvents);
	Ext.onReady(function(){
		Ext.BLANK_IMAGE_URL = '../js//resources/images/default/s.gif';
	});
  </script>
  <body>
  <% 
 // log.info("test : " + NgbassTools.getQueryDate("testFormName","YYYYMM"));
  %> 
  <form action="" method="post">
	  <div id="hidden_div">
		<input type="hidden" id="allPageNum" name="allPageNum" value="">
		<input type="hidden" id="sql" name="sql" value="">
		<input type="hidden" name="filename" value="">
		<input type="hidden" name="order"  value="">
		<input type="hidden" name="title" value="">
	</div>
	
	<div class="divinnerfieldset">
		<fieldset>
			<legend>
				<table>
					<tr>
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏">
							<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;查询条件区域：
						</td>
					</tr>
				</table>
			</legend>
			
			<div id="dim_div">
				<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="dim_row">
						<td class="dim_cell_title">时间</td>
						<td class="dim_cell_content">
							<%=NgbassTools.getQueryDate("date","yyyyMM")%>
						</td>
						
						<td class="dim_cell_title">地市</td>
						<td class="dim_cell_content"> 
						<%-- 默认值是0,从波涛工具中看到 --%>
							<%=bass.common.QueryTools2.getAreaCodeHtml("city","0","areacombo(1)")%>
						</td>
						<td class="dim_cell_title">县市<!-- (ng) --></td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getCountyHtml("county","areacombo(2)")%>
						</td>
					</tr>
					
					<tr class="dim_row">
					<%-- 这里的预警类型不能少 --%> 
					<td class="dim_cell_title">预警类型(属性)</td>
					<td class="dim_cell_content" colspan="5">
						<input type="checkbox" id="complain" value="complain" name="alerttype" />客户投诉超过指定次数
						<input type="checkbox" id="stop" value="stop" name="alerttype" checked="checked" />客户为停机状态
						<input type="checkbox" id="nocall" value="nocall" name="alerttype"/>指定时间范围内连续0次通话
					</td>
					</tr>
						<tr class="dim_row">
					<%-- 不在这里添加 
					<td class="dim_cell_title">信息推送类型</td>
					<td class="dim_cell_content" colspan="5">
						<input type="checkbox" id="sms" name=remaintype checked="checked"/>短信
						<input type="checkbox" id="ms" name="remaintype"/>彩信
						<input type="checkbox" id="email" name="remaintype"/>电子邮件
					</td>
					--%>
					</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="信息推送类型" onclick="mask.style.visibility='visible';massage_box.style.visibility='visible'">&nbsp;
							<input type="button" class="form_button" value="查询" onclick="doSubmit()">&nbsp;
							<input type="button" class="form_button" value="下载" onclick="toDown(1)">&nbsp;
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	<br/>
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏">
								<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
								&nbsp;数据展现区域：
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="show_div">
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
			</fieldset>
		</div>
		<br>
	
		<div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 	<td width="" class="grid_title_cell">用户号码</td>
				 	<td width="" class="grid_title_cell">用户姓名</td>
				 	<td width="" class="grid_title_cell">用户入网渠道</td>
				 	<td width="" class="grid_title_cell">归属集团名称</td>
				 	<td width="" class="grid_title_cell">客户经理姓名</td>
				 	<td width="" class="grid_title_cell">投诉次数</td>
				 	<td width="" class="grid_title_cell">停机天数</td>
				 	<td width="" class="grid_title_cell">连续0通话天数</td>
				 </tr>
			</table>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>

<div id="massage_box">
	<div class="massage">
		 <div class="header" onmousedown=MDown(massage_box) style="cursor:move">
				<div style="display:inline; width:100px;position:absolute; ">信息推送类型</div>
			  <span onClick="massage_box.style.visibility='hidden'; mask.style.visibility='hidden'" style="float:right; display:inline; cursor:hand">×</span>
	   </div>
			<table width="96%" border="0" align="center" valign="middle">
	 		<tr>
	 			<td >
	 					<input type="checkbox" value="1" id="sms" name="remaintype" checked="checked"/>短信
						<input type="checkbox" value="2" id="ms" name="remaintype"/>彩信
						<input type="checkbox" value="4" id="email" name="remaintype"/>电子邮件
	 			</td>
	 			<td>
	 				<input  type="button" value="确定" onclick="setRemainType()"/>
	 			</td>
	 		</tr>
	 	</table>
	</div>
</div>
<div id="mask"></div>
<script type="text/javascript" charset="utf-8"> 
	var Obj=''
	document.onmouseup=MUp
	document.onmousemove=MMove
	function MDown(Object){
		Obj=Object.id
		document.all(Obj).setCapture()
		pX=event.x-document.all(Obj).style.pixelLeft;
		pY=event.y-document.all(Obj).style.pixelTop;
	}
	function MMove(){
		if(Obj!=''){
			document.all(Obj).style.left=event.x-pX;
			document.all(Obj).style.top=event.y-pY;
		}
	}
	function MUp(){
		if(Obj!=''){
			document.all(Obj).releaseCapture();
			Obj='';
		}
	}
	
	 function setRemainType() {
	 	massage_box.style.visibility='hidden'; mask.style.visibility='hidden';
	 	var remainTypes = document.getElementsByName("remaintype");
	 	//alert("remainTypes : " + remainTypes);
	 	var remainValue = 0;
	 	var hasValue = false;
	 	for(var i = 0; i < remainTypes.length; i++) {
	 		if(remainTypes[i].checked) {
	 		//alert("Number(remainTypes[i].value) : " + Number(remainTypes[i].value));
	 			remainValue += Number(remainTypes[i].value);
	 			hasValue = true;
	 		}
	 	}
	 	if(!hasValue)
	 		remainValue = 0;//不定制
	 	Ext.Ajax.request({
			url: 'addremainmsg.jsp',
			params: {
				remain_type: remainValue,
				opertype : "insert",
				app_name1 : document.title
				//manager_id : ''//暂无！
			},
			success: function(response, options) { 
	            //获取响应的json字符串 
	            var responseArray = Ext.util.JSON.decode(response.responseText); 
	            if (responseArray.success == true)  
	                Ext.Msg.alert('成功','设置成功!'); 
	            else  
	                Ext.Msg.alert('失败', responseArray.errorInfo); 
			},
			failure: function() {Ext.Msg.alert("提示","设置失败！请联系管理员.");}
		});
	 }
</script>
