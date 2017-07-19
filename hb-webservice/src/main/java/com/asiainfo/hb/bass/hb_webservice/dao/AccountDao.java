package com.asiainfo.hb.bass.hb_webservice.dao;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.core.models.JdbcTemplate;

@Repository
public class AccountDao {
	
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource,false);
	}
	
	public Map<String, Object> getUserInfo(String userId){
		String sql = "select username, status from fpf_user_user where userid=?";
		List<Map<String, Object>> list = jdbcTemplate.queryForList(sql, new Object[]{userId});
		if(list != null && list.size()>0){
			return list.get(0);
		}
		return null;
	}
	
	public void delAccount(String userId){
		//status 1表示正常
		String sql = "update fpf_user_user set status=0 where userid=?";
		jdbcTemplate.update(sql, new Object[]{userId});
	}
}
