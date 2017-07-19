<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page import="java.io.PrintWriter"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.asiainfo.hb.web.models.User"%>
<%@page import="org.apache.log4j.Logger"%>

<%!
static Logger LOG = Logger.getLogger("com.asiainfo.college_list_info.jsp");
%>
<%
	String collegeCode = (String) request.getParameter("collegeCode");
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

		User user = (User) request.getSession().getAttribute("user");

		if (user == null) {
			user = new User();
		}

		PreparedStatement ps = null;
		ResultSet rs = null;

		//判断当前登陆人权限
		String auditSql = "SELECT VALUE(AREA_CODE,'') FROM mk.bt_area AREA WHERE TRIM(CHAR(AREA.AREA_ID)) = '"
				+ user.getCityId().trim() + "'";
		LOG.info("auditSql="+auditSql);
		ps = conn.prepareStatement(auditSql);
		rs = ps.executeQuery();

		if (rs.next()) {
			user.setRegionId(rs.getString(1));
		}
		if (user.getRegionId() == null || "".equals(user.getRegionId()) || user.getRegionId().length() < 5) {
			user.setRegionId("HB.00");
		}
		
		String userCityId = user.getRegionId().substring(0, 5);
		String userId = user.getId();
		LOG.info(userId);
		
		String countsql = "";
		if(userId.equals("meikefu")){
			countsql = "select count(*) from COLLEGE_INFO_PT where STATE = 1 AND STATUS <> 'FAL'  ";
		}else{
			countsql = "select count(*) from COLLEGE_INFO_PT where STATE = 1 AND STATUS <> 'FAL' AND AREA_ID = '"
				+ userCityId + "' ";
		}

		if (StringUtils.isNotEmpty(cityStr)) {
			countsql += (" and ucase(AREA_ID) like '%" + cityStr + "%' ");
		}
		if (StringUtils.isNotEmpty(areaStr)) {
			countsql += (" and ucase(COLLEGE_ADD) like '%" + areaStr + "%' ");
		}
		if (StringUtils.isNotEmpty(bName)) {
			countsql += (" and ucase(COLLEGE_ID) like '%"
					+ bName.toUpperCase() + "%' ");
		}
		if (StringUtils.isNotEmpty(cName)) {
			countsql += (" and ucase(COLLEGE_NAME) like '%" + cName + "%' ");
		}
		if (StringUtils.isNotEmpty(status)) {
			countsql += (" and ucase(STATUS) like '" + status + "' ");
		}
		if (StringUtils.isNotEmpty(opType)) {
			countsql += (" and ucase(OPERATE_TYPE) like '" + opType + "' ");
		}
		countsql += " with ur";
		LOG.info("countsql="+countsql);
		ps = conn.prepareStatement(countsql);
		rs = ps.executeQuery();

		StringBuffer buf = null;
		buf = new StringBuffer();

		int count = 0;
		if (rs.next()) {
			count = rs.getInt(1);
		}

		if (count > 0) {
			String sql = " select aa.* from (select COLLEGE_ID, COLLEGE_NAME, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
					+ " SHORT_NUMBER, AREA_ID, MANAGER, STUDENTS_NUM, NEW_STUDENTS, "
					+ " STATE_DATE, MANAGER_NBR, "
					+ " CREATE_DATE, (case when OPERATE_TYPE = 'INSERT' then '新增' when OPERATE_TYPE = 'UPDATE' then '修改' ELSE '删除' END) ,"
					+ " (case when STATUS = 'SUC' then '已生效' when STATUS = 'IN_ADUIT_1' then '（新增）待一级审核' when STATUS = 'IN_ADUIT_2' then '（新增）待二级审核' when STATUS = 'IN_ADUIT_3' then '（新增）待三级审核' when STATUS = 'OUT_ADUIT_1' then '（删除）待一级审核' when STATUS = 'OUT_ADUIT_2' then '（删除）待二级审核' when STATUS = 'OUT_ADUIT_3' then '（删除）待三级审核' when STATUS = 'UPD_ADUIT_1' then '（修改）待一级审核' when STATUS = 'UPD_ADUIT_2' then '（修改）待二级审核' when STATUS = 'UPD_ADUIT_3' then '（修改）待三级审核' ELSE '' END),"
					+ " CREATEUSER,(select cc.AREA_NAME from mk.bt_area cc where cc.AREA_CODE = bb.AREA_ID),"
					+ " row_number() over(partition by 1 ORDER BY AREA_ID,COLLEGE_ID DESC) as row_num"
					+ " from COLLEGE_INFO_PT bb where STATE=1 AND STATUS <> 'FAL'" ;
			if(!userId.equals("meikefu")){
				sql = sql + "AND AREA_ID = '" + userCityId + "' ";
			}
			if (StringUtils.isNotEmpty(cityStr)) {
				sql += (" and ucase(bb.AREA_ID) like '%" + cityStr + "%' ");
			}
			if (StringUtils.isNotEmpty(areaStr)) {
				sql += (" and ucase(COLLEGE_ADD) like '%" + areaStr + "%' ");
			}
			if (StringUtils.isNotEmpty(bName)) {
				sql += (" and ucase(COLLEGE_ID) like '%"
						+ bName.toUpperCase() + "%' ");
			}
			if (StringUtils.isNotEmpty(cName)) {
				sql += (" and ucase(COLLEGE_NAME) like '%" + cName + "%' ");
			}
			if (StringUtils.isNotEmpty(status)) {
				sql += (" and ucase(STATUS) like '" + status + "' ");
			}
			if (StringUtils.isNotEmpty(opType)) {
				sql += (" and ucase(OPERATE_TYPE) like '" + opType + "' ");
			}

			sql += " ) aa where row_num > " + index + " and row_num <= "
					+ end + " with ur";
					
			LOG.info("基站查询SQL："+sql);

			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();

			buf.append("{Total:").append(count).append(",Info:[");

			for (int i = 0; rs.next(); i++) {
				if (i != 0) {
					buf.append(",");
				}
				buf.append("{COLLEGE_ID:'").append(rs.getString(1))
						.append("',COLLEGE_NAME:'").append(
								rs.getString(2)).append("',WEB_ADD:'")
						.append(rs.getString(3)).append(
								"',COLLEGE_TYPE:'").append(
								rs.getString(4)).append(
								"',COLLEGE_ADD:'").append(
								rs.getString(5)).append(
								"',SHORT_NUMBER:'").append(
								rs.getString(6)).append("',AREA_ID:'")
						.append(rs.getString(7)).append("',MANAGER:'")
						.append(rs.getString(8)).append(
								"',STUDENTS_NUM:'")
						.append(rs.getInt(9))
						.append("',NEW_STUDENTS:'").append(
								rs.getInt(10)).append("',STATE_DATE:'")
						.append(rs.getDate(11)).append(
								"',MANAGER_NBR:'").append(
								rs.getString(12)).append(
								"',CREATE_DATE:'").append(
								rs.getDate(13)).append(
								"',OPERATE_TYPE:'").append(
								rs.getString(14)).append("',STATUS:'")
						.append(rs.getString(15)).append(
								"',CREATEUSER:'").append(
								rs.getString(16)).append(
								"',AREA_ID_STR:'").append(
								rs.getString(17)).append("'}");
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
