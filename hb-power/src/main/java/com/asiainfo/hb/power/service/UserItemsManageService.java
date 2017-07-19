package com.asiainfo.hb.power.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.power.models.MenuManageDao;
import com.asiainfo.hb.power.models.UserItemsManageDao;


/**
 * 
 * @author zhaob
 * @date 2016-08-24
 *
 */
@SuppressWarnings("unused")
@Service
public class UserItemsManageService {
	@Autowired
	MenuManageDao menudao;
	@Autowired
	UserItemsManageDao uItemsdao ;
	@Autowired
	MenuManageService menuService;
	
	public Logger logger = LoggerFactory.getLogger(UserItemsManageService.class);
	//添加操作
//	public void addUserItems(int menuId, int groupId, String power) {
//		logger.debug("addUserItems");
//		uItemsdao.addUserItems(menuId, groupId, power);
//	}
	public boolean addUserItems(String menuId, String roleId, String power) {
		return uItemsdao.addUserItems(roleId,menuId,power);
	}
	
	public boolean addUserParentItems(String roleId, List<Map<String,Object>> list) {
		boolean flag = true;
		try {
			for (int i = 0; i < list.size(); i++) {
				Map<String,Object> map = list.get(i);
				String menuId = map.get("parentid").toString();
				Map<String,Object> menuMap =  menuService.queryMenuByMenuId(menuId, "FPF_SYS_MENU_ITEMS");
				if(menuMap==null) continue;
				String power = menuMap.get("power").toString();
				addUserItems(menuId, roleId, power);
			}
		} catch (Exception e) {
		
			e.printStackTrace();
			flag = false;
			return flag;
		}
		return flag;
	}
	
	//根据menuid查询操作
	public List<Map<String,Object>> getPowerbymenuid(int roleId,int menuId){
		 logger.debug("getPowerbymenuid");
		 List<Map<String,Object>> list=uItemsdao.getPowerbymenuid(roleId,menuId);
		 return list;
	 }
	//根据groupId查询操作
	 public List<Map<String,Object>> queryByGroupid(int groupId){
		return uItemsdao.queryByGroupid(groupId);
	}
	//修改操作
	public boolean updateByMenuid(int roleId,int menuId,String power){
		logger.debug("updateByMenuid");
		return uItemsdao.updateByMenuid(roleId,menuId, power);
	}
	
	//删除操作
	public boolean deletebypId(int roleId,int menuId){
		logger.debug("deletebypId");
		return uItemsdao.deletebypId(roleId,menuId);
	}
	
	/**
	 * 查看用户组和菜单是否关联
	 * @param roleId
	 * @param menuId
	 * @return
	 */
	public boolean roleIdItemExist(String roleId,String menuId){
		boolean flag = false;
		List<Map<String,Object>> list = uItemsdao.userItemMap(roleId,menuId);
		if(list.size()>0)
			flag = true;
		return flag;
	}
	
	/**
	 * 
	 * @param list 
	 * @param cid
	 * @return
	 */
	public List<Map<String,Object>> getAllParentItemsBycid(String cid){
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		uItemsdao.getAllParentItemsBycid(list, cid);
		return list;
	}
	
}
