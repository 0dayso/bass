<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="org.apache.log4j.Logger"%>
<jsp:useBean id="NgbassTools" scope="application" class="bass.common.NgbassTools"/> 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  <%-- 
  	copied from channelInfo.jsp
  	ò�ƺ�̨��ṹ���޸ģ�country_id�����ĸĳ�Ӣ����
  --%>
    <title>���������ֵ����ģ��</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/report/financing/dim_conf.js" charset=utf-8></script>
	<script type="text/javascript" src="js/common.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="../css/bass21.css" />
 	<link rel="stylesheet" type="text/css" href="../js/ext3/resources/css/ext-all.css"/>
 	<script type="text/javascript" src="../js/ext3/adapter/ext/ext-base.js"></script>
  	<script type="text/javascript" src="../js/ext3/ext-all.js"></script>
  	<%-- added--%>
  	<style type="text/css">
 		#massage_box{ position:absolute;  left:expression((body.clientWidth-550)/2); top:expression((body.clientHeight-300)/2); width:550px; height:550px;filter:dropshadow(color=#B0D7EC,offx=2,offy=2,positive=2); z-index:2; visibility:hidden;filter:alpha(opacity=80)}
 		#mask{ position:absolute; top:0; left:0; width:expression(body.clientWidth); height:expression(body.clientHeight); background:#ccc; filter:ALPHA(opacity=30); z-index:1; visibility:hidden}
 		.massage{border:#D9ECF6 solid; border-width:1 1 2 1; width:95%; height:95%; background:#fff; color:#036; font-size:12px; line-height:150%}
		.header{background:#A8D2EA; height:20px; font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px; padding:3 5 0 5; color:#000}
 	</style>
  </head>  
  
 <%!
 	private static Logger log = Logger.getLogger("ngbasstool");
 %> 
 <script type="text/javascript">
	cellclass[0]="grid_row_cell_text";
	cellclass[1]="grid_row_cell_text";
	cellclass[2]="grid_row_cell_number";
	cellclass[3]="grid_row_cell_number";
	cellclass[4]="grid_row_cell_number";
	cellclass[5]="grid_row_cell_number";
	cellclass[6]="grid_row_cell_number";
	cellclass[7]="grid_row_cell_number";
	cellclass[8]="grid_row_cell_number";
	cellclass[9]="grid_row_cell_number";
	cellclass[10]="grid_row_cell_number";
	cellclass[11]="grid_row_cell_number";
	cellclass[12]="grid_row_cell_number";
	cellclass[13]="grid_row_cell_number";
	cellclass[14]="grid_row_cell_number";
	cellclass[15]="grid_row_cell_number";
	//cellclass[16]="grid_row_cell_text";
	//16 ��
	cellfunc[3] = percentFormat;
	cellfunc[4] = percentFormat;
	cellfunc[5] = percentFormat;
	cellfunc[6] = percentFormat;
	cellfunc[7] = percentFormat;
	cellfunc[8] = percentFormat;
	cellfunc[11] = numberFormatDigit2;//�����ն����� 12 �� 11
	//cellfunc[2] = numberFormatDigit2;
	//cellfunc[3] = numberFormatDigit2;
	cellfunc[16]= function(datas,options){
	//����case when�Ĺ���
		switch(datas[options.seq]) {
			case '1':return 'һ�Ǽ�';break;
			case '2':return '���Ǽ�';break;
			case '3':return '���Ǽ�';break;
			case '4':return '���Ǽ�';break;
			//case '5':return '���Ǽ�';break;
			default :return '����';break;
		}
	}
	cellfunc[17]= function(datas,options){//18��17,��Ϊ����һ��
	//���ʣ�o_channel_levelӦ�����Ҵӱ���ai_sum�ж�����'�����Ǽ�'(a.channel_level)���Ǵ��ҵ���ʷ���ж������޸�ǰ��ֵ
	//���ʣ���Ч���ڴ�������
		//added for beauty
		if(datas[options.seq]) {
			//ǰ�����м�¼,Ҳ����˵�Ǽ��Ѿ�������,����ֻ��������
			switch(datas[options.seq]) {
			case '1':datas[options.seq]='һ�Ǽ�';break;
			case '2':datas[options.seq]='���Ǽ�';break;
			case '3':datas[options.seq]='���Ǽ�';break;
			case '4':datas[options.seq]='���Ǽ�';break;
			default :datas[options.seq]='����';break;
			}
		}
			
		///added for beauty
		return datas[options.seq] ? "<a title='����޸�' href='#' onclick=window.open('modelmodify.jsp?oper=modify&channel_code=" + datas[0] + "&o_channellevel=" +datas[options.seq - 1] + "','modelmodify','width=800,height=600,status=no,resizable=yes,menubar=no,toolbar=no')>" + datas[options.seq] + "</a>" : "<a href='#' title='�����������' onclick=window.open('modelmodify.jsp?oper=add&channel_code=" + datas[0] + "&o_channellevel=" +datas[options.seq - 1] + "','modelmodify','width=800,height=600,status=no,resizable=yes,menubar=no,toolbar=no')>δ����</a>";
		//return datas[options.seq] ? "<a title='����޸�' href='#' onclick='window.open(\'modelmodify.jsp?\',\'test page\',\'width=800,height=600,status=no,resizable=yes,menubar=no,toolbar=no\')'>" + datas[options.seq] + "</a>" : "<a href='#' title='�����������' onclick='window.open(\'modelmodify.jsp\',\'test add page\',\'width=800,height=600,status=no,resizable=yes,menubar=no,toolbar=no\')'>����</a>";
	}; 
	function doSubmit()
	{	
		var condition = " where a.channel_code = o.channel_code ";
		var op_time,area_id,county_id,tableName,sql,_viewType,constantPart,titleDiv;
		with(document.forms[0]) {
			area_id = city.value;
			county_id = county.value;//����,��ע��
			op_time = date.value;
			tableName = "nmk.ai_channel_sum_" + op_time + " a , " + "nmk.channel_sum_" + op_time + " o ";  
			condition += (channel_name.value && channel_name.value != '֧��ģ����ѯ') ? " and a.channel_name like '%" + channel_name.value + "%'" : "";
		}
		constantPart = " a.channel_code,a.channel_name," + 
		"a.fh_num, case when o.dd_num=0 then 0 else o.harup_num/o.dd_num end ," + 
		"case when o.dd_num=0 then 0 else o.larup_num/o.dd_num end," + 
		" case when o.xz_num=0 then 0 else o.xz_lw_num/o.xz_num end," + 
		"case when o.dd_num=0 then 0 else o.crw_num/o.dd_num end," + 
		"case when o.bill_charge=0 then 0 else (o.zz_charge + o.data_charge)/o.bill_charge end," + 
		" case when o.dd_num=0 then 0 else o.debt_num/o.dd_num end ," + 
		//" a.terminal_num,case when o.disbind_times=0 then 0 else a.terminal_num/o.disbind_times end," + 
		" a.terminal_num," + //���ζ����ն˲����
		" a.rec_times, a.Payment_charge/1000.00, a.khfz_score, a.xyw_score," + 
		//" a.zd_score, a.khfw_score, a.score, a.channel_level ";//before moving
	    " a.zd_score, a.khfw_score, " + 
	    //��������������������������֮�󴫹�ȥ��ԭ�����Ǽ����Ǻ��֣����� "case when a.channel_level=1 then 'һ�Ǽ�' when a.channel_level=2 then '���Ǽ�' when a.channel_level=3 then '���Ǽ�' when a.channel_level=4 then '���Ǽ�' when a.channel_level=5 then '���Ǽ�' else '����' end,(select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=a.channel_code order by number desc fetch first 1 rows only) ";//after moving
	   /*before modified because :
	   ���޸���־����û��������¼���Ǻܣ���ȡchannel_sum��ġ�����У���ȡ��־���У�number���ģ��Ǽ� by ��Ө
	   "a.channel_level,(select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=a.channel_code order by number desc fetch first 1 rows only) ";//after moving
	    */
	    /*after modified
	    �޸�֮��������Ч����Ӧ������д,�������Ĵ��ۻ�������ģ����޸���channel_sum_hist��channel_level������
	    */
	    // modify for the n th th time : ��һ����Ҫ�Ļ�ȥ��ֻ����ͼ��������ʷ����Ϊ�ǵ����Ǽ� "case when (select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=a.channel_code order by number desc fetch first 1 rows only) is null then a.channel_level else (select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=a.channel_code order by number desc fetch first 1 rows only) end," + 
	   	//after modify
	   	"a.channel_level," +
	    "(select h.channel_level from nmk.ai_channel_sum_hist h where h.channel_code=a.channel_code order by number desc fetch first 1 rows only) ";//after moving
	    condition += (county_id == '' ? (area_id == '0' ? "" : " and a.city_id = '" + area_id + "'") : " and a.country_id = '" + county_id + "'");
		//condition += " and a.channel_code = 'HB.HS.01.16.01.03'";//test
		//condition += " and a.channel_name like '%��ɽ��%'";//test
		//alert("condition : " + condition);
		//test
		
		sql = "select " + constantPart + " from " + tableName + condition;
		var countSql ="select count(*) from " + tableName + condition;
		document.forms[0].sql.value = sql;
	 	//alert("sql : " + sql);
	 	ajaxSubmitWrapper(sql+" fetch first 1000 rows only with ur",countSql);
	}
	function setupEvents() {
		catchEvent(document.getElementById("channel_name"),"blur",checkBlur);
		catchEvent(document.getElementById("channel_name"),"focus",checkFocus);	
	}
	catchEvent(window,"load",setupEvents);

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

	
	function dimDisplay() {
		window.open("levelmodify.jsp","����������λ���","width=800,height=600,status=yes,resizable=yes,menubar=yes,toolbar=yes");
	}
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
						<td class="dim_cell_content" colspan="5">
							<input type="text" id="channel_name" name="channel_name" value="֧��ģ����ѯ" style="color:gray; font-style: italic;"/>
						</td>
				</table>
				
				<table align="center" width="99%">
					<tr class="dim_row_submit">
						<td align="right">
							<input type="button" class="form_button" value="����ֵ���ѯ" onclick="dimDisplay()">&nbsp;
							<input type="button" class="form_button" value="��ѯ" onclick="doSubmit()">&nbsp;
							<input type="button" class="form_button" value="����" onclick="toDown(2)">&nbsp;
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
			<table id="resultTable" align="center" width="125%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				<%-- 
				 <tr class="grid_title_blue">
				 		<td class='grid_title_cell' colspan="11">����Ҫ��</td>
				 		<td class='grid_title_cell' colspan="7">���Ҫ��</td>
				 </tr>
				 --%>
				 <tr class="grid_title_blue">
				 <td class='grid_title_cell' rowspan="2">����ID</td>
				 <td class='grid_title_cell' rowspan="2">��������</td>
				 		
				 		<td class='grid_title_cell' colspan="8">ҵ��չ</td><%-- ���ζ����ն˺� 9 �ĳ�8 --%>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">ҵ��չ</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">ҵ��չ</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">ҵ��չ</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">ҵ��չ</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">ҵ��չ</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">ҵ��չ</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="8">ҵ��չ</td>
				 		<td class='grid_title_cell' colspan="2" >�ͻ�������</td>
				 		<td style="display:none;" class='grid_title_cell' colspan="2" >�ͻ�������</td>
				 		 
				 	 <td class='grid_title_cell' colspan="4">����������</td>
				 	  <td style="display:none;" class='grid_title_cell' colspan="4">����������</td>
				 	   <td style="display:none;" class='grid_title_cell' colspan="4">����������</td>
				 	    <td style="display:none;" class='grid_title_cell' colspan="4">����������</td>
				 	  <td class='grid_title_cell'>�������·ּ����</td>
				 	   <td class='grid_title_cell'>�����������ķּ����</td>
				 	   <%-- 
				 	    <td class='grid_title_cell' rowspan="2">���������뼶���޸�</td>
				 		--%>
				 </tr>
				  <tr class="grid_title_blue">
				  		<!-- ���벿�� -->
				  		<!-- 
	a.fh_num,
	o.harup_num/o.dd_num,	o.larup_num/o.dd_num,	o.xz_lw_num/o.xz_num,
	o.crw_num/o.dd_num,	(o.zz_charge + o.data_charge)/o.bill_charge,	o.debt_num/o.dd_num,	
	a.terminal_num,	a.terminal_num/o.disbind_times
	a.rec_times,	a.Payment_charge,	a.khfz_score,	
	a.xyw_score,	a.zd_score	a.khfw_score,
	a.score,	a.channel_level
	
				  		 -->
				  		 <td style="display:none;" class='grid_title_cell' rowspan="2">����ID</td>
				 		<td style="display:none;" class='grid_title_cell' rowspan="2">��������</td>
				 		<td class='grid_title_cell'>�����ͻ���</td>
				 		<td class='grid_title_cell'>��ARPU�ͻ�ռ��</td>
				 		<td class='grid_title_cell'>��ARPU�ͻ�ռ��</td>
				 		<td class='grid_title_cell'>�����ͻ�������</td>
				 		<td class='grid_title_cell'>�������ͻ�ռ��</td>
				 		<td class='grid_title_cell'>��ҵ������ռ��</td>
				 		<td class='grid_title_cell'>Ƿ�ѿͻ�ռ��</td>
				 		<td class='grid_title_cell'>�����ն���������</td>
				 		<%-- 
				 		<td class='grid_title_cell'>�����ն˲����</td>
				 		--%>
				 		<td class='grid_title_cell'>ҵ��������</td>
				 		<td class='grid_title_cell' width="6%">�����ɷѽ��</td>
						<!-- ������� -->
						 <td class='grid_title_cell'>�����ͻ���չ�÷�</td>
						 <td class='grid_title_cell'>������ҵ��Ӫ���÷�</td>
						 <td class='grid_title_cell'>���������ն����۵÷�</td>
						 <td class='grid_title_cell'>�����ͻ�����÷�</td>
						  <td class='grid_title_cell'>�����Ǽ�</td>
						 <td class='grid_title_cell'>�������Ǽ�</td><%-- testtemp --%>
						
				 </tr>
			</table>
		</div>			
	</form>
  <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>



