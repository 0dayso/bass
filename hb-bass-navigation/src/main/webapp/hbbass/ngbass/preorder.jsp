<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  copied from preorder.jsp
  OWN_ORG_ID����ȡ�������к����е��ж�����
  ��������:
  staff_id����,�Լ��ɴ����������ݿ�ֵ����
  2010.05.13 : ά������д��,������Ϊд����ά�ȣ���������Ӧjs�ж�ά�ȵ�ҵ���߼�
  --%>
    <title>���ſͻ�Ӫ������������</title>
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
 		//���ǵ�һ�ν���ʱ���ύ��֮�󷵻ص�ҳ��
 		if(request.getAttribute("result") != null)
 		    out.print("alert('" + request.getAttribute("result") + "')");
 		//ÿ���ͻ�����ֻ�ܲ鿴����Ͻ��Χ�ڵļ�¼��Ϊ�ˣ�Ӧ����session�еõ�loginname
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
		return _value ? _value : "�޼�¼ <input type=\"button\" value=\"����\" onclick=\"Ext.getDom('groupcode').value =" + grpcode + ";Ext.getDom('feedback_div').style.display=''\">";
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
		//δ�������ʾ,�������������ڽ�����ʾ
		//�ػ��������
		var orderby = " order by  EXP_DATE asc,SERVICE_TIMES asc";
		
		//loginanme
		var loginName = '<%= loginname%>';
		/*��ʱ�����η���鲻��ֵ 091120
		if(loginName)
			condition += " and staff_id in (select distinct staff_id from user_config where user_id = '" + loginName + "')";
		*/	 
		with(document.forms[0]){
			area_id = city.value;
			county_id = county.value;
			op_time = date.value;
			tableName = "Nmk.Dw_AI_Ent_Business_Alert_" + op_time;
			condition += (viptype.value ? " and viptype='" + viptype.value + "'" : "");
			condition += (custgrade.value ? (custgrade.value.indexOf(",")!=-1 ? " and custgrade in ('" + custgrade.value + "')" : " and custgrade='" + custgrade.value + "'") : ""); /* 2010.05.13 : higherzl ����һ����Ŀ�����,�� in */
			// /* 2010.05.13 : higherzl ��Ϊҳ��д��,����һ��option����һ�����,��������ĳɺ��� */  condition += (valuegrade.value ? " and value_grade='" + valuegrade.value + "'" : "");
			condition += (valuegrade.value ? " and substr(value_grade,1,1)='" + valuegrade.value + "'" : "");
			
			condition += (gstate.value ? " and g_state=" + gstate.value : "");
		}
		
	    condition += (county_id == '' ? (area_id == '0' ? "" : " and substr(OWN_ORG_ID,1,5) = '" + area_id + "'") : " and substr(OWN_ORG_ID,1,8) = '" + county_id + "'");
			
		//alert("condition : " + condition);
		sql = " select  GROUPNAME || '@' || groupcode,CARE_DATE, EXP_DATE,case when SERVICE_TIMES=1 then '���' when service_times=0 then 'δ���' else 'δ֪' end,reminders ,REMINDERS_DATE "//������js����ת����Ҫ������, case when REMINDERS_DATE is null then '' else reminders_date end "
		+ " from " + tableName + condition + orderby;
		var countSql ="select count(*) from " + tableName + condition;
		//alert("sql : " + sql);
		//alert("countSql : " + countSql);
		document.forms[0].sql.value = sql;
	 	ajaxSubmitWrapper(sql+" fetch first 1000 rows only with ur",countSql);
		//����һ���£����������е�tableName��ֵ,����form1�ύ�󣬺�̨����֪����ѯ���ű�
		Ext.getDom("tablename").value = tableName;
	}

