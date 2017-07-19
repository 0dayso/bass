package com.asiainfo.hb.core.datastore;

import org.springframework.stereotype.Component;

/**
 * 生成分页的SQL
 * @author Mei Kefu
 * @date 2011-9-2
 */
@Component
public class OracleSqlPageHelper extends SqlPageHelper{

	
	public String getLimitSQL(String sql,int limit,int start,String orderColumn){
		
		if(orderColumn==null || orderColumn.length()==0){
			orderColumn = "1";
		}
		sql = sql.trim();
		StringBuilder limitSQL = new StringBuilder("select * from (select t.*,rownum as pseudo_column_rownum from (");
		limitSQL.append(sql);
		
		if(sql.endsWith(";")){
			limitSQL.delete(limitSQL.length()-1,limitSQL.length());
		}
		
		limitSQL.append(") t order by "+orderColumn+") t2 where pseudo_column_rownum between ").append(start+1).append(" and ").append(start+limit);
		
		return limitSQL.toString();
	}
	
	public String getPieceSQL(String sql,int rows){
		if(rows<pieceRow){
			rows=pieceRow;
		}
		StringBuilder pieceSQL = new StringBuilder(sql.trim());
		
		if(pieceSQL.indexOf(" fetch first")>0){
			pieceSQL.delete(pieceSQL.indexOf("fetch first"),pieceSQL.length());
		}
		
		if(pieceSQL.indexOf(" with ur")>0){
			pieceSQL.delete(pieceSQL.indexOf("with ur"),pieceSQL.length());
		}
		
		pieceSQL.append(" rownum <= "+rows);
		//LOG.debug("SQL:"+pieceSQL);
		return pieceSQL.toString();
	}
	
}
