<%@ page contentType="text/html; charset=gb2312" language="java" import="java.sql.*"%>
<%@ page import="com.asiainfo.database.*" %>
<%@ page import="java.util.*,java.text.*"%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=gb2312" />
	<TITLE>备份数据</TITLE>
	<link rel="stylesheet" type="text/css" href="/hbbass/css/bass21.css" />
</head>
<%
     Sqlca sqlca=null;
			try
			{
			sqlca = new Sqlca(new ConnectionEx("JDBC_HB"));

			sqlca.setAutoCommit(false); //禁用自动提交
			sqlca.addBatch("insert into NGBASS_REPORT_backup(ID, REPORT_NAME, REPORT_DESC, REPORT_COLNAME, REPORT_SQL, ALIGN_LEFT, ALIGN_CENTER, TABLE_WIDTH, REPORT_HELP, REPORTANALYQUERY) "+
			               " select ID, REPORT_NAME, REPORT_DESC, REPORT_COLNAME, REPORT_SQL, ALIGN_LEFT, ALIGN_CENTER, TABLE_WIDTH, REPORT_HELP, REPORTANALYQUERY from NGBASS_REPORT ");
			sqlca.addBatch("insert into NGBASS_REPORT_INPUT_backup(ID, PID, FORMTYPE, FORMNAME, FORMID, DATAFORMAT, SQLREG, TAGNAME, ORDER) select ID, PID, FORMTYPE, FORMNAME, FORMID, DATAFORMAT, SQLREG, TAGNAME, ORDER from NGBASS_REPORT_INPUT");
			sqlca.addBatch("insert into NGBASS_REPORT_OUTPUT_backup(ID, PID, FIELDNAME, VALUEREG, ANALYSORDER) select ID, PID, FIELDNAME, VALUEREG, ANALYSORDER from NGBASS_REPORT_OUTPUT");
			sqlca.executeBatch();
			sqlca.commit();
			out.print("<script>alert('备份应用成功');window.close();</script>");
			}
			catch(Exception excep)
			{
			   out.print("<script>alert('备份应用失败');</script>");
				 excep.printStackTrace();
				 System.out.println(excep.getMessage());
			}
			finally
			{
				if(null != sqlca)
					sqlca.closeAll();
			}
%>
