package com.asiainfo.hbbass.common.jdbc.wrapper;

import java.sql.Connection;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.impl.SQLQueryJsonImpl;
import com.asiainfo.hbbass.common.jdbc.wrapper.impl.SQLQueryJsonLimitImpl;
import com.asiainfo.hbbass.common.jdbc.wrapper.impl.SQLQueryJsonPieceImpl;
import com.asiainfo.hbbass.common.jdbc.wrapper.impl.SQLQueryListImpl;
import com.asiainfo.hbbass.component.cache.CacheServerCache;
import com.asiainfo.hbbass.component.cache.CacheServerFactory;

/**
 * 
 * @author Mei Kefu
 * @date 2009-7-22
 */
public class SQLQueryContext {

	private static SQLQueryContext sqlQueryContext = new SQLQueryContext();

	public static String DefaultJndiName = "JDBC_HB";

	public static String webJndiName = "AiomniDB";
	
	public static String nlJndiName = "JDBC_NL";

	public static class SQLQueryName {
		public static String JSON = "json", LIST = "list", JSON_LIMIT = "jsonlimit", JSON_OBJECT = "jsonObject", JSON_PIECE = "jsonPiece";
	}

	private SQLQueryContext() {

	}

	public static SQLQueryContext getInstance() {
		return sqlQueryContext;
	}

	public SQLQuery getSQLQuery(String sqlQueryName, String dataSourceName) {
		return getSQLQuery(sqlQueryName, dataSourceName, false);
	}

	public SQLQuery getSQLQuery(String sqlQueryName, String dataSourceName, boolean isCached) {
		return getSQLQuery(sqlQueryName, dataSourceName, isCached, null);
	}

	public SQLQuery getSQLQuery(String sqlQueryName, String dataSourceName, boolean isCached, Connection connection) {
		SQLQueryBase sqlQuery = null;

		CacheServerCache cache = null;

		if (isCached)
			cache = CacheServerFactory.getInstance().getCache("SQL");

		if (SQLQueryName.JSON.equalsIgnoreCase(sqlQueryName)) {
			sqlQuery = new SQLQueryJsonImpl(cache);
		} else if (SQLQueryName.LIST.equalsIgnoreCase(sqlQueryName)) {
			sqlQuery = new SQLQueryListImpl(cache);
		} else if (SQLQueryName.JSON_LIMIT.equalsIgnoreCase(sqlQueryName)) {
			sqlQuery = new SQLQueryJsonLimitImpl(cache);
		} else if (SQLQueryName.JSON_PIECE.equalsIgnoreCase(sqlQueryName)) {
			sqlQuery = new SQLQueryJsonPieceImpl(cache);
		} else if (SQLQueryName.JSON_OBJECT.equalsIgnoreCase(sqlQueryName)) {
			sqlQuery = new SQLQueryBase(cache);
		}

		// 20091226自动转换Web
		if ("web".equalsIgnoreCase(dataSourceName)) {
			dataSourceName = webJndiName;
		} else if (dataSourceName == null || dataSourceName.length() == 0 || "dw".equalsIgnoreCase(dataSourceName)) {
			dataSourceName = DefaultJndiName;
			// dataSourceName=webJndiName;
		} else if(dataSourceName == null || dataSourceName.length() == 0 || "nl".equalsIgnoreCase(dataSourceName)){
			dataSourceName = nlJndiName;
		}

		if (connection == null) {
			connection = ConnectionManage.getInstance().getConnection(dataSourceName);
		}

		if (sqlQuery != null) {
			sqlQuery.setConnection(connection);
		}

		return sqlQuery == null ? SQLQuery.NULL : sqlQuery;
	}

	public SQLQuery getSQLQuery(String sqlQueryName) {
		return getSQLQuery(sqlQueryName, DefaultJndiName);
	}

	public static void main(String[] args) {

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("json");

		sqlQuery.query("");
	}
}
