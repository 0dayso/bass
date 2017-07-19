package com.asiainfo.hb.power.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.power.models.RoleDao;

@Service
public class RoleService {

	@Autowired
	RoleDao dao;

	public List<Map<String, Object>> queryRole(String roleName, int indexNum, int pageSize) {
		return dao.queryRole(roleName, indexNum, pageSize);
	}

	public int getRoleCount(String roleName) {
		return dao.getRoleCount(roleName);
	}

	public int add(String roleName) {
		return dao.add(roleName);
	}

	public void update(String roleId, String roleName) {
		dao.update(roleId, roleName);
	}

	public void delete(String id) {
		dao.delete(id);
	}

	public void batchDelete(String ids) {
		dao.batchDelete(ids);
	}
	
	public List<Map<String, Object>> getMenuList(String roleId, String menuName){
		return dao.getMenuList(roleId, menuName);
	}
	
	public List<Map<String, Object>> getConnectGroup(String roleId, String groupName){
		return dao.getConnectGroup(roleId, groupName);
	}
	
	public void delGroup(String roleId, String groupIds){
		dao.delGroup(roleId, groupIds);
	}
	
	public void addGroup(String roleId, String groupId){
		dao.addGroup(roleId, groupId);
	}
	
	public List<Map<String, Object>> getUbConnectGroup(String roleId, String groupName){
		return dao.getUbConnectGroup(roleId, groupName);
	}

	public List<Map<String, Object>> getConnectMenu(String roleId,
			String menuName) {
		
		return dao.getConnectMenu(roleId,menuName);
	}

	public void addMenus(String roleId, String menuId) {
		
		dao.addMenus(roleId,menuId);
	}

	public void delMenus(String roleId, String menuIds) {
		
		dao.delMenu(roleId,menuIds);
	}

	public List<Map<String, Object>> getUbConnectMenu(String roleId,
			String menuName) {
		
		return dao.getUbConnectMenu( roleId,menuName);
	}
}
