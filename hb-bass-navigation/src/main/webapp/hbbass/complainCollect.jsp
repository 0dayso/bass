<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="java.util.Calendar"%>
<%@page import="bass.common.QueryTools2"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bass.common.QueryTools3"%>
<%-- 
	copied from keyBusiReport.jsp
	����ı�:��ĸ����
--%>
<%
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH,-1);//����
	DateFormat formater = new SimpleDateFormat("yyyyMMdd");
	String day1 = formater.format(cal.getTime());
	//�ı���ҵ���߼�����������ʹ��ͬһ�����ڣ�Ĭ������
%>
<html>
	<HEAD> 
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>�ͻ�Ͷ�߻��ܱ���</title>
		<script type="text/javascript" src="/hbbass/common2/basscommon.js"	charset=utf-8></script>
		<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
		<script type="text/javascript" src="../js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript" src="../ngbass/js/common.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
<script type="text/javascript">
	var titleMap = new Array();
		titleMap["user_area_id"] = "����";
		titleMap["item_name_lev1"] = "Ͷ������һ��";
		titleMap["item_name_lev2"] = "Ͷ�����Ͷ���";
		titleMap["item_name_lev3"] = "Ͷ����������";
	var sample = "<td class='grid_title_cell'>@area@</td>"
	var condition;
	var outerCond = " 1=1 ";
	var tableTime = "";
	function doSubmit(sortNum)
	{	
		outerCond = " 1=1 ";
		var groupByPart = "";
		//var isEmpty = true;
		var highestLevel = "'HB'";//д��
		var _table;
		isEmpty = true;
		var titleDiv = titleDiv = "<table id='resultTable' align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>"
			 	+"<tr class='grid_title_blue'>"
		
		with(document.forms[0]) {
			startDate = date1.value;
			endDate = date2.value;
			cityId = city.value;
			for(var i = 0 ; i < display.length ; i ++) {
				if(display[i].checked) {
					groupByPart += display[i].value  + ",";
					isEmpty = false;
				}
			}
			if(isEmpty) {
				alert("������Ҫѡ��һ��չ�֡�");
				return;
			}
			
			if(startDate > endDate) {
				alert("��ʼ���ڲ��ܴ��ڽ�ֹ���ڡ�");
				return;
			}
			if(startDate.substr(4,2)!= endDate.substr(4,2)) {
				alert("�ݲ�֧�ֿ��²�ѯ��������ѡ�����ڡ�");
				return;
			}
			tableTime = startDate.substr(0,6);
			/* ������������ */
			condition = " etl_cycle_id>="  + startDate + " and etl_cycle_id<=" + endDate;
			
			
			if(level3.value)
				outerCond += " and ITEM_ID_LEV3='" + level3.value + "'";
			else if(level2.value)
				outerCond += " and ITEM_ID_LEV2='" + level2.value + "'";
			else if(level1.value)
				outerCond += " and ITEM_ID_LEV1='" + level1.value + "'";
			//Ƕ����Ҫ��Ϊ�˰�nullת��HB.WH,ͬʱ��where����ɸѡ������ֻ���Ҫ���ֶ�
			
			
			if(brand.value!=""){
				outerCond += " and brand_id  in (" + brand.value + ")";
			}
			
			if(Partner_type.value!=""){
				outerCond += " and Partner_type = '" + Partner_type.value + "'";
			}
			
			if(Foreigner_flag.value!=""){
				outerCond += " and Foreigner_flag = " + Foreigner_flag.value ;
			}
			
			if(county.value!=""){
				outerCond += " and user_area_id = '" + county.value + "'";
			}else{
				var areaCond = cityId == "0" ? "" : " and user_area_id='" + cityId + "'";
				//��condition�з����areaCond
				condition += areaCond;
				
			}
			_table = "(select value(substr(user_channel_code,1,8),'HB.WH.01')user_area_id,complain_num,Foreigner_flag,Partner_type,brand_id,acc_nbr,complain_type from NMK.COMPLAIN_RECEIVE_" + tableTime + " where " + condition +
			" ) a left outer join nmk.vdim_complain_type b on a.complain_type =  b.item_id_lev3 ";
		}
		//var queryType = "lev1";
		groupByPart = groupByPart.replace(/,$/,""); //����ͨ��
			var keys = groupByPart.split(",");//û��,�����ַ�������
			for(indx in keys) {
				titleDiv += sample.replace("@area@",titleMap[keys[indx]]);
			}
			/* ��ʽ 
				7 : max probable Length of this program
			*/
			for(var i = 0; i < 8; i ++) {
				if(i < keys.length) {
					cellclass[i]="grid_row_cell_text";
					cellfunc[i] = undefined;
				} else {
					cellclass[i]="grid_row_cell_number";
					cellfunc[i] = numberFormatDigit2;
				}
				if(i==(keys.length+1) || i == (keys.length + 3))
					cellfunc[i] = percentFormat;
			}
			//��β			
		titleDiv += "<td class='grid_title_cell'>Ͷ������</td>"
				+ "<td class='grid_title_cell'>Ͷ������ռ��</td>"
				+ "<td class='grid_title_cell'>Ͷ�ߴ���</td>"
				+ "<td class='grid_title_cell'>Ͷ�ߴ���ռ��</td>";	
				+ "</tr></table>";
		
		var sql = "with temp as (" + 
					" select " + highestLevel + " area,count(distinct acc_nbr)total_counts,sum(complain_num)total_times " + 
					//" from " + _table.replace(" where " + condition,"") + //������_table,������Ҫwhere����
					" from " + _table.replace(areaCond,"") + //ȥ����������
					//������Ϊֻ��ʱ������" where " + outerCond +//added
					" group by " + highestLevel + 
					")";//���ȫʡ���������е���Ͷ������count1,�ʹ���count2,null�����人
		var	totalCounts = "(select temp.total_counts from temp where area='HB')";//Ͷ������
		var totalTimes = "(select temp.total_times from temp where area='HB')";//Ͷ�ߴ���
		var constantPart = ", count(distinct acc_nbr)" + //Ͷ������ 
		",case when " + totalCounts + "=0 then 0 else decimal(count(distinct acc_nbr),16,2)/" + totalCounts + " end " + //������Ͷ������
		",sum(complain_num)" + //Ͷ�ߴ���
		",case when " + totalTimes + "=0 then 0 else decimal(sum(complain_num),16,2)/" + totalTimes + " end ";
		
		if(cityId == "0"){
			areaName=groupByPart.replace("user_area_id","(select area_name from mk.bt_area where area_code=substr(user_area_id,1,5))");
			groupByPart=groupByPart.replace("user_area_id","substr(user_area_id,1,5)");
		}else
			areaName=groupByPart.replace("user_area_id","(select county_name from MK.BT_AREA_all where county_code=user_area_id)");

		
		sql += " select " + areaName + constantPart +  
				  " from " + _table + 
				  " where " + outerCond + 
				  " group by " + groupByPart ;
		document.form1.sql.value = sql;
		document.getElementById("title_div").innerHTML = titleDiv;
		ajaxSubmitWrapper(sql + " with ur");
	}
	
	function complaincombo(i,sync){		
		selects = new Array();
		selects.push(document.forms[0].level1);
		sqls = new Array();
		if(document.forms[0].level2 != undefined)
		{
			selects.push(document.forms[0].level2);
			sqls.push("select distinct item_id_lev2,replace(item_name_lev2,item_name_lev1,'') from nmk.vdim_complain_type where item_id_lev1='#{value}' order by 1 with ur");
		}
		
		if(document.forms[0].level3!= undefined)
		{
			selects.push(document.forms[0].level3);
			sqls.push("select distinct item_id_lev3,replace(item_name_lev3,item_name_lev2,'') from nmk.vdim_complain_type where item_id_lev2='#{value}' order by 1 with ur");
		}
		var bl = false;
		if(sync!=undefined)bl=sync;
		combolink(selects,sqls,i,bl);
	}
	function toXls() {
		if(!condition) {
			alert("���Ȳ�ѯ�������嵥��");
			return;
		}
		if(document.getElementById("maxCt")) {
			if(document.getElementById("maxCt").innerHTML == 0) {
				alert("û�в�ѯ�����û����Ӧ���嵥���ء�");
				return;
			}
		}
		var sql = " select ACC_NBR,(select area_name from mk.bt_area where area_code=user_area_id),case when BRAND_ID in (1,2,3) then 'ȫ��ͨ' when BRAND_ID in (4,5,6,7) or brand_id is null then '������' when BRAND_ID=8 then '���еش�' else '����' end,ITEM_NAME_LEV3,ETL_CYCLE_ID ,c.rowname , replace(COMPLAIN_DESC,',','��'),COMPLAIN_NUM "
   		+ " from NMK.COMPLAIN_RECEIVE_" + tableTime + " a, nmk.vdim_complain_type b,NWH.VDIM_TIME_LEV c "
  		+ " where a.complain_type =  b.item_id_lev3 and a.complain_time_lev = c.rowid and " + condition + " and " + outerCond;
		document.forms[1].sql.value = sql;
		document.forms[1].filename.value = document.title;
		document.forms[1].title.value = ["�û�����","����","Ʒ��","Ͷ������","Ͷ������","Ͷ��ʱ��","Ͷ������","Ͷ�ߴ���"];//��δ��
		document.forms[1].action = "/hbbass/common2/commonDown.jsp";
		document.forms[1].target = "_top";
		document.forms[1].submit();
	}  

 </script>
	<HEAD>
	<body>
		<form name="form1" method="post" action="">
			<div id="hidden_div">
				<input type="hidden" id="allPageNum" name="allPageNum" value="">
				<input type="hidden" id="sql" name="sql" value="">
				<input type="hidden" name="filename" value="">
				<input type="hidden" name="order" value="">
				<input type="hidden" name="title" value="">
			</div>
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onClick="hideTitle(this.childNodes[0],'dim_div')"
									title="�������">
									<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>
									&nbsp;��ѯ��������
								</td>
							</tr>
						</table>
					</legend>
					<div id="dim_div">
						<table align="center" width="99%" class="grid-tab-blue"
							cellspacing="1" cellpadding="0" border="0">
								<tr class="dim_row">
								<td class="dim_cell_title" align="left">&nbsp;��ʼ����(>=)</td>
								<td class="dim_cell_content">
									<input type="text" value='<%=day1 %>' id="date1" name="date1" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate"/>
							 	</td>
							 	
							 	<td class="dim_cell_title" align="left">&nbsp;��������(<=)</td>
								<td class="dim_cell_content">
									<input type="text" value='<%=day1 %>' id="date2" name="date2" onfocus="WdatePicker({readOnly:true,dateFmt:'yyyyMMdd'})" class="Wdate"/>
							 	</td>
							 	
							 	<td class="dim_cell_title">&nbsp;����</td>
				 				<td class="dim_cell_content" ><%=QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"areacombo(1)")%></td>
								</tr>
								<tr class="dim_row">
									<td class="dim_cell_title" title="���ݸ�ѡ��,ȷ��չ����Щγ��,Ĭ��ѡ�����">&nbsp;ά��ѡ��</td>
									<td class="dim_cell_content" colspan="3">
										����<input checked="checked" type="checkbox" value="user_area_id" name="display" />
										Ͷ������һ��<input type="checkbox" value="item_name_lev1" name="display" />
										Ͷ�����Ͷ���<input type="checkbox" value="item_name_lev2" name="display" />
										Ͷ����������<input type="checkbox" value="item_name_lev3" name="display" />
									</td>
									<td class="dim_cell_title">&nbsp;����</td>
				 					<td class="dim_cell_content" ><%=QueryTools2.getCountyHtml("county","")%></td>
								</tr>
								<tr class="dim_row">
									<td class="dim_cell_title">&nbsp;Ͷ��ҵ������һ��</td>
									<td class="dim_cell_content">
										<select name="level1" onchange="complaincombo(1)">
											<option value="">ȫ��</option>
										</select>
										<script type="text/javascript" defer="defer">
											renderSelect("select distinct item_id_lev1,item_name_lev1 from nmk.vdim_complain_type ",document.forms[0].level1.value,document.forms[0].level1,undefined,undefined);
										</script>
									</td>
									
									<td class="dim_cell_title">&nbsp;Ͷ��ҵ�����Ͷ���</td>
									<td class="dim_cell_content">
										<select name="level2" onchange="complaincombo(2)">
											<option value="">ȫ��</option>
										</select>
										<script type="text/javascript" defer="defer">
											complaincombo(2);
										</script>
									</td>
									
									<td class="dim_cell_title">&nbsp;Ͷ��ҵ����������</td>
									<td class="dim_cell_content">
										<select name="level3">
											<option value="">ȫ��</option>
										</select>
									</td>
									
								</tr>
								<tr class="dim_row">
									<td class="dim_cell_title">Ʒ��</td>
									<td class="dim_cell_content"><%=QueryTools3.getStaticHTMLSelect("brand","")%></td>
									<td class="dim_cell_title">��Ӫ��</td>
									<td class="dim_cell_content"><span name="Partner_type"><select name="Partner_type" class='form_select'><option value="">ȫ��</option><option value="yd">�ƶ�</option><option value="dx">����</option><option value="lt">��ͨ</option></select></span></td>
									<td class="dim_cell_title">��������</td>
									<td class="dim_cell_content"><span name="Foreigner_flag"><select name="Foreigner_flag" class='form_select'><option value="">ȫ��</option><option value="0">��ʡ</option><option value="1">��ʡ</option></select></span></td>
								</tr>
							</table>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="��ѯ"
										onClick="doSubmit()">
									&nbsp;
									<input type="button" class="form_button" value="����"
										onclick="toDown()">
									&nbsp;
									
									<input type="button" class="form_button" value="ͼ�η���" onClick="tabAdd({id : 'complainCollect',title : 'ͼ�η���',url : 'http://10.25.124.114:8080/hbbass/ngbass/analyMain.jsp?pid=275&reportname=�ͻ�Ͷ�߻��ܷ���'})">
									<input type="button" class="form_button" value="�嵥����"
										onClick="toXls()">
									&nbsp;
								</td>
							</tr>
						</table>
					</div>
				</fieldset>
			</div>
			<br>
			<div class="divinnerfieldset">
				<fieldset>
					<legend>
						<table>
							<tr>
								<td onClick="hideTitle(this.childNodes[0],'show_div')"
									title="�������">
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
			<div id="tempSql"></div>
			<div id="title_div" style="display:none;">
			</div>
		</form>
		<form name="form2" method="post" action="">
			<div id="hidden_div2">
				<input type="hidden" id="sql" name="sql" value="">
				<input type="hidden" name="filename" value="">
				<input type="hidden" name="title" value="">
			</div>
		</form>
		<%@ include file="/hbbass/common2/loadmask.htm"%>
		</body>
</html>
