package com.asiainfo.hb.core.datastore;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.stereotype.Component;

import com.asiainfo.hb.core.models.JdbcTemplate;

/**
 * 生成分页的SQL
 * @author Mei Kefu
 * @date 2013-6-9
 */
@Component
public class SqlserverSqlPageHelper extends SqlPageHelper{
	
	public SqlserverSqlPageHelper(){
		
	}
	
	public SqlserverSqlPageHelper(JdbcTemplate jdbcTemplate){
		if(this.jdbcTemplate == null){
			this.jdbcTemplate = jdbcTemplate;
		}
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	private String fetchRowName(String sql,final int columNum){
		if( this.jdbcTemplate!=null){
			StringBuilder sb = new StringBuilder();
			sb.append(sql).append(sql.indexOf("where")>0?" and 1=2":" where 1=2");
			
			String result = "";
			result = (String)this.jdbcTemplate.query(sb.toString(), new ResultSetExtractor(){
				@Override
				public String extractData(ResultSet rs) throws SQLException,
						DataAccessException {
					ResultSetMetaData rsmd = rs.getMetaData();
					return rsmd.getColumnName(columNum);
				}
			});
			return result;
		}else{
			throw new RuntimeException("SqlserverSqlPageHelper must be set jdbcTemplate,please use JdbcTemplate.getSqlPageHelper to get the sqlpagehelper");
		}
	}
	
	public String getLimitSQL(String sql,int limit,int start,String orderColumn){
		if(sql==null || sql.length()==0){
			return "";
		}
		if(orderColumn==null || orderColumn.length()==0){
			orderColumn = fetchRowName(sql,1);
		}
		sql=sql.trim();
		StringBuilder limitSQL = new StringBuilder("select * from (select t.*,ROW_NUMBER() over(order by "+orderColumn+") as pseudo_column_rownum from (");
		limitSQL.append(sql);
		if(sql.endsWith(";")){
			limitSQL.delete(limitSQL.length()-1,limitSQL.length());
		}
		if(limitSQL.indexOf(" with ur")>0){
			limitSQL.delete(limitSQL.indexOf("with ur"),limitSQL.length());
		}
		
		limitSQL.append(") t) t2 where pseudo_column_rownum between ").append(start+1).append(" and ").append(start+limit).append(" ");
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
	
	public String getCountSQL(String sql){
		StringBuilder countSQL = new StringBuilder("select count(*) cnt from (");
		countSQL.append(sql.trim());
		
		if(countSQL.indexOf(" order by")>0){
			countSQL.delete(countSQL.indexOf("order by"),countSQL.length());
		}
		countSQL.append(") t");
		//countSQL.append(" with ur");
		
		//LOG.debug("SQL:"+countSQL);
		return countSQL.toString();
	}
	
}
