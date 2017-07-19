package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;

/**
 * 
 * 资费信息管理
 * 
 * @author lizhijian
 * @date 2010-05-28
 */
public class FeeInfoAction extends Action {

	private static Logger log = Logger.getLogger(FeeInfoAction.class);

	@SuppressWarnings("unused")
	private JsonHelper jsonHelper = JsonHelper.getInstance();

	/**
	 * 新增资费
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings({ "rawtypes", "unused" })
	public void saveFeeInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		Map map = request.getParameterMap();
		for (Iterator it = map.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			String[] value = (String[]) map.get(key);
			// log.debug("key:" + key + " value:" + value[0]);
		}
		Connection conn1 = null;
		Connection conn2 = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int count = 0;
		String sql = "";
		List list = new ArrayList();
		try {
			sql = "insert into nwh.fee_rate_discount_info(fee_id,fee_rate_type,fee_rate_type_name,fee_rates,fee_discount_dura,fee_discount_charge,rent_charge,minimum_charge,dura_flag,charge_flag) values(?,?,?,?,?,?,?,?,?,?)";

			conn2 = ConnectionManage.getInstance().getDWConnection();
			conn2.setAutoCommit(false);
			ps = conn2.prepareStatement(sql);
			ps.setString(1, request.getParameter("f0"));
			ps.setString(2, request.getParameter("f1001"));
			ps.setString(3, request.getParameter("f1002"));
			ps.setBigDecimal(4, (request.getParameter("f1003") == null || "".equals(request.getParameter("f1003").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1003"))));
			ps.setBigDecimal(5, (request.getParameter("f1004") == null || "".equals(request.getParameter("f1004").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1004"))));
			ps.setBigDecimal(6, (request.getParameter("f1005") == null || "".equals(request.getParameter("f1005").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1005"))));
			ps.setBigDecimal(7, (request.getParameter("f1006") == null || "".equals(request.getParameter("f1006").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1006"))));
			ps.setBigDecimal(8, (request.getParameter("f1007") == null || "".equals(request.getParameter("f1007").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1007"))));
			ps.setBigDecimal(9, (request.getParameter("f1008") == null || "".equals(request.getParameter("f1008").trim())) ? BigDecimal.valueOf(0) : BigDecimal.valueOf(1));
			ps.setBigDecimal(10, (request.getParameter("f1009") == null || "".equals(request.getParameter("f1009").trim())) ? BigDecimal.valueOf(0) : BigDecimal.valueOf(1));

			log.debug(sql);
			ps.execute();
			if (rs != null)
				rs.close();
			ps.close();
			conn2.commit();
		} catch (Exception e) {
			try {
				if (conn1 != null) {
					conn1.rollback();
				}
				if (conn1 != null) {
					conn2.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn1);
			ConnectionManage.getInstance().releaseConnection(conn2);
		}
		response.sendRedirect("/hb-bass-navigation/hbbass/fee/fee_info_manage.jsp");
	}

	/**
	 * 修改资费
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void updateFeeInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		Map map = request.getParameterMap();
		for (Iterator it = map.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			String[] value = (String[]) map.get(key);
			log.debug("key:" + key + "	value:" + value[0]);
		}
		Connection conn1 = null;
		Connection conn2 = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int count = 0;
		String sql = "";
		List list = new ArrayList();
		try {
			conn1 = ConnectionManage.getInstance().getWEBConnection();
			conn1.setAutoCommit(false);
			ps = conn1.prepareStatement("select field_type from fee_info_config order by field_id asc with ur");
			rs = ps.executeQuery();
			while (rs.next()) {
				list.add(rs.getString(1));
				count++;
			}
			for (int i = 0; i < count; i++) {
				if ("".equals(sql)) {
					sql += "?";
				} else {
					sql += ",?";
				}
			}
			sql = "insert into nmk.fee_info values(" + sql + ")";

			conn2 = ConnectionManage.getInstance().getDWConnection();
			conn2.setAutoCommit(false);
			ps = conn2.prepareStatement(sql);
			for (int i = 0; i < count; i++) {
				String type = (String) list.get(i);
				String[] value = (String[]) map.get("f" + i);
				if ("".equals(value[0])) {
					value[0] = null;
				}
				if ("VARCHAR".equalsIgnoreCase(type)) {
					ps.setString(i + 1, value[0]);
				} else if ("DECIMAL".equalsIgnoreCase(type)) {
					ps.setBigDecimal(i + 1, value[0] == null ? null : BigDecimal.valueOf(new Double(value[0])));
				} else if ("DATE".equalsIgnoreCase(type)) {
					ps.setDate(i + 1, new java.sql.Date(System.currentTimeMillis()));
				} else if ("INTEGER".equalsIgnoreCase(type)) {
					ps.setBigDecimal(i + 1, value[0] == null ? null : BigDecimal.valueOf(new Integer(value[0])));
				}
			}
			log.debug(sql);
			ps.execute();
			rs.close();
			ps.close();
			conn2.commit();
		} catch (Exception e) {
			try {
				conn1.rollback();
				conn2.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn1);
			ConnectionManage.getInstance().releaseConnection(conn2);
		}
	}

	/**
	 * 删除资费
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings({ "rawtypes", "null" })
	public void deleteFeeInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		Map map = request.getParameterMap();
		for (Iterator it = map.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			String[] value = (String[]) map.get(key);
			log.debug("key:" + key + "	value:" + value[0]);
		}
		Connection conn1 = null;
		Connection conn2 = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int count = 0;
		String sql = "";
		List list = new ArrayList();
		try {
			sql = "delete nmk.fee_info where fee_id in (" + sql + ")";

			conn2 = ConnectionManage.getInstance().getDWConnection();
			conn2.setAutoCommit(false);
			ps = conn2.prepareStatement(sql);
			for (int i = 0; i < count; i++) {
				String type = (String) list.get(i);
				String[] value = (String[]) map.get("f" + i);
				if ("".equals(value[0])) {
					value[0] = null;
				}
				if ("VARCHAR".equalsIgnoreCase(type)) {
					ps.setString(i + 1, value[0]);
				} else if ("DECIMAL".equalsIgnoreCase(type)) {
					ps.setBigDecimal(i + 1, value[0] == null ? null : BigDecimal.valueOf(new Double(value[0])));
				} else if ("DATE".equalsIgnoreCase(type)) {
					ps.setDate(i + 1, new java.sql.Date(System.currentTimeMillis()));
				} else if ("INTEGER".equalsIgnoreCase(type)) {
					ps.setBigDecimal(i + 1, value[0] == null ? null : BigDecimal.valueOf(new Integer(value[0])));
				}
			}
			log.debug(sql);
			ps.execute();
			rs.close();
			ps.close();
			conn2.commit();
		} catch (Exception e) {
			try {
				conn1.rollback();
				conn2.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn1);
			ConnectionManage.getInstance().releaseConnection(conn2);
		}
	}

	/**
	 * 新增资费费率
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings({ "unused", "rawtypes" })
	public void saveFeeInfoType(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String fee_id = request.getParameter("f0");
		String fee_rate_type = request.getParameter("f1001");
		Connection conn1 = null;
		Connection conn2 = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int count = 0;
		String sql = "";
		List list = new ArrayList();
		try {
			conn2 = ConnectionManage.getInstance().getDWConnection();
			conn2.setAutoCommit(false);

			if (fee_id != null && !"".equals(fee_id.trim()) && fee_rate_type != null && !"".equals(fee_rate_type.trim())) {
				sql = "delete from nwh.fee_rate_discount_info where fee_id = '" + fee_id + "' and fee_rate_type='" + fee_rate_type + "'";
				ps = conn2.prepareStatement(sql);
				ps.execute();
				log.debug(sql);
				// conn2.commit();
				sql = "insert into nwh.fee_rate_discount_info(fee_id,fee_rate_type,fee_rate_type_name,fee_rates,fee_discount_dura,fee_discount_charge,rent_charge,minimum_charge,dura_flag,charge_flag,maxmum_charge) values(?,?,?,?,?,?,?,?,?,?,?)";
				ps = conn2.prepareStatement(sql);
				ps.setString(1, request.getParameter("f0"));
				ps.setString(2, request.getParameter("f1001"));
				ps.setString(3, request.getParameter("f1002"));
				ps.setBigDecimal(4, (request.getParameter("f1003") == null || "".equals(request.getParameter("f1003").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1003"))));
				ps.setBigDecimal(5, (request.getParameter("f1004") == null || "".equals(request.getParameter("f1004").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1004"))));
				ps.setBigDecimal(6, (request.getParameter("f1005") == null || "".equals(request.getParameter("f1005").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1005"))));
				ps.setBigDecimal(7, (request.getParameter("f1006") == null || "".equals(request.getParameter("f1006").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1006"))));
				ps.setBigDecimal(8, (request.getParameter("f1007") == null || "".equals(request.getParameter("f1007").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1007"))));
				ps.setBigDecimal(9, (request.getParameter("f1008") == null || "".equals(request.getParameter("f1008").trim())) ? BigDecimal.valueOf(0) : BigDecimal.valueOf(1));
				ps.setBigDecimal(10, (request.getParameter("f1009") == null || "".equals(request.getParameter("f1009").trim())) ? BigDecimal.valueOf(0) : BigDecimal.valueOf(1));
				ps.setBigDecimal(11, (request.getParameter("f1010") == null || "".equals(request.getParameter("f1010").trim())) ? null : BigDecimal.valueOf(new Double(request.getParameter("f1010"))));
				log.debug(sql);
				ps.execute();
				if (rs != null)
					rs.close();
				ps.close();
				conn2.commit();
			}
		} catch (Exception e) {
			try {
				if (conn1 != null) {
					conn1.rollback();
				}
				if (conn2 != null) {
					conn2.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn1);
			ConnectionManage.getInstance().releaseConnection(conn2);
		}
		response.sendRedirect("/hb-bass-navigation/hbbass/fee/fee_info_update.jsp?fee_id=" + fee_id);
		PrintWriter out = response.getWriter();
		// out.print("<script type='text/javascript'>window.opener.location.reload();window.close();</script>");
	}

	/**
	 * 删除资费费率
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("unused")
	public void deleteFeeInfoType(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String fee_id = request.getParameter("fee_id");
		String fee_rate_type = request.getParameter("fee_rate_type");
		Connection conn2 = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		try {
			conn2 = ConnectionManage.getInstance().getDWConnection();
			conn2.setAutoCommit(false);

			if (fee_id != null && !"".equals(fee_id.trim()) && fee_rate_type != null && !"".equals(fee_rate_type.trim())) {
				sql = "delete from nwh.fee_rate_discount_info where fee_id = '" + fee_id + "' and fee_rate_type='" + fee_rate_type + "'";
				ps = conn2.prepareStatement(sql);
				ps.execute();
				log.debug(sql);
				ps.execute();
				if (rs != null)
					rs.close();
				ps.close();
				conn2.commit();
			}
		} catch (Exception e) {
			try {
				if (conn2 != null) {
					conn2.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn2);
		}
		response.sendRedirect("/hb-bass-navigation/hbbass/fee/fee_info_operate_result.jsp");
	}

	/**
	 * 新增资费信息表的字段，修改相应配置表
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void addFeeInfoConfig(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		Map map = request.getParameterMap();
		for (Iterator it = map.keySet().iterator(); it.hasNext();) {
			String key = (String) it.next();
			String[] value = (String[]) map.get(key);
			log.debug("key:" + key + "	value:" + value[0]);
		}
		Connection conn1 = null;
		Connection conn2 = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int count = 0;
		String sql = "";
		List list = new ArrayList();
		try {
			conn1 = ConnectionManage.getInstance().getWEBConnection();
			conn1.setAutoCommit(false);
			ps = conn1.prepareStatement("select field_type from fee_info_config order by field_id asc with ur");
			rs = ps.executeQuery();
			while (rs.next()) {
				list.add(rs.getString(1));
				count++;
			}
			for (int i = 0; i < count; i++) {
				if ("".equals(sql)) {
					sql += "?";
				} else {
					sql += ",?";
				}
			}
			sql = "insert into nmk.fee_info values(" + sql + ")";

			conn2 = ConnectionManage.getInstance().getDWConnection();
			conn2.setAutoCommit(false);
			ps = conn2.prepareStatement(sql);
			for (int i = 0; i < count; i++) {
				String type = (String) list.get(i);
				String[] value = (String[]) map.get("f" + i);
				if ("".equals(value[0])) {
					value[0] = null;
				}
				if ("VARCHAR".equalsIgnoreCase(type)) {
					ps.setString(i + 1, value[0]);
				} else if ("DECIMAL".equalsIgnoreCase(type)) {
					ps.setBigDecimal(i + 1, value[0] == null ? null : BigDecimal.valueOf(new Double(value[0])));
				} else if ("DATE".equalsIgnoreCase(type)) {
					ps.setDate(i + 1, new java.sql.Date(System.currentTimeMillis()));
				} else if ("INTEGER".equalsIgnoreCase(type)) {
					ps.setBigDecimal(i + 1, value[0] == null ? null : BigDecimal.valueOf(new Integer(value[0])));
				}
			}
			log.debug(sql);
			ps.execute();
			rs.close();
			ps.close();
			conn2.commit();
		} catch (Exception e) {
			try {
				conn1.rollback();
				conn2.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn1);
			ConnectionManage.getInstance().releaseConnection(conn2);
		}
	}
}
