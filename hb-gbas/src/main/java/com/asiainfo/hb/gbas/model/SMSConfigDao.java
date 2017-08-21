package com.asiainfo.hb.gbas.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Repository;

import com.asiainfo.hb.web.models.CommonDao;

@Repository
public class SMSConfigDao extends CommonDao {
	
	public Map<String, Object> getAlarmUserList(String name, String num, HttpServletRequest req){
		String pageSql = "select * from NWH.PROC_ALARM_USER where 1=1";
		String countSql = "select count(1) from NWH.PROC_ALARM_USER where 1=1";
		StringBuffer condition = new StringBuffer();
		if(isNotNull(name)){
			condition.append(" and user_name like '%").append(name).append("%' ");
		}
		if(isNotNull(num)){
			condition.append(" and acc_nbr like '%").append(num).append("%' ");
		}
		int[] pageParam = this.pageParam(req);
		return page(pageSql + condition.toString(), countSql + condition.toString(), pageParam[0], pageParam[1], "user_name");
	}
	
	public void addUser(String name, String num, String remark){
		String idSql = "select value(max(id),0) from NWH.PROC_ALARM_USER";
		int id = this.jdbcTemplate.queryForObject(idSql, Integer.class) + 1;
		String sql = "insert into NWH.PROC_ALARM_USER (id, user_name, acc_nbr, user_remark) values(?,?,?,?)";
		this.jdbcTemplate.update(sql, new Object[]{id, name, num, remark});
	}
	
	public void updateUser(String id, String name, String num, String remark){
		String sql = "update NWH.PROC_ALARM_USER set user_name=?, acc_nbr=?, user_remark=? where id=?";
		this.jdbcTemplate.update(sql, new Object[]{name, num, remark, id});
	}
	
	public void delUser(String ids){
		String sql = "delete from NWH.PROC_ALARM_USER where id in (" + ids + ")";
		this.jdbcTemplate.update(sql);
	}
	
	public List<Map<String, Object>> getAlarmGroup(String groupId, String groupName, String userName, String accNbr){
		StringBuffer condition = new StringBuffer();
		if(isNotNull(groupId)){
			condition.append(" and group_id like '%").append(groupId).append("%'");
		}
		if(isNotNull(groupName)){
			condition.append(" and group_remark like '%").append(groupName).append("%'");
		}
		if(isNotNull(userName)){
			condition.append(" and user_name like '%").append(userName).append("%'");
		}
		if(isNotNull(accNbr)){
			condition.append(" and acc_nbr like '%").append(accNbr).append("%'");
		}
		
		String sql = "select * from (select replace(group_id,' ','') id , max(group_remark) name, max(type) type,'' remark,'0' parentid " +
				" from nwh.PROC_ALARM  where 1=1 " + condition.toString() + 
				" group by group_id " +
				" union all " +
				" select replace(group_id,' ','') id , user_name, acc_nbr, user_remark ,replace(group_id,' ','') parentid from nwh.PROC_ALARM " +
				" where 1=1 " + condition.toString() + 
				" )" +
				" order by parentid desc";
		List<Map<String, Object>> list =  this.jdbcTemplate.queryForList(sql);
		List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();
		Map<String, List<Map<String, Object>>> temp = new HashMap<String, List<Map<String, Object>>>();
		for(Map<String, Object> map : list){
			if("0".equals((String) map.get("parentid"))){
				map.put("children", temp.get((String)map.get("id")));
				map.put("state", "closed");
				resList.add(map);
			}else{
				if(temp.containsKey((String) map.get("parentid"))){
					List<Map<String, Object>> child = temp.get((String) map.get("parentid"));
					child.add(map);
				}else{
					List<Map<String, Object>> arr = new ArrayList<Map<String, Object>>();
					arr.add(map);
					temp.put((String) map.get("parentid"), arr);
				}
			}
		}
		return resList;
	}
	
	public List<Map<String, Object>> getUserByGroupId(String groupId){
		String sql = "select user_name, user_remark, acc_nbr from nwh.proc_alarm where group_id=?";
		return this.jdbcTemplate.queryForList(sql, new Object[]{groupId});
	}
	
	public void addAlarmGroup(String groupId, String groupName, String type, String userIds){
		String sql = "insert into nwh.proc_alarm (group_id, group_remark, type,user_name, acc_nbr,user_remark)" +
				" select ?,?,?, user_name, acc_nbr, user_remark from  nwh.proc_alarm_user where id in (" + userIds + ")";
		this.jdbcTemplate.update(sql, new Object[]{groupId, groupName, type});
	}
	
	public void updateAlarmGroup(String groupId, String groupName, String type){
		String sql = "update nwh.proc_alarm set group_remark=?, type=? where group_id=?";
		this.jdbcTemplate.update(sql, new Object[]{groupName, type, groupId});
	}
	
	public void delAlartGroup(String groupId){
		String sql = "delete from nwh.proc_alarm where group_id=?";
		this.jdbcTemplate.update(sql, new Object[]{groupId});
	}
	
	public boolean checkGroupId(String groupId){
		String sql = "select * from nwh.proc_alarm where group_id=?";
		List<Map<String, Object>> list = this.jdbcTemplate.queryForList(sql, new Object[]{groupId});
		if(list != null && list.size() == 0){
			return true;
		}
		return false;
	}
	
	public List<Map<String, Object>> getNotInUserList(String userName, String num, String groupId){
		String sql = "select * from nwh.proc_alarm_user where acc_nbr not in (select acc_nbr from nwh.proc_alarm where group_id=?)";
		if(isNotNull(userName)){
			sql += " and user_name like '%" + userName + "%' ";
		}
		if(isNotNull(num)){
			sql += " and acc_nbr like '%" + num + "%'";
		}
		return this.jdbcTemplate.queryForList(sql, new Object[]{groupId});
	}
	
	public void delGroupUser(String groupId, String accNbrs){
		String sql = "delete from nwh.proc_alarm where group_id='" + groupId + "' and acc_nbr in (" + accNbrs + ")";
		this.jdbcTemplate.update(sql);
	}

}
