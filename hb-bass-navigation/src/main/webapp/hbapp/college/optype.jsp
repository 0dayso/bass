<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="java.io.PrintWriter"%>

<%
	String optype = (String) request.getParameter("optype");
	String collegeCode = (String) request.getParameter("collegeCode");
	String bureauCode = (String) request.getParameter("bureauCode");
	String userid = (String) session.getAttribute("loginname");
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
		conn = ConnectionManage.getInstance().getDWConnection();
		conn.setAutoCommit(false);
		if ("insert".equals(optype)) {
			String collegeName = (String) request
					.getParameter("collegeName");
			if (StringUtils.isNotEmpty(collegeName)) {
				collegeName = URLDecoder.decode(collegeName, "utf-8");
			}

			String insertCode = (String) request
					.getParameter("insertCode");

			String insertSql = "INSERT INTO  BUREAU_CFG_COLLEGE_PT(BUREAU_ID, BUREAU_NAME, COLLEGE, AREA_NAME, DEPT_NAME, "
					+ " COLLEGE_ID, LONGITUDE, LATITUDE, EFF_DATE, EXP_DATE,  "
					+ " CREATE_DATE, OPERATE_TYPE, STATUS, STATE_DATE, CREATEUSER) "
					+ " SELECT BUREAU_ID, BUREAU_NAME, '"
					+ collegeName
					+ "', "
					+ " AREA_NAME, COUNTY_NAME, '"
					+ collegeCode.toUpperCase()
					+ "',"
					+ " LONGITUDE, LATITUDE, EFF_DATE, EXP_DATE,current timestamp, 'INSERT', 'IN_ADUIT_1', CURRENT TIMESTAMP, '"
					+ userid
					+ "' "
					+ " FROM  NWH.DIM_BUREAU_CFG WHERE BUREAU_ID in ("
					+ insertCode.toUpperCase() + ")";

			ps = conn.prepareStatement(insertSql);
			int isSuc = ps.executeUpdate();

			String insertLogSql = "INSERT INTO  BUREAU_CFG_COLLEGE_PT_LOG(BUREAU_ID, BUREAU_NAME, COLLEGE, AREA_NAME, DEPT_NAME, "
					+ " COLLEGE_ID, LONGITUDE, LATITUDE, EFF_DATE, EXP_DATE,  "
					+ " CREATE_DATE, OPERATE_TYPE, STATUS, STATE_DATE, CREATEUSER) "
					+ " SELECT BUREAU_ID, BUREAU_NAME, '"
					+ collegeName
					+ "', "
					+ " AREA_NAME, COUNTY_NAME, '"
					+ collegeCode.toUpperCase()
					+ "',"
					+ " LONGITUDE, LATITUDE, EFF_DATE, EXP_DATE,current timestamp, 'INSERT', 'IN_NEW', CURRENT TIMESTAMP, '"
					+ userid
					+ "' "
					+ " FROM  NWH.DIM_BUREAU_CFG WHERE BUREAU_ID in ("
					+ insertCode.toUpperCase() + ")";

			ps = conn.prepareStatement(insertLogSql);
			ps.execute();

			PrintWriter outs = null;
			StringBuffer buf = null;

			outs = response.getWriter();
			buf = new StringBuffer();

			if (isSuc > 0) {
				buf
						.append("{Info:[{count:'0',msg:'高校与基站关系新增成功，状态更新为（新增）待一级审核！'}]}");
			} else {
				buf.append("{Info:[{count:'0',msg:'高校与基站关系新增失败！'}]}");
			}
			outs.write(buf.toString());
		}

		if ("delete".equals(optype)) {
			String deleteCode = (String) request
					.getParameter("deleteCode");

			String deleteSql = "update BUREAU_CFG_COLLEGE_PT set"
					+ " OPERATE_TYPE = 'DELETE',STATUS='OUT_ADUIT_1',STATE_DATE=current timestamp,CREATE_DATE=current timestamp,CREATEUSER='"
					+ userid + "'"
					+ " where  STATUS <> 'FAL' and BUREAU_ID in ("
					+ deleteCode.toUpperCase() + ")"
					+ " and COLLEGE_id = '" + collegeCode.toUpperCase()
					+ "'";

			ps = conn.prepareStatement(deleteSql);
			int isSuc = ps.executeUpdate();

			String insertLogSql = "INSERT INTO  BUREAU_CFG_COLLEGE_PT_LOG(BUREAU_ID, BUREAU_NAME, COLLEGE, AREA_NAME, DEPT_NAME, "
					+ " COLLEGE_ID, LONGITUDE, LATITUDE, EFF_DATE, EXP_DATE,  "
					+ " CREATE_DATE, OPERATE_TYPE, STATUS, STATE_DATE, CREATEUSER) "
					+ " SELECT BUREAU_ID, BUREAU_NAME, COLLEGE, "
					+ " AREA_NAME, DEPT_NAME,COLLEGE_ID, "
					+ " LONGITUDE, LATITUDE, EFF_DATE, EXP_DATE,current timestamp, 'DELETE', 'OUT_NEW', CURRENT TIMESTAMP, '"
					+ userid
					+ "' "
					+ " FROM  BUREAU_CFG_COLLEGE_PT WHERE STATUS <> 'FAL' AND COLLEGE_id = '"
					+ collegeCode.toUpperCase()
					+ "' AND BUREAU_ID in ("
					+ deleteCode.toUpperCase()
					+ ")";

			ps = conn.prepareStatement(insertLogSql);
			ps.execute();

			PrintWriter outs = null;
			StringBuffer buf = null;

			outs = response.getWriter();
			buf = new StringBuffer();

			if (isSuc > 0) {
				buf
						.append("{Info:[{count:'0',msg:'高校与基站关系删除成功，状态更新为（删除）待一级审核！'}]}");
			} else {
				buf.append("{Info:[{count:'0',msg:'高校与基站关系删除失败！'}]}");
			}
			outs.write(buf.toString());
		}

		if ("aduit_y".equals(optype)) {
			String opCollegeCode = (String) request
					.getParameter("opCollegeCode");
			if (StringUtils.isNotEmpty(opCollegeCode)) {
				opCollegeCode = URLDecoder.decode(opCollegeCode,
						"utf-8");
			}
			String opBurCode = (String) request
					.getParameter("opBurCode");
			if (StringUtils.isNotEmpty(opBurCode)) {
				opBurCode = URLDecoder.decode(opBurCode, "utf-8");
			}
			String opCode = (String) request.getParameter("opCode");
			if (StringUtils.isNotEmpty(opCode)) {
				opCode = URLDecoder.decode(opCode, "utf-8");
			}
			String statusCode = (String) request
					.getParameter("statusCode");
			if (StringUtils.isNotEmpty(statusCode)) {
				statusCode = URLDecoder.decode(statusCode, "utf-8");
			}

			String[] opCollegeCodeLs = opCollegeCode.split(",");
			String[] opBurCodeLs = opBurCode.split(",");
			String[] opCodeLs = opCode.split(",");
			String[] statusCodeLs = statusCode.split(",");

			int isSuc = 0;

			for (int i = 0; i < opCollegeCodeLs.length; i++) {

				String insertLogSql = "INSERT INTO  BUREAU_CFG_COLLEGE_PT_LOG(BUREAU_ID, BUREAU_NAME, COLLEGE, AREA_NAME, DEPT_NAME, "
						+ " COLLEGE_ID, LONGITUDE, LATITUDE, EFF_DATE, EXP_DATE,  "
						+ " CREATE_DATE, OPERATE_TYPE, STATUS, STATE_DATE, CREATEUSER) "
						+ " SELECT BUREAU_ID, BUREAU_NAME, COLLEGE, "
						+ " AREA_NAME, DEPT_NAME,COLLEGE_ID, "
						+ " LONGITUDE, LATITUDE, EFF_DATE, EXP_DATE,CREATE_DATE,";

				String sql = "update BUREAU_CFG_COLLEGE_PT set STATE_DATE=current timestamp, ";

				if ("INSERT".equals(opCodeLs[i])) {
					if ("IN_ADUIT_1".equals(statusCodeLs[i])) {
						sql += " STATUS='IN_ADUIT_2' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_1', ";
					}
					if ("IN_ADUIT_2".equals(statusCodeLs[i])) {
						sql += " STATUS='IN_ADUIT_3' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_2', ";
					}
					if ("IN_ADUIT_3".equals(statusCodeLs[i])) {
						sql += " STATUS='SUC' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_3', ";
					}
				}
				if ("DELETE".equals(opCodeLs[i])) {
					if ("OUT_ADUIT_1".equals(statusCodeLs[i])) {
						sql += " STATUS='OUT_ADUIT_2' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_1', ";
					}
					if ("OUT_ADUIT_2".equals(statusCodeLs[i])) {
						sql += " STATUS='OUT_ADUIT_3' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_2', ";
					}
					if ("OUT_ADUIT_3".equals(statusCodeLs[i])) {
						sql += " STATUS='FAL' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_3', ";
					}
				}
				sql += " where STATUS<>'FAL' and  BUREAU_ID = '"
						+ opBurCodeLs[i].toUpperCase()
						+ "' and COLLEGE_id = '"
						+ opCollegeCodeLs[i].toUpperCase() + "'";

				insertLogSql += " CURRENT TIMESTAMP, '"
						+ userid
						+ "' "
						+ " FROM  BUREAU_CFG_COLLEGE_PT WHERE STATUS <> 'FAL' AND COLLEGE_id = '"
						+ opCollegeCodeLs[i].toUpperCase()
						+ "' AND BUREAU_ID = '"
						+ opBurCodeLs[i].toUpperCase() + "'";

				ps = conn.prepareStatement(insertLogSql);
				ps.execute();

				ps = conn.prepareStatement(sql);
				isSuc = ps.executeUpdate();
			}

			PrintWriter outs = null;
			StringBuffer buf = null;

			outs = response.getWriter();
			buf = new StringBuffer();

			if (isSuc > 0) {
				buf.append("{Info:[{count:'0',msg:'操作成功！'}]}");
			} else {
				buf.append("{Info:[{count:'0',msg:'操作失败！'}]}");
			}

			outs.write(buf.toString());
		}

		if ("aduit_n".equals(optype)) {
			String opCollegeCode = (String) request
					.getParameter("opCollegeCode");
			if (StringUtils.isNotEmpty(opCollegeCode)) {
				opCollegeCode = URLDecoder.decode(opCollegeCode,
						"utf-8");
			}
			String opBurCode = (String) request
					.getParameter("opBurCode");
			if (StringUtils.isNotEmpty(opBurCode)) {
				opBurCode = URLDecoder.decode(opBurCode, "utf-8");
			}
			String opCode = (String) request.getParameter("opCode");
			if (StringUtils.isNotEmpty(opCode)) {
				opCode = URLDecoder.decode(opCode, "utf-8");
			}
			String statusCode = (String) request
					.getParameter("statusCode");
			if (StringUtils.isNotEmpty(statusCode)) {
				statusCode = URLDecoder.decode(statusCode, "utf-8");
			}

			String[] opCollegeCodeLs = opCollegeCode.split(",");
			String[] opBurCodeLs = opBurCode.split(",");
			String[] opCodeLs = opCode.split(",");
			String[] statusCodeLs = statusCode.split(",");

			int isSuc = 0;

			for (int i = 0; i < opCollegeCodeLs.length; i++) {
				String insertLogSql = "INSERT INTO  BUREAU_CFG_COLLEGE_PT_LOG(BUREAU_ID, BUREAU_NAME, COLLEGE, AREA_NAME, DEPT_NAME, "
						+ " COLLEGE_ID, LONGITUDE, LATITUDE, EFF_DATE, EXP_DATE,  "
						+ " CREATE_DATE, OPERATE_TYPE, STATUS, STATE_DATE, CREATEUSER) "
						+ " SELECT BUREAU_ID, BUREAU_NAME, COLLEGE, "
						+ " AREA_NAME, DEPT_NAME,COLLEGE_ID, "
						+ " LONGITUDE, LATITUDE, EFF_DATE, EXP_DATE,CREATE_DATE,";

				String sql = "update BUREAU_CFG_COLLEGE_PT set STATE_DATE=current timestamp, ";

				if ("INSERT".equals(opCodeLs[i])) {
					if ("IN_ADUIT_1".equals(statusCodeLs[i])) {
						sql += " STATUS='FAL' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_1_N', ";
					}
					if ("IN_ADUIT_2".equals(statusCodeLs[i])) {
						sql += " STATUS='IN_ADUIT_1' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_2_N', ";
					}
					if ("IN_ADUIT_3".equals(statusCodeLs[i])) {
						sql += " STATUS='IN_ADUIT_2' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_3_N', ";
					}
				}
				if ("DELETE".equals(opCodeLs[i])) {
					if ("OUT_ADUIT_1".equals(statusCodeLs[i])) {
						sql += " STATUS='SUC' ";
						//sql += " STATUS='OUT_ADUIT_0' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_1_N', ";
					}
					if ("OUT_ADUIT_2".equals(statusCodeLs[i])) {
						sql += " STATUS='OUT_ADUIT_1' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_2_N', ";
					}
					if ("OUT_ADUIT_3".equals(statusCodeLs[i])) {
						sql += " STATUS='OUT_ADUIT_2' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_3_N', ";
					}
				}
				sql += " where STATUS<>'FAL' and  BUREAU_ID = '"
						+ opBurCodeLs[i].toUpperCase()
						+ "' and COLLEGE_id = '"
						+ opCollegeCodeLs[i].toUpperCase() + "'";

				insertLogSql += " CURRENT TIMESTAMP, '"
						+ userid
						+ "' "
						+ " FROM  BUREAU_CFG_COLLEGE_PT WHERE STATUS <> 'FAL' AND COLLEGE_id = '"
						+ opCollegeCodeLs[i].toUpperCase()
						+ "' AND BUREAU_ID = '"
						+ opBurCodeLs[i].toUpperCase() + "'";

				ps = conn.prepareStatement(insertLogSql);
				ps.execute();

				ps = conn.prepareStatement(sql);
				isSuc = ps.executeUpdate();
			}

			PrintWriter outs = null;
			StringBuffer buf = null;

			outs = response.getWriter();
			buf = new StringBuffer();

			if (isSuc > 0) {
				buf.append("{Info:[{count:'0',msg:'操作成功！'}]}");
			} else {
				buf.append("{Info:[{count:'0',msg:'操作失败！'}]}");
			}

			outs.write(buf.toString());
		}
		
		conn.commit();
		if (rs != null)
			rs.close();
		if (ps != null)
			ps.close();

	} catch (SQLException e) {
		conn.rollback();
		e.printStackTrace();
	} finally {
		if (conn != null)
			conn.close();
	}
%>
