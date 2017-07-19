package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;

/**
 * 
 * @author Mei Kefu
 * @date 2010-2-23
 */
public class CreditWeightAction extends Action {

	private static Logger LOG = Logger.getLogger(CreditWeightAction.class);

	public void save(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String jsondata = request.getParameter("weights");

		JsonHelper jsonHelper = JsonHelper.getInstance();
		Object obj = jsonHelper.read(jsondata);

		if (obj instanceof List) {
			@SuppressWarnings("rawtypes")
			List list = (List) obj;
			Connection conn = ConnectionManage.getInstance().getDWConnection();
			try {
				conn.setAutoCommit(false);
				Statement stat = conn.createStatement();
				stat.execute("delete from credit_weight");
				String sql = "insert into credit_weight values";

				for (int i = 0; i < list.size(); i++) {
					String piece = (String) list.get(i);
					LOG.debug(sql + piece);
					stat.execute(sql + piece);
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
			} finally {
				try {
					conn.setAutoCommit(true);
				} catch (SQLException e) {
					e.printStackTrace();
				}
				ConnectionManage.getInstance().releaseConnection(conn);
			}
		}
	}

	public void getWeight(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json");

		String sb = (String) sqlQuery.query("select id,weight*100 weight from credit_weight");

		response.getWriter().write(sb.toString());
	}

}
