<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="com.asiainfo.database.*" %>
<%@page import="java.util.*,java.text.*"%>
<HTML>
<HEAD>
	<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
	<TITLE>分析条件配置</TITLE>
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

/*  增加分析配置信息 */
String fieldName  =request.getParameter("fieldName")==null?"":request.getParameter("fieldName");
fieldName=new String(fieldName.getBytes("ISO-8859-1"),"gb2312");
String valueReg   =request.getParameter("valueReg")==null?"":request.getParameter("valueReg");
valueReg=new String(valueReg.getBytes("ISO-8859-1"),"gb2312");
valueReg=valueReg.replaceAll("'","''");
String analysOrder=request.getParameter("analysOrder")==null?"":request.getParameter("analysOrder");

/* 修改查询查询主体*/
String modid=request.getParameter("modid")==null?"":request.getParameter("modid");
String reportAnalyQuery=request.getParameter("reportAnalyQuery")==null?"99":request.getParameter("reportAnalyQuery");
reportAnalyQuery=new String(reportAnalyQuery.getBytes("ISO-8859-1"),"gb2312");
reportAnalyQuery=reportAnalyQuery.replaceAll("'","''");

/*删除查询条件*/
String delid=request.getParameter("delid")==null?"":request.getParameter("delid");

/* 定义操作结果信息 */
String message="";

