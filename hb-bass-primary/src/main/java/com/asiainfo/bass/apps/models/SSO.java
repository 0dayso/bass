package com.asiainfo.bass.apps.models;

import java.util.HashMap;

@SuppressWarnings("unchecked")
public class SSO {
	@SuppressWarnings("rawtypes")
	public static final HashMap RESULT_MSG = new HashMap();

	static {
		RESULT_MSG.put("UNAUTHORIZED_IP_ACCESS", "非法的IP访问");
		RESULT_MSG.put("OK", "验证成功");
		RESULT_MSG.put("USER_UNLOGIN", "用户没有登陆");
		RESULT_MSG.put("SYS_ERROR", "系统错误");
		RESULT_MSG.put("SYS_ERROR_DB", "数据库错误");
		RESULT_MSG.put("SYS_ERROR_NO_PARAMETER", "参数不完整");
		RESULT_MSG.put("SYS_ERROR_NO_AUTHORIZATION", "没有对应的授权");
	}
}
