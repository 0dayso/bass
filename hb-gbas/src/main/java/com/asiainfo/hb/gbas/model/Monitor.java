package com.asiainfo.hb.gbas.model;

public class Monitor {
	
	private String chkId;
	private String name;
	//类型
	private String type;
	//群组id(分号分割)
	private String groupId;
	//手机号(分号分割)
	private String accNbr;
	//创建时间
	private String createDate;
	//下次告警时间
	private String nextTime;
	//开始时间
	private String startTime;
	//结束时间
	private String endTime;
	//间隔类型:month,day,minute
	private String cycle;
	//间隔
	private String warnInterval;
	private String sqlDef;
	//错误次数超过30次,不再告警
	private String errTimes;
	public String getChkId() {
		return chkId;
	}
	public void setChkId(String chkId) {
		this.chkId = chkId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}
	public String getAccNbr() {
		return accNbr;
	}
	public void setAccNbr(String accNbr) {
		this.accNbr = accNbr;
	}
	public String getCreateDate() {
		return createDate;
	}
	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
	public String getNextTime() {
		return nextTime;
	}
	public void setNextTime(String nextTime) {
		this.nextTime = nextTime;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public String getCycle() {
		return cycle;
	}
	public void setCycle(String cycle) {
		this.cycle = cycle;
	}
	public String getWarnInterval() {
		return warnInterval;
	}
	public void setWarnInterval(String warnInterval) {
		this.warnInterval = warnInterval;
	}
	public String getSqlDef() {
		return sqlDef;
	}
	public void setSqlDef(String sqlDef) {
		this.sqlDef = sqlDef;
	}
	public String getErrTimes() {
		return errTimes;
	}
	public void setErrTimes(String errTimes) {
		this.errTimes = errTimes;
	}
	
	@Override
	public String toString() {
		return "Monitor [chkId=" + chkId + ", name=" + name + ", type=" + type
				+ ", groupId=" + groupId + ", accNbr=" + accNbr
				+ ", createDate=" + createDate + ", nextTime=" + nextTime
				+ ", startTime=" + startTime + ", endTime=" + endTime
				+ ", cycle=" + cycle + ", warnInterval=" + warnInterval
				+ ", sqlDef=" + sqlDef + ", errTimes=" + errTimes + "]";
	}
}
