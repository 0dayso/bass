package com.asiainfo.hbbass.common.filter;

import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;

public class OnlineUserClearListener implements HttpSessionListener {

	private static Logger LOG = Logger.getLogger(OnlineUserClearListener.class);

	public void sessionCreated(HttpSessionEvent se) {
	}

	public void sessionDestroyed(HttpSessionEvent se) {

		String userId = (String) se.getSession().getAttribute("loginname");

		if (userId != null && userId.length() > 0) {
			LOG.info("clear online user :" + userId);
			Connection conn = ConnectionManage.getInstance().getWEBConnection();

			try {
				conn.createStatement().execute("delete from fpf_online_user where user_id='" + userId + "'");
				conn.commit();
			} catch (SQLException e) {
				e.printStackTrace();
			} finally {
				ConnectionManage.getInstance().releaseConnection(conn);
			}
		}

	}
}
