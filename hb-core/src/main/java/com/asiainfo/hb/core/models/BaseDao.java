/**
 * 
 */
package com.asiainfo.hb.core.models;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @author zhangds
 * @date 2015年7月22日
 */
public abstract class BaseDao {
	public Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public Logger getLogger(){
		return this.logger;
	}
	
	protected JdbcTemplate jdbcTemplate;
	
	@SuppressWarnings("all")
	@Autowired
	private void setJdbcTemplate(DataSource dataSource){
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
}
