<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryBase, java.util.*"%>
<%@ page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage" %>
<%@ page import="java.sql.Connection" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbapp/resources/css/default/default.css" />
  </head>
  <script type="text/javascript">
<%
Connection conn=null;
List list = null;
try{	
    conn = ConnectionManage.getInstance().getWEBConnection();
	SQLQueryBase queryBase = new SQLQueryBase();
	queryBase.setConnection(conn);
	String userid = request.getParameter("userid");
	String condition ="";
	if(null!=userid){
		condition=" and b.userid='" + userid+"'";
	}
		
	String sql = "select b.userid,a.loginname,char(a.timeid) timeid,a.content from syslog a,FPF_USER_USER b where a.loginname=b.username and optype='修改角色资源信息' "+condition +" and LOCATE('修改后',content)>0 and LOCATE('修改前',content)>0 fetch first 500 row only";
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
  </script>
  <body>
  <form method="post" action="roleRightChangeLog.jsp">
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'dim_div')" title="点击隐藏"><img flag='1' href="${mvcPath}/hb-bass-primary/image/default/ns-expand.gif"></img>&nbsp;查询条件区域：</td>
	</tr></table></legend>
	<div id="dim_div">
		<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'><tr class='dim_row'><td class='dim_cell_title'>操作帐号</td><td class='dim_cell_content'><dim id='aidim_userid' name='userid' dbName="a.userid" operType="varchar"><input type='text' name='userid'></dim></td><td class='dim_cell_title'></td><td class='dim_cell_content'></td><td class='dim_cell_title'></td><td class='dim_cell_content'></td></tr></table>
	<table align="center" width="99%">
		<tr class="dim_row_submit">
			<td><span id="tipDiv"></span></td>
			<td align="right">
				<div id="Btn"><input id="btn_query" type="submit" class="form_button" value="查询" ></div>
			</td>
		</tr>
	</table>
	</div>
</fieldset>
</div>
<div class="divinnerfieldset">
<fieldset>
	<legend><table><tr>
		<td onclick="hideTitle(this.childNodes[0],'show_div')" title="点击隐藏"><img flag='1' href="${mvcPath}/hb-bass-primary/image/default/ns-expand.gif"></img>&nbsp;数据展现区域：</td>
		<td></td>
	</tr></table></legend>
	<div id="gridBtn" style="display:none;"></div>
	<div id="grid" style="display:none;"></div>
</fieldset>
</div>
<div class="divinnerfieldset" id="chartMain" style="display:none;">
<fieldset>
	<legend><table><tr>
		<td title="点击隐藏" onclick="hideTitle(document.getElementById('chart_div_img'),'chart_div')"><img id="chart_div_img" flag='1' href="${mvcPath}/hb-bass-primary/image/default/ns-expand.gif"></img>&nbsp;图形展现区域：</td>
		<td></td>
	</tr></table></legend>
	
	<div id="chart_div" style="display: none;">
	<div style="float: left;margin: 5px;"><select id="chart_oper" multiple="multiple" size="11" style="width:160px;"></select></div>
	<div style="float: left;" id="chart"></div>
	</div>
</fieldset>
</div>
</form>
  
  
		 <TABLE class=grid-tab-blue border=0 cellSpacing=1 cellPadding=0 width="99%" align=center>
<THEAD>
<TR class=grid_title_blue>
<TD class=grid_title_cell><A id=userid title=点击排列 href="javascript:void(0)" >操作帐号</A></TD>
<TD class=grid_title_cell><A id=timeid title=点击排列 href="javascript:void(0)" >操作时间</A></TD>
<TD class=grid_title_cell><A id=group_name title=点击排列 href="javascript:void(0)" >角色名称</A></TD>
<TD class=grid_title_cell><A id=content title=点击排列 href="javascript:void(0)" >更改前权限</A></TD>
<TD class=grid_title_cell><A id=content1 title=点击排列 href="javascript:void(0)" >更改后权限</A></TD>
</TR>
</THEAD>
<TBODY>
<%
  	for(int i = 0; i < list.size(); i++) {
  		HashMap lines = (HashMap)list.get(i);
  %>
  <TR class="grid_row_blue grid_row_over_blue">
<TD class=grid_row_cell_text><%=lines.get("userid") %></TD>
<TD class=grid_row_cell_text><%=lines.get("timeid") %></TD>
<TD class=grid_row_cell_text><%=lines.get("content").toString().split("修改前：")[0] %></TD>
<TD class=grid_row_cell_text><%=lines.get("content").toString().split("修改前：")[1].split("修改后：")[0].length()>50?lines.get("content").toString().split("修改前：")[1].split("修改后：")[0].substring(0, 50):lines.get("content").toString().split("修改前：")[1].split("修改后：")[0] %></TD>
<TD class=grid_row_cell_text><%=lines.get("content").toString().split("修改后")[1]%></TD>
</TR>
	<%  	
		}
 %>	
 <TBODY>
	</table>
	
</body>
</html>

