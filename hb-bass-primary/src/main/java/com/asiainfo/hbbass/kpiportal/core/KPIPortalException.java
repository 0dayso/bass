package com.asiainfo.hbbass.kpiportal.core;

public class KPIPortalException extends RuntimeException {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1109727023145136091L;

	public KPIPortalException() {
		
	}

	public KPIPortalException(Exception e) {
		super(e);
	}

	public KPIPortalException(String message) {
		super(message);
	}
}
