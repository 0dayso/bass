package com.asiainfo.bass.components.models;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;

import com.asiainfo.bass.components.models.Constants;

/**
 * 
 * @author LiZhijian
 * 
 */
public class ConnectionManage {

	public static Logger LOG = Logger.getLogger(ConnectionManage.class);

	public static Context ctx = null;

	@SuppressWarnings("rawtypes")
	public static Map map = new HashMap();

	public static ConnectionManage instance = new ConnectionManage();

	private String prefix = "java:comp/env/";

	public static ConnectionManage getInstance() {
		return instance;
	}

	private ConnectionManage() {
		if (prefix == null) {
			prefix = "java:comp/env/";
		}
	}

	@SuppressWarnings("unchecked")
	public DataSource getDataSource(String jndiname) {
		try {
			if (ctx == null)
				ctx = new InitialContext();

			if (map.containsKey(jndiname)) {
				return (DataSource) map.get(jndiname);
			} else {
				DataSource ds = (DataSource) ctx.lookup("java:comp/env/" + jndiname);
				map.put(jndiname, ds);
				return ds;
			}
		} catch (NamingException e) {
			e.printStackTrace();
		}
		return null;
	}

	public Connection getConnection(String jndiname) {
		try {
			if (!jndiname.startsWith("jdbc/")) {
				jndiname = "jdbc/" + jndiname;
			}
			return instance.getDataSource(jndiname).getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public Connection getDWConnection() {
		try {
			return instance.getDataSource(Constants.DW_DS).getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public Connection getWEBConnection() {
		try {
			return instance.getDataSource(Constants.WEB_DS).getConnection();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	public void releaseConnection(Connection conn) {
		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}

	}

	public static void main(String[] args) {

	}
}
