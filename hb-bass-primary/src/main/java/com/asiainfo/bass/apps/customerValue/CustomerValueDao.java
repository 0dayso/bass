package com.asiainfo.bass.apps.customerValue;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.PageSqlGen;


@Repository
public class  CustomerValueDao{
	
	 public Logger logger = LoggerFactory.getLogger(CustomerValueDao.class);
	
	@Autowired
	private DataSource dataSource;

	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSourceDw;

	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSourceNl;
	
	@Autowired
	private PageSqlGen pageSqlGen;
	
	public List<Map<String, Object>> getAreaList(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select area_id key,area_name value,area_code from (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) order by area_id");
	}
	
	public List<Map<String, Object>> getChannelList(){
		
		logger.debug("getChannelList");
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List<Map<String, Object>> list =new ArrayList<Map<String,Object>>();
		try {
			list=jdbcTemplate.queryForList("select distinct act_type key from nwh.user_value_act_type");
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}
	
	public void saveConfig(String city, String type, String username, String mobilephone){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		int id = jdbcTemplate.queryForObject("select max(id) from customer_value_config",Integer.class) + 1;
		jdbcTemplate.execute("insert into customer_value_config(id,city_id, type, username, mobilephone) values('" + id + "','"+city+"', '"+type+"', '"+username+"', '"+mobilephone+"')");
	}
	
	public void saveAssessConfig(String city, String type, String username, String mobilephone){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		int id = jdbcTemplate.queryForObject("select max(id) from customer_assess_config",Integer.class) + 1;
		jdbcTemplate.execute("insert into customer_assess_config(id, city_id, type, username, mobilephone) values('" + id +"','"+city+"', '"+type+"', '"+username+"', '"+mobilephone+"')");
	}
	
	public void deleteConfig(int id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.execute("delete from customer_value_config where id="+id+"");
	}
	
	public void deleteAssessConfig(int id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.execute("delete from customer_assess_config where id="+id+"");
	}
	
	public ArrayList<HashMap<String, String>> getReply(String fee_id, String time_id, String type, String area_code){
		ArrayList<HashMap<String, String>> result = new ArrayList<HashMap<String, String>>();
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List<Map<String, Object>> list = jdbcTemplate.queryForList("select id, REPLY_CONTENT,value(REPLY_LEVEL,'未评估') REPLY_LEVEL from customer_value_reply where fee_id='"+fee_id+"' and time_id='"+time_id+"' and area_code='"+area_code+"' and type='"+type+"' order by reply_dt");
		String content= "请在此处回复";
		String level = "";
		if(list.size()>0 && list!=null){
			for(int i=0;i<list.size();i++){
				Map<String, Object> map = (Map<String, Object>)list.get(i);
				content = map.get("REPLY_CONTENT").toString().trim();
				level = map.get("REPLY_LEVEL").toString().trim();
				String id = String.valueOf(map.get("ID")).trim();
				HashMap<String, String> hashMap = new HashMap<String, String>();
				hashMap.put("reply_content", content);
				hashMap.put("reply_level", level);
				hashMap.put("id", id);
				result.add(hashMap);
				if ((i == list.size() - 1) &&  (!("1".equals(level)))) {
					HashMap<String, String> hashmap = new HashMap<String, String>();
				    hashmap.put("reply_content", "请在此处回复");
				    hashmap.put("reply_level", "未评估");
				    result.add(hashmap);
			    }
			}
		}else{
			HashMap<String, String> hashMap = new HashMap<String, String>();
			hashMap.put("reply_content", content);
			hashMap.put("reply_level", level);
			result.add(hashMap);
		}
		return result;
	}
	
	public ArrayList<HashMap<String, String>> getReplyForWarning(String fee_id, String time_id, String type, String area_code){
		ArrayList<HashMap<String, String>> result = new ArrayList<HashMap<String, String>>();
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List<Map<String, Object>> list = jdbcTemplate.queryForList("select ID, REPLY_CONTENT,value(REPLY_LEVEL,'未评估') REPLY_LEVEL from customer_value_reply where fee_id='"+fee_id+"' and time_id='"+time_id+"' and area_code='"+area_code+"' and type='"+type+"' order by reply_dt");
		if(list.size()>0 && list!=null){
			for(int i=0;i<list.size();i++){
				Map<String, Object> map = (Map<String, Object>)list.get(i);
				String content = map.get("REPLY_CONTENT").toString().trim();
				String level = map.get("REPLY_LEVEL").toString().trim();
				String id = String.valueOf(map.get("ID")).trim();
				HashMap<String, String> hashMap = new HashMap<String, String>();
				hashMap.put("reply_content", content);
				hashMap.put("reply_level", level);
				hashMap.put("id", id);
				result.add(hashMap);
			}
		}
		return result;
	}
	
	public Map<String,Object> getActMap(String fee_id, String time_id, String area_code){
		Map<String,Object> result = new HashMap<String,Object>();
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List<Map<String,Object>> list = jdbcTemplate.queryForList("select a.time_id,b.act_type,a.fee_id,a.fee_name,c.area_name,a.area_code from NWH.USER_VALUE_ACT_ALERT_RESULT a inner join nwh.user_value_act_type b on a.fee_id=b.fee_id inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) c on a.area_code=c.area_code where a.time_id="+time_id+" and a.area_code='"+area_code+"' and a.fee_id='"+fee_id+"'");
		if(list!=null && list.size()>0){
			result = (Map<String,Object>)list.get(0);
		}
		return result;
	}
	
	public void addReply(String time_id, String area_code, String username, String fee_id, String fee_name, String type, String reply){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		int id = jdbcTemplate.queryForObject("select max(id) from customer_value_reply",Integer.class) + 1;
		jdbcTemplate.execute("insert into customer_value_reply(id,TIME_ID, AREA_CODE, USERNAME, FEE_ID, FEE_NAME, TYPE, REPLY_CONTENT) values('" + id + "','"+time_id+"', '"+area_code+"', '"+username+"', '"+fee_id+"', '"+fee_name+"', '"+type+"', '"+reply+"')");
	}
	
	public void replyLevel(String id, String reply_level){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		if("0".equals(reply_level)){
			jdbcTemplate.execute("update customer_value_reply set reply_level = '"+reply_level+"', state='0' where id="+Integer.parseInt(id));
		}else if("1".equals(reply_level)){
			jdbcTemplate.execute("update customer_value_reply set reply_level = '"+reply_level+"', state='1' where id="+Integer.parseInt(id));
		}
	}
	
	public List<Map<String,Object>> getList(String start_time, String end_time, String city, String zb_code){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "";
		if(!"".equals(end_time) && end_time!=null){
			sql = "select time_id,code_value value from nmk.market_all_view where code_id='"+zb_code+"' and city_code='"+city+"' and time_id between '"+start_time+"' and '"+end_time+"' order by time_id";
		}else{
			sql = "select time_id,code_value value from nmk.market_all_view where code_id='"+zb_code+"' and city_code='"+city+"' and time_id = '"+start_time+"'  order by time_id";
		}
		
		List<Map<String,Object>> list = jdbcTemplate.queryForList(sql);
		return list;
	}
	
	public Map<String, Object> getZbName(String zb_code){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List<Map<String,Object>> list = jdbcTemplate.queryForList("select code_name, unit from nmk.market_all_view where code_id='"+zb_code+"'");
		if(list!=null && list.size()>0){
			Map<String, Object> map = (Map<String,Object>)list.get(0);
			return map;
		}else{
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("CODE_NAME", "无此指标数据");
			map.put("UNIT", "无");
			return map;
		}
	}
	
	public String getMaxTime(String zb_code){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List<Map<String,Object>> list = jdbcTemplate.queryForList("select max(time_id) time_id from nmk.market_all_view where code_id='"+zb_code+"'");
		if(list!=null && list.size()>0){
			Map<String, Object> map = (Map<String,Object>)list.get(0);
			return String.valueOf(map.get("time_id"));
		}
		return null;
	}
	
	public Map<String, Object> getWarningInfo(String fee_id, String time_id, String type, String area_code){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "";
		if("1".equals(type)){
			sql = "select time_id, area_name, act_type, fee_id, fee_name from NWH.USER_VALUE_ACT_ALERT_RESULT a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code=b.area_code where time_id='"+time_id+"' and fee_id='"+fee_id+"' and a.area_code='"+area_code+"'";
		}else if("2".equals(type)){
			sql = "select time_id, area_name, act_type, fee_id, fee_name from NWH.USER_VALUE_ACT_PERFORMANCE_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code=b.area_code where time_id='"+time_id+"' and fee_id='"+fee_id+"' and a.area_code='"+area_code+"'";
		}else if("3".equals(type)){
			sql = "select time_id, area_name, channel_code fee_id,channel_name fee_name from nwh.user_value_channel_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code=b.area_code where time_id='"+time_id+"' and channel_code='"+fee_id+"' and a.area_code='"+area_code+"'";
		}else if("4".equals(type)){
			sql = "select time_id, area_name, nbilling_tid fee_id,nbilling_tname fee_name from nwh.user_value_nbilling_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code=b.area_code where time_id='"+time_id+"' and nbilling_tid='"+fee_id+"' and a.area_code='"+area_code+"'";
		}
		return jdbcTemplate.queryForMap(sql);
	}
	
	public List<Map<String, Object>> getSzyjList(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select count(*) count,b.area_name,c.mobilephone from nwh.user_value_act_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id,mobilephone from customer_value_config where type='1') c on b.area_id = c.city_id where time_id='"+time+"' group by b.area_name,c.mobilephone ");
	}
	
