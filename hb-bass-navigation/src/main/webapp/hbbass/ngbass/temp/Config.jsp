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
  <script src="calendarweek.js" type="text/javascript"></script>

<%--本页 jsp 初始化程序段--%>
<%

String reportid=request.getParameter("reportid");
String reportname=request.getParameter("reportname");
reportname=new String(reportname.getBytes("ISO-8859-1"),"gb2312");
/* 获取操作类型 */
String oper=request.getParameter("oper")==null?"":request.getParameter("oper");
/* 增加查询条件 */

String order=request.getParameter("order")==null?"1":request.getParameter("order");
/*删除查询条件*/
String delid=request.getParameter("delid")==null?"":request.getParameter("delid");
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


String reportAnalyQuery=request.getParameter("reportAnalyQuery")==null?"99":request.getParameter("reportAnalyQuery");
reportAnalyQuery=new String(reportAnalyQuery.getBytes("ISO-8859-1"),"gb2312");
reportAnalyQuery=reportAnalyQuery.replaceAll("'","''");


/*  增加分析配置信息 */
String fieldValue =request.getParameter("fieldValue")==null?"":request.getParameter("fieldValue");
String fieldName  =request.getParameter("fieldName")==null?"":request.getParameter("fieldName");
fieldName=new String(fieldName.getBytes("ISO-8859-1"),"gb2312");

String fieldType  =request.getParameter("fieldType")==null?"dim":request.getParameter("fieldType");
String dimTable   =request.getParameter("dimTable")==null?"":request.getParameter("dimTable");
String valueReg   =request.getParameter("valueReg")==null?"":request.getParameter("valueReg");
valueReg=valueReg.replaceAll("'","''");
String analysOrder=request.getParameter("analysOrder")==null?"":request.getParameter("analysOrder");

/* 定义操作结果信息 */
String message="";

