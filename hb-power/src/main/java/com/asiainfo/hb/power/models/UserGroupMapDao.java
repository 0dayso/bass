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
import org.springframework.util.StringUtils;

import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.power.controller.UserManagerController;
import com.asiainfo.hb.power.util.Conversion;

@SuppressWarnings("unused")
@Repository
public class UserGroupMapDao extends BaseDao{
	public Logger logger = LoggerFactory.getLogger(UserGroupMapDao.class);
	 
	  @Resource(name="jdbcTemplateN")
	  private NamedParameterJdbcTemplate pjdbcTemplate;
	
	 /**
	  * 根据条查询不在指定用户组下的用户信息
	  * @param userid
	  * @param username
	  * @param groupid
	  * @param cityid
	  * @return
	  */
	public List<Map<String,Object>> getUserInfoNoInGroupid(String userid,String username,String groupid,String cityid){
		logger.debug("getUserInfoNoInGroupid-------------------------------->");
		String _sql = " select a.userid,a.username,b.area_name from FPF_USER_USER a,FPF_BT_AREA b where a.cityid=b.area_id" +
				      " and userid not in (select userid from FPF_USER_GROUP_MAP where group_id = ? ) ";
		List<Object> list = new ArrayList<Object>();
		List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
		list.add(groupid);
		 if(userid!=null&&userid.trim().length()!=0){
			 _sql += " and userid like ? ";
			 list.add("%"+userid+"%");
		 }
		 
		 if(username!=null&&username.trim().length()!=0){
			 _sql+=" and username like ? ";
			 list.add("%"+username+"%");
		 }
		 
		 if(cityid!=null&&cityid.trim().length()!=0){
			 _sql+=" and cityid = ? ";
			 list.add(cityid);
		 }
		 Object[] obj=list.toArray();
		 try {
			result=jdbcTemplate.queryForList(_sql, obj);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
		 return result;
		
	}
	
	 /**
	  * 根据条查询不在指定角色下的用户信息
	  * @param userid
	  * @param username
	  * @param groupid
	  * @param cityid
	  * @return
	  */
	public List<Map<String,Object>> getUserInfoNoInRoleid(String userid,String username,String roleid,String cityid){
		logger.debug("getUserInfoNoInGroupid-------------------------------->");
		String _sql = " select a.userid,a.username,b.area_name from FPF_USER_USER a,FPF_BT_AREA b where a.cityid=b.area_id" +
				      " and userid not in ( select userid from FPF_USER_ROLE_MAP where roleid = ? ) ";
		List<Object> list = new ArrayList<Object>();
		list.add(roleid);
		List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
		 if(userid!=null&&userid.trim().length()!=0){
			 _sql += " and userid like ? ";
			 list.add("%"+userid+"%");
		 }
		 
		 if(username!=null&&username.trim().length()!=0){
			 _sql+=" and username like ? ";
			 list.add("%"+username+"%");
		 }
		 
		 if(cityid!=null&&cityid.trim().length()!=0){
			 _sql+=" and cityid = ? ";
			 list.add(cityid);
		 }
		 Object[] obj=list.toArray();
		 try {
			result=jdbcTemplate.queryForList(_sql, obj);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 return result;
		
	}
	
	
	 /**
	  * 查询角色下的用户成员表
	  * @param userid
	  * @param username
	  * @param groupid
	  * @param cityid
	  * @return
	  */
	public List<Map<String,Object>> getUserInfoBygroupID(String groupid,String userid,String username,String cityid){
		logger.debug("getUserInfoBygroupID-------------------------------->");
		String _sql = " select a.userid,a.username,b.area_name from FPF_USER_USER a,FPF_BT_AREA b where a.cityid=b.area_id " ;
		List<Object> list = new ArrayList<Object>();
		List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
		if(userid!=null&&!userid.equals("")){
			_sql = _sql +" and userid like ? ";
			 list.add("%"+userid+"%");
		}
		
		if(username!=null&&!username.trim().equals("")){
			_sql = _sql +" and username like ? ";
			 list.add("%"+username+"%");
		}
		
		if(cityid!=null&&!cityid.trim().equals("")){
			_sql = _sql +" and cityid = ? ";
			list.add(cityid);
		}
		_sql = _sql + " and userid  in ( select userid from FPF_USER_GROUP_MAP where group_id = ? ) ";
		list.add(groupid);
		 Object[] obj=list.toArray();
		 try {
			result=jdbcTemplate.queryForList(_sql, obj);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 return result;
		
	}
	
	/**
	 * 通过groupid和userid删除UserGroupMap
	 * @param groupId
	 * @param userid
	 * @return
	 */
	 public boolean deleteUserGroupMapbyId(String groupId,List<String> userid){
		 logger.debug("deleteUserGroupMapbyId-------------------------------->");
		 boolean flag = false;
		 String _sql = Conversion.creteSql(userid.size());
		 userid.add(groupId);
		 try {
			String sql = " delete from FPF_USER_GROUP_MAP where  USERID in "+_sql+"  and GROUP_ID =? ";
			 jdbcTemplate.update(sql, userid.toArray());
			 flag = true;
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 return flag;
	 }
	 
	
	 public boolean addUserGroupMap(String userId,String groupId){
		 logger.debug("addUserGroupMap-------------------------------->");
			boolean flag = true;
			try {
				StringBuffer _sql = new StringBuffer();
				 _sql.append(" insert into FPF_USER_GROUP_MAP (USERID,GROUP_ID) ")
				 	 .append(" values ")
				 	 .append(" ( ?, ?) ");
				 Object[] obj=new Object[]{userId,groupId};
				 jdbcTemplate.update(_sql.toString(), obj);
				 flag = true;
			} catch (Exception e) {
				
				e.printStackTrace();
			}
			
			return flag;
		}
	 	
	 
	 public boolean addUserGroupMap(String[] userId,String groupId){
		 logger.debug("addUserGroupMap(批量)-------------------------------->");
			boolean flag = true;
			try {
				List<String> list = new ArrayList<String>();
				StringBuffer _sql = new StringBuffer();
				 _sql.append(" insert into FPF_USER_GROUP_MAP (USERID,GROUP_ID) ")
				  .append(" values ");
				int len = userId.length-1;
				for (int i = 0; i < len; i++) {
					_sql.append(" ( ?, ?), ");
					list.add(userId[i]);
					list.add(groupId);
				}
				_sql.append(" ( ?, ?) ");
				list.add(userId[len]);
				list.add(groupId);
				 Object[] obj=list.toArray();
				 jdbcTemplate.update(_sql.toString(), obj);
				 flag = true;
			} catch (Exception e) {
				
				e.printStackTrace();
			}
			
			return flag;
		}
	 /**
	  * 修改用户的用户组
	  * @param oldGroupId
	  * @param newGroupId
	  * @param userId
	  * @return
	  */
	 	public boolean updateUserGroupMap(String oldGroupId,String newGroupId,String userId){
	 		logger.debug("updateUserGroupMap-------------------------------->");
	 		boolean flag = false;
	 		try {
	 			String delSql = "delete from FPF_USER_GROUP_MAP where userid= ?";
	 			String _sql = "insert into FPF_USER_GROUP_MAP (userid, group_id) values (?,?)";
	 			jdbcTemplate.update(delSql, new Object[]{userId});
				jdbcTemplate.update(_sql, new Object[]{userId,newGroupId});
				flag = true;
			} catch (DataAccessException e) {
				
				e.printStackTrace();
			}
	 		
	 		return flag;
	 	}
	 
	 public List<Map<String, Object>> getConnectUserGroup(String userId, String groupName){
		 logger.debug("getConnectUserGroup-------------------------------->");
		 List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
		 String sql = "select a.group_id groupid, b.group_name groupname, char(b.create_time) createtime from FPF_USER_GROUP_MAP a" +
		 		" left join FPF_USER_GROUP b on a.group_id = b.group_id where a.userid=?";
		 if(!StringUtils.isEmpty(groupName)){
			 sql += " and b.group_name like '%" + groupName + "%'";
		 }
		 try {
			result=jdbcTemplate.queryForList(sql, new Object[]{userId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 return result;
	 }
	 
	 public List<Map<String, Object>> getUnconnectUserGroup(String userId, String groupName){
		 logger.debug("getUnconnectUserGroup-------------------------------->");
		 List<Map<String,Object>> result=new ArrayList<Map<String,Object>>();
		 String sql = "select group_id groupid, group_name groupname, char(create_time) createtime from FPF_USER_GROUP " +
		 		" where group_id not in (select group_id from FPF_USER_GROUP_MAP where userid=?)";
		 if(!StringUtils.isEmpty(groupName)){
			 sql += " and group_name like '%" + groupName + "%'";
		 }
		 try {
			result=jdbcTemplate.queryForList(sql, new Object[]{userId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 return result;
	 }
	 
	 public void delUserGroup(String userId, String groupIds){
		 logger.debug("delUserGroup-------------------------------->");
		 String sql = "delete from FPF_USER_GROUP_MAP where userid='"  + userId + "' and group_id in(" + groupIds + ")";
		 try {
			jdbcTemplate.update(sql);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
	 }

}
