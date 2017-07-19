package com.asiainfo.bass.apps.stock;

import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
@SuppressWarnings("rawtypes")
public class StockDao {

	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(StockDao.class);
	
	@Autowired
	private DataSource dataSourceDw;
	
	public int getCountByRegionName(String region_name){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		Map map = jdbcTemplate.queryForMap("select count(*) count from nmk.snapshot_region where region_name = '"+region_name+"'");
		return Integer.parseInt(map.get("count").toString());
	}
	
	public int getCountForPersonManager(String manager_name,String manager_accnbr){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		Map map = jdbcTemplate.queryForMap("select count(*) count from nmk.manager_region where manager_name = '"+manager_name+"' and manager_accnbr = '"+manager_accnbr+"'");
		return Integer.parseInt(map.get("count").toString());
	}
	
	public void saveCounty(String region_name){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		jdbcTemplate.update("insert into nmk.snapshot_region values('"+region_name+"','ОЃжн',1,0)");
	}
	
	public void savePersonManager(String region_name, String manager_name, String manager_accnbr, String manager_type, String region_level){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		jdbcTemplate.update("insert into nmk.manager_region values('"+manager_name+"','"+manager_accnbr+"',"+Integer.parseInt(manager_type)+",'"+region_name+"', "+Integer.parseInt(region_level)+")");
	}
	
	public void saveMarketing(String region_name, String parent_region_name){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		jdbcTemplate.update("insert into nmk.snapshot_region values('"+region_name+"','"+parent_region_name+"',2,1)");
	}
	
	public void deleteCounty(String region_name){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		jdbcTemplate.update("delete from  nmk.snapshot_region where region_name = '"+region_name+"'");
	}
	
	public void deletePersonManager(String region_name, String manager_name){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		jdbcTemplate.update("delete from  nmk.manager_region where region_name = '"+region_name+"' and manager_name = '"+manager_name+"'");
	}
	
	public void deletePersonManager(String region_name){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		jdbcTemplate.update("delete from  nmk.manager_region where region_name = '"+region_name+"'");
	}
}
