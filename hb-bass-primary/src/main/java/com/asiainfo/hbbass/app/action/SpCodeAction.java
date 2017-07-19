package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.io.PrintWriter;
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

/**
 * 
 * SP基本信息管理
 * 
 * @author lizhijian
 * @date 2011-01-21
 */
public class SpCodeAction extends Action {
	private static Logger log = Logger.getLogger(SpCodeAction.class);

	/**
	 * 新增SP基本信息
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void saveSpCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		@SuppressWarnings("unused")
		String townName = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			String spCode = request.getParameter("f1001");
			// 看此spCode有几条已经存在的记录
			sql = "select count(1) from nwh.dim_sett_sp_code where sp_code = '" + spCode + "'";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			int count = 0;
			while (rs.next()) {
				count = rs.getInt(1);
			}
			if (rs != null)
				rs.close();
			ps.close();
			if (count > 0) {
				response.sendRedirect("/hb-bass-navigation/hbbass/spcode/sp_code.jsp");
				PrintWriter out = response.getWriter();
				out.print("<script type='text/javascript'>window.opener.location.reload();window.close();</script>");
				return;
			}
			sql = "insert into nwh.dim_sett_sp_code(sp_code,sp_name,serv_code,sp_busi_type,sp_type,connect_prov,sett_prov,owner_flag,sp_status,sp_edit_status,eff_date,exp_date,sp_sett_flag) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
			ps = conn.prepareStatement(sql);
			ps.setString(1, request.getParameter("f1001"));
			ps.setString(2, request.getParameter("f1002"));
			ps.setString(3, request.getParameter("f1003"));
			ps.setString(4, request.getParameter("f1004"));
			ps.setString(5, request.getParameter("f1005"));
			ps.setString(6, request.getParameter("f1006"));
			ps.setString(7, request.getParameter("f1007"));
			ps.setString(8, request.getParameter("f1008"));
			ps.setString(9, request.getParameter("f1009"));
			ps.setString(10, request.getParameter("f1010"));
			String f1011 = request.getParameter("f1011");
			if (f1011 == null || "null".equals(f1011) || "".equals(f1011.trim())) {
				ps.setDate(11, null);
			} else {
				ps.setDate(11, java.sql.Date.valueOf(f1011));
			}
			String f1012 = request.getParameter("f1012");
			if (f1012 == null || "null".equals(f1012) || "".equals(f1012.trim())) {
				ps.setDate(12, null);
			} else {
				ps.setDate(12, java.sql.Date.valueOf(f1012));
			}
			ps.setString(13, request.getParameter("f1013"));
			log.debug(sql);
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
		response.sendRedirect("/hb-bass-navigation/hbbass/spcode/sp_code.jsp");
	}

	/**
	 * 取得SP基本信息
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getSpCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String spCode = request.getParameter("spCode");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		String[] spCodeRec = new String[13];
		try {
			sql = "select sp_code,sp_name,serv_code,sp_busi_type,sp_type,connect_prov,sett_prov,owner_flag,sp_status,sp_edit_status,eff_date,exp_date,sp_sett_flag from nwh.dim_sett_sp_code where sp_code = '" + spCode + "'";
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement(sql);
			log.debug(sql);
			rs = ps.executeQuery();
			while (rs.next()) {
				spCodeRec[0] = rs.getString(1) == null ? "" : rs.getString(1).trim();
				spCodeRec[1] = rs.getString(2) == null ? "" : rs.getString(2).trim();
				spCodeRec[2] = rs.getString(3) == null ? "" : rs.getString(3).trim();
				spCodeRec[3] = rs.getString(4) == null ? "" : rs.getString(4).trim();
				spCodeRec[4] = rs.getString(5) == null ? "" : rs.getString(5).trim();
				spCodeRec[5] = rs.getString(6) == null ? "" : rs.getString(6).trim();
				spCodeRec[6] = rs.getString(7) == null ? "" : rs.getString(7).trim();
				spCodeRec[7] = rs.getString(8) == null ? "" : rs.getString(8).trim();
				spCodeRec[8] = rs.getString(9) == null ? "" : rs.getString(9).trim();
				spCodeRec[9] = rs.getString(10) == null ? "" : rs.getString(10).trim();
				spCodeRec[10] = rs.getString(11) == null ? "" : rs.getString(11).trim();
				spCodeRec[11] = rs.getString(12) == null ? "" : rs.getString(12).trim();
				spCodeRec[12] = rs.getString(13) == null ? "" : rs.getString(13).trim();
			}
			request.getSession().setAttribute("spCode", spCodeRec);
			rs.close();
			ps.close();
			conn.commit();
		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.sendRedirect("/hb-bass-navigation/hbbass/spcode/sp_code_update.jsp");
	}

	/**
	 * 修改SP基本信息
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("unused")
	public void updateSpCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			String spCode = request.getParameter("f1001");
			sql = "update nwh.dim_sett_sp_code set ";
			sql += " sp_busi_type='" + request.getParameter("f1004") + "'";
			sql += " ,sp_type='" + request.getParameter("f1005") + "'";
			sql += " ,owner_flag='" + request.getParameter("f1008") + "'";
			sql += " ,sp_sett_flag='" + request.getParameter("f1013") + "'";
			sql += " where sp_code = '" + spCode + "'";
			ps = conn.prepareStatement(sql);
			log.debug(sql);
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
		response.sendRedirect("/hb-bass-navigation/hbbass/spcode/sp_code.jsp");
	}

	/**
	 * 删除SP基本信息
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void deleteSpCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String spCode = request.getParameter("spCode");
		Connection conn = null;
		PreparedStatement ps = null;
		String sql = "";
		try {
			sql = "delete from nwh.dim_sett_sp_code where sp_code = '" + spCode + "'";
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement(sql);
			log.debug(sql);
			ps.execute();
			ps.close();
			conn.commit();
		} catch (Exception e) {
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.sendRedirect("/hb-bass-navigation/hbbass/spcode/sp_code.jsp");
	}
}
