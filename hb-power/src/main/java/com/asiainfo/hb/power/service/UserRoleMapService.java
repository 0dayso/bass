package com.asiainfo.hb.power.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.power.models.UserRoleMapDao;

@Service
public class UserRoleMapService {

	@Autowired
	UserRoleMapDao dao;
	
	 public boolean userRoleMapEixt(String roleid,String userid){
		 boolean flag = false;
		 List<Map<String,Object>> list = dao.getUserRoleMap(roleid, userid);
		 if(list.size()>0){
			 flag = true;
		 }
		 return flag;
	 }
	 
	 public boolean insertUserAndroleMap(String[] roleid,String userid){
		 return dao.insertUserAndroleMap(roleid, userid);
	 }
	 
	 public boolean insertUserAndroleMap(String roleid,String userid[]){
		 return dao.insertUserAndroleMap(roleid, userid);
	 }
	 
	 public boolean bachDeleteUserAndRoleMap(List<Object> roleids,String userid){
		 return dao.bachDeleteUserAndRoleMap(roleids, userid);
	 }
	 
	 public boolean bachDeleteUserAndRoleMap(String roleid,List<Object> userids){
		 return dao.bachDeleteUserAndRoleMap(roleid, userids);
	 }
	 
	 public List<Map<String,Object>> getRoleListByUserId(String userid){
		 return dao.getRoleListByUserId(userid);
	 }
	 
	 public List<Map<String,Object>> getUserListByRoleId(String roleid){
		 return dao.getUserListByRoleId(roleid);
	 }
	 
	 public List<Map<String,Object>> getRoleGroupByParam(String roleid,String roleName, String userId){
		 return dao.getRoleGroupByParam(roleid, roleName, userId);
	 }

	public List<Map<String, Object>> getUserListByParam(String roleid,
			String userid, String username,String cityid) {
		
		return dao.getUserListByParam(roleid,userid,username,cityid);
	}
	
}
