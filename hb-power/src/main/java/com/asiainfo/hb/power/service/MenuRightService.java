package com.asiainfo.hb.power.service;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.asiainfo.hb.power.models.MenuRightDao;

/**
 * 
 * @author xiaoh
 *
 */
@Service
public class MenuRightService {

	@Autowired
	private MenuRightDao m_MenuRightDao;
	
	/**
	 * 查询所有菜单
	 * @return
	 */
	public List<Map<String, Object>> getMenuList(){
		return m_MenuRightDao.getMenuList();
	}
	
	/**
	 * 查询已绑定角色数量
	 * @param menuId
	 * @return
	 */
	public int getBindRoleCount(String menuId, String roleName){
		return m_MenuRightDao.getBindRoleCount(menuId, roleName);
	}
	
	/**
	 * 查询已绑定的角色
	 * @param menuId
	 * @return
	 */
	public List<Map<String, Object>> getBindRoleList(String menuId, String roleName, int indexNum, int pageSize){
		return m_MenuRightDao.getBindRoleList(menuId, roleName, indexNum, pageSize);
		
	}
	
	/**
	 * 查询未绑定的角色列表
	 * @param menuId
	 * @return
	 */
	public List<Map<String, Object>> getUnbRoleList(String menuId,String roleName, int indexNum, int pageSize){
		return m_MenuRightDao.getUnbRoleList(menuId, roleName, indexNum, pageSize);
	}
	
	/**
	 * 查询未绑定角色数量
	 * @param menuId
	 * @return
	 */
	public int getUnbRoleCount(String menuId, String roleName){
		return m_MenuRightDao.getUnbRoleCount(menuId, roleName);
		
	}
	
	public void saveRole(String menuId, String roleId){
		m_MenuRightDao.saveRole(menuId, roleId);
	}
	
	public void deleteRoles(String menuId, String roleIds){
		m_MenuRightDao.deleteRoles(menuId, roleIds);
	}
	
	public int getBindUserCount(String menuId, String userName){
		return m_MenuRightDao.getBindUserCount(menuId, userName);
	}
	
	public List<Map<String, Object>> getBindUserList(String menuId, String userName, int indexNum, int pageSize){
		return m_MenuRightDao.getBindUserList(menuId, userName, indexNum, pageSize);
		
	}
	
	/**
	 * 查询未绑定的用户列表
	 * @param menuId
	 * @return
	 */
	public List<Map<String, Object>> getUnbUserList(String menuId,String userName, int indexNum, int pageSize){
		return m_MenuRightDao.getUnbUserList(menuId, userName, indexNum, pageSize);
	}
	
	/**
	 * 查询未绑定用户数量
	 * @param menuId
	 * @return
	 */
	public int getUnbUserCount(String menuId, String userName){
		return m_MenuRightDao.getUnbindUserCount(menuId, userName);
		
	}
	
	public void saveUser(String menuId, String userId){
		m_MenuRightDao.saveUser(menuId, userId);
	}
	
	public void deleteUsers(String menuId, String userids){
		m_MenuRightDao.deleteUsers(menuId, userids);
	}
	
	public int getNextMenuId(){
		return m_MenuRightDao.getNextMenuId();
	}
	
	public void saveMenu(String menuId, String menuItemTitle, String parentId, String sortNum ,
			String iconUrl, String url, String state, String menuType, String power){
		m_MenuRightDao.saveMenu(menuId, menuItemTitle, parentId, sortNum, iconUrl, url, state, menuType, power);
	}
	
	public void delMenu(String menuId){
		m_MenuRightDao.delMenu(menuId);
	}
	
	public Map<String, Object> getMenuDetail(String menuId){
		return m_MenuRightDao.getMenuDetail(menuId);
	}
	
	public boolean insertMenuPower(String menuID,String powerId,String powerName,
			String powerDes,String powerCode,int sortNum){
		return m_MenuRightDao.insertMenuPower(menuID, powerId, powerName, powerDes, powerCode, sortNum);
	}
	
	public boolean updateMenuPower(String menuId,String powerId,String powerName,String powerdes,String powerCode){
		return m_MenuRightDao.updateMenuPower(menuId, powerId, powerName,powerdes,powerCode);
	}
	
	public int getNewSort(String menuId){
		return m_MenuRightDao.getNewSort(menuId);
	}
	
	public List<Map<String,Object>> getPowerByMenuId(String menuId){
		return m_MenuRightDao.getPowerByMenuId(menuId);
	}
	
	public List<Map<String,Object>> getAllPowerAndCheck(String menuid,String roleid){
		return m_MenuRightDao.getAllPowerAndCheck(menuid, roleid);
	}
	
	public boolean deleteAllRolePower(String menuid){
		return m_MenuRightDao.deleteAllRolePower(menuid);
	}
	
	public boolean addPowerToRole(String roleid,String menuid,String poerid){
		return m_MenuRightDao.addPowerToRole(roleid, menuid, poerid);
	}
	
	public List<Map<String,Object>> getUserMenuPower(String menuid,String userid){
		return m_MenuRightDao.getUserMenuPower(menuid,userid);
	}
}
