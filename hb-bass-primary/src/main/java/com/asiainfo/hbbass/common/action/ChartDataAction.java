package com.asiainfo.hbbass.common.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.bass.components.models.Constants;
import com.asiainfo.bass.components.models.DesUtil;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.json.JsonHelper;


public class ChartDataAction extends JsonDataAction {
	private final static Logger LOG = Logger.getLogger(ChartDataAction.class);
	private String sql = "";
	private String ds = null;
	private String caption = "";

	public String chartXml(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setCharacterEncoding("UTF-8");
		Connection connection = null;
		List<String[]> list = new ArrayList<String[]>();

		// 页面传过来的sql如下
		String sql=request.getParameter("sql");
		sql = DesUtil.defaultStrDec(sql);
		LOG.debug(sql);
		try {
			connection = ConnectionManage.getInstance().getConnection(Constants.WEB_DS);
			Statement stat = connection.createStatement();
			ResultSet rs = null;
			rs = stat.executeQuery(sql);
			while (rs.next()) {
				String[] row = new String[2];
				row[0] = rs.getString(1);
				row[1] = rs.getString(2);
				list.add(row);
			}
			rs.close();
			stat.close();
			ConnectionManage.getInstance().releaseConnection(connection);
		} catch (SQLException e) {
			LOG.error("执行失败SQL:" + sql, e);
			e.printStackTrace();
		}
		PrintWriter out = response.getWriter();
		String jsonStr = JsonHelper.getInstance().write(list);
		LOG.debug(jsonStr);
		out.print(jsonStr);
		return null;
	}


	
	/**
	 * @return the caption
	 */
	public String getCaption() {
		return caption;
	}

	/**
	 * @param caption
	 *            the caption to set
	 */
	public void setCaption(String caption) {
		this.caption = caption;
	}

	/**
	 * @return the sql
	 */
	public String getSql() {
		return sql;
	}

	/**
	 * @param sql
	 *            the sql to set
	 */
	public void setSql(String sql) {
		this.sql = sql;
	}

	/**
	 * @return the ds
	 */
	public String getDs() {
		return ds;
	}

	/**
	 * @param ds
	 *            the ds to set
	 */
	public void setDs(String ds) {
		this.ds = ds;
	}

}
