package com.asiainfo.hb.power.models;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.power.util.Conversion;

/**
 * 对FPF_USER_ROLE_MAP表的操作
 * @date 2016-10-28
 * @author lfy
 *
 */
@Repository
public class UserRoleMapDao extends BaseDao {
	
	/**
	 * 查询单条FPF_USER_ROLE_MAP记录
	 * @param roleid
	 * @param userid
	 * @return
	 */
	public List<Map<String,Object>> getUserRoleMap(String roleid,String userid){
		logger.debug("getUserRoleMap-------------------------------->");
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		try {
			
			String sql = " select roleid role_id,userid from FPF_USER_ROLE_MAP where roleid=? and userid =? ";
			list = jdbcTemplate.queryForList(sql, new Object[]{roleid,userid});
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		return list;
		
	}
	
	/**
	 * 批量添加角色与用户的关联数据
	 * @param roleid
	 * @param userid
	 * @return
	 */
	public boolean insertUserAndroleMap(String roleid,String[] userids){
		logger.debug("批量添加角色与用户的关联数据insertUserAndroleMap-------------------------------->");
		boolean flag = true;
		try {
			List<String> list = new ArrayList<String>();
			int len = userids.length-1;
			String sql = " insert into FPF_USER_ROLE_MAP values ";
			for (int i = 0; i < len; i++) {
				sql = sql +"(?,?),";
				list.add(roleid);
				list.add(userids[i]);
			}
			sql = sql +"(?,?)";
			list.add(roleid);
			list.add(userids[len]);
			jdbcTemplate.update(sql, list.toArray());
			
			flag = true;
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		
		return flag;
	}
	
	/**
	 * 添加用户与角色的关联数据
	 * @param roleid
	 * @param userid
	 * @return
	 */
	public boolean insertUserAndroleMap(String[] roleids,String userid){
		logger.debug("添加用户与角色的关联数据insertUserAndroleMap-------------------------------->");
		boolean flag = true;
		
		try {
			List<String> list = new ArrayList<String>();
			int len = roleids.length-1;
			String sql = " insert into FPF_USER_ROLE_MAP values ";
			for (int i = 0; i < len; i++) {
				sql = sql +"(?,?),";
				list.add(roleids[i]);
				list.add(userid);
			}
			sql = sql +"(?,?)";
			list.add(roleids[len]);
			list.add(userid);
			jdbcTemplate.update(sql, list.toArray());
			
			flag = true;
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		
		return flag;
	}
	
	/**
	 * 批量删除用户
	 * @param groupId
	 * @param roleid
	 * @param userid
	 * @return
	 */
	public boolean bachDeleteUserAndRoleMap(List<Object> roleids,String userid){
		logger.debug("bachDeleteUserAndRoleMap-------------------------------->");
 		boolean flag = false;
 		try {
			String createSql = Conversion.creteSql(roleids.size());
			String sql = " delete from FPF_USER_ROLE_MAP where roleid in "+createSql+" and userid = ? ";
			roleids.add(userid);
			Object[] obj = roleids.toArray();
			jdbcTemplate.update(sql,obj);
			flag = true;
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
 		return flag;
 	}
	
	public boolean bachDeleteUserAndRoleMap(String roleid,List<Object> userids){
		logger.debug("bachDeleteUserAndRoleMap-------------------------------->");
 		boolean flag = false;
 		try {
			String createSql = Conversion.creteSql(userids.size());
			String sql = " delete from FPF_USER_ROLE_MAP where userid in "+createSql+" and roleid = ? ";
			userids.add(roleid);
			Object[] obj = userids.toArray();
			jdbcTemplate.update(sql,obj);
			flag = true;
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
 		return flag;
 	}
	
	/**
	 * 查询用户的角色信息
	 * @param userid
	 * @return
	 */
	
	public List<Map<String,Object>> getRoleListByUserId(String userid){
		logger.debug("getRoleListByUserId-------------------------------->");
		try {
			String _sql =" select c.userid,a.role_id roleid,a.role_name rolename,a.create_time createtime from FPF_USER_ROLE a ,FPF_USER_ROLE_MAP b, FPF_USER_USER c " +
					" where a.role_id=b.roleid and b.userid=c.userid and c.userid = ? ";
			
			return jdbcTemplate.queryForList(_sql, new Object[]{userid});
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}
		
	}
	
	/**
	 * 查询角色对应的用户列表
	 * @param userid
	 * @return
	 */
	
	public List<Map<String,Object>> getUserListByRoleId(String roleid){
		logger.debug("getUserListByRoleId-------------------------------->");
		try {
			String _sql =" select a.role_id roleid,a.role_name rolename, c.userid,c.username from FPF_USER_ROLE a ,FPF_USER_ROLE_MAP b, FPF_USER_USER c " +
					" where a.role_id=b.roleid and b.userid=c.userid and a.role_id = ? ";
			
			return jdbcTemplate.queryForList(_sql, new Object[]{roleid});
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}
		
	}
	
	/**
	 *通过角色ID、角色名称模糊查询角色
	 * @param roleid
	 * @param roleName
	 * @return
	 */
	public List<Map<String,Object>> getRoleGroupByParam(String roleid,String roleName, String userId){
		logger.debug("getRoleGroupByParam-------------------------------->");
		try {
			String _sql = "select role_id roleid,role_name rolename,TO_CHAR (create_time,'YYYY-MM-DD HH24:MI:SS') createtime from FPF_USER_ROLE" +
					" where role_id not in (select roleid from FPF_USER_ROLE_MAP where userid = ?) and role_id like ? and role_name like ? ";
			
			return jdbcTemplate.queryForList(_sql, new Object[]{userId, "%"+roleid+"%","%"+roleName+"%"});
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}
		
	}

	public List<Map<String, Object>> getUserListByParam(String roleid,
			String userid, String username,String cityid) {
		logger.debug("getUserListByParam-------------------------------->");
		
		String _sql =" select c.userid,c.username,a.role_id roleid,a.role_name rolename,d.area_name areaname from FPF_USER_ROLE a ,FPF_USER_ROLE_MAP b, FPF_USER_USER c ,FPF_BT_AREA d" +
			         " where a.role_id=b.roleid and b.userid=c.userid and a.role_id = ? and c.cityid=d.area_id ";
		List<Object> list = new ArrayList<Object>();
		list.add(roleid);
		
		 if(userid!=null&&userid.trim().length()!=0){
			 _sql += " and c.userid like ? ";
			 list.add("%"+userid+"%");
		 }
		 
		 if(username!=null&&username.trim().length()!=0){
			 _sql+=" and c.username like ? ";
			 list.add("%"+username+"%");
		 }
		 
		 if(cityid!=null&&cityid.trim().length()!=0){
			 _sql+="  and c.cityid = ? ";
			 list.add(cityid);
		 }
		 Object[] obj=list.toArray();
		try {
			return jdbcTemplate.queryForList(_sql, obj);
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}
	}
	
}
