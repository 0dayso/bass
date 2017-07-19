package com.asiainfo.hb.power.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.core.models.BaseDao;

/**
 * 
 * @author xiaoh
 * 
 */
@Repository
public class MenuRightDao extends BaseDao{
	
	 public Logger logger = LoggerFactory.getLogger(MenuManageDao.class);

	public List<Map<String, Object>> getMenuList(){
		logger.debug("getMenuList----------------------------------------->");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String sql = "select * from FPF_SYS_MENU_ITEMS order by parentid, sortnum";
		try {
			list=this.jdbcTemplate.queryForList(sql);
		} catch (DataAccessException e) {
		
			e.printStackTrace();
		}
		return list;
	}
	
	public int getBindRoleCount(String menuId, String roleName){
		logger.debug("getBindRoleCount----------------------------------------->");
		String sql = "select count(1) from FPF_SYS_MENUITEM_RIGHT " +
				" left join FPF_USER_ROLE on role_id=operatorid " +
				" where resourceid =?";
		if(!StringUtils.isEmpty(roleName)){
			sql += " and role_name like '%" + roleName + "%'";
		}
		try {
			return this.jdbcTemplate.queryForObject(sql, new Object[] { menuId },Integer.class);
		} catch (Exception e) {
			
			e.printStackTrace();
			return 0;
		}
	}
	