Sqlca sqlca=null;
try
{
	sqlca = new Sqlca(new ConnectionEx("JDBC_HB"));
	if(oper.equals("addanaly"))
	{
	   if(!analysOrder.equals(""))
	   {
	    sqlca.execute("insert into NGBASS_REPORT_OUTPUT(PID,  FIELDNAME,   VALUEREG,  ANALYSORDER) values("+reportid+",'"+fieldName+"','"+valueReg+"',"+analysOrder+")");
	   }
	  else
	 	{
	   	sqlca.execute("insert into NGBASS_REPORT_OUTPUT(PID,  FIELDNAME,  VALUEREG,  ANALYSORDER) values("+reportid+",'"+fieldName+"','"+valueReg+"',(select value(max(ANALYSORDER)+1,1) from     NGBASS_REPORT_OUTPUT where pid="+reportid+"))");
	 	}
	     message="新增分析配置成功！";
	}
	/* 删除一个查询条件 */
	else if(oper.equals("delanaly"))
	{
	   sqlca.execute("delete from  NGBASS_REPORT_OUTPUT where id="+delid);
	    message="删除分析条件成功！";
	}
	else if(oper.equals("modianaly"))
	{
	   sqlca.execute("update NGBASS_REPORT_OUTPUT set FIELDNAME='"+fieldName+"',VALUEREG='"+valueReg+"', ANALYSORDER="+analysOrder+" where id="+modid);
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
		
<table width="98%" border="0" align="center">
<tr><td width=50% align="left">分析指标配置</td>
	 <td width=50% align="right">
	     <input type="button" class="form_button" name="addanaly" value="添加" onclick="addAnlya()">&nbsp;
		   <input type="reset" class="form_button" name="cancleanaly" value="取消">&nbsp;
	 </td>
</tr>
</table>
<table id="analyTable" align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
 <tr class="grid_title_blue">
  <td width="15%" align="center">指标中文名称</td>
  <td width="40%" align="center">指标规则</td>
  <td width="5%" align="center">排序</td>
</tr>
<tr bgcolor="#FFFFFF">
<td align="left" >
  	 <select name="fieldName" id="fieldName" style="width:180">
	 	 <option value=''>请选择</option>  
	 		<%
		 	 // sqlca.execute("select lcase(replace(substr(sqlreg,1,locate('=',sqlreg)),'=','')) field ,FORMNAME from NGBASS_REPORT_INPUT where pid="+reportid+" order by order");
		   sqlca.execute("select REPORT_COLNAME   from NGBASS_REPORT where id="+reportid);
		   String[] colNameArray=null;
		   if(sqlca.next())
		   {
		      colNameArray=sqlca.getString("REPORT_COLNAME").split(",");
		      for(int i=0;i<colNameArray.length;i++)
		      {
		 	%>
					<option value='<%=colNameArray[i]%>'><%=colNameArray[i]%></option>    
	    <%
	         }
	     }
	    %>
	 </select>
</td>
	<td><input type="text" name="valueReg" id="valueReg"  size="100" maxlength="500"/></td>
 	<td>
	<select name="analysOrder" style="width:80" id="order">
		  <option value="">请选择</option>
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
      	<td width=50% align="left">已有指标&nbsp;</td>
		    <td width="50%" align="right">
		       <input type="button" class="form_button2" name="modi2" value="保存编辑" onClick="saveanaly()">&nbsp;	
		    </td>
		  </tr>
	</table>			
<table id="EditAnalyTable" align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" style="display:block">
 <tr class="grid_title_blue">
 	<td width="5%" align="center">编号</td>
  <td width="10%" align="center">字段中文名称</td>
  <td width="30%" align="center">指标规则</td>
  <td width="5%" align="center">排序</td>
  <td width="15%" align="center">操作</td>
</tr>
     <%
					
					 String sqlAnaly="select ID,  FIELDNAME,  VALUEREG, ANALYSORDER  from NGBASS_REPORT_OUTPUT where pid="+reportid+" order by ANALYSORDER,id with ur ";
	         sqlca.execute(sqlAnaly);
					 while(sqlca.next())
					 {
      %>	
         <tr class="grid_row_blue" height="25">
            <td align="left"><%=sqlca.getString("ID")%></td> 
            <td align="left"><%=sqlca.getString("FIELDNAME")%></td> 
            <td align="left"><%=sqlca.getString("VALUEREG")%></td> 
            <td align="left"><%=sqlca.getString("ANALYSORDER")%></td> 
				     <td align="center">
				     <input type="button" class="form_button" name="btmodanaly" value="编辑" onclick="modanaly('<%=sqlca.getString("ID")%>','<%=sqlca.getString("FIELDNAME")%>','<%=sqlca.getString("VALUEREG").replaceAll("'","‘")%>','<%=sqlca.getString("ANALYSORDER")%>')">	&nbsp;
				     <input type="button" class="form_button" name="btdelanaly" value="删除" onclick="delanaly('<%=sqlca.getString("ID")%>')">	     
				    </td>
				  </tr>  
      <%
      }
      %>				 
						 
</table>
<br>

	<!-- 定义分析查询主表、查询条件及分组条件 -->
<table width="98%" border="0" align="center">
<tr><td width=30% align="left">分析定义&nbsp;</td>
	<td width=30% align="center"><div id="modSqlNotic"><font color="red"><%=message%></font></div></td>
	 <td width=35% align="right">
	     <input type="button" class="form_button" name="modanalyCon" value="修改" onclick="modAnalyCon()">&nbsp;
		   <input type="reset" class="form_button" name="cancel3" value="取消">&nbsp;
	 </td>
</tr>
</table>
<%
sqlca.execute("select * from NGBASS_REPORT where id="+reportid);
String reportAnalyQuery2="";
if(sqlca.next())
{
reportAnalyQuery2=sqlca.getString("reportAnalyQuery");
}
%>
<table id="analyConTable" align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" style="display:block">
 <tr class="grid_title_blue">
  <td width="10%" align="center">配置项</td>
  <td width="90%" align="center" colspan="3">值</td>
</tr>
<tr bgcolor="#FFFFFF">
  <td align="center">查询主体</td>
  <td align="center" colspan="3"><textarea name="reportAnalyQuery" cols="120" rows="20"><%=reportAnalyQuery2%></textarea></td>
</tr>
<tr bgcolor="#FFFFFF">
  <td align="center">提示</td>
  <td align="left" colspan="3">如：from NMK.ST_NEWBUSI_INTERSMSMMS_MM   where city_id='#city' </td>
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