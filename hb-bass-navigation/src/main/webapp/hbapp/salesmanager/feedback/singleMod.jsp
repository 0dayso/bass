<%@page contentType="text/html; charset=gb2312"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="bass.database.report.ReportBean"%>
<%
response.setHeader("Cache-Control","no-store");
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
/*
java.util.Calendar cal=java.util.GregorianCalendar.getInstance();
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
String optime = sdf.format(cal.getTime());
*/
String opp_nbr = request.getParameter("opp_nbr");
String acc_nbr = request.getParameter("acc_nbr");
String manager_name = "";
String manager_id = "";
String op_area = "";
String police = "";
String op_date = "";
 
String strSql = " select opp_nbr,acc_nbr,name,manager_id,area,police,date from COMPETE_OPPSTATE a where opp_nbr = '"+opp_nbr+"' and acc_nbr = '"+acc_nbr+"' with ur ";
ReportBean rb = new ReportBean();
rb.execute(strSql);
int num1 = rb.getRowCount();
if(num1 > 0)
{
	for(int i=0;i<num1;i++)
	{
		opp_nbr = rb.getStringValue("opp_nbr",i);
		acc_nbr = rb.getStringValue("acc_nbr",i);
		manager_name = rb.getStringValue("name",i);
		manager_id = rb.getStringValue("manager_id",i);
		op_area = rb.getStringValue("area",i);
		police = rb.getStringValue("police",i);
		op_date = rb.getStringValue("date",i);
	}
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>�������������޸�</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
<SCRIPT language=javascript src="/hcr/jscript/calendar/calendar.js"></SCRIPT>
<script language="JavaScript">

function checkMobileNum(op)
{
    if(op.value.substring(0,2)!='13'&&op.value.substring(0,2)!='15'&&op.value.substring(0,2)!='18')
    {
        alert("���벻���ֻ����룡");
        op.focus();
        return false;
    }
    if(op.value=="")
    {
        alert("�������ֻ����룡");
        op.focus();
        return false;
    }
    else 
    {
        var Letters="0123456789" ;
        if(op.value.length!=11)
        {
            alert("�绰���볤�Ȳ��ԣ�");
            op.focus();
            return false;
        }
        
        for(i=0;i<op.value.length;i++)
        {
            var CheckChar=op.value.charAt(i);
            if(Letters.indexOf(CheckChar)==-1)
            {
                alert("�绰�����ʽ����ȷ��");
                op.focus();
                return false;
            }
        }
        
    }
}
function updateSingle()
{
  
  if(checkMobileNum(document.form2.acc_nbr)==false)   
  {
  	return false;
  }  
  if(form2.manager_name.value=="")   
  {
  	alert("�ͻ�������������Ϊ��!");
  	form2.manager_name.focus();
  	return false;
  }
  if(form2.manager_id.value=="")   
  {
  	alert("�ͻ�����ID����Ϊ��!");
  	form2.manager_id.focus();
  	return false;
  }
  if(form2.police.value=="")   
  {
  	alert("�������߲���Ϊ��!");
  	form2.police.focus();
  	return false;
  }
  var opp_nbr = document.form2.opp_nbr.value;
  var acc_nbr = document.form2.acc_nbr.value;
  var manager_name = document.form2.manager_name.value;
  var manager_id = document.form2.manager_id.value;
  var police = document.form2.police.value;
  var op_area = document.form2.op_area.value;
  var op_date = document.form2.op_date.value
  loadmask.style.display = "block";
  xmlHttp = new ActiveXObject("Msxml2.XMLHTTP.3.0");
	xmlHttp.onreadystatechange=modBack; // ���ûص�����
	xmlHttp.open("POST","/hbbass/salesmanager/feedback/feedback_db.jsp",false);
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	var str="actiontype=singlemod&opp_nbr="+opp_nbr+"&acc_nbr="+acc_nbr+"&manager_name="+manager_name+"&manager_id="+manager_id+"&police="+police+"&op_area="+op_area+"&op_date="+op_date;
	//str = encodeURIComponent(str);
	str = encodeURI(str,"utf-8");
	xmlHttp.send(str);
	//alert(xmlHttp.responseText);
}
function modBack()
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			alert(xmlHttp.responseText);
			loadmask.style.display = "none";
			window.parent.focus();
			//window.opener.doSubmit();
		}
	}
}
</script>
</head>

<body background="/hbbass/images/bg-1.gif">
 <table width="100%" border="0" cellpadding="0" cellspacing="0">
 <!--     <tr>
       <td width=90% height="27"><font color="#003399">����λ�ã�<A class=submenu>�߷�����</A></font></td>
       <td width=10%><a href="javascript:help();">����<img src="/hbbass/images/hot1.gif" width="17" height="11" border="0"></a></td>
     </tr>
 -->
	 <tr> 
      <td rowspan="2" colspan=2 valign="top" bgcolor="#FAFCFA"> 
		       <TABLE border=1 borderColorDark=#ffffff borderColorLight=#000066 cellPadding=3 cellSpacing=0 width="95%" align="center">
                <TR> 
                  <TD colspan="4" align="center">
			               <table width="380" height="50" border="0" align="left" cellpadding="0" cellspacing="0" background="${mvcPath}/hbbass/images/hot-open.gif">
               	        <tr> 
               	          <td width=50% height="13"> </td>
               	          <td>&nbsp;</td>
               	        </tr>
               	        <tr> 
               	          <td height="17">&nbsp;</td>
               	          <td><span class="style1"><%=acc_nbr%>&nbsp���뷴�������޸�</span></td>
               	        </tr>
                     </table>
		              </TD>
                </TR>
           <form action="" method="post" name="form2" >
             <TR class="grid_row_alt_blue"> 
                <TD class="grid_row_cell" width="15%" rowspan="7">���������޸�</TD>
                <TD class="grid_row_cell_number" width="18%">�߷�����</TD>
                <TD class="grid_row_cell_text" width="50%"><input type="text" name="opp_nbr" size=20 maxlength="15" value="<%=opp_nbr%>"/>&nbsp;<font color=red>*</font></TD>
                <TD class="grid_row_cell" width="17%" rowspan="7" align="center" ><input type="button" name="singleaddbtn" class="form_button" value="����" onClick="updateSingle()"> </TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">�ƶ�����</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="acc_nbr" size=20 maxlength="11" value="<%=acc_nbr%>"/>&nbsp;<font color=red>*</font></TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">�ͻ���������</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="manager_name" size=20 maxlength="30" value="<%=manager_name%>"/>&nbsp;<font color=red>*</font></TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">�ͻ�����ID</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="manager_id" size=20 maxlength="15" value="<%=manager_id%>"/>&nbsp;<font color=red>*</font></TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">�ͻ������������</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="op_area" size=20 maxlength="15" value="<%=op_area%>"/>&nbsp;</TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">��������</TD>
                <TD align=left  valign="middle" style="font-size:9pt;"><textarea name="police" cols="60" rows="5"><%=police%></textarea>&nbsp;<font color=red>*</font></TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">�߷�����</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="op_date" size=10 maxlength="10" value="<%=op_date%>" readonly/>
                <SPAN title="��ѡ������" style="cursor:hand" onClick="calendar(document.form2.op_date)"><IMG src="/hbbass/images/icon_date.gif" align="absMiddle" width="27"
								height="25" border="0"> </SPAN>
                </TD>
             </TR>
           </form>
          </TABLE>
      </td>
	 </tr>
</table>
<%@ include file="/hbbass/common2/loadmask.htm"%>
</body>
</html>