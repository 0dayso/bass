package com.asiainfo.hb.gbas.model;

public class TaskConfig {
	
	private String taskId;
	private String sqlDescribe;
	private String remark;
	private String unitCode;
	private String fileStandBy;
	private String filterType;
	private String status;
	private String taskType;
	private String execPath;
	private String execName;
	private String ftpFlag;
	private String createSh;
	
	public String getTaskId() {
		return taskId;
	}
	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}
	public String getSqlDescribe() {
		return sqlDescribe;
	}
	public void setSqlDescribe(String sqlDescribe) {
		this.sqlDescribe = sqlDescribe;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getUnitCode() {
		return unitCode;
	}
	public void setUnitCode(String unitCode) {
		this.unitCode = unitCode;
	}
	public String getFileStandBy() {
		return fileStandBy;
	}
	public void setFileStandBy(String fileStandBy) {
		this.fileStandBy = fileStandBy;
	}
	public String getFilterType() {
		return filterType;
	}
	public void setFilterType(String filterType) {
		this.filterType = filterType;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getTaskType() {
		return taskType;
	}
	public void setTaskType(String taskType) {
		this.taskType = taskType;
	}
	public String getExecPath() {
		return execPath;
	}
	public void setExecPath(String execPath) {
		this.execPath = execPath;
	}
	public String getExecName() {
		return execName;
	}
	public void setExecName(String execName) {
		this.execName = execName;
	}
	public String getFtpFlag() {
		return ftpFlag;
	}
	public void setFtpFlag(String ftpFlag) {
		this.ftpFlag = ftpFlag;
	}
	public String getCreateSh() {
		return createSh;
	}
	public void setCreateSh(String createSh) {
		this.createSh = createSh;
	}
	
	@Override
	public String toString() {
		return "TaskConfig [taskId=" + taskId + ", sqlDescribe=" + sqlDescribe
				+ ", remark=" + remark + ", unitCode=" + unitCode
				+ ", fileStandBy=" + fileStandBy + ", filterType=" + filterType
				+ ", status=" + status + ", taskType=" + taskType
				+ ", execPath=" + execPath + ", execName=" + execName
				+ ", ftpFlag=" + ftpFlag + ", createSh=" + createSh + "]";
	}
	
}
