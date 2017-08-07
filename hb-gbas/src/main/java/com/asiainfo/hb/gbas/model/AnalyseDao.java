package com.asiainfo.hb.gbas.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import com.asiainfo.hb.web.models.CommonDao;

@Repository
public class AnalyseDao extends CommonDao{
	
	public Map<String, Object> getGbasList(){
		String zbSql = "select zb_code code, zb_name name, cycle from gbas.zb_def";
		String ruleSql = "select rule_code code, rule_name name, cycle from gbas.rule_def";
		
		Map<String, Object> resMap= new HashMap<String, Object>();
		resMap.put("zbList", this.jdbcTemplate.queryForList(zbSql));
		resMap.put("ruleList", this.jdbcTemplate.queryForList(ruleSql));
		return resMap;
	}
	
	public List<Map<String, Object>> getGbasData(String cycle, String startTime, String endTime, String gbasCodes){
		String tableName = "monthly".equals(cycle) ? "BOI_TOTAL_monthly" : "BOI_TOTAL_DAILY";
		StringBuffer sql = new StringBuffer();
		sql.append("select * from gbas.").append(tableName);
		sql.append(" where time_id between ").append(startTime).append(" and ").append(endTime);
		return this.jdbcTemplate.queryForList(sql.toString());
	}
	
	public String getGbasNameByCode(String gbasCode, String type){
		String sql = "";
		if("rule".equals(type)){
			sql = "select max(rule_name) name from gbas.rule_def where rule_code=?";
		}else{
			sql = "select max(zb_name) name from gbas.zb_def where zb_code=?";
		}
		String name = "";
		Map<String, Object> map = this.jdbcTemplate.queryForMap(sql, new Object[]{gbasCode});
		if(!map.isEmpty()){
			name = (String) map.get("name");
		}
		return name;
	}
	
}
