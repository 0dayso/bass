package com.asiainfo.hbbass.kpiportal.load;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;

import com.asiainfo.bass.components.models.BeanFactoryA;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;

/**
 * 从数据库批量加载的KpiEntity，相当于KpiLoader的数据库
 * @author MeiKefu
 * @date 2012-9-17 
 */
public class KpiDataStore {
	
	private JdbcTemplate jdbcTemplate;
	
	public KpiDataStore(String appName,String date){
		DataSource dataSource = (DataSource)BeanFactoryA.getBean("dataSource");
		jdbcTemplate = new JdbcTemplate(dataSource,false);
		initialize(appName,date);
	}
	
	Map<String,List<Map<String,String>>> dataStore = new HashMap<String,List<Map<String,String>>>();
	
	public List<Map<String,String>> getData(String id){
		return dataStore.get(id);
	}
	
	public void initialize(String appName,String date){
		String sql="";
		if(appName.startsWith("Channel")){
			sql="select t1.zb_code,t1.channel_code region_id, max(value(t1.channel_name,'')) region_name,t1.parent_channel_code parent_id,value(targetvalue,0) targetvalue,value('','-1') brand_id"
				+"	,max(t1.value) as current"
				+"	,value(sum(case when t2.time_id =? then t2.value end),0) as pre"
				+"	,value(sum(case when t2.time_id =? then t2.value end),0) as before"
				+"	,value(sum(case when t2.time_id =? then t2.value end),0) as year "
				+"	from kpi_total_"+(appName.endsWith("M")?"monthly":"daily")+" t1"
				+"	left join kpiportal_target on t1.ZB_CODE=ZBCODE and t1.channel_code=AREA_ID"
				+"	left join "
				+"	(select * from kpi_total_"+(appName.endsWith("M")?"monthly":"daily")+" where time_id in (?,?,?)  and length(channel_code)<=8) t2"
				+"	on t1.ZB_CODE=t2.zb_code and t1.channel_code=t2.channel_code and t1.parent_channel_code=t2.parent_channel_code" 
				+"	where t1.time_id=?  and length(t1.channel_code)<=8"
				+"	group by t1.zb_code,t1.channel_code,t1.parent_channel_code,targetvalue"
				+"	order by t1.zb_code,t1.channel_code with ur ";
		}else if (appName.startsWith("Bureau")){
			sql="select t1.zb_code,t1.region_id, max(value(t1.region_name,'')) region_name,t1.parent_id,value(targetvalue,0) targetvalue,value('','-1') brand_id"
					+" ,max(t1.value) as current"
					+" ,value(sum(case when t2.time_id =? then t2.value end),0) as pre"
					+" ,value(sum(case when t2.time_id =? then t2.value end),0) as before"
					+" ,value(sum(case when t2.time_id =? then t2.value end),0) as year "
					+" from kpi_bureau_town_"+(appName.endsWith("M")?"monthly":"daily")+" t1"
					+" left join kpiportal_target on t1.ZB_CODE=ZBCODE and t1.region_id=AREA_ID" 
					+" left join "
					+" (select * from kpi_bureau_town_"+(appName.endsWith("M")?"monthly":"daily")+" where time_id in (?,?,?)  and level<=3) t2"
					+" on t1.ZB_CODE=t2.zb_code and t1.region_id=t2.region_id and t1.parent_id=t2.parent_id and t1.level=t2.level"
					+" where t1.time_id=?  and t1.level<=3 "
					+" group by t1.zb_code,t1.region_id,t1.parent_id,targetvalue,t1.level"
					+" order by t1.zb_code,t1.level,t1.region_id with ur ";
		}else if (appName.startsWith("College")){
			sql="select t1.zb_code,t1.region_id, max(value(t1.region_name,'')) region_name,t1.parent_id,value(targetvalue,0) targetvalue,value(t1.brand_id,'-1') brand_id"
					+" ,max(t1.value) as current"
					+" ,value(sum(case when t2.time_id =? then t2.value end),0) as pre"
					+" ,value(sum(case when t2.time_id =? then t2.value end),0) as before"
					+" ,value(sum(case when t2.time_id =? then t2.value end),0) as year "
					+" from kpi_college_"+(appName.endsWith("M")?"monthly":"daily")+" t1"
					+" left join kpiportal_target on t1.ZB_CODE=ZBCODE and t1.region_id=AREA_ID" 
					+" left join "
					+" (select * from kpi_college_"+(appName.endsWith("M")?"monthly":"daily")+" where time_id in (?,?,?)  and level<=3) t2"
					+" on t1.ZB_CODE=t2.zb_code and t1.region_id=t2.region_id and t1.brand_id=t2.brand_id and t1.parent_id=t2.parent_id and t1.level=t2.level"
					+" where t1.time_id=?  and t1.level<=3 "
					+" group by t1.zb_code,t1.region_id,t1.parent_id,targetvalue,t1.level,t1.brand_id"
					+" order by t1.zb_code,t1.level,t1.region_id with ur ";
		}
		
		if(sql.length()>0){
			String[] dates = KPIPortalContext.calDate(date);
			String current = date;
			String pre = dates[0];
			String before = dates[1];
			String year = dates[2];
			Object[] args = new Object[]{pre,before,year,pre,before,year,current};
			
			jdbcTemplate.query(sql, new ResultSetExtractor<Object>(){
				@Override
				public Object extractData(ResultSet rs) throws SQLException,DataAccessException {
					
					while(rs.next()){
						String zbCode = rs.getString("zb_code");
						String region_id = rs.getString("region_id");
						String region_name = rs.getString("region_name");
						String parent_id = rs.getString("parent_id");
						String brand_id = rs.getString("brand_id");
						String targetvalue = rs.getString("targetvalue");
						String current = rs.getString("current");
						String pre = rs.getString("pre");
						String before = rs.getString("before");
						String year = rs.getString("year");
						
						Map<String,String> map = new HashMap<String,String>();
						
						map.put("region_id", region_id);
						map.put("region_name", region_name);
						map.put("parent_id", parent_id);
						map.put("brand_id", brand_id);
						map.put("targetvalue", targetvalue);
						map.put("current", current);
						map.put("pre", pre);
						map.put("before", before);
						map.put("year", year);
						
						if(!dataStore.containsKey(zbCode)){
							dataStore.put(zbCode, new ArrayList<Map<String,String>>());
						}
						List<Map<String,String>> datas = dataStore.get(zbCode);
						datas.add(map);
					}
					return null;
				}
			},args);
		}
	}
	
}
