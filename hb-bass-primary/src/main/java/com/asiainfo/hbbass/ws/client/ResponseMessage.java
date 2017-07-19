package com.asiainfo.hbbass.ws.client;

import org.apache.commons.lang.StringUtils;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;

public class ResponseMessage extends Message {
	private String errorCode;
	private String errorInfo;
	private String serviceName;
	private String resultXml;

	public boolean isSuc() {
		return "ASIP-0000".equals(this.getErrorCode());
	}

	public ResponseMessage() {
		super();
	}

	public static ResponseMessage newInstance(String xml) throws ResponseMessageException {
		ResponseMessage message = new ResponseMessage();
		if (StringUtils.isBlank(xml)) {
			throw new IllegalArgumentException("接口响应xml串不能为空");
		}
		try {
			DocumentHelper.parseText(xml);
			message.setResultXml(xml);
		} catch (DocumentException e) {
			throw new ResponseMessageException("解析服务响应出错。", e);
		}
		return message;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorInfo() {
		return errorInfo;
	}

	public void setErrorInfo(String errorInfo) {
		this.errorInfo = errorInfo;
	}

	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	public String getResultXml() {
		return resultXml;
	}

	public void setResultXml(String resultXml) {
		this.resultXml = resultXml;
	}
}
