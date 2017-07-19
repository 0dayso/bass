package com.asiainfo.hb.power.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.power.models.MenuManageDao;


/**
 * 
 * @author lify
 * @date 2016-08-12
 *
 */
@Service
public class MenuManageService {
	@Autowired
	MenuManageDao dao;
	
	public List<Map<String, Object>> queryAllMenuByMenuTab(String tableName){

		return dao.queryAllMenuByMenuTab(tableName);
	}

	public int createNewMenuId(String tablename) {
		
		return dao.createNewMenuId(tablename);
	}

	public Map<String,Object> queryMenuByMenuId(String menuId,String menuTable) {
		
		Map<String,Object> map = dao.queryMenuByMenuId(menuId,menuTable);
	    if (map == null) return null;
	    return map;
	}

	@SuppressWarnings("rawtypes")
	public List queryMenus(String sysCode,String menuTable) {
		
		return dao.queryMenus(sysCode,menuTable);
	}

	public Map<String,Object> queryMenuByMenuId(int menuId,String menuTable) {
		
		Map<String,Object> map = dao.queryMenuByMenuId(menuId,menuTable);
		    if (map == null) return null;
		    return map;
	}

	public int queryMaxSortNumByPid(int pid, String tableName) {
		
		return dao.queryMaxSortNumByPid(pid,tableName);
	}

	public void addMenu(int menuId, int pid, int sortNum,
			String menuItemTitle, int menutype, String tableName) {
		
		 dao.addMenu(menuId, pid, sortNum, menuItemTitle, menutype, tableName);
		
	}

	public void modifyMenuTitle(String menuItemTitle, String menuId, String tableName) {
		
		dao.modifyMenuTitle(menuItemTitle, menuId,tableName);
	}

	public void delMenuAndRoleMenuByMenuId(int menuId, String menuTable) {
		
		dao.delMenuAndRoleMenuByMenuId(menuId,menuTable);
		dao.delMenuAndRoleMenuBypId(menuId,menuTable);
	}

	public void updateMenu(int menuId, int pid, String menuItemTitle,
			int sortNum, String url, String pic1,int status, String menutype, String power,String table) {
		
		dao.updateMenu(menuId, pid,menuItemTitle,sortNum,url, pic1,status,menutype,power,table);
	}
	
	/**
	 * 添加菜单
	 * @param menuId
	 * @param pid
	 * @param menuItemTitle
	 * @param sortNum
	 * @param url
	 * @param pic1
	 * @param status
	 * @param menutype
	 * @param power
	 * @param table
	 */
	public void insertMenu(int menuId, int pid, String menuItemTitle,
			int sortNum, String url, String pic1,int status, String menutype, String power,String table) {
		
		dao.insertMenu(menuId, pid,menuItemTitle,sortNum,url, pic1,status,menutype,power,table);
	}
}