	public List<Map<String, Object>> getBindRoleList(String menuId, String roleName, int indexNum, int pageSize){
		logger.debug("getBindRoleList----------------------------------------->");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String sql = "select m.operatorid roleid, r.role_name rolename, value(a.area_name,'') areaname" +
				" from FPF_SYS_MENUITEM_RIGHT m left join FPF_USER_ROLE r on m.operatorid = r.role_id " +
				" left join FPF_BT_AREA a on a.area_id = r.create_group " +
				" where m.resourceid =?";
		if(!StringUtils.isEmpty(roleName)){
			sql += " and r.role_name like '%" + roleName + "%'";
		}
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		sql = sqlPageHelper.getLimitSQL(sql, pageSize, indexNum, "roleid");
		try {
			list = this.jdbcTemplate.queryForList(sql, new Object[]{menuId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}
	
	public int getUnbRoleCount(String menuId, String roleName){
		logger.debug("getUnbRoleCount----------------------------------------->");
		String sql = "select count(1) from FPF_USER_ROLE r " +
					" where r.role_id not in (select operatorid from FPF_SYS_MENUITEM_RIGHT where resourceid='" + menuId + "')" ;
		if(!StringUtils.isEmpty(roleName)){
			sql += " and r.role_name like '%" + roleName + "%'";
		}
		try {
			return this.jdbcTemplate.queryForObject(sql,Integer.class);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
			return 0;
		}
	}
	
	public List<Map<String, Object>> getUnbRoleList(String menuId,String roleName, int indexNum, int pageSize){
		logger.debug("getUnbRoleList----------------------------------------->");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String sql = "select r.role_id roleid, r.role_name rolename, value(a.area_name,'') areaname, " +
				" to_char(r.create_time, 'YYYY-MM-DD HH24:MI:SS') createtime " +
				" from FPF_USER_ROLE r left join FPF_BT_AREA a on a.area_id = r.create_group " +
				" where r.role_id not in (select operatorid from FPF_SYS_MENUITEM_RIGHT where resourceid=?) " ;
		if(!StringUtils.isEmpty(roleName)){
			sql += " and r.role_name like '%" + roleName + "%'";
		}
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		sql = sqlPageHelper.getLimitSQL(sql, pageSize, indexNum, "roleid");
		try {
			list =this.jdbcTemplate.queryForList(sql, new Object[]{menuId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}
	
	public void saveRole(String menuId, String roleId){
		logger.debug("saveRole----------------------------------------->");
		String sql = "insert into FPF_SYS_MENUITEM_RIGHT (operatorid, resourceid) values(?,?) ";
		try {
			this.jdbcTemplate.update(sql, new Object[]{roleId, menuId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}
	
	public void deleteRoles(String menuId, String roleIds){
		logger.debug("deleteRoles----------------------------------------->");
		String sql = "delete from FPF_SYS_MENUITEM_RIGHT where resourceid='" + menuId + "' and operatorid in ("  + roleIds + ")";
		try {
			this.jdbcTemplate.update(sql);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}
	
	public int getBindUserCount(String menuId, String userName){
		logger.debug("getBindUserCount----------------------------------------->");
		String sql = "select count(1) from FPF_SYS_MENUITEM_USER m " +
				" left join FPF_USER_USER u on u.userid=m.user_id " +
				" where m.menu_id='" + menuId + "'";
		if(!StringUtils.isEmpty(userName)){
			sql += " and u.username like '%" + userName + "%'";
		}
				
		try {
			return this.jdbcTemplate.queryForObject(sql,Integer.class);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
			return 0;
		}
	}
	
	public List<Map<String, Object>> getBindUserList(String menuId, String userName, int indexNum, int pageSize){
		logger.debug("getBindUserList----------------------------------------->");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String sql = "select m.user_id userid,u.username username, value(a.area_name,'') areaname from FPF_SYS_MENUITEM_USER m " +
				" left join FPF_USER_USER u on u.userid = m.user_id" +
				" left join FPF_BT_AREA a on a.area_id=u.cityid" +
				" where m.menu_id='" + menuId + "'";
		if(!StringUtils.isEmpty(userName)){
			sql += " and username like '%" + userName + "%'";
		}
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		sql = sqlPageHelper.getLimitSQL(sql, pageSize, indexNum, "userid");
		
		try {
			list =this.jdbcTemplate.queryForList(sql);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
		
	}
	
	public int getUnbindUserCount(String menuId, String userName){
		logger.debug("getUnbindUserCount----------------------------------------->");
		String sql = "select count(1) from FPF_USER_USER  where userid not in (select user_id from FPF_SYS_MENUITEM_USER where menu_id =?) ";
		if(!StringUtils.isEmpty(userName)){
			sql += " and username like '%" + userName + "%'";
		}
		try {
			return this.jdbcTemplate.queryForObject(sql, new Object[]{menuId},Integer.class);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
			return 0;
		}
	}
	
	public List<Map<String, Object>> getUnbUserList(String menuId, String userName, int indexNum, int pageSize){
		logger.debug("getUnbUserList----------------------------------------->");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String sql = "select u.userid userid,u.username username, value(a.area_name,'') areaname, " +
				" char(u.createtime) createtime from FPF_USER_USER u " +
				" left join FPF_BT_AREA a on a.area_id=u.cityid " +
				" where u.userid not in (select user_id from FPF_SYS_MENUITEM_USER where menu_id ='" + menuId + "')";
		if(!StringUtils.isEmpty(userName)){
			sql += " and username like '%" + userName + "%'";
		}
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		sql = sqlPageHelper.getLimitSQL(sql, pageSize, indexNum, "userid");
		try {
			list = this.jdbcTemplate.queryForList(sql);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}
	
	public void saveUser(String menuId, String userId){
		logger.debug("saveUser----------------------------------------->");
		String sql = "insert into FPF_SYS_MENUITEM_USER (menu_id, user_id) values(?,?) ";
		try {
			this.jdbcTemplate.update(sql, new Object[]{menuId, userId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}
	
	public void deleteUsers(String menuId, String userids){
		logger.debug("deleteUsers----------------------------------------->");
		String sql = "delete from FPF_SYS_MENUITEM_USER where menu_id='" + menuId + "' and user_id in ("  + userids + ")";
		try {
			this.jdbcTemplate.update(sql);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}
	
	public int getNextMenuId(){
		logger.debug("getNextMenuId----------------------------------------->");
		String sql = "select max(int(menuitemid)) + 1 from FPF_SYS_MENU_ITEMS";
		try {
			return this.jdbcTemplate.queryForObject(sql,Integer.class);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
			return 0;
		}
	}
	
	public void saveMenu(String menuId, String menuItemTitle, String parentId, String sortNum ,
			String iconUrl, String url, String state, String menuType, String power){
		logger.debug("saveMenu----------------------------------------->");
		String delSql = "delete from FPF_SYS_MENU_ITEMS where menuitemid =?";
		String insSql = "insert into FPF_SYS_MENU_ITEMS (menuitemid, parentid, menuitemtitle, sortnum," +
				" iconurl, url, menutype, state) values(?,?,?,?,?,?,?,?)";
		try {
			this.jdbcTemplate.update(delSql, new Object[]{menuId});
			this.jdbcTemplate.update(insSql, new Object[]{menuId, parentId, menuItemTitle, Integer.valueOf(sortNum), iconUrl,
					url, Integer.valueOf(menuType), Integer.valueOf(state)});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		} catch (NumberFormatException e) {
			
			e.printStackTrace();
		}
	}
	
	public void delMenu(String menuId){
		logger.debug("delMenu----------------------------------------->");
		String delRoleSql = "delete from FPF_SYS_MENUITEM_RIGHT where resourceid= ?";
		String delUserSql = "delete from FPF_SYS_MENUITEM_USER where menu_id=?";
		String sql = "delete from FPF_SYS_MENU_ITEMS where menuitemid =?";
		String delepowersql = "delete from FPF_ROLE_MENU_POWER where menu_id =?";
		String deleMenupower = "delete from MENU_POWER_ITEM where menu_id =?";
		try {
			this.jdbcTemplate.update(delRoleSql, new Object[] { menuId });
			this.jdbcTemplate.update(delUserSql, new Object[] { menuId });
			this.jdbcTemplate.update(sql, new Object[] { menuId });
			this.jdbcTemplate.update(delepowersql, new Object[] { menuId });
			this.jdbcTemplate.update(deleMenupower, new Object[] { menuId });
		} catch (Exception e) {
		
			e.printStackTrace();
		}
	}
	
	public Map<String, Object> getMenuDetail(String menuId){
		logger.debug("getMenuDetail----------------------------------------->");
		Map<String, Object> map = new HashMap<String, Object>();
		String sql = "select * from FPF_SYS_MENU_ITEMS where menuitemid = ?";
		try {
			map =  this.jdbcTemplate.queryForMap(sql, new Object[]{menuId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return  map;
	}
	
	/**
	 * 添加功能
	 * @param menuID 菜单编号
	 * @param powerId 功能编号
	 * @param powerName 功能名称
	 * @param powerDes 功能描述
	 * @param powerCode 功能位置码
	 * @param sortNum 排序
	 * @return
	 */
	public boolean insertMenuPower(String menuID,String powerId,String powerName,
			String powerDes,String powerCode,int sortNum){
		logger.debug("insertMenuPower----------------------------------------->");
		boolean flag = false;
		
		try {
			StringBuffer _sql = new StringBuffer();
			_sql.append("INSERT INTO ")
				.append(" MENU_POWER_ITEM ")
				.append(" (MENU_ID,POWER_ID,POWER_NAME,POWER_DES,POWER_CODE,SORT_NUM) ")
				.append(" VALUES ")
				.append(" ( ?,?,?,?,?,? ) ");
			Object[] obj = new Object[]{menuID,powerId,powerName,powerDes,powerCode,sortNum};
			jdbcTemplate.update(_sql.toString(), obj);
			flag = true;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		return flag;
	}
	
	/**
	 * 更新功能
	 * @param menuId
	 * @param powerId
	 * @param powerName
	 * @return
	 */
	public boolean updateMenuPower(String menuId,String powerId,String powerName,String powerDES,String powerCode){
		logger.debug("updateMenuPower----------------------------------------->");
		boolean flag = false;
		try {
			String _sql = " update menu_power_item set POWER_NAME = ?,POWER_DES=?,POWER_CODE=? WHERE MENU_ID = ? AND POWER_ID = ? ";
			Object[] obj = new Object[] { powerName, powerDES,powerCode,menuId, powerId };
			jdbcTemplate.update(_sql.toString(), obj);
			flag = true;
		} catch (Exception e) {
		
			e.printStackTrace();
		}
		return flag;
	}
	
	/**
	 * 获得新的
	 * @param menuId
	 * @return
	 */
	public int getNewSort(String menuId){
		logger.debug("getNewSort----------------------------------------->");
		String sql = " select count(menu_id) powernum from menu_power_item where menu_id = ? ";
		int num = 0;
		try {
			num = jdbcTemplate.queryForObject(sql, new Object[]{menuId},Integer.class);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return num+1;
	}
	
	/**
	 * 根据菜单ID获得power信息
	 * @param menuId
	 * @return
	 */
	public List<Map<String,Object>> getPowerByMenuId(String menuId){
		logger.debug("getPowerByMenuId----------------------------------------->");
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String sql = " select menu_id menuid ,power_id powerid ,power_name||'-'||power_des||'-'||power_code powername, " +
				     " power_code powercode ,sort_num sortnum from menu_power_item where menu_id = ? ";
		try {
			list =  jdbcTemplate.queryForList(sql, new Object[]{menuId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
		
	}
	
	
	/**
	 * 查询菜下的所有权限，并查询据角色权限
	 * @param menuid
	 * @param roleid
	 * @return
	 */
	public List<Map<String,Object>> getAllPowerAndCheck(String menuid,String roleid){
		logger.debug("getAllPowerAndCheck----------------------------------------->");
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String _sql = " select power_des powername,power_id powerid,(select power_id from FPF_ROLE_MENU_POWER b where a.power_id = b.power_id and b.role_id = ? ) checked" +
				      " from menu_power_item a where a.menu_id= ?";
		try {
			list = jdbcTemplate.queryForList(_sql, new Object[]{roleid,menuid});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
		
	}
	
	/**
	 * 删除菜单的所有权限
	 * @param menuid
	 * @return
	 */
	public boolean deleteAllRolePower(String menuid){
		logger.debug("deleteAllRolePower----------------------------------------->");
		boolean flag = false;
		
		try {
			String sql = " delete from FPF_ROLE_MENU_POWER where menu_id = ? ";
			jdbcTemplate.update(sql, new Object[]{menuid});
			flag = true;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		return flag;
	}
	
	/**
	 * 为角色添加菜单权限
	 * @param roleid
	 * @param menuid
	 * @param poerid
	 * @return
	 */
	
	public boolean addPowerToRole(String roleid,String menuid,String poerid){
		logger.debug("addPowerToRole----------------------------------------->");
		boolean flag = true;
		
		try {
			StringBuffer _sql = new StringBuffer();
			_sql.append("INSERT INTO ")
				.append(" FPF_ROLE_MENU_POWER ")
				.append(" (ROLE_ID,MENU_ID,POWER_ID) ")
				.append(" VALUES ")
				.append(" ( ?,?,?) ");
			Object[] obj = new Object[]{roleid,menuid,poerid};
			jdbcTemplate.update(_sql.toString(), obj);
			flag = true;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		return flag;
	}
	
	public List<Map<String,Object>> getUserMenuPower(String menuid,String userid){
		logger.debug("getUserMenuPower----------------------------------------->");
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String sql = " select a.userid,b.group_id,c.role_id,d.power_id," +
				     " (select power_code from menu_power_item e where e.power_id = d.power_id ) power_code " +
				     " from FPF_USER_USER a,FPF_USER_GROUP_MAP b,FPF_GROUP_ROLE_MAP c,FPF_ROLE_MENU_POWER d where " +
				     " a.userid=b.userid and b.group_id = c.group_id and c.role_id=d.role_id and d.menu_id = ? and a.userid = ?";
		try {
			list = jdbcTemplate.queryForList(sql, new Object[]{menuid,userid});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}
	
}