//ng�漶����������Ҫ��sql��ͬ��Ҳ���Ǳ�����ͬ
function areacombo(i,sync)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();
	if(document.forms[0].county != undefined)
	{
		selects.push(document.forms[0].county);
		//#�����ù����޹��Լ����ù����еı����޹�
		//sqlʹ�õ��ǲ��ι����еģ����Ա���Ҳ����ˣ�����ı�������dongyong���ҵ�ά��mk.dim_areacity/county
	  sqls.push("select AREA_ID, AREA_NAME  from MK.STAT_AREA where PARENT_ID='#{value}'   order by AREA_ID");
	}
	//������������
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
		var checkBoxes2 = document.getElementsByName("remaintype");//��Ϣ��������
		for(var i = 0; i < checkBoxes1.length; i++) {
			catchEvent(checkBoxes1[i],"change",checkSelect);
		} 
		/*ȡ�����������͵ļ��
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
				Ext.Msg.alert("ע��!","��������Ҫѡ��һ��Ԥ������");
				theSrc.checked = true;
			}
		}
		/*
			ȡ�����������͵��ж�
		 else if(theSrc.name == "remaintype") {
			var checkBoxes2 = document.getElementsByName("remaintype");
			var unselectAll = true;
			for(var i = 0; i < checkBoxes2.length; i++) {
				if(checkBoxes2[i].checked) unselectAll = false;
			} 
			if(unselectAll) {
				Ext.Msg.alert("ע��!","��������Ҫѡ��һ����Ϣ��������");
				//alert("��������Ҫѡ��һ����Ϣ��������");
				theSrc.checked = true;
			}
		}
		*/
		
	}
	catchEvent(window,"load",setupEvents);
	
	Ext.onReady(function(){
		Ext.BLANK_IMAGE_URL = '../js/ext3/resources/images/default/s.gif';
	});
	
	//form1������캯��
	function sendMsg1() {
	 			if(document.forms[1].datetime1.value && document.forms[1].msg1.value) 
	 				document.forms[1].submit();
	 			else 
	 				Ext.Msg.alert("ע��!","��ѡ���Ϊ��!");
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
						<td onClick="hideTitle(this.childNodes[0],'dim_div')" title="�������">
							<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
							&nbsp;��ѯ��������
						</td>
					</tr>
				</table>
			</legend>
			
			<div id="dim_div">
				<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="dim_row">
						<td class="dim_cell_title">ʱ��</td>
						<td class="dim_cell_content">
							<%=NgbassTools.getQueryDate("date","yyyyMM")%>
						</td>
						
						<td class="dim_cell_title">����</td>
						<td class="dim_cell_content"> 
						<%-- Ĭ��ֵ��0,�Ӳ��ι����п��� --%>
							<%=bass.common.QueryTools2.getAreaCodeHtml("city","0","areacombo(1)")%>
						</td>
						<td class="dim_cell_title">����<!-- (ng) --></td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getCountyHtml("county","areacombo(2)")%>
						</td>
					</tr>
					
					<tr class="dim_row">
					<%-- 
					<td class="dim_cell_title">Ԥ������(����)</td>
					<td class="dim_cell_content" colspan="5">
						<input type="checkbox" id="reserve" value="reserve" name="alerttype" checked="checked"/>ԤԼ��������
						<input type="checkbox" id="overdue" value="overdue" name="alerttype" />����Э�鵽��
						<input type="checkbox" id="anniversary" value="anniversary" name="alerttype"/>���ż����չػ�
						<input type="checkbox" id="servtimes" value="servtimes" name="alerttype"/>�ͻ�����Լ��ſͻ��ķ������δ���
					</td>
					--%>
					<td class="dim_cell_title">�ͻ�����</td>
					<td class="dim_cell_content">
						<select name="viptype">
							<option value="">ȫ��</option>
							 <%-- 2010.05.13 : higherzl д�� --%>
							<option value="PreGroup">Ǳ�ڼ���</option>
							<option value="Group">��������</option>
							<option value="SilentGroup">��Ĭ����</option>
							<option value="Lost">��������</option>
							<option value="VC0000">��ͨ�û�</option>
							<option value="LivGroup">��ʹ�ü���</option>
							<option value="stcmInv">����</option>
						</select>
						<%--
						��д��������
						<script type="text/javascript">
						//����д���ˣ���̫����
						/* 2010.05.13 : higherzl  ����case when ,չʾ�����ֶ� */
							renderSelect("select  distinct viptype , case when viptype='PreGroup' then 'Ǳ�ڼ���' when viptype='Group' then '��������' when viptype='SilentGroup' then '��Ĭ����' when viptype='Lost' then '��������' when viptype='VC0000' then'��ͨ�û�' when viptype='LivGroup' then'��ʹ�ü���' when viptype='stcmInv' then '����' else '����' end from Nmk.Dw_AI_Ent_Business_Alert_200908 where viptype is not null with ur",undefined,document.forms[0].viptype);
						</script>
						 --%>
					</td>
					<td class="dim_cell_title">���ż���</td>
					<td class="dim_cell_content">
					
						<select name="custgrade">
							<option value="">ȫ��</option>
							 <%-- 2010.05.13 : higherzl д�� --%>
							<option value="VC3000">A��</option>
							<option value="VC3100">B��</option>
							<option value="VC3200">C��</option>
							<%-- �Զ��ŷָ�,����jsƴsql,��Ȼд�����ͳ���д��,��'Ҳд�� --%>
							<option value="VC3300','VC3400','VC3500">D��</option>
						</select>
						<%-- 
						<script type="text/javascript">
						//����д���ˣ���̫����
							renderSelect("select distinct CUSTGRADE,  case when CUSTGRADE='VC3000' then 'A��'when CUSTGRADE='VC3100' then 'B��'when CUSTGRADE='VC3200' then 'C��'when CUSTGRADE='VC3300' then 'D��'when CUSTGRADE='VC3400' then 'D��'when CUSTGRADE='VC3500' then 'D��' else '����' end  from Nmk.Dw_AI_Ent_Business_Alert_200908 where custgrade is not null with ur",undefined,document.forms[0].custgrade);
						</script>
						--%>
						  
					</td>
					<td class="dim_cell_title">���ſͻ���ֵ�÷ּ���</td>
					<td class="dim_cell_content">
					<select name="valuegrade">
							<option value="">ȫ��</option>
							<%-- 2010.05.13 : higherzl д�� --%>
							<option value="A">A��</option>
							<option value="B">B��</option>
							<option value="C">C��</option>
						</select>
						<%--
						<script type="text/javascript">
						//����д���ˣ���̫����
							renderSelect("select distinct VALUE_GRADE , case when substr(VALUE_GRADE,1,1)='A' then 'A��' when substr(VALUE_GRADE,1,1)='B' then 'B��' when substr(VALUE_GRADE,1,1)='C' then 'C��' else '����' end from Nmk.Dw_AI_Ent_Business_Alert_200908 where VALUE_GRADE is not null with ur",undefined,document.forms[0].valuegrade);
						</script>
						 --%>
					</td>
					</tr>
					
						<tr class="dim_row">
						<td class="dim_cell_title">���ſͻ�����״̬</td>
					<td class="dim_cell_content" colspan="5">
						<select name="gstate">
							<option value="">ȫ��</option>
							<option value="-1">�浵</option>
							<option value="0">����</option>
							<option value="1">����</option>
							<option value="2">��ʧ</option>
						</select>
						<%-- 
						<script type="text/javascript">
						//����д���ˣ���̫����
							renderSelect("select distinct G_STATE , G_STATE from Nmk.Dw_AI_Ent_Business_Alert_200908 where G_STATE is not null with ur",undefined,document.forms[0].gstate);
						</script>
						--%>
					
					</td>
					<!-- ��ʱû�м�״̬��ά�� -->
					<%-- ����������� 
					<td class="dim_cell_title">��Ϣ��������</td>
					<td class="dim_cell_content" colspan="3">
						<input type="checkbox" id="sms" name=remaintype checked="checked"/>����
						<input type="checkbox" id="ms" name="remaintype"/>����
						<input type="checkbox" id="email" name="remaintype"/>�����ʼ�
					</td>
					--%>
					</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="��Ϣ��������" onclick="mask.style.visibility='visible';massage_box.style.visibility='visible'">&nbsp;
							<input type="button" class="form_button" value="��ѯ" onclick="doSubmit()">&nbsp;
							<input type="button" class="form_button" value="����" onclick="toDown(1)">&nbsp;
						</td>
					</tr>
				</table>
			</div>
		</fieldset>
	</div>
	<br/>
		</form>
		<%-- ��ǰ ����forms[0]���� --%>
	<%-- �������� --%>
	<div id="feedback_div" style="display:none;">
	<div style="width:100%;height:300%;background:#dddddd;position:absolute;z-index:99;left:0;top:0;filter:alpha(opacity=80);">&#160;</div>
	<div class="feedback">
		<div style="text-align: right"><img src='/hbbass/common2/image/tab-close.gif' style="cursor: hand;" onclick="{this.parentNode.parentNode.parentNode.style.display='none';}"></img></div>
		<form action="addremainmsg.jsp" method="get" enctype="multipart/form-data">
		<center>
		<span style="text-align :center;font-size : 16pt">ԤԼ����������Ϣ¼��</span>
		</center>
	<%-- ������,���groupcode,tablename--%>
		<input type="hidden" id="groupcode" name="groupcode" value="" />
		<input type="hidden" id="tablename" name="tablename" value="" />
		<table width="99%">
			<tr>
				<td>����ʱ��<span style="color:red">*</span></td>
				<td>
					<input id="datetime1" name="datetime1" type="text" readonly="readonly"/>
					<img onclick="WdatePicker({dateFmt:'yyyy-MM-dd',el:'datetime1'})" src="../js/datepicker/skin/datePicker.gif" onmouseover="this.style.cursor='hand'" width="16" height="22" align="absmiddle">
				</td>
			</tr>
			<tr>
				<td>ԤԼ������������<span style="color:red">*</span></td>
				<td>
					<textarea name="msg1" id="msg1" rows="10" cols="20"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
				<input type="button" value="�ύ" onclick="sendMsg1()" name="form2_submit" />
				<input type="reset" value="����" />
				</td> 
			</tr>
	 	</table>
	 	</form>
	</div>
	</div>  
		<%-- /�������� --%>
		
		<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="�������">
								<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
								&nbsp;����չ������
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
				 	<td width="" class="grid_title_cell">���ſͻ�����</td>
				 	<%--
				 	<td width="" class="grid_title_cell">�ͻ�����</td>
				 	<td width="" class="grid_title_cell">���ż���</td>
				 	<td width="" class="grid_title_cell">���ſͻ���ֵ�÷ּ���</td>
				 	<td width="" class="grid_title_cell">���ſͻ�����״̬</td>
				 	<td width="" class="grid_title_cell">״̬</td>
				 	 --%>
				 	<td width="" class="grid_title_cell">���ż����չػ�</td>
				 	 	<td width="" class="grid_title_cell">����Э�鵽��</td>
				 	<td width="" class="grid_title_cell">������</td>
				 	<td width="" class="grid_title_cell">ԤԼ��������</td>
				 		<td width="" class="grid_title_cell">����ʱ��</td>
				 </tr>
			</table>
		</div>			

  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>

<div id="massage_box">
	<div class="massage">
		 <div class="header" onmousedown=MDown(massage_box) style="cursor:move">
				<div style="display:inline; width:100px;position:absolute; ">��Ϣ��������</div>
			  <span onClick="massage_box.style.visibility='hidden'; mask.style.visibility='hidden'" style="float:right; display:inline; cursor:hand">��</span>
	   </div>
			<table width="96%" border="0" align="center" valign="middle">
	 		<tr>
	 			<td >
	 					<input type="checkbox" value="1" id="sms" name="remaintype" checked="checked"/>����
						<input type="checkbox" value="2" id="ms" name="remaintype"/>����
						<input type="checkbox" value="4" id="email" name="remaintype"/>�����ʼ�
	 			</td>
	 			<td>
	 				<input  type="button" value="ȷ��" onclick="setRemainType()"/>
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
	 		remainValue = 0;//������
	 	Ext.Ajax.request({
			url: 'addremainmsg.jsp',
			params: {
				remain_type: remainValue,
				opertype : "insert",
				app_name1 : document.title
			},
			success: function(response, options) { 
	            //��ȡ��Ӧ��json�ַ��� 
	            var responseArray = Ext.util.JSON.decode(response.responseText); 
	            if (responseArray.success == true)  
	                Ext.Msg.alert('�ɹ�','���óɹ�!'); 
	            else  
	                Ext.Msg.alert('ʧ��', responseArray.errorInfo); 
			},
			failure: function() {Ext.Msg.alert("��ʾ","����ʧ�ܣ�����ϵ����Ա.");}
		});
	 }
</script>
