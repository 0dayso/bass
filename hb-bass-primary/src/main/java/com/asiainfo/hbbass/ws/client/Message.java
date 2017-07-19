package com.asiainfo.hbbass.ws.client;

public abstract class Message {
	protected String appId = "";
	protected String requestTime = "";
	protected String method = "";
	protected String msgType = "";
	protected String clientIp = "";
	protected String reqXml = "";

	public Message() {
		super();
	}

	public Message(String appId, String requestTime, String method, String msgType, String clientIp,
			String reqXml) {
		super();
		this.appId = appId;
		this.requestTime = requestTime;
		this.method = method;
		this.msgType = msgType;
		this.clientIp = clientIp;
		this.reqXml = reqXml;
	}

	public String getAppId() {
		return appId;
	}

	public void setAppId(String appId) {
		this.appId = appId;
	}

	public String getRequestTime() {
		return requestTime;
	}

	public void setRequestTime(String requestTime) {
		this.requestTime = requestTime;
	}

	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public String getMsgType() {
		return msgType;
	}

	public void setMsgType(String msgType) {
		this.msgType = msgType;
	}

	public String getClientIp() {
		return clientIp;
	}

	public void setClientIp(String clientIp) {
		this.clientIp = clientIp;
	}

	public String getReqXml() {
		return reqXml;
	}

	public void setReqXml(String reqXml) {
		this.reqXml = reqXml;
	}
}
