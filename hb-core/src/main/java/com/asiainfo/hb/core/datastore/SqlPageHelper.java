package com.asiainfo.hb.core.datastore;

import com.asiainfo.hb.core.models.BeanFactory;
import com.asiainfo.hb.core.models.JdbcTemplate;

/**
 * 生成分页的SQL
 * @author Mei Kefu
 * @date 2011-7-19
 */
public abstract class SqlPageHelper {

	public abstract String getLimitSQL(String sql,int limit,int start,String orderColumn);
	
	public abstract String getPieceSQL(String sql,int rows);
	
	protected JdbcTemplate jdbcTemplate = null;
	
	protected void setJdbcTemplate(JdbcTemplate jdbcTemplate){
		this.jdbcTemplate = jdbcTemplate;
	}
	
	protected int pieceRow=500;//随机取的行数
	
	public String getLimitSQL(String sql,int limit,int start){
		return getLimitSQL(sql, limit, start, null);
	}
	
	/**
	 * 根据数据类型得到相应的分页sql生成器
	 * @param databaseType
	 * @deprecated use getSqlPageHelper(JdbcTemplate)
	 * @return
	 */
	public static SqlPageHelper getSqlPageHelper(String databaseType){
		return (SqlPageHelper)BeanFactory.getBean(databaseType+"SqlPageHelper");
	}
	
	public static SqlPageHelper getSqlPageHelper(JdbcTemplate jdbcTemplate){
		SqlPageHelper sqlPageHelper =(SqlPageHelper)BeanFactory.getBean(jdbcTemplate.getDatabaseType()+"SqlPageHelper");
		sqlPageHelper.setJdbcTemplate(jdbcTemplate);
		return sqlPageHelper;
	}
	
	/**
	 * 得到sql的统计行数的sql
	 * @param sql
	 * @return
	 */
	public String getCountSQL(String sql){
		StringBuilder countSQL = new StringBuilder("select count(*) cnt from (");
		countSQL.append(sql.trim());
		
		if(countSQL.indexOf(" with ur")>0){
			countSQL.delete(countSQL.indexOf("with ur"),countSQL.length());
		}
		countSQL.append(") t");
		//countSQL.append(" with ur");
		
		//LOG.debug("SQL:"+countSQL);
		return countSQL.toString();
	}
	
}
