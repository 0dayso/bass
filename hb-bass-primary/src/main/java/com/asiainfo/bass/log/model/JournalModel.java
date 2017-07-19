package com.asiainfo.bass.log.model;

public class JournalModel extends UtilModel{
	private String loginname;
	private String uri;
	public String getUri() {
		return uri;
	}
	public void setUri(String uri) {
		this.uri = uri;
	}
	public String getLoginname() {
		return loginname;
	}
	public void setLoginname(String loginname) {
		this.loginname = loginname;
	}
}
