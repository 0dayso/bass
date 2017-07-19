<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="com.asiainfo.database.*" %>
<%@page import="java.util.*,java.text.*"%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
	<TITLE>表单配置</TITLE>
	<script type="text/javascript" src="/hbbass/common2/basscommon.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/common2/bassgcc.js" charset=utf-8></script>
	<script type="text/javascript" src="/hbbass/ngbass/config.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
	<link rel="stylesheet" type="text/css" href="/hbbass/ngbass/ngbass.css" />
</head>
<%
String reportid=request.getParameter("reportid");
String reportname=request.getParameter("reportname");
reportname=new String(reportname.getBytes("ISO-8859-1"),"gb2312");

/* 获取操作类型 */
String oper=request.getParameter("oper")==null?"":request.getParameter("oper");

/* 修改查询条件*/
String modid=request.getParameter("modid")==null?"":request.getParameter("modid");

/* 修改表头及查询sql*/
String report_colname=request.getParameter("report_colname")==null?"":request.getParameter("report_colname");
report_colname=new String(report_colname.getBytes("ISO-8859-1"),"gb2312");
report_colname=report_colname.replaceAll("'","''");
String align_left=request.getParameter("align_left")==null?"":request.getParameter("align_left");
String align_center=request.getParameter("align_center")==null?"":request.getParameter("align_center");
String table_width=request.getParameter("table_width")==null?"99":request.getParameter("table_width");
String report_help=request.getParameter("report_help")==null?"99":request.getParameter("report_help");
report_help=new String(report_help.getBytes("ISO-8859-1"),"gb2312");
report_help=report_help.replaceAll("'","''");
report_help=report_help.replaceAll("\n","<br>");
report_help=report_help.replaceAll(" ","&nbsp;");

String report_sql=request.getParameter("report_sql")==null?"":request.getParameter("report_sql");
report_sql=new String(report_sql.getBytes("ISO-8859-1"),"gb2312");
report_sql=report_sql.replaceAll("'","''");
/* 定义操作结果信息 */
String message="";

Sqlca sqlca=null;
try
{
	sqlca = new Sqlca(new ConnectionEx("JDBC_HB"));
	if(oper.equals("modsql"))
	{
	   sqlca.execute("update NGBASS_REPORT set REPORT_COLNAME='"+report_colname+"',REPORT_SQL='"+report_sql+"',align_left='"+align_left+"',align_center='"+align_center+"',table_width='"+table_width+"' ,report_help='"+report_help+"' where id="+reportid);
	   message="修改表头及查询sql成功！";
	}

%>
<body>
<form name="form1" method="post" action="">
	<input type="hidden" name="reportid" value="<%=reportid%>">
	<input type="hidden" name="reportname" value="<%=reportname%>">
	<input type="hidden" name="modid" value="">
	
		<!-- 输出结果定义 -->
<table width="98%" border="0" align="center">
<tr><td width=30% align="left">输出表头及查询sql配置&nbsp;</td>
	<td width=30% align="center"><div id="modSqlNotic"><font color="red"><%=message%></font></div></td>
	 <td width=35% align="right">
	     <input type="button" class="form_button" name="modresult" value="修改" onclick="modSql()">&nbsp;
		   <input type="reset" class="form_button" name="cancel2" value="取消">&nbsp;
	 </td>
</tr>
</table>
<table id="resultTable" align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" style="display:block">
 <tr class="grid_title_blue">
  <td width="10%" align="center">配置项</td>
  <td width="90%" align="center" colspan="3">值</td>
</tr>
<%
sqlca.execute("select * from NGBASS_REPORT where id="+reportid);
String report_colname2="";
String report_sql2="";
String align_left2="";
String align_center2="";
String table_width2="99";
String report_help2="";
String reportAnalyQuery2="";

if(sqlca.next())
{
report_colname2=sqlca.getString("REPORT_COLNAME");
report_sql2=sqlca.getString("REPORT_SQL");
align_left2=sqlca.getString("align_left");
align_center2=sqlca.getString("align_center");
table_width2=sqlca.getString("table_width");
report_help2=sqlca.getString("report_help");
report_help2=report_help2.replaceAll("<br>","\n");
report_help2=report_help2.replaceAll("&nbsp;"," ");
reportAnalyQuery2=sqlca.getString("reportAnalyQuery");
}
%>
<tr bgcolor="#FFFFFF">
  <td align="center">&nbsp;</td>
  <td align="left">&nbsp;表格宽度<input type="text" name="table_width" id="align_left" value="<%=table_width2%>" size="20">&nbsp;左对齐<input type="text" name="align_left" id="align_left" value="<%=align_left2%>" size=20 />&nbsp;居中对齐<input type="text" name="align_center" id="align_center" value="<%=align_center2%>" size=20 /></td>
</tr>
<tr bgcolor="#FFFFFF">
  <td align="center">输出表头</td>
  <td align="center" colspan="3"><textarea name="report_colname" cols="120" rows="4"><%=report_colname2%></textarea></td>
</tr>
<tr bgcolor="#FFFFFF">
  <td align="center">查询sql</td>
  <td align="center" colspan="3"><textarea name="report_sql" cols="120" rows="20"><%=report_sql2%></textarea></td>
</tr>
<tr bgcolor="#FFFFFF">
  <td align="center">帮助信息</td>
  <td align="center" colspan="3"><textarea name="report_help" cols="120" rows="6"><%=report_help2%></textarea></td>
</tr>
<tr bgcolor="#FFFFFF">
  <td align="center">提示</td>
  <td align="left" colspan="3">
  1.查询模块不能进行维度的编码转换，需要在sql中关联表进行转换；<br>
  2.如果涉及到全省看地市、地市看县市的报表类查询，需要截取字段时候，固定变量为length(city)， 如：substr(channel_code,1,length(city)),<br>	
 选择全省时 length(city)将替换为5，输出如 HB.WH ,选择了某一个地市时 length(city)将替换为8 输出如 HB.WH.01
  </td>
</tr>
</table>
</form>
</body>
</html>
<%
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
%>
<script>
setTimeout("clearNotice()",3000)	;	
</script>