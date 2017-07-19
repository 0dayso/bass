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
	String userid = (String) session.getAttribute("loginname");
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	try {
		conn = ConnectionManage.getInstance().getDWConnection();
		conn.setAutoCommit(false);

		if ("insert".equals(optype)) {
			String paramsInsert = (String) request
					.getParameter("paramsInsert");
			if (StringUtils.isNotEmpty(paramsInsert)) {
				paramsInsert = URLDecoder.decode(paramsInsert, "utf-8");
			}
			//var paramsInsert = "'"+cArea+"','"+cCollegeName+"','"+cCode+"','"+cWeb+"','"+cType+"','"+cAdd+"',"+cStus
			//+","+cStusNew+",'"+cMan+"','"+cManNbr+"','"+cShortNum+"'";	

			String[] params = paramsInsert.split(",");

			String checkSql = "select count(*) from COLLEGE_INFO_PT where STATUS <> 'FAL' AND STATE = 1 AND (COLLEGE_NAME = "
					+ params[1] + " OR COLLEGE_ID=" + params[2] + ")";

			ps = conn.prepareStatement(checkSql);
			rs = ps.executeQuery();

			PrintWriter outs = null;
			StringBuffer buf = null;

			outs = response.getWriter();
			buf = new StringBuffer();

			int count = 0;
			if (rs.next()) {
				count = rs.getInt(1);
			}

			if (count > 0) {
				buf.append("{Info:[{count:'").append(count).append(
						"',msg:'输入的高校名称或高校编码有重复记录，请重新输入！'}]}");
			} else {
				String insertSql = "INSERT INTO COLLEGE_INFO_PT(CREATE_DATE, OPERATE_TYPE, STATUS, CREATEUSER,STATE_DATE,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER )"
						+ " VALUES(current timestamp,'INSERT','IN_ADUIT_1', '"
						+ userid
						+ "',current timestamp,1,current timestamp,"
						+ paramsInsert + ")";

				ps = conn.prepareStatement(insertSql);
				ps.execute();

				String insertLogSql = "INSERT INTO COLLEGE_INFO_PT_LOG(CREATE_DATE, OPERATE_TYPE, STATUS, CREATEUSER,STATE_DATE,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER )"
						+ " SELECT CREATE_DATE, 'INSERT', 'IN_NEW', CREATEUSER,STATE_DATE,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER "
						+ " FROM  COLLEGE_INFO_PT WHERE STATUS <> 'FAL' AND STATE = 1 AND COLLEGE_ID="
						+ params[2];

				ps = conn.prepareStatement(insertLogSql);
				ps.execute();

				buf
						.append("{Info:[{count:'0',msg:'高校信息新增成功，状态更新为（新增）待一级审核！'}]}");
			}
			outs.write(buf.toString());
		}

		if ("update".equals(optype)) {
			String paramsUpdate = (String) request
					.getParameter("paramsUpdate");
			String collegeCode = (String) request
					.getParameter("collegeCode");
			if (StringUtils.isNotEmpty(paramsUpdate)) {
				paramsUpdate = URLDecoder.decode(paramsUpdate, "utf-8");
			}
			if (StringUtils.isNotEmpty(collegeCode)) {
				collegeCode = URLDecoder.decode(collegeCode, "utf-8");
			}
			//var paramsUpdate = "COLLEGE_NAME='"+cCollegeName+"',WEB_ADD='"+cWeb+"',COLLEGE_TYPE='"+cType
			//+"',COLLEGE_ADD='"+cAdd+"',STUDENTS_NUM="+cStus
			//+",NEW_STUDENTS="+cStusNew+",MANAGER='"+cMan+"',MANAGER_NBR='"+cManNbr+"',SHORT_NUMBER='"+cShortNum+"'";

			String[] params = paramsUpdate.split(",");

			String checkSql = "select count(*) from COLLEGE_INFO_PT where STATUS <> 'FAL' AND STATE = 1 AND ("
					+ params[0]
					+ " and COLLEGE_ID<>'"
					+ collegeCode
					+ "')";

			ps = conn.prepareStatement(checkSql);
			rs = ps.executeQuery();

			PrintWriter outs = null;
			StringBuffer buf = null;

			outs = response.getWriter();
			buf = new StringBuffer();

			int count = 0;
			if (rs.next()) {
				count = rs.getInt(1);
			}

			if (count > 0) {
				buf.append("{Info:[{count:'").append(count).append(
						"',msg:'输入的高校名称有重复记录，请重新输入！'}]}");
			} else {
				String updateSql = "UPDATE COLLEGE_INFO_PT SET STATUS='UPD_ADUIT_1',STATE_DATE=current timestamp,OPERATE_TYPE='UPDATE',CREATE_DATE=current timestamp,CREATEUSER='"
						+ userid
						+ "',"
						+ paramsUpdate
						+ " WHERE STATUS <> 'FAL' AND STATE = 1 AND COLLEGE_ID='"
						+ collegeCode + "'";

				ps = conn.prepareStatement(updateSql);
				ps.execute();

				String insertLogSql = "INSERT INTO COLLEGE_INFO_PT_LOG(CREATE_DATE, OPERATE_TYPE, STATUS, CREATEUSER,STATE_DATE,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER )"
						+ " SELECT CREATE_DATE, 'UPDATE', 'UPD_NEW', CREATEUSER,STATE_DATE,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER "
						+ " FROM  COLLEGE_INFO_PT WHERE STATUS <> 'FAL' AND STATE = 1 AND COLLEGE_ID='"
						+ collegeCode + "'";

				ps = conn.prepareStatement(insertLogSql);
				ps.execute();

				buf
						.append("{Info:[{count:'0',msg:'高校信息修改成功，状态更新为（修改）待一级审核！'}]}");
			}
			outs.write(buf.toString());
		}

		if ("delete".equals(optype)) {
			String deleteCode = (String) request
					.getParameter("deleteCode");

			String checkSql = "SELECT COUNT(*) FROM BUREAU_CFG_COLLEGE_PT WHERE STATUS <> 'FAL' AND COLLEGE_ID IN ("
					+ deleteCode.toUpperCase() + ")";

			ps = conn.prepareStatement(checkSql);
			rs = ps.executeQuery();

			PrintWriter outs = null;
			StringBuffer buf = null;

			outs = response.getWriter();
			buf = new StringBuffer();

			int count = 0;
			if (rs.next()) {
				count = rs.getInt(1);
			}

			if (count > 0) {
				buf.append("{Info:[{count:'").append(count).append("',msg:'高校已经有在用的高校与基站对应联系，不能删除操作！'}]}");
			} else {
				String deleteSql = "update COLLEGE_INFO_PT set"
						+ " OPERATE_TYPE = 'DELETE',STATUS='OUT_ADUIT_1',STATE_DATE=current timestamp,CREATE_DATE=current timestamp,CREATEUSER='"
						+ userid
						+ "'"
						+ " where  STATUS <> 'FAL' AND STATE = 1 and COLLEGE_id in ("
						+ deleteCode.toUpperCase() + ")";

				ps = conn.prepareStatement(deleteSql);
				int isSuc = ps.executeUpdate();

				String insertLogSql = "INSERT INTO COLLEGE_INFO_PT_LOG(CREATE_DATE, OPERATE_TYPE, STATUS, CREATEUSER,STATE_DATE,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER )"
						+ " SELECT CREATE_DATE, 'DELETE', 'OUT_NEW', CREATEUSER,STATE_DATE,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER "
						+ " FROM  COLLEGE_INFO_PT WHERE STATUS <> 'FAL' AND STATE = 1 and COLLEGE_id in ("
						+ deleteCode.toUpperCase() + ")";

				ps = conn.prepareStatement(insertLogSql);
				ps.execute();

				outs = response.getWriter();
				buf = new StringBuffer();

				if (isSuc > 0) {
					buf.append("{Info:[{count:'0',msg:'高校信息删除成功，状态更新为（删除）待一级审核！'}]}");
				} else {
					buf.append("{Info:[{count:'0',msg:'高校信息删除失败！'}]}");
				}
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
			String[] opCodeLs = opCode.split(",");
			String[] statusCodeLs = statusCode.split(",");

			int isSuc = 0;

			for (int i = 0; i < opCollegeCodeLs.length; i++) {

				String insertLogSql = "INSERT INTO COLLEGE_INFO_PT_LOG(CREATE_DATE, CREATEUSER,STATE_DATE,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER,OPERATE_TYPE, STATUS )"
						+ " SELECT CREATE_DATE, '"
						+ userid
						+ "',current timestamp,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER, ";

				String sql = "update COLLEGE_INFO_PT set STATE_DATE=current timestamp, ";

				if ("INSERT".equals(opCodeLs[i])) {
					if ("IN_ADUIT_1".equals(statusCodeLs[i])) {
						sql += " STATUS='IN_ADUIT_2' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_1' ";
					}
					if ("IN_ADUIT_2".equals(statusCodeLs[i])) {
						sql += " STATUS='IN_ADUIT_3' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_2' ";
					}
					if ("IN_ADUIT_3".equals(statusCodeLs[i])) {
						sql += " STATUS='SUC' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_3' ";
					}
				}
				if ("DELETE".equals(opCodeLs[i])) {
					if ("OUT_ADUIT_1".equals(statusCodeLs[i])) {
						sql += " STATUS='OUT_ADUIT_2' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_1' ";
					}
					if ("OUT_ADUIT_2".equals(statusCodeLs[i])) {
						sql += " STATUS='OUT_ADUIT_3' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_2' ";
					}
					if ("OUT_ADUIT_3".equals(statusCodeLs[i])) {
						sql += " STATUS='FAL' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_3' ";
					}
				}
				if ("UPDATE".equals(opCodeLs[i])) {
					if ("UPD_ADUIT_1".equals(statusCodeLs[i])) {
						sql += " STATUS='UPD_ADUIT_2' ";
						insertLogSql += " 'UPDATE', 'UPD_ADUIT_1' ";
					}
					if ("UPD_ADUIT_2".equals(statusCodeLs[i])) {
						sql += " STATUS='UPD_ADUIT_3' ";
						insertLogSql += " 'UPDATE', 'UPD_ADUIT_2' ";
					}
					if ("UPD_ADUIT_3".equals(statusCodeLs[i])) {
						sql += " STATUS='SUC' ";
						insertLogSql += " 'UPDATE', 'UPD_ADUIT_3' ";
					}
				}
				sql += " where STATUS<>'FAL' AND STATE = 1 and COLLEGE_id = '"
						+ opCollegeCodeLs[i].toUpperCase() + "'";

				insertLogSql += " FROM  COLLEGE_INFO_PT WHERE STATUS <> 'FAL' AND STATE = 1 AND COLLEGE_ID='"
						+ opCollegeCodeLs[i].toUpperCase() + "'";

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
			String[] opCodeLs = opCode.split(",");
			String[] statusCodeLs = statusCode.split(",");

			int isSuc = 0;

			for (int i = 0; i < opCollegeCodeLs.length; i++) {

				String insertLogSql = "INSERT INTO COLLEGE_INFO_PT_LOG(CREATE_DATE, CREATEUSER,STATE_DATE,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER,OPERATE_TYPE, STATUS )"
						+ " SELECT CREATE_DATE, '"
						+ userid
						+ "',current timestamp,STATE,EFF_DATE,"
						+ " AREA_ID,COLLEGE_NAME, COLLEGE_ID, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " STUDENTS_NUM, NEW_STUDENTS, MANAGER,MANAGER_NBR,SHORT_NUMBER, ";

				String sql = "update COLLEGE_INFO_PT set STATE_DATE=current timestamp, ";

				if ("INSERT".equals(opCodeLs[i])) {
					if ("IN_ADUIT_1".equals(statusCodeLs[i])) {
						sql += " STATUS='FAL' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_1_N' ";
					}
					if ("IN_ADUIT_2".equals(statusCodeLs[i])) {
						sql += " STATUS='IN_ADUIT_1' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_2_N' ";
					}
					if ("IN_ADUIT_3".equals(statusCodeLs[i])) {
						sql += " STATUS='IN_ADUIT_2' ";
						insertLogSql += " 'INSERT', 'IN_ADUIT_3_N' ";
					}
				}
				if ("UPDATE".equals(opCodeLs[i])) {
					if ("UPD_ADUIT_1".equals(statusCodeLs[i])) {
						sql += " STATUS='SUC' ";
						insertLogSql += " 'UPDATE', 'UPD_ADUIT_1_N' ";
					}
					if ("UPD_ADUIT_2".equals(statusCodeLs[i])) {
						sql += " STATUS='UPD_ADUIT_1' ";
						insertLogSql += " 'UPDATE', 'UPD_ADUIT_2_N' ";
					}
					if ("UPD_ADUIT_3".equals(statusCodeLs[i])) {
						sql += " STATUS='UPD_ADUIT_2' ";
						insertLogSql += " 'UPDATE', 'UPD_ADUIT_3_N' ";
					}
				}
				if ("DELETE".equals(opCodeLs[i])) {
					if ("OUT_ADUIT_1".equals(statusCodeLs[i])) {
						sql += " STATUS='SUC' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_1_N' ";
					}
					if ("OUT_ADUIT_2".equals(statusCodeLs[i])) {
						sql += " STATUS='OUT_ADUIT_1' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_2_N' ";
					}
					if ("OUT_ADUIT_3".equals(statusCodeLs[i])) {
						sql += " STATUS='OUT_ADUIT_2' ";
						insertLogSql += " 'DELETE', 'OUT_ADUIT_3_N' ";
					}
				}
				sql += " where STATUS<>'FAL' AND STATE = 1  and  COLLEGE_id = '"
						+ opCollegeCodeLs[i].toUpperCase() + "'";

				insertLogSql += " FROM  COLLEGE_INFO_PT WHERE STATUS <> 'FAL' AND STATE = 1 AND COLLEGE_ID='"
						+ opCollegeCodeLs[i].toUpperCase() + "'";

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
