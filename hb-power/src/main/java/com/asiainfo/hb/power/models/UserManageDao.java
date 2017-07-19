package com.asiainfo.hb.power.models;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.core.models.BaseDao;

@Repository
public class UserManageDao extends BaseDao {
	@Resource(name = "jdbcTemplateN")
	private NamedParameterJdbcTemplate pjdbcTemplate;

	// 单个删除
	public void delete(String userid) {
		logger.debug("delete-------------------------------->");
		try {
			String menuSql = " delete from FPF_SYS_MENUITEM_USER where user_id = ?";
			String groSql= "delete from FPF_USER_GROUP_MAP where userid = ?";
			String roleSql = "delete from FPF_USER_ROLE_MAP where userid = ?";
			String sql = "delete from FPF_USER_USER where userid = ?";
			jdbcTemplate.update(menuSql, new Object[] { userid });
			jdbcTemplate.update(groSql, new Object[] { userid });
			jdbcTemplate.update(roleSql, new Object[] { userid });
			jdbcTemplate.update(sql, new Object[] { userid });
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}
	}
	
	public List<Map<String,Object>> getUserByUid(String userid){
		logger.debug("getUserByUid-------------------------------->");
		try {
			String sql = " select * from FPF_USER_USER where userid = ? ";
			return jdbcTemplate.queryForList(sql, new Object[]{userid});
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}
	}

	// 批量删除
	public void batchDeletes(String userids) {
		logger.debug("batchDeletes-------------------------------->");
		try {
			String menuSql = " delete from FPF_SYS_MENUITEM_USER where user_id in (" + userids + "'')";
			String groSql= "delete from FPF_USER_GROUP_MAP where userid in (" + userids + "'')";
			String roleSql = "delete from FPF_USER_ROLE_MAP where userid in (" + userids + "'')";
			String sql = "delete from FPF_USER_USER where userid in (" + userids + "'')";
			jdbcTemplate.update(menuSql);
			jdbcTemplate.update(groSql);
			jdbcTemplate.update(roleSql);
			jdbcTemplate.update(sql);
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}

	}

	public Map<String, Object> findById(String id) {
		logger.debug("findById-------------------------------->");
		try {
			String sql = "select * from FPF_USER_USER where userid= ?";
			return jdbcTemplate.queryForMap(sql, new Object[] { id });
		} catch (DataAccessException e) {
			
			e.printStackTrace();
			return null;
		}
	}

	// 修改
	public void update(String userid, String username, String cityid,
			Integer status, String mobilephone, String email) {
		logger.debug("update-------------------------------->");
		try {
			String sql = "update FPF_USER_USER set username= ?,cityid= ?,status= ?,mobilephone= ?,email= ?,region_id= (select area_code from FPF_BT_AREA where area_id=?)  where userid= ?";
			jdbcTemplate.update(sql, new Object[] { username, cityid, status,
					mobilephone, email,cityid, userid });
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}
	}

	// 查询所有的用户id存入map
	public List<Map<String, Object>> findAllUserId() {
		logger.debug("findAllUserId-------------------------------->");
		try {
			String sql = "select userid from FPF_USER_USER";
			return jdbcTemplate.queryForList(sql);
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}

	}

	/**
	 * 根据条件查询用户
	 * 
	 * @param userid
	 * @param username
	 * @param cityid
	 * @param indexNum
	 * @param pageSize
	 * @return
	 */
	public List<Map<String, Object>> getUsers(String userid, String username,
			String cityid, int indexNum, int pageSize) {
		logger.debug("getUsers-------------------------------->");
		List<Map<String,Object>> result = new ArrayList<Map<String,Object>>();
		try {
			List<Object> list = new ArrayList<Object>();
			String _sql =" select a.userid,a.username,(select area_name from FPF_BT_AREA b where a.cityid=b.area_id) area_name," +
					     " decode(a.status,'0','关闭','1','启用') status,a.mobilephone,a.email,a.createtime,a.visit_area from ";
			SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
			String sql = " select * from FPF_USER_USER where 1=1 ";
			if (cityid != null && cityid.length() != 0) {
				sql = sql+" and cityid = ? ";
				list.add(cityid);
			}
			if(userid!=null&&userid.length()>0){
				sql = sql + " and userid like ? ";
				list.add("%"+userid+"%");
			}
			
			if(username!=null&&username.length()>0){
				sql = sql + " and username like ? ";
				list.add("%"+username+"%");
			}
			sql = sql +" order by createtime desc";
			sql = sqlPageHelper.getLimitSQL(sql, pageSize, indexNum, "userid");
			sql =  _sql +" ("+sql+") a";
			Object[] obj = list.toArray();
			result =  jdbcTemplate.queryForList(sql,obj);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * 查询用户的个数
	 * 
	 * @param userid
	 * @param username
	 * @param cityid
	 * @return
	 */
	public int getUserCount(String userid, String username, String cityid) {
		logger.debug("getUserCount-------------------------------->");
		String areaidsql = "";
		if (cityid != null && cityid.length() != 0) {
			areaidsql = " and cityid = " + cityid;
		}
		String sqlcount = "select count(*) from FPF_USER_USER where userid like ? and username like ? "
				+ areaidsql;
		try {
			return jdbcTemplate.queryForObject(sqlcount, new Object[] {
					"%" + userid + "%", "%" + username + "%" },Integer.class);
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return 0;
		}
	}

	// 添加用户
	public void add(String userid, String cityid, String username, String pwd,
			Integer status, String mobilephone, String email, Date createtime,String visitArea) {
		logger.debug("add-------------------------------->");
		try {
			String sql = "insert into FPF_USER_USER (USERID,CITYID,USERNAME,PWD,STATUS,MOBILEPHONE,EMAIL,CREATETIME,VISIT_AREA,region_id)"
					+ " values(?,?,?,?,?,?,?,?,?,(select area_code from FPF_BT_AREA where area_id=?))";
			jdbcTemplate.update(sql, new Object[] { userid, cityid, username, pwd,
					status, mobilephone, email, createtime,visitArea,cityid});
			
		} catch (Exception e) {
			
			e.printStackTrace();
		}
	}

	public List<Map<String, Object>> getvisitAreaList() {
		logger.debug("getvisitAreaList-------------------------------->");
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String sql = "SELECT * FROM FPF_BT_AREA ";
		try {
			list= jdbcTemplate.queryForList(sql);
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 更新visit_area表
	 * @param visitAREA
	 * @param uID
	 * @return
	 */
	public boolean updateVisitArea(String visitAREA, String uID) {
		logger.debug("updateVisitArea-------------------------------->");
		boolean flag = false;
		
		try {
			String sql = " update FPF_USER_USER SET VISIT_AREA = ? WHERE USERID = ?";
			jdbcTemplate.update(sql, new Object[]{visitAREA,uID});
			flag = true;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		return flag;
	}
	
	/**
	 * 通过ID查询地市名称
	 * @param areaId
	 * @return
	 */
	public Map<String, Object> getAreaNameByAid(String areaId){
		logger.debug("getAreaNameByAid-------------------------------->");
		String sql="select area_name areaname from FPF_BT_AREA where area_id=?";
		try {
			return jdbcTemplate.queryForMap(sql, new Object[]{areaId});
			
		} catch (Exception e) {
			
			e.printStackTrace();
			return null;
		}
	}
	
	
	
}

