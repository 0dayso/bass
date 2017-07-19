package com.cmsz.ws;

import javax.jws.WebService;

import com.asiainfo.hb.web.models.ResultVO;
import com.asiainfo.hb.web.models.UserInfoVO;
@WebService
public interface  UserService {
	//添加用户
	public ResultVO addUserInfo(UserInfoVO userInfo);
	//修改用户密码
	public ResultVO modifyUserPwd(String loginUser,String newPassword);
	//删除用户
	public ResultVO delUserInfo (String loginUsers);
}
