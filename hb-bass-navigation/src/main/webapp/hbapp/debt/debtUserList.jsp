<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools3" %>
<%@page import="java.util.Calendar"%>
<%@page import="bass.common.QueryTools2"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<title>�߶�Ƿ���û����</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<script type="text/javascript" src="../common2/basscommon.js" charset=utf-8></script>
<script type="text/javascript" src="../js/datepicker/WdatePicker.js"></script>
<script type="text/javascript" src="default.js" charset=utf-8></script>
<link rel="stylesheet" type="text/css" href="../css/bass21.css" /> 
<link rel="stylesheet" type="text/css" href="../css/com.css" />  

</head>
 <script type="text/javascript">
 	cellclass[0]="grid_row_cell_text";
 	cellclass[1]="grid_row_cell_text";
 	cellclass[2]="grid_row_cell_text";
 	cellclass[3]="grid_row_cell_text";
 	cellclass[4]="grid_row_cell_text";
 	cellclass[5]="grid_row_cell_text";
  cellclass[6]="grid_row_cell_text";
  cellclass[7]="grid_row_cell_number";
  cellclass[8]="grid_row_cell_number";
  cellclass[9]="grid_row_cell_number";
  cellclass[10]="grid_row_cell_number";
  cellclass[11]="grid_row_cell_number";
  cellclass[12]="grid_row_cell_number";
  cellclass[13]="grid_row_cell_number"; 
  cellclass[14]="grid_row_cell_number";
  cellclass[15]="grid_row_cell_number";
  cellclass[16]="grid_row_cell_text"; 
  cellclass[17]="grid_row_cell_text";
  cellclass[18]="grid_row_cell_text";
	pagenum=20;
 
 
 function doSubmit()
{	
	
		var sql=" ";
		var condition="";
		if(document.forms[0].city.value!="0")
		   condition+=" and area_id= '"+document.forms[0].city.value+"'";    
		if(document.forms[0].time_id.value!="0")
		   condition+=" and time_id= "+document.forms[0].time_id.value;   
		if(document.forms[0].fazhi.value!="0")
		   condition+=" and "+document.forms[0].fazhi.value;   
		   
		var sortcol=document.forms[0].sortcol.value;
		sql=" select ACC_NBR, CUST_NAME,  AREA_NAME, CHANNEL_CODE,CHANNEL_NAME, EFF_DATE, MCUST_NAME, MCUST_LID,   "+
		    " BILL_CHARGE, YZ_CHARGE,DX_CHARGE, YY_CHARGE,ZZ_CHARGE,DATA_OPER_CHARGE,ACT_BILL, CREDIT_CHARGE,STATE_NAME, STATE_TID, EXP_DATE "+
		    " from NMK.ACCT_BOOK_LIST_BILLCHARGE200 where 1=1  "+condition;


		document.forms[0].sql.value = sql;
		document.getElementById("sqldiv").innerText=sql;
		
	  var countSql ="select count(*) from ("+sql+") as t with ur";
	  ajaxSubmitWrapper(sql+" fetch first "+fetchRows+" rows only with ur",countSql);
}		
 
function sortThis(colid)
{
document.forms[0].sortcol.value=colid;
doSubmit();
}
 </script>
 <style type="text/css">
