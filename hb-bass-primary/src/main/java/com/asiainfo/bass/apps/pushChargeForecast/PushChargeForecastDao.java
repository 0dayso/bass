package com.asiainfo.bass.apps.pushChargeForecast;

import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
@SuppressWarnings("rawtypes")
public class PushChargeForecastDao {
	
	private static Logger LOG = Logger.getLogger(PushChargeForecastDao.class);
	
	@Autowired
	private DataSource dataSource;
	
	@Autowired
	private DataSource dataSourceDw;
	
	public List getList(String sql){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		return jdbcTemplate.queryForList(sql);
	}
	
	public List getVISITLIST(String title){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "select * from FPF_VISITLIST where loginname='sender' and track='信息推送-邮件' and opername like '%"+title+"%'";
		return jdbcTemplate.queryForList(sql);
	}
	
	public void insertVISITLIST(String strTo, String today){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		LOG.info("fileName="+"经分系统"+today.substring(0,6)+"月收入预测");
		jdbcTemplate.update("insert into FPF_VISITLIST(loginname,area_id,track,opertype,opername) values('sender','0','信息推送-邮件',?,?)", new Object[] {  strTo, "经分系统"+today.substring(0,6)+"月收入预测" });
	}

}
