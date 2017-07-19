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

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
@SuppressWarnings("unused")
public class WarningUserinfoConfgAction extends Action {


	private static Logger LOG = Logger
			.getLogger(WarningUserinfoConfgAction.class);

	private JsonHelper jsonHelper = JsonHelper.getInstance();

	public void cfgUserChange(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String cityId = request.getParameter("cityId");
		String operator = request.getParameter("operator");

		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			conn = ConnectionManage.getInstance().getDWConnection();
			conn.setAutoCommit(false);
			int _newnum = 0;
			// 根据ID获得原状态
			String sql = "update warning_user_cfg set operator= '" + operator
					+ "'  where cityId='" + cityId+ "'";
			System.out.print(sql);
			ps = conn.prepareStatement(sql);
			ps.execute();
			ps.close();
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
		response.sendRedirect("/hb-bass-navigation/hbapp/app/warning/loadUserConfg.jsp");
	}
}
