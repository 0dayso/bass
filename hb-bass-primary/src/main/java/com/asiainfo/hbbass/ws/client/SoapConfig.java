package com.asiainfo.hbbass.ws.client;

import java.io.Serializable;

public class SoapConfig implements Serializable {

	private static final long serialVersionUID = 54235653L;

	/**
	 * ip
	 * 235:测试IP
	 * 238:正式IP
	 */
//	private String ip = "10.25.5.235";
	private String ip = "10.25.5.238";
//	private String ip = "10.31.81.245";

	/**
	 * 端口
	 */
	private int port = 8080;
	//private int port = 8086;
	/**
	 * 网关服务uri
	 */
	private String uri = "/bsbiam/services/SoapTreasury4A";
	//private String uri = "/ws/IFacadeService";

	/**
	 * 连接超时
	 */
	private int connectionTimeout = 3 * 1000;
	/**
	 * 接收超时
	 */
	private int receiveTimeout = 100 * 1000;

	public SoapConfig() {
		super();
	}

	public SoapConfig(String ip, int port, String uri) {
		super();
		this.ip = ip;
		this.port = port;
		this.uri = uri;
	}

	public SoapConfig(String ip, int port, String uri, int connectionTimeout, int receiveTimeout) {
		super();
		this.ip = ip;
		this.port = port;
		this.uri = uri;
		this.connectionTimeout = connectionTimeout;
		this.receiveTimeout = receiveTimeout;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public int getPort() {
		return port;
	}

	public void setPort(int port) {
		this.port = port;
	}

	public String getUri() {
		return uri;
	}

	public void setUri(String uri) {
		this.uri = uri;
	}

	public int getConnectionTimeout() {
		return connectionTimeout;
	}

	public void setConnectionTimeout(int connectionTimeout) {
		this.connectionTimeout = connectionTimeout;
	}

	public int getReceiveTimeout() {
		return receiveTimeout;
	}

	public void setReceiveTimeout(int receiveTimeout) {
		this.receiveTimeout = receiveTimeout;
	}
}
