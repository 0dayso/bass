package com.asiainfo.bass.apps.models;

import java.io.Serializable;
import org.springframework.stereotype.Service;

/**
 * @author mei xianxin
 * @date 2013-1-9
 * 
 */
@Service
public class LogBass implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -683611220109185122L;

	private String userId;// 操作员账号
	private String operTime;// 操作时间
	private String ip;// 客户端IP
	private String appServ;// 服务器IP
	private String operType;// 操作类型 3 帐号管理事件 4 口令管理事件 5 权限变更事件
	private String operName;// 操作名称
	private String appCode;// 应用编号
	private String appName;// 应用名称
	private String modCode;// 模块编号
	private String modName;// 模块名称
	private String operContent;// 操作内容
	private String operResult;/*
								 * 操作结果 1 新增帐号成功 2 新增帐号失败 3 修改帐号成功 4 修改帐号失败 5
								 * 删除帐号成功 6 删除帐号失败 7 修改密码成功 8 修改密码失败 9 新增角色权限成功
								 * 10 新增角色权限失败 11 删除角色权限成功 12 删除角色权限失败 13
								 * 新增用户权限成功 14 新增用户权限失败 15 删除用户权限成功 16 用户权限失败删除
								 */

	/**
	 * @return the userId
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * @param userId
	 *            the userId to set
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * @return the operTime
	 */
	public String getOperTime() {
		return operTime;
	}

	/**
	 * @param operTime
	 *            the operTime to set
	 */
	public void setOperTime(String operTime) {
		this.operTime = operTime;
	}

	/**
	 * @return the ip
	 */
	public String getIp() {
		return ip;
	}

	/**
	 * @param ip
	 *            the ip to set
	 */
	public void setIp(String ip) {
		this.ip = ip;
	}

	/**
	 * @return the appServ
	 */
	public String getAppServ() {
		return appServ;
	}

	/**
	 * @param appServ
	 *            the appServ to set
	 */
	public void setAppServ(String appServ) {
		this.appServ = appServ;
	}

	/**
	 * @return the operType
	 */
	public String getOperType() {
		return operType;
	}

	/**
	 * @param operType
	 *            the operType to set
	 */
	public void setOperType(String operType) {
		this.operType = operType;
	}

	/**
	 * @return the operName
	 */
	public String getOperName() {
		return operName;
	}

	/**
	 * @param operName
	 *            the operName to set
	 */
	public void setOperName(String operName) {
		this.operName = operName;
	}

	/**
	 * @return the appCode
	 */
	public String getAppCode() {
		return appCode;
	}

	/**
	 * @param appCode
	 *            the appCode to set
	 */
	public void setAppCode(String appCode) {
		this.appCode = appCode;
	}

	/**
	 * @return the appName
	 */
	public String getAppName() {
		return appName;
	}

	/**
	 * @param appName
	 *            the appName to set
	 */
	public void setAppName(String appName) {
		this.appName = appName;
	}

	/**
	 * @return the modCode
	 */
	public String getModCode() {
		return modCode;
	}

	/**
	 * @param modCode
	 *            the modCode to set
	 */
	public void setModCode(String modCode) {
		this.modCode = modCode;
	}

	/**
	 * @return the modName
	 */
	public String getModName() {
		return modName;
	}

	/**
	 * @param modName
	 *            the modName to set
	 */
	public void setModName(String modName) {
		this.modName = modName;
	}

	/**
	 * @return the operContent
	 */
	public String getOperContent() {
		return operContent;
	}

	/**
	 * @param operContent
	 *            the operContent to set
	 */
	public void setOperContent(String operContent) {
		this.operContent = operContent;
	}

	/**
	 * @return the operResult
	 */
	public String getOperResult() {
		return operResult;
	}

	/**
	 * @param operResult
	 *            the operResult to set
	 */
	public void setOperResult(String operResult) {
		this.operResult = operResult;
	}

}
