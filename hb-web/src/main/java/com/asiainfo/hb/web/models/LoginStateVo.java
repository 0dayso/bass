package com.asiainfo.hb.web.models;

import java.io.Serializable;

/**
 * 登录的返回状态
 * @author Mei Kefu
 */
@SuppressWarnings("serial")
public class LoginStateVo implements Serializable {
	private boolean success;
	private String msg;
	
	public boolean isSuccess() {
		return success;
	}
	public void setSuccess(boolean success) {
		this.success = success;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
}
