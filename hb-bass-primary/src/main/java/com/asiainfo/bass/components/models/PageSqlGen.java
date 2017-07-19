package com.asiainfo.bass.components.models;

import org.springframework.stereotype.Component;

/**
 * 生成分页的SQL
 * 
 * @author Mei Kefu
 * @date 2011-7-19
 */
@Component
public class PageSqlGen {

	public String getLimitSQL(String sql, int limit, int start) {
		return getLimitSQL(sql, limit, start, null);
	}

	public String getLimitSQL(String sql, int limit, int start, String orderColumn) {

		if (orderColumn == null || orderColumn.length() == 0) {
			orderColumn = "1";
		}

		StringBuffer limitSQL = new StringBuffer("select * from (select t.*,rownumber() over(order by " + orderColumn + ") as row_num from (");
		limitSQL.append(sql.trim());

		if (limitSQL.indexOf(" with ur") > 0) {
			limitSQL.delete(limitSQL.indexOf("with ur"), limitSQL.length());
		}

		limitSQL.append(") t) t2 where row_num between ").append(start).append(" and ").append((start + limit) - 1).append(" with ur");
		// LOG.debug("SQL:"+pieceSQL);
		return limitSQL.toString();
	}

	public String getPieceSQL(String sql, int rows) {
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
	 * 得到sql的统计行数的sql
	 * 
	 * @param sql
	 * @return
	 */
	public String getCountSQL(String sql) {
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
	 * @param args
	 */
	public static void main(String[] args) {
		

	}

}
