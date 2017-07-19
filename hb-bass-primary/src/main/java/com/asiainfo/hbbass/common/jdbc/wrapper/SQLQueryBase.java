package com.asiainfo.hbbass.common.jdbc.wrapper;

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

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.component.cache.CacheServerCache;
import com.asiainfo.hbbass.component.util.Util;

/**
 * 
 * @author Mei Kefu
 * @date 2009-7-22
 */
public class SQLQueryBase implements SQLQuery {

	public static Logger LOG = Logger.getLogger(SQLQueryBase.class);

	protected Connection connection = null;

	public Connection getConnection() {
		return connection;
	}

	public void setConnection(Connection connection) {
		this.connection = connection;
	}

	public Object querys(String sql) throws SQLException {

		Object obj = getObjectFromCache(sql);// from Cache

		if (obj == null && connection != null && sql != null && sql.length() > 0) {
			try {
				Statement stat = connection.createStatement();
				ResultSet rs = stat.executeQuery(sql);
				if (rs != null) {
					LOG.debug("SQL:" + sql);
					obj = format(rs);
				}
				rs.close();
				stat.close();
				putObjectToCache(sql, obj);
			} catch (SQLException e) {
				LOG.error("执行失败SQL:" + sql, e);
				e.printStackTrace();
				throw e;
			}
		}
		return obj;
	}

	protected CacheServerCache cache = null;

	public SQLQueryBase(CacheServerCache cache) {
		super();
		this.cache = cache;
	}

	public SQLQueryBase() {
	}

	protected void putObjectToCache(String sql, Object obj) {
		if (cache != null)
			cache.put(Util.md5(sql), obj);
	}

	protected Object getObjectFromCache(String sql) {
		return cache != null ? cache.get(Util.md5(sql)) : null;
	}

	public Object query(String sql) {
		Object obj = null;
		try {
			obj = querys(sql);
		} catch (SQLException e) {
			LOG.error("执行失败SQL:" + sql, e);
			e.printStackTrace();
		} finally {
			release();
		}
		return obj;
	}

	public void release() {
		try {
			if (connection != null && !connection.isClosed()) {
				connection.close();
				connection = null;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public Object query(String sql, int limit, int start) {
		return query(sql, 500);
	}

	public Object query(String sql, int rows) {
		return query(getPieceSQL(sql, rows));
	}

	protected String getPieceSQL(String sql, int rows) {
		if (rows < 500) {
			rows = 500;
		}
		StringBuffer pieceSQL = new StringBuffer(sql.trim());

		if (pieceSQL.indexOf(" fetch first") > 0) {
			pieceSQL.delete(pieceSQL.indexOf("fetch first"), pieceSQL.length());
		}

		if (pieceSQL.indexOf(" with ur") > 0) {
			pieceSQL.delete(pieceSQL.indexOf("with ur"), pieceSQL.length());
		}

		pieceSQL.append(" fetch first " + rows + " rows only ").append(" with ur");
		// LOG.debug("SQL:"+pieceSQL);
		return pieceSQL.toString();
	}

	/**
	 * 格式化游标,并放回处理后的对象
	 * 
	 * @param rs
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	protected Object format(ResultSet rs) {
		LOG.debug("Json数据格式化");
		
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
						// map.put(colName.toLowerCase(),
						// rs.getDouble(colName));
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

		// LOG.debug("SQL:"+countSQL);
		return countSQL.toString();
	}

	/**
	 * 计算总的行数
	 * 
	 * @param sql
	 * @return
	 * @throws SQLException
	 */
	protected Integer getTotalCount(String sql) throws SQLException {
		Integer total = 0;
		if (connection != null && sql.length() > 0) {
			Statement stat = connection.createStatement();
			String countSQL = getCountSQL(sql);

			// 从缓存中取cnt的值，是放的Integer对象
			Object obj1 = getObjectFromCache(countSQL);
			if (obj1 != null) {
				LOG.debug("从缓存中命中countSQL的值:" + countSQL);
				total = (Integer) obj1;
			} else {
				LOG.debug("countSQL:" + countSQL);
				ResultSet rs = stat.executeQuery(countSQL);
				if (rs.next()) {
					total = rs.getInt(1);
				}
				rs.close();
				stat.close();
				putObjectToCache(countSQL, total);
			}
		}
		return total;
	}
}
