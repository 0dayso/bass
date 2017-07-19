package com.asiainfo.hbbass.component.scheduler;

import java.sql.Connection;
import java.sql.SQLException;

import org.quartz.utils.ConnectionProvider;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;

/**
 * 
 * @author Mei Kefu
 * @date 2010-3-2
 */
public class SchedulerConnectionProvider implements ConnectionProvider {

	public Connection getConnection() throws SQLException {
		return ConnectionManage.getInstance().getWEBConnection();
	}

	public void shutdown() throws SQLException {
	}

}
