<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 	
  	��Ȼ��ȫ��д,��Ҫ���ɺ��
  	���ɵ�����
  	zb001	2
  	zb002	3
  	zboo2	5
  --%>
  <%-- 
  	refer sql :
  	select  "ZB_CODE", "ZB_NAME", sum(case when time_id='200909' then zb_value else 0 end) ,sum(case when time_id='200908' then zb_value else 0 end)
  from "NMK"."AI_CHANNEL_KPI_WAVE" WHERE channel_type = '1' 
  group by zb_code,zb_name order by 1
  
  2009.12.24 ������δ��λԤ��������sql,ԭ�����ƺ������⣬��Ϊ�����ϴ���Ԥ������
  ���Ӹ�λ�ʣ�
  	case when (sum(case when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end))!= 0 then (   decimal((sum(case when time_id='" + op_time + "' and channel_type = '4' and a.zb_value > b.max_value then 1 else 0 end)),16,2)     /(sum(case when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end))) else 0 end
  --%>
    <title>�����������Ԥ��</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="js/common.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  </head>  
 
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> 
 <script type="text/javascript">
	for(var i = 0 ; i < 7 ;i++) {
		if(i==0 || i == 3)
			cellclass[i]="grid_row_cell_text";
		else 
			cellclass[i] = "grid_row_cell_number";
	}
	var outerCondition;//����������������
	//��������� cellfunc[2] = percentFormat;
	
	//�����ķָ���������
	cellfunc[0] = function(datas,options) {
		var parts = datas[0].split(",");
		return parts[1];//��������
	}
	cellfunc[1] = percentFormat;
	cellfunc[2] = percentFormat;
	cellfunc[6] = percentFormat;
	cellfunc[4] = function(datas,options) {
	/*
	��������:zb_code,����datas����;
			queryTime,����outerCondition;
			area_id,����outerCondition;
			��county_id,����outerCondition;
			channel_code,����outerCondition;
			counts,it is false
			*/
		return "<a href='#' onclick=window.open('alertDetail.jsp?" + outerCondition + "&zb_code=" + datas[0].split(",")[0] + "&counts=" + datas[options.seq] + "','alertDetail','width=800,height=600,status=no,resizable=yes,menubar=no,toolbar=no')>" + datas[options.seq] + "</a>";
	};
	/*
	cellfunc[5] = percentFormat;
	cellfunc[6] = percentFormat;
	cellfunc[7] = percentFormat;
	cellfunc[8] = percentFormat;
	cellfunc[9] = percentFormat;
	cellfunc[10] = percentFormat;
	cellfunc[11] = percentFormat;
	cellfunc[12] = percentFormat;
	cellfunc[13] = percentFormat;
	cellfunc[14] = percentFormat;
	cellfunc[15] = percentFormat;
	cellfunc[16] = percentFormat;
	cellfunc[17] = percentFormat;
	cellfunc[18] = percentFormat;
	*/
	function doSubmit(sortNum)
	{	
		outerCondition = "";//ÿ�ν�������,�������Ա��治ͬ������
		var op_time,area_id,county_id,sql,condition,tblName,innerCondition,constantPart,_channel_name;
		tblName = "nmk.ai_channel_kpi_wave";
		with(document.forms[0]) {
			area_id = city.value;
			county_id = country.value;//����,��ע��
			op_time = date.value;
			_channel_code = channel_code.value;
		}
		condition = " a.zb_code not in('SH010','SH012','SH015','SH017','SH020','SH023') and time_id in ('" + op_time + "','" + getLastMonth(op_time) + "')";
		var specialCond = " a.zb_code not in('SH010','SH012','SH015','SH017','SH020','SH023') and channel_type ='4' and time_id in ('" + op_time + "','" + getLastMonth(op_time) + "') and a.zb_value <= b.max_value ";
		condition += _channel_code && _channel_code!='֧��ģ����ѯ' ? " and channel_code like '%" + _channel_code + "%'" : "";
		specialCond += _channel_code && _channel_code!='֧��ģ����ѯ' ? " and channel_code like '%" + _channel_code + "%'" : "";
		outerCondition += "queryTime=" + op_time;//��Ϊ��һ��������û��& 
		outerCondition += _channel_code && _channel_code!='֧��ģ����ѯ' ? "&channel_code=" + _channel_code : "&channel_code=";
		if(county_id){
			condition += " and substr(channel_code,1,8)='" + county_id + "'";
			specialCond += " and substr(channel_code,1,8)='" + county_id + "'";
			condition += " and channel_type in ('3','4')";
			innerCondition = " channel_type='3' ";
			outerCondition += "&country_id=" + county_id;//һ�����ǵ�һ����������&
			outerCondition += "&area_id=";
		} else if(area_id != 0) {
			condition += " and substr(channel_code,1,5)='" + area_id + "'";
			specialCond += " and substr(channel_code,1,5)='" + area_id + "'";
			condition += " and channel_type in ('2','4')";
			innerCondition = " channel_type='2' ";
			outerCondition += "&area_id=" + area_id;
			outerCondition += "&country_id=";
		} else {
			//ȫʡ,���ӵ���Լ��
			condition += " and channel_type in ('1','4')";
			innerCondition = " channel_type='1' ";
			outerCondition += "&area_id=" ;//��ֵ
			outerCondition += "&country_id="
		}
		sql = "select col1 ,thisVal,lastVal,col4,yj_count,c.wfw," + 
		" case when (yj_count - c.wfw) != 0 then decimal((yj_count - c.wfw),16,2)/l_yj_count else 0 end " + //��λ�� : �ָ�����������/���µ�Ԥ������
		" from (select  a.zb_code as zb_code,a.zb_code || ',' || a.ZB_NAME as col1 " + 
		",sum(case when time_id='" + op_time + "' and " + innerCondition + " then zb_value else 0 end) as thisVal " + 
		" ,sum(case when time_id='" + getLastMonth(op_time) + "' and " + innerCondition + " then zb_value else 0 end) as lastVal " + 
		", (select tbl.alert_level from nmk.ai_channel_kpi_threshold tbl where tbl.zb_code=a.zb_code and (sum(case when time_id='" + op_time + "' and " + innerCondition + " then zb_value else 0 end)) > tbl.min_value and (sum(case when time_id='" + op_time + "' and " + innerCondition + " then zb_value else 0 end)) <= tbl.max_value ) col4" + 
		",sum(case when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end)as yj_count" + //Ԥ����������
		",sum(case when time_id='" + op_time + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end)as l_yj_count" + //����Ԥ����������,�㸴λ����
		//",count(distinct case when time_id='" + op_time + "' and channel_type = '4' and a.zb_value <= b.max_value then channel_code when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then channel_code else null end)," + 
		// ",sum(case when (case when time_id ='" + op_time + "' and channel_type = '4' and a.zb_value <= b.max_value then '' else null end) is not null  and (case when time_id ='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then '' else null end) is not null then 1 else 0 end)" + 
		//added for test
		//",sum((case when time_id ='" + op_time + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else null end))" + 
		//",sum((case when time_id ='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else null end))" + 
		// added done
		//��λ�� ��",case when (sum(case when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end))!= 0 then (   decimal((sum(case when time_id='" + op_time + "' and channel_type = '4' and a.zb_value > b.max_value then 1 else 0 end)),16,2)     /(sum(case when time_id='" + getLastMonth(op_time) + "' and channel_type = '4' and a.zb_value <= b.max_value then 1 else 0 end))) else 0 end " + 
		//",c.www " + 
		" from NMK.AI_CHANNEL_KPI_WAVE a " + 
		"left join ( select zb_code,max_value from nmk.ai_channel_kpi_threshold where alert_level = '��' ) b on a.zb_code = b.zb_code " + 
		" WHERE " + condition + "group by a.ZB_CODE, a.ZB_NAME ) tbla " + 
		" inner join (select zb_code ,count(*) wfw from (" + 
		" select a.zb_code,channel_code,count(*) from NMK.AI_CHANNEL_KPI_WAVE a left join ( select zb_code,max_value from nmk.ai_channel_kpi_threshold where alert_level = '��' ) b on a.zb_code = b.zb_code " + 
		" where " + specialCond + 
		" group by a.zb_code,channel_code having count(*)>1" + 
		") t group by zb_code ) c on c.zb_code=tbla.zb_code" ; 
		document.forms[0].sql.value = sql;
	 	ajaxSubmitWrapper(sql+" fetch first " + fetchRows  + " rows only with ur",null);
	} 
	

