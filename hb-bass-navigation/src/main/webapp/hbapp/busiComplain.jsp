<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="java.util.Calendar"%>
<%@page import="bass.common.QueryTools2"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="bass.common.QueryTools3"%>
<%@page deferredSyntaxAllowedAsLiteral="true" %>
<%-- 
	copied from complainCollect.jsp
	����ı�:��ĸ����
	�����Ӹĳ�������
	����: �嵥���ص� Ͷ��ʱ�Ρ��ظ�Ͷ�߱�־ ��ȷ����
		2.���ɵ�excel��ʽ�ܹ֣���ȷ������sql����,��Ӣ�Ķ�������
		3.Ʒ�ƵĴ���
	refer sql :
	select user_area_id,b.item_name_lev1,b.item_name ,sum(complain_num)
  from NMK.COMPLAIN_RECEIVE_200912 a, nmk.vdim_keybusi_complain_type b
  where a.complain_type =  b.item_id
    and a.etl_cycle_id>=20091201 and  a.etl_cycle_id<=20091202
group by  user_area_id,b.item_name_lev1,b.item_name 
--%>
<%
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DAY_OF_MONTH,-1);//ǰ��
	DateFormat formater = new SimpleDateFormat("yyyyMMdd");
	String day1 = formater.format(cal.getTime());
%>
<html>
	<HEAD> 
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<title>�ؼ�ҵ��Ͷ�߻��ܱ�</title>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/old/basscommon.js"	charset=utf-8></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/default.js"	charset=utf-8></script>
		
		<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/bass21.css" />
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/datepicker/WdatePicker.js"></script>
		<script type="text/javascript" src="${mvcPath}/hbapp/resources/js/default/tabext.js"></script>
