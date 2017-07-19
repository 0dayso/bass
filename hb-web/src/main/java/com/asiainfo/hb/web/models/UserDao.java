package com.asiainfo.hb.web.models;

import java.util.List;

/**
 *
 * @author Mei Kefu
 * @date 2011-2-12
 */
public interface UserDao {
	public User getUserById(String id);
	
	public User getLoginUser(String id);
	
	public List<User> getUsersByName(String userName);
	
	public User saveUserFace(String userId,String userFace);//设置头像
	
	public void addUser(UserInfoVO userInfo);
	
	public int updatePwd(String userId, String pwd);
	
	public void insertPwdHistory(String userId, String newPwd);
	
	public int delUser(String userId);

	public boolean modify(String userName, String password1);
}
