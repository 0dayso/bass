<%@ page contentType="text/html; charset=gb2312"%>
<%@ page import="bass.common.QueryTools2,bass.common.QueryTools3,java.util.Calendar,java.text.SimpleDateFormat,bass.database.report.ReportBean"%>
<%
// �û���¼��ʱ�ж�
String loginname="";
if(session.getAttribute("loginname")==null)
{
  response.sendRedirect("/hbbass/error/loginerror.jsp");
  return;
}
else
{
  loginname=(String)session.getAttribute("loginname");
}	

java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
Calendar cal = Calendar.getInstance();
cal.add(java.util.Calendar.MONTH,-1);
String queryTime = sdf.format(cal.getTime());

%>
<html xmlns:ai>
	<HEAD>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8">
		<TITLE>�Ļ������嵥��ѯ����</TITLE>
		<script type="text/javascript" src="/hbbass/common2/basscommon.js"	charset=utf-8></script>
		<script type="text/javascript" src="/hcr/jscript/calendar/calendar.js"></script>
		<script type="text/javascript" src="dim_conf.js" charset=utf-8></script>
		<script language="javascript" src="combobox.js"></script>
		<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
		<script type="text/javascript">
cellclass[0]="grid_row_cell_text";
cellclass[1]="grid_row_cell_text";
cellclass[2]="grid_row_cell_number";
cellclass[3]="grid_row_cell_text";
cellclass[4]="grid_row_cell_number"
//cellfunc[5]=numberFormatDigit2;
//cellfunc[6]=numberFormatDigit2;
cellclass[5]="grid_row_cell_text";
cellclass[6]="grid_row_cell_number";
cellclass[7]="grid_row_cell_text";
//cellfunc[8]=numberFormatDigit2;
//cellfunc[9]=numberFormatDigit2;
cellclass[8]="grid_row_cell_text";
cellclass[9]="grid_row_cell_text";
cellclass[10]="grid_row_cell_number";
cellclass[11]="grid_row_cell_number";

var arrObj=[];
/*
cellfunc[0]=function(datas,options)
{
	return citycode[datas[options.seq]];	
}
*/
function doSubmit(method)
{
	var heji = false;
	//��ѯ�ֶ�
	var selectfield;
	//�����ֶ�
	var groupfield;
	//�ϼ�SQL
	var unionsql;
	var uniongroup;

	//��ѯʱ��
	var querytime = document.form1.querytime.value;
	querytime = querytime.replace(/\-/g,"");
	var cond = " where time_id = "+querytime;
	//��������
	var city = document.form1.city.value;
	if(city != '0') cond += " and area_code = '"+city+ "'";
	
	var sql = "select AREA_NAME, MOBILE_TYPE, IMEI_ID, SUPPLY_NAME, SERV_NUM, FEE_NAME,INNET_DATE, CARE_OPERA, SL_TYPE, CARE_OPERATOR, REC_ID, TIME_ID from NPD.IMPORT_IMEI ";
	sql += cond;
	var orderby = " order by area_code with ur";
	sql += orderby;
	
	document.form1.sql.value = sql;
	
	ajaxSubmitWrapper(sql);
	//ajaxSubmitWrapper(sql,undefined,true,undefined,'&ds=java:comp/env/jdbc/AiomniMPM');
}
  
function saveExcel()
{
	var sql=document.form1.sql.value;
	sql = encodeURIComponent(sql);
	form1.action="/hbbass/channel/surrogateanalysis/saveExcel.jsp";
	form1.target="_top";
	form1.submit();
}
function help()
{
	var helpwindow=window.open('income_report_help.jsp' ,"helpwindow", "height=480, width=600, left=420, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
	helpwindow.focus();
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
								<td class="dim_cell_title" align="left">
									��ѯʱ��
								</td>
								<td class="dim_cell_content">
								<input type="text" size="12" name="querytime" value="<%=queryTime%>" />
									<SPAN title="��ѡ������" style="cursor:hand">
										<IMG src="/hbbass/images/icon_date.gif" align="absMiddle" style="cursor:hand" width="27" height="25" border="0" onclick="javascript: var t=document.all.item('querytime').value; var x=window.showModalDialog('/hbbass/channel/surrogateanalysis/monthCalendar.htm',null,'dialogLeft:'+window.event.screenX+'px;dialogTop:'+window.event.screenY+'px;dialogWidth:250px;dialogHeight:140px;resizable:no;status:no;scroll:no');if (x != null && x.length >0) document.all.item('querytime').value = x; if(x!=t&&x!=null) monthChanged();" width="20" align="absbottom" />
									</SPAN>
							    </td>
								<td class="dim_cell_title"  align="left">
									����
								</td>
								<td class="dim_cell_content">
								<%=QueryTools2.getAreaCodeHtml("city", (String) session.getAttribute("area_id"), "")%>								
								</td>
								<td width="50%" class="dim_cell_content" colspan="3">&nbsp;</td>
								</tr>						
						</table>
						<table align="center" width="99%">
							<tr class="dim_row_submit">
								<td align="right">
									<input type="button" class="form_button" value="��ѯ"
										onClick="doSubmit()">
									&nbsp;<!--
									<input type="button" class="form_button" value="����"
										onclick="saveExcel()">
									&nbsp;//-->
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
			<div id="title_div" style="display:none;">
				<table id="resultTable" align="center" width="130%"
					class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
					<tr class="grid_title_blue">						
						<td class="grid_title_cell" width="" id="0">����</td>
						<td class="grid_title_cell" width="" id="1">�ֻ�����</td>
						<td class="grid_title_cell" width="" id="2">��Դ��ʶ</td>
						<td class="grid_title_cell" width="" id="3">��Ӧ��</td>
						<td class="grid_title_cell" width="" id="4">�����</td>
						<td class="grid_title_cell" width="" id="5">���Żݰ�</td>
						<td class="grid_title_cell" width="" id="6">����ʱ��</td>
						<td class="grid_title_cell" width="" id="7">����λ</td>
					  <td class="grid_title_cell" width="" id="8">��������</td>
					  <td class="grid_title_cell" width="" id="9">�������Ա</td>
					  <td class="grid_title_cell" width="" id="10">������</td>
					  <td class="grid_title_cell" width="" id="11">����ʱ��</td>					    
					</tr>
				</table>
			</div>
		</form>
		<%@ include file="/hbbass/common2/loadmask.htm"%></body>
</html>