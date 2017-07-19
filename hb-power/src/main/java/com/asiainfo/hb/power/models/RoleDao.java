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
import com.asiainfo.hb.power.util.DateUtil;
import com.asiainfo.hb.power.util.IdGen;

@SuppressWarnings("unused")
@Repository
public class RoleDao extends BaseDao {
	
	public Logger logger = LoggerFactory.getLogger(RoleDao.class);

	public List<Map<String, Object>> queryRole(String roleName, int indexNum, int pageSize) {
		logger.debug("queryRole------------------------------>");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		try {
			if (StringUtils.isEmpty(roleName)) {
				String sql = "select * from FPF_USER_ROLE";
				sql = sqlPageHelper.getLimitSQL(sql, pageSize, indexNum, "role_id");
				list =  jdbcTemplate.queryForList(sql);
			} else {
				String sql = "select * from FPF_USER_ROLE where role_name like ?";
				sql = sqlPageHelper.getLimitSQL(sql, pageSize, indexNum, "role_id");
				list = jdbcTemplate.queryForList(sql, new Object[] { "%" + roleName + "%" });
			}
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		} 
		
		return list;
	}

	public int getRoleCount(String roleName) {
		logger.debug("getRoleCount------------------------------>");
		int count = 0;
		try {
			if (StringUtils.isEmpty(roleName)) {
				String sqlcount = "select count(*) from FPF_USER_ROLE";
				count =  jdbcTemplate.queryForObject(sqlcount, new Object[] {},Integer.class);
			} else {
				String sqlcount = "select count(*) from FPF_USER_ROLE where role_name like ? ";
				count = jdbcTemplate.queryForObject(sqlcount, new Object[] { "%" + roleName + "%" },Integer.class);
			}
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return count;
	}

	public int add(String roleName) {
		logger.debug("add------------------------------>");
		int count = 0;
		String sql = "insert into FPF_USER_ROLE (role_id,role_name,create_time,resourcetype)" + " values(?,?,?,?)";
		String time = DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss");
		 try {
			count = jdbcTemplate.update(sql, new Object[] { IdGen.genId(), roleName, time, 1 });
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 return count;
	}

	// 修改
	public void update(String roleId, String roleName) {
		logger.debug("update------------------------------>");
		String sql = "update FPF_USER_ROLE set role_name = ? where role_id = ?";
		try {
			jdbcTemplate.update(sql, new Object[] { roleName, roleId });
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}

	// 单个删除
	public void delete(String id) {
		
		logger.debug("delete------------------------------>");
		String groupSql = "delete from FPF_GROUP_ROLE_MAP where role_id=?";
		String menuSql = "delete from FPF_SYS_MENUITEM_RIGHT where operatorid=?";
		String userSql = "delete from FPF_USER_ROLE_MAP where roleid =?";
		String sql = "delete from FPF_USER_ROLE where role_id = ?";
		String deletepower = "delete from FPF_ROLE_MENU_POWER where role_id =?";
		try {
			jdbcTemplate.update(sql, new Object[] { id });
			jdbcTemplate.update(groupSql, new Object[] { id });
			jdbcTemplate.update(menuSql, new Object[] { id });
			jdbcTemplate.update(userSql, new Object[] { id });
			jdbcTemplate.update(deletepower, new Object[] { id });
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}

	// 批量删除
	public void batchDelete(String ids) {
		logger.debug("batchDelete------------------------------>");
		String groupSql = "delete from FPF_GROUP_ROLE_MAP where role_id in (" + ids + "'')";
		String menuSql = "delete from FPF_SYS_MENUITEM_RIGHT where operatorid in (" + ids + "'')";
		String userSql = "delete from FPF_USER_ROLE_MAP where roleid in (" + ids + "'')";
		String sql = "delete from FPF_USER_ROLE where role_id in (" + ids + "'')";
		String deletepower = "delete from FPF_ROLE_MENU_POWER where role_id in ("+ids+"'')";
		try {
			jdbcTemplate.update(sql);
			jdbcTemplate.update(groupSql);
			jdbcTemplate.update(menuSql);
			jdbcTemplate.update(userSql);
			jdbcTemplate.update(deletepower);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}

	}
	
	public List<Map<String, Object>> getMenuList(String roleId, String menuName){
		logger.debug("getMenuList------------------------------>");
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		
		String sql = "select resourceid menuid, menuitemtitle menutitle from FPF_SYS_MENUITEM_RIGHT" +
				" left join FPF_SYS_MENU_ITEMS on resourceid=menuitemid where operatorid='" + roleId + "'";
		if(!StringUtils.isEmpty(menuName)){
			sql += " and menuitemtitle like '%" + menuName + "%'";
		}
		try {
			list =jdbcTemplate.queryForList(sql);
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> map = list.get(i);
				List<Map<String, Object>> power=getPowersByMenuAnRole(map.get("menuid").toString(), roleId);
				map.put("power", power);
				list.set(i, map);
			}
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}

	public List<Map<String, Object>> getConnectGroup(String roleId, String groupName){
		logger.debug("getConnectGroup------------------------------>");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String sql = "select a.group_id groupid, b.group_name groupname, char(b.create_time) createtime from  FPF_GROUP_ROLE_MAP  a " +
				" left join FPF_USER_GROUP b on a.group_id=b.group_id " +
				" where role_id=?";
		if(!StringUtils.isEmpty(groupName)){
			sql += " and b.group_name like '%" + groupName + "%'";
		}
		try {
			list =  jdbcTemplate.queryForList(sql, new Object[]{roleId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}
	
	public void delGroup(String roleId, String groupIds){
		logger.debug("delGroup------------------------------>");
		String sql = "delete from FPF_GROUP_ROLE_MAP where role_id= '" + roleId + "' and group_id in (" + groupIds + ")";
		try {
			jdbcTemplate.update(sql);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}
	
	public void addGroup(String roleId, String groupId){
		logger.debug("addGroup------------------------------>");
		String sql = "insert into FPF_GROUP_ROLE_MAP (group_id, role_id) values (?,?)";
		try {
			jdbcTemplate.update(sql, new Object[]{groupId, roleId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}
	
	public List<Map<String, Object>> getUbConnectGroup(String roleId, String groupName){
		logger.debug("getUbConnectGroup------------------------------>");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String sql = "select group_id groupid, group_name groupname, char(create_time) createtime" +
				" from FPF_USER_GROUP where group_id not in (select group_id from FPF_GROUP_ROLE_MAP where role_id=?)";
		if(!StringUtils.isEmpty(groupName)){
			sql += " and group_name like '%" + groupName + "%'";
		}
		try {
			return list =jdbcTemplate.queryForList(sql, new Object[]{roleId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}
	
	public List<Map<String, Object>> getPowersByMenuAnRole(String menuid,String roleid){
		logger.debug("getPowersByMenuAnRole------------------------------>");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String sql=" select power_id ,(select power_des from menu_power_item b where a.power_id=b.power_id ) power_name " +
				   " from FPF_ROLE_MENU_POWER a where role_id=? and menu_id=? ";
		 try {
			list =jdbcTemplate.queryForList(sql, new Object[]{roleid,menuid});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 return list;
	}

	public List<Map<String, Object>> getConnectMenu(String roleId,
			String menuName) {
		logger.debug("getConnectMenu------------------------------>");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String sql = "select a.RESOURCEID menuid, b.MENUITEMTITLE menuname from  FPF_SYS_MENUITEM_RIGHT  a " +
				" left join FPF_SYS_MENU_ITEMS b on a.RESOURCEID=b.MENUITEMID " +
				" where OPERATORID=?";
		if(!StringUtils.isEmpty(menuName)){
			sql += " and b.MENUITEMTITLE like '%" + menuName + "%'";
		}
		try {
			list =  jdbcTemplate.queryForList(sql, new Object[]{roleId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}

	public void addMenus(String roleId, String menuId) {
		 
		logger.debug("addMenus------------------------------>");
		String sql = "insert into FPF_SYS_MENUITEM_RIGHT (RESOURCEID, OPERATORID) values (?,?)";
		try {
			jdbcTemplate.update(sql, new Object[]{menuId, roleId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}

	public void delMenu(String roleId, String menuIds) {
		
		logger.debug("delMenu------------------------------>");
		String sql = "delete from FPF_SYS_MENUITEM_RIGHT where OPERATORID= '" + roleId + "' and RESOURCEID in (" + menuIds + ")";
		try {
			jdbcTemplate.update(sql);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	}

	public List<Map<String, Object>> getUbConnectMenu(String roleId,
			String menuName) {
		logger.debug("getUbConnectMenu------------------------------>");
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String sql = "select MENUITEMID menuid, MENUITEMTITLE menuname " +
				" from FPF_SYS_MENU_ITEMS where  MENUITEMID not in (select RESOURCEID from FPF_SYS_MENUITEM_RIGHT where OPERATORID=?)";
		if(!StringUtils.isEmpty(menuName)){
			sql += " and MENUITEMTITLE like '%" + menuName + "%'";
		}
		try {
			list =  jdbcTemplate.queryForList(sql, new Object[]{roleId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}
}
