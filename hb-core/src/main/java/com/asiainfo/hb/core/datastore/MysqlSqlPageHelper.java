package com.asiainfo.hb.core.datastore;

import org.springframework.stereotype.Component;

/**
 * 生成分页的SQL
 * @author Mei Kefu
 * @date 2011-9-2
 */
@Component
public class MysqlSqlPageHelper extends SqlPageHelper{
	
	public String getLimitSQL(String sql,int limit,int start,String orderColumn){
		if(orderColumn==null || orderColumn.length()==0){
			orderColumn = "1";
		}
		sql=sql.trim();
		StringBuilder limitSQL = new StringBuilder(sql);
		if(sql.endsWith(";")){
			limitSQL.delete(limitSQL.length()-1,limitSQL.length());
		}
		limitSQL.append(" limit ").append(start+1).append(" , ").append(start+limit);
		return limitSQL.toString();
	}
	
	public String getPieceSQL(String sql,int rows){
		return getLimitSQL(sql, rows, 1, null);
	}
	
}
