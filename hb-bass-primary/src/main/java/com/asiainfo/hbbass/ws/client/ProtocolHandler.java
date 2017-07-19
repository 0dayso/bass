package com.asiainfo.hbbass.ws.client;

public interface ProtocolHandler {

	public static final String SOAP11_NS = "http://schemas.xmlsoap.org/soap/envelope/";

	/**
	 * @param context
	 *            请求上下文
	 * @return 响应消息
	 */
	ResponseMessage execute(RequestContext context);
}
