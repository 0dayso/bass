<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page import="java.io.PrintWriter"%>

<%
	String collegeCode = (String) request.getParameter("collegeCode");
	String start = (String) request.getParameter("start");
	String limit = (String) request.getParameter("limit");

	int index = Integer.parseInt(start);
	int pageSize = Integer.parseInt(limit);
	int end = index + pageSize;
	Connection conn = null;
	
	try {
		conn = ConnectionManage.getInstance().getDWConnection();

		String countsql = "select count(*) from BUREAU_CFG_COLLEGE_PT where college_id = '"
				+ collegeCode + "' with ur";

		PreparedStatement ps = conn.prepareStatement(countsql);
		ResultSet rs = ps.executeQuery();

		StringBuffer buf = null;
		buf = new StringBuffer();

		int count = 0;
		if (rs.next()) {
			count = rs.getInt(1);
		}
		if (count > 0) {
			String sql = "select aaa.* from (select bureau_id, bureau_name, (select college_name from nwh.college_info where college_Id=t.college_id and state=1) college, college_id,"
				+ " (case when STATUS = 'SUC' then '已绑定' when STATUS = 'IN_ADUIT_1' then '（新增）待一级审核' when STATUS = 'IN_ADUIT_2' then '（新增）待二级审核' when STATUS = 'IN_ADUIT_3' then '（新增）待三级审核' when STATUS = 'OUT_ADUIT_0' then '（删除）被回退' when STATUS = 'OUT_ADUIT_1' then '（删除）待一级审核' when STATUS = 'OUT_ADUIT_2' then '（删除）待二级审核' when STATUS = 'OUT_ADUIT_3' then '（删除）待三级审核' ELSE '' END),"
					+" (case when OPERATE_TYPE = 'INSERT' then '新增' ELSE '删除' END),STATE_DATE,CREATEUSER,"
					+" row_number() over(partition by 1 order by bureau_name) as row_num from BUREAU_CFG_COLLEGE_PT t where STATUS <> 'FAL' and college_id = '"
					+ collegeCode
					+ "') aaa where row_num > "
					+ index
					+ " and row_num <= "+end+" with ur";
					
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			buf.append("{Total:").append(count).append(",Info:[");

			for (int i = 0; rs.next(); i++) {
				if (i != 0) {
					buf.append(",");
				}
				buf.append("{bCode:'").append(rs.getString(1)).append("',bName:'")
						.append(rs.getString(2)).append("',cName:'").append(rs.getString(3))
						.append("',cCode:'").append(rs.getString(4)).append(
								"',status:'").append(rs.getString(5)).append(
								"',opType:'").append(rs.getString(6)).append(
								"',stDate:'").append(rs.getDate(7)).append(
								"',opUser:'").append(rs.getString(8)).append("'}");
			}

			buf.append("]}");
		}else {
			buf.append("{Total:0,Info:[]}");
		}
		
		rs.close();
		ps.close();

		PrintWriter outs = null;
		outs = response.getWriter();
		outs.write(buf.toString());
	} catch (SQLException e) {
		e.printStackTrace();
	} finally {
		if (conn != null)
			conn.close();
	}
%>
