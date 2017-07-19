<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  copied from preorder.jsp
  OWN_ORG_ID，截取当做地市和县市的判断条件
  遗留问题:
  staff_id问题,以及由此引发的数据库值问题
  2010.05.13 : 维度条件写死,另外因为写死了维度，更改了相应js判断维度的业务逻辑
  --%>
    <title>集团客户营销服务类提醒</title>
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
 		//不是第一次进入时，提交表单之后返回的页面
 		if(request.getAttribute("result") != null)
 		    out.print("alert('" + request.getAttribute("result") + "')");
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
	cellfunc[0] = function(datas,options) {
		return datas[options.seq].split("@")[0];
	}
	cellfunc[4]=function(datas,options) {
		var _value = datas[options.seq];
		var grpcode = datas[0].split("@")[1];
		return _value ? _value : "无记录 <input type=\"button\" value=\"增加\" onclick=\"Ext.getDom('groupcode').value =" + grpcode + ";Ext.getDom('feedback_div').style.display=''\">";
	}
	function doSubmit()
	{	
		var condition = " where 1=1 ";
		var op_time;
		var area_id;
		var county_id;
		var tableName;
		//var alertType;
		var remainType;
		var sql;
		//未达标先显示,到期日期离现在近先显示
		//关怀日期随机
		var orderby = " order by  EXP_DATE asc,SERVICE_TIMES asc";
		
		//loginanme
		var loginName = '<%= loginname%>';
		/*暂时先屏蔽否则查不到值 091120
		if(loginName)
			condition += " and staff_id in (select distinct staff_id from user_config where user_id = '" + loginName + "')";
		*/	 
		with(document.forms[0]){
			area_id = city.value;
			county_id = county.value;
			op_time = date.value;
			tableName = "Nmk.Dw_AI_Ent_Business_Alert_" + op_time;
			condition += (viptype.value ? " and viptype='" + viptype.value + "'" : "");
			condition += (custgrade.value ? (custgrade.value.indexOf(",")!=-1 ? " and custgrade in ('" + custgrade.value + "')" : " and custgrade='" + custgrade.value + "'") : ""); /* 2010.05.13 : higherzl 增加一个三目运算符,用 in */
			// /* 2010.05.13 : higherzl 因为页面写死,并且一个option代表一类情况,所以这里改成函数 */  condition += (valuegrade.value ? " and value_grade='" + valuegrade.value + "'" : "");
			condition += (valuegrade.value ? " and substr(value_grade,1,1)='" + valuegrade.value + "'" : "");
			
			condition += (gstate.value ? " and g_state=" + gstate.value : "");
		}
		
	    condition += (county_id == '' ? (area_id == '0' ? "" : " and substr(OWN_ORG_ID,1,5) = '" + area_id + "'") : " and substr(OWN_ORG_ID,1,8) = '" + county_id + "'");
			
		//alert("condition : " + condition);
		sql = " select  GROUPNAME || '@' || groupcode,CARE_DATE, EXP_DATE,case when SERVICE_TIMES=1 then '达标' when service_times=0 then '未达标' else '未知' end,reminders ,REMINDERS_DATE "//还是用js来做转换，要不报错, case when REMINDERS_DATE is null then '' else reminders_date end "
		+ " from " + tableName + condition + orderby;
		var countSql ="select count(*) from " + tableName + condition;
		//alert("sql : " + sql);
		//alert("countSql : " + countSql);
		document.forms[0].sql.value = sql;
	 	ajaxSubmitWrapper(sql+" fetch first 1000 rows only with ur",countSql);
		//再做一件事，将隐藏域中的tableName赋值,否则form1提交后，后台并不知道查询哪张表
		Ext.getDom("tablename").value = tableName;
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
	
	//form1表单的体检函数
	function sendMsg1() {
	 			if(document.forms[1].datetime1.value && document.forms[1].msg1.value) 
	 				document.forms[1].submit();
	 			else 
	 				Ext.Msg.alert("注意!","必选项不能为空!");
	 }
	
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
					<%-- 
					<td class="dim_cell_title">预警类型(属性)</td>
					<td class="dim_cell_content" colspan="5">
						<input type="checkbox" id="reserve" value="reserve" name="alerttype" checked="checked"/>预约服务提醒
						<input type="checkbox" id="overdue" value="overdue" name="alerttype" />集团协议到期
						<input type="checkbox" id="anniversary" value="anniversary" name="alerttype"/>集团纪念日关怀
						<input type="checkbox" id="servtimes" value="servtimes" name="alerttype"/>客户经理对集团客户的服务次数未达标
					</td>
					--%>
					<td class="dim_cell_title">客户类型</td>
					<td class="dim_cell_content">
						<select name="viptype">
							<option value="">全部</option>
							 <%-- 2010.05.13 : higherzl 写死 --%>
							<option value="PreGroup">潜在集团</option>
							<option value="Group">在网集团</option>
							<option value="SilentGroup">沉默集团</option>
							<option value="Lost">离网集团</option>
							<option value="VC0000">普通用户</option>
							<option value="LivGroup">正使用集团</option>
							<option value="stcmInv">作废</option>
						</select>
						<%--
						已写死，不查
						<script type="text/javascript">
						//表名写死了，不太合适
						/* 2010.05.13 : higherzl  增加case when ,展示中文字段 */
							renderSelect("select  distinct viptype , case when viptype='PreGroup' then '潜在集团' when viptype='Group' then '在网集团' when viptype='SilentGroup' then '沉默集团' when viptype='Lost' then '离网集团' when viptype='VC0000' then'普通用户' when viptype='LivGroup' then'正使用集团' when viptype='stcmInv' then '作废' else '其他' end from Nmk.Dw_AI_Ent_Business_Alert_200908 where viptype is not null with ur",undefined,document.forms[0].viptype);
						</script>
						 --%>
					</td>
					<td class="dim_cell_title">集团级别</td>
					<td class="dim_cell_content">
					
						<select name="custgrade">
							<option value="">全部</option>
							 <%-- 2010.05.13 : higherzl 写死 --%>
							<option value="VC3000">A类</option>
							<option value="VC3100">B类</option>
							<option value="VC3200">C类</option>
							<%-- 以逗号分隔,方便js拼sql,既然写死，就彻底写死,将'也写死 --%>
							<option value="VC3300','VC3400','VC3500">D类</option>
						</select>
						<%-- 
						<script type="text/javascript">
						//表名写死了，不太合适
							renderSelect("select distinct CUSTGRADE,  case when CUSTGRADE='VC3000' then 'A类'when CUSTGRADE='VC3100' then 'B类'when CUSTGRADE='VC3200' then 'C类'when CUSTGRADE='VC3300' then 'D类'when CUSTGRADE='VC3400' then 'D类'when CUSTGRADE='VC3500' then 'D类' else '其他' end  from Nmk.Dw_AI_Ent_Business_Alert_200908 where custgrade is not null with ur",undefined,document.forms[0].custgrade);
						</script>
						--%>
						  
					</td>
					<td class="dim_cell_title">集团客户价值得分级别</td>
					<td class="dim_cell_content">
					<select name="valuegrade">
							<option value="">全部</option>
							<%-- 2010.05.13 : higherzl 写死 --%>
							<option value="A">A类</option>
							<option value="B">B类</option>
							<option value="C">C类</option>
						</select>
						<%--
						<script type="text/javascript">
						//表名写死了，不太合适
							renderSelect("select distinct VALUE_GRADE , case when substr(VALUE_GRADE,1,1)='A' then 'A类' when substr(VALUE_GRADE,1,1)='B' then 'B类' when substr(VALUE_GRADE,1,1)='C' then 'C类' else '不详' end from Nmk.Dw_AI_Ent_Business_Alert_200908 where VALUE_GRADE is not null with ur",undefined,document.forms[0].valuegrade);
						</script>
						 --%>
					</td>
					</tr>
					
						<tr class="dim_row">
						<td class="dim_cell_title">集团客户在网状态</td>
					<td class="dim_cell_content" colspan="5">
						<select name="gstate">
							<option value="">全部</option>
							<option value="-1">存档</option>
							<option value="0">存量</option>
							<option value="1">增量</option>
							<option value="2">流失</option>
						</select>
						<%-- 
						<script type="text/javascript">
						//表名写死了，不太合适
							renderSelect("select distinct G_STATE , G_STATE from Nmk.Dw_AI_Ent_Business_Alert_200908 where G_STATE is not null with ur",undefined,document.forms[0].gstate);
						</script>
						--%>
					
					</td>
					<!-- 暂时没有加状态的维度 -->
					<%-- 不在这里添加 
					<td class="dim_cell_title">信息推送类型</td>
					<td class="dim_cell_content" colspan="3">
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
		</form>
		<%-- 提前 到此forms[0]结束 --%>
	<%-- 新增功能 --%>
	<div id="feedback_div" style="display:none;">
	<div style="width:100%;height:300%;background:#dddddd;position:absolute;z-index:99;left:0;top:0;filter:alpha(opacity=80);">&#160;</div>
	<div class="feedback">
		<div style="text-align: right"><img src='/hbbass/common2/image/tab-close.gif' style="cursor: hand;" onclick="{this.parentNode.parentNode.parentNode.style.display='none';}"></img></div>
		<form action="addremainmsg.jsp" method="get" enctype="multipart/form-data">
		<center>
		<span style="text-align :center;font-size : 16pt">预约服务提醒信息录入</span>
		</center>
	<%-- 隐藏域,存放groupcode,tablename--%>
		<input type="hidden" id="groupcode" name="groupcode" value="" />
		<input type="hidden" id="tablename" name="tablename" value="" />
		<table width="99%">
			<tr>
				<td>提醒时间<span style="color:red">*</span></td>
				<td>
					<input id="datetime1" name="datetime1" type="text" readonly="readonly"/>
					<img onclick="WdatePicker({dateFmt:'yyyy-MM-dd',el:'datetime1'})" src="../js/datepicker/skin/datePicker.gif" onmouseover="this.style.cursor='hand'" width="16" height="22" align="absmiddle">
				</td>
			</tr>
			<tr>
				<td>预约服务提醒内容<span style="color:red">*</span></td>
				<td>
					<textarea name="msg1" id="msg1" rows="10" cols="20"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
				<input type="button" value="提交" onclick="sendMsg1()" name="form2_submit" />
				<input type="reset" value="重置" />
				</td> 
			</tr>
	 	</table>
	 	</form>
	</div>
	</div>  
		<%-- /新增功能 --%>
		
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
				 	<%--
				 	<td width="" class="grid_title_cell">客户类型</td>
				 	<td width="" class="grid_title_cell">集团级别</td>
				 	<td width="" class="grid_title_cell">集团客户价值得分级别</td>
				 	<td width="" class="grid_title_cell">集团客户在网状态</td>
				 	<td width="" class="grid_title_cell">状态</td>
				 	 --%>
				 	<td width="" class="grid_title_cell">集团纪念日关怀</td>
				 	 	<td width="" class="grid_title_cell">集团协议到期</td>
				 	<td width="" class="grid_title_cell">服务达标</td>
				 	<td width="" class="grid_title_cell">预约服务提醒</td>
				 		<td width="" class="grid_title_cell">提醒时间</td>
				 </tr>
			</table>
		</div>			

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
<script type="text/javascript"> 
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
