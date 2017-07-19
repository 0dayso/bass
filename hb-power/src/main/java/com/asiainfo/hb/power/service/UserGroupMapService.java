package com.asiainfo.hb.power.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.power.models.UserGroupMapDao;


/**
 * 
 * @author lify
 * @date 2016-08-22
 *
 */
@Service
public class UserGroupMapService {
	@Autowired
	UserGroupMapDao dao;
	
	public List<Map<String,Object>> getUserInfoNoInGroupid(String userid,String username,String groupid,String cityid){
		return dao.getUserInfoNoInGroupid(userid, username, groupid,cityid);
	}
	
	public List<Map<String,Object>> getUserInfoNoInRoleid(String userid,String username,String groupid,String cityid){
		return dao.getUserInfoNoInRoleid(userid, username, groupid,cityid);
	}
	
	
	public boolean addUserGroupMap(String userId, String groupId) {
		
		return dao.addUserGroupMap(userId, groupId);
	}
	
	public boolean addUserGroupMap(String[] userId, String groupId) {
		
		return dao.addUserGroupMap(userId, groupId);
	}
	
	public List<Map<String,Object>> getUserInfoBygroupID(String groupid,String userid,String username,String cityid){
		return dao.getUserInfoBygroupID(groupid, userid, username, cityid);
	}
	
	 public boolean deleteUserGroupMapbyId(String groupId,List<String> userid){
		return dao.deleteUserGroupMapbyId(groupId, userid);
	 }
	 
	 public boolean updateUserGroupMap(String oldGroupId,String newGroupId,String userId){
		 return dao.updateUserGroupMap(oldGroupId, newGroupId, userId);
	 }
	 
	 public List<Map<String, Object>> getConnectUserGroup(String userId, String groupName){
		 return dao.getConnectUserGroup(userId, groupName);
	 }
	 
	 public List<Map<String, Object>> getUnconnectUserGroup(String userId, String groupName){
		 return dao.getUnconnectUserGroup(userId, groupName);
	 }
	 
	 public void delUserGroup(String userId, String groupIds){
		 dao.delUserGroup(userId, groupIds);
	 }
	 
}
