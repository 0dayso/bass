<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase, java.util.*"%>
<%@ page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage" %>
<%@ page import="java.sql.Connection" %>
<%
Connection conn=null;
List list = null;
try{	
    conn = ConnectionManage.getInstance().getWEBConnection();
	SQLQueryBase queryBase = new SQLQueryBase();
	queryBase.setConnection(conn);
	String zb_code = request.getParameter("zb_code");
	String zb_name = request.getParameter("zb_name");
	String condition ="";
	if(null!=zb_name){
		condition=" and zb_name like '%" + zb_name+"%'";
	}
	if(null!=zb_code){
		condition+=" and zb_code like '%" + zb_code+"%'";
	}
		
	String sql = "select zb_code,zb_name,zb_unit_name,remark,zb_where from stat_zb_def where 1=1 "+condition +" order by zb_code";
	list = (List)queryBase.query(sql);
}catch(Exception e)
{
	e.printStackTrace();
}
finally
{
	//连接已经在query方法释放过了，这里不用再释放了。
}	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/app/jquery.js" />
  </head>
  <script type="text/javascript">
alert($("#tbody"));
$(function(){ 
	alert(11);
	//alert($("#tbody tr"))
	//$("#tbody tr").quickpaginate({ perpage: 20, pager : $("#pager") }); 
}); 
</script> 

  </script>
  <body>
 <form method="post" action="kpiInfoQuery.jsp">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏"><img flag='1' href="${mvcPath}/hb-bass-primary/image/default/ns-expand.gif"></img>&nbsp;查询条件区域：</td>
	</tr></table></legend>
	<div id="dim_div">
		<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'><tr class='dim_row'><td class='dim_cell_title'>指标标识</td><td class='dim_cell_content'><dim id='aidim_zb_code' name='zb_code' dbName="zb_code" operType="varchar"><input type='text' name='zb_code'></dim></td><td class='dim_cell_title'>指标名称</td><td class='dim_cell_content'><dim id='aidim_zb_name' name='zb_name' dbName="zb_name" operType="varchar"><input type='text' name='zb_name'></dim></td><td class='dim_cell_title'></td><td class='dim_cell_content'></td></tr></table>
	<table align="center" width="99%" border=0>
		<tr class="dim_row_submit">
			<td><span id="tipDiv"></span></td>
			<td align="right">
				<div id="Btn"><input id="btn_query" type="submit" class="form_button" value="查询" ></div>
			</td>
		</tr>
	</table>
	</div>
</fieldset>
</form>
<TABLE id="data" class=grid-tab-blue border=0 cellSpacing=1 cellPadding=0  width=99% align=left>
<thead>
<tr class=grid_title_blue>
<TD class=grid_title_cell width="">指标标识</TD>
<TD class=grid_title_cell width="200" align=left>指标名称</TD>
<TD class=grid_title_cell width="80">度量单位</TD>
<TD class=grid_title_cell width="">业务口径</TD>
<TD class=grid_title_cell style="word-wrap:break-word;"  width="650">指标统计语句</TD>
</tr>
</thead>
<tbody id="tbody">
<%
  	for(int i = 0; i < list.size(); i++) {
  		HashMap lines = (HashMap)list.get(i);
  %>
  <TR class="grid_row_blue grid_row_over_blue" width="99%">
<TD  class=grid_title_cell style="text-align:left" width=""><%=lines.get("zb_code") %></TD>
<TD  class=grid_title_cell style="text-align:left" width="200"><%=lines.get("zb_name") %></TD>
<TD  class=grid_title_cell style="text-align:left" width="80"><%=lines.get("zb_unit_name") %></TD>
<TD  class=grid_title_cell style="text-align:left" width=""><%=lines.get("remark")%></TD>
<TD  class=grid_title_cell style="word-wrap:break-word;text-align:left" width="650"><%=lines.get("zb_where")%></TD>
</TR>
	<%  	
		}
 %>	
 </tbody>
 <div id="pager"></div> 
</table>	
</body>
</html>