//ng�漶����������Ҫ��sql��ͬ��Ҳ���Ǳ�����ͬ
function areacombo(i,sync)
{
	selects = new Array();
	selects.push(document.forms[0].city);
	sqls = new Array();
	if(document.forms[0].country != undefined)
	{
		selects.push(document.forms[0].country);
		sqls.push("select AREA_ID, AREA_NAME  from MK.STAT_AREA where PARENT_ID='#{value}' order by AREA_ID");
	}
	//������������
	var bl = false;
	if(sync!=undefined)bl=sync;
	combolink(selects,sqls,i,bl);
}
function getRollUp(groupbyPart) {
	return "rollup(" + groupbyPart + ")";
}
function setupEvents() {
		catchEvent(document.getElementById("channel_code"),"blur",checkBlur);
		catchEvent(document.getElementById("channel_code"),"focus",checkFocus);	
}
	function dealNull(val,val2) {return "value(" + val + ",'" + val2 + "')"}
	Ext.onReady(function(){
		Ext.BLANK_IMAGE_URL = '../js/ext3/resources/images/default/s.gif';
	});
	catchEvent(window,"load",setupEvents);
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
							<%=bass.common.QueryTools2.getCountyHtml("country","")%>
						</td>
					</tr>
					<tr  class="dim_row">
						<td class="dim_cell_title">��������</td>
						<td class="dim_cell_content" colspan="5">
							<input type="text" id="channel_code" name="channel_code" value="֧��ģ����ѯ" style="color:gray; font-style: italic;"/>
						</td>
					</tr>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="Ԥ����������" onclick="window.open('alertmodify.jsp','Ԥ����������','width=800,height=600,status=yes,resizable=yes,menubar=no,toolbar=no')">&nbsp;
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
				 <tr class="grid_title_blue">
				 	<td class='grid_title_cell'>ָ������</td>
				 	<td class='grid_title_cell'>���²���</td>
					<td class='grid_title_cell'>���²���</td>
					<td class='grid_title_cell'>Ԥ������</td>
					<td class='grid_title_cell'>Ԥ����������</td>
					<td class='grid_title_cell'>δ��λԤ����������</td>
					<td class='grid_title_cell'>��λ��</td>
				 	<%-- old one
				 	<td class='grid_title_cell'>���������������</td>
				 	<td class='grid_title_cell'>�����ھ�������<br>������������</td>
				 	<td class='grid_title_cell'>�����ն���<br>����������</td>
				 	<td class='grid_title_cell'>��������<br>�벨��</td>
				 	<td class='grid_title_cell'>�����ͻ�<br>������</td>
				 	<td class='grid_title_cell'>�����ͻ�<br>������</td>
				 	<td class='grid_title_cell'>�Ʒѿͻ�<br>������</td>
				 	<td class='grid_title_cell'>ҵ��������(��<br>�����ɷ�)����</td>
				 	<td class='grid_title_cell'>�����<br>����</td>
				 	<td class='grid_title_cell'>������<br>����</td>
				 	<td class='grid_title_cell'>��RPU�ͻ�<br>ռ�Ȳ���</td>
				 	<td class='grid_title_cell'>�߶�Ƿ�ѿ�<br>��������</td>
				 	<td class='grid_title_cell'>�����ն˲�<br>���ʲ���</td>
				 	<td class='grid_title_cell'>�ͻ�Ͷ��<br>������</td>
				 	<td class='grid_title_cell'>�������<br>��������</td>
				 	<td class='grid_title_cell'>�ͼ�ֵ�ͻ�<br>ռ�Ȳ���</td>
				 	<td class='grid_title_cell'>��������<br>��������</td>
				 	<td class='grid_title_cell'>Ӧ����<br>�𲨶�</td>
				 	--%>
				 </tr>
			</table>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>
