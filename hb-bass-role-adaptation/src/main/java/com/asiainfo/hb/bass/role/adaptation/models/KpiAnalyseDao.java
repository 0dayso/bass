package com.asiainfo.hb.bass.role.adaptation.models;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.asiainfo.hb.bass.role.adaptation.service.KpiAnalyseService;
import com.asiainfo.hb.core.models.BaseDao;

/**
 * 
 * @author xiaoh
 *
 */
@Repository
public class KpiAnalyseDao extends BaseDao implements KpiAnalyseService{

	@Override
	public Map<String, Object> getKpiInfo(String bocId) {
		String sql = "select * from (select a.id id , a.name name, b.kpi_des desc, row_number() over(partition by a.id order by b.kpi_code) num " +
					" from boc_indicator_menu a , kpi_def b where (a.DAILY_CODE= b.KPI_CODE or a.DAILY_CUMULATE_CODE= b.KPI_CODE) " +
					" and a.id=" + bocId + 
					" ) where num =1";
		List<Map<String, Object>> list = this.jdbcTemplate.queryForList(sql);
		if(list != null && list.size()> 0){
			return list.get(0);
		}else{
			return new HashMap<String, Object>();
		}
	}

}
