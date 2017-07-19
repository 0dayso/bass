package com.asiainfo.bass.apps.dataDetail;

import java.util.List;
import java.util.Map;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
public class DataDetailDao {
	
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}
	
	public List<Map<String ,Object>> getTimeList(){
		String sql = "select distinct bigint(time_id) timeid from NWH.DM_BROADBAND_INSTALLMAINTAIN_DM order by bigint(time_id) desc";
		return this.jdbcTemplate.queryForList(sql);
	}
	
	public List<Map<String, Object>> getDataList(String cityId, String timeId){
		String sql = "select REGION_ID,COUNTY,COUNTY_TYPE,CONNECT_TYPE,INSTALL_FLAG,INSTALLMAINTAIN," +
				" COUNT(CASE WHEN FLAG = 1 THEN PHONE_NO END) Y_CNT," +
				" COUNT(CASE WHEN FLAG = 0 THEN PHONE_NO END) N_CNT " +
				" FROM NWH.DM_BROADBAND_INSTALLMAINTAIN_DM " +
				" where TIME_ID=" + timeId;
		if (!"0".equals(cityId)) {
			sql += " and region_id = (select area_name from FPF_BT_AREA where area_id = " + cityId + ")";
		}
		sql += " GROUP BY REGION_ID,COUNTY,COUNTY_TYPE,CONNECT_TYPE,INSTALL_FLAG,INSTALLMAINTAIN " +
				" order by REGION_ID,COUNTY,COUNTY_TYPE WITH UR";
		return jdbcTemplate.queryForList(sql);
	}

}
