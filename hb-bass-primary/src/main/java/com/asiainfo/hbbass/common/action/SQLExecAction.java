package com.asiainfo.hbbass.common.action;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.bass.components.models.DesUtil;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;

/**
 * 
 * @author Mei Kefu
 * @date 2009-12-21
 */
@SuppressWarnings("unused")
public class SQLExecAction extends Action {

	private static Logger LOG = Logger.getLogger(SQLExecAction.class);

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String ds = request.getParameter("ds");
	    String[] sqls = request.getParameterValues("sqls");
	    Map result = new HashMap();

		Connection conn = null;
		try {
			if ("web".equalsIgnoreCase(ds))
				ds = "jdbc/AiomniDB";
			else if ("am".equalsIgnoreCase(ds))
				ds = "jdbc/JDBC_AM";
			else if ("nl".equalsIgnoreCase(ds))
				ds = "jdbc/JDBC_NL";
			else
				ds = "jdbc/JDBC_HB";

			conn = ConnectionManage.getInstance().getConnection(ds);
			
			try {
				conn.setAutoCommit(false);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			Statement stat = conn.createStatement();

			for (int i = 0; i < sqls.length; i++) {
				String sql = sqls[i];
				LOG.info("SQL:" + sql);
				stat.execute(sql);
			}
			stat.close();
			conn.commit();
		} catch (SQLException e) {
			e.printStackTrace();
			try {
				conn.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			result.put("message", "执行失败");
		} finally {
			try {
				conn.setAutoCommit(true);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		result.put("message", "执行成功");
		response.getWriter().print(JsonHelper.getInstance().write(result));
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		
		String url = "http://10.25.124.114:8080/hbbass/datamart/checklogin.jsp";

		if (url.indexOf("funccode=") > 0)
			url = url.substring(0, url.indexOf("funccode=") - 1);

		System.out.println(url);

	}
}
