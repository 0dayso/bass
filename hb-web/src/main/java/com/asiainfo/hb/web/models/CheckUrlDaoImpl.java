package com.asiainfo.hb.web.models;

import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.hb.core.models.JdbcTemplate;

public class CheckUrlDaoImpl implements CheckUrlDao{

	private JdbcTemplate jdbcTemplate;
	
	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	@Autowired
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
	
	/**
	 * 查询URL菜单中所有不为空的URL
	 */
	public List<String> getAllUrl(){
		return jdbcTemplate.queryForList("SELECT URL FROM ST.FPF_SYS_MENU_ITEMS WHERE URL !=''", String.class);
	}
}
