package com.asiainfo.hbbass.ws.client;

import java.io.Serializable;

public class RequestContext implements Serializable {

	private static final long serialVersionUID = 2432525345L;

	private RequestMessage requestMessage;

	private SoapConfig soapConfig;

	public RequestContext(final SoapConfig soapConfig) {
		try {
			this.soapConfig = soapConfig;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public RequestMessage getRequestMessage() {
		return requestMessage;
	}

	public void setRequestMessage(RequestMessage requestMessage) {
		this.requestMessage = requestMessage;
	}

	public SoapConfig getSoapConfig() {
		return soapConfig;
	}

	public void setSoapConfig(SoapConfig soapConfig) {
		this.soapConfig = soapConfig;
	}
}
