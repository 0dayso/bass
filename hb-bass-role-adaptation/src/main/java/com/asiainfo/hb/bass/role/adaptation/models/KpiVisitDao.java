package com.asiainfo.hb.bass.role.adaptation.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.bass.role.adaptation.service.KpiVisitService;
import com.asiainfo.hb.core.models.BaseDao;

/**
 * @author zuoyl
 * 
 * */
@Repository
public class KpiVisitDao extends BaseDao implements KpiVisitService {
	public List<Map<String, Object>> getNum() {
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM (SELECT distinct kpi_category name, COUNT(*) raised FROM FPF_KPI_VISIT GROUP BY kpi_category ORDER BY raised DESC),(select count(*) goal  from fpf_kpi_visit)  FETCH FIRST 5 ROWS ONLY with ur";
		
		try {
			list = jdbcTemplate.queryForList(sql);
			if(list.size()<5){
				int i=list.size();
				for(list.size();i<5;i++){
					Map<String, Object> map=new HashMap<String, Object>();
					map.put("name", "没有数据");
					map.put("raised", 0);
					map.put("goal", 1);
					list.add(map);
				}
			}

		} catch (DataAccessException e) {
			e.printStackTrace();
		}
		return list;
	}

	
	@SuppressWarnings("unused")
	@Override
	public void insertKpi(int id, String kpicode) {
		String sql="select kpi_code,kpi_name,category from BOC_INDICATOR_MENU,kpi_def where kpi_code='"+kpicode+"' and id="+id+"";
		
		List<Map<String,Object> > list=jdbcTemplate.queryForList(sql);
		int i=0;
		for(Map<String,Object> m: list){
			String sql1="insert into fpf_kpi_visit (kpi_code,kpi_name,kpi_category) values('"+m.get("kpi_code")+"','"+m.get("kpi_name")+"','"+m.get("category")+"')";
			i=jdbcTemplate.update(sql1);
		}
	
	}
	@SuppressWarnings("unused")
	@Override
	public void insertKpiLog(String id,String kpicode,String date,String user) {
		String sql="select kpi_code,kpi_name,category from BOC_INDICATOR_MENU,kpi_def where kpi_code='"+kpicode+"' and id="+id+"";
		List<Map<String,Object> > list=jdbcTemplate.queryForList(sql);
		int i=0;
		for(Map<String,Object> m: list){
			String sql1="insert into fpf_kpi_visit (kpi_code,kpi_name,kpi_category,user_name,visit_time) values('"+m.get("kpi_code")+"','"+m.get("kpi_name")+"','"+m.get("category")+"','"+user+"','"+date+"')";
			i=jdbcTemplate.update(sql1);	
		}
		
		}
}
