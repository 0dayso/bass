package com.asiainfo.bass.components.models;

public class TimeoutException extends RuntimeException {

	private static final long serialVersionUID = -8078853655388692688L;

	public TimeoutException(String errMessage) {
		super(errMessage);
	}
}