	public List<Map<String, Object>> getYxpgList(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select count(*) count,b.area_name,c.mobilephone from nwh.user_value_act_performance_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id,mobilephone from customer_value_config where type='2') c on b.area_id = c.city_id where time_id='"+time+"' group by b.area_name,c.mobilephone ");
	}
	
	public List<Map<String, Object>> getQdjkList(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select count(*) count,b.area_name,c.mobilephone from nwh.user_value_channel_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id,mobilephone from customer_value_config where type='3') c on b.area_id = c.city_id where time_id='"+time+"' group by b.area_name,c.mobilephone ");
	}
	
	public List<Map<String, Object>> getZfaList(String time){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select count(*) count,b.area_name,c.mobilephone from nwh.user_value_nbilling_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id,mobilephone from customer_value_config where type='4') c on b.area_id = c.city_id where time_id='"+time+"' group by b.area_name,c.mobilephone ");
	}
	
	public List<Map<String,Object>> getAreaListForMMS(String time, String type){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "";
		if("1".equals(type)){
			sql = "select b.area_name, a.fee_name, a.user_num,direct_cost_rate direct_cost_rate1, decimal(direct_cost_rate*100,10,2)||'%' direct_cost_rate,decimal(low_value_rate*100,10,2)||'%' low_value_rate,alert_total from nwh.user_value_act_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code where time_id='"+time+"' order by direct_cost_rate1 desc fetch first 10 rows only";
		}else if("2".equals(type)){
			sql = "select b.area_name, a.fee_name, a.user_num,direct_cost_rate direct_cost_rate1, decimal(direct_cost_rate*100,10,2)||'%' direct_cost_rate,decimal(low_value_rate*100,10,2)||'%' low_value_rate,alert_total from nwh.user_value_act_performance_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code where time_id='"+time+"' order by direct_cost_rate1 desc fetch first 10 rows only";
		}else if("3".equals(type)){
			sql = "select b.area_name, a.channel_name fee_name,direct_cost_rate direct_cost_rate1, a.user_num, decimal(direct_cost_rate*100,10,2)||'%' direct_cost_rate,decimal(low_value_rate*100,10,2)||'%' low_value_rate,alert_total from nwh.user_value_channel_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code where time_id='"+time+"' order by direct_cost_rate1 desc fetch first 10 rows only";
		}else if("4".equals(type)){
			sql = "select b.area_name, a.nbilling_tname fee_name,direct_cost_rate direct_cost_rate1, a.user_num, decimal(direct_cost_rate*100,10,2)||'%' direct_cost_rate,decimal(low_value_rate*100,10,2)||'%' low_value_rate,alert_total from nwh.user_value_nbilling_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code where time_id='"+time+"' order by direct_cost_rate1 desc fetch first 10 rows only";
		}
		return jdbcTemplate.queryForList(sql);
	}
	
