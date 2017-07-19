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

/* 增加查询条件 */
String formType=request.getParameter("formType")==null?"":request.getParameter("formType");
String formTagName=request.getParameter("formTagName")==null?"":request.getParameter("formTagName");
String formName=request.getParameter("formName")==null?"":request.getParameter("formName");
formName=new String(formName.getBytes("ISO-8859-1"),"gb2312");
String formId=request.getParameter("formId")==null?"":request.getParameter("formId");
String dataformat=request.getParameter("dataformat")==null?"":request.getParameter("dataformat");
dataformat=new String(dataformat.getBytes("ISO-8859-1"),"gb2312");
String sqlreg=request.getParameter("sqlreg")==null?"":request.getParameter("sqlreg");
sqlreg=sqlreg.replaceAll("'","''");
String order=request.getParameter("order")==null?"":request.getParameter("order");

/*删除查询条件*/
String delid=request.getParameter("delid")==null?"":request.getParameter("delid");
/* 修改查询条件*/
String modid=request.getParameter("modid")==null?"":request.getParameter("modid");

/* 定义操作结果信息 */
String message="";

Sqlca sqlca=null;
try
{
	sqlca = new Sqlca(new ConnectionEx("JDBC_HB"));
	/* 增加一个查询条件 */
	if(oper.equals("addquery"))
	{
	   if(!order.equals(""))
	   {
	     sqlca.execute("insert into NGBASS_REPORT_INPUT(PID, FORMTYPE, FORMNAME, FORMID,dataformat, SQLREG,TAGNAME,ORDER) values("+reportid+",'"+formType+"','"+formName+"','"+formId+"','"+dataformat+"','"+sqlreg+"','"+formTagName+"',"+order+")");
	   }
	   else
	   {	
	 	   sqlca.execute("insert into NGBASS_REPORT_INPUT(PID, FORMTYPE, FORMNAME, FORMID,dataformat, SQLREG,TAGNAME,ORDER) values("+reportid+",'"+formType+"','"+formName+"','"+formId+"','"+dataformat+"','"+sqlreg+"','"+formTagName+"',(select value(max(order)+1,1) from     NGBASS_REPORT_INPUT where pid="+reportid+" ))");
	   }
	     message="新增查询条件成功！";
	}
	/* 删除一个查询条件 */
	else if(oper.equals("delquery"))
	{
	   sqlca.execute("delete from  NGBASS_REPORT_INPUT where id="+delid);
	    message="删除查询条件成功！";
	}
	/* 删除一个查询条件 */
	else if(oper.equals("modiquery"))
	{
	   sqlca.execute("update NGBASS_REPORT_INPUT set FORMTYPE='"+formType+"',dataformat='"+dataformat+"',FORMNAME='"+formName+"',FORMID='"+formId+"', SQLREG='"+sqlreg+"',tagname='"+formTagName+"',order="+order+" where id="+modid);
	   message="修改查询条件成功！";
	}

%>
<body>
<form name="form1" method="post" action="">
	<input type="hidden" name="reportid" value="<%=reportid%>">
	<input type="hidden" name="reportname" value="<%=reportname%>">
	<input type="hidden" name="modid" value="">
	<!-- 查询条件定义 -->
<table width="98%" border="0" align="center">
<tr><td width=50% align="left">查询条件配置</td>
	 <td width=50% align="right">
	     <input type="button" class="form_button" name="addform" value="添加" onClick="addquery()">&nbsp;
		   <input type="reset" class="form_button" name="down1" value="取消">&nbsp;
	 </td>
</tr>
</table>
<table id="queryTable" align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
 <tr class="grid_title_blue">
  <td width="10%" align="center">表单类型</td>
  <td width="15%" align="center">可选表单</td>
  <td width="15%" align="center">表单名称</td>
  <td width="10%" align="center">表单ID</td>
  <td width="40%" align="center">表单应用规则</td>
  <td width="5%" align="center">排序</td>
</tr>
<tr bgcolor="#FFFFFF">
  <td>
    <select name="formType" style="width:120" id="formType" onchange="freshSelect(this.value,'formList')">
      <option value="time">时间</option>
      <option value="select">下拉框(ng)</option>
      <option value="select2">下拉框(2.0)</option>
      <option value="input">输入文本框</option>
      <option value="yesno">是否开关</option>
    </select>	
  </td>
  <td>
  	<div id="formListDiv">
     <select name="formList" id="formList" style="width:180" onchange="setFormName(this.selectedIndex)">
     	   <option value="">请选择</option>
				<%
				 String sql1="select TAGNAME,NAME from DIM_NGBASS_FORM_TYPE where FORMTYPE='time' order by order with ur ";
				 sqlca.execute(sql1);
				 while(sqlca.next())
				 {
				%>
				 <option value="<%=sqlca.getString("TAGNAME")%>"><%=sqlca.getString("NAME")%></option>
				<%
				 }
				%>
		</select>
     <div>	
  </td>
	<td><input type="text" name="formName" id="formName" size="20" maxlength="20"/></td>
	<td><input type="text" name="formId" id="formId"  size="12" maxlength="12"/></td>
	<input type="hidden" name="dataformat" id="dataformat" />
	<input type="hidden" name="formTagName" id="formTagName" value=""/>
	<td><input type="text" name="sqlreg" id="sqlreg"  size="60" maxlength="600"/></td>
	<td>
	<select name="order" style="width:80" id="order">
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
      	<td width=20% align="left">已有查询条件</td>
      	<td align="center"><div id="modSqlNotic"><font color="red"><%=message%></font></div></td>
		    <td width="20%" align="right">
		       <input type="button" class="form_button2" name="modi2" value="保存编辑" onClick="savequery()">&nbsp;	
		    </td>
		  </tr>
	</table>							  

   <table id="editQueryTable" align="center" width="98%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0" style="display:block">
    <tr class="grid_title_blue">
    	<td width="5%" align="center">编号</td>
    	<td width="10%" align="center">表单类型</td>
	    <td width="15%" align="center">表单名称</td>
	   
	    <td width="15%" align="center">表单ID</td>
	    <td width="20%" align="center">表单应用规则</td> 
	    <td width="5%" align="center">排序</td>
	    <td width="15%" align="center">操作</td>
	  </tr>
           <%
						 sqlca.execute("select ID, PID, FORMTYPE,case when FORMTYPE='select2' then '下拉框(2.0)' when FORMTYPE='select' then '下拉框(ng)'  when FORMTYPE='input' then '输入文本框' when FORMTYPE='time' then '时间' when FORMTYPE='yesno' then '是否开关' end FORMTYPE2,dataformat, FORMNAME, FORMID, SQLREG,tagname,order   from NGBASS_REPORT_INPUT where pid="+reportid+" order by order ");
						 String id_t="";
						 String FORMNAME_t="";
						 String FORMTYPE_t="";
						 String dataformat_t="";
						 String FORMID_t="";
						 String SQLREG_t="";
						 String order_t="";
						 String tagname_t="";
						 
						 while(sqlca.next())
						 {
						    id_t=sqlca.getString("id");
						    FORMNAME_t=sqlca.getString("FORMNAME");
						    FORMTYPE_t=sqlca.getString("FORMTYPE2");
						    dataformat_t=sqlca.getString("dataformat");
						    FORMID_t=sqlca.getString("FORMID");
						    SQLREG_t=sqlca.getString("SQLREG");
						    order_t=sqlca.getString("order");
						    tagname_t=sqlca.getString("tagname");
						%>
			   	  <tr class="grid_row_blue" height="25">
			   	   <td align="left"><%=id_t%></td>
			   	   <td align="left"><%=FORMTYPE_t%></td>
				     <td align="left"><%=FORMNAME_t%></td>
				     
				     <td align="left"><%=FORMID_t%></td>
				     <td align="left"><%=SQLREG_t%></td> 
				     <td align="left"><%=order_t%></td> 
				     <td align="center">
				     <input type="button" class="form_button" name="btmod" value="编辑" onclick="modquery('<%=id_t%>','<%=sqlca.getString("FORMTYPE")%>','<%=dataformat_t%>','<%=FORMNAME_t%>','<%=FORMID_t%>','<%=SQLREG_t.replaceAll("'","‘")%>','<%=order_t%>','<%=tagname_t%>')">	&nbsp; 
				     <input type="button" class="form_button" name="btdel" value="删除" onclick="delquery('<%=sqlca.getString("ID")%>')">	     
				    </td>
				  </tr>
					<%
					}
					%>
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