<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page import="java.io.PrintWriter"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.net.URLDecoder"%>

<%
	//String collegeCode = (String) request.getParameter("collegeCode");
	String start = (String) request.getParameter("start");
	String limit = (String) request.getParameter("limit");

	int index = Integer.parseInt(start);
	int pageSize = Integer.parseInt(limit);
	int end = index + pageSize;
	Connection conn = null;

	String cityStr = (String) request.getParameter("cityStr");
	String areaStr = (String) request.getParameter("areaStr");
	String bName = (String) request.getParameter("bName");
	String cName = (String) request.getParameter("cName");
	String opType = (String) request.getParameter("opType");
	String status = (String) request.getParameter("status");

	if (StringUtils.isNotEmpty(cityStr)) {
		cityStr = URLDecoder.decode(cityStr, "utf-8");
	}
	if (StringUtils.isNotEmpty(areaStr)) {
		areaStr = URLDecoder.decode(areaStr, "utf-8");
	}
	if (StringUtils.isNotEmpty(bName)) {
		bName = URLDecoder.decode(bName, "utf-8");
	}
	if (StringUtils.isNotEmpty(cName)) {
		cName = URLDecoder.decode(cName, "utf-8");
	}
	if (StringUtils.isNotEmpty(opType)) {
		opType = URLDecoder.decode(opType, "utf-8");
	}
	if (StringUtils.isNotEmpty(status)) {
		status = URLDecoder.decode(status, "utf-8");
	}

	try {
		conn = ConnectionManage.getInstance().getDWConnection();

		StringBuffer buf = null;
		buf = new StringBuffer();

		String countsql = "select count(*) from BUREAU_CFG_COLLEGE_PT where status not in ('FAL') ";

		if (StringUtils.isNotEmpty(cityStr)) {
			//countsql += (" and ucase(AREA_NAME) like '%" + cityStr + "%' ");
			countsql += (" and ucase(COLLEGE_ID) like '" + cityStr + "%' ");
		}
		if (StringUtils.isNotEmpty(areaStr)) {
			countsql += (" and ucase(DEPT_NAME) like '%" + areaStr + "%' ");
		}
		if (StringUtils.isNotEmpty(bName)) {
			countsql += (" and ucase(BUREAU_NAME) like '%" + bName + "%' ");
		}
		if (StringUtils.isNotEmpty(cName)) {
			countsql += (" and ucase(COLLEGE) like '%" + cName + "%' ");
		}
		if (StringUtils.isNotEmpty(status)) {
			countsql += (" and ucase(STATUS) like '" + status + "' ");
		}
		if (StringUtils.isNotEmpty(opType)) {
			countsql += (" and ucase(OPERATE_TYPE) like '" + opType + "' ");
		}

		countsql += " with ur";

		PreparedStatement ps = conn.prepareStatement(countsql);
		ResultSet rs = ps.executeQuery();

		int count = 0;
		if (rs.next()) {
			count = rs.getInt(1);
		}
		if (count > 0) {
			String sql = " select aaa.* from (select   BUREAU_ID ,  BUREAU_NAME ,  COLLEGE ,  AREA_NAME ,  DEPT_NAME , "
					+ " COLLEGE_ID ,  CREATE_DATE ,  (case when OPERATE_TYPE = 'INSERT' then '新增' ELSE '删除' END) ,"
					+ " (case when STATUS = 'SUC' then '已绑定' when STATUS = 'OUT_ADUIT_0' then '（删除）被回退' when STATUS = 'IN_ADUIT_1' then '（新增）待一级审核' when STATUS = 'IN_ADUIT_2' then '（新增）待二级审核' when STATUS = 'IN_ADUIT_3' then '（新增）待三级审核' when STATUS = 'OUT_ADUIT_1' then '（删除）待一级审核' when STATUS = 'OUT_ADUIT_2' then '（删除）待二级审核' when STATUS = 'OUT_ADUIT_3' then '（删除）待三级审核' ELSE '' END),"
					+ " STATE_DATE ,  CREATEUSER ,OPERATE_TYPE,STATUS,"
					+ " row_number() over(partition by 1 ORDER BY AREA_NAME,DEPT_NAME DESC) as row_num"
					+ " from BUREAU_CFG_COLLEGE_PT where status not in ('FAL') ";

			if (StringUtils.isNotEmpty(cityStr)) {
				//sql += (" and ucase(AREA_NAME) like '%" + cityStr + "%' ");
				sql += (" and ucase(COLLEGE_ID) like '" + cityStr + "%' ");
			}
			if (StringUtils.isNotEmpty(areaStr)) {
				sql += (" and ucase(DEPT_NAME) like '%" + areaStr + "%' ");
			}
			if (StringUtils.isNotEmpty(bName)) {
				sql += (" and ucase(BUREAU_NAME) like '%" + bName + "%' ");
			}
			if (StringUtils.isNotEmpty(cName)) {
				sql += (" and ucase(COLLEGE) like '%" + cName + "%' ");
			}
			if (StringUtils.isNotEmpty(status)) {
				sql += (" and ucase(STATUS) like '" + status + "' ");
			}
			if (StringUtils.isNotEmpty(opType)) {
				sql += (" and ucase(OPERATE_TYPE) like '" + opType + "' ");
			}
			sql += " ) aaa where row_num > " + index + " and row_num <= "
					+ end + " with ur";

			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();

			buf.append("{Total:").append(count).append(",Info:[");

			for (int i = 0; rs.next(); i++) {
				if (i != 0) {
					buf.append(",");
				}
				buf.append("{BUREAU_ID:'").append(rs.getString(1))
						.append("',BUREAU_NAME:'").append(
								rs.getString(2)).append("',COLLEGE:'")
						.append(rs.getString(3))
						.append("',AREA_NAME:'")
						.append(rs.getString(4))
						.append("',DEPT_NAME:'")
						.append(rs.getString(5)).append(
								"',COLLEGE_ID:'").append(
								rs.getString(6)).append(
								"',CREATE_DATE:'")
						.append(rs.getDate(7)).append(
								"',OPERATE_TYPE_STR:'").append(
								rs.getString(8)).append(
								"',STATUS_STR:'").append(
								rs.getString(9)).append(
								"',STATE_DATE:'")
						.append(rs.getDate(10))
						.append("',CREATEUSER:'").append(
								rs.getString(11)).append(
								"',OPERATE_TYPE:'").append(
								rs.getString(12)).append("',STATUS:'")
						.append(rs.getString(13)).append("'}");
			}

			buf.append("]}");
		} else {
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
