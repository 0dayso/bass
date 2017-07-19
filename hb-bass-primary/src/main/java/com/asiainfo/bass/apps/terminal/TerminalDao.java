package com.asiainfo.bass.apps.terminal;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

/*代码真烂*/
@Repository
public class TerminalDao {
	
	private static Logger LOG = Logger.getLogger(TerminalDao.class);
	
	@Autowired
	private DataSource dataSource;

	@Autowired
	private DataSource dataSourceDw;

	//@Autowired
	//private DataSource dataSourceNl;
	
	public List<Map<String,Object>> getCity(String cityId) throws Exception{
		List<Map<String,Object>> result = null ;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select key, value from (select area_id, area_code key,case when area_name='湖北' then '全省' else area_name end  value from mk.bt_area ";
			if(!"".equals(cityId) && !"0".equals(cityId)){
				sql = sql + " ) a where area_id = "+cityId;
			}else if(!"".equals(cityId) && "0".equals(cityId)){
				sql = sql + " union all select 0 cityId, 'HB' key, '全省' value from sysibm.sysdummy1) a ";
			}
			sql = sql + " order by 1 ";
			result = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:"+sql);
		}
		return result;
	}
	
	public List<Map<String,Object>> getArea(String cityId) throws Exception{
		List<Map<String,Object>> result = null ;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select county_id key,county_name value from MK.BT_AREA_ALL_VIEW where area_id = "+cityId;
			sql = sql + " order by area_id,county_id ";
			result = jdbcTemplate.queryForList(sql);
		} catch (DataAccessException e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:"+sql);
		}
		return result;
	}
	
	public List<Map<String,Object>> getAreaByCode(String cityId) throws Exception{
		List<Map<String,Object>> result = null ;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select county_id key,county_name value from MK.BT_AREA_ALL_VIEW where area_code = '"+cityId+"'";
			sql = sql + " order by area_id,county_id ";
			result = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:"+sql);
		}
		return result;
	}
	
	public List<Map<String, Object>> getList(String sql) throws Exception {
		List<Map<String, Object>> result = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			result = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public String getAreaCode(String area_id) throws Exception {
		String result = "";
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select area_code from mk.bt_area where area_id="+area_id+"";
			HashMap map = (HashMap)jdbcTemplate.queryForMap(sql);
			result = map.get("AREA_CODE").toString();
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public double getAverage(String averageSql) throws Exception {
		double result = 0D;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			HashMap map = (HashMap)jdbcTemplate.queryForMap(averageSql);
			result = Double.parseDouble(map.get("num").toString());
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + averageSql);
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public double getAverageEddl(String date) throws Exception {
		double average = 0D;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select distinct(plan)*100 plan from  TERMINAL_CBBT_P where time_id=?";
			HashMap map = (HashMap)jdbcTemplate.queryForMap(sql, new Object[] { date });
			average = Double.parseDouble(map.get("plan").toString());
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql + "###参数为:"+date);
		}
		return average;
	}
	
	public List<Map<String, Object>> getDateEddl(String date) throws Exception{
		List<Map<String, Object>> result = null;
		String sql = null ;
		try {
			sql = "select b.area_name , a.sell_rate*100 sell_rate, a.cost_rate*100 cost_rate from  TERMINAL_CBBT_P a inner join mk.bt_area b on a.AREA_CODE=b.AREA_CODE where time_id=? and length(a.AREA_CODE)=5";
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			result = jdbcTemplate.queryForList(sql, new Object[] { date });
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql + "###参数为:"+date);
		}
		return result;
	}
	
	public List<Map<String, Object>> getDateChl(String date, String type, String cityId) throws Exception{
		List<Map<String, Object>> result = null ;
		String sql = "";
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			if(!"".equals(cityId) && cityId.equals("HB")){
				if(!"".equals(type) && type.equals("1")){
					sql = "select area_name, decimal(PO_RATE*100,16,2) po_rate ,decimal(PO_CYCLE_RATE*100,16,2) po_cycle_rate from  TERMINAL_CUANHUO_P a  inner join mk.bt_area b on a.AREA_ID=b.AREA_CODE where  TIME_ID=? and STATUS =1  order by 1";
				}else if(!"".equals(type) && type.equals("2")){
					sql = "select area_name, decimal(PI_RATE*100,16,2) po_rate,decimal(PI_CYCLE_RATE*100,16,2) po_cycle_rate from  TERMINAL_CUANHUO_P a  inner join mk.bt_area b on a.AREA_ID=b.AREA_CODE where  TIME_ID=? and STATUS =1 order by 1";
				}
				result = jdbcTemplate.queryForList(sql, new Object[] { date });
			}else{
				if(!"".equals(type) && type.equals("1")){
					sql = "select b.COUNTY_NAME area_name, decimal(po_rate*100,16,2) po_rate, decimal(po_cycle_rate*100,16,2) po_cycle_rate from (select * from  TERMINAL_CUANHUO_P where STATUS =3 )a left join MK.BT_AREA_ALL_VIEW b on a.AREA_ID=b.COUNTY_CODE where time_id=? and subStr(a.AREA_ID,1,5)=? order by 1";
				}else if(!"".equals(type) && type.equals("2")){
					sql = "select b.COUNTY_NAME area_name, decimal(Pi_RATE*100,16,2) po_rate, decimal(Pi_CYCLE_RATE*100,16,2) po_cycle_rate from (select * from  TERMINAL_CUANHUO_P where STATUS =3 )a left join MK.BT_AREA_ALL_VIEW b on a.AREA_ID=b.COUNTY_CODE where time_id=? and subStr(a.area_id,1,5)=? order by 1";
				}
				result = jdbcTemplate.queryForList(sql, new Object[] { date, cityId });
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql + "###参数为:"+date+"::"+cityId);
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public String getMaxTime() throws Exception{
		String result = null;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select max(time_id) time_id from terminal_demo_1";
			Map map = jdbcTemplate.queryForMap("select max(time_id) time_id from terminal_demo_1");
			result = map.get("time_id").toString();
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public String getMaxIndexTime() throws Exception {
		String result = null;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
			sql = "select max(time_id) time_id from report_total_ter_m where report_code='Terminal_Index'";
			Map map = jdbcTemplate.queryForMap(sql);
			result = map.get("time_id").toString();
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public String getMaxAfterTime() throws Exception {
		String result = null;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select max(time_id) time_id from terminal_demo_3";
			Map map = jdbcTemplate
					.queryForMap("select max(time_id) time_id from terminal_demo_3");
			result = map.get("time_id").toString();
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public String getMaxSalingTime() throws Exception {
		String result = null;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			Map map = jdbcTemplate
					.queryForMap("select max(time_id) time_id from terminal_demo_2");
			result = map.get("time_id").toString();
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return result;
	}
	
	public List<Map<String,Object>> getTopList(String time, String cityId) throws Exception{
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List<Map<String,Object>> list = null;
		String sql = "select DIM2, RN, DIM2, RN, value(IND1,0) ind1, value(IND2,0) ind2, value(IND3,0) ind3,int(RN)+8 NUM from terminal_demo_1 where status=1 and dim1=? and time_id=?";
		try {
			list = jdbcTemplate.queryForList(sql, new Object[] {cityId, time});
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:"+sql +"##参数为:"+cityId+"::"+time);
		}
		return list;
	}
	
	private Double getStringToDouble(String string){
		if (string == null){
			return 0D;
		}else{
			Double result = 0D;
			try {
				result = Double.parseDouble(string);
			} catch (NumberFormatException e) {
				LOG.error(e.getMessage());
			}
			return result;
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map getTurnover(String time, String cityId, String type, int status)throws Exception{
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		Map map = new HashMap();
		String sql = "select ind1,ind2,ind3,ind4,ind5,alert from TERMINAL_DEMO_1 where time_id=? and dim1=? and dim2=? and status=? ";
		List list = null;
		try {
			list = jdbcTemplate.queryForList(sql, new Object[] {time, cityId, type, status});
		} catch (DataAccessException e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:"+sql+"##参数为:"+time+"::"+ cityId+"::"+ type+"::"+ status);
		}
		if(list!=null && list.size()>0){
			HashMap hashMap = (HashMap)list.get(0);
			double ind1 = getStringToDouble(hashMap.get("ind1")==null?"0":hashMap.get("ind1").toString());
			double ind2 = getStringToDouble(hashMap.get("ind2")==null?"0":hashMap.get("ind2").toString());
			double ind3 = getStringToDouble(hashMap.get("ind3")==null?"0":hashMap.get("ind3").toString());
			double ind4 = getStringToDouble(hashMap.get("ind4")==null?"0":hashMap.get("ind4").toString());
			double ind5 = getStringToDouble(hashMap.get("ind5")==null?"0":hashMap.get("ind5").toString());
			String alert = hashMap.get("alert")==null?"":hashMap.get("alert").toString();
			map.put("ind1", ind1);
			map.put("ind2", ind2);
			map.put("ind3", ind3);
			map.put("ind4", ind4);
			map.put("ind5", ind5);
			map.put("alert", alert);
		}else{
			map.put("ind1", "0");
			map.put("ind2", "0");
			map.put("ind3", "0");
			map.put("ind4", "0");
			map.put("ind5", "0");
			map.put("alert", "");
		}
		return map;
	}
	
	public List<Map<String,Object>> getWarningCity(String time, String cityId, String type, String status)throws Exception{
		List<Map<String,Object>> result = null;
		String sql = null ;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			result = jdbcTemplate.queryForList("select areaname from terminal_demo_1 inner join FPF_BT_AREA on dim2=areacode where time_id=? and dim1=? and dim3=? and status=? and alert='预警' order by ind3", new Object[] {time, cityId, type, status});
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql + "###参数为:"+time +"::"+ cityId +"::"+ type +"::"+ status);
		}
		return result;
	}
	
	public List<Map<String, Object>> getWarningType(String time, String cityId,String type, String status) throws Exception {
		List<Map<String, Object>> result = null;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select dim2 from terminal_demo_1 where time_id=? and dim1=? and dim3=? and status=? order by ind3";
			result = jdbcTemplate.queryForList(sql, new Object[] { time, cityId, type, status });
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql + "###参数为:" + time + "::"
					+ cityId + "::" + type + "::" + status);
		}
		return result;
	}
	
	public List<Map<String, Object>> getCityList() throws Exception {
		List<Map<String, Object>> result = null;
		String sql = null;
		try {
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		sql = "select key, value from (select area_id, area_code key,case when area_name='湖北' then '全省' else area_name end  value from mk.bt_area  union all select 0 cityId, 'HB' key, '全省' value from sysibm.sysdummy1) a order by 1";
		result = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return result;
	}
	
	public List<Map<String, Object>> getCityList(String cityId) throws Exception {
		List<Map<String, Object>> result = null;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select key, value from (select area_id, area_code key,case when area_name='湖北' then '全省' else area_name end  value from mk.bt_area  where area_code=?) a";
			result = jdbcTemplate.queryForList(sql, new Object[] {cityId});
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return result;
	}
	
	public List<Map<String, Object>> getInventory(String time, String cityId, String type, int status) throws Exception {
		List<Map<String, Object>> result = null;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			if("3".equals(status) && cityId.equals("HB")){
				sql = "select area_name DIM2,IND1/10000 IND1,value(IND3,0) ind3 from terminal_demo_1 inner join mk.bt_area on dim2=area_code where time_id=? and status=? and dim1=? and dim3=?";
			}else if("3".equals(status) && !"HB".equals(cityId)){
				sql = "select county_name DIM2,IND1/1000 IND1,value(IND3,0) ind3 from terminal_demo_1 inner join MK.BT_AREA_ALL_VIEW on dim2=county_code where time_id=? and status=? and dim1=? and dim3=?";
			}else{
				sql = "select DIM2,IND1/10000 IND1,value(IND3,0) ind3 from terminal_demo_1 where time_id=? and status=? and dim1=? and dim3=?";
			}
			result = jdbcTemplate.queryForList(sql, new Object[] {time, status, cityId, type});
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql +"###参数为:" + time + "::"
					+ status + "::" + cityId + "::" + type);
		}
		return result;
	}
	
	public List<Map<String, Object>> getUsing(String time, String cityId, String type, int status) throws Exception {
		List<Map<String, Object>> result = null;
		StringBuffer sql = new StringBuffer();
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql.append("select ind1/10000 ind1,ind2/10000 ind2,");
			if("1".equals(type)){
				sql.append(" ind3*100 ind3, ");
			}else if("2".equals(type)){
				sql.append(" ind4*100 ind3, ");
			}else if("3".equals(type)){
				sql.append(" ind5*100 ind3, ");
			}else if("4".equals(type)){
				sql.append(" ind6*100 ind3, ");
			}
			if(cityId.equals("HB")){
				sql.append("area_name from terminal_demo_3 inner join mk.bt_area on dim2=area_code ");
			}else{
				sql.append("county_name area_name from terminal_demo_3 inner join MK.BT_AREA_ALL_VIEW on dim2=county_code ");
			}
			sql.append("WHERE time_id=? and dim1=? and status=?");
			result = jdbcTemplate.queryForList(sql.toString(), new Object[] {time, cityId, status});
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql +"###参数为:" + time + "::"
					+ cityId + "::" + status);
		}
		return result;
	}
	
	public List<Map<String, Object>> AnalysisList(String time, String cityId, int status) throws Exception{
		List<Map<String, Object>> result = null;
		StringBuffer sql = new StringBuffer();
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql.append("select value(ind1,0) ind1,value(ind2,0) ind2,value(ind3,0)*100 ind3");
			if(cityId.equals("HB")){
				sql.append(",area_name from terminal_demo_3 inner join mk.bt_area on dim3=area_code ");
			}else{
				sql.append(",county_name area_name from terminal_demo_3 inner join MK.BT_AREA_ALL_VIEW on dim3=county_code ");
			}
			sql.append(" WHERE time_id=? and dim2=? and dim1='终端投入产出图' and status=?");
			result = jdbcTemplate.queryForList(sql.toString(), new Object[] {time, cityId, status});
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql +"###参数为:" + time + "::"
					+ cityId + "::" + status);
		}
		return result;
	}
	
	public List<Map<String, Object>> getWarningList(String cityId, String time, String status, String type) throws Exception{
		List<Map<String, Object>> result = null;
		StringBuffer sql = new StringBuffer();
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql.append("select ");
			if("HB".equals(cityId)){
				sql.append(" area_name ");
			}else{
				sql.append(" county_name ");
			}
			if("1".equals(type)){
				sql.append(" dim2,dim3 dim3,ind1*100 ind1 ");
			}else if("2".equals(type)){
				sql.append(" dim2,dim4 dim3,ind2*100 ind1 ");
			}else if("3".equals(type)){
				sql.append(" dim2,dim5 dim3,ind3*100 ind1 ");
			}else if("4".equals(type)){
				sql.append(" dim2,dim6 dim3,ind4*100 ind1 ");
			}
			sql.append(" from terminal_demo_3 inner join ");
			if("HB".equals(cityId)){
				sql.append(" mk.bt_area on dim2=area_code ");
			}else{
				sql.append(" MK.BT_AREA_ALL_VIEW on dim2=county_code ");
			}
			sql.append(" WHERE time_id=? and status=? and dim1=? ");
				if("1".equals(type)){
					sql.append(" order by ind5 ");
				}else if("2".equals(type)){
					sql.append(" order by ind6 desc ");
				}else if("3".equals(type)){
					sql.append(" order by ind7 desc ");
				}else if("4".equals(type)){
					sql.append(" order by ind8 desc ");
				}
			result = jdbcTemplate.queryForList(sql.toString(), new Object[] {time, status, cityId});
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql +"###参数为:" + time + "::"
					+ status + "::" + cityId);
		}
		return result;
	}
	
	public List<Map<String, Object>> getMarketingList(String cityId, String time, int status, String type, String type1) throws Exception{
		List<Map<String, Object>> result = null;
		StringBuffer sql = new StringBuffer();
		String str="";
		String str1="";
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql.append("select 31+(rn*3) rn1,31+(rn*3+1) rn2,31+(rn*3+2) rn3,dim3, ind1,value(ind2,0)*100 ind2 from terminal_demo_3 where dim1=? and time_id=? and status=? and dim2=?  and rn<6 order by rn");
			if("1".equals(type)){
				str = "激活率";
			}else if("2".equals(type)){
				str = "省内窜货率";
			}else if("3".equals(type)){
				str = "省际窜货率";
			}else if("4".equals(type)){
				str = "拆包率";
			}
			if("1".equals(type1)){
				str1 = "营销活动";
			}else if("2".equals(type1)){
				str1 = "终端型号";
			}else if("3".equals(type1)){
				str1 = "渠道";
			}
			result = jdbcTemplate.queryForList(sql.toString(), new Object[] {cityId, time, status, str1+str });
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql.toString() +"###参数为:" + cityId +"::"+time+ "::"
					+ status + "::" + (str1+str));
		}
		return result;
	}
	
	public Map<String,Double> getAnalysisMap(String cityId, String time, String status) throws Exception{
		String sql = "select ind1,ind2*100 ind2 from terminal_demo_3 where dim2='"+cityId+"' and time_id="+time+" and dim1='终端投入产出分析' and status="+status+" ";
		Map<String,Double> map = new HashMap<String,Double>();
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			List<Map<String,Object>> list = jdbcTemplate.queryForList(sql);
			if(list!=null && list.size()>0){
				Map<String,Object> hashMap = (Map<String,Object>)list.get(0);
				//double ind1 = getStringToDouble(hashMap.get("ind1")==null?"0":hashMap.get("ind1").toString());
				//double ind2 = getStringToDouble(hashMap.get("ind2")==null?"0":hashMap.get("ind1").toString());
				map.put("ind1", getStringToDouble(hashMap.get("ind1")==null?"0":hashMap.get("ind1").toString()));
				map.put("ind2", getStringToDouble(hashMap.get("ind2")==null?"0":hashMap.get("ind2").toString()));
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return map;
	}
	
	public List<Map<String, Object>> getSaleList(String status, String time, String type, String cityId) throws Exception{
		List<Map<String, Object>> result = null ;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			String dim = "";
			if("1".equals(type)){
				dim="当月监控";
			}else if("2".equals(type)){
				dim="当年监控";
			}
			sql = "select value(site_name,'') channel_name,53+(rn*4) rn1, 53+(rn*4+1) rn2, 53+(rn*4+2) rn3, 53+(rn*4+3) rn4,value(int(ind1),0) ind1,value(int(ind2*100),0) ind2 from terminal_demo_2 left join nmk.res_site on dim3=site_id where dim2='"+cityId+"' and time_id="+time+" and dim1='"+dim+"' and status="+status+" and rn<6 order by rn ";
			result = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return result;
	}
	
	public List<Map<String,Object>> getChannelSaleList(String status, String time, String type, String cityId)throws Exception{
		String dim = "";
		if("1".equals(type)){
			dim="当月监控";
		}else if("2".equals(type)){
			dim="当年监控";
		}
		List<Map<String,Object>> list = null;
		String sql = "select dim3, 38+(rn*3) rn1, 38+(rn*3+1) rn2, 38+(rn*3+2) rn3, int(value(ind1,0)) ind1, int(value(ind2,0)*100) ind2 from terminal_demo_2 where dim2='"+cityId+"' and time_id="+time+" and dim1='"+dim+"' and status="+status+" and rn<6 order by rn ";
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql："+sql);
		}
		return list;
	}
	
	public Map<String,Object> getSaleByCityMap(String status, String time, String cityId) throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		String sql = "select value(ind1,0) ind1, value(ind2,0) ind2, value(ind3,0) ind3 from terminal_demo_2 WHERE status="+status+" AND time_id="+time+" and dim2='"+cityId+"'";
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			List<Map<String,Object>> list = jdbcTemplate.queryForList(sql);
			if(list!=null && list.size()>0){
				Map<String,Object> hashMap = (Map<String,Object>)list.get(0);
//			double ind1 = Double.parseDouble(hashMap.get("ind1").toString());
//			double ind2 = Double.parseDouble(hashMap.get("ind2").toString());
//			double ind3 = Double.parseDouble(hashMap.get("ind3").toString());
				map.put("ind1", getStringToDouble(hashMap.get("ind1")==null?"0":hashMap.get("ind1").toString()));
				map.put("ind2", getStringToDouble(hashMap.get("ind2")==null?"0":hashMap.get("ind2").toString()));
				map.put("ind3", getStringToDouble(hashMap.get("ind3")==null?"0":hashMap.get("ind3").toString()));
			}else{
				map.put("ind1", "-");
				map.put("ind2", "-");
				map.put("ind3", "-");
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql："+sql);
		}
		return map;
	}
	
	@SuppressWarnings("rawtypes")
	public double getIsValue(String status, String time, String type, String cityId, String type1) throws Exception{
		String sql = null;
		double value = 0D;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			String dim = "";
			if("1".equals(type)){
				dim="当月监控";
			}else if("2".equals(type)){
				dim="当年监控";
			}
			sql = "select int(value(ind1,0)*100) ind1 from terminal_demo_2 WHERE status="+status+" AND time_id="+time+" AND dim1='"+dim+"' and dim3='"+cityId+"' and dim2='"+type1+"'";
			List list = jdbcTemplate.queryForList(sql);
			if(list!=null && list.size()>0){
				HashMap hashMap = (HashMap)list.get(0);
				value = Double.parseDouble(hashMap.get("ind1").toString());
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql："+sql);
		}
		return value;
	}
	
	public List<Map<String,Object>> getPaulInfoMap(String status, String time, String type, String cityId) throws Exception{
		List<Map<String,Object>> result = null;
		StringBuffer sql = new StringBuffer();
		try {
			String dim = "";
			if("1".equals(type)){
				dim="当月监控";
			}else if("2".equals(type)){
				dim="当年监控";
			}
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			
			sql.append("select ");
			if("HB".equals(cityId)){
				sql.append(" area_name ");
			}else{
				sql.append(" county_name ");
			}
			sql.append(" area_name,int(value(ind1,0)*100) ind1,int(value(ind2,0)*100) ind2,ind3 from terminal_demo_2 inner join ");
			if("HB".equals(cityId)){
				sql.append(" mk.bt_area on dim3=area_code ");
			}else{
				sql.append(" MK.BT_AREA_ALL_VIEW on dim3=county_code ");
			}
			sql.append(" where dim2='"+cityId+"' and time_id="+time+" and dim1='"+dim+"' and status="+status+"  ");
			result = jdbcTemplate.queryForList(sql.toString());
		} catch (DataAccessException e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql："+sql.toString());
		}
		return result;
	}
	
	public List<Map<String,Object>> getSalingListMap(String beginTime, String endTime, String cityId, String status, String type) throws Exception{
		List<Map<String,Object>> result = null;
		String sql = null;
		try {
			String dim = "";
			if("1".equals(type)){
				dim="当月监控";
			}else if("2".equals(type)){
				dim="当年监控";
			}
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select subStr(char(bigint(time_id)),7,8) time_id,decimal(value(ind1,0),16,1) ind1, decimal(value(ind2*100,0),16,1) ind2 from terminal_demo_2 where time_id>="+beginTime+" and time_id<="+endTime+" and status="+status+" and dim1='"+dim+"' and dim2='"+cityId+"' order by 1";
			result = jdbcTemplate.queryForList(sql.toString());
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql："+sql);
		}
		return result;
	}
	
	public List<Map<String,Object>> getSalingListMapByType(String times, String cityId, String status, String type) throws Exception{
		List<Map<String,Object>> result = null;
		String sql = null;
		try {
			String dim = "";
			if("1".equals(type)){
				dim="当月监控";
			}else if("2".equals(type)){
				dim="当年监控";
			}
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql = "select subStr(char(bigint(time_id)),5,2) time_id,decimal(value(ind1,0),16,1) ind1, decimal(value(ind2*100,0),16,1) ind2 from terminal_demo_2 where time_id in ("+times+") and status="+status+" and dim1='"+dim+"' and dim2='"+cityId+"' order by 1";
			result = jdbcTemplate.queryForList(sql.toString());
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql："+sql);
		}
		return result;
	}
	
	public List<Map<String,Object>> getSalingByCityListMap(String beginTime, String endTime, String cityId, String status, String type) throws Exception{
		List<Map<String,Object>> result = null;
		StringBuffer sql = new StringBuffer();
		try {
			String dim = "";
			if("1".equals(type)){
				dim="当月监控";
			}else if("2".equals(type)){
				dim="当年监控";
			}
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
			sql.append("select ");
			if("HB".equals(cityId)){
				sql.append(" area_name ");
			}else{
				sql.append(" county_name ");
			}
			sql.append(" area_name,decimal(value(ind1,0),16,1) ind1 from terminal_demo_2 inner join ");
			if("HB".equals(cityId)){
				sql.append(" mk.bt_area on dim3=area_code ");
			}else{
				sql.append(" MK.BT_AREA_ALL_VIEW_view on dim3=county_code ");
			}
			sql.append(" where time_id="+endTime+" and status="+status+" and dim1='"+dim+"' and dim2='"+cityId+"'");
			result = jdbcTemplate.queryForList(sql.toString());
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql："+sql.toString());
		}
		return result;
	}
	
	public List<Map<String,Object>> getMenuList(String menuitemid)throws Exception{
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "select menuitemid id,menuitemtitle name,sortnum sort,url type from FPF_SYS_MENU_ITEM where (parentid="+menuitemid+") order by sort,id with ur";
		List<Map<String,Object>> list = null ;
		try {
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql："+sql);
		}
		return list;
	}
	
	public List<Map<String,Object>> getChildList(String id) throws Exception{
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "select id,name,type from (select char(a.sid) id,c.name name, 'report' type from FPF_IRS_SUBJECT_MENU_MAP a  inner join FPF_IRS_SUBJECT c on a.sid=c.id where mid="+id+" and c.status='在用' union all select a.url id,a.menuitemtitle name, 'url' type from FPF_SYS_MENU_ITEM a where parentid="+id+") aa ";
		List<Map<String,Object>> list = null ;
		try {
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql："+sql);
		}
		return list;
	}
	
	public List<Map<String,Object>> getIndexInfo(String cityid, String time)throws Exception{
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		StringBuffer sql = new StringBuffer();
		sql.append("select time_id,dim1,int(ind1) A1,int(ind2) A2,ind2/case when ind3/15=0 then null else ind3/15 end A3,int(ind22) A4,case when ind21=0 then 0 else decimal((ind22/ind21*100),16,2) end A5,int(ind23) A6,case when ind21=0 then 0 else decimal((ind23/ind21*100),16,2) end A7,int(ind24) A8,case when ind21=0 then 0 else decimal((ind24/ind21*100),16,2) end A9,int(ind4) B1,case when ind5=0 then 0 else decimal((ind4/ind5*100),16,2) end B2,case when ind4=0 then 0 else decimal(ind7/ind4*100,16,2) end B3,case when ind4=0 then 0 else decimal(ind8/ind4*100,16,2) end B31,case when ind4=0 then 0 else decimal(ind9/ind4*100,16,2) end B4,int(ind10) B6,case when ind20=0 then 0 else decimal(ind10/ind20*100,16,2) end B7,int(ind11) B8,case when ind6=0 then 0 else decimal(ind11/ind6*100,16,2) end B9, int(ind12) C4,int(ind13) C5,case when ind15=0 then 0 else decimal(ind14/ind15*100,16,2) end C1,case when ind16=0 then 0 else decimal((ind17-ind16)/ind16*100,16,2) end C3,case when ind18=0 then 0 else decimal((ind19-ind18)/ind18*100,16,2) end C2 from report_total_ter_m where report_code='Terminal_Index' and time_id="+time+" and dim1='"+cityid+"' ");
		List<Map<String,Object>> list = null;
		try {
			list = jdbcTemplate.queryForList(sql.toString());
		} catch (Exception e) {
			throw new Exception("错误sql:"+sql.toString());
		}
		return list;
	}
	
	public List<Map<String,Object>> getIndexInfo2(String cityid, String time)throws Exception{
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		StringBuffer sql = new StringBuffer();
		sql.append("select time_id,dim1,case when ind4=0 then 0 else decimal((ind1/ind4*100),16,2) end A10,case when ind4=0 then 0 else decimal((ind2/ind4*100),16,2) end A11,case when ind4=0 then 0 else decimal((ind3/ind4*100),16,2) end A12 from report_total_ter_m WHERE report_code = 'Terminal_Index_chl' and time_id="+time+" and dim1='"+cityid+"' ");
		List<Map<String,Object>> list = null;
		try {
			list = jdbcTemplate.queryForList(sql.toString());
		} catch (Exception e) {
			throw new Exception("错误sql:"+sql.toString());
		}
		return list;
	}
	
	public List<Map<String,Object>> getIndexInfoPreAndSal(String cityid, String time)throws Exception{
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		StringBuffer sql = new StringBuffer();
		sql.append("select time_id,int(ind21) A1,int(ind22) A2,int(ind23) A3,int(ind24) A4,int(ind13) A5,int(ind14) A6,int(ind15) A7,int(ind16) A8,case when ind17=0 then 0 else decimal((ind21/ind17*15)*100,16,2) end A9,case when ind18=0 then 0 else decimal((ind22/ind18*15)*100,16,2) end A10,case when ind19=0 then 0 else decimal((ind23/ind19*15)*100,16,2) end A11,case when ind20=0 then 0 else decimal((ind24/ind20*15)*100,16,2) end A12,int(ind5) B1,int(ind6) B2,int(ind7) B3,int(ind8) B4,int(ind25) B5,int(ind26) B6,int(ind27) B7,int(ind28) B8,case when ind5=0 then 0 else decimal((ind9/ind5)*100,16,2) end B9,case when ind6=0 then 0 else decimal((ind10/ind6)*100,16,2) end B10,case when ind7=0 then 0 else decimal((ind11/ind7)*100,16,2) end B11,case when ind8=0 then 0 else decimal((ind12/ind8)*100,16,2) end B12	from  terminal_index_total_d where model=1 and model_name='index1' and time_id="+time+" and dim1='"+cityid+"'");
		List<Map<String,Object>> list = null;
		try {
			list = jdbcTemplate.queryForList(sql.toString());
		} catch (Exception e) {
			throw new Exception("错误sql:"+sql.toString());
		}
		return list;
	}
	
	public List<Map<String,Object>> getIndexInfoAfter(String cityid, String time)throws Exception{
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		StringBuffer sql = new StringBuffer();
		sql.append("select time_id,int(ind1) C1,int(ind2) C2,int(ind3) C3,int(ind4) C4,int(ind5) C5,int(ind6) C6,int(ind7) C7,int(ind8) C8 from  terminal_index_total_d where model=1 and model_name='index2' and time_id="+time+" and dim1='"+cityid+"'");
		List<Map<String,Object>> list = null;
		try {
			list = jdbcTemplate.queryForList(sql.toString());
		} catch (Exception e) {
			throw new Exception("错误sql:"+sql.toString());
		}
		return list;
	}
	
	public List<Map<String,Object>> getSalAndOneSeason(String cityid, String time)throws Exception{
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		StringBuffer sql = new StringBuffer();
		sql.append("select decimal(ind1*100,16,2) B13,decimal(ind2*100,16,2) B14 from terminal_index_total_d where model=1 and model_name='index3' and time_id="+time+" and dim1='"+cityid+"'");
		List<Map<String,Object>> list = null;
		try {
			list = jdbcTemplate.queryForList(sql.toString());
		} catch (Exception e) {
			throw new Exception("错误sql:"+sql.toString());
		}
		return list;
	}
	
	public List<Map<String,Object>> getAfte2GChange(String cityid, String time)throws Exception{
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		StringBuffer sql = new StringBuffer();
		sql.append("select int(ind1) C9,int(ind2) C10 from terminal_index_total_d where model=1 and model_name='index4' and time_id="+time+" and dim1='"+cityid+"'");
		List<Map<String,Object>> list = null;
		try {
			list = jdbcTemplate.queryForList(sql.toString());
		} catch (Exception e) {
			throw new Exception("错误sql:"+sql.toString());
		}
		return list;
	}
	
	
	
	public List<Map<String,Object>> getChannelCode(String cityid)throws Exception{
		List<Map<String,Object>> list = null;
		String sql = "select distinct case when channel_type_code is null then 0 else channel_type_code end key, case when channel_type is null then '全部' else channel_type end value from terminal_index where area_code = '"+cityid+"' order by 1";
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			throw new Exception("错误sql:"+sql);
		}
		return list;
	}
	
	public List<Map<String,Object>> getRectimestampsale(String time)throws Exception{
		List<Map<String,Object>> list = null;
		String sql = "select distinct case when rectimestampsale is null then 0 else rectimestampsale end key, case when rectimestampsale is null then 20130531 else rectimestampsale end value from terminal_index where stat_month="+time+" order by 1";
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			throw new Exception("错误sql:"+sql);
		}
		return list;
	}
	
	public List<Map<String,Object>> getTime()throws Exception{
		List<Map<String,Object>> list = null;
		String sql = "select distinct time_id key, time_id value from report_total_ter_m where report_code='Terminal_Index' order by 1 desc";
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			throw new Exception("错误sql:"+sql);
		}
		return list;
	}
	
	public List<Map<String,Object>> getTimeWithDay()throws Exception{
		List<Map<String,Object>> list = null;
		String sql = "select distinct time_id key, time_id value from terminal_index_total_d where model=1 order by 1 desc";
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			throw new Exception("错误sql:"+sql);
		}
		return list;
	}
	
	@SuppressWarnings("rawtypes")
	public String getMaxTimeIndexDay() throws Exception {
		String result = null;
		String sql = null;
		try {
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
			sql = "select max(time_id) time_id from terminal_index_total_d where model=1";
			Map map = jdbcTemplate.queryForMap(sql);
			result = map.get("time_id").toString();
		} catch (Exception e) {
			LOG.error(e.getMessage());
			throw new Exception("错误sql:" + sql);
		}
		return result;
	}
}