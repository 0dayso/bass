<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 	
  	80 percent
  --%>
    <title>���������ֵ��������</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  </head>  
 
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> 
 <script type="text/javascript">
 	//cellclass[0]="grid_row_cell_text";
	//cellclass[1]="grid_row_cell_number";
	//cellclass[2]="grid_row_cell_number";
	//cellclass[3]="grid_row_cell_number";
	
	//cellfunc[1] = numberFormatDigit2;
	//cellfunc[2] = numberFormatDigit2;
	//cellfunc[3] = numberFormatDigit2;
	desc = true;
	function doSubmit(sortNum)
	{	
		var condition = " where 1=1 ";
		var op_time,area_id,county_id,tableName,sql,constantPart,_channel_level,orderSql,_top_N,_channel_name,_channel_code;
		orderSql = manageSort(sortNum); 
		//document.getElementById("channel_name_given").value != "" && document.getElementById("channel_name_given").value != "֧��ģ����ѯ"
		with(document.forms[0]) {
			area_id = city.value;
			county_id = county.value;//����,��ע��
			op_time = date.value;
			tableName = "nmk.ai_channel_sum_" + op_time;  
			_channel_level = channel_level.value;
			_top_N = top_N.value;
			_channel_name = channel_name.value;
			_channel_code = channel_code.value;
		}
		condition += _channel_level ? " and channel_level=" + _channel_level : "";
	    condition += (county_id == '' ? (area_id == '0' ? "" : " and city_id = '" + area_id + "'") : " and country_id = '" + county_id + "'");
		condition += _channel_name && _channel_name!='֧��ģ����ѯ' ? " and channel_name like '%" + _channel_name + "%'" : "";
		condition += _channel_code && _channel_code!='֧��ģ����ѯ' ? " and channel_code like '%" + _channel_code + "%'" : "";
		//alert("condition : " + condition);
		//constantPart = " channel_name, khfz_score, xyw_score, zd_score, khfw_score, score ";
		constantPart = " channel_name, khfz_score, xyw_score, zd_score, khfw_score, czk_score, rv_score, xx_score, fz_score	,score ";
		
		sql = "select " + constantPart + " from " + tableName + condition + orderSql;
		var countSql ="select count(*) from " + tableName + condition;
		document.forms[0].sql.value = sql;
	 	if(_top_N) {
	 		fetchRows = _top_N;
	 		countSql = undefined;
	 	}else fetchRows = 1000;
	 	ajaxSubmitWrapper(sql+" fetch first " + fetchRows  + " rows only with ur",countSql);
	} 
	
	function manageSort(sortNum) {
		if(!sortNum)return "";
		var orderSql = " order by " + sortNum + (desc? " desc ":" asc ");
		desc = !desc;
		//alert(orderSql);
		return orderSql;
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
	 // sqls.push("select AREA_ID, AREA_NAME  from MK.STAT_AREA where PARENT_ID='#{value}'   order by AREA_ID");
		sqls.push("select AREA_NAME, AREA_NAME  from MK.STAT_AREA where PARENT_ID='#{value}'   order by AREA_ID");
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
		/*
		var elements = document.getElementById("sortDiv").getElementsByTagName("td");
		for(var i = 0; i < elements.length; i++)
			catchEvent(elements[i],"click",doSubmit);
		*/
		catchEvent(document.getElementById("channel_name"),"blur",checkBlur);
		catchEvent(document.getElementById("channel_name"),"focus",checkFocus);	
		catchEvent(document.getElementById("channel_code"),"blur",checkBlur);
		catchEvent(document.getElementById("channel_code"),"focus",checkFocus);			
	}
	catchEvent(window,"load",setupEvents);
	Ext.onReady(function(){
		Ext.BLANK_IMAGE_URL = '../js/ext3/resources/images/default/s.gif';
	});
	function checkBlur(evt) {
		var event = evt ? evt : window.event;
		var theSrc = event.target ? event.target : event.srcElement;
		if(theSrc.value == "") {
			theSrc.value="֧��ģ����ѯ";
			theSrc.style.color = "gray";
			theSrc.style.fontStyle = "italic";
		}
		//alert("checkblur");
	}
	function checkFocus(evt) {
		var event = evt ? evt : window.event;
		var theSrc = event.target ? event.target : event.srcElement;
		theSrc.value="";//����ı�
		theSrc.style.color = "black";
		theSrc.style.fontStyle = "normal";
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
						
						<td class="dim_cell_title">��������</td>
						<td class="dim_cell_content"> 
						<%-- Ĭ��ֵ��0,�Ӳ��ι����п��� --%>
							<%=bass.common.QueryTools2.getAreaCodeHtml("city","0","areacombo(1)")%>
						</td>
						<td class="dim_cell_title">��������<!-- (ng) --></td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getCountyHtml("county","areacombo(2)")%>
						</td>
					</tr>
					<tr class="dim_row">
						<td class="dim_cell_title">��������</td>
						<td class="dim_cell_content">
						<input type="text" id="channel_name" name="channel_name" value="֧��ģ����ѯ" style="color:gray; font-style: italic;"/>
						</td>
						<td class="dim_cell_title">��������</td>
						<td class="dim_cell_content">
						<input type="text" id="channel_code" name="channel_code" value="֧��ģ����ѯ" style="color:gray; font-style: italic;"/>
						</td>
						<td class="dim_cell_title">�����Ǽ�</td>
						<td class="dim_cell_content">
							<select id="channel_level" name="channel_level">
								<option value="">ȫ��</option>
							</select>
							<script type="text/javascript" defer="defer">
								renderSelect("select channel_level,case when channel_level=1 then 'һ�Ǽ�' when channel_level=2 then '���Ǽ�' when channel_level=3 then '���Ǽ�' when channel_level=4 then '���Ǽ�' else '����' end from NMK.DIM_channel_level",document.forms[0].channel_level.value,document.forms[0].channel_level,undefined,undefined);
							</script>
						</td>
					</tr>
						<tr class="dim_row">
						<td class="dim_cell_title">ѡ��չ��ǰN��</td>
						<td class="dim_cell_content" colspan="5">
							<input type="text" id="top_N" name="top_N"/>
						</td>
						</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="��ѯ" onclick="doSubmit()">&nbsp;
							<input type="button" class="form_button" value="����" onclick="toDown(1)">&nbsp;
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
				 
				 <%-- 
				 
 �����ͻ���չ�÷�	
 ������ҵ��Ӫ���÷�	
 ���������ն����۵÷�
 �����ͻ�����÷�	
added
��ֵ�����۵÷�	
����ս�Ե÷�	
����ս�Ե÷�	
��չս�Ե÷�	
�ܵ÷�	
				 --%>
				 <tr class="grid_title_blue">
				 	<td class='grid_title_cell'>��������</td>
				 	<td class='grid_title_cell'>
				 	<a href="#" onclick="doSubmit(2)" title="�����������">
				 	�û���չ�÷�
				 	</a>
				 	</td>
				 	<td class='grid_title_cell'>
				 	<a href="#" onclick="doSubmit(3)" title="�����������">
				 	��ҵ��Ӫ���÷�
				 	</a>
				 	</td>
				 	<td class='grid_title_cell'>
				 	<a href="#" onclick="doSubmit(4)" title="�����������">
				 	�ն����۵÷�
				 	</a>
				 	</td>
				 	<td class='grid_title_cell'>
				 	<a href="#" onclick="doSubmit(5)" title="�����������">
				 	�ͻ�����÷�
				 	</a>
				 	</td>
				 	<%-- bak 
				 	<td class='grid_title_cell'>
				 	<a href="#" onclick="doSubmit(6)" title="�����������">
				 	�ܵ÷�
				 	</a>
				 	</td>
				 	--%>
				 	<%-- added --%>
				 	<td class='grid_title_cell'>
				 	<a href="#" onclick="doSubmit(6)" title="�����������">
				 	��ֵ�����۵÷�
				 	</a>
				 	</td>
				 		<td class='grid_title_cell'>
				 	<a href="#" onclick="doSubmit(7)" title="�����������">
				 	����ս�Ե÷�
				 	</a>
				 	</td>
				 		<td class='grid_title_cell'>
				 	<a href="#" onclick="doSubmit(8)" title="�����������">
				 	����ս�Ե÷�
				 	</a>
				 	</td>
				 		<td class='grid_title_cell'>
				 	<a href="#" onclick="doSubmit(9)" title="�����������">
				 	��չս�Ե÷�
				 	</a>
				 	</td>
				 		<td class='grid_title_cell'>
				 	<a href="#" onclick="doSubmit(10)" title="�����������">
				 	�ܵ÷�
				 	</a>
				 	</td>
				 	
				 </tr>
			</table>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