//	public List getSzyjAreaListForMMS(String time){
//		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
//		return jdbcTemplate.queryForList("select a.area_code, c.mobilephone from nwh.user_value_act_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id,mobilephone from customer_value_config where type='1') c on b.area_id = c.city_id where time_id='201506' group by a.area_code, c.mobilephone");
//	}
//	
//	public List getYxpgAreaListForMMS(String time){
//		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
//		return jdbcTemplate.queryForList("select a.area_code, c.mobilephone from nwh.user_value_act_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id,mobilephone from customer_value_config where type='1') c on b.area_id = c.city_id where time_id='201506' group by a.area_code, c.mobilephone");
//	}
//
//	public List getZfaAreaListForMMS(String time){
//		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
//		return jdbcTemplate.queryForList("select a.area_code, c.mobilephone from nwh.user_value_act_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id,mobilephone from customer_value_config where type='1') c on b.area_id = c.city_id where time_id='201506' group by a.area_code, c.mobilephone");
//	}
//	
//	public List getQdjkAreaListForMMS(String time){
//		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
//		return jdbcTemplate.queryForList("select a.area_code, c.mobilephone from nwh.user_value_act_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id,mobilephone from customer_value_config where type='1') c on b.area_id = c.city_id where time_id='201506' group by a.area_code, c.mobilephone");
//	}
//	
//	public List getSzyjListForMMS(String time, String area_code){
//		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
//		return jdbcTemplate.queryForList("select b.area_name, a.fee_name, a.user_num, decimal(direct_cost_rate*100,10,2)||'%' direct_cost_rate,decimal(low_value_rate*100,10,2)||'%' low_value_rate,alert_total from nwh.user_value_act_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id from customer_value_config where type='1') c on b.area_id = c.city_id where time_id='"+time+"' and a.area_code= '"+area_code+"'");
//		
//	}
//	
//	public List getYxpgListForMMS(String time, String area_code){
//		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
//		return jdbcTemplate.queryForList("select b.area_name, a.fee_name, a.user_num, decimal(direct_cost_rate*100,10,2)||'%' direct_cost_rate,decimal(low_value_rate*100,10,2)||'%' low_value_rate,alert_total from nwh.user_value_act_performance_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id from customer_value_config where type='2') c on b.area_id = c.city_id where time_id='"+time+"' and a.area_code= '"+area_code+"'");
//		
//	}
//	
//	public List getZfaListForMMS(String time, String area_code){
//		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
//		return jdbcTemplate.queryForList("select b.area_name, a.channel_name fee_name, a.user_num, decimal(direct_cost_rate*100,10,2)||'%' direct_cost_rate,decimal(low_value_rate*100,10,2)||'%' low_value_rate,alert_total from nwh.user_value_channel_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id from customer_value_config where type='3') c on b.area_id = c.city_id where time_id='"+time+"' and a.area_code= '"+area_code+"'");
//		
//	}
//	
//	public List getQdjkListForMMS(String time, String area_code){
//		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
//		return jdbcTemplate.queryForList("select b.area_name, a.nbilling_tname, a.user_num, decimal(low_value_rate*100,10,2)||'%' low_value_rate,alert_total from nwh.user_value_nbilling_alert_result a inner join (select area_id,area_name,area_code from mk.bt_area union all values(0,'省公司','HB' )) b on a.area_code = b.area_code inner join (select city_id from customer_value_config where type='4') c on b.area_id = c.city_id where time_id='"+time+"' and a.area_code= '"+area_code+"'");
//		
//	}
	
	public List<Map<String,Object>> getParentList(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select id,code,name,parent_id,code_type,month_code,descript from nmk.kpi_org_config where parent_id='0' order by id");
	}
	
	public List<Map<String,Object>> getChildList(String parent_id){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select id,code,name,parent_id,code_type,month_code,value(descript,'') descript from nmk.kpi_org_config where parent_id='"+parent_id+"' order by id");
	}
	
	public Map<String, Object> getCodeInfo(String zb_code){
		Map<String, Object> result = new HashMap<String, Object>();
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		List<Map<String, Object>> codeMap = jdbcTemplate.queryForList("select ID, CODE, NAME, PARENT_ID, CODE_TYPE, value(MONTH_CODE,'') MONTH_CODE,DESCRIPT from NMK.KPI_ORG_CONFIG where code='"+zb_code+"'");
		List<Map<String, Object>> monthCodeMap = jdbcTemplate.queryForList("select ID, CODE, NAME, PARENT_ID, CODE_TYPE, value(MONTH_CODE,'') MONTH_CODE,DESCRIPT from NMK.KPI_ORG_CONFIG where month_code='"+zb_code+"'");
		if(codeMap!=null && codeMap.size()>0){
			result = (Map<String, Object>)codeMap.get(0);
			result.put("check", "1");
		}else{
			result = (Map<String, Object>)monthCodeMap.get(0);
			result.put("check", "2");
		}
		
		return result;
	}
	
	public List<Map<String, Object>> getListByGroupId(String groupId){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select mobilephone,email from FPF_USER_USER where username in (select user_name from nwh.proc_alarm where group_id = '"+groupId+"')");
	}
	
	//预警人列表查询
	public Map<String, Object> getCustUserList(String cityId, String userName, String type, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select id, city_id city, value(area_name,'省公司') area_name, ");
		strBuf.append("case when type='1' then '营销案(事中预警)' when type='2' then '营销案(绩效评估预警)' ");
		strBuf.append("when type='3' then '渠道监控预警'  when type='4' then '资费案预警' end type, ");
		strBuf.append("username, mobilephone from customer_value_config ");
		strBuf.append("left join mk.bt_area on city_id = area_id where 1 = 1 ");
		if(!StringUtils.isEmpty(cityId)){
			strBuf.append("and city_id ='").append(cityId).append("' ");
		}
		if(!StringUtils.isEmpty(userName)){
			strBuf.append("and username like '%").append(userName).append("%' ");
		}
		if(!StringUtils.isEmpty(type)){
			strBuf.append("and type ='").append(type).append("' ");
		}
		strBuf.append(" order by create_dt desc");
		return query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getCustValWarningList(String userName, String time, String channel, String status, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		Map<String, Object> map=new HashMap<String, Object>();
		strBuf.append("select a.time_id, a.area_code, b.area_name, a.act_type, a.fee_id fee_id, a.fee_name, d.username, "); 
		strBuf.append(" d.mobilephone, d.type, value(e.status, '未回复') status, e.reply_level "); 
		strBuf.append(" from NWH.USER_VALUE_ACT_ALERT_RESULT a ");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b ");
		strBuf.append(" on a.area_code = b.area_code ");
		strBuf.append(" inner join customer_value_config d on b.area_id = d.city_id ");
		strBuf.append(" left join (select * from (select a.fee_id, a.time_id, a.area_code,");
		strBuf.append(" case when a.REPLY_CONTENT is not null and  a.reply_level = '0' then '已驳回' ");
		strBuf.append(" when a.REPLY_CONTENT is not null and a.reply_level = '1' then '已归档' ");
		strBuf.append(" when a.REPLY_CONTENT is not null and a.reply_level is null then '待评估' ");
		strBuf.append(" else '未回复' end status, ");
		strBuf.append(" a.reply_level,row_number() over(partition by fee_id,time_id,area_code order by reply_dt desc) rn ");
		strBuf.append(" from customer_value_reply a) where rn = 1) e ");
		strBuf.append(" on a.fee_id = e.fee_id and a.time_id = e.time_id and a.area_code = e.area_code where d.type = '1' ");
		strBuf.append(" and d.username = '").append(userName).append("' ");
		if(!StringUtils.isEmpty(time)){
			strBuf.append(" and a.time_id = '").append(time).append("' ");
		}
		if(!StringUtils.isEmpty(channel)){
			strBuf.append(" and a.act_type = '").append(channel).append("' ");
		}
		if(!StringUtils.isEmpty(status)){
			strBuf.append(" and value(status,'未回复') = '").append(status).append("' ");
		}
		strBuf.append(" order by b.area_code, time_id,a.act_type desc");
		logger.info(strBuf.toString());
		try {
			map=this.query(strBuf.toString(), limitStr);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		return map;
	}
	
	public Map<String, Object> getWarningReply(String feeId, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.time_id, b.area_name, a.fee_id  fee_id, a.fee_name fee_name, a.act_type, a.low_value_rate,");
		strBuf.append(" a.income, a.cost, a.direct_income, a.direct_cost, a.direct_cost_rate, a.soc_chl_reward,");
		strBuf.append(" a.term_cost, a.gift_cost, a.score_cost, a.bad_debt_cost,");
		strBuf.append(" a.direct_cost-a.soc_chl_reward-a.term_cost-a.gift_cost-a.score_cost-a.bad_debt_cost other_cost,");
		strBuf.append(" c.reply_content ");
		strBuf.append(" from nwh.user_value_act_alert_result a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code");
		strBuf.append(" left join (select * from (select row_number() over(partition by fee_id order by reply_dt desc) rn,");
		strBuf.append(" fee_id, reply_content, time_id, area_code from customer_value_reply) where rn = 1) c ");
		strBuf.append(" on a.fee_id = c.fee_id and a.time_id = c.time_id and a.area_code = c.area_code ");
		strBuf.append(" where a.fee_id = '").append(feeId).append("' ");
		strBuf.append(" order by time_id desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getAccessForWarningInfo(String userName, String time, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.id, a.time_id, a.area_code, b.area_name, a.username, a.fee_id, a.fee_name, a.reply_dt, ");
		strBuf.append(" case when a.reply_level = '1' then '通过' when a.reply_level = '0' then '不通过' else '未审核' end reply_level ");
		strBuf.append(" from (select * from (select id, a.fee_id, a.time_id, a.area_code, a.type, a.username, a.fee_name, ");
		strBuf.append(" a.reply_dt, a.reply_level, row_number() over(partition by fee_id,time_id,area_code order by reply_dt desc) rn "); 
		strBuf.append(" from customer_value_reply a) where rn = 1) a ");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b ");  
		strBuf.append(" on a.area_code = b.area_code "); 
		strBuf.append(" inner join (select username, city_id from customer_assess_config ");
		strBuf.append(" where username='").append(userName).append("' ");
		strBuf.append(" and type='1') c on c.city_id=b.area_id where a.type = '1' ");
		if(!StringUtils.isEmpty(time)){
			strBuf.append(" and a.time_id =").append(time);
		}
		strBuf.append(" order by b.area_code, time_id, a.reply_dt desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getWarningForAccessInfo(String feeId, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.time_id, b.area_name, a.fee_id fee_id, a.fee_name fee_name, a.act_type, a.low_value_rate,");
		strBuf.append(" a.income, a.cost, a.direct_income, a.direct_cost, a.direct_cost_rate, a.soc_chl_reward,");
		strBuf.append(" a.term_cost, a.gift_cost, a.score_cost, a.bad_debt_cost,");
		strBuf.append(" a.direct_cost-a.soc_chl_reward-a.term_cost-a.gift_cost-a.score_cost-a.bad_debt_cost other_cost,");
		strBuf.append(" c.reply_content");
		strBuf.append(" from nwh.user_value_act_alert_result a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code");
		strBuf.append(" left join (select * from (select row_number() over(partition by fee_id order by reply_dt desc) rn,");
		strBuf.append(" fee_id, reply_content, time_id, area_code from customer_value_reply) where rn = 1) c");
		strBuf.append(" on a.fee_id = c.fee_id and a.time_id = c.time_id and a.area_code = c.area_code ");
		strBuf.append(" where a.fee_id = '").append(feeId).append("'");
		strBuf.append(" order by time_id desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getWarningForJXPGInfo(String userName, String time, String channel, String status, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.time_id, a.area_code, b.area_name, a.act_type, a.fee_id fee_id, a.fee_name,");
		strBuf.append(" d.username, d.mobilephone, d.type, value(e.status, '未回复') status, e.reply_level");
		strBuf.append(" from NWH.user_value_act_performance_result a ");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code ");
		strBuf.append(" inner join customer_value_config d on b.area_id = d.city_id");
		strBuf.append(" left join (select * from (select a.fee_id, a.time_id, a.area_code,");
		strBuf.append(" case when a.REPLY_CONTENT is not null and a.reply_level = '0' then '已驳回'");
		strBuf.append(" when a.REPLY_CONTENT is not null and a.reply_level = '1' then '已归档'");
		strBuf.append(" when a.REPLY_CONTENT is not null and a.reply_level is null then '待评估' else '未回复' end status,");
		strBuf.append(" a.reply_level,");
		strBuf.append(" row_number() over(partition by fee_id,time_id,area_code order by reply_dt desc) rn");
		strBuf.append(" from customer_value_reply a) where rn = 1) e");
		strBuf.append(" on a.fee_id = e.fee_id and a.time_id = e.time_id and a.area_code = e.area_code");
		strBuf.append(" where d.type = '2'");
		strBuf.append(" and d.username = '").append(userName).append("'");
		if(!StringUtils.isEmpty(time)){
			strBuf.append(" and a.time_id = '").append(time).append("' ");
		}
		if(!StringUtils.isEmpty(channel)){
			strBuf.append(" and a.act_type = '").append(channel).append("' ");
		}
		if(!StringUtils.isEmpty(status)){
			strBuf.append(" and value(status,'未回复') = '").append(status).append("' ");
		}
		strBuf.append(" order by b.area_code, time_id,a.act_type desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getReplyForWarningForJXPGInfo(String feeId, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.time_id, b.area_name, a.fee_id fee_id, a.fee_name fee_name, a.act_type,");
		strBuf.append(" a.outnet_rate, a.zero_rate, a.low_value_rate, a.owe_rate, a.income, a.cost, a.direct_income,");
		strBuf.append(" a.direct_cost, a.direct_cost_rate, a.user_feedback_rate, a.soc_chl_reward, a.term_cost,");
		strBuf.append(" a.gift_cost, a.score_cost, a.bad_debt_cost,");
		strBuf.append(" a.direct_cost-a.soc_chl_reward-a.term_cost-a.gift_cost-a.score_cost-a.bad_debt_cost other_cost,");
		strBuf.append(" c.reply_content");
		strBuf.append(" from nwh.user_value_act_performance_result a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code");
		strBuf.append(" left join (select * from (select row_number() over(partition by fee_id order by reply_dt desc) rn,");
		strBuf.append(" fee_id, reply_content, time_id, area_code from customer_value_reply) where rn = 1) c");
		strBuf.append(" on a.fee_id = c.fee_id and a.time_id = c.time_id and a.area_code = c.area_code");
		strBuf.append(" where a.fee_id = '").append(feeId).append("'");
		strBuf.append(" order by time_id desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getAccessForWarningForJXPGInfo(String time, String userName, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.id, a.time_id, a.area_code, b.area_name, a.username, a.fee_id, a.reply_dt, a.fee_name,");
		strBuf.append(" case when a.reply_level = '1' then '通过' when a.reply_level = '0' then '不通过' else '未审核' end reply_level");
		strBuf.append(" from (select * from (select id, a.fee_id, a.time_id, a.area_code, a.type, a.username, a.fee_name, a.reply_dt, a.reply_level,");
		strBuf.append(" row_number() over(partition by fee_id,time_id,area_code order by reply_dt desc) rn");
		strBuf.append(" from customer_value_reply a) where rn = 1) a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code ");
		strBuf.append(" inner join (select username, city_id from customer_assess_config ");
		strBuf.append(" where username='").append(userName).append("' and type='2') c");
		strBuf.append(" on c.city_id=b.area_id where a.type = '2' ");
		if(!StringUtils.isEmpty(time)){
			strBuf.append(" and a.time_id =").append(time);
		}
		strBuf.append(" order by b.area_code, time_id, a.reply_dt desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getWarningForAssessForJXPGInfo(String feeId, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.time_id, b.area_name, a.fee_id fee_id, a.fee_name fee_name, a.act_type, a.outnet_rate, a.zero_rate,");
		strBuf.append(" a.low_value_rate, a.owe_rate, a.income, a.cost, a.direct_income, a.direct_cost, a.direct_cost_rate,");
		strBuf.append(" a.user_feedback_rate, a.soc_chl_reward, a.term_cost, a.gift_cost, a.score_cost, a.bad_debt_cost,");
		strBuf.append(" a.direct_cost-a.soc_chl_reward-a.term_cost-a.gift_cost-a.score_cost-a.bad_debt_cost other_cost,");
		strBuf.append(" c.reply_content");
		strBuf.append(" from nwh.user_value_act_performance_result a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code");
		strBuf.append(" left join (select * from (select row_number() over(partition by fee_id order by reply_dt desc) rn,");
		strBuf.append(" fee_id, reply_content, time_id, area_code from customer_value_reply) where rn = 1) c");
		strBuf.append(" on a.fee_id = c.fee_id and a.time_id = c.time_id and a.area_code = c.area_code");
		strBuf.append(" where a.fee_id = '").append(feeId).append("' ");
		strBuf.append(" order by time_id desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getWarningListForQDKZ(String time, String channel, String status, String userName, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.time_id, a.area_code, b.area_name, a.channel_type act_type, a.channel_code fee_id,");
		strBuf.append(" a.channel_name fee_name, d.username, d.mobilephone, d.type, value(e.status, '未回复') status, e.reply_level");
		strBuf.append(" from NWH.USER_VALUE_CHANNEL_ALERT_result a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code");
		strBuf.append(" inner join customer_value_config d on b.area_id = d.city_id");
		strBuf.append(" left join (select * from (select a.fee_id, a.time_id, a.area_code,");
		strBuf.append(" case when a.REPLY_CONTENT is not null and a.reply_level = '0' then '已驳回'");
		strBuf.append(" when a.REPLY_CONTENT is not null and a.reply_level = '1' then '已归档'");
		strBuf.append(" when a.REPLY_CONTENT is not null and a.reply_level is null then '待评估' else '未回复' end status,");
		strBuf.append(" a.reply_level, row_number() over(partition by fee_id,time_id,area_code order by reply_dt desc) rn");
		strBuf.append(" from customer_value_reply a) where rn = 1) e");
		strBuf.append(" on a.channel_code = e.fee_id and a.time_id = e.time_id and a.area_code = e.area_code");
		strBuf.append(" where d.type = '3' and d.username = '").append(userName).append("'");
		if(!StringUtils.isEmpty(time)){
			strBuf.append(" and a.time_id = '").append(time).append("'");
		}
		if(!StringUtils.isEmpty(channel)){
			strBuf.append(" and a.channel_type ='").append(channel).append("'");
		}
		if(!StringUtils.isEmpty(status)){
			strBuf.append(" and value(status,'未回复') = '").append(status).append("'");
		}
		strBuf.append(" order by b.area_code, time_id,a.channel_type desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getReplyForWarningForQDKZ(String feeId, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.time_id, b.area_name, a.channel_code fee_id, a.channel_name fee_name, a.outnet_rate, a.zero_rate,"); 
		strBuf.append(" a.low_value_rate, a.owe_rate, a.mou, a.dou, a.income, a.cost, a.direct_income, "); 
		strBuf.append(" a.direct_cost, a.direct_cost_rate, a.soc_chl_reward, a.term_cost, a.gift_cost, a.score_cost, a.bad_debt_cost,");  
		strBuf.append(" a.other_cost, c.reply_content ");
		strBuf.append(" from nwh.user_value_channel_alert_result a ");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b ");
		strBuf.append(" on a.area_code = b.area_code ");
		strBuf.append(" left join (select * from (select row_number() over(partition by fee_id order by reply_dt desc) rn,");  
		strBuf.append(" fee_id, reply_content, time_id, area_code  from customer_value_reply) where rn = 1) c ");
		strBuf.append(" on a.channel_code = c.fee_id and a.time_id = c.time_id and a.area_code = c.area_code");
		strBuf.append(" where a.channel_code = '").append(feeId).append("'");
		strBuf.append(" order by time_id desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getAssessForWarningForQDKZ(String userName, String time, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.id, a.time_id, a.area_code, b.area_name, a.username, a.fee_id, a.fee_name, a.reply_dt,");
		strBuf.append(" case when a.reply_level = '1' then '通过' when a.reply_level = '0' then '不通过' else '未审核' end reply_level");
		strBuf.append(" from (select * from (select id, a.fee_id, a.time_id, a.area_code, a.type,");
		strBuf.append(" a.username, a.fee_name, a.reply_dt, a.reply_level,");
		strBuf.append(" row_number() over(partition by fee_id,time_id,area_code order by reply_dt desc) rn");
		strBuf.append(" from customer_value_reply a) where rn = 1) a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code");
		strBuf.append(" inner join (select username, city_id from customer_assess_config ");
		strBuf.append(" where username='").append(userName).append("' and type='3') c");
		strBuf.append(" on c.city_id=b.area_id where a.type = '3' ");
		if(!StringUtils.isEmpty(time)){
			strBuf.append(" and a.time_id =").append(time);
		}
		strBuf.append(" order by  b.area_code, time_id,a.reply_dt desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getWarningForAssessForQDKZ(String feeId, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.time_id, b.area_name, a.channel_code fee_id, a.channel_name fee_name, a.outnet_rate, a.zero_rate,");
		strBuf.append(" a.low_value_rate, a.owe_rate, a.mou, a.dou, a.income, a.cost, a.direct_income, a.direct_cost,");
		strBuf.append(" a.direct_cost_rate, a.soc_chl_reward, a.term_cost, a.gift_cost, a.score_cost, a.bad_debt_cost, a.other_cost, c.reply_content");
		strBuf.append(" from nwh.user_value_channel_alert_result a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b ");
		strBuf.append(" on a.area_code = b.area_code");
		strBuf.append(" left join (select * from (select row_number() over(partition by fee_id order by reply_dt desc) rn,");
		strBuf.append(" fee_id, reply_content, time_id, area_code from customer_value_reply) where rn = 1) c");
		strBuf.append(" on a.channel_code = c.fee_id and a.time_id = c.time_id and a.area_code = c.area_code");
		strBuf.append(" where a.channel_code = '").append(feeId).append("'");
		strBuf.append(" order by time_id desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getWarningListForZFA(String userName, String time, String status, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.time_id, a.area_code, b.area_name, a.nbilling_tid fee_id, a.nbilling_tname fee_name,");
		strBuf.append(" d.username, d.mobilephone, d.type, value(e.status, '未回复') status, e.reply_level");
		strBuf.append(" from nwh.user_value_nbilling_alert_result a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code");
		strBuf.append(" inner join customer_value_config d on b.area_id = d.city_id ");
		strBuf.append(" left join (select * from (select a.fee_id, a.time_id, a.area_code,");
		strBuf.append(" case when a.REPLY_CONTENT is not null and a.reply_level = '0' then '已驳回'");
		strBuf.append(" when a.REPLY_CONTENT is not null and a.reply_level = '1' then '已归档'");
		strBuf.append(" when a.REPLY_CONTENT is not null and a.reply_level is null then '待评估' else '未回复' end status,");
		strBuf.append(" a.reply_level, row_number() over(partition by fee_id,time_id,area_code order by reply_dt desc) rn");
		strBuf.append(" from customer_value_reply a) where rn = 1) e");
		strBuf.append(" on a.nbilling_tid = e.fee_id and a.time_id = e.time_id and a.area_code = e.area_code");
		strBuf.append(" where d.type = '4' and d.username = '").append(userName).append("'");
		if(!StringUtils.isEmpty(time)){
			strBuf.append(" and a.time_id = '").append(time).append("'");
		}
		if(!StringUtils.isEmpty(status)){
			strBuf.append(" and value(status,'未回复') = '").append(status).append("'");
		}
		strBuf.append(" order by b.area_code,time_id desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getReplyForWarningForZFA(String feeId, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append(" select a.time_id, b.area_name, a.nbilling_tid fee_id, a.nbilling_tname fee_name, a.outnet_rate, a.zero_rate, ");
		strBuf.append(" a.low_value_rate, a.owe_rate, a.mou, a.dou, a.income, a.cost, a.direct_income, a.direct_cost, a.direct_cost_rate,");
		strBuf.append(" a.stl_outnet_cost, a.stl_innet_cost, a.soc_chl_reward, a.term_cost,");
		strBuf.append(" a.gift_cost, a.score_cost, a.bad_debt_cost, a.other_cost, c.reply_content");
		strBuf.append(" from nwh.user_value_nbilling_alert_result a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code left join (select * from (select row_number() over(partition by fee_id order by reply_dt desc) rn,");
		strBuf.append(" fee_id, reply_content, time_id, area_code from customer_value_reply) where rn = 1) c");
		strBuf.append(" on a.nbilling_tid = c.fee_id and a.time_id = c.time_id and a.area_code = c.area_code");
		strBuf.append(" where a.nbilling_tid = '").append(feeId).append("'");
		strBuf.append(" order by time_id desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getAssessForWarningForZFA(String userName, String time, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.id, a.time_id, a.area_code, b.area_name, a.username, a.fee_id, a.fee_name, a.reply_dt,");
		strBuf.append(" case when a.reply_level = '1' then '通过' when a.reply_level = '0' then '不通过' else '未审核' end reply_level");
		strBuf.append(" from (select * from (select id, a.fee_id, a.time_id, a.area_code, a.type,");
		strBuf.append(" a.username, a.fee_name, a.reply_dt, a.reply_level,");
		strBuf.append(" row_number() over(partition by fee_id,time_id,area_code order by reply_dt desc) rn");
		strBuf.append(" from customer_value_reply a) where rn = 1) a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code");
		strBuf.append(" inner join (select username, city_id from customer_assess_config");
		strBuf.append(" where username='").append(userName).append("' and type='4') c");
		strBuf.append(" on c.city_id=b.area_id");
		strBuf.append(" where a.type = '4' ");
		if(!StringUtils.isEmpty(time)){
			strBuf.append(" and a.time_id = ").append(time);
		}
		strBuf.append(" order by  b.area_code, time_id,a.reply_dt desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	public Map<String, Object> getWarningForAssessForZFA(String feeId, String limitStr){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select a.time_id, b.area_name, a.nbilling_tid fee_id, a.nbilling_tname fee_name, a.outnet_rate, a.zero_rate,");
		strBuf.append(" a.low_value_rate, a.owe_rate, a.mou, a.dou, a.income, a.cost, a.direct_income, a.direct_cost, a.direct_cost_rate,");
		strBuf.append(" a.stl_outnet_cost, a.stl_innet_cost, a.soc_chl_reward, a.term_cost, a.gift_cost,");
		strBuf.append(" a.score_cost, a.bad_debt_cost, a.other_cost, c.reply_content");
		strBuf.append(" from nwh.user_value_nbilling_alert_result a");
		strBuf.append(" inner join (select area_id, area_name, area_code from mk.bt_area union all values(0, '省公司', 'HB')) b");
		strBuf.append(" on a.area_code = b.area_code");
		strBuf.append(" left join (select * from (select row_number() over(partition by fee_id order by reply_dt desc) rn,");
		strBuf.append(" fee_id, reply_content, time_id, area_code from customer_value_reply) where rn = 1) c");
		strBuf.append(" on a.nbilling_tid = c.fee_id and a.time_id = c.time_id and a.area_code = c.area_code");
		strBuf.append(" where a.nbilling_tid = '").append(feeId).append("'");
		strBuf.append(" order by time_id desc");
		return this.query(strBuf.toString(), limitStr);
	}
	
	private Map<String, Object> query(String sql, String limitStr){
		Map<String, Object> result = new HashMap<String, Object>();
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		int start = 1;
		int limit = 510;
		if (limitStr != null && limitStr.matches("[0-9]+")) {
			limit = Integer.parseInt(limitStr);
		}
		List<Map<String, Object>> data = jdbcTemplate.queryForList(pageSqlGen.getLimitSQL(sql, limit, start));
		int count = data.size();// 计数器
		// 2.超过极限说明数据没有查询完整，需要countSQL一下
		int total = 0;// .返回值，总的元素数量
		if (limit == count) {
			total = jdbcTemplate.queryForObject(pageSqlGen.getCountSQL(sql),Integer.class);
		}

		result.put("data", data);
		result.put("total", count > total ? count + start - 1 : total);
		result.put("start", start);
		return result;
	}
}
