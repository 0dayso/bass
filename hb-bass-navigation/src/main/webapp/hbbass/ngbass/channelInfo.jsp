<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  	���ά�ȣ�������������ģ����ѯ,
  	������ֹ���Ҫ�����͵�ʵ��
  --%>
    <title>���������ͼ</title>
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
 pagenum = 20;//����ÿҳ��ʾ������Ϊ20��
 	//cellclass[0]="grid_row_cell_text";
	//cellclass[1]="grid_row_cell_number";
	//cellclass[2]="grid_row_cell_number";
	//cellclass[3]="grid_row_cell_number";
	
	//cellfunc[1] = numberFormatDigit2;
	//cellfunc[2] = numberFormatDigit2;
	//cellfunc[3] = numberFormatDigit2;
	
	function doSubmit()
	{	
		var condition = " where 1=1 ";
		var op_time,area_id,county_id,tableName,sql,_viewType,constantPart,titleDiv,_channel_type,_channel_state,_channel_name;
		with(document.forms[0]) {
			area_id = city.value;
			county_id = county.value;//����,��ע��
			op_time = date.value;
			tableName = "nmk.ai_channel_sum_" + op_time;  
			_viewType = viewType.value;
			_channel_type = channel_type.value;
			_channel_name = channel_name.value;
			_channel_state = channel_state.value;
		}
		condition += _channel_type ? " and channel_type ='" + _channel_type + "'" : "";
		condition += _channel_state ? " and channel_state ='" + _channel_state + "'" : "";
		condition += _channel_name && _channel_name!='֧��ģ����ѯ' ? " and channel_name like '%" + _channel_name + "%'" : "";
		switch(_viewType) {
			case '1':
				for(var i = 0; i< 17; i++) {
				 	cellfunc[i] =undefined;
				 	if(i == 16) cellfunc[i] = function(datas,options) {
				 		switch(datas[options.seq]) {
							case '1':return 'һ�Ǽ�';break;
							case '2':return '���Ǽ�';break;
							case '3':return '���Ǽ�';break;
							case '4':return '���Ǽ�';break;
							default :return '����';break;
						}
				 	}
				}
			constantPart = " (select area_name from mk.dim_social_channel where area_id=city_id),(select area_name from mk.dim_social_channel where area_id=country_id),market_org_id,bureau_type,channel_name,channel_code,channel_state, channel_type, case when hall_flag = 0 then '��' when hall_flag = 1 then '��' else 'δ֪' end,channel_modle,case when operators_type='yd' then '�ƶ�' else operators_type end,Stra_Partners,exclusiveness_flag,sign_effdate,case when connect_flag=1 then '��'  when connect_flag=0 then '��' else 'δ֪' end,sign_expdate," + 
			//ori one "case when channel_level=1 then 'һ�Ǽ�' when channel_level=2 then '���Ǽ�' when channel_level=3 then '���Ǽ�' when channel_level=4 then '���Ǽ�' when channel_level=5 then '���Ǽ�' else 'δ֪' end ";
			//modified one
			"case when (select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=channel_code order by number desc fetch first 1 rows only) is null then channel_level else (select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=channel_code order by number desc fetch first 1 rows only) end ";
			/*
			���� ���� ���� �������� �������� �������� ����״̬ �������� �Ƿ��ſڵ� ��Ӫģʽ ��Ӫ������ ս�Ժ������ ������ ǩԼʱ�� ������ ��������ʱ�� �����Ǽ�
			*/
			titleDiv = "<table id='resultTable' align='center' width='150%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
					+"<tr class='grid_title_blue'>"
					+"<td class='grid_title_cell'>����</td>"
					+"<td class='grid_title_cell'>����</td>"
					+"<td class='grid_title_cell'>����</td>"
					+"<td class='grid_title_cell'>��������</td>"
					+"<td class='grid_title_cell'>��������</td>"
					+"<td class='grid_title_cell'>��������</td>"
					+"<td class='grid_title_cell'>����״̬</td>"
					+"<td class='grid_title_cell'>��������</td>"
					+"<td class='grid_title_cell'>�Ƿ��ſڵ�</td>"
					+"<td class='grid_title_cell'>��Ӫģʽ</td>"
					+"<td class='grid_title_cell'>��Ӫ������</td>"
					+"<td class='grid_title_cell'>ս�Ժ������</td>"
					+"<td class='grid_title_cell'>������</td>"
					+"<td class='grid_title_cell'>ǩԼʱ��</td>"
					+"<td class='grid_title_cell'>������</td>"
					+"<td class='grid_title_cell'>��������ʱ��</td>"
					+"<td class='grid_title_cell'>�����Ǽ�</td>"
					+"</tr></table>";
			break;
			case '2':
			for(var i = 0; i< 13; i++) {
				 if(i >=8 && i<=12)
				 	cellfunc[i] =numberFormatDigit2;
				 else cellfunc[i] =undefined;
			}
			constantPart = " channel_name,channel_code,xz_num,null_num,lw_num,crw_num,debt_num,n_fh_num,fh_arpu/1000.00,xz_arpu/1000.00,fh_bill_charge/1000.00,xz_bill_charge/1000.00,debt_charge/1000.00 ";
			titleDiv = "<table id='resultTable' align='center' width='150%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
					+"<tr class='grid_title_blue'>"
					
					+"<td class='grid_title_cell'>��������</td>"//added
					+"<td class='grid_title_cell'>��������</td>"//added
					+"<td class='grid_title_cell'>�����ͻ���</td>"
					+"<td class='grid_title_cell'>��οͻ���</td>"
					+"<td class='grid_title_cell'>���������ͻ���</td>"
					+"<td class='grid_title_cell'>�������ͻ���</td>"
					+"<td class='grid_title_cell'>�����ۼ�Ƿ�ѿͻ���</td>"
					+"<td class='grid_title_cell'>δ�ź���</td>"
					+"<td class='grid_title_cell'>�źſͻ�ARPUֵ</td>"
					+"<td class='grid_title_cell'>�����ͻ�����ARPUֵ</td>"
					+"<td class='grid_title_cell'>�źſͻ�����������</td>"
					+"<td class='grid_title_cell'>�����ͻ�����������</td>"
					+"<td class='grid_title_cell'>����Ƿ�ѽ��</td>"
					+"</tr></table>";
			break;
			case '3':
			for(var i = 0; i< 9; i++) {
				 cellfunc[i] =undefined;
			}
			constantPart = " channel_name,channel_code,new_rec_times,new_rec_num,focus_rec_times,terminal_num,disbind_num,other_sales_times,other_sales_num ";
			titleDiv = "<table id='resultTable' align='center' width='120%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
					+"<tr class='grid_title_blue'>"
					+"<td class='grid_title_cell'>��������</td>"//added
					+"<td class='grid_title_cell'>��������</td>"//added
					+"<td class='grid_title_cell'>��ҵ��������</td>"
					+"<td class='grid_title_cell'>��ҵ��չ�ͻ���</td>"
					+"<td class='grid_title_cell'>�ص�ҵ��������</td>"
					+"<td class='grid_title_cell'>�����ն���������</td>"
					+"<td class='grid_title_cell'>����û���</td>"
					+"<td class='grid_title_cell'>��������ҵ��������</td>"
					+"<td class='grid_title_cell'>��������ҵ������ͻ���</td>"
					+"</tr></table>";
			break;
			case '4':
			for(var i = 0; i< 6; i++) {
				if(i == 4) {
					cellfunc[i] = numberFormatDigit2;
				}
				else cellfunc[i] =undefined;
			}
			constantPart = " channel_name,channel_code,rec_times,rec_num,Payment_charge/1000.00,Payment_times ";
			titleDiv = "<table id='resultTable' align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
					+"<tr class='grid_title_blue'>"
					+"<td class='grid_title_cell'>��������</td>"//added
					+"<td class='grid_title_cell'>��������</td>"//added
					+"<td class='grid_title_cell'>ҵ����(���ɷ�.������)������</td>"
					+"<td class='grid_title_cell'>ҵ����(���ɷ�.������)����ͻ���</td>"
					+"<td class='grid_title_cell'>�����ɷѽ��</td>"
					+"<td class='grid_title_cell'>�����ɷѱ���</td>"
					+"</tr></table>";
			break;
			case '5':
			for(var i = 0; i< 6; i++) {
				if(i >= 2 && i<=5) {
					cellfunc[i] = numberFormatDigit2;
				}
				else cellfunc[i] =undefined;
			}
			constantPart = " channel_name,channel_code,fh_REWARD/1000.00,zz_rec_REWARD/1000.00,general_REWARD/1000.00,other_REWARD/1000.00 ";
			titleDiv = "<table id='resultTable' align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
	 				+"<tr class='grid_title_blue'>"
					+"<td class='grid_title_cell'>��������</td>"//added
					+"<td class='grid_title_cell'>��������</td>"//added
					+"<td class='grid_title_cell'>�źų��</td>"
					+"<td class='grid_title_cell'>��ҵ����</td>"
					+"<td class='grid_title_cell'>��ͨҵ����</td>"
					+"<td class='grid_title_cell'>�������</td>"
					+"</tr></table>";
			break;
			case '6':
			//��������������
			//����: �������ʱ���ֻȡһ����¼���й���?���һ��channel_code����ʷ����ֻ��һ����¼�Ļ������������ͽ����
			//done,��ҪǶ�ײ�ѯ�Ӳ�ѯ
			//�ο�sql(����):select o_channel_level,change_reason,change_staff,eff_date from nmk.ai_channel_sum_hist where changes_date in (select max(changes_date) from nmk.ai_channel_sum_hist group by channel_code);
			
			/*
	091126: ���������ͼ�еģ���չ���������ԭ�Ǽ��ĳ�һ�ǣ����ǣ����ǰ�
	*/
	for(var i = 0; i< 11; i++) {
		if(i == 5) {
			cellfunc[i]= function(datas,options){
				switch(datas[options.seq]) {
					case '1':return 'һ�Ǽ�';break;
					case '2':return '���Ǽ�';break;
					case '3':return '���Ǽ�';break;
					case '4':return '���Ǽ�';break;
					case '5':return '���Ǽ�';break;
					default :return '����';break;
				}
			}
		}
		if(i == 8) {
			cellfunc[i]= function(datas,options){return datas[options.seq].substr(0,19);}
		}
		else cellfunc[i] =undefined;
	}
			//condition += " and a.channel_code in (select distinct channel_code from nmk.ai_channel_sum_hist ) ";//test//
			tableName = "nmk.ai_channel_sum_" + op_time + " a left outer join (select channel_code,o_channel_level,change_reason,change_staff,changes_date from nmk.ai_channel_sum_hist where changes_date in (select max(changes_date) from nmk.ai_channel_sum_hist group by channel_code)) h on a.channel_code=h.channel_code ";
			constantPart = "  a.channel_name,a.channel_code,khfz_score,xyw_score,khfw_score,h.o_channel_level,h.change_reason,h.change_staff,h.changes_date,Violation_type,Violation_date ";
			titleDiv = "<table id='resultTable' align='center' width='120%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
					+"<tr class='grid_title_blue'>"
					+"<td class='grid_title_cell'>��������</td>"//added
					+"<td class='grid_title_cell'>��������</td>"//added
					+"<td class='grid_title_cell'>�����ͻ���չ�÷�</td>"
					+"<td class='grid_title_cell'>������ҵ��Ӫ���÷�</td>"
					+"<td class='grid_title_cell'>�����ͻ�����÷�</td>"
					+"<td class='grid_title_cell'>ԭ�Ǽ�</td>"
					+"<td class='grid_title_cell'>�Ǽ����ԭ��</td>"
					+"<td class='grid_title_cell'>�Ǽ������Ա����</td>"
					+"<td class='grid_title_cell'>�Ǽ��������</td>"
					+"<td class='grid_title_cell'>����Υ������</td>"
					+"<td class='grid_title_cell'>Υ������</td>"
					+"</tr></table>";
			break;
			default:constantPart = ""; break;
		}
	    condition += (county_id == '' ? (area_id == '0' ? "" : " and city_id = '" + area_id + "'") : " and country_id = '" + county_id + "'");
		//alert("condition : " + condition);
		sql = "select " + constantPart + " from " + tableName + condition;
		var countSql ="select count(*) from " + tableName + condition;
		document.getElementById("title_div").innerHTML=titleDiv;
		document.forms[0].sql.value = sql;
	 	//alert("sql : " + sql);
	 	ajaxSubmitWrapper(sql+" fetch first 1000 rows only with ur",countSql);
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
		catchEvent(document.getElementById("channel_name"),"blur",checkBlur);
		catchEvent(document.getElementById("channel_name"),"focus",checkFocus);	
	}
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
						<td class="dim_cell_title">����Ҫ������</td>
						<td class="dim_cell_content" colspan="5">
							<select id="viewType" name="viewType">
								<option value="1">������������</option>
								<option value="2">�����û���չ��</option>
								<option value="3">��������ҵ����</option>
								<option value="4">�����ͻ�������</option>
								<option value="5">���������</option>
								<option value="6">������չ����</option>
							</select>
						</td>
					</tr>
					<tr>
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
							<select id="channel_type" name="channel_type">
								<option value="">ȫ��</option>
							</select>
								<script type="text/javascript" defer="defer">
									renderSelect("select distinct channel_type,channel_type from nmk.ai_channel_sum_200909",document.forms[0].channel_type.value,document.forms[0].channel_type,undefined,undefined);
								</script>
						</td>
						<td class="dim_cell_title">����״̬</td>
						<td class="dim_cell_content">
							<select id="channel_state" name="channel_state">
								<option value="">ȫ��</option>
							</select>
								<script type="text/javascript" defer="defer">
									renderSelect("select distinct channel_state,channel_state from nmk.ai_channel_sum_200909",document.forms[0].channel_state.value,document.forms[0].channel_state,undefined,undefined);
								</script>
						</td>
						<td class="dim_cell_title">
							��������
						</td>
						<td class="dim_cell_content">
							<input type="text" id="channel_name" name="channel_name" value="֧��ģ����ѯ" style="color:gray; font-style: italic;"/>
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
			<%--
			<table id="resultTable" align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				 </tr>
			</table>
			--%>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
