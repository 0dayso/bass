package com.asiainfo.hbbass.kpiportal.report;

import java.io.IOException;
import java.net.URLDecoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.irs.action.Action;

@SuppressWarnings("unused")
public class StaticReportAction extends Action {

	private static Logger LOG = Logger.getLogger(StaticReportAction.class);

	public void init(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	public void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pid = request.getParameter("pid");

		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			conn = ConnectionManage.getInstance().getWEBConnection();
			conn.setAutoCommit(false);
			int packageId = -1;
			if (pid == null || pid.length() == 0) {// 新增
				ps = conn.prepareStatement("values nextval for irs_package_id");
				rs = ps.executeQuery();
				if (rs.next())
					packageId = rs.getInt(1);
				rs.close();
				ps.close();
				ps = conn.prepareStatement("insert into FPF_IRS_PACKAGE(id,name,type) values(?,?,'manaul')");
				ps.setInt(1, packageId);
				ps.setString(2, "开发中的静态报表");
				ps.execute();
				ps.close();
			} else {// 修改
				packageId = Integer.parseInt(pid);

				String packageName = request.getParameter("name");
				packageName = URLDecoder.decode(packageName, "utf-8");
				String packagetDesc = request.getParameter("desc");
				packagetDesc = URLDecoder.decode(packagetDesc, "utf-8");

				ps = conn.prepareStatement("update FPF_IRS_PACKAGE set name=?,desc=? where id=?");
				ps.setString(1, packageName);
				ps.setString(2, packagetDesc);
				ps.setInt(3, packageId);
				ps.execute();
				ps.close();
			}
			conn.commit();

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

	public void delete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pid = request.getParameter("pid");
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = ConnectionManage.getInstance().getWEBConnection();
			conn.setAutoCommit(false);
			int packageId = Integer.parseInt(pid);

			String sql = " select id from FPF_IRS_SUBJECT where pid=? with ur";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, packageId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				String sid = rs.getString(1);
				RepMeta rep = new RepMeta(sid);
				rep.delete();
			}
			rs.close();
			ps.close();
			sql = "delete from FPF_IRS_PACKAGE where id=?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, packageId);
			ps.execute();
			ps.close();

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

	public void render(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sid = request.getParameter("sid");
		RepMeta rep = new RepMeta(sid);
		rep.initialize();
		LOG.debug(rep);
		response.getWriter().print(rep.render());
	}

}