<script type="text/javascript">
	var titleMap = new Array();
		titleMap["user_area_id"] = "����";
		titleMap["item_name_lev1"] = "Ͷ������һ��";
		titleMap["item_name"] = "Ͷ�����Ͷ���";
	var sample = "<td class='grid_title_cell'>@area@</td>";
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
		
			
			if(level2.value)
				outerCond += " and ITEM_ID='" + level2.value + "'";
			else if(level1.value)
				outerCond += " and ITEM_ID_LEV1='" + level1.value + "'";
			
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
			
			_table = "(select value(substr(user_channel_code,1,8),'HB.WH.01')user_area_id,complain_num,Foreigner_flag,Partner_type,brand_id,acc_nbr,complain_type,again_complain_num from NMK.COMPLAIN_RECEIVE_" + tableTime + " where " + condition +
			" ) a inner join nmk.vdim_keybusi_complain_type b on a.complain_type =  b.item_id ";
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
			for(var i = 0; i < 10; i ++) {
				if(i < keys.length) {
					cellclass[i]="grid_row_cell_text";
					cellfunc[i] = undefined;
				} else {
					cellclass[i]="grid_row_cell_number";
					cellfunc[i] = numberFormatDigit2;
				}
				if(i==(keys.length+1) || i == (keys.length + 3) || i == (keys.length + 5))
					cellfunc[i] = percentFormat;
			}
			//��β			
		titleDiv += "<td class='grid_title_cell'>Ͷ������</td>"
				+ "<td class='grid_title_cell'>Ͷ������ռ��</td>"
				+ "<td class='grid_title_cell'>Ͷ�ߴ���</td>"
				+ "<td class='grid_title_cell'>Ͷ�ߴ���ռ��</td>"
				+ "<td class='grid_title_cell'>�ظ�Ͷ�ߴ���</td>"
				+ "<td class='grid_title_cell'>�ظ�Ͷ�ߴ���ռ��</td>";	
				+ "</tr></table>";
		
		var sql = "with temp as (" + 
					" select " + highestLevel + " area,count(distinct acc_nbr)total_counts,sum(complain_num)total_times,sum(again_complain_num)total_again_times " + 
					" from " + _table.replace(areaCond,"") + //ȥ����������
					" group by " + highestLevel + 
					")";
		var	totalCounts = "(select temp.total_counts from temp where area='HB')";//Ͷ������
		var totalTimes = "(select temp.total_times from temp where area='HB')";//Ͷ�ߴ���
		var	totalAgainTimes = "(select temp.total_again_times from temp where area='HB')";//�ظ�Ͷ�ߴ���
		var constantPart = ", count(distinct acc_nbr)" + //Ͷ������ 
		",case when " + totalCounts + "=0 then 0 else decimal(count(distinct acc_nbr),16,2)/" + totalCounts + " end " + //������Ͷ������
		",sum(complain_num)" + //Ͷ�ߴ���
		",case when " + totalTimes + "=0 then 0 else decimal(sum(complain_num),16,2)/" + totalTimes + " end " + 
		",sum(again_complain_num)" + //�ظ�Ͷ�ߴ���
		",case when " + totalAgainTimes + "=0 then 0 else decimal(sum(again_complain_num),16,2)/" + totalAgainTimes + " end ";
		
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
		//debugger;
		ajaxSubmitWrapper(sql + " with ur");
	}
	function complaincombo(level){	
		var selects = [];
		selects.push(document.forms[0].level1);
		var sqls = [];
		if(document.forms[0].level2 != undefined){
			selects.push(document.forms[0].level2);
			sqls.push("select distinct item_id key,item_name value from nmk.vdim_keybusi_complain_type where item_id_lev1='#{value}' order by 1 with ur");
		}
		
		aihb.FormHelper.comboLink({
			elements : selects
			,datas : sqls
			,level : level
		});
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
		var sql = " select ACC_NBR,(select area_name from mk.bt_area where area_code=user_area_id),case when BRAND_ID in (1,2,3) then 'ȫ��ͨ' when BRAND_ID in (4,5,6,7) or brand_id is null then '������' when BRAND_ID=8 then '���еش�' else '����' end,ITEM_NAME_LEV2,ETL_CYCLE_ID,c.rowname ,replace(COMPLAIN_DESC,',','��'),COMPLAIN_NUM,again_complain_num "
   		+ " from NMK.COMPLAIN_RECEIVE_" + tableTime + " a, nmk.vdim_keybusi_complain_type b ,NWH.VDIM_TIME_LEV c"
  		+ " where a.complain_type =  b.item_id and a.complain_time_lev = c.rowid and " + condition + " and " + outerCond;
		document.forms[1].sql.value = sql;
		document.forms[1].filename.value = document.title;
		document.forms[1].title.value = ["�û�����","����","Ʒ��","Ͷ������","Ͷ������","Ͷ��ʱ��","Ͷ������","Ͷ�ߴ���","�ظ�Ͷ�ߴ���"];
		document.forms[1].action = "${mvcPath}/hbapp/resources/old/commonDown.jsp";
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
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
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
										Ͷ�����ʹ���<input type="checkbox" value="item_name_lev1" name="display" />
										Ͷ������ϸ��<input type="checkbox" value="item_name" name="display" />
									</td>
									<td class="dim_cell_title">&nbsp;����</td>
				 					<td class="dim_cell_content" ><%=QueryTools2.getCountyHtml("county","")%></td>
								</tr>
								<tr class="dim_row">
									<td class="dim_cell_title">&nbsp;Ͷ��ҵ�����ʹ���</td>
									<td class="dim_cell_content">
										<select name="level1" onchange="complaincombo(1)">
											<option value="">ȫ��</option>
										</select>
										<script type="text/javascript" defer="defer">
											renderSelect("select distinct item_id_lev1 key,item_name_lev1 value from nmk.vdim_keybusi_complain_type ",document.forms[0].level1.value,document.forms[0].level1,undefined,undefined);
										</script>
									</td>
									
									<td class="dim_cell_title">&nbsp;Ͷ��ҵ������ϸ��</td>
									<td class="dim_cell_content" colspan="3">
										<select name="level2">
											<option value="">ȫ��</option>
										</select>
										<script type="text/javascript" defer="defer">
											complaincombo(1);
										</script>
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
									
									<input type="button" class="form_button" value="ͼ�η���" onClick="tabAdd({id : 'busiComplain',title : 'ͼ�η���',url : 'http://10.25.124.115:8080/hbbass/ngbass/analyMain.jsp?pid=274&reportname=�ؼ�ҵ��Ͷ�߻��ܷ���'})">
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
									<img flag='1' src="${mvcPath}/hbapp/resources/image/default/ns-expand.gif"></img>
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
		<%@ include file="/hbapp/resources/old/loadmask.htm"%>
		</body>
</html>
