package com.asiainfo.hb.web.models;

import java.sql.Timestamp;

/**
 * 访问错误的url信息VO
 * @author chendb
 *
 */
public class ErrorPageInfoVO {
	
	/**
	 * 菜单ID
	 */
	private String menuItemId;
	
	/**
	 * 菜单名称
	 */
	private String menuItemTitle;

	/**
	 * 菜单url
	 */
	private String url;
	
	/**
	 * 错误代码
	 */
	private Integer errorCode;
	
	/**
	 * 错误信息
	 */
	private String errorMessage;
	
	/**
	 * 错误记录时间
	 */
	private Timestamp errorDate;
	
	/**
	 * 发送信息的电话号码
	 */
	private String sendPhoneNum;
	
	/**
	 * 发送状态：0为失败，1为成功
	 */
	private String sendState;

	public ErrorPageInfoVO() {
	}
	
	public ErrorPageInfoVO(String menuItemId, String menuItemTitle, String url) {
		super();
		this.menuItemId = menuItemId;
		this.menuItemTitle = menuItemTitle;
		this.url = url;
	}

	public ErrorPageInfoVO(String menuItemId, String menuItemTitle, String url, Integer errorCode, String errorMessage,
			Timestamp errorDate, String sendPhoneNum, String sendState) {
		super();
		this.menuItemId = menuItemId;
		this.menuItemTitle = menuItemTitle;
		this.url = url;
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
		this.errorDate = errorDate;
		this.sendPhoneNum = sendPhoneNum;
		this.sendState = sendState;
	}

	public String getSendPhoneNum() {
		return sendPhoneNum;
	}

	public void setSendPhoneNum(String sendPhoneNum) {
		this.sendPhoneNum = sendPhoneNum;
	}

	public String getSendState() {
		return sendState;
	}

	public void setSendState(String sendState) {
		this.sendState = sendState;
	}

	public String getMenuItemId() {
		return menuItemId;
	}

	public void setMenuItemId(String menuItemId) {
		this.menuItemId = menuItemId;
	}

	public String getMenuItemTitle() {
		return menuItemTitle;
	}

	public void setMenuItemTitle(String menuItemTitle) {
		this.menuItemTitle = menuItemTitle;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Integer getErrorCode() {
		return errorCode;
	}

	public void setErrorCode(Integer errorCode) {
		this.errorCode = errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public Timestamp getErrorDate() {
		return errorDate;
	}

	public void setErrorDate(Timestamp errorDate) {
		this.errorDate = errorDate;
	}
}
