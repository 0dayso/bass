package com.asiainfo.hb.power.models;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import com.asiainfo.hb.core.models.BaseDao;

/**
 * @author zhaob 
 * @date 2016年8月24日
 */
@Repository
public class UserItemsManageDao extends BaseDao{
	@Resource(name="jdbcTemplateN")
	  private NamedParameterJdbcTemplate pjdbcTemplate;
	 
	public Logger logger = LoggerFactory.getLogger(UserItemsManageDao.class);
	/**
	  * user_items_map
	  * 根据menuid查询power
	  * @param menuid
	  * @return map
	  */
	 public List<Map<String,Object>> getPowerbymenuid(int roleId,int menuId){
		 logger.debug("getPowerbymenuid-------------------------------->");
		 List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
			String _sql = " select 'Y,Y,Y,N' power,roleid,menuid from user_items_map where roleid=? and menuid = ? ";
			 try {
				result = jdbcTemplate.queryForList(_sql, new Object[]{roleId,menuId});
			} catch (DataAccessException e) {
				
				e.printStackTrace();
			}
			return result;
		}

	/**
	 * 根据groupid查询menuid
	 * @param groupId
	 * @return
	 */
	 public List<Map<String,Object>> queryByGroupid(int groupId){
		 logger.debug("queryByGroupid-------------------------------->");
		 List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
			String _sql = " SELECT * FROM USER_ITEMS_MAP WHERE ROLEID=?";
			List<Object> list = new ArrayList<Object>();
			list.add(groupId);
			 Object[] obj=list.toArray();
			 try {
				result=jdbcTemplate.queryForList(_sql, obj);
			} catch (DataAccessException e) {
				
				e.printStackTrace();
			}
			 return result;
			
		}
	/**
	 * 添加数据
	 * @param menuId
	 * @param roleid
	 * @param power
	 * @param tableName
	 */
//	public void addUserItems(int menuId, int groupId, String power) {
//		
//			Map paramMap = new HashMap();
//			paramMap.put("ROLEID", Integer.valueOf(groupId));
//			paramMap.put("MENUID", Integer.valueOf(menuId));
//		    paramMap.put("POWER", power);
//		    StringBuffer sql = new StringBuffer();
//		    sql.append("insert into ")
//		       .append("USER_ITEMS_MAP")
//		      .append(" (ROLEID,MENUID,POWER) ")
//		      .append(" values ")
//		      .append(" (:ROLEID,:MENUID,:POWER) ");
//		    pjdbcTemplate.execute(sql.toString(), paramMap, new PreparedStatementCallback()
//		    {
//		        public Object doInPreparedStatement(PreparedStatement pre) throws SQLException, DataAccessException
//		        {
//		          return Boolean.valueOf(pre.execute());
//		        } } );
//		
//	}
	 public boolean addUserItems(String menuId, String roleId,String power) {
		 logger.debug("addUserItems-------------------------------->");
		 boolean flag = true;
		 try {
				StringBuffer _sql = new StringBuffer();
				 _sql.append(" insert into USER_ITEMS_MAP (ROLEID,MENUID,POWER) ")
				 	 .append(" values ")
				 	 .append(" ( ?, ?, ?) ");
				 Object[] obj=new Object[]{roleId,menuId,power};
				 jdbcTemplate.update(_sql.toString(), obj);
				 flag = true;
			} catch (Exception e) {
				
				e.printStackTrace();
			}
		 return flag;
	 }
	/**
	 * 修改 根据menuid  进行修改power
	 * @param menuid
	 * @param power
	 * @return boolean:  true OR false
	 */
	public boolean updateByMenuid(int roleId,int menuId,String power){
		logger.debug("updateByMenuid-------------------------------->");
		boolean flag = true;
		 
		try {
			StringBuffer _sql = new StringBuffer();
			 _sql.append(" UPDATE USER_ITEMS_MAP ")
			 	 .append(" SET POWER=? ")
			 	 .append(" WHERE ROLEID= ? ")
			 	 .append(" AND MENUID= ? ");
			 Object[] obj=new Object[]{power,roleId,menuId};
			 jdbcTemplate.update(_sql.toString(), obj);
			 System.out.println("sql="+_sql);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		
		return flag;
	}

	/**
	 * 删除数据 根据menuId删除  相应菜单权限信息
	 * @param menuId
	 * @return boolean:  true OR false
	 */
	public boolean deletebypId(int roleId,int menuId){
		logger.debug("deletebypId-------------------------------->");
		 boolean flag = false;
		 try {
			 String sql = " DELETE FROM USER_ITEMS_MAP WHERE ROlEID = '"+roleId+"'and MENUID = '"+menuId+"' ";
//			 String sql = " DELETE FROM USER_ITEMS_MAP WHERE MENUID = '"+menuId+"'";
			 jdbcTemplate.execute(sql);
			 flag = true;
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 
		 return flag;
	 }
	
	/**
	 * 通过父菜单ID查询所有子菜单ID
	 * @param pID
	 * @return
	 */
	public List<Map<String,Object>> getChildrenItemsIdByPID(String pID){
		logger.debug("getChildrenItemsIdByPID-------------------------------->");
		 List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
		String _sql = " select menuitemid from FPF_SYS_MENU_ITEMS where parentid = ? ";
		try {
			result=jdbcTemplate.queryForList(_sql, new Object[]{pID});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 通过ID查询符ID
	 * @param cID
	 * @return
	 */
	public List<Map<String,Object>> getParentItemsIdBycID(String cID){
		logger.debug("getParentItemsIdBycID-------------------------------->");
		 List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
		String _sql = " select parentid from FPF_SYS_MENU_ITEMS where menuitemid = ? ";
		try {
			result=jdbcTemplate.queryForList(_sql, new Object[]{cID});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 递归的方式查询所有菜单的子菜单
	 * @param list
	 * @param pid
	 * @return
	 */
	public List<Map<String,Object>> getAllchildrenItemsByPid(List<Map<String,Object>> list,String pid){
		logger.debug("getAllchildrenItemsByPid-------------------------------->");
		List<Map<String,Object>> childList = getChildrenItemsIdByPID(pid);
		list.addAll(childList);
		for (int i = 0; i < childList.size(); i++) {
			String cpid = childList.get(i).get("menuitemid").toString();
			getAllchildrenItemsByPid(list,cpid);
		}
		return list;
	}
	
	/**
	 * 递归的方式查询所有父菜单
	 * @param list
	 * @param pid
	 * @return
	 */
	public List<Map<String,Object>> getAllParentItemsBycid(List<Map<String,Object>> list,String cid){
		logger.debug("getAllParentItemsBycid-------------------------------->");
		List<Map<String,Object>> childList = getParentItemsIdBycID(cid);
		list.addAll(childList);
		for (int i = 0; i < childList.size(); i++) {
			String cpid = childList.get(i).get("parentid").toString();
			getAllParentItemsBycid(list,cpid);
		}
		return list;
	}
	
	
	public List<Map<String,Object>> userItemMap(String roleId,String menuId){
		logger.debug("userItemMap-------------------------------->");
		 List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
		String sql = "select * from USER_ITEMS_MAP where roleid=? and menuid=?";
		try {
			result=jdbcTemplate.queryForList(sql, new Object[]{roleId,menuId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return result;
	}
	
}
