package com.asiainfo.hbbass.common.jdbc.wrapper;

import java.sql.SQLException;

/**
 * 
 * @author Mei Kefu
 * @date 2009-7-22
 */
public interface SQLQuery {

	/**
	 * 查询完后直接关闭链接
	 * 
	 * @param sql
	 *            : SQL Statement
	 * @return : List or String etc.
	 */
	public Object query(String sql);

	/**
	 * 执行多个SQL 必需手工关闭链接
	 * 
	 * @param sql
	 *            : SQL Statement
	 * @return : List or String etc.
	 */
	public Object querys(String sql) throws SQLException;

	/**
	 * 调用querys时必需手工执行release()
	 */
	public void release();

	/**
	 * 分段查询
	 * 
	 * @param sql
	 *            : SQL Statement
	 * @return : List or String etc.
	 */
	public Object query(String sql, int limit, int start);

	/**
	 * 部分查询，只查前500条
	 * 
	 * @param sql
	 *            : SQL Statement
	 * @return : List or String etc.
	 */
	public Object query(String sql, int rows);

	public static final SQLQuery NULL = new SQLQuery() {

		public Object query(String sql) {
			return null;
		}

		public Object querys(String sql) throws SQLException {
			return null;
		}

		public void release() {
		}

		public Object query(String sql, int limit, int start) {
			return null;
		}

		public Object query(String sql, int rows) {
			return null;
		}
	};

}
