package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.irs.action.Action;

@SuppressWarnings("unused")
public class RoamMonitorAction extends Action {

	private static Logger LOG = Logger.getLogger(RoamMonitorAction.class);

	/**
	 * 新增节日
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void saveFestival(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			sql = "insert into nmk.dim_feast_day (feast_name, start_date, end_date, feast_year) values (?,?,?,?)";
			ps = conn.prepareStatement(sql);
			ps.setString(1, request.getParameter("f1001"));
			ps.setString(2, request.getParameter("f1002"));
			ps.setString(3, request.getParameter("f1003"));
			ps.setString(4, request.getParameter("f1004"));
			LOG.debug(sql);
			ps.execute();
			if (rs != null)
				rs.close();
			ps.close();
			conn.commit();
		} catch (Exception e) {
			try {
				if (conn != null) {
					conn.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.sendRedirect("/hb-bass-navigation/hbbass/roammonitor/festival.jsp");
	}

	/**
	 * 取得节日
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getFestival(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String fId = request.getParameter("fId");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		String[] festival = new String[5];
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			sql = "select feast_id, feast_name, start_date, end_date, feast_year from nmk.dim_feast_day where feast_id = " + fId + "";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if (rs.next()) {
				festival[0] = rs.getString(1) == null ? "" : rs.getString(1);
				festival[1] = rs.getString(2) == null ? "" : rs.getString(2);
				festival[2] = rs.getString(3) == null ? "" : rs.getString(3);
				festival[3] = rs.getString(4) == null ? "" : rs.getString(4);
				festival[4] = rs.getString(5) == null ? "" : rs.getString(5);
			}
			LOG.debug(sql);
			ps.execute();
			if (rs != null)
				rs.close();
			ps.close();
			conn.commit();
		} catch (Exception e) {
			try {
				if (conn != null) {
					conn.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		request.setAttribute("festival", festival);
		request.getRequestDispatcher("/hbbass/roammonitor/festival_update.jsp").forward(request, response);
	}

	/**
	 * 修改节日
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void updateFestival(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String fId = request.getParameter("fId");
		Connection conn = null;
		PreparedStatement ps = null;
		String sql = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			String fName = request.getParameter("f1001");
			String fStartDate = request.getParameter("f1002");
			String fEndDate = request.getParameter("f1003");
			String fYear = request.getParameter("f1004");
			sql = "update nmk.dim_feast_day set feast_name = '" + fName + "' ,start_date='" + fStartDate + "',end_date='" + fEndDate + "',feast_year=" + fYear + " where feast_id = " + fId + "";
			ps = conn.prepareStatement(sql);
			ps.execute();
			LOG.debug(sql);
			ps.execute();
			ps.close();
			conn.commit();
		} catch (Exception e) {
			try {
				if (conn != null) {
					conn.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.sendRedirect("/hb-bass-navigation/hbbass/roammonitor/festival.jsp");
	}

	/**
	 * 新增交通枢纽
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void saveJunction(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			sql = "insert into nmk.junction_info (junction_name, junction_type) values (?,?)";
			ps = conn.prepareStatement(sql);
			ps.setString(1, request.getParameter("f1001"));
			ps.setString(2, request.getParameter("f1002"));
			LOG.debug(sql);
			ps.execute();
			if (rs != null)
				rs.close();
			ps.close();
			conn.commit();
		} catch (Exception e) {
			try {
				if (conn != null) {
					conn.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.sendRedirect("/hb-bass-navigation/hbbass/roammonitor/junction.jsp");
	}

	/**
	 * 给交通枢纽新增基站
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	/**
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void saveJunctionBureau(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String junctionId = request.getParameter("junctionId");
		String bureauParas = request.getParameter("bureauParas");
		if (junctionId == null || "".equals(junctionId.trim())) {
			return;
		}
		if (bureauParas == null || "".equals(bureauParas.trim())) {
			return;
		}
		String[] rows = (String[]) bureauParas.split(",");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			sql = "select * from nmk.junction_info where junction_id =" + junctionId;
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			String junctionName = "";
			String junctionType = "";
			if (rs.next()) {
				junctionName = rs.getString("JUNCTION_NAME");
				junctionType = rs.getString("JUNCTION_TYPE");
			}
			sql = "insert into nmk.junction_bureau (junction_id,junction_name, junction_type, bureau_id, bureau_name) values (?,?,?,?,?)";
			ps = conn.prepareStatement(sql);
			for (int i = 0; i < rows.length; i++) {
				String[] rec = rows[i].split("_");
				String bureauId = rec[0];
				String bureauName = rec[1];
				ps.setString(1, junctionId);
				ps.setString(2, junctionName);
				ps.setString(3, junctionType);
				ps.setString(4, bureauId);
				ps.setString(5, bureauName);
				ps.addBatch();
			}
			ps.executeBatch();
			if (rs != null)
				rs.close();
			ps.close();
			conn.commit();
		} catch (Exception e) {
			try {
				if (conn != null) {
					conn.rollback();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		request.setAttribute("junctionId", junctionId);
		response.sendRedirect("/hb-bass-navigation/hbbass/roammonitor/junction_bureau.jsp?junctionId=" + junctionId);
	}

}
