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
 * 乡镇基本信息管理
 * 
 * @author lizhijian
 * @date 2010-07-09
 */
@SuppressWarnings("unused")
public class TownInfoAction extends Action {

	private static Logger log = Logger.getLogger(TownInfoAction.class);

	/**
	 * 新增乡镇基本信息
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void saveTownInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		String townName = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);

			String town_code = request.getParameter("f1004");

			// 看此town_code有几条已经存在的记录
			sql = "select count(1) from nmk.bureau_town_info where town_code = '" + town_code + "'";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			int count = 0;
			while (rs.next()) {
				count = rs.getInt(1);
			}
			if (rs != null)
				rs.close();
			ps.close();

			// 查找town_code对应原town_name
			sql = "select name from nwh.bureau_tree where id = '" + town_code + "'";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while (rs.next()) {
				townName = rs.getString(1);
			}
			if (rs != null)
				rs.close();
			ps.close();

			if (count > 0) {
				response.sendRedirect("/hb-bass-navigation/hbbass/town/town_info.jsp");
				PrintWriter out = response.getWriter();
				out.print("<script type='text/javascript'>window.opener.location.reload();window.close();</script>");
				return;
			}
			sql = "insert into nmk.bureau_town_info(area_code,county_code,zone_code,town_code,town_name,is_canton,total_usernum,agriculture_usernum,job_usernum,outward_usernum,man_usernum,total_familynum,gdp_num,user_failth,import_domain,income_average,competitive_chlnum,mobile_chlnum,tel_rate,telmarket_rate) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

			ps = conn.prepareStatement(sql);
			ps.setString(1, request.getParameter("f1001"));
			ps.setString(2, request.getParameter("f1002"));
			ps.setString(3, request.getParameter("f1003"));
			ps.setString(4, request.getParameter("f1004"));
			ps.setString(5, townName);
			ps.setString(6, request.getParameter("f1006"));
			ps.setBigDecimal(7, (request.getParameter("f1007") == null || "".equals(request.getParameter("f1007").trim())) ? null : new BigDecimal(request.getParameter("f1007")));
			ps.setBigDecimal(8, (request.getParameter("f1008") == null || "".equals(request.getParameter("f1008").trim())) ? null : new BigDecimal(request.getParameter("f1008")));
			ps.setBigDecimal(9, (request.getParameter("f1009") == null || "".equals(request.getParameter("f1009").trim())) ? null : new BigDecimal(request.getParameter("f1009")));
			ps.setBigDecimal(10, (request.getParameter("f1010") == null || "".equals(request.getParameter("f1010").trim())) ? null : new BigDecimal(request.getParameter("f1010")));
			ps.setBigDecimal(11, (request.getParameter("f1011") == null || "".equals(request.getParameter("f1011").trim())) ? null : new BigDecimal(request.getParameter("f1011")));
			ps.setBigDecimal(12, (request.getParameter("f1012") == null || "".equals(request.getParameter("f1012").trim())) ? null : new BigDecimal(request.getParameter("f1012")));
			ps.setBigDecimal(13, (request.getParameter("f1013") == null || "".equals(request.getParameter("f1013").trim())) ? null : new BigDecimal(request.getParameter("f1013")));
			ps.setString(14, request.getParameter("f1014"));
			ps.setString(15, request.getParameter("f1015"));
			ps.setBigDecimal(16, (request.getParameter("f1016") == null || "".equals(request.getParameter("f1016").trim())) ? null : new BigDecimal(request.getParameter("f1016")));
			ps.setBigDecimal(17, (request.getParameter("f1017") == null || "".equals(request.getParameter("f1017").trim())) ? null : new BigDecimal(request.getParameter("f1017")));
			ps.setBigDecimal(18, (request.getParameter("f1018") == null || "".equals(request.getParameter("f1018").trim())) ? null : new BigDecimal(request.getParameter("f1018")));
			ps.setBigDecimal(19, (request.getParameter("f1019") == null || "".equals(request.getParameter("f1019").trim())) ? null : new BigDecimal(request.getParameter("f1019")));
			ps.setBigDecimal(20, (request.getParameter("f1020") == null || "".equals(request.getParameter("f1020").trim())) ? null : new BigDecimal(request.getParameter("f1020")));

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
		response.sendRedirect("/hb-bass-navigation/hbbass/town/town_info.jsp");
	}

	/**
	 * 取得乡镇基本信息
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void getTownInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String town_code = request.getParameter("town_code");
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		String[] townInfo = new String[20];
		try {
			sql = "select * from nmk.bureau_town_info where town_code = '" + town_code + "'";

			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement(sql);
			log.debug(sql);
			rs = ps.executeQuery();
			while (rs.next()) {
				townInfo[0] = rs.getString(1) == null ? "" : rs.getString(1);
				townInfo[1] = rs.getString(2) == null ? "" : rs.getString(2);
				townInfo[2] = rs.getString(3) == null ? "" : rs.getString(3);
				townInfo[3] = rs.getString(4) == null ? "" : rs.getString(4);
				townInfo[4] = rs.getString(5) == null ? "" : rs.getString(5);
				townInfo[5] = rs.getString(6) == null ? "" : rs.getString(6);
				townInfo[6] = rs.getString(7) == null ? "" : rs.getString(7);
				townInfo[7] = rs.getString(8) == null ? "" : rs.getString(8);
				townInfo[8] = rs.getString(9) == null ? "" : rs.getString(9);
				townInfo[9] = rs.getString(10) == null ? "" : rs.getString(10);
				townInfo[10] = rs.getString(11) == null ? "" : rs.getString(11);
				townInfo[11] = rs.getString(12) == null ? "" : rs.getString(12);
				townInfo[12] = rs.getString(13) == null ? "" : rs.getString(13);
				townInfo[13] = rs.getString(14) == null ? "" : rs.getString(14);
				townInfo[14] = rs.getString(15) == null ? "" : rs.getString(15);
				townInfo[15] = rs.getString(16) == null ? "" : rs.getString(16);
				townInfo[16] = rs.getString(17) == null ? "" : rs.getString(17);
				townInfo[17] = rs.getString(18) == null ? "" : rs.getString(18);
				townInfo[18] = rs.getString(19) == null ? "" : rs.getString(19);
				townInfo[19] = rs.getString(20) == null ? "" : rs.getString(20);
			}
			request.getSession().setAttribute("townInfo", townInfo);
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
		response.sendRedirect("/hb-bass-navigation/hbbass/town/town_info_update.jsp");
	}

	/**
	 * 修改乡镇基本信息
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void updateTownInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		String sql = "";
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);

			String town_code = request.getParameter("f1004");
			sql = "delete from nmk.bureau_town_info where town_code = '" + town_code + "'";
			ps = conn.prepareStatement(sql);
			ps.execute();
			sql = "insert into nmk.bureau_town_info(area_code,county_code,zone_code,town_code,town_name,is_canton,total_usernum,agriculture_usernum,job_usernum,outward_usernum,man_usernum,total_familynum,gdp_num,user_failth,import_domain,income_average,competitive_chlnum,mobile_chlnum,tel_rate,telmarket_rate) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

			ps = conn.prepareStatement(sql);
			ps.setString(1, request.getParameter("f1001"));
			ps.setString(2, request.getParameter("f1002"));
			ps.setString(3, request.getParameter("f1003"));
			ps.setString(4, request.getParameter("f1004"));
			ps.setString(5, request.getParameter("f1005"));
			ps.setString(6, request.getParameter("f1006"));
			ps.setBigDecimal(7, (request.getParameter("f1007") == null || "".equals(request.getParameter("f1007").trim())) ? null : new BigDecimal(request.getParameter("f1007")));
			ps.setBigDecimal(8, (request.getParameter("f1008") == null || "".equals(request.getParameter("f1008").trim())) ? null : new BigDecimal(request.getParameter("f1008")));
			ps.setBigDecimal(9, (request.getParameter("f1009") == null || "".equals(request.getParameter("f1009").trim())) ? null : new BigDecimal(request.getParameter("f1009")));
			ps.setBigDecimal(10, (request.getParameter("f1010") == null || "".equals(request.getParameter("f1010").trim())) ? null : new BigDecimal(request.getParameter("f1010")));
			ps.setBigDecimal(11, (request.getParameter("f1011") == null || "".equals(request.getParameter("f1011").trim())) ? null : new BigDecimal(request.getParameter("f1011")));
			ps.setBigDecimal(12, (request.getParameter("f1012") == null || "".equals(request.getParameter("f1012").trim())) ? null : new BigDecimal(request.getParameter("f1012")));
			ps.setBigDecimal(13, (request.getParameter("f1013") == null || "".equals(request.getParameter("f1013").trim())) ? null : new BigDecimal(request.getParameter("f1013")));
			ps.setString(14, request.getParameter("f1014"));
			ps.setString(15, request.getParameter("f1015"));
			ps.setBigDecimal(16, (request.getParameter("f1016") == null || "".equals(request.getParameter("f1016").trim())) ? null : new BigDecimal(request.getParameter("f1016")));
			ps.setBigDecimal(17, (request.getParameter("f1017") == null || "".equals(request.getParameter("f1017").trim())) ? null : new BigDecimal(request.getParameter("f1017")));
			ps.setBigDecimal(18, (request.getParameter("f1018") == null || "".equals(request.getParameter("f1018").trim())) ? null : new BigDecimal(request.getParameter("f1018")));
			ps.setBigDecimal(19, (request.getParameter("f1019") == null || "".equals(request.getParameter("f1019").trim())) ? null : new BigDecimal(request.getParameter("f1019")));
			ps.setBigDecimal(20, (request.getParameter("f1020") == null || "".equals(request.getParameter("f1020").trim())) ? null : new BigDecimal(request.getParameter("f1020")));

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
		response.sendRedirect("/hb-bass-navigation/hbbass/town/town_info.jsp");
	}

	/**
	 * 删除乡镇基本信息
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void deleteTownInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String town_code = request.getParameter("town_code");
		Connection conn = null;
		PreparedStatement ps = null;
		String sql = "";
		try {
			sql = "delete from nmk.bureau_town_info where town_code = '" + town_code + "'";

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
		response.sendRedirect("/hb-bass-navigation/hbbass/town/town_info.jsp");
	}

	/**
	 * 导入乡镇基本信息
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void importTownInfo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String fee_id = request.getParameter("f0");
		String fee_rate_type = request.getParameter("f1001");
		Connection conn1 = null;
		Connection conn2 = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int count = 0;
		String sql = "";
	//	List list = new ArrayList();
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
		// out.print("<script
		// type='text/javascript'>window.opener.location.reload();window.close();</script>");
	}

}
