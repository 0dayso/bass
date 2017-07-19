<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="bass.common.SQLSelect, java.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<script type="text/javascript" src="${mvcPath}/hbbass/common2/basscommon.js" charset=utf-8></script>
	<link rel="stylesheet" type="text/css" href="${mvcPath}/hbbass/css/bass21.css" />
  </head>
  <script type="text/javascript">
<% 
	
	String college_id = request.getParameter("college_id");
	SQLSelect select = new SQLSelect();
	String condition = " where college_id='" + college_id + "'";
	String sql = "select college_id, college_name, web_add, college_type, college_add, short_number, area_id, manager, students_num, new_students, channel_code, value(state_date,eff_date)" + 
	" from NWH.COLLEGE_INFO " + condition + " with ur";
	
	System.out.println("the sql : " + sql);
	List list = select.getTotalList(sql);
%>
  </script>
  <body>
  
  <%-- 改成迭代版 --%>
  <%
  	for(int i = 0; i < list.size(); i++) {
  		String[] lines = (String[])list.get(i);
  %>
  		 <table align="center" width="99%" class="grid-tab-blue" cellspacing="1" cellpadding="0" border="0">
			<tr class="dim_row">
				<td class="dim_cell_title">高校编码</td>
				<td class="dim_cell_content"><%=lines[0] %></td>
				<td class="dim_cell_title" >高校名称</td>
				<td class="dim_cell_content"><%=lines[1] %></td>
				<td class="dim_cell_title" >高校网址</td>
				<td class="dim_cell_content"><%=lines[2] %></td>
			</tr>
			<tr class="dim_row">
				<td class="dim_cell_title">学校类型</td>
				<td class="dim_cell_content"><%=lines[3] %></td>
				<td class="dim_cell_title">学校地址</td>
				<td class="dim_cell_content"><%=lines[4] %></td>
				<td class="dim_cell_title">V网短号码</td>
				<td class="dim_cell_content"><%=lines[5] %></td>
				</tr>
				<tr class="dim_row">
				<td class="dim_cell_title">所在地市</td>
				<td class="dim_cell_content"><%=lines[6] %></td>
				<td class="dim_cell_title">高校片区经理</td>
				<td class="dim_cell_content"><%=lines[7] %></td>
				<td class="dim_cell_title">学生人数</td>
				<td class="dim_cell_content"><%=lines[8] %></td>
				</tr>
			
				<tr class="dim_row">
				<td class="dim_cell_title">本年度招生人数</td>
				<td class="dim_cell_content"><%=lines[9] %></td>
				<td class="dim_cell_title">高校渠道</td>
				<td class="dim_cell_content"><%=lines[10] %></td>
				<td class="dim_cell_title">信息更新时间</td>
				<td class="dim_cell_content"><%=lines[11] %></td>
				</tr>
		</table>
<%  	
		}
 %>
		  
		
		
		
		
  <%@ include file="/hbbass/common2/loadmask.htm"%></body>
</html>
<%!
	public static String percentFormat(String value)
	{
		double num = Double.parseDouble(value);
		int digit = 2;
		String[] ary = ((num * 100) + "").split("\\.");
		String post = "";
		if (ary.length == 2)
		{
			post = ary[1];
			if (ary[1].length() > digit)
			{
				int nextnum = Integer.parseInt(ary[1].substring(digit,digit + 1));
				int curnum = Integer.parseInt(ary[1].substring(0, digit));
				if (nextnum >= 5)curnum = curnum + 1;

				if (curnum < 10)
					post = "0" + curnum;
				else
					post = curnum + "";

				if (post.length() > digit)
				{
					post = post.substring(1, digit + 1);
					int per = Integer.parseInt(ary[0]) + 1;
					ary[0] = per + "";
				}
			}
		}
		String result = ary[0];
		if (post.length() > 0)
			result += "." + post;

		return result + "%";
	}

%>
