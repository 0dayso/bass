package com.asiainfo.hbbass.kpiportal.customize;

import java.io.IOException;
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
import com.asiainfo.hbbass.irs.action.ActionMethod;

/**
 * 
 * @author Mei Kefu
 * @date 2010-5-25
 */
public class KPICustomizeAction extends Action {

	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(KPICustomizeAction.class);

	public void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
		String desc = request.getParameter("desc");
		String appName = request.getParameter("appName");
		String contacts = request.getParameter("contacts");
		String userId = (String) request.getSession().getAttribute("loginname");
		String msg = "操作失败";
		Connection conn = ConnectionManage.getInstance().getWEBConnection();

		try {
			int subjectId = -1;
			PreparedStatement ps = conn.prepareStatement("values nextval for kpi_audit_gid");
			ResultSet rs = ps.executeQuery();
			if (rs.next())
				subjectId = rs.getInt(1);
			rs.close();
			ps.close();
			ps = conn.prepareStatement("insert into kpi_audit_job(id,name,desc,user_id,app_name,contacts,fire_date) values(?,?,?,?,?,?,current_date)");
			ps.setInt(1, subjectId);
			ps.setString(2, name);
			ps.setString(3, desc);
			ps.setString(4, userId);
			ps.setString(5, appName);
			ps.setString(6, contacts);

			ps.execute();
			ps.close();
			msg = "操作成功";
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.getWriter().print(msg);

	}

	public void deleteAudit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		String sid = request.getParameter("pid");
		int nId = Integer.parseInt(sid);
		String zbCode = request.getParameter("zbCode");
		String appName = request.getParameter("appName");
		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			delAudit(conn, nId, zbCode, appName);
			conn.commit();
			msg = "操作成功";
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		response.getWriter().print(msg);
	}

	@ActionMethod(isLog = false)
	protected void delAudit(Connection conn, int nId, String zbCode, String appName) throws SQLException {
		PreparedStatement ps1 = conn.prepareStatement("delete from kpi_audit where pid=? and zb_code=? and app_name=?");
		ps1.setInt(1, nId);
		ps1.setString(2, zbCode);
		ps1.setString(3, appName);
		ps1.execute();
	}

	public void saveAudit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		String pid = request.getParameter("pid");
		int nId = Integer.parseInt(pid);
		String zbCode = request.getParameter("zbCode");
		String appName = request.getParameter("appName");
		Connection conn = ConnectionManage.getInstance().getWEBConnection();

		try {
			delAudit(conn, nId, zbCode, appName); // 为什么要先删除?

			String areaCode = request.getParameter("areaCode");
			String exp = request.getParameter("exp");

			PreparedStatement ps = conn.prepareStatement("insert into kpi_audit(pid,zb_code,app_name,area_code,exp,sort) values(?,?,?,?,?,?)");
			ps.setInt(1, nId);
			ps.setString(2, zbCode);
			ps.setString(3, appName);
			ps.setString(4, areaCode);
			ps.setString(5, exp);
			ps.setString(6, request.getParameter("sort"));
			ps.execute();
			conn.commit();
			msg = "操作成功";
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
		response.getWriter().print(msg);
	}

	/**
	 * 打印文本
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void text(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pid = request.getParameter("pid");
		int nId = Integer.parseInt(pid);
		KPIAuditJob job = new KPIAuditJob(nId);
		response.getWriter().print(job.format());
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void push(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String pid = request.getParameter("pid");
		int nId = Integer.parseInt(pid);
		KPIAuditJob job = new KPIAuditJob(nId);
		job.push();
		response.getWriter().print("操作成功");
	}

	public void updateAuditJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("update KPI_AUDIT_JOB set name=?,desc=?,contacts=? where id=?");
			ps.setString(1, request.getParameter("name"));
			ps.setString(2, request.getParameter("desc"));
			ps.setString(3, request.getParameter("contacts"));
			ps.setString(4, request.getParameter("id"));
			ps.execute();
			conn.commit();
			msg = "操作成功";
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
		response.getWriter().print(msg);
	}

	public void deleteAuditJob(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String msg = "操作失败";
		int id = Integer.parseInt(request.getParameter("id"));
		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			PreparedStatement ps = conn.prepareStatement("delete from KPI_AUDIT_JOB where id=?");
			ps.setInt(1, id);
			ps.execute();
			ps.close();
			PreparedStatement ps1 = conn.prepareStatement("delete from KPI_AUDIT where pid=?");
			ps1.setInt(1, id);
			ps1.execute();
			ps1.close();
			conn.commit();
			msg = "操作成功";
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
		response.getWriter().print(msg);
	}
}
