package com.asiainfo.hb.power.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.core.models.BaseDao;

@Repository
public class PowerDao extends BaseDao{
	
	public Logger logger = LoggerFactory.getLogger(PowerDao.class);
	
	 @Resource(name="jdbcTemplateN")
	  private NamedParameterJdbcTemplate pjdbcTemplate;
	 
	 
	 public List<Map<String,Object>> getUserPower(String userid){
		 logger.debug("getUserPower------------------------------>");
		 List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		 String _sql = "select menuid ,'Y,Y,Y,Y' power from FPF_USER_GROUP_MAP a,user_items_map b where a.group_id=b.roleid and userid=?";
		 try {
			list = jdbcTemplate.queryForList(_sql, new Object[]{userid});
			 for (int i = 0; i < list.size(); i++) {
				Map<String,Object> map = list.get(i);
				String power = map.get("power").toString();
				Map<String,String> powerMap = changeStrToMapCon(power);
				map.put("power", powerMap);
				list.set(i, map);
			}
		} catch (DataAccessException e) {
		
			e.printStackTrace();
		}
		 return list;
	 }
	 
	 public Map<String,Object> getUserPower(String userid,String menuid){
		 logger.debug("getUserPower------------------------------>");
		 Map<String,Object> map = new HashMap<String,Object>();
		 String _sql = "select menuid,'Y,Y,Y,N' power from FPF_USER_GROUP_MAP a,user_items_map b where a.group_id=b.roleid and userid=? and menuid=?";
		 try {
			map=jdbcTemplate.queryForMap(_sql, new Object[]{userid,menuid});
			 String power = map.get("power").toString();
			 Map<String,String> powerMap = changeStrToMapCon(power);
			 map.put("power", powerMap);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 return map;
	 }
	 
	 public Map<String,String> changeStrToMapCon(String power){
		 logger.debug("changeStrToMapCon------------------------------>");
		 Map<String,String> map = new HashMap<String, String>();
		 String[] powers = power.split(",");
		 map.put("add", powers[0]);
		 map.put("delete", powers[1]);
		 map.put("edit", powers[2]);
		 map.put("select", powers[3]);
		 return map;
	 }
	 
}
