package com.asiainfo.hb.power.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.power.models.UserTreeManageDao;


/**
 * 
 * @author lify
 * @date 2016-08-22
 *
 */
@Service
public class UserTreeManageService {
	@Autowired
	UserTreeManageDao dao;
	
	public Logger logger = LoggerFactory.getLogger(UserTreeManageService.class);
	
	public List<Map<String, Object>> queryAlltreeUser(){	
		return dao.queryAlltreeUser();
	}

	public boolean deleteTreeUserId(String menuId) {
		
		return dao.deleteUserGroupbyId(menuId);
	}

	public int createNewMenuId() {
		
		return dao.createNewGroupId();
	}

	@SuppressWarnings("rawtypes")
	public List queryMenus() {
		
		return dao.queryMenus();
	}

	public Map<String, Object> queryMenuByMenuId(String menuId) {
		logger.debug("queryMenuByMenuId");
		
		Map<String, Object> map = dao.getDetailUserGroupbygid(menuId);
		if(map==null) return null;
		return map;
	}

	public boolean addUserGroup(String groupId,String groupName,String parentId, int status,
			Date createTime,String beginDate,String endDate,int userlimit,int sortnum ){
		return dao.addUserGroup(groupId, groupName, parentId, status, createTime, beginDate, endDate, userlimit, sortnum);
	}

	public boolean updateUserGroup(String groupid, String groupname,String parentid, int status, String begindate,
			String enddate, int userlimit, int sortnum) {
		
		return dao.updateUserGroup(groupid, groupname, parentid, status, begindate, enddate, userlimit, sortnum);
		
	}
	
	public boolean updateUserGroupMap(String userId,String groupId,String oldGroupId) {
		
		return dao.updateUserGroupMap(userId, groupId, oldGroupId);
		
	}
	
	
	public List<Map<String,Object>> selectUserGroupbyParam(String groupName){
		return dao.selectUserGroupbyParam(groupName);
	}
	

	public boolean updateGroupName(String menuId, String menuItemTitle) {
		
		 return dao.updateGroupName( menuId,  menuItemTitle);
	}

	public List<Map<String, Object>> getConnectRole(String groupId, String roleName){
		return dao.getConnectRole(groupId, roleName);
	}
	
	public void delRole(String groupId, String roleIds){
		dao.delRole(groupId, roleIds);
	}
	
	public void addRole(String groupId, String roleId){
		dao.addRole(groupId, roleId);
	}
	
	public List<Map<String, Object>> getUnConnectRole(String groupId, String roleName){
		return dao.getUnConnectRole(groupId, roleName);
	}
}
