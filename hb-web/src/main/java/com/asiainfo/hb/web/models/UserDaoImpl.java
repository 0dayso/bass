package com.asiainfo.hb.web.models;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.RowMapper;

import com.asiainfo.hb.core.models.JdbcTemplate;

/**
 *
 * @author Mei Kefu
 * @date 2011-2-12
 */
public class UserDaoImpl implements UserDao {

	private static Logger LOG = Logger.getLogger(UserDaoImpl.class);
	
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
	
	@SuppressWarnings("unchecked")
	public User getUserById(String id){
		User user = null;
		String sql = "select userid id,username name, pwd,mobilephone phone,email mail,status status,cityid regionId,face_img,group_id,group_name,cityid,region_id,area_name,c.area_code,c.area_id, "
				+"(select a.group_id from fpf_user_group a,fpf_user_group_map b where a.group_name='超级管理员用户组' and a.group_id=b.group_id and b.userid = ?) isAdmin from FPF_USER_USER"
				+",(select userid uids,min(group_id) gid  from FPF_USER_GROUP_MAP group by userid) a"
				+",(select group_id,max(group_name) group_name from FPF_USER_GROUP group by group_id) b"
				+",(SELECT AREA_CODE,AREA_NAME,area_id FROM FPF_BT_AREA ) c"
				+" where userid=? and userid=uids and gid=group_id and c.area_id=cityid";
			
		try{
			user=(User)this.jdbcTemplate.queryForObject(sql,new Object[]{id,id} ,new UserMapper2() );
		}catch(EmptyResultDataAccessException e){
			LOG.info("查询数据为空ID:"+id);
			user = new User(id,id);
		}catch(Exception e){
			LOG.error(e.getMessage(),e);
			e.printStackTrace();
			user = new User(id,id);
		}
		return user;
	}
	
	@SuppressWarnings("unchecked")
	public User getLoginUser(String id){
		User user = null;
		String sql = " select userid id, username name,pwd,mobilephone phone,email mail,status status,cityid regionId,cityid,face_img,t.group_id,t.group_name,region_id,value((select area_name from FPF_BT_AREA where int(cityid)=area_id),'省公司') area_name,(select area_code from FPF_BT_AREA where int(cityid)=area_id) area_code,(select area_id from FPF_BT_AREA where int(cityid)=area_id) area_id,status," +
					 " (select a.group_id from fpf_user_group a,fpf_user_group_map b where a.group_name='超级管理员用户组' and a.group_id=b.group_id and b.userid = ?) isAdmin "+
				     " from FPF_USER_USER left join " +
				     " (select userid uid,max(group_id) group_id,(select max(group_name) from FPF_USER_GROUP b where b.group_id=max(a.group_id)) group_name from FPF_USER_GROUP_MAP a group by userid) t on userid=uid where userid = ?";
		try{
			user=(User)this.jdbcTemplate.queryForObject(sql,new Object[]{id,id} ,new UserMapper2() );
			
		}catch(EmptyResultDataAccessException e){
			e.printStackTrace();
			LOG.info("查询数据为空ID:"+id);
			user = new User(id,id);
		}catch(Exception e){
			LOG.error(e.getMessage(),e);
			e.printStackTrace();
			user = new User(id,id);
		}
		return user;
	}
	//修改密码作用
	public boolean modify(String id,String password){
		String sql="update FPF_USER_USER set pwd='"+id+"' where userid ='"+id+"'";
		int a=0;
		try {
			a = this.jdbcTemplate.update(sql);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
		boolean mag=false;
		if(a>0){
			mag=true;
		}
		return mag;
		
	}
	public User saveUserFace(String userId,String userFace){//设置头像
		jdbcTemplate.update("update FPF_USER_USER set face_img=? where userid=?",new Object[]{userFace,userId});
		return getUserById(userId);
	}
	
	@SuppressWarnings("rawtypes")
	public static final class UserMapper implements RowMapper {
		public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
			User u = new User(rs.getString("id"),rs.getString("name"));
			u.setPassword(rs.getString("pwd"));
			u.setPhone(rs.getString("phone"));
			u.setMail(rs.getString("mail"));
			u.setRegionId(rs.getString("regionid"));
			u.setFace(rs.getString("face_img"));
			
			u.setCityId(rs.getString("cityid"));
			u.setGroupId(rs.getString("group_id"));
			u.setGroupName(rs.getString("group_name"));
			u.setAreaCode(rs.getString("region_id"));
			u.setAreaName(rs.getString("area_name"));
			return u;
		}
	}
	
	@SuppressWarnings("rawtypes")
	public static final class UserMapper2 implements RowMapper {
		public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
			User u = new User(rs.getString("id"),rs.getString("name"));
			u.setPassword(rs.getString("pwd"));
			u.setPhone(rs.getString("phone"));
			u.setMail(rs.getString("mail"));
			u.setRegionId(rs.getString("regionid"));
			u.setFace(rs.getString("face_img"));
			
			u.setCityId(rs.getString("cityid"));
			u.setGroupId(rs.getString("group_id"));
			u.setGroupName(rs.getString("group_name"));
			u.setAreaCode(rs.getString("region_id"));
			u.setAreaName(rs.getString("area_name"));
			u.setSperAdmin(rs.getObject("isAdmin")==null?0:1);
			u.setStatus(rs.getInt("status"));
			return u;
		}
	}
	
	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<User> getUsersByName(String userName) {
		String sql = "select userid id,username name, pwd,mobilephone phone,email mail,cityid regionId,face_img,group_id,group_name,cityid from FPF_USER_USER"
				+",(select userid uid,min(group_id) gid  from FPF_USER_GROUP_MAP group by userid) a"
				+",(select group_id,max(group_name) group_name from FPF_USER_GROUP group by group_id) b"
				+" where username=? and userid=uid and gid=group_id";
		
		List<User> users = (List<User>)jdbcTemplate.query(sql, new String[]{userName},new UserMapper());
		
		return users;
	}

	@Override
	public void addUser(UserInfoVO userInfo) {
		this.jdbcTemplate.update("insert into FPF_USER_USER(userid,cityid,username,pwd,createtime) values(?,?,?,?,current timestamp)", new Object[] { userInfo.getLoginUser(), userInfo.getSregion(), userInfo.getStaffName(), userInfo.getPassword() });
	}

	@Override
	public int updatePwd(String userId, String pwd) {
		return jdbcTemplate.update("update FPF_USER_USER set pwd=? where userid=?", new Object[] { pwd, userId });
	}

	@Override
	public void insertPwdHistory(String userId, String newPwd) {
		this.jdbcTemplate.update("insert into fpf_user_password_history values(?,?,current timestamp)", new Object[] { userId, newPwd });
		
	}

	@Override
	public int delUser(String userId) {
		System.out.println("userId==================" + userId);
		return jdbcTemplate.update("delete from FPF_USER_USER  where userid in(?) ", new Object[] { userId });
	}
}
