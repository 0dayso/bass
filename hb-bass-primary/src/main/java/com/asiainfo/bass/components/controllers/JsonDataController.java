package com.asiainfo.bass.components.controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.bass.components.models.ConnectionManage;
import com.asiainfo.bass.components.models.Constants;
import com.asiainfo.bass.components.models.DesUtil;
import com.asiainfo.hb.core.models.JsonHelper;

/**
 * 用于Ext请求得到json格式的数据
 * 
 * @version 1.0
 * @created 2011-06-25 20:16:24
 * @author LiZhijian
 */
@Controller
@RequestMapping(value = "/jsonData")
public class JsonDataController {
	private final static Logger LOG = Logger.getLogger(JsonDataController.class);
	private String ds = "";
	private String isCutPage = "true";// 是否需要分页

	@RequestMapping(value = "query", method = RequestMethod.POST)
	public String query(WebRequest request, HttpServletResponse response, String sql, String ds, int limit, int start) {
		response.setCharacterEncoding("UTF-8");
		Connection connection = null;
		Statement stat = null;
		ResultSet rs = null;
		String result = "";
		if (sql == null) {
			sql = "";
		}
		if(!sql.trim().toLowerCase().startsWith("select"))
			sql = DesUtil.defaultStrDec(sql);
		LOG.debug("页面传过来的sql如下:" + sql);
		String[] sqls = sql.split(Constants.SEPERATOR);
		for (int i = 0; i < sqls.length; i++) {
			sql = sqls[i];
			LOG.debug("sql_" + i + ":" + sql);
			if (sql == null || sql.length() == 0) {
				result = "{\"total\":" + 0 + ",\"root\":" + "[]" + "}";
			} else {
				// 数据源有两种
				if (ds == null)
					return result;
				if ((sql.trim().length() > 7 && sql.trim().substring(0, 7).equalsIgnoreCase("select ")) || (sql.trim().length() > 5 && sql.trim().substring(0, 5).equalsIgnoreCase("with "))) {
					//屏蔽pwd
					if(sql.indexOf("pwd")>0){
						sql = sql.replaceAll("pwd,", "");
						sql = sql.replaceAll("pwd ,", "");
					}
					try {
						connection = ConnectionManage.getInstance().getConnection(ds);
						stat = connection.createStatement();
						Integer total = 0;
						// select语句，求总结果数
						total = getTotalCount(sql, ds);
						// select语句，求分页sql
						String limitSql = getLimitSQL(sql, limit, start, total);
						if ("true".equals(isCutPage)) {
							rs = stat.executeQuery(limitSql);
						} else {// 直接输出json对象，不需要加分页，传入不分页的sql，输出全部数据
							rs = stat.executeQuery(sql);
						}
						if (rs != null) {
							Object obj = format(rs);
							result += JsonHelper.getInstance().write(obj);
							result = "{\"total\":" + total + ",\"root\":" + result + "}";
						}
						rs.close();
						stat.close();
						ConnectionManage.getInstance().releaseConnection(connection);
					} catch (SQLException e) {
						LOG.error("执行失败SQL:" + sql, e);
						e.printStackTrace();
					}
				} else if (sql.trim().length() > 7 && sql.trim().substring(0, 7).equalsIgnoreCase("delete ")) {
					try {
						connection = ConnectionManage.getInstance().getConnection(ds);
						stat = connection.createStatement();
						stat.execute(sql);
						stat.close();
						ConnectionManage.getInstance().releaseConnection(connection);
					} catch (SQLException e) {
						result = "-1";
						LOG.error("执行失败SQL:" + sql, e);
						e.printStackTrace();
					}
				} else if (sql.trim().length() > 7 && sql.trim().substring(0, 7).equalsIgnoreCase("update ")) {
					try {
						connection = ConnectionManage.getInstance().getConnection(ds);
						stat = connection.createStatement();
						stat.executeUpdate(sql);
						stat.close();
						ConnectionManage.getInstance().releaseConnection(connection);
					} catch (SQLException e) {
						result = "-1";
						LOG.error("执行失败SQL:" + sql, e);
						e.printStackTrace();
					}
				} else if (sql.trim().length() > 7 && sql.trim().substring(0, 7).equalsIgnoreCase("insert ")) {
					try {
						connection = ConnectionManage.getInstance().getConnection(ds);
						stat = connection.createStatement();
						stat.execute(sql);
						stat.close();
						ConnectionManage.getInstance().releaseConnection(connection);
					} catch (SQLException e) {
						result = "-1";
						LOG.error("执行失败SQL:" + sql, e);
						e.printStackTrace();
					}
				} else if (sql.trim().length() > 5 && sql.trim().substring(0, 5).equalsIgnoreCase("drop ")) {
					try {
						connection = ConnectionManage.getInstance().getConnection(ds);
						stat = connection.createStatement();
						stat.execute(sql);
						stat.close();
						ConnectionManage.getInstance().releaseConnection(connection);
					} catch (SQLException e) {
						result = "-1";
						LOG.error("执行失败SQL:" + sql, e);
						e.printStackTrace();
					}
				}
			}
		}
		PrintWriter out;
		try {
			out = response.getWriter();
			LOG.debug("查询的结果json:" + result);
			out.print(result);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Json数据格式化
	 * 
	 * @param rs
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected Object format(ResultSet rs) {
		List result = new ArrayList();
		try {
			ResultSetMetaData rsmd = rs.getMetaData();
			int size = rsmd.getColumnCount();
			while (rs.next()) {
				Map map = new HashMap();
				for (int i = 0; i < size; i++) {
					String colName = rsmd.getColumnName(i + 1);
					int type = rsmd.getColumnType(i + 1);
					if (Types.INTEGER == type || Types.SMALLINT == type) {
						map.put(colName.toLowerCase(), rs.getInt(colName));
					} else if (Types.BIGINT == type) {
						map.put(colName.toLowerCase(), rs.getLong(colName));
					} else if (Types.DECIMAL == type || Types.FLOAT == type || Types.DOUBLE == type) {
						map.put(colName.toLowerCase(), rs.getBigDecimal(colName));// 使用bigDecimal来取，可以取到null
					} else {
						map.put(colName.toLowerCase(), rs.getString(colName));
					}
				}
				result.add(map);
			}
		} catch (SQLException e) {
			LOG.error(e.getMessage(), e);
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 得到sql的统计行数的sql
	 * 
	 * @param sql
	 * @return
	 */
	protected String getCountSQL(String sql) {
		StringBuffer countSQL = new StringBuffer("select count(*) cnt from (");
		countSQL.append(sql.trim());
		if (countSQL.indexOf(" with ur") > 0) {
			countSQL.delete(countSQL.indexOf("with ur"), countSQL.length());
		}
		countSQL.append(") t").append(" with ur");
		return countSQL.toString();
	}

	/**
	 * 计算总的行数
	 * 
	 * @param sql
	 * @return
	 * @throws SQLException
	 */
	protected Integer getTotalCount(String sql, String ds) throws SQLException {
		Integer total = 0;
		Connection connection = null;
		try {
			connection = ConnectionManage.getInstance().getConnection(ds);
			if (connection != null && sql.length() > 0) {
				Statement stat = connection.createStatement();
				String countSQL = getCountSQL(sql);
				// LOG.debug("countSQL:" + countSQL);
				ResultSet rs = stat.executeQuery(countSQL);
				if (rs.next()) {
					total = rs.getInt(1);
				}
				rs.close();
				stat.close();
			}
			ConnectionManage.getInstance().releaseConnection(connection);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return total;
	}

	/**
	 * 求分页sql
	 * 
	 * @param sql
	 * @param limit
	 * @param start
	 * @return
	 */
	protected String getLimitSQL(String sql, int limit, int start, int total) {
		if (start == 0) {
			start = 1;
		}
		StringBuffer limitSQL = new StringBuffer("select * from (select t.*,rownumber() over(order by 1) as row_num from (");
		limitSQL.append(sql.trim());
		if (limitSQL.indexOf(" with ur") > 0) {
			limitSQL.delete(limitSQL.indexOf("with ur"), limitSQL.length());
		}
		if (limit > total) {
			limitSQL.append(") t) t2 where row_num between ").append(start).append(" and ").append(total).append(" with ur");
		} else if (start == 1) {
			limitSQL.append(") t) t2 where row_num between ").append(start).append(" and ").append(limit).append(" with ur");
		} else {
			limitSQL.append(") t) t2 where row_num between ").append(start + 1).append(" and ").append(start + limit).append(" with ur");
		}
		LOG.debug("分页SQL:" + limitSQL);
		return limitSQL.toString();
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

	/**
	 * @return the isCutPage
	 */
	public String getIsCutPage() {
		return isCutPage;
	}

	/**
	 * @param isCutPage
	 *            the isCutPage to set
	 */
	public void setIsCutPage(String isCutPage) {
		this.isCutPage = isCutPage;
	}

}
