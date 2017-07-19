package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.asiainfo.bass.components.models.DesUtil;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.msg.sms.SendSMSWrapper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;

/**
 * 
 * @author yulei
 * @since 2012-09-24
 * @version 1.0
 * @see 高校信息维护、审批管理
 *
 */
@SuppressWarnings("unused")
public class CollegeManageAction extends Action {
	private static Logger log = Logger.getLogger(CollegeManageAction.class);
	

	/**
	 * @see 新增高校信息，生成新的高校编码(college_id)
	 * @param request
	 * @param response
	 */
	public void queryCollegeCode(HttpServletRequest request,
			HttpServletResponse response) {
		response.setCharacterEncoding("UTF-8");
		Connection connection = null;
		Statement stat = null;
		ResultSet rs = null;

		String sql = request.getParameter("sql");
		String ds = request.getParameter("ds");
		String areaCode = request.getParameter("areaCode");
		sql = DesUtil.defaultStrDec(sql);
		try {
			connection = ConnectionManage.getInstance().getConnection(ds);
			stat = connection.createStatement();

			rs = stat.executeQuery(sql);
			String collegeCode = "";
			if (rs.next()) {
				collegeCode = rs.getString(1);
			}

			if ("".equals(collegeCode)) {
				collegeCode = areaCode + ".C0001";
			} else if (collegeCode == null) {
				collegeCode = areaCode + ".C0001"; // 没有地市信息赋值
			} else {
				DecimalFormat df = new DecimalFormat("0000");
				String tempStr = collegeCode
						.substring(collegeCode.length() - 4);
				int tempInt = Integer.parseInt(tempStr) + 1;
				collegeCode = areaCode + ".C" + df.format(tempInt);
			}

			rs.close();
			stat.close();

			PrintWriter outs = null;
			StringBuffer buf = null;

			outs = response.getWriter();
			buf = new StringBuffer();

			buf.append("{root:[{collegeCode:'").append(collegeCode).append(
					"'}]}");
			outs.write(buf.toString());

		} catch (Exception ex) {
			log.error(ex);
			ex.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(connection);
		}
	}

	/**
	 * @see 高校信息表COLLEGE_INFO_PT-CRUD操作
	 * @param request
	 * @param response
	 */
	@SuppressWarnings("resource")
	public void serviceDB(HttpServletRequest request,
			HttpServletResponse response) {
		User user=(User)request.getSession().getAttribute("user");
		String optype = (String) request.getParameter("optype");
		String userid = (String) request.getSession().getAttribute("loginname");
		String curMobilePhone=user.getPhone();
		log.info("optype="+ optype + ";userid=" + userid + ";curMobilePhone=" + curMobilePhone);
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean sendMsg=false;
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
//			conn.setAutoCommit(false);

			if ("insert".equals(optype)) {
				String paramsInsert = (String) request
						.getParameter("paramsInsert");
				if (StringUtils.isNotEmpty(paramsInsert)) {
					paramsInsert = URLDecoder.decode(paramsInsert, "utf-8");
				}
				// var paramsInsert =
				// "'"+cArea+"','"+cCollegeName+"','"+cCode+"','"+cWeb+"','"+cType+"','"+cAdd+"',"+cStus
				// +","+cStusNew+",'"+cMan+"','"+cManNbr+"','"+cShortNum+"'";

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

					log.info("insertLogSql=" + insertLogSql);
					ps = conn.prepareStatement(insertLogSql);
					ps.execute();

					buf
							.append("{Info:[{count:'1',msg:'高校信息新增成功，状态更新为（新增）待一级审核！'}]}");
					sendMsg=true;
				}
				outs.write(buf.toString());
				
				//发送提醒短信
					//获取下级审核人员手机号
				if(sendMsg){
					conn=ConnectionManage.getInstance().getWEBConnection();
					ps=conn.prepareStatement("select mobilephone from FPF_USER_USER where userid= (select operator from audit_college_cfg where cityid='"+user.getCityId()+"')");
					rs=ps.executeQuery();
					String nextAuditMobile=null;
					if(rs.next()){
						nextAuditMobile=rs.getString(1);
						if(""!=curMobilePhone&&null!=curMobilePhone){
							if(curMobilePhone.trim().matches("[0-9]{11}")){
								sendSmsMessage(new String[]{curMobilePhone,nextAuditMobile}, 
										new String[]{"您新增的高校信息已经成功,目前状态为[新增待一级审核] !",
															user.getName()+"已经新增了"+ params[1]+"高校信息待您审批,谢谢 !"});
							}
						}
					}else{
						if(""!=curMobilePhone&&null!=curMobilePhone){
							if(curMobilePhone.trim().matches("[0-9]{11}")){
								sendSmsMessage(curMobilePhone,"您新增的高校信息已经成功,目前状态为[新增待一级审核] !");
							}
						}
					}
				}
				
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
				// var paramsUpdate =
				// "COLLEGE_NAME='"+cCollegeName+"',WEB_ADD='"+cWeb+"',COLLEGE_TYPE='"+cType
				// +"',COLLEGE_ADD='"+cAdd+"',STUDENTS_NUM="+cStus
				// +",NEW_STUDENTS="+cStusNew+",MANAGER='"+cMan+"',MANAGER_NBR='"+cManNbr+"',SHORT_NUMBER='"+cShortNum+"'";

				String[] params = paramsUpdate.split(",");

				String checkSql = "select count(*) from COLLEGE_INFO_PT where STATUS <> 'FAL' AND STATE = 1 AND ("
						+ params[0] + " and COLLEGE_ID<>'" + collegeCode + "')";

				log.info("checkSql=" + checkSql);
				
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

					log.info("updateSql=" + updateSql);
					
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

					log.info("insertLogSql=" + insertLogSql);
					
					ps = conn.prepareStatement(insertLogSql);
					ps.execute();

					buf.append("{Info:[{count:'0',msg:'高校信息修改成功，状态更新为（修改）待一级审核！'}]}");
					
					sendMsg=true;
				}
				outs.write(buf.toString());
				