<!--
#title_div {
	position:absolute;
	left:234px;
	top:170px;
	width:543px;
	height:331px;
	z-index:1;
	background-image:url(/hbbass/images/plan/3.gif)
}
-->
</style>
 <%
	// session.setAttribute("area_id","0");
 %>
 <body>
  <form action="" method="post">
	  <div id="hidden_div">
			<input type="hidden" id="allPageNum" name="allPageNum" value="">
			<input type="hidden" id="sql" name="sql" value="">
			<input type="hidden" name="filename" value="">
			<input type="hidden" name="order"  value="">
			<input type="hidden" name="title" value="">
			<input type="hidden" name="colnum" value="15">
			<input type="hidden" name="sortcol" value="2">
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
			<!-- ��ѯ��������ʼ -->
	    <div id="dim_div">
				<table align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="dim_row">
						<td class="dim_cell_title" align="right">ʱ��</td>
						<td class="dim_cell_content"><%=QueryTools3.getDateYMDHtml("time_id",1,false)%>
						</td>
					  <td class="dim_cell_title" align="right">����</td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"")%>
						</td>
						 <td class="dim_cell_title" align="right">Ƿ�ѷ�ֵ</td>
						<td class="dim_cell_content">
							 <select name="fazhi">
							 	<option value="bill_charge>=200">>=200</option>
							 	<option value="bill_charge>=300">>=300</option>
							 	<option value="bill_charge>=400">>=400</option>
							 	<option value="bill_charge>=500">>=500</option>
							 	<option value="bill_charge>=600">>=600</option>
							 	<option value="bill_charge>=700">>=700</option>
							 	<option value="bill_charge>=800">>=800</option>
							 	<option value="bill_charge>=900">>=900</option>
							 	<option value="bill_charge>=1000">>=1000</option>
							</select>
						</td>
						<td align="right" class="dim_cell_content">
							<input type="button" class="form_button" value="��ѯ" onClick="doSubmit()">&nbsp;
							<input type="button" class="form_button" value="����" onclick="toDown()">&nbsp;
						</td>
						<td align="right" class="dim_cell_content">&nbsp;</td>
				  </tr>
					
				</table>
			</div>
			<!-- ��ѯ����������� -->
		</fieldset>
	</div>

	<div class="divinnerfieldset">
			<fieldset>
				<legend>
					<table>
						<tr>
							<td onClick="hideTitle(this.childNodes[0],'show_div')" title="�������">
								<img flag='1' src="/hbbass/common2/image/ns-expand.gif"></img>&nbsp;����չ������
							</td>
							<td></td>
						</tr>
					</table>
				</legend>
				<div id="show_div">
				<%-- �˴��п�����ʾ�п������أ���ȫȡ����fecth first n rows ��n��ֵ --%>
					<div id="showSum"></div>
					<div id="showResult"></div>
				</div>
			</fieldset>
		</div>
		<br>
		<div id="title_div" style="display:none;">
			<table id="resultTable" align="center" width="140%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				      <td class="grid_title_cell">�ֻ���</td>
					    <td class="grid_title_cell">�û���</td>
					    <td class="grid_title_cell">����</td>
					    <td class="grid_title_cell">������������</td>
					    <td class="grid_title_cell">������������</td>
					    <td class="grid_title_cell">����ʱ��</td>
					    <td class="grid_title_cell">�û�VIP<br>����</td>
					    <td class="grid_title_cell">�û�VIP<br>���ͱ�ʶ</td>
					    <td class="grid_title_cell">�û�������<br>�Ƴ�������</td>
					    <td class="grid_title_cell">����:����<br>��������</td>
					    <td class="grid_title_cell">����:����<br>��������</td>
					    <td class="grid_title_cell">����:����<br>��������</td>
					    <td class="grid_title_cell">����:������<br>ֵҵ������</td>
					    <td class="grid_title_cell">����:������<br>��ҵ������</td>
					    <td class="grid_title_cell">�ۼ���<br>�����</td>
					    <td class="grid_title_cell">���ö�</td>
					    <td class="grid_title_cell">�û�״̬</td>   
					    <td class="grid_title_cell">�û�״<br>̬��ʶ</td> 
					    <td class="grid_title_cell">�û�״̬<br>���ʱ��</td>   
					  </tr>
			</table> 
		</div>	
		<div id="sqldiv" style="display:none"></div>		
	</form>
	 <%@ include file="/hbbass/common2/loadmask.htm"%>
  </body>
</html>  
<script>
document.forms[0].time_id.style.width=80;
document.forms[0].city.style.width=80;
</script>