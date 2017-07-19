package com.asiainfo.hb.power.models;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.power.util.Conversion;

@Repository
public class UserTreeManageDao extends BaseDao {
	
	  @Resource(name="jdbcTemplateN")
	  private NamedParameterJdbcTemplate pjdbcTemplate;
	  
	  public Logger logger = LoggerFactory.getLogger(UserTreeManageDao.class);

	  /**
	   * 查询所以用户组 ID,name,pid
	   * @return
	   */
	 public List<Map<String, Object>> queryAlltreeUser()
	  {
		 logger.debug("queryAlltreeUser------------------->");
	    StringBuffer sql = new StringBuffer();
	    sql.append(" select * from ( ")
	       .append(" select group_id treeNodeId,group_name treeNodeName,parent_id treeNodePid  from FPF_USER_GROUP ")
	       .append(" ) order by treeNodeId ");
	    try {
	    	return jdbcTemplate.queryForList(sql.toString());
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}
	  }
	 
	 /**
	  * 创建新的用户组编号
	  * @return
	  */
	 public int createNewGroupId() {
		 logger.debug("createNewGroupId-------------------------------->");
			
		 try {
			 StringBuffer sql = new StringBuffer();
			 sql.append(" select max(group_id)+1 newgroupid from FPF_USER_GROUP where length(group_id)<10 ");
			 Map<String,Object> map = jdbcTemplate.queryForMap(sql.toString());
			 int newgroupid = Integer.parseInt(map.get("newgroupid").toString()==null?"1":map.get("newgroupid").toString());
			 return newgroupid;
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return 0;
		}
		}

	 
	 /**
	  * 通过用户组编号删除用户组
	  * @param groupId
	  * @return
	  */
	 public boolean deleteUserGroupbyId(String groupId){
		 logger.debug("deleteUserGroupbyId-------------------------------->");
		 boolean flag = false;
		 try {
			 String userSql = "delete from FPF_USER_GROUP_MAP where group_id='" + groupId + "'";
			 String roleSql = "delete from FPF_GROUP_ROLE_MAP where group_id='" + groupId + "'";
			 String sql = " delete from FPF_USER_GROUP where group_id = '"+groupId+"' ";
			 jdbcTemplate.execute(userSql);
			 jdbcTemplate.execute(roleSql);
			 jdbcTemplate.execute(sql);
			 flag = true;
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 return flag;
	 }
	 
	 /**
	  * 通过父用户组删除所以用户组
	  * @param groupId
	  * @return
	  */
	 public boolean deleteUserGroupbypId(String groupId){
		 logger.debug("deleteUserGroupbypId-------------------------------->");
		 boolean flag = false;
		 try {
			String sql = " delete from FPF_USER_GROUP where parent_id = '"+groupId+"' ";
			 jdbcTemplate.execute(sql);
			 flag = true;
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		 
		 return flag;
	 }
	 
	 /**
	  * 查询所有用户组信息
	  * @return
	  */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<Map<String,Object>> queryMenus() {
		logger.debug("queryMenus-------------------------------->");
		
		 StringBuffer sql = new StringBuffer();
		    sql.append(" select group_id treeNodeId,group_name treeNodeName from ");
		    sql.append(" FPF_USER_GROUP ")
		       .append(" order by treeNodeId ");
		    System.out.println(sql);
		    try
		    {
		    
				List lists = new ArrayList();
		     List <Map<String,Object>> list = jdbcTemplate.queryForList(sql.toString());
		     for (int i = 0; i < list.size(); i++) {
		    	 Map<String,Object> map = list.get(i);
		    	 lists.add(new String[] {map.get("treeNodeId").toString(),map.get("treeNodeName")==null?"":map.get("treeNodeName").toString()});
			}
		     return lists;
		    }
		    catch (EmptyResultDataAccessException e) {
		    }
		    return null;
	}
	
	/**
	 * 通过用户组名称查询用户组
	 * @param groupName
	 * @return
	 */
	public List<Map<String,Object>> selectUserGroupbyParam(String groupName){
		logger.debug("selectUserGroupbyParam-------------------------------->");
		   StringBuffer sql = new StringBuffer();
		    sql.append(" select * from ( ")
		       .append(" select group_id treeNodeId,group_name treeNodeName,parent_id treeNodePid  from FPF_USER_GROUP ")
		       .append(" where group_name like ? ")
		       .append(" ) order by treeNodeId ");
		    try {
		    	return jdbcTemplate.queryForList(sql.toString(),new Object[]{"%"+groupName+"%"});
				
			} catch (Exception e) {
				
				e.printStackTrace();
				return null;
			}
	}
	
	public boolean addUserGroup(String groupId,String groupName,String parentId, int status,
			Date createTime,String beginDate,String endDate,int userlimit,int sortnum ){
		logger.debug("addUserGroup-------------------------------->");
		boolean flag = false;
		try {
			String sq1 = " insert into FPF_USER_GROUP (GROUP_ID, GROUP_NAME, PARENT_ID, STATUS, CREATE_TIME, USER_LIMIT, SORTNUM) ";
			String sql2 = " ( ?, ?, ?, ?, ? , ?, ?) ";
			 Object[] obj=new Object[]{groupId,groupName,parentId,status,createTime,userlimit,sortnum};
			if(beginDate!=null&&endDate!=null){
/*				Date sdate = Conversion.strConvertToDate(beginDate, "yyyy-MM-dd hh:mm:ss");
				Date edate = Conversion.strConvertToDate(endDate, "yyyy-MM-dd hh:mm:ss");*/
				Date sdate = Conversion.strConvertToDate(beginDate, "yyyy-MM-dd hh:mm:ss");
				Date edate = Conversion.strConvertToDate(endDate, "yyyy-MM-dd hh:mm:ss");
				sq1 = " insert into FPF_USER_GROUP (GROUP_ID, GROUP_NAME, PARENT_ID, STATUS, CREATE_TIME, BEGIN_DATE, END_DATE, USER_LIMIT, SORTNUM) ";
				sql2 = " ( ?, ?, ?, ?, ? , ?, ?, ?, ?) ";
				obj=new Object[]{groupId,groupName,parentId,status,createTime,sdate,edate,userlimit,sortnum};
			}
			StringBuffer _sql = new StringBuffer();
			 _sql.append(sq1)
			 	 .append(" values ")
			 	 .append(sql2);
			 jdbcTemplate.update(_sql.toString(), obj);
			 flag = true;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		 return flag;
	}
	
	public boolean updateUserGroup(String groupId,String groupName,String parentId, int status,
				String beginDate,String endDate,int userlimit,int sortnum ){
		logger.debug("updateUserGroup-------------------------------->");
		boolean flag = false;
		try {
			StringBuffer _sql = new StringBuffer();
			String sq1 = " GROUP_NAME = ? , PARENT_ID = ? , STATUS = ? , USER_LIMIT = ? , SORTNUM = ? ";
			 Object[] obj=new Object[]{groupName,parentId,status,userlimit,sortnum,groupId};
			if(beginDate!=null&&endDate!=null){
				Date sdate = Conversion.strConvertToDate(beginDate, "yyyy-MM-dd hh:mm:ss");
				Date edate = Conversion.strConvertToDate(endDate, "yyyy-MM-dd hh:mm:ss");
				sq1 = " GROUP_NAME = ? , PARENT_ID = ? , STATUS = ? , BEGIN_DATE = ? , END_DATE = ? , USER_LIMIT = ? , SORTNUM = ? ";
				obj=new Object[]{groupName,parentId,status,sdate,edate,userlimit,sortnum,groupId};
			}
			 _sql.append(" update FPF_USER_GROUP ")
			 	 .append(" SET ")
			 	 .append(sq1)
			 	 .append(" WHERE  GROUP_ID = ? ");
			 jdbcTemplate.update(_sql.toString(), obj);
			 flag = true;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		 return flag;
	}
	 
	
	
	public boolean updateUserGroupMap(String userId,String groupId,String oldGroupId){
		logger.debug("updateUserGroupMap-------------------------------->");
		boolean flag = true;
		 
		try {
			StringBuffer _sql = new StringBuffer();
			 _sql.append(" update FPF_USER_GROUP_MAP ")
			 	 .append(" set GROUP_ID = ? ")
			 	 .append(" where USERID = ? AND GROUP_ID = ? ");
			 Object[] obj=new Object[]{groupId,userId,oldGroupId};
			 jdbcTemplate.update(_sql.toString(), obj);
			 flag = true;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		
		return flag;
	}
	
	public Map<String,Object> getDetailUserGroupbygid(String groupId){
		logger.debug("getDetailUserGroupbygid-------------------------------->");
		try {
			String _sql = " select * from FPF_USER_GROUP where GROUP_ID = ? ";
			return jdbcTemplate.queryForMap(_sql, new Object[]{groupId});
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return null;
	}
	
	public Map<String,Object> getDetailUserGroupbyuid(String userId){
		logger.debug("getDetailUserGroupbyuid-------------------------------->");
		try {
			String _sql = " select userid group_id, username group_name from FPF_USER_USER where USERID = ? ";
			Map<String,Object> map = jdbcTemplate.queryForMap(_sql, new Object[]{userId});
			return map;
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}
	}
	

	public boolean updateGroupName(String menuId, String menuItemTitle) {
		
		
		
		logger.debug("updateGroupName-------------------------------->");
		boolean flag = false;
		try {
			String sql = " update FPF_USER_GROUP set GROUP_NAME = ? where group_id = ? ";
			jdbcTemplate.update(sql, new Object[]{menuItemTitle,menuId});
			flag = true;
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return flag;
	}
	
	public List<Map<String, Object>> getConnectRole(String groupId, String roleName){
		logger.debug("getConnectRole-------------------------------->");
		String sql = "select a.role_id roleid, b.role_name rolename, char(b.create_time) createtime from FPF_GROUP_ROLE_MAP a " +
				" left join FPF_USER_ROLE b on a.role_id=b.role_id where group_id=?";
		if(!StringUtils.isEmpty(roleName)){
			sql += " and b.role_name like '%" + roleName + "%'";
		}
		sql += " order by a.role_id";
		try {
			return jdbcTemplate.queryForList(sql, new Object[]{groupId});
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}
	}
	
	public void delRole(String groupId, String roleIds){
		logger.debug("delRole-------------------------------->");
		try {
			String sql = "delete from FPF_GROUP_ROLE_MAP where group_id='" + groupId + "' and role_id in (" + roleIds + ")";
			jdbcTemplate.update(sql);
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}
	}
	
	public void addRole(String groupId, String roleId){
		logger.debug("addRole-------------------------------->");
		try {
			String sql = "insert into FPF_GROUP_ROLE_MAP (group_id, role_id) values (?,?)";
			jdbcTemplate.update(sql, new Object[]{groupId, roleId});
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}
	}
	
	public List<Map<String, Object>> getUnConnectRole(String groupId, String roleName){
		logger.debug("getUnConnectRole-------------------------------->");
		String sql = "select role_id roleid, role_name rolename, char(create_time) createtime from FPF_USER_ROLE " +
				" where role_id not in (select role_id from FPF_GROUP_ROLE_MAP where group_id=?)";
		if(!StringUtils.isEmpty(roleName)){
			sql += " and role_name like '%" + roleName + "%'";
		}
		sql += " order by role_id";
		try {
			return jdbcTemplate.queryForList(sql, new Object[]{groupId});
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}
	}
}
