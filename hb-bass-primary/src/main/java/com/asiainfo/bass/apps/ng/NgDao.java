package com.asiainfo.bass.apps.ng;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
public class NgDao {
	
	private static Logger LOG = Logger.getLogger(NgDao.class);
	
	@Autowired
	private DataSource dataSource;
	
	public List<Map<String, Object>> getInd(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select ind1,ind2,ind3,ind4,ind5,ind6,ind7,ind8,ind9,ind10 from NMK.CP_TERM_ALERT_INFO");
	}
	
	public void insert(double ind1,double ind2,double ind3,double ind4,double ind5,double ind6,double ind7,double ind8,double ind9,double ind10){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "insert into NMK.CP_TERM_ALERT_INFO(ind1,ind2,ind3,ind4,ind5,ind6,ind7,ind8,ind9,ind10) values("+ind1+","+ind2+","+ind3+","+ind4+","+ind5+","+ind6+","+ind7+","+ind8+","+ind9+","+ind10+")";
		LOG.info(sql);
		jdbcTemplate.execute(sql);
	}
	
	public void update(double ind1,double ind2,double ind3,double ind4,double ind5,double ind6,double ind7,double ind8,double ind9,double ind10){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "update NMK.CP_TERM_ALERT_INFO set ind1 = "+ind1+",ind2 = "+ind2+",ind3 = "+ind3+",ind4 = "+ind4+",ind5 = "+ind5+",ind6 = "+ind6+",ind7 = "+ind7+",ind8 = "+ind8+",ind9 = "+ind9+",ind10 = "+ind10+"";
		LOG.info(sql);
		jdbcTemplate.execute(sql);
	}

}
