package com.asiainfo.hbbass.ws.interfaceclient;

import org.apache.commons.lang.StringUtils;

import com.asiainfo.hbbass.ws.client.RequestMessage;
import com.asiainfo.hbbass.ws.client.ResponseMessage;
import com.asiainfo.hbbass.ws.client.WsClient;

public class InterfaceClient {
	private InterfaceClient() {
	}

	private static InterfaceClient instance = null;

	public static InterfaceClient getInstance() {
		if (instance == null) {
			instance = new InterfaceClient();
		}
		return instance;
	}

	/**
	 * @param reqXml
	 *            请求报文
	 * @param serviceName
	 *            请求报文服务名称
	 * @param parameterName
	 *            请求报文参数名称
	 * @param serviceResponse
	 *            返回报文response名称
	 * @param serviceResult
	 *            返回报文result名称
	 * @return
	 */
	public String execute(String reqXml, String serviceName, String parameterName, String serviceResponse, String serviceResult) throws Exception {
		if (StringUtils.isBlank(reqXml)) {
			throw new IllegalArgumentException(serviceName + "接口调用入参reqXml错误。");
		}
		RequestMessage requestMessage = new RequestMessage(reqXml, serviceName, parameterName, serviceResponse, serviceResult);
		WsClient wsClient = WsClient.getInstance();
		ResponseMessage message = wsClient.call(requestMessage);
		if (message == null || StringUtils.isBlank(message.getResultXml())) {
			throw new IllegalArgumentException(serviceName + "接口调用返回结果异常。");
		}
		return message.getResultXml();
	}
}
