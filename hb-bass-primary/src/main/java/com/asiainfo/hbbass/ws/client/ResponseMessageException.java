package com.asiainfo.hbbass.ws.client;

public class ResponseMessageException extends Exception {

	private static final long serialVersionUID = 1L;

	public ResponseMessageException() {
	}

	public ResponseMessageException(String message, Throwable cause) {
		super(message, cause);
	}

	public ResponseMessageException(String message) {
		super(message);
	}

	public ResponseMessageException(Throwable cause) {
		super(cause);
	}
}
