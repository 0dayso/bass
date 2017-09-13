package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hb.web.models.User;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.component.msg.sms.SendSMSWrapper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;

/**
 * 区域化基站参数维护
 * 
 * @author lizhijianR
 * 
 */	
@SuppressWarnings({"unused","resource"})
public class AreaSaleManageAction extends Action {

	private static Logger LOG = Logger.getLogger(AreaSaleManageAction.class);


	private JsonHelper jsonHelper = JsonHelper.getInstance();

	/**
	 * 基站新增、删除信息审核
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */

	@ActionMethod(isLog = false)
	public void bureauNewdel(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 取得要批量审批的ID
		String ids = request.getParameter("ids");
		// 取得审批结果（通过或者不通过）
		String result = request.getParameter("result");
		// 修改原始状态
		String oldStatus = request.getParameter("result");
		String eff_type = request.getParameter("eff_type");

		String[] idArr = null;
		if (ids != null && ids.length() > 0) {
			idArr = ids.split(",");
		}
		if (idArr.length > 0) {
			String userid = (String) request.getSession().getAttribute("loginname");

			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				int _delnum = 0;
				int _newnum = 0;
				for (int i = 0; i < idArr.length; i++) {
					String id = idArr[i];
					// 根据ID获得原状态
					ps = conn.prepareStatement("select STATUS,OPERATE_TYPE from BUREAU_CELL_NEWDEL_INFO where NEWDELCELL_SEQ = " + id + "");
					rs = ps.executeQuery();
					String status = null;
					if (rs.next()) {
						status = rs.getString(1);
						if (status != null && status.length() > 4) {
							// 修改成新记录的状态
							status = status.substring(4);
							System.out.println("status:" + status);
						}
						if (rs.getString("OPERATE_TYPE").equalsIgnoreCase("del")) {
							_delnum++;
						}
						if (rs.getString("OPERATE_TYPE").equalsIgnoreCase("new")) {
							_newnum++;
						}
					}
					rs.close();
					ps.close();

					// 记录审批日志
					ps = conn.prepareStatement("insert into BUREAU_CELL_NEWDEL_AUDIT_LOG (NEWDELCELL_SEQ, OPERATE_TYPE, OPERATE_RESULT, OPERATE_DATE, OPERATOR) values (?,?,?,?,?)");
					java.util.Date date = new java.util.Date();
					ps.setInt(1, Integer.valueOf(id));
					ps.setString(2, status);
					ps.setString(3, result);
					ps.setTimestamp(4, new Timestamp(date.getTime()));
					ps.setString(5, userid);
					ps.execute();
					ps.close();

					// 待一级审核成功以后变参为待二级审核
					if ("succ".equals(result) && "audit1".equals(status)) {
						oldStatus = "waitaudit2";
					}
					if ("fail".equals(result) && "audit1".equalsIgnoreCase(status)) {
						oldStatus = "fail";
					}
					// 待二级审核变为待三级审核
					if ("succ".equals(result) && "audit2".equalsIgnoreCase(status)) {
						oldStatus = "waitaudit3";
					}
					if ("fail".equals(result) && "audit2".equalsIgnoreCase(status)) {
						oldStatus = "fail";
					}
					// 待三级审核变为审核通过
					if ("succ".equals(result) && "audit3".equalsIgnoreCase(status)) {
						oldStatus = "succ";
					}
					if ("fail".equals(result) && "audit3".equalsIgnoreCase(status)) {
						oldStatus = "fail";
					}
					// 修改原记录状态
					if (eff_type == null || "".equals(eff_type)) {
						ps = conn.prepareStatement("update BUREAU_CELL_NEWDEL_INFO set STATUS = '" + oldStatus + "',STATE_DATE=? where NEWDELCELL_SEQ = " + id + "");
						System.out.println("excuteSql:" + "update BUREAU_CELL_NEWDEL_INFO set STATUS = '" + oldStatus + "',STATE_DATE=? where NEWDELCELL_SEQ = " + id + "");
					} else {
						ps = conn.prepareStatement("update BUREAU_CELL_NEWDEL_INFO set STATUS = '" + oldStatus + "',eff_type='" + eff_type + "',STATE_DATE=? where NEWDELCELL_SEQ = " + id + "");
						System.out.println("excuteSql:" + "update BUREAU_CELL_NEWDEL_INFO set STATUS = '" + oldStatus + "',eff_type='" + eff_type + "',STATE_DATE=? where NEWDELCELL_SEQ = " + id + "");
						
					}

					date = new java.util.Date();
					ps.setTimestamp(1, new Timestamp(date.getTime()));
					ps.execute();
					ps.close();
					conn.commit();
				}

				// 添加发送短信
				if (_delnum != 0 || _newnum != 0) {
					String msg = "在区域化中有" + _newnum + "个新增基站," + _delnum + "个删除基站。需要审核,请及时审核！";
					getNextUserSMS(userid, msg);
				}
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
	}

	/**
	 * 基站信息变更审核
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@ActionMethod(isLog = false)
	public void bureauChange(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 取得要批量审批的ID
		String ids = request.getParameter("ids");
		// 取得审批结果（通过或者不通过）
		String result = request.getParameter("result");
		// 修改原始状态
		String oldStatus = request.getParameter("result");
		String eff_type = request.getParameter("eff_type");

		String[] idArr = null;
		if (ids != null && ids.length() > 0) {
			idArr = ids.split(",");
		}
		if (idArr.length > 0) {
			String userid = (String) request.getSession().getAttribute("loginname");

			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				int _delnum = 0;
				int _newnum = 0;
				for (int i = 0; i < idArr.length; i++) {
					String id = idArr[i];
					// 根据ID获得原状态
					ps = conn.prepareStatement("select STATUS,chang_type from BUREAU_CELL_CHANGE_INFO where CHANGECELL_SEQ = " + id + "");
					rs = ps.executeQuery();
					String status = null;
					if (rs.next()) {
						status = rs.getString(1);
						if (status != null && status.length() > 4) {
							// 修改成新记录的状态
							status = status.substring(4);
						}
						if (rs.getString(2).equalsIgnoreCase("ChangeCellTown")) {
							_delnum++;
						}
						if (rs.getString(2).equalsIgnoreCase("ChangeCellName")) {
							_newnum++;
						}
					}
					rs.close();
					ps.close();

					// 记录审批日志
					ps = conn.prepareStatement("insert into BUREAU_CELL_CHANGE_AUDIT_LOG (CHANGECELL_SEQ, OPERATE_TYPE, OPERATE_RESULT, OPERATE_DATE, OPERATOR) values (?,?,?,?,?)");
					java.util.Date date = new java.util.Date();
					ps.setInt(1, Integer.valueOf(id));
					ps.setString(2, status);
					ps.setString(3, result);
					ps.setTimestamp(4, new Timestamp(date.getTime()));
					ps.setString(5, userid);
					ps.execute();
					ps.close();

					// 待一级审核成功以后变参为待二级审核
					if ("succ".equals(result) && "audit1".equals(status)) {
						oldStatus = "waitaudit2";
					}
					if ("fail".equals(result) && "audit1".equalsIgnoreCase(status)) {
						oldStatus = "fail";
					}
					// 待二级审核变为待三级审核
					if ("succ".equals(result) && "audit2".equalsIgnoreCase(status)) {
						oldStatus = "waitaudit3";
					}
					if ("fail".equals(result) && "audit2".equalsIgnoreCase(status)) {
						oldStatus = "fail";
					}
					// 待三级审核变为审核通过
					if ("succ".equals(result) && "audit3".equalsIgnoreCase(status)) {
						oldStatus = "succ";
					}
					if ("fail".equals(result) && "audit3".equalsIgnoreCase(status)) {
						oldStatus = "fail";
					}
					// 修改原记录状态
					if (eff_type == null || "".equals(eff_type)) {
						ps = conn.prepareStatement("update BUREAU_CELL_CHANGE_INFO set STATUS = '" + oldStatus + "',STATE_DATE=? where CHANGECELL_SEQ = " + id + "");
					} else {
						ps = conn.prepareStatement("update BUREAU_CELL_CHANGE_INFO set STATUS = '" + oldStatus + "',eff_type='" + eff_type + "',STATE_DATE=? where CHANGECELL_SEQ = " + id + "");
					}

					date = new java.util.Date();
					ps.setTimestamp(1, new Timestamp(date.getTime()));
					ps.execute();
					ps.close();
					conn.commit();
				}
				// 添加发送短信
				if (_delnum != 0 || _newnum != 0) {
					String msg = "在基站信息变更审核中有" + _newnum + "个更改乡镇," + _delnum + "个更改名称。需要审核,请及时审核！";
					getNextUserSMS(userid, msg);
				}
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
	}
	
	/**
	 * 基站审核人变更
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@ActionMethod(isLog = false)
	public void updateAuditFlow(HttpServletRequest request,
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
			LOG.info("修改基站审核员：一级审核员="+audit1+"二级审核员："+audit2+"修改城市："+cityId);
			conn = ConnectionManage.getInstance().getWEBConnection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement("update FPF_AUDIT_FLOW set OPERATOR = '"
								+ audit1
								+ "',OPERATOR2= '"
								+ audit2
								+ "' where CITYID = "
								+ cityId);
			ps.execute();
			ps.close();
			conn.commit();
			LOG.info("修改成功");
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

	/**
	 * LAC码变更审核
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@ActionMethod(isLog = false)
	public void lacChange(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 取得要批量审批的ID
		String ids = request.getParameter("ids");
		// 取得审批结果（通过或者不通过）
		String result = request.getParameter("result");
		// 修改原始状态
		String oldStatus = request.getParameter("result");
		String eff_type = request.getParameter("eff_type");

		String[] idArr = null;
		if (ids != null && ids.length() > 0) {
			idArr = ids.split(",");
		}
		if (idArr.length > 0) {
			String userid = (String) request.getSession().getAttribute("loginname");

			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);

				int _newnum = 0;
				for (int i = 0; i < idArr.length; i++) {
					String id = idArr[i];
					// 根据ID获得原状态
					ps = conn.prepareStatement("select STATUS from BUREAU_LAC_CHANGE_INFO where CHANGLAC_SEQ = " + id + "");
					rs = ps.executeQuery();
					String status = null;
					if (rs.next()) {
						status = rs.getString(1);
						if (status != null && status.length() > 4) {
							// 修改成新记录的状态
							status = status.substring(4);
						}
						_newnum++;
					}
					rs.close();
					ps.close();

					// 记录审批日志
					ps = conn.prepareStatement("insert into BUREAU_LAC_CHANGE_AUDIT_LOG (CHANGLAC_SEQ, OPERATE_TYPE, OPERATE_RESULT, OPERATE_DATE, OPERATOR) values (?,?,?,?,?)");
					java.util.Date date = new java.util.Date();
					ps.setInt(1, Integer.parseInt(id));
					ps.setString(2, status);
					ps.setString(3, result);
					ps.setTimestamp(4, new Timestamp(date.getTime()));
					ps.setString(5, userid);
					ps.execute();
					ps.close();

					// 待一级审核成功以后变参为待二级审核
					if ("succ".equals(result) && "audit1".equals(status)) {
						oldStatus = "waitaudit2";
					}
					if ("fail".equals(result) && "audit1".equals(status)) {
						oldStatus = "fail";
					}
					// 待二级审核变为待三级审核
					if ("succ".equals(result) && "audit2".equalsIgnoreCase(status)) {
						oldStatus = "waitaudit3";
					}
					if ("fail".equals(result) && "audit2".equalsIgnoreCase(status)) {
						oldStatus = "fail";
					}
					// 待三级审核变为审核通过
					if ("succ".equals(result) && "audit3".equalsIgnoreCase(status)) {
						oldStatus = "succ";
					}
					if ("fail".equals(result) && "audit3".equalsIgnoreCase(status)) {
						oldStatus = "fail";
					}
					// 修改原记录状态
					if (eff_type == null || "".equals(eff_type)) {
						ps = conn.prepareStatement("update BUREAU_LAC_CHANGE_INFO set STATUS = '" + oldStatus + "',STATE_DATE=? where CHANGLAC_SEQ = " + id + "");
					} else {
						ps = conn.prepareStatement("update BUREAU_LAC_CHANGE_INFO set STATUS = '" + oldStatus + "',eff_type='" + eff_type + "',STATE_DATE=? where CHANGLAC_SEQ = " + id + "");
					}
					date = new java.util.Date();
					ps.setTimestamp(1, new Timestamp(date.getTime()));
					ps.execute();
					ps.close();
					conn.commit();
				}
				// 添加发送短信
				if (_newnum != 0) {
					String msg = "在lac码变更审核中有" + _newnum + "个lac码变更。需要审核,请及时审核！";
					getNextUserSMS(userid, msg);
				}
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
	}

	/**
	 * 层级关系信息新增、删除审核
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@ActionMethod(isLog = false)
	public void bureauTreeNewdel(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 取得要批量审批的ID
		String ids = request.getParameter("ids");
		// 取得审批结果（通过或者不通过）
		String result = request.getParameter("result");
		// 修改原始状态
		String oldStatus = request.getParameter("result");
		String eff_type = request.getParameter("eff_type");

		String[] idArr = null;
		if (ids != null && ids.length() > 0) {
			idArr = ids.split(",");
		}
		if (idArr.length > 0) {
			String userid = (String) request.getSession().getAttribute("loginname");

			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			int _delnum = 0;
			int _newnum = 0;
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				for (int i = 0; i < idArr.length; i++) {
					String id = idArr[i];
					// 根据ID获得原状态
					ps = conn.prepareStatement("select STATUS,OPERATE_TYPE from BUREAU_TREE_NEWDEL_INFO where newdeltree_seq = " + id + "");
					rs = ps.executeQuery();
					String status = null;
					if (rs.next()) {
						status = rs.getString(1);
						if (status != null && status.length() > 4) {
							// 修改成新记录的状态
							status = status.substring(4);
						}
						if (rs.getString("OPERATE_TYPE").equalsIgnoreCase("del")) {
							_delnum++;
						}
						if (rs.getString("OPERATE_TYPE").equalsIgnoreCase("new")) {
							_newnum++;
						}
					}
					rs.close();
					ps.close();

					// 记录审批日志
					ps = conn.prepareStatement("insert into BUREAU_TREE_NEWDEL_AUDIT_LOG (newdeltree_seq, OPERATE_TYPE, OPERATE_RESULT, OPERATE_DATE, OPERATOR) values (?,?,?,?,?)");
					java.util.Date date = new java.util.Date();
					ps.setInt(1, Integer.valueOf(id));
					ps.setString(2, status);
					ps.setString(3, result);
					ps.setTimestamp(4, new Timestamp(date.getTime()));
					ps.setString(5, userid);
					ps.execute();
					ps.close();

					// 待一级审核成功以后变参为待二级审核
					if ("succ".equals(result) && "audit1".equals(status)) {
						oldStatus = "waitaudit2";
					}
					if ("fail".equals(result) && "audit1".equals(status)) {
						oldStatus = "fail";
					}
					// 待二级审核变为待三级审核
					if ("succ".equals(result) && "audit2".equalsIgnoreCase(status)) {
						oldStatus = "waitaudit3";
					}
					if ("fail".equals(result) && "audit2".equals(status)) {
						oldStatus = "fail";
					}
					// 待三级审核变为审核通过
					if ("succ".equals(result) && "audit3".equalsIgnoreCase(status)) {
						oldStatus = "succ";
					}
					if ("fail".equals(result) && "audit3".equals(status)) {
						oldStatus = "fail";
					}
					// 修改原记录状态
					if (eff_type == null || "".equals(eff_type)) {
						ps = conn.prepareStatement("update BUREAU_TREE_NEWDEL_INFO set STATUS = '" + oldStatus + "',STATE_DATE=? where newdeltree_seq = " + id + "");
					} else {
						ps = conn.prepareStatement("update BUREAU_TREE_NEWDEL_INFO set STATUS = '" + oldStatus + "',eff_type='" + eff_type + "',STATE_DATE=? where newdeltree_seq = " + id + "");
					}

					date = new java.util.Date();
					ps.setTimestamp(1, new Timestamp(date.getTime()));
					ps.execute();
					ps.close();
					conn.commit();

				}
				// 添加发送短信
				if (_delnum != 0 || _newnum != 0) {
					String msg = "在区域化中有" + _newnum + "个新增层级关系," + _delnum + "个删除层级关系。需要审核,请及时审核！";
					getNextUserSMS(userid, msg);
				}
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
	}

	/**
	 * 层级关系信息变更审核
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@ActionMethod(isLog = false)
	public void bureauTreeChange(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 取得要批量审批的ID
		String ids = request.getParameter("ids");
		// 取得审批结果（通过或者不通过）
		String result = request.getParameter("result");
		// 修改原始状态
		String oldStatus = request.getParameter("result");
		String eff_type = request.getParameter("eff_type");

		String[] idArr = null;
		if (ids != null && ids.length() > 0) {
			idArr = ids.split(",");
		}
		if (idArr.length > 0) {
			String userid = (String) request.getSession().getAttribute("loginname");

			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				int _newnum = 0;
				for (int i = 0; i < idArr.length; i++) {
					String id = idArr[i];
					// 根据ID获得原状态
					ps = conn.prepareStatement("select STATUS from BUREAU_TREE_CHANGE_INFO where CHANGETREE_SEQ = " + id + "");
					rs = ps.executeQuery();
					String status = null;
					if (rs.next()) {
						status = rs.getString(1);
						if (status != null && status.length() > 4) {
							// 修改成新记录的状态
							status = status.substring(4);
							_newnum++;
						}
					}
					rs.close();
					ps.close();

					// 记录审批日志
					ps = conn.prepareStatement("insert into BUREAU_TREE_CHANGE_Audit_log (CHANGETREE_SEQ, OPERATE_TYPE, OPERATE_RESULT, OPERATE_DATE, OPERATOR) values (?,?,?,?,?)");
					java.util.Date date = new java.util.Date();
					ps.setInt(1, Integer.valueOf(id));
					ps.setString(2, status);
					ps.setString(3, result);
					ps.setTimestamp(4, new Timestamp(date.getTime()));
					ps.setString(5, userid);
					ps.execute();
					ps.close();

					// 待一级审核成功以后变参为待二级审核
					if ("succ".equals(result) && "audit1".equals(status)) {
						oldStatus = "waitaudit2";
					}
					if ("fail".equals(result) && "audit1".equals(status)) {
						oldStatus = "fail";
					}
					// 待二级审核变为待三级审核
					if ("succ".equals(result) && "audit2".equalsIgnoreCase(status)) {
						oldStatus = "waitaudit3";
					}
					if ("fail".equals(result) && "audit2".equals(status)) {
						oldStatus = "fail";
					}
					// 待三级审核变为审核通过
					if ("succ".equals(result) && "audit3".equalsIgnoreCase(status)) {
						oldStatus = "succ";
					}
					if ("fail".equals(result) && "audit3".equals(status)) {
						oldStatus = "fail";
					}
					// 修改原记录状态
					if (eff_type == null || "".equals(eff_type)) {
						ps = conn.prepareStatement("update BUREAU_TREE_CHANGE_INFO set STATUS = '" + oldStatus + "',STATE_DATE=? where CHANGETREE_SEQ = " + id + "");
					} else {
						ps = conn.prepareStatement("update BUREAU_TREE_CHANGE_INFO set STATUS = '" + oldStatus + "',eff_type='" + eff_type + "',STATE_DATE=? where CHANGETREE_SEQ = " + id + "");
					}

					date = new java.util.Date();
					ps.setTimestamp(1, new Timestamp(date.getTime()));
					ps.execute();
					ps.close();
					conn.commit();
				}
				// 添加发送短信
				if (_newnum != 0) {
					String msg = "在层级关系信息变更审核中有" + _newnum + "个层级关系变更。需要审核,请及时审核！";
					getNextUserSMS(userid, msg);
				}
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
	}

	/**
	 * 高校新增、删除基站审核
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@ActionMethod(isLog = false)
	public void collegeBureauNewdel(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 取得要批量审批的ID
		String ids = request.getParameter("ids");
		// 取得审批结果（通过或者不通过）
		String result = request.getParameter("result");
		// 修改原始状态
		String oldStatus = request.getParameter("result");
		String eff_type = request.getParameter("eff_type");

		String[] idArr = null;
		if (ids != null && ids.length() > 0) {
			idArr = ids.split(",");
		}
		if (idArr.length > 0) {
			String userid = (String) request.getSession().getAttribute("loginname");

			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;
			try {
				conn = ConnectionManage.getInstance().getDWConnection();
				conn.setAutoCommit(false);
				for (int i = 0; i < idArr.length; i++) {
					String id = idArr[i];
					// 根据ID获得原状态
					ps = conn.prepareStatement("select STATE from COLLEGE_BUREAU_INFO where COLLEGEBUREAU_SEQ = " + id + "");
					rs = ps.executeQuery();
					String status = null;
					if (rs.next()) {
						status = rs.getString(1);
						if (status != null && status.length() > 4) {
							// 修改成新记录的状态
							status = status.substring(4);
						}
					}
					rs.close();
					ps.close();

					// 记录审批日志
					ps = conn.prepareStatement("insert into COLLEGE_BUREAU_AUDIT_LOG (COLLEGEBUREAU_SEQ, OPERATE_TYPE, OPERATE_RESULT, OPERATE_DATE, OPERATOR) values (?,?,?,?,?)");
					java.util.Date date = new java.util.Date();
					ps.setInt(1, Integer.valueOf(id));
					ps.setString(2, status);
					ps.setString(3, result);
					ps.setTimestamp(4, new Timestamp(date.getTime()));
					ps.setString(5, userid);
					ps.execute();
					ps.close();

					// 待一级审核成功以后变参为待二级审核
					if ("succ".equals(result) && "audit1".equals(status)) {
						oldStatus = "waitaudit2";
					}
					// 修改原记录状态
					if (eff_type == null || "".equals(eff_type)) {
						ps = conn.prepareStatement("update COLLEGE_BUREAU_INFO set STATE = '" + oldStatus + "',STATE_DATE=? where COLLEGEBUREAU_SEQ = " + id + "");
					} else {
						ps = conn.prepareStatement("update COLLEGE_BUREAU_INFO set STATE = '" + oldStatus + "',eff_type='" + eff_type + "',STATE_DATE=? where COLLEGEBUREAU_SEQ = " + id + "");
					}

					date = new java.util.Date();
					ps.setTimestamp(1, new Timestamp(date.getTime()));
					ps.execute();
					ps.close();
					conn.commit();
				}
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
	}

	/**
	 * 生成选择地区的树
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void nodes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String id = request.getParameter("node");

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", "JDBC_HB");
		String result = (String) sqlQuery
				.query("select id,name text,case when level=4 then 'true' else 'false' end leaf,case when level=1 then 'area_code='||chr(39)||id||chr(39) when level=2 then 'county_code='||chr(39)||id||chr(39) when level=3 then 'zone_code='||chr(39)||id||chr(39) when level=4 then 'town_code='||chr(39)||id||chr(39)  end url from  bureau_tree where  pid='"
						+ id + "' order by 1 with ur");

		LOG.debug(result.toString().replaceAll("\"false\"", "false"));

		response.getWriter().write(result.toString().replaceAll("\"false\"", "false"));
	}

	/**
	 * 地区高校树
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void Areanodes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String id = request.getParameter("node");

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", "JDBC_HB");
		String result = null;
		if (id != null && Integer.parseInt(id) <= 27) {
			result = (String) sqlQuery.query("select id,name text,case when level=4 then 'true' else 'false' end leaf,area_code url from  bureau_tree where  pid='" + id + "' order by 1 with ur ");
		} else {
			result = (String) sqlQuery.query("select college_id,college_name text,'true' leaf ,college_id url from   COLLEGE_INFO where area_id in (select area_code from  bt_area where old_code=" + id + ") order by 2 with ur ");
		}
		LOG.debug(result.toString().replaceAll("\"false\"", "false"));

		response.getWriter().write(result.toString().replaceAll("\"false\"", "false"));
	}

	/**
	 * 地区高校树(增加登陆用户地域权限)
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void AreanodesByRegionId(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String id = request.getParameter("node");

		User user = (User) request.getSession().getAttribute("user");

		String cityId = user.getCityId();
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", "JDBC_HB");
		String result = null;
		if (id != null && Integer.parseInt(id) == -1) {
			result = (String) sqlQuery.query("select id,name text,'false' leaf,area_code url from  bureau_tree where pid='" + id + "' order by 1 with ur ");
			LOG.debug("select id,name text,'false' leaf,area_code url from  bureau_tree where pid='" + id + "' order by 1 with ur ");
		} else if (id != null && Integer.parseInt(id) <= 27 && Integer.parseInt(id) >= 0) {
			if ("0".equals(cityId)) {
				result = (String) sqlQuery.query("select id,name text,'false' leaf,area_code url from  bureau_tree where pid='" + id + "' order by 1 with ur ");
				LOG.debug("select id,name text,'false' leaf,area_code url from  bureau_tree where pid='" + id + "' order by 1 with ur ");
			} else {
				result = (String) sqlQuery.query("select id,name text,'false' leaf,area_code url from  bureau_tree where AREA_CODE=(select area_code from  bt_area where area_id=" + cityId + ") and  pid='" + id + "' order by 1 with ur ");
				LOG.debug("select id,name text,'false' leaf,area_code url from  bureau_tree where AREA_CODE=(select area_code from  bt_area where area_id=" + cityId + ") and  pid='" + id + "' order by 1 with ur ");
			}
		} else {
			result = (String) sqlQuery.query("select college_id,college_name text,'true' leaf ,college_id url from   COLLEGE_INFO where area_id in (select area_code from  bt_area where old_code=" + id + ") and STATE = 1 order by 2 with ur ");
			LOG.info("select college_id,college_name text,'true' leaf ,college_id url from   COLLEGE_INFO where area_id in (select area_code from  bt_area where old_code=" + id + ") and STATE = 1 order by 2 with ur ");
		}
		LOG.debug(result.toString().replaceAll("\"false\"", "false"));

		response.getWriter().write(result.toString().replaceAll("\"false\"", "false"));
	}

	/**
	 * 生成选择地区的树(增加登陆用户地域权限)
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void nodesByRegionId(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String id = request.getParameter("node");
		User user = (User) request.getSession().getAttribute("user");

		String cityId = user.getCityId();

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json", "JDBC_HB");

		String result = null;
		if (id != null && "-1".equals(id.toString())) {
			result = (String) sqlQuery
					.query("select id,name text,'false' leaf,case when level=1 then 'area_code='||chr(39)||id||chr(39) when level=2 then 'county_code='||chr(39)||id||chr(39) when level=3 then 'zone_code='||chr(39)||id||chr(39) when level=4 then 'town_code='||chr(39)||id||chr(39)  end url from  bureau_tree where pid='"
							+ id + "' order by 1 with ur ");
			LOG.debug("select id,name text,'false' leaf,case when level=1 then 'area_code='||chr(39)||id||chr(39) when level=2 then 'county_code='||chr(39)||id||chr(39) when level=3 then 'zone_code='||chr(39)||id||chr(39) when level=4 then 'town_code='||chr(39)||id||chr(39)  end url from  bureau_tree where pid='"
					+ id + "' order by 1 with ur ");
		} else {
			String sql = "";
			if ("0".equals(cityId)) {
				sql = "select id,name text,case when level=4 then 'true' else 'false' end leaf,case when level=1 then 'area_code='||chr(39)||id||chr(39) when level=2 then 'county_code='||chr(39)||id||chr(39) when level=3 then 'zone_code='||chr(39)||id||chr(39) when level=4 then 'town_code='||chr(39)||id||chr(39)  end url from  bureau_tree where  pid='"
					+ id + "' order by 1 with ur";
			} else {
				sql = "select id,name text,case when level=4 then 'true' else 'false' end leaf,case when level=1 then 'area_code='||chr(39)||id||chr(39) when level=2 then 'county_code='||chr(39)||id||chr(39) when level=3 then 'zone_code='||chr(39)||id||chr(39) when level=4 then 'town_code='||chr(39)||id||chr(39)  end url from  bureau_tree where  pid='"
					+ id + "' and AREA_CODE=(select area_code from  bt_area where area_id=" + cityId + ") order by 1 with ur";
			}
			result = (String) sqlQuery.query(sql);
			LOG.debug(sql);
		}

		LOG.debug(result.toString().replaceAll("\"false\"", "false"));

		response.getWriter().write(result.toString().replaceAll("\"false\"", "false"));
	}

	// 根据用户id发送短信
	public boolean sendSMS(String userName, String msg) {

		ResultSet rst = null;
		Connection connweb = null;
		PreparedStatement pstmt = null;
		boolean _flag = false;
		try {
			ConnectionManage connManage = ConnectionManage.getInstance();
			connweb = connManage.getWEBConnection();
			String sql = "select USERID,USERNAME,MOBILEPHONE from FPF_USER_USER WHERE USERID='" + userName + "'";

			pstmt = connweb.prepareStatement(sql);
			rst = pstmt.executeQuery();
			String phone = null;
			String usercnName = null;
			if (rst.next()) {
				phone = rst.getString("MOBILEPHONE");
				usercnName = rst.getString("USERNAME");
			}
			msg = usercnName + ",您有以下信息需要关注!" + msg;

			if (phone != null && msg != null) {
				SendSMSWrapper.send(phone, msg);
				_flag = true;
			}
		} catch (SQLException e) {
		
			e.printStackTrace();
			_flag = false;
		} finally {
			try {
				if (rst != null)
					rst.close();
				if (pstmt != null)
					pstmt.close();
				if (connweb != null)
					ConnectionManage.getInstance().releaseConnection(connweb);
			} catch (SQLException e) {
			
				e.printStackTrace();
			}

		}
		return _flag;

	}

	// 根据当前审核人获取下一步审核人并发送短信
	public boolean getNextUserSMS(String userid, String Msg) {
		ResultSet rst = null;
		Connection connweb = null;
		PreparedStatement pstmt = null;
		boolean _flag = false;
		try {
			ConnectionManage connManage = ConnectionManage.getInstance();
			connweb = connManage.getWEBConnection();
			String sql = "SELECT B.CITYID,B.CITYNAME,B.OPERATOR,B.OPERATOR2,A.OPERATOR OPERATOR3 FROM (SELECT * from FPF_AUDIT_FLOW WHERE CITYID='0') A LEFT JOIN (SELECT CITYID,CITYNAME,OPERATOR,OPERATOR2 from FPF_AUDIT_FLOW WHERE OPERATOR='" + userid + "' OR OPERATOR2='" + userid
					+ "') B ON 1=1 WHERE EXISTS(SELECT 1 from FPF_AUDIT_FLOW WHERE OPERATOR='" + userid + "' OR OPERATOR2='" + userid + "')";
			pstmt = connweb.prepareStatement(sql);
			rst = pstmt.executeQuery();
			if (rst.next()) {
				if (rst.getString("OPERATOR").equalsIgnoreCase(userid)) {
					Msg = "区域化二级审核提示:" + Msg;
					_flag = sendSMS(rst.getString("OPERATOR2"), Msg);
				} else if (rst.getString("OPERATOR2").equalsIgnoreCase(userid)) {
					Msg = "区域化三级审核提示:" + Msg;
					_flag = sendSMS(rst.getString("OPERATOR3"), Msg);
				}
			}

		} catch (Exception e) {
			
			e.printStackTrace();
		} finally {
			try {
				if (rst != null)
					rst.close();
				if (pstmt != null)
					pstmt.close();
				if (connweb != null)
					ConnectionManage.getInstance().releaseConnection(connweb);
			} catch (SQLException e) {
		
				e.printStackTrace();
			}
		}

		return _flag;
	}
}
