package com.asiainfo.hb.core.datastore;

import org.springframework.stereotype.Component;

/**
 * 生成分页的SQL
 * @author Mei Kefu
 * @date 2011-7-19
 */
@Component
public class Db2SqlPageHelper extends SqlPageHelper{

	
	public String getLimitSQL(String sql,int limit,int start,String orderColumn){
		
		if(sql==null || sql.length()==0){
			return "";
		}
		sql = sql.trim();
		if(orderColumn==null || orderColumn.length()==0){
			orderColumn = "1";
		}
		
		StringBuilder limitSQL = new StringBuilder("select * from (select t.*,rownumber() over() as pseudo_column_rownum from (");
		limitSQL.append(sql);
		
		if(sql.endsWith(";")){
			limitSQL.delete(limitSQL.length()-1,limitSQL.length());
		}
		
		if(limitSQL.indexOf("order by")<0){
			limitSQL.append(" order by ").append(orderColumn);
		}
		
		if(limitSQL.indexOf("with ur")>0){
			limitSQL.delete(limitSQL.indexOf("with ur"),limitSQL.length());
		}
		
		
		limitSQL.append(") t) t2 where pseudo_column_rownum between ").append(start+1).append(" and ").append(start+limit).append(" with ur");
		//LOG.debug("SQL:"+pieceSQL);
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
		
		pieceSQL.append(" fetch first "+rows+" rows only ").append(" with ur");
		//LOG.debug("SQL:"+pieceSQL);
		return pieceSQL.toString();
	}
	
}
