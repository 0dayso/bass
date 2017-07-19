<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  copied from key.jsp
   OWN_ORG_ID，截取当做地市和县市的判断条件
   SUM_DEBT_CHARGE 欠费，单位是分
   TF_CHARGE_L 统付收入，单位是厘
   
   2010.05.12 : 增加 case when 以展示中文
  --%>
    <title>集团客户业务类预警</title>
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
	cellclass[1]="grid_row_cell_number";
	cellclass[2]="grid_row_cell_number";
	cellclass[3]="grid_row_cell_number";
	
	cellfunc[1] = numberFormatDigit2;
	cellfunc[2] = numberFormatDigit2;
	cellfunc[3] = numberFormatDigit2;
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
		if(loginName)
		//测试去掉否则查不出记录
			condition += "";//" and staff_id in (select distinct staff_id from user_config where user_id = '" + loginName + "')";
		with(document.forms[0]) {
			area_id = city.value;
			county_id = county.value;
			op_time = date.value;
			tableName = "Nmk.Dw_AI_Ent_Business_Alert_" + op_time;  
		}
	    condition += (county_id == '' ? (area_id == '0' ? "" : " and substr(OWN_ORG_ID,1,5) = '" + area_id + "'") : " and substr(OWN_ORG_ID,1,8) = '" + county_id + "'");
		var alertTypes = document.getElementsByName("alerttype");
		for(var i = 0; i < alertTypes.length; i++) {
			if(alertTypes[i].checked) {
				condition += alertTypes[i].value == "leveldown" ? " and VALUE_GRADE > OVALUE_GRADE" : "";//集团客户级别降低,级别：A>B,B1>B2,数据库相反，所以用>判断
				condition += alertTypes[i].value == "debt" ? " and SUM_DEBT_CHARGE !=0" : "";//集团帐户欠费,可能有负数，并且负数和正数都代表欠费，所以判断条件是!=0
				condition += alertTypes[i].value == "incomedown" ? " and TF_CHARGE_T < TF_CHARGE_L" : "";//统付收入下降
			} else continue;
		}
			
		//alert("condition : " + condition);
		//单位是分，应该除以100 ,单位是厘，应该除以1000
		//sql = " select GROUPNAME,TF_CHARGE_T/1000 , TF_CHARGE_L/1000 ,SUM_DEBT_CHARGE/100,(select value from dim_total where name = '集团级别' and key = VALUE_GRADE),(select value from dim_total where name = '集团级别' and key = OVALUE_GRADE) "
		// sql = " select GROUPNAME,TF_CHARGE_T/1000 , TF_CHARGE_L/1000 ,SUM_DEBT_CHARGE/100,VALUE_GRADE, OVALUE_GRADE "  /* 2010.05.12 higherzl 增加case when 展示中文 */
		sql = " select GROUPNAME,TF_CHARGE_T/1000 , TF_CHARGE_L/1000 ,SUM_DEBT_CHARGE/100,case when substr(VALUE_GRADE,1,1)='A' then 'A类' when  substr(VALUE_GRADE,1,1)='B' then 'B类' when  substr(VALUE_GRADE,1,1)='C' then 'C类' else '不详' end ,case when substr(OVALUE_GRADE,1,1)='A' then 'A类' when  substr(OVALUE_GRADE,1,1)='B' then 'B类' when  substr(OVALUE_GRADE,1,1)='C' then 'C类' else '不详' end "
		+ " from " + tableName + condition;
		var countSql ="select count(*) from " + tableName + condition;
		//新加入维表select * from dim_total where name = '集团级别'
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
		Ext.BLANK_IMAGE_URL = '../js/ext3/resources/images/default/s.gif';
	});
  </script>
  <body>
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
						<input type="checkbox" id="leveldown" value="leveldown" name="alerttype" />集团客户级别降低
						<input type="checkbox" id="debt" value="debt" name="alerttype" checked="checked" />集团帐户欠费
						<input type="checkbox" id="incomedown" value="incomedown" name="alerttype"/>统付收入下降
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
				 	<td width="" class="grid_title_cell">集团客户名称</td>
				 	<td width="" class="grid_title_cell">统一付费收入(元)</td>
				 	<td width="" class="grid_title_cell">上月统一付费收入(元)</td>
				 	<td width="" class="grid_title_cell">欠费金额(元)</td>
				 	<td width="" class="grid_title_cell">集团客户价值得分级别</td>
				 	<td width="" class="grid_title_cell">上月集团客户价值得分级别</td>
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
