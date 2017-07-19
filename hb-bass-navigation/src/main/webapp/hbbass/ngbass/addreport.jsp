<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*"%>
<%@ page import="com.asiainfo.database.*" %>
<%@ page import="java.util.*,java.text.*"%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=gb2312" />
	<TITLE>新增应用</TITLE>
	<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
  <style>	
	.form_button{
	BORDER-RIGHT: #7b9ebd 1px solid; 
	BORDER-TOP: #7b9ebd 1px solid; 
	BORDER-LEFT: #7b9ebd 1px solid;
	BORDER-BOTTOM: #7b9ebd 1px solid;
	PADDING: 2px ,2px; 
	FONT-SIZE: 12px; 
	FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); 
	CURSOR: hand; 
	COLOR: black;
 	width:60px;
 	height:20px;
}

/* 要求有下划线的链接样式 */
a.a2            { color: #0000FF; text-decoration: none }
a:link.a2       { text-decoration: underline; color: #0000FF; font-family: 宋体 }
a:visited.a2    { text-decoration: underline; color: #0000FF; font-family: 宋体 }
a:hover.a2      { text-decoration: underline; color: #FF0000 }
a:active.a2     { text-decoration: underline; color: #FF0000 }
</style>
<script language=javascript>
function clickSubmit()
{
  document.form1.confirm.disabled=true;
  document.form1.action="addreport.jsp";
	document.form1.submit(); 
}
</script>	
</head>
<%
String reportname=request.getParameter("reportname")==null?"":request.getParameter("reportname");
reportname=new String(reportname.getBytes("ISO-8859-1"),"gb2312");

String reportdesc=request.getParameter("reportdesc")==null?"":request.getParameter("reportdesc");
reportdesc=new String(reportdesc.getBytes("ISO-8859-1"),"gb2312");

String sql="insert into NGBASS_REPORT(REPORT_NAME, REPORT_DESC) values ('"+reportname+"','"+reportdesc+"')";
if(request.getMethod().equals("POST"))
{
     Sqlca sqlca=null;
			try
			{
			sqlca = new Sqlca(new ConnectionEx("JDBC_HB"));
			if(sqlca.execute(sql)>0)
				out.print("<script>alert('新增应用成功');window.opener.location.href=window.opener.location.href;window.close();</script>");
		  else
				out.print("<script>alert('新增应用失败');</script>");
			}
			catch(Exception excep)
			{
				 excep.printStackTrace();
				 System.out.println(excep.getMessage());
			}
			finally
			{
				if(null != sqlca)
					sqlca.closeAll();
			}

}
%>
<body topmargin="5">
<form name="form1" method="post" action="" >
	 <table width="98%" align="center" border="0" cellspacing="1" cellpadding="1" bgcolor="#c3daf9">
		<tr bgcolor="#FFFFFF">
	    <td align="center" width="30%">应用名称：</td><td width="70%"><input type="text" name="reportname" value="" size="40" maxlength="40"/></td>
		</tr>
			<tr bgcolor="#FFFFFF">
	    <td align="center">应用描述：</td><td width="70%">
	       <textarea name="reportdesc" id="reportdesc" cols="45" rows="5"></textarea>	
	    </td>
	   </tr> 
	   <tr bgcolor="#FFFFFF" height="30">
	    <td align="center" colspan="2"><input type=button name="confirm" class="form_button" value="新 增"  onclick="clickSubmit()"> 
	    	&nbsp;&nbsp;<input type=reset name="addbt" class="form_button" value="取 消" >
	    	&nbsp;&nbsp;<input type=button name="cancel" class="form_button" value="关 闭"  onclick="window.close()"> 
	    </td>
		</tr>
	</table>
</form>
</body>
</html>	