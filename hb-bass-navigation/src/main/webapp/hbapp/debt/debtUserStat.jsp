<%@ page contentType="text/html; charset=gb2312"%>
<%@page import="bass.common.QueryTools3" %>
<%@page import="java.util.Calendar"%>
<%@page import="bass.common.QueryTools2"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<title>�߶�Ƿ�ѷֵ��зֲ���</title>
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
 	cellclass[1]="grid_row_cell_number";
 	cellclass[2]="grid_row_cell_number";
 	cellclass[3]="grid_row_cell_number";
 	cellclass[4]="grid_row_cell_number";
 	cellclass[5]="grid_row_cell_number";
  cellclass[6]="grid_row_cell_number";
  cellclass[7]="grid_row_cell_number";
  cellclass[8]="grid_row_cell_number";
	pagenum=20;
 
 
 function doSubmit()
{	
	
		var sql=" ";
		var condition="";
		if(document.forms[0].city.value!="0")
		   condition+=" and area_id= '"+document.forms[0].city.value+"'";    
		if(document.forms[0].time_id.value!="0")
		   condition+=" and time_id= "+document.forms[0].time_id.value;    
		   
		var sortcol=document.forms[0].sortcol.value;
		sql="select value(area_name,'�ϼ�'),sum(countnum0_50), sum(countnum50_100),sum(countnum100_200), sum(countnum200_300), sum(countnum300_400), "+
		    " sum(countnum400_500),sum(countnum500_1000), sum(countnum1000) from nmk.acct_book_geqf_fc "+
		    " where 1=1 "+condition+" group by rollup(area_name) order by "+ sortcol;


		document.forms[0].sql.value = sql;
		document.getElementById("sqldiv").innerText=sql;
		
	  var countSql ="select count(*) from ("+sql+") as t with ur";
	  ajaxSubmitWrapper(sql,countSql);
}		
 
function sortThis(colid)
{
document.forms[0].sortcol.value=colid;
doSubmit();
}
 </script>
 <%
	//session.setAttribute("area_id","0");
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
				<table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="dim_row">
						<td class="dim_cell_title" align="right">ʱ��</td>
						<td class="dim_cell_content"><%=QueryTools3.getDateYMDHtml("time_id",1,false)%>
						</td>
					  <td class="dim_cell_title" align="right">����</td>
						<td class="dim_cell_content">
							<%=bass.common.QueryTools2.getAreaCodeHtml("city",(String)session.getAttribute("area_id"),"")%>
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
			<table id="resultTable" align="center" width="100%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
				 <tr class="grid_title_blue">
				      <td class="grid_title_cell" width="10%">����</td>
					    <td class="grid_title_cell"><a class="a2"  href="#" onclick="sortThis(2)" title="������˽�������">Ƿ��50Ԫ�����û�</a></td>
					    <td class="grid_title_cell"><a class="a2"  href="#" onclick="sortThis(3)" title="������˽�������">Ƿ��50Ԫ��100Ԫ�û�</a></td>
					    <td class="grid_title_cell"><a class="a2"  href="#" onclick="sortThis(4)" title="������˽�������">Ƿ��100Ԫ��200Ԫ�û�</a></td>
					    <td class="grid_title_cell"><a class="a2"  href="#" onclick="sortThis(5)" title="������˽�������">Ƿ��200Ԫ��300Ԫ�û�</a></td>
					    <td class="grid_title_cell"><a class="a2"  href="#" onclick="sortThis(6)" title="������˽�������">Ƿ��300Ԫ��400Ԫ�û�</a></td>
					    <td class="grid_title_cell"><a class="a2"  href="#" onclick="sortThis(7)" title="������˽�������">Ƿ��400Ԫ��500Ԫ�û�</a></td>
					    <td class="grid_title_cell"><a class="a2"  href="#" onclick="sortThis(8)" title="������˽�������">Ƿ��500Ԫ��1000Ԫ�û�</a></td>
					    <td class="grid_title_cell"><a class="a2"  href="#" onclick="sortThis(9)" title="������˽�������">Ƿ��1000Ԫ�����û�</a></td>
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