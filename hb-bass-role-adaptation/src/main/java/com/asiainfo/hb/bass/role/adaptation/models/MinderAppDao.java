package com.asiainfo.hb.bass.role.adaptation.models;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.asiainfo.hb.bass.role.adaptation.service.MinderAppService;
import com.asiainfo.hb.core.models.BaseDao;

/**
 * 营销资源管理
 * @author xiaoh
 *
 */
@Repository
public class MinderAppDao extends BaseDao implements MinderAppService{

	@Override
	public List<Map<String, Object>> getCity() {
		String sql= "select area_code,area_name from mk.bt_area union all " +
				"select * from (values ('HB','湖北')) c(area_code,area_name) order by area_code";
		return this.jdbcTemplate.queryForList(sql);
	}

	@Override
	public Map<String, Object> queryCostMaxTime() {
		String sql = "SELECT MAX(TIME_ID) MAXTIME FROM NMK.RESOURCE_COST_REPORT";
		List<Map<String, Object>> list = this.jdbcTemplate.queryForList(sql);
		if(list != null && list.size()>0){
			return list.get(0);
		}else{
			return new HashMap<String, Object>();
		}
	}

	@Override
	public List<Map<String, Object>> queryCostData(String time, String areaCode) {
		String sql = "WITH RPL (TIME_ID,CITY_CODE,COST_NAME,COST_CODE,P_COST_CODE,COST_VALUE,LJ_COST_VALUE,REMARK,level ) " +
				" as ( SELECT TIME_ID,CITY_CODE,COST_NAME,COST_CODE,P_COST_CODE,COST_VALUE,LJ_COST_VALUE,REMARK, 0 level " +
				" FROM NMK.RESOURCE_COST_REPORT WHERE P_COST_CODE is null " +
				" union all " +
				" select child.TIME_ID,child.CITY_CODE,child.COST_NAME,child.COST_CODE,child.P_COST_CODE, " +
				" child.COST_VALUE,child.LJ_COST_VALUE,child.REMARK, SUPER.level+1 level from NMK.RESOURCE_COST_REPORT CHILD, " +
				" RPL SUPER where super.COST_CODE=CHILD.P_COST_CODE and super.time_id=child.time_id and super.CITY_CODE=child.CITY_CODE ) " +
				" SELECT TIME_ID,CITY_CODE,COST_NAME,COST_CODE,P_COST_CODE,value(COST_VALUE, 0) cost_value , value(LJ_COST_VALUE,0) LJ_COST_VALUE ,value(REMARK,'') remark,level , " +
				" (select area_name from (select area_code,area_name from mk.bt_area union all " +
				" select * from (values ('HB','湖北')) c(area_code,area_name)) as ts " +
				" where area_code = RPL.CITY_CODE) area_name FROM RPL " +
				" where time_id=? and city_code=? order by cost_code asc,level asc";
		return this.jdbcTemplate.queryForList(sql, new Object[]{time, areaCode});
	}

}
