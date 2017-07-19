<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.asiainfo.bass.components.models.ConnectionManage"%>
<%@page import="java.sql.Connection"%>
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
/*
java.util.Calendar cal=java.util.GregorianCalendar.getInstance();
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
String optime = sdf.format(cal.getTime());
*/
String time_id = request.getParameter("time_id");
String imei = request.getParameter("imei");
String prod = request.getParameter("prod");
String device_name = request.getParameter("device_name");
String use_locate = request.getParameter("use_locate");
String sell_locate = request.getParameter("sell_locate");
Connection conn = null;
try
{
	conn = ConnectionManage.getInstance().getConnection("jdbc/JDBC_HB");
	conn.setAutoCommit(false);
	ResultSet rs = null;
	int count = 0;

	//检查是否能查询出数据
	String querySql = " select count(*) count from NWH.TERMINAL_SJ_LOAD a where time_id = "+time_id+" and imei = '"+imei+"' and prod = '"+prod+"' and device_name = '"+device_name+"' and use_locate = '"+use_locate+"' and sell_locate = '"+sell_locate+"' with ur ";
	System.out.println("querySql = "+querySql);
	PreparedStatement psQuery = conn.prepareStatement(querySql);
	rs = psQuery.executeQuery();
	while(rs.next()){
		count = rs.getInt("count");
		if(count <= 0){
			System.out.println("没有此imei的数据，请查询清楚!");			
		}
	}
}
catch (SQLException e)
{
	e.printStackTrace();
	System.out.println(e.getStackTrace());
}
finally
{
	if (conn != null)
	{
		conn.setAutoCommit(true);
		conn.close();
	}
}		
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>回流反馈数据修改</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
<SCRIPT language=javascript src="/hcr/jscript/calendar/calendar.js"></SCRIPT>
<script language="JavaScript">
function updateSingle()
{
  var prod = document.form2.prod.value;
  var device_name = document.form2.device_name.value;
  var use_locate = document.form2.use_locate.value;
  var sell_locate = document.form2.sell_locate.value;
  var time_id = document.form2.time_id.value;
  loadmask.style.display = "block";
  xmlHttp = new ActiveXObject("Msxml2.XMLHTTP.3.0");
	xmlHttp.onreadystatechange=modBack; // 设置回掉函数
	xmlHttp.open("POST","${mvcPath}/hbapp/app/import/jtchDb.jsp",false);
	xmlHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	var str="actiontype=singleUpd&imei="+<%=imei%>+"&prod="+prod+"&device_name="+device_name+"&use_locate="+use_locate+"&sell_locate="+sell_locate+"&time_id="+time_id;
	//str = encodeURIComponent(str);
	xmlHttp.setRequestHeader("X-Requested-With","XMLHttpRequest");
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
			window.location.href='jituanchuanghuo_import.jsp';
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
               	          <td><span class="style1"><%=imei%>集团串货数据修改</span></td>
               	        </tr>
                     </table>
		              </TD>
                </TR>
           <form action="" method="post" name="form2" >
             <TR class="grid_row_alt_blue"> 
                <TD class="grid_row_cell" width="15%" rowspan="7">集团串货数据修改</TD>
                <TD class="grid_row_cell_number" width="18%">品牌</TD>
                <TD class="grid_row_cell_text" width="50%"><input type="text" name="prod" size=20 maxlength="15" value="<%=prod%>"/>&nbsp;<font color=red>*</font></TD>
                <TD class="grid_row_cell" width="17%" rowspan="7" align="center" ><input type="button" name="singleaddbtn" class="form_button" value="保存" onClick="updateSingle()"> </TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">型号</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="device_name" size=20 maxlength="30" value="<%=device_name%>"/>&nbsp;<font color=red>*</font></TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">客户归属省</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="use_locate" size=20 maxlength="15" value="<%=use_locate%>"/>&nbsp;<font color=red>*</font></TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">终端销售省</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="sell_locate" size=20 maxlength="15" value="<%=sell_locate%>"/>&nbsp;</TD>
             </TR>
             <TR class="grid_row_alt_blue"> 
                <TD align=right style="font-size:9pt;">省际窜入窜出时间</TD>
                <TD align=left style="font-size:9pt;"><input type="text" name="time_id" size=10 maxlength="10" value="<%=time_id%>" readonly/>
                <SPAN title="请选择日期" style="cursor:hand" onClick="calendar(document.form2.op_date)"><IMG src="/hbbass/images/icon_date.gif" align="absMiddle" width="27"
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