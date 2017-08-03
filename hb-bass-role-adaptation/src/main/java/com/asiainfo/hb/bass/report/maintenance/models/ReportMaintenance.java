package com.asiainfo.hb.bass.report.maintenance.models;

import java.io.Serializable;

/**
 * 报表维护表
 * 
 * @author king-pan
 *
 */
public class ReportMaintenance implements Serializable {

	private static final long serialVersionUID = 1L;
	/**
	 * 主键ID
	 */
	private String id;
	/**
	 * 报表id
	 */
	private String reportId;
	/**
	 * '报表名称';
	 */
	private String reportName;
	/**
	 * 后台程序名
	 */
	private String procedureName;
	/**
	 * 开发人员
	 */
	private String developerName;
	/**
	 * 负责人
	 */
	private String manager;
	/**
	 * 重要级别
	 */
	private String level;
	/**
	 * 重要级别
	 */
	private String levelVal;
	/**
	 * 是否云化上线
	 */
	private String online;
	/**
	 * 是否云化上线
	 */
	private String onlineVal;
	/**
	 * 是否交维
	 */
	private String maintenance;
	/**
	 * 是否交维
	 */
	private String maintenanceVal;
	/**
	 * 期望数据最晚到达时间
	 */
	private String expectationDate;
	/**
	 * 实际数据到达时间
	 */
	private String actualDate;
	
	

	public String getExpectationDate() {
		return expectationDate;
	}

	public void setExpectationDate(String expectationDate) {
		this.expectationDate = expectationDate;
	}

	public String getActualDate() {
		return actualDate;
	}

	public void setActualDate(String actualDate) {
		this.actualDate = actualDate;
	}

	public String getLevelVal() {
		return levelVal;
	}

	public void setLevelVal(String levelVal) {
		this.levelVal = levelVal;
	}

	public String getOnlineVal() {
		return onlineVal;
	}

	public void setOnlineVal(String onlineVal) {
		this.onlineVal = onlineVal;
	}

	public String getMaintenanceVal() {
		return maintenanceVal;
	}

	public void setMaintenanceVal(String maintenanceVal) {
		this.maintenanceVal = maintenanceVal;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getReportId() {
		return reportId;
	}

	public void setReportId(String reportId) {
		this.reportId = reportId;
	}

	public String getReportName() {
		return reportName;
	}

	public void setReportName(String reportName) {
		this.reportName = reportName;
	}

	public String getProcedureName() {
		return procedureName;
	}

	public void setProcedureName(String procedureName) {
		this.procedureName = procedureName;
	}

	public String getDeveloperName() {
		return developerName;
	}

	public void setDeveloperName(String developerName) {
		this.developerName = developerName;
	}

	public String getManager() {
		return manager;
	}

	public void setManager(String manager) {
		this.manager = manager;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public String getOnline() {
		return online;
	}

	public void setOnline(String online) {
		this.online = online;
	}

	public String getMaintenance() {
		return maintenance;
	}

	public void setMaintenance(String maintenance) {
		this.maintenance = maintenance;
	}

	@Override
	public String toString() {
		return "ReportMaintenance [id=" + id + ", reportId=" + reportId + ", reportName=" + reportName
				+ ", procedureName=" + procedureName + ", developerName=" + developerName + ", manager=" + manager
				+ ", level=" + level + ", levelVal=" + levelVal + ", online=" + online + ", onlineVal=" + onlineVal
				+ ", maintenance=" + maintenance + ", maintenanceVal=" + maintenanceVal + ", expectationDate="
				+ expectationDate + ", actualDate=" + actualDate + "]";
	}
}
