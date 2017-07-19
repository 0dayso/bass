<%@page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
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

java.util.Calendar cal=java.util.GregorianCalendar.getInstance();
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
String optime = sdf.format(cal.getTime());

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>回流反馈数据录入</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="${mvcPath}/hbbass/css/bass21.css" />
<SCRIPT language=javascript src="${mvcPath}/hbapp/resources/js/default/calendar2.js"></SCRIPT> 
<script language="JavaScript">
function help()
{
var userwindow=window.open('cp_feedbackhelp.jsp?' , "SelectUserWindow", "height=400, width=460, left=540, top=0, toolbar=no, menubar=no, scrollbars=yes, resizable=yes, location=no, status=no");
userwindow.focus();
}

function checkMobileNum(op)
{
    if(op.value.substring(0,2)!='13'&&op.value.substring(0,2)!='15'&&op.value.substring(0,2)!='18')
    {
        alert("输入不是手机号码！"+"="+op.value);
        op.focus();
        return false;
    }
    if(op.value=="")
    {
        alert("请输入手机号码！");
        op.focus();
        return false;
    }
    else 
    {
        var Letters="0123456789" ;
        if(op.value.length!=11)
        {
            alert("电话号码长度不对！"+"="+op.value);
            op.focus();
            return false;
        }
        
        for(i=0;i<op.value.length;i++)
        {
            var CheckChar=op.value.charAt(i);
            if(Letters.indexOf(CheckChar)==-1)
            {
                alert("电话号码格式不正确！"+"="+op.value);
                op.focus();
                return false;
            }
        }        
    }
} 
function updateSingle()
{
	if(form2.employee_num.value=="")   
  {
  	alert("员工编号不能为空!");
  	form2.employee_num.focus();
  	return false;
  }
  
  if(form2.employee_part_name.value=="")   
  {
  	alert("参与员工姓名不能为空!");
  	form2.employee_part_name.focus();
  	return false;
  }
  if(form2.group_custname.value=="")   
  {
  	alert("回流集团名称不能为空!");
  	form2.group_custname.focus();
  	return false;
  }
  if(form2.group_custid.value=="")   
  {
  	alert("回流集团ID不能为空!");
  	form2.group_custid.focus();
  	return false;
  }
  
  if(form2.net_portin.value=="")   
  {
  	alert("回流异网号码不能为空!");
  	form2.net_portin.focus();
  	return false;
  }
  else{
	  var portNum = checkMobileNum(form2.net_portin);
	  if (!portNum && String(portNum) != "undefined"){
		  return false;
	  }
  }
  
  
  if(form2.net_newacc_nbr.value=="")   
  {
  	alert("新发展本网号码不能为空!");
  	form2.net_portin.focus();
  	return false;
  }
  else {
	  var newaccNum = checkMobileNum(form2.net_newacc_nbr);
	  if (!newaccNum && String(newaccNum) != "undefined"){
		  return false;
	  }
  }
  
  var employee_num = document.form2.employee_num.value;
  var employee_part_name = document.form2.employee_part_name.value;
  var group_custname = document.form2.group_custname.value;
  var group_custid = document.form2.group_custid.value;
  var net_portin = document.form2.net_portin.value;
  var net_newacc_nbr = document.form2.net_newacc_nbr.value;
  var opbackdate = document.form2.opbackdate.value;
  loadmask.style.display = "block";
  xmlHttp = new ActiveXObject("Msxml2.XMLHTTP.3.0");
	xmlHttp.onreadystatechange=addBack; // 设置回掉函数
	xmlHttp.open("POST","${mvcPath}/hbapp/app/feedback/feedback_db_province.jsp",false);
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	xmlHttp.setRequestHeader("X-Requested-With","XMLHttpRequest");
	var str="actiontype=singleadd&employee_num="+employee_num+"&employee_part_name="+employee_part_name+"&group_custname="+group_custname+"&group_custid="+group_custid+"&net_portin="+net_portin+"&net_newacc_nbr="+net_newacc_nbr+"&opbackdate="+opbackdate;
	//str = encodeURIComponent(str);
	str = encodeURI(str,"utf-8");
	xmlHttp.send(str);
	//alert(xmlHttp.responseText);
}
function addBack()
{
	if(xmlHttp.readyState == 4)
	{
		if(xmlHttp.status == 200)
		{
			alert(xmlHttp.responseText);
			loadmask.style.display = "none";	
		}
	}
}
</script>
</head>

<body background="${mvcPath}/hbbass/images/bg-1.gif">
 <table width="100%" border="0" cellpadding="0" cellspacing="0">
 <!--     <tr>
       <td width=90% height="27"><font color="#003399">您的位置：<A class=submenu>策反反馈</A></font></td>
       <td width=10%><a href="javascript:help();">帮助<img src="/hbbass/images/hot1.gif" width="17" height="11" border="0"></a></td>
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
               	          <td><span class="style1">集团客户回流反馈录入</span></td>
               	        </tr>
                     </table>
		              </TD>
                </TR>
           <form action="" method="post" name="form2" >
             <TR class="grid_row_alt_blue"> 
                <TD class="grid_row_cell" width="15%" rowspan="7">单个号码录入</TD>
                <TD class="grid_row_cell_number" width="18%">员工编号</TD>
                <TD class="grid_row_cell_text" width="50%"><input type="text" name="employee_num" size=20 maxlength="32" />&nbsp;<font color=red>*</font></TD>
                <TD class="grid_row_cell" width="17%" rowspan="7" align="center" ><input type="button" name="singleaddbtn" class="form_button" value="保存" onClick="updateSingle()"> </TD>
             </TR>
             <!--
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">策反号码</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="opp_nbr" size=20 maxlength="15" />&nbsp;<font color=red>*</font></TD>
             </TR>
             //-->
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">参与员工姓名</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="employee_part_name" size=20 maxlength="30" />&nbsp;<font color=red>*</font></TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">回流集团名称</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="group_custname" size=20 maxlength="64" />&nbsp;<font color=red>*</font></TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">回流集团ID</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="group_custid" size=20 maxlength="32" />&nbsp;<font color=red>*</font></TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">回流异网号码</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="net_portin" size=20 maxlength="15" />&nbsp;<font color=red>*</font></TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">新发展本网号码</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="net_newacc_nbr" size=20 maxlength="15" />&nbsp;<font color=red>*</font></TD>
             </TR>
             <!--
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">回流集团ID</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="op_area" size=20 maxlength="15" />&nbsp;<font color=red>(请填写中文县域名)</font></TD>
             </TR>
             
             <TR class="grid_row_alt_blue">
                <TD align=right style="font-size:9pt;">回流政策</TD>
                <TD align=left  valign="middle" style="font-size:9pt;"><textarea name="police" cols="60" rows="5"></textarea>&nbsp;<font color=red>*</font></TD>
             </TR> -->
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">回流月份</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="opbackdate" size=10 maxlength="10" value=<%=optime%> readonly/>
                <SPAN title="请选择日期" style="cursor:hand" onClick="calendar(document.form2.opbackdate)"><IMG src="/hb-bass-navigation/hbbass/images/icon_date.gif" align="absMiddle" width="27"
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