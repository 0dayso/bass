package com.cmsz.ws;

import javax.jws.WebService;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.bass.apps.models.LogDao;
import com.asiainfo.hb.web.models.ResultVO;
import com.asiainfo.hb.web.models.UserDao;
import com.asiainfo.hb.web.models.UserInfoVO;

@WebService(endpointInterface="com.cmsz.ws.UserService",targetNamespace="http://impl.ws.com") 
@Service("userServiceImp")
public class UserServiceImp implements UserService {
	private static Logger LOG = Logger.getLogger(UserServiceImp.class);
	@Autowired
	private UserDao userDao;
	@Autowired
	private LogDao logDao;
	
	public UserServiceImp() {
	}

	public UserDao getUserDao() {
		return userDao;
	}

	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}

	public LogDao getLogDao() {
		return logDao;
	}

	public void setLogDao(LogDao logDao) {
		this.logDao = logDao;
	}

	@Override
	public ResultVO addUserInfo(UserInfoVO userInfo) {
		LOG.debug("新增用户");
		ResultVO rv = new ResultVO();
		//集团检查这个功能要实现
		try {
			userDao.addUser(userInfo);
			rv.setResult("0");
			rv.setResultDesc("新增用户成功");
		}catch (Exception e) {
			rv.setResult("1");
			rv.setResultDesc(e.getMessage());
			e.printStackTrace();
		}
		logDao.writeLog(userInfo.getLoginUser(),Integer.parseInt(rv.getResult()), "addUserInfo",rv.getResultDesc());
		return rv;
	}

	@Override
	public ResultVO modifyUserPwd(String loginUser, String newPassword) {
		//4a传过来就是密文，不用再加密了
		LOG.debug("4A传递的改密码参数：loginUser="+loginUser+" newPassword="+newPassword);
		ResultVO rv = new ResultVO();
		try {
//			userDao.updatePwd(loginUser, newPassword);
			if(loginUser!=null && loginUser.trim().length()>0 && newPassword!= null && newPassword.trim().length()>0){
				int result = userDao.updatePwd(loginUser,newPassword);
				LOG.debug("密码修改结果："+result);
				if(result == 1){
					userDao.insertPwdHistory(loginUser,newPassword);
					rv.setResult("0");
					rv.setResultDesc("密码修改成功");
				}else{
					rv.setResult("1");
					rv.setResultDesc("用户名不存在");
				}
			}
			
		} catch (Exception e) {
			rv.setResult("1");
			rv.setResultDesc(e.getMessage());
			e.printStackTrace();
		}
		logDao.writeLog(loginUser,Integer.parseInt(rv.getResult()), "modifyUserPwd",rv.getResultDesc());
		return rv;
	}

	@Override
	public ResultVO delUserInfo(String loginUsers) {
		LOG.info("4A传递的删除用户参数："+loginUsers);
		ResultVO rv = new ResultVO();
		try {
			if(loginUsers!=null && loginUsers.trim().length()>0){
//				String[] users = loginUsers.split(",");
//				if(users.length>1){
//					for(int i=0;i<users.length;i++){
//						loginUsers = "'"+users[i]+"',";
//					}
//					loginUsers = loginUsers.substring(0, loginUsers.length()-1);
//				}else{
//					loginUsers = "'"+loginUsers+"'";
//				}
				LOG.info("实际删除的用户："+loginUsers);
				int result = userDao.delUser(loginUsers);
				LOG.info("实际删除的用户数："+result);
				if(result>=1){
					rv.setResult("0");
					rv.setResultDesc("用户删除成功");
				}else{
					rv.setResult("1");
					rv.setResultDesc("用户名不存在");
				}
			}else{
				rv.setResult("1");
				rv.setResultDesc("用户名参数有误");
			}
			
		} catch (Exception e) {
			rv.setResult("1");
			rv.setResultDesc(e.getMessage());
			e.printStackTrace();
		}
		logDao.writeLog(loginUsers,Integer.parseInt(rv.getResult()), "delUserInfo",rv.getResultDesc());
		return rv;
	}

}
