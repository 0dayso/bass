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
import com.asiainfo.hbbass.irs.action.Action;

/**
 * 
 * 业务受理渠道适配
 * 
 * @author lizhijian
 * @date 2010-10-21
 */
@SuppressWarnings("unused")
public class RecChannelAction extends Action {
	private static Logger log = Logger.getLogger(RecChannelAction.class);

	/**
	 * 新增业务受理渠道适配
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void saveRecChannelMatch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		String townName = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			sql = "insert into nmk.dim_business_rec_channel_matching(business_code,business_name,bsachal_match_level,ivr_match_level,bsackf_match_level,bsacnb_match_level,outcall_match_level,bsacsms_match_level,wap_match_level,bsacatsv_match_level,bsacair_match_level) values(?,?,?,?,?,?,?,?,?,?,?)";
			ps = conn.prepareStatement(sql);
			ps.setString(1, request.getParameter("f01"));
			ps.setString(2, request.getParameter("f02"));
			ps.setString(3, request.getParameter("f03"));
			ps.setString(4, request.getParameter("f04"));
			ps.setString(5, request.getParameter("f05"));
			ps.setString(6, request.getParameter("f06"));
			ps.setString(7, request.getParameter("f07"));
			ps.setString(8, request.getParameter("f08"));
			ps.setString(9, request.getParameter("f09"));
			ps.setString(10, request.getParameter("f10"));
			ps.setString(11, request.getParameter("f11"));
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
		response.sendRedirect("/hb-bass-navigation/hbbass/recChannel/rec_channel_matching.jsp");
	}

	/**
	 * 取得业务受理渠道适配
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getRecChannelMatch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String business_code = request.getParameter("business_code");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		String[] recChannelMatch = new String[11];
		try {
			sql = "select business_code,business_name,bsachal_match_level,ivr_match_level,bsackf_match_level,bsacnb_match_level,outcall_match_level,bsacsms_match_level,wap_match_level,bsacatsv_match_level,bsacair_match_level from nmk.dim_business_rec_channel_matching where business_code = '" + business_code + "'";
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement(sql);
			log.debug(sql);
			rs = ps.executeQuery();
			while (rs.next()) {
				recChannelMatch[0] = rs.getString(1) == null ? "" : rs.getString(1);
				recChannelMatch[1] = rs.getString(2) == null ? "" : rs.getString(2);
				recChannelMatch[2] = rs.getString(3) == null ? "" : rs.getString(3);
				recChannelMatch[3] = rs.getString(4) == null ? "" : rs.getString(4);
				recChannelMatch[4] = rs.getString(5) == null ? "" : rs.getString(5);
				recChannelMatch[5] = rs.getString(6) == null ? "" : rs.getString(6);
				recChannelMatch[6] = rs.getString(7) == null ? "" : rs.getString(7);
				recChannelMatch[7] = rs.getString(8) == null ? "" : rs.getString(8);
				recChannelMatch[8] = rs.getString(9) == null ? "" : rs.getString(9);
				recChannelMatch[9] = rs.getString(10) == null ? "" : rs.getString(10);
				recChannelMatch[10] = rs.getString(11) == null ? "" : rs.getString(11);
			}
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
		request.setAttribute("recChannelMatch", recChannelMatch);
		request.getRequestDispatcher("/hbbass/recChannel/rec_channel_matching_update.jsp").forward(request, response);
	}

	/**
	 * 修改业务受理渠道适配
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void updateRecChannelMatch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			String business_code = request.getParameter("f01");
			if (business_code == null || "".equals(business_code.trim())) {
				throw new Exception("business_code不能为空");
			}
			sql = "update nmk.dim_business_rec_channel_matching set business_name=?,bsachal_match_level=?,ivr_match_level=?,bsackf_match_level=?,bsacnb_match_level=?,outcall_match_level=?,bsacsms_match_level=?,wap_match_level=?,bsacatsv_match_level=?,bsacair_match_level=? where business_code=?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, request.getParameter("f02"));
			ps.setString(2, request.getParameter("f03"));
			ps.setString(3, request.getParameter("f04"));
			ps.setString(4, request.getParameter("f05"));
			ps.setString(5, request.getParameter("f06"));
			ps.setString(6, request.getParameter("f07"));
			ps.setString(7, request.getParameter("f08"));
			ps.setString(8, request.getParameter("f09"));
			ps.setString(9, request.getParameter("f10"));
			ps.setString(10, request.getParameter("f11"));
			ps.setString(11, request.getParameter("f01"));
			ps.executeUpdate();
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
		request.getRequestDispatcher("/hbbass/recChannel/rec_channel_matching.jsp").forward(request, response);
	}

	/**
	 * 删除业务受理渠道适配
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void deleteRecChannelMatch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String business_code = request.getParameter("business_code");
		Connection conn = null;
		PreparedStatement ps = null;
		String sql = "";
		try {
			sql = "delete from nmk.dim_business_rec_channel_matching where business_code = '" + business_code + "'";
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
		request.getRequestDispatcher("/hbbass/recChannel/rec_channel_matching.jsp").forward(request, response);
	}
}
