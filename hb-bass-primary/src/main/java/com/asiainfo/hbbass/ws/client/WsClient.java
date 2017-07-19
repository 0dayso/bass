package com.asiainfo.hbbass.ws.client;

import java.io.PrintWriter;
import java.io.StringWriter;

public class WsClient {
	private SoapConfig soapConfig = new SoapConfig();
	private ProtocolHandler protocolHandler;

	private WsClient() {
	}

	private static WsClient instance = null;

	public static WsClient getInstance() {
		if (instance == null) {
			instance = new WsClient();
		}
		return instance;
	}

	public WsClient(SoapConfig soapConfig, ProtocolHandler protocolHandler) {
		this.soapConfig = soapConfig;
		this.protocolHandler = protocolHandler;
	}

	public ResponseMessage call(RequestMessage requestMessage) {
		if (requestMessage == null) {
			throw new IllegalArgumentException();
		}
		ResponseMessage responseMessage = null;
		RequestContext context = null;
		try {
			context = new RequestContext(this.soapConfig);
			context.setRequestMessage(requestMessage);
		} catch (Exception e) {
			responseMessage = buildExceptivelyResponseMessage("ASIP-0010", "客户端异常，以下是异常堆栈信息：\n"
					+ getExceptionTrace(e), context);
		}
		try {
			if (responseMessage == null) {
				protocolHandler = new SOAPProtocolHandler();
				responseMessage = protocolHandler.execute(context);
			}
		} catch (Exception e) {
			responseMessage = buildExceptivelyResponseMessage("ASIP-0020", "客户端异常，以下是异常堆栈信息：\n"
					+ getExceptionTrace(e), context);
		}
		return responseMessage;
	}

	protected static ResponseMessage buildExceptivelyResponseMessage(String errorCode, String errorInfo,
			RequestContext context) {
		ResponseMessage responseMessage = new ResponseMessage();
		responseMessage.setServiceName(context.getRequestMessage().getServiceName());
		responseMessage.setMsgType("response");
		responseMessage.setErrorCode(errorCode);
		responseMessage.setErrorInfo(errorInfo);
		return responseMessage;
	}

	protected static String getExceptionTrace(Throwable e) {
		if (e != null) {
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			return sw.toString();
		} else {
			return "No Exception";
		}
	}

	public SoapConfig getAsipConfig() {
		return soapConfig;
	}

	public void setAsipConfig(SoapConfig asipConfig) {
		this.soapConfig = asipConfig;
	}

	public ProtocolHandler getProtocolHandler() {
		return protocolHandler;
	}

	public void setProtocolHandler(ProtocolHandler protocolHandler) {
		this.protocolHandler = protocolHandler;
	}
}
