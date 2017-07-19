package com.asiainfo.hbbass.ws.client;

public class RequestMessage extends Message {
	private String serviceName = "";
	private String parameterName = "";
	private String serviceResponse = "";
	private String serviceResult = "";

	public RequestMessage(String reqXml, String serviceName, String parameterName, String serviceResponse,
			String serviceResult) {
		this.reqXml = reqXml;
		this.serviceName = serviceName;
		this.parameterName = parameterName;
		this.serviceResponse = serviceResponse;
		this.serviceResult = serviceResult;
	}

	public RequestMessage() {
		super();
	}

	public String toString() {
		return reqXml.toString();
	}

	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	public String getParameterName() {
		return parameterName;
	}

	public void setParameterName(String parameterName) {
		this.parameterName = parameterName;
	}

	public String getServiceResponse() {
		return serviceResponse;
	}

	public void setServiceResponse(String serviceResponse) {
		this.serviceResponse = serviceResponse;
	}

	public String getServiceResult() {
		return serviceResult;
	}

	public void setServiceResult(String serviceResult) {
		this.serviceResult = serviceResult;
	}
}
