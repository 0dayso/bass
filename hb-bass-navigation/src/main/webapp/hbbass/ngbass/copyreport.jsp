<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*"%>
<%@ page import="com.asiainfo.database.*" %>
<%@ page import="java.util.*,java.text.*"%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=gb2312" />
	<TITLE>复制应用</TITLE>
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
  document.form1.action="copyreport.jsp";
	document.form1.submit(); 
}
</script>	
</head>
<%
String reportid=request.getParameter("reportid");

String reportname=request.getParameter("reportname")==null?"":request.getParameter("reportname");
reportname=new String(reportname.getBytes("ISO-8859-1"),"gb2312");
reportname=reportname+"-复件";
// 复件的名称
String reportnamenew=request.getParameter("reportnamenew")==null?"复件":request.getParameter("reportnamenew");
reportnamenew=new String(reportnamenew.getBytes("ISO-8859-1"),"gb2312");

String reportdesc=request.getParameter("reportdesc")==null?"":request.getParameter("reportdesc");
reportdesc=new String(reportdesc.getBytes("ISO-8859-1"),"gb2312");

String maxid="";// 现有应用最大id
if(request.getMethod().equals("POST"))
{
     Sqlca sqlca=null;
			try
			{
			sqlca = new Sqlca(new ConnectionEx("JDBC_HB"));
			sqlca.execute("select max(ID)+1 ID   from NGBASS_REPORT with ur");
			if(sqlca.next())
			{
			  maxid=sqlca.getString("id");
			}
			sqlca.setAutoCommit(false); //禁用自动提交
			sqlca.addBatch("insert into NGBASS_REPORT select "+maxid+", '"+reportnamenew+"', '"+reportdesc+"', REPORT_COLNAME, REPORT_SQL, ALIGN_LEFT, ALIGN_CENTER, TABLE_WIDTH, REPORT_HELP, REPORTANALYQUERY  from NGBASS_REPORT where id="+reportid);
			sqlca.addBatch("insert into NGBASS_REPORT_OUTPUT(PID, FIELDNAME, VALUEREG, ANALYSORDER) select "+maxid+", FIELDNAME, VALUEREG, ANALYSORDER from NGBASS_REPORT_OUTPUT where pid="+reportid);
			sqlca.addBatch("insert into NGBASS_REPORT_INPUT(PID, FORMTYPE, FORMNAME, FORMID, DATAFORMAT, SQLREG, TAGNAME, ORDER) select "+maxid+", FORMTYPE, FORMNAME, FORMID, DATAFORMAT, SQLREG, TAGNAME, ORDER from NGBASS_REPORT_INPUT where pid="+reportid);
			sqlca.executeBatch();
			sqlca.commit();
			out.print("<script>alert('复制应用成功');window.opener.location.href=window.opener.location.href;window.close();</script>");
			}
			catch(Exception excep)
			{
			   out.print("<script>alert('复制应用失败');</script>");
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
<br>
<form name="form1" method="post" action="" >
	<input type="hidden" name="reportid" value="<%=reportid%>">
	 <table width="98%" align="center" border="0" cellspacing="1" cellpadding="1" bgcolor="#c3daf9">
		<tr bgcolor="#FFFFFF">
	    <td align="center" width="30%">应用名称：</td>
	    <td width="70%"><input type="text" name="reportnamenew" value="<%=reportname%>"  size="40" maxlength="40"/></td>
		</tr>
			<tr bgcolor="#FFFFFF">
	    <td align="center">应用描述：</td><td width="70%">
	       <textarea name="reportdesc" id="reportdesc" cols="45" rows="5"></textarea>	
	    </td>
	   </tr> 
	   <tr bgcolor="#FFFFFF" height="30">
	    <td align="center" colspan="2"><input type=button name="confirm" class="form_button" value="确 定"  onclick="clickSubmit()"> 
	    	&nbsp;&nbsp;<input type=reset name="addbt" class="form_button" value="取 消" >
	    	&nbsp;&nbsp;<input type=button name="cancel" class="form_button" value="关 闭"  onclick="window.close()"> 
	    </td>
		</tr>
	</table>
</form>
</body>
</html>	