Sqlca sqlca=null;
try
{
	sqlca = new Sqlca(new ConnectionEx());
	if(oper.equals("modsql"))
	{
	   sqlca.execute("update NGBASS_REPORT set REPORT_COLNAME='"+report_colname+"',REPORT_SQL='"+report_sql+"',align_left='"+align_left+"',align_center='"+align_center+"',table_width='"+table_width+"' ,report_help='"+report_help+"' where id="+reportid);
	   message="修改表头及查询sql成功！";
	}
	else if(oper.equals("addanaly"))
	{
	   sqlca.execute("insert into NGBASS_REPORT_OUT(PID, FIELDVALUE, FIELDNAME, FIELDTYPE, DIMTABLE, VALUEREG,  ANALYSORDER) values("+reportid+",'"+fieldValue+"','"+fieldName+"','"+fieldType+"','"+dimTable+"','"+valueReg+"',"+analysOrder+")");
	     message="新增分析配置成功！";
	}
	/* 删除一个查询条件 */
	else if(oper.equals("delanaly"))
	{
	   sqlca.execute("delete from  NGBASS_REPORT_OUT where id="+delid);
	    message="删除分析条件成功！";
	}
	else if(oper.equals("modianaly"))
	{
	   sqlca.execute("update NGBASS_REPORT_OUT set FIELDVALUE='"+fieldValue+"', FIELDNAME='"+fieldName+"', FIELDTYPE='"+fieldType+"', DIMTABLE='"+dimTable+"', VALUEREG='"+valueReg+"', ANALYSORDER="+analysOrder+" where id="+modid);
	    message="保存分析条件成功！";
	}
	else if(oper.equals("modanalyCon"))
	{
	   sqlca.execute("update NGBASS_REPORT set reportAnalyQuery='"+reportAnalyQuery+"' where id="+reportid);
	   message="修改分析配置成功！";
	}
%>  
<form name="form1" method="post" action="">
	<input type="hidden" name="reportid" value="<%=reportid%>">
		<input type="hidden" name="reportname" value="<%=reportname%>">
		<input type="hidden" name="modid" value="">
			<!-- 查询条件定义 -->

	<!-- 输出结果定义 -->
<table width="98%" border="0" align="center">
<tr><td width=30% align="left">输出表头及查询sql配置&nbsp;<span id="resultControl" style="cursor:hand" onclick="controlView(this.id,'resultTable')">隐藏</span></td>
	<td width=30% align="center"><div id="modSqlNotic"><font color="red"><%=message%></font></div></td>
	 <td width=35% align="right">
	     <input type="button" class="form_button" name="modresult" value="修改" onclick="modSql()">&nbsp;
		   <input type="reset" class="form_button" name="cancel2" value="取消">&nbsp;
	 </td>
</tr>
</table>
<table id="resultTable" align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" style="display:none">
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
  <td align="center" colspan="3"><textarea name="report_colname" cols="120" rows="3"><%=report_colname2%></textarea></td>
</tr>
<tr bgcolor="#FFFFFF">
  <td align="center">查询sql</td>
  <td align="center" colspan="3"><textarea name="report_sql" cols="120" rows="6"><%=report_sql2%></textarea></td>
</tr>
<tr bgcolor="#FFFFFF">
  <td align="center">帮助信息</td>
  <td align="center" colspan="3"><textarea name="report_help" cols="120" rows="6"><%=report_help2%></textarea></td>
</tr>
</table>


<table width="98%" border="0" align="center">
<tr><td width=50% align="left">分析条件配置</td>
	 <td width=50% align="right">
	     <input type="button" class="form_button" name="addanaly" value="添加" onclick="addAnlya()">&nbsp;
		   <input type="reset" class="form_button" name="cancleanaly" value="取消">&nbsp;
	 </td>
</tr>
</table>
<table id="analyTable" align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
 <tr class="grid_title_blue">

  <td width="12%" align="center">表字段名称</td>
  <td width="15%" align="center">字段中文名称</td>
  <td width="5%" align="center">类型</td>
  <td width="15%" align="center">维表</td>
  <td width="40%" align="center">指标规则</td>
  <td width="5%" align="center">排序</td>
</tr>
<tr bgcolor="#FFFFFF">
	<td><input type="text" name="fieldValue" id="fieldValue" size="18" maxlength="30"/></td>
	<td><input type="text" name="fieldName" id="fieldName" size="18" maxlength="30"/></td>
  <td>
    <select name="fieldType" style="width:60" id="fieldType">
      <option value="dim" <%if(fieldType.equals("dim")) out.println("selected");%>>维度</option>
      <option value="value" <%if(fieldType.equals("value")) out.println("selected");%>>指标</option>
    </select>	
  </td>
  <td>
    <select name="dimTable" id="dimTable" style="width:160">
     	   <option value="none">不需要维度转换</option>
     	   <%
     	     String dimSql="select distinct NAME, TAGNAME from DIM_TOTAL where tagname is not null order by 1";
     	     sqlca.execute(dimSql);
	     	   while(sqlca.next())
	     	   {
     	   %>
     	   <option value="<%=sqlca.getString("TAGNAME")%>"><%=sqlca.getString("NAME")%></option>
     	   <%
     	     }
     	   %>
		</select>
  </td>
	
	<td><input type="text" name="valueReg" id="valueReg"  size="54" maxlength="200"/></td>
 	<td>
	<select name="analysOrder" style="width:40" id="order">
      <option value="1">1</option>
      <option value="2">2</option>
      <option value="3">3</option>
      <option value="4">4</option>
      <option value="5">5</option>
      <option value="6">6</option>
      <option value="7">7</option>
      <option value="8">8</option>
      <option value="9">9</option>
      <option value="10">10</option>
      <option value="11">11</option>
      <option value="12">12</option>
      <option value="13">13</option>
      <option value="14">14</option>
      <option value="15">15</option>
    </select>		
	</td>
</tr>
</table>
<br>
	 <table align="center" width="98%" cellspacing="1" cellpadding="0" border="0">
      <tr>
      	<td width=50% align="left">已有分析配置&nbsp;<span id="analyControl" style="cursor:hand" onclick="controlView(this.id,'EditAnalyTable')" >隐藏</span></td>
		    <td width="50%" align="right">
		       <input type="button" class="form_button2" name="modi2" value="保存编辑" onClick="saveanaly()">&nbsp;	
		    </td>
		  </tr>
	</table>			
<table id="EditAnalyTable" align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" style="display:block">
 <tr class="grid_title_blue">
 	<td width="5%" align="center">编号</td>
  <td width="10%" align="center">表字段名称</td>
  <td width="10%" align="center">字段中文名称</td>
  <td width="5%" align="center">类型</td>
  <td width="10%" align="center">维表</td>
  <td width="30%" align="center">指标规则</td>
  <td width="5%" align="center">排序</td>
  <td width="15%" align="center">操作</td>
</tr>
     <%
					
					 String sqlAnaly="select ID, FIELDVALUE, FIELDNAME, case when FIELDTYPE='dim' then '维度' else '指标' end FIELDTYPE, value(b.name,'') name, VALUEREG, ANALYSORDER  from NGBASS_REPORT_OUT a left join (select distinct NAME, TAGNAME from DIM_TOTAL where tagname is not null  ) b on a.dimtable=b.TAGNAME where pid="+reportid+" order by FIELDTYPE,ANALYSORDER,id with ur ";
	         sqlca.execute(sqlAnaly);
					 while(sqlca.next())
					 {
      %>	
         <tr class="grid_row_blue" height="25">
            <td align="left"><%=sqlca.getString("ID")%></td> 
            <td align="left"><%=sqlca.getString("FIELDVALUE")%></td> 
            <td align="left"><%=sqlca.getString("FIELDNAME")%></td> 
            <td align="left"><%=sqlca.getString("FIELDTYPE")%></td> 
            <td align="left"><%=sqlca.getString("name")%></td> 
            <td align="left"><%=sqlca.getString("VALUEREG")%></td> 
            <td align="left"><%=sqlca.getString("ANALYSORDER")%></td> 
				     <td align="center">
				     <input type="button" class="form_button" name="btmodanaly" value="编辑" onclick="modanaly('<%=sqlca.getString("ID")%>','<%=sqlca.getString("FIELDVALUE")%>','<%=sqlca.getString("FIELDNAME")%>','<%=sqlca.getString("FIELDTYPE")%>','<%=sqlca.getString("name")%>','<%=sqlca.getString("VALUEREG")%>','<%=sqlca.getString("ANALYSORDER")%>')">	&nbsp;
				     <input type="button" class="form_button" name="btdelanaly" value="删除" onclick="delanaly('<%=sqlca.getString("ID")%>')">	     
				    </td>
				  </tr>  
      <%
      }
      %>				 
						 
</table>


	<!-- 定义分析查询主表、查询条件及分组条件 -->
<table width="98%" border="0" align="center">
<tr><td width=30% align="left">分析定义&nbsp;<span id="analyCOnfigControl" style="cursor:hand" onclick="controlView(this.id,'analyConTable')">隐藏</span></td>
	<td width=30% align="center"><div id="modSqlNotic2"><font color="red"><%=message%></font></div></td>
	 <td width=35% align="right">
	     <input type="button" class="form_button" name="modanalyCon" value="修改" onclick="modAnalyCon()">&nbsp;
		   <input type="reset" class="form_button" name="cancel3" value="取消">&nbsp;
	 </td>
</tr>
</table>
<table id="analyConTable" align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" style="display:block">
 <tr class="grid_title_blue">
  <td width="10%" align="center">配置项</td>
  <td width="90%" align="center" colspan="3">值</td>
</tr>
<tr bgcolor="#FFFFFF">
  <td align="center">查询主题</td>
  <td align="center" colspan="3"><textarea name="reportAnalyQuery" cols="120" rows="6"><%=reportAnalyQuery2%></textarea></td>
</tr>
</table>




</form>
</body>
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