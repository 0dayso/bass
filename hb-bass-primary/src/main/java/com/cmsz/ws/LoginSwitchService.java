package com.cmsz.ws;

import javax.jws.WebService;

import com.asiainfo.hb.web.models.ResultVO;
@WebService
public interface LoginSwitchService {
	/**
	 * 输入参数为：flag，开关标志位0表示4a认证功能开启，用户将通过4a认证登录应用。
	 * Flag值置为 1表示4a认证功能关闭，用户采用应用本地认证方式登录
	 * @param flag
	 * @return
	 */
	public ResultVO loginModChg (String flag);
}