					//发送提醒短信
					//获取下级审核人员手机号
				if(sendMsg){
					conn=ConnectionManage.getInstance().getWEBConnection();
					ps=conn.prepareStatement("select mobilephone from FPF_USER_USER where userid= (select operator from audit_college_cfg where cityid='"+user.getCityId()+"')");
					rs=ps.executeQuery();
					String nextAuditMobile=null;
					if(rs.next()){
						nextAuditMobile=rs.getString(1);
						if(""!=curMobilePhone&&null!=curMobilePhone){
							if(curMobilePhone.trim().matches("[0-9]{11}")){
									sendSmsMessage(new String[]{curMobilePhone,nextAuditMobile}, 
											new String[]{"您修改的高校信息已经成功,目前状态为[修改待一级审核] !",
																user.getName()+"已经修改了"+params[0].substring(14,params[0].length()-1)+"高校信息待您审批,谢谢 !"});	
							}
						}
					}else{
						if(""!=curMobilePhone&&null!=curMobilePhone){
							if(curMobilePhone.trim().matches("[0-9]{11}")){
									sendSmsMessage(curMobilePhone,"您修改的高校信息已经成功,目前状态为[修改待一级审核] !");
							}
						}
					}
				}
			}

			if ("delete".equals(optype)) {
				String deleteCode = (String) request.getParameter("deleteCode");
				String collegeName = (String) request.getParameter("collegeName");

				String checkSql = "SELECT COUNT(*) FROM BUREAU_CFG_COLLEGE_PT WHERE STATUS <> 'FAL' AND COLLEGE_ID IN ("
						+ deleteCode.toUpperCase() + ")";

				log.info("checkSql=" + checkSql);
				
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
							"',msg:'高校已经有在用的高校与基站对应联系，不能删除操作！'}]}");
				} else {
					String deleteSql = "update COLLEGE_INFO_PT set"
							+ " OPERATE_TYPE = 'DELETE',STATUS='OUT_ADUIT_1',STATE_DATE=current timestamp,CREATE_DATE=current timestamp,CREATEUSER='"
							+ userid
							+ "'"
							+ " where  STATUS <> 'FAL' AND STATE = 1 and COLLEGE_id in ("
							+ deleteCode.toUpperCase() + ")";

					log.info("deleteSql=" + deleteSql);
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
						sendMsg=true;
					} else {
						buf.append("{Info:[{count:'0',msg:'高校信息删除失败！'}]}");
					}
				}
				outs.write(buf.toString());
				
				//发送提醒短信
				
				if(sendMsg){
					//获取下级审核人员手机号
					conn=ConnectionManage.getInstance().getWEBConnection();
					ps=conn.prepareStatement("select mobilephone from FPF_USER_USER where userid= (select operator from AUDIT_COLLEGE_CFG where cityid='"+user.getCityId()+")");
					rs=ps.executeQuery();
					String nextAuditMobile=null;
					if(rs.next()){
						nextAuditMobile=rs.getString(1);
						if(""!=curMobilePhone&&null!=curMobilePhone){
							if(curMobilePhone.trim().matches("[0-9]{11}")){
								sendSmsMessage(new String[]{curMobilePhone,nextAuditMobile}, 
										new String[]{"您删除的高校信息已经成功,目前状态为[删除待一级审核] !",
															user.getName()+"已经删除了"+collegeName+"高校信息待您审批,谢谢 !"});
							}
						}
					}else{
						if(""!=curMobilePhone&&null!=curMobilePhone){
							if(curMobilePhone.trim().matches("[0-9]{11}")){
								sendSmsMessage(curMobilePhone,"您删除的高校信息已经成功,目前状态为[删除待一级审核] !");
							}
						}
					}
				}
			}

			if ("aduit_y".equals(optype)) {
				String opCollegeCode = (String) request
						.getParameter("opCollegeCode");
				if (StringUtils.isNotEmpty(opCollegeCode)) {
					opCollegeCode = URLDecoder.decode(opCollegeCode, "utf-8");
				}
				String opCode = (String) request.getParameter("opCode");
				if (StringUtils.isNotEmpty(opCode)) {
					opCode = URLDecoder.decode(opCode, "utf-8");
				}
				String statusCode = (String) request.getParameter("statusCode");
				if (StringUtils.isNotEmpty(statusCode)) {
					statusCode = URLDecoder.decode(statusCode, "utf-8");
				}
				String creater = (String) request.getParameter("creater");
				if (StringUtils.isNotEmpty(statusCode)) {
					creater = URLDecoder.decode(creater, "utf-8");
				}
				String collegeName=(String) request.getParameter("collegeName");
				if (StringUtils.isNotEmpty(collegeName)) {
					collegeName = URLDecoder.decode(collegeName, "utf-8");
				}
				String[] opCollegeCodeLs = opCollegeCode.split(",");
				String[] opCodeLs = opCode.split(",");
				String[] statusCodeLs = statusCode.split(",");
				String[] creaters=creater.split(",");
				String[] collegeNames=creater.split(",");

				int isSuc = 0;
				//下级审批人的级别
				String operatorSql=null;
				String auditLevel=null;

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
							auditLevel="新增待二级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator2 from AUDIT_COLLEGE_CFG where cityid='"+user.getCityId()+"')";
						}
						if ("IN_ADUIT_2".equals(statusCodeLs[i])) {
							sql += " STATUS='IN_ADUIT_3' ";
							insertLogSql += " 'INSERT', 'IN_ADUIT_2' ";
							auditLevel="新增待三级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator from AUDIT_COLLEGE_CFG where cityid='0')";
						}
						if ("IN_ADUIT_3".equals(statusCodeLs[i])) {
							sql += " STATUS='SUC' ";
							auditLevel="生效";
							insertLogSql += " 'INSERT', 'IN_ADUIT_3' ";
						}
					}
					if ("DELETE".equals(opCodeLs[i])) {
						if ("OUT_ADUIT_1".equals(statusCodeLs[i])) {
							sql += " STATUS='OUT_ADUIT_2' ";
							insertLogSql += " 'DELETE', 'OUT_ADUIT_1' ";
							auditLevel="删除待二级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator2 from AUDIT_COLLEGE_CFG where cityid='"+user.getCityId()+"')";
						}
						if ("OUT_ADUIT_2".equals(statusCodeLs[i])) {
							sql += " STATUS='OUT_ADUIT_3' ";
							insertLogSql += " 'DELETE', 'OUT_ADUIT_2' ";
							auditLevel="删除待三级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator from AUDIT_COLLEGE_CFG where cityid='0')";
						}
						if ("OUT_ADUIT_3".equals(statusCodeLs[i])) {
							sql += " STATUS='FAL' ";
							auditLevel="删除完成";
							insertLogSql += " 'DELETE', 'OUT_ADUIT_3' ";
						}
					}
					if ("UPDATE".equals(opCodeLs[i])) {
						if ("UPD_ADUIT_1".equals(statusCodeLs[i])) {
							sql += " STATUS='UPD_ADUIT_2' ";
							insertLogSql += " 'UPDATE', 'UPD_ADUIT_1' ";
							auditLevel="修改待二级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator2 from AUDIT_COLLEGE_CFG where cityid='"+user.getCityId()+"')";
						}
						if ("UPD_ADUIT_2".equals(statusCodeLs[i])) {
							sql += " STATUS='UPD_ADUIT_3' ";
							insertLogSql += " 'UPDATE', 'UPD_ADUIT_2' ";
							auditLevel="修改待三级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator from AUDIT_COLLEGE_CFG where cityid='0')";
						}
						if ("UPD_ADUIT_3".equals(statusCodeLs[i])) {
							sql += " STATUS='SUC' ";
							auditLevel="修改完成";
							insertLogSql += " 'UPDATE', 'UPD_ADUIT_3' ";
						}
					}
					sql += " where STATUS<>'FAL' AND STATE = 1 and COLLEGE_id = '"
							+ opCollegeCodeLs[i].toUpperCase() + "'";

					insertLogSql += " FROM  COLLEGE_INFO_PT WHERE STATUS <> 'FAL' AND STATE = 1 AND COLLEGE_ID='"
							+ opCollegeCodeLs[i].toUpperCase() + "'";

					log.info("insertLogSql=" + insertLogSql);
					
					conn = ConnectionManage.getInstance().getDWConnection();
					ps = conn.prepareStatement(insertLogSql);
					ps.execute();

					log.info("sql=" + sql);
					ps = conn.prepareStatement(sql);
					isSuc = ps.executeUpdate();
					
					
					
					//发送提醒短信
					//获取下级审核人员手机号
					if(isSuc>0){
						//获得创建人的手机号码
						conn=ConnectionManage.getInstance().getWEBConnection();
						ps=conn.prepareStatement("select mobilephone from FPF_USER_USER where userid='"+creaters[i]+"'");
						rs=ps.executeQuery();
						rs.next();
						curMobilePhone=rs.getString(1);
						if(null!=operatorSql){
							//获取审核人号码
							ps=conn.prepareStatement(operatorSql);
							rs=ps.executeQuery();
							String nextAuditMobile=null;
							if(rs.next()){
								nextAuditMobile=rs.getString(1);
								if(""!=curMobilePhone&&null!=curMobilePhone){
									if(curMobilePhone.trim().matches("[0-9]{11}")){
										sendSmsMessage(new String[]{curMobilePhone,nextAuditMobile}, 
												new String[]{"您提交审批的高校信息已经审核通过,目前状态为"+auditLevel+" !",
																	user.getName()+"已经审核通过了"+collegeNames[i]+"高校信息待您审批,谢谢 !"});
									}
								}
							}else{
								if(""!=curMobilePhone&&null!=curMobilePhone){
									if(curMobilePhone.trim().matches("[0-9]{11}")){
										sendSmsMessage(curMobilePhone,"您提交审批的高校信息已经审核通过,目前状态为"+auditLevel+" !");
									}
								}
							}
						}else{
							//状态为SUC
							if(""!=curMobilePhone&&null!=curMobilePhone){
								if(curMobilePhone.trim().matches("[0-9]{11}")){
									sendSmsMessage(curMobilePhone,"您提交审批的高校信息已经审核通过,目前状态为"+auditLevel+" !");
								}
							}
						}
					}
				}
				
				PrintWriter outs = null;
				StringBuffer buf = null;

				outs = response.getWriter();
				buf = new StringBuffer();

				if (isSuc > 0) {
					buf.append("{Info:[{count:'0',msg:'操作成功！'}]}");
					sendMsg=true;
				} else {
					buf.append("{Info:[{count:'0',msg:'操作失败！'}]}");
				}

				outs.write(buf.toString());
				
			}

			if ("aduit_n".equals(optype)) {
				String opCollegeCode = (String) request
						.getParameter("opCollegeCode");
				if (StringUtils.isNotEmpty(opCollegeCode)) {
					opCollegeCode = URLDecoder.decode(opCollegeCode, "utf-8");
				}
				String opCode = (String) request.getParameter("opCode");
				if (StringUtils.isNotEmpty(opCode)) {
					opCode = URLDecoder.decode(opCode, "utf-8");
				}
				String statusCode = (String) request.getParameter("statusCode");
				if (StringUtils.isNotEmpty(statusCode)) {
					statusCode = URLDecoder.decode(statusCode, "utf-8");
				}
				String creater = (String) request.getParameter("creater");
				if (StringUtils.isNotEmpty(statusCode)) {
					creater = URLDecoder.decode(creater, "utf-8");
				}
				String collegeName=(String) request.getParameter("collegeName");
				if (StringUtils.isNotEmpty(collegeName)) {
					collegeName = URLDecoder.decode(collegeName, "utf-8");
				}

				String[] opCollegeCodeLs = opCollegeCode.split(",");
				String[] opCodeLs = opCode.split(",");
				String[] statusCodeLs = statusCode.split(",");
				String[] creaters=creater.split(",");
				String[] collegeNames=creater.split(",");

				int isSuc = 0;
				//下级审批人的级别
				String operatorSql=null;
				String auditLevel=null;

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

					/**
					 *  ['SUC','已生效'],
					 *  ['FAL','失效/失败'],
						['IN_ADUIT_1','（新增）待一级审核'],
				        ['IN_ADUIT_2','（新增）待二级审核'],
				        ['IN_ADUIT_3','（新增）待三级审核'],
				        ['UPD_ADUIT_0','修改被回退']
				        ['UPD_ADUIT_1','（修改）待一级审核'],
				        ['UPD_ADUIT_2','（修改）待二级审核'],
				        ['UPD_ADUIT_3','（修改）待三级审核'],
				        ['OUT_ADUIT_0','删除被回退'],
				        ['OUT_ADUIT_1','（删除）待一级审核'],
				        ['OUT_ADUIT_2','（删除）待二级审核'],
				        ['OUT_ADUIT_3','（删除）待三级审核']
				        ['IN_AUDIT_0','新增被回退']
					 */
					if ("INSERT".equals(opCodeLs[i])) {
						if ("IN_ADUIT_1".equals(statusCodeLs[i])) {
							sql += " STATUS='FAL' ";
							insertLogSql += " 'INSERT', 'IN_ADUIT_1_N' ";
							auditLevel="失效";
						}
						if ("IN_ADUIT_2".equals(statusCodeLs[i])) {
							sql += " STATUS='IN_ADUIT_1' ";
							insertLogSql += " 'INSERT', 'IN_ADUIT_2_N' ";
							auditLevel="新增待一级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator from AUDIT_COLLEGE_CFG where cityid='"+user.getCityId()+"')";
						}
						if ("IN_ADUIT_3".equals(statusCodeLs[i])) {
							sql += " STATUS='IN_ADUIT_2' ";
							insertLogSql += " 'INSERT', 'IN_ADUIT_3_N' ";
							auditLevel="新增待二级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator2 from AUDIT_COLLEGE_CFG where cityid='"+user.getCityId()+"')";
						}
					}
					if ("UPDATE".equals(opCodeLs[i])) {
						if ("UPD_ADUIT_1".equals(statusCodeLs[i])) {
							sql += " STATUS='UPD_ADUIT_0' ";
							insertLogSql += " 'UPDATE', 'UPD_ADUIT_1_N' ";
							auditLevel="修改被回退";
						}
						if ("UPD_ADUIT_2".equals(statusCodeLs[i])) {
							sql += " STATUS='UPD_ADUIT_1' ";
							insertLogSql += " 'UPDATE', 'UPD_ADUIT_2_N' ";
							auditLevel="修改待一级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator from AUDIT_COLLEGE_CFG where cityid='"+user.getCityId()+"')";
						}
						if ("UPD_ADUIT_3".equals(statusCodeLs[i])) {
							sql += " STATUS='UPD_ADUIT_2' ";
							insertLogSql += " 'UPDATE', 'UPD_ADUIT_3_N' ";
							auditLevel="修改待二级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator2 from AUDIT_COLLEGE_CFG where cityid='"+user.getCityId()+"')";
						}
					}
					if ("DELETE".equals(opCodeLs[i])) {
						if ("OUT_ADUIT_1".equals(statusCodeLs[i])) {
							sql += " STATUS='OUT_ADUIT_0' ";
							insertLogSql += " 'DELETE', 'OUT_ADUIT_1_N' ";
							auditLevel="删除被回退";
						}
						if ("OUT_ADUIT_2".equals(statusCodeLs[i])) {
							sql += " STATUS='OUT_ADUIT_1' ";
							insertLogSql += " 'DELETE', 'OUT_ADUIT_2_N' ";
							auditLevel="删除待一级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator from AUDIT_COLLEGE_CFG where cityid='"+user.getCityId()+"')";
						}
						if ("OUT_ADUIT_3".equals(statusCodeLs[i])) {
							sql += " STATUS='OUT_ADUIT_2' ";
							insertLogSql += " 'DELETE', 'OUT_ADUIT_3_N' ";
							auditLevel="删除待二级审核";
							operatorSql="select mobilephone from FPF_USER_USER where userid= (select operator2 from AUDIT_COLLEGE_CFG where cityid='"+user.getCityId()+"')";
						}
					}
					sql += " where STATUS<>'FAL' AND STATE = 1  and  COLLEGE_id = '"
							+ opCollegeCodeLs[i].toUpperCase() + "'";

					insertLogSql += " FROM  COLLEGE_INFO_PT WHERE STATUS <> 'FAL' AND STATE = 1 AND COLLEGE_ID='"
							+ opCollegeCodeLs[i].toUpperCase() + "'";

					conn = ConnectionManage.getInstance().getDWConnection();
					ps = conn.prepareStatement(insertLogSql);
					ps.execute();

					log.info("sql=" + sql);
					ps = conn.prepareStatement(sql);
					isSuc = ps.executeUpdate();
					
					//发送提醒短信
					//获取下级审核人员手机号
					if(isSuc>0){
						//获得创建人的手机号码
						conn=ConnectionManage.getInstance().getWEBConnection();
						ps=conn.prepareStatement("select mobilephone from FPF_USER_USER where userid='"+creaters[i]+"'");
						rs=ps.executeQuery();
						rs.next();
						curMobilePhone=rs.getString(1);
						if(null!=operatorSql){
							//获取审核人号码
							ps=conn.prepareStatement(operatorSql);
							rs=ps.executeQuery();
							String nextAuditMobile=null;
							if(rs.next()){
								nextAuditMobile=rs.getString(1);
								if(""!=curMobilePhone&&null!=curMobilePhone){
									if(curMobilePhone.trim().matches("[0-9]{11}")){
										sendSmsMessage(new String[]{curMobilePhone,nextAuditMobile}, 
												new String[]{"您提交审批的高校信息已经被驳回,目前状态为"+auditLevel+" !",
																	user.getName()+"已经驳回了"+collegeNames[i]+"高校信息待您审批,谢谢 !"});
									}
								}
							}else{
								if(""!=curMobilePhone&&null!=curMobilePhone){
									if(curMobilePhone.trim().matches("[0-9]{11}")){
										sendSmsMessage(curMobilePhone,"您提交审批的高校信息已经被驳回,目前状态为"+auditLevel+" !");
									}
								}
							}
						}else{
							//状态为SUC
							if(""!=curMobilePhone&&null!=curMobilePhone){
								if(curMobilePhone.trim().matches("[0-9]{11}")){
									sendSmsMessage(curMobilePhone,"您提交审批的高校信息已经被驳回,目前状态为"+auditLevel+" !");
								}
							}
						}
					}
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

//			conn.commit();

			if (rs != null)
				rs.close();
			if (ps != null)
				ps.close();
			if (conn != null)
				conn.close();

		} catch (Exception e) {
			try {
				conn.rollback();
				log.error(e);
				e.printStackTrace();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
	}

	/**
	 * @see 高校待审核查询
	 * @param request
	 * @param response
	 */
	public void queryForAudit(HttpServletRequest request,
			HttpServletResponse response) {
		// String collegeCode = (String) request.getParameter("collegeCode");
		String start = (String) request.getParameter("start");
		String limit = (String) request.getParameter("limit");

		log.info("start=" + start + "; limit=" + limit);
		
		int index = Integer.parseInt(start);
		int pageSize = Integer.parseInt(limit);
		int end = index + pageSize;
		Connection connWeb = null;
		Connection connDW = null;
		ResultSet webRs=null;
		ResultSet dwRs=null;

		String cityStr = (String) request.getParameter("cityStr");
		String areaStr = (String) request.getParameter("areaStr");
		String bName = (String) request.getParameter("bName");
		String cName = (String) request.getParameter("cName");
		String opType = (String) request.getParameter("opType");
		String status = (String) request.getParameter("status");

		log.info("cityStr=" + cityStr + "; areaStr=" + areaStr
				+ ";bName=" + bName + ",cName=" + cName + ",opType=" + opType + ",status=" + status);
		
		try {
			connWeb = ConnectionManage.getInstance().getWEBConnection();

			String userid = (String) request.getSession().getAttribute(
					"loginname");

			StringBuffer buf = new StringBuffer();

			// 判断当前登陆人权限
			String auditSql = "SELECT trim(VALUE(AREA.AREA_CODE,'HB')),  trim(OPERATOR), trim(OPERATOR2)   FROM AUDIT_COLLEGE_CFG ACFG LEFT JOIN mk.bt_area AREA ON TRIM(CHAR(AREA.AREA_ID)) = ACFG.CITYID "
					+ " WHERE 1=1 AND (OPERATOR ='"
					+ userid
					+ "' OR OPERATOR2='" + userid + "')";
			
			log.info("auditSql=" + auditSql);
			PreparedStatement ps = connWeb.prepareStatement(auditSql);
			webRs = ps.executeQuery();

			String operator1 = "";
			String operator2 = "";
			String areaAudit = "FALS";
			String opAudit = "'FALS'";

			if (webRs.next()) {
				areaAudit = webRs.getString(1);
				operator1 = webRs.getString(2);
				operator2 = webRs.getString(3);

				System.out.println(areaAudit);
				System.out.println(operator1);
				System.out.println(operator2);
				if (userid.equals(operator1) && !"HB".equals(areaAudit)) {
					opAudit = "'IN_ADUIT_1','OUT_ADUIT_1','UPD_ADUIT_1'";
				}
				if (userid.equals(operator2) && !"HB".equals(areaAudit)) {
					opAudit = "'IN_ADUIT_2','OUT_ADUIT_2','UPD_ADUIT_2'";
				}
				if (userid.equals(operator1) && "HB".equals(areaAudit)) {
					opAudit = "'IN_ADUIT_3','OUT_ADUIT_3','UPD_ADUIT_3'";
				}
				/**
				 * 测试代码start
				 */
//				if (userid.equals(operator2) && "HB".equals(areaAudit)) {
//					opAudit = "'IN_ADUIT_3','OUT_ADUIT_3','UPD_ADUIT_3','IN_ADUIT_1','OUT_ADUIT_1','UPD_ADUIT_1','IN_ADUIT_2','OUT_ADUIT_2','UPD_ADUIT_2'";
//				}
				/**
				 * 测试代码end
				 */
				if ("HB".equals(areaAudit)) {
					areaAudit = "HB%";
				}

				log.info(opAudit);
				log.info(areaAudit);
				StringBuffer countsql = new StringBuffer(
						"select count(*) from COLLEGE_INFO_PT where STATE = 1 AND STATUS NOT IN ('FAL','SUC') "
								+ " AND STATUS IN ("
								+ opAudit
								+ ") AND AREA_ID LIKE '" + areaAudit + "' ");

				if (StringUtils.isNotEmpty(cityStr)) {
					countsql.append(" and ucase(AREA_ID) like '%"
							+ URLDecoder.decode(cityStr, "utf-8") + "%' ");
				}
				if (StringUtils.isNotEmpty(areaStr)) {
					countsql.append(" and ucase(COLLEGE_ADD) like '%"
							+ URLDecoder.decode(areaStr, "utf-8") + "%' ");
				}
				if (StringUtils.isNotEmpty(bName)) {
					countsql.append(" and ucase(COLLEGE_ID) like '%"
							+ URLDecoder.decode(bName, "utf-8").toUpperCase()
							+ "%' ");
				}
				if (StringUtils.isNotEmpty(cName)) {
					countsql.append(" and ucase(COLLEGE_NAME) like '%"
							+ URLDecoder.decode(cName, "utf-8") + "%' ");
				}
				if (StringUtils.isNotEmpty(status)) {
					countsql.append(" and ucase(STATUS) like '"
							+ URLDecoder.decode(status, "utf-8") + "' ");
				}
				if (StringUtils.isNotEmpty(opType)) {
					countsql.append(" and ucase(OPERATE_TYPE) like '"
							+ URLDecoder.decode(opType, "utf-8") + "' ");
				}
				countsql.append(" with ur");
				log.info(countsql);
				connDW=ConnectionManage.getInstance().getDWConnection();
				ps = connDW.prepareStatement(countsql.toString());
				dwRs = ps.executeQuery();

				int count = 0;
				if (dwRs.next()) {
					count = dwRs.getInt(1);
					log.info(dwRs.getInt(1));
				}
				if (count > 0) {
					StringBuffer sql = new StringBuffer(
							" select aaa.* from (select COLLEGE_ID, COLLEGE_NAME, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
									+ " SHORT_NUMBER, AREA_ID, MANAGER, STUDENTS_NUM, NEW_STUDENTS, "
									+ " STATE_DATE, MANAGER_NBR, "
									+ " CREATE_DATE, (case when OPERATE_TYPE = 'INSERT' then '新增' when OPERATE_TYPE = 'UPDATE' then '修改' ELSE '删除' END) ,"
									+ " (case when STATUS = 'SUC' then '已生效' when STATUS = 'IN_ADUIT_1' then '（新增）待一级审核' when STATUS = 'IN_ADUIT_2' then '（新增）待二级审核' when STATUS = 'IN_ADUIT_3' then '（新增）待三级审核' when STATUS = 'OUT_ADUIT_1' then '（删除）待一级审核' when STATUS = 'OUT_ADUIT_2' then '（删除）待二级审核' when STATUS = 'OUT_ADUIT_3' then '（删除）待三级审核' when STATUS = 'UPD_ADUIT_1' then '（修改）待一级审核' when STATUS = 'UPD_ADUIT_2' then '（修改）待二级审核' when STATUS = 'UPD_ADUIT_3' then '（修改）待三级审核' ELSE '' END),"
									+ " CREATEUSER,STATUS,OPERATE_TYPE,(select cc.AREA_NAME from mk.bt_area cc where cc.AREA_CODE = bb.AREA_ID),"
									+ " row_number() over(partition by 1 ORDER BY AREA_ID,COLLEGE_ID DESC) as row_num"
									+ " from COLLEGE_INFO_PT bb where STATE=1 AND STATUS NOT IN ('FAL','SUC') "
									+ " AND STATUS IN ("
									+ opAudit
									+ ") AND AREA_ID LIKE '" + areaAudit + "' ");
					if (StringUtils.isNotEmpty(cityStr)) {
						sql.append(" and ucase(AREA_ID) like '%"
								+ URLDecoder.decode(cityStr, "utf-8") + "%' ");
					}
					if (StringUtils.isNotEmpty(areaStr)) {
						sql.append(" and ucase(COLLEGE_ADD) like '%"
								+ URLDecoder.decode(areaStr, "utf-8") + "%' ");
					}
					if (StringUtils.isNotEmpty(bName)) {
						sql.append(" and ucase(COLLEGE_ID) like '%"
								+ URLDecoder.decode(bName, "utf-8")
										.toUpperCase() + "%' ");
					}
					if (StringUtils.isNotEmpty(cName)) {
						sql.append(" and ucase(COLLEGE_NAME) like '%"
								+ URLDecoder.decode(cName, "utf-8") + "%' ");
					}
					if (StringUtils.isNotEmpty(status)) {
						sql.append(" and ucase(STATUS) like '"
								+ URLDecoder.decode(status, "utf-8") + "' ");
					}
					if (StringUtils.isNotEmpty(opType)) {
						sql.append(" and ucase(OPERATE_TYPE) like '"
								+ URLDecoder.decode(opType, "utf-8") + "' ");
					}

					sql.append(" ) aaa where row_num > " + index
							+ " and row_num <= " + end + " with ur");

					log.info("sql=" + sql);
					ps = connDW.prepareStatement(sql.toString());
					dwRs = ps.executeQuery();

					buf.append("{Total:").append(count).append(",Info:[");

					for (int i = 0; dwRs.next(); i++) {
						if (i != 0) {
							buf.append(",");
						}
						buf.append("{COLLEGE_ID:'").append(dwRs.getString(1))
								.append("',COLLEGE_NAME:'").append(
										dwRs.getString(2)).append("',WEB_ADD:'")
								.append(dwRs.getString(3)).append(
										"',COLLEGE_TYPE:'").append(
												dwRs.getString(4)).append(
										"',COLLEGE_ADD:'").append(
												dwRs.getString(5)).append(
										"',SHORT_NUMBER:'").append(
												dwRs.getString(6)).append("',AREA_ID:'")
								.append(dwRs.getString(7)).append("',MANAGER:'")
								.append(dwRs.getString(8)).append(
										"',STUDENTS_NUM:'")
								.append(dwRs.getInt(9))
								.append("',NEW_STUDENTS:'").append(
										dwRs.getInt(10)).append("',STATE_DATE:'")
								.append(dwRs.getDate(11)).append(
										"',MANAGER_NBR:'").append(
												dwRs.getString(12)).append(
										"',CREATE_DATE:'").append(
												dwRs.getDate(13)).append(
										"',OPERATE_TYPE_STR:'").append(
												dwRs.getString(14)).append(
										"',STATUS_STR:'").append(
												dwRs.getString(15)).append(
										"',CREATEUSER:'").append(
												dwRs.getString(16)).append("',STATUS:'")
								.append(dwRs.getString(17)).append(
										"',OPERATE_TYPE:'").append(
												dwRs.getString(18)).append(
										"',AREA_ID_STR:'").append(
												dwRs.getString(19)).append("'}");
					}

					buf.append("]}");
				} else {
					buf.append("{Total:0,Info:[{FLAG:''}]}");
				}
			} else {
//				{Info:[{count:'0',msg:'高校信息新增成功，状态更新为（新增）待一级审核！'}]}
				buf.append("{Total:0,Info:[{FLAG:'您不具备审核的权限,请通知市管理员添加 !'}]}");
			}

			webRs.close();
			if(dwRs != null){
				dwRs.close();
			}
			ps.close();

			PrintWriter outs = null;
			outs = response.getWriter();
			outs.write(buf.toString());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("查询出现异常：" + e);
		} finally {
			ConnectionManage.getInstance().releaseConnection(connWeb);
			ConnectionManage.getInstance().releaseConnection(connDW);
		}

	}
	
	public void queryForLog(HttpServletRequest request,HttpServletResponse response){
//		String collegeCode = (String) request.getParameter("collegeCode");
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

		try {
			conn = ConnectionManage.getInstance().getDWConnection();

			StringBuffer countsql =new StringBuffer("select count(*) from COLLEGE_INFO_PT_LOG where STATE = 1 AND STATUS NOT IN ('FAL','SUC') ");

			if (StringUtils.isNotEmpty(cityStr)) {
				countsql .append (" and ucase(AREA_ID) like '%" + URLDecoder.decode(cityStr, "utf-8") + "%' ");
			}
			if (StringUtils.isNotEmpty(areaStr)) {
				countsql .append (" and ucase(COLLEGE_ADD) like '%" + URLDecoder.decode(areaStr, "utf-8") + "%' ");
			}
			if (StringUtils.isNotEmpty(bName)) {
				countsql .append (" and ucase(COLLEGE_ID) like '%" + URLDecoder.decode(bName, "utf-8").toUpperCase() + "%' ");
			}
			if (StringUtils.isNotEmpty(cName)) {
				countsql .append (" and ucase(COLLEGE_NAME) like '%" + URLDecoder.decode(cName, "utf-8") + "%' ");
			}
			if (StringUtils.isNotEmpty(status)) {
				countsql .append (" and ucase(STATUS) like '" + URLDecoder.decode(status, "utf-8") + "' ");
			}
			if (StringUtils.isNotEmpty(opType)) {
				countsql .append (" and ucase(OPERATE_TYPE) like '" + URLDecoder.decode(opType, "utf-8") + "' ");
			}
			countsql .append(" with ur");

			PreparedStatement ps = conn.prepareStatement(countsql.toString());
			ResultSet rs = ps.executeQuery();

			StringBuffer buf = null;
			buf = new StringBuffer();

			int count = 0;
			if (rs.next()) {
				count = rs.getInt(1);
			}
			if (count > 0) {
				StringBuffer sql =new StringBuffer(" select aaa.* from (select COLLEGE_ID, COLLEGE_NAME, WEB_ADD, COLLEGE_TYPE, COLLEGE_ADD,"
						+ " SHORT_NUMBER, AREA_ID, MANAGER, STUDENTS_NUM, NEW_STUDENTS, "
						+ " STATE_DATE, MANAGER_NBR, "
						+ " CREATE_DATE, (case when OPERATE_TYPE = 'INSERT' then '新增' when OPERATE_TYPE = 'UPDATE' then '修改' ELSE '删除' END) ,"
						+ " (case when STATUS = 'IN_NEW' then '（新增）创建' when STATUS = 'OUT_NEW' then '（删除）创建' when STATUS = 'UPD_NEW' then '（修改）创建' "
						+" when STATUS = 'IN_ADUIT_1' then '（新增）一级审核通过' when STATUS = 'IN_ADUIT_2' then '（新增）二级审核通过' when STATUS = 'IN_ADUIT_3' then '（新增）三级审核通过' "
						+" when STATUS = 'OUT_ADUIT_1' then '（删除）一级审核通过' when STATUS = 'OUT_ADUIT_2' then '（删除）二级审核通过' when STATUS = 'OUT_ADUIT_3' then '（删除）三级审核通过' "
						+" when STATUS = 'UPD_ADUIT_1' then '（修改）一级审核通过' when STATUS = 'UPD_ADUIT_2' then '（修改）二级审核通过' when STATUS = 'UPD_ADUIT_3' then '（修改）三级审核通过' "
						+" when STATUS = 'IN_ADUIT_1_N' then '（新增）一级审核不通过' when STATUS = 'IN_ADUIT_2_N' then '（新增）二级审核不通过' when STATUS = 'IN_ADUIT_3_N' then '（新增）三级审核不通过' "
						+" when STATUS = 'OUT_ADUIT_1_N' then '（删除）一级审核不通过' when STATUS = 'OUT_ADUIT_2_N' then '（删除）二级审核不通过' when STATUS = 'OUT_ADUIT_3_N' then '（删除）三级审核不通过' "
						+" when STATUS = 'UPD_ADUIT_1_N' then '（修改）一级审核不通过' when STATUS = 'UPD_ADUIT_2_N' then '（修改）二级审核不通过' when STATUS = 'UPD_ADUIT_3_N' then '（修改）三级审核不通过' "
						+" ELSE '' END),"
						+ " CREATEUSER,STATUS,OPERATE_TYPE,(select cc.AREA_NAME from mk.bt_area cc where cc.AREA_CODE = bb.AREA_ID),"
						+ " row_number() over(partition by 1 ORDER BY AREA_ID,COLLEGE_ID DESC) as row_num"
						+ " from COLLEGE_INFO_PT_LOG bb where STATE=1 AND STATUS NOT IN ('FAL','SUC') ");
				if (StringUtils.isNotEmpty(cityStr)) {
					sql .append (" and ucase(AREA_ID) like '%" + URLDecoder.decode(cityStr, "utf-8") + "%' ");
				}
				if (StringUtils.isNotEmpty(areaStr)) {
					sql .append (" and ucase(COLLEGE_ADD) like '%" + URLDecoder.decode(areaStr, "utf-8") + "%' ");
				}
				if (StringUtils.isNotEmpty(bName)) {
					sql .append (" and ucase(COLLEGE_ID) like '%" + URLDecoder.decode(bName, "utf-8").toUpperCase() + "%' ");
				}
				if (StringUtils.isNotEmpty(cName)) {
					sql .append (" and ucase(COLLEGE_NAME) like '%" + URLDecoder.decode(cName, "utf-8") + "%' ");
				}
				if (StringUtils.isNotEmpty(status)) {
					sql .append (" and ucase(STATUS) like '" + URLDecoder.decode(status, "utf-8") + "' ");
				}
				if (StringUtils.isNotEmpty(opType)) {
					sql .append (" and ucase(OPERATE_TYPE) like '" + URLDecoder.decode(opType, "utf-8") + "' ");
				}

				sql .append (" ) aaa where row_num > " + index + " and row_num <= "
						+ end + " with ur");

				ps = conn.prepareStatement(sql.toString());
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
									"',OPERATE_TYPE_STR:'").append(
									rs.getString(14)).append("',STATUS_STR:'")
							.append(rs.getString(15)).append(
									"',CREATEUSER:'").append(
									rs.getString(16)).append(
									"',STATUS:'").append(
											rs.getString(17)).append(
											"',OPERATE_TYPE:'").append(
													rs.getString(18)).append(
													"',AREA_ID_STR:'").append(
															rs.getString(19)).append("'}");
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
		} catch (Exception e) {
			log.error(e);
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
	}
	
	/**
	 * 高校基站审核人变更
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@ActionMethod(isLog = false)
	public void updateCollegeAuditFlow(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		// 取得要修改审核人的地市ID
		String cityId = request.getParameter("cityId");
		// 取得一级审核人
		String audit1 = request.getParameter("audit1");
		// 取得二级审核人
		String audit2 = request.getParameter("audit2");

		Connection conn = null;
		PreparedStatement ps = null;
		try {
			log.info("修改基站审核员：一级审核员="+audit1+"二级审核员："+audit2+"修改城市："+cityId);
			conn = ConnectionManage.getInstance().getWEBConnection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("update AUDIT_COLLEGE_CFG set OPERATOR = '"
								+ audit1
								+ "',OPERATOR2= '"
								+ audit2
								+ "' where CITYID = "
								+ cityId);
			ps.execute();
			ps.close();
			conn.commit();
			log.info("修改成功");
		} catch (SQLException e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();

		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
	}
	
	public void sendSmsMessage(String phone,String msg){
		log.info("单人sendSmsMessage开始");
		log.info("phone=" + phone);
		log.info("msg=" + msg);
		if(StringUtils.isNotEmpty(phone)){
			//通过此方法无法发送短信，暂时先注释 2017-03-23
//			SendSMSWrapper.send(phone,msg);
		}
		log.info("单人sendSmsMessage结束");
	}
	
	public void sendSmsMessage(String[] phones,String[] msgs){
		log.info("多条sendSmsMessage开始：");
		for(int i=0; i<phones.length; i++){
			log.info(phones[i] + ":" + msgs[i] + ",");
		}
		for(int i=0;i<phones.length;i++){
			if(StringUtils.isNotEmpty(phones[i])){
				//通过此方法无法发送短信，暂时先注释 2017-03-23
//				SendSMSWrapper.send(phones[i],msgs[i]);
			}
		}
		log.info("多条sendSmsMessage结束");
	}
	
	public void getCity(HttpServletRequest request,HttpServletResponse response){
		String sql="select area_code value,area_name text from nmk.cmcc_area";
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", "web");
		try{
			Object obj= sqlQuery.query(sql);
			
			response.getWriter().print(obj);
		}catch(Exception ex){
			log.info("获取地市编码sql异常",ex);
		}
	}
}
