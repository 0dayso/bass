package com.asiainfo.hb.gbas.model;

public class ZbDef {
	
	private String zbCode;
	private String zbName;
	/**一经、省内*/
	private String zbType;
	/**sql配置*/
	private String zbDef;
	/**依赖程序*/
	private String procDepend;
	/**依赖的gbas指标,规则,接口*/
	private String gbasDepend;
	/**上线状态,0开发,1上线,默认0,与流程相关,数值待定*/
	private String status;
	/**周期daily,monthly*/
	private String cycle;
	/**上线时间*/
	private String onlineDate;
	/**下线时间,默认2999-12-31*/
	private String offlineDate;
	/**指标描述*/
	private String remark;
	/**创建人*/
	private String creater;
	private String createrName;
	/**开发人*/
	private String developer;
	private String developerName;
	/**局方负责人*/
	private String manager;
	private String managerName;
	
	/**一经接口号*/
	private String boiCode;
	/**优先级，默认99*/
	private String priority;
	/**预期完成日期 ，0每日,1-31表示1-31日*/
	private String expectEndDay;
	/**预期完成时间 8.5表示8点半 */
	private String expectEndTime;
	
	/**1强规则,0弱规则等,默认0*/
	private String ruleType;
	/**规则配置*/
	private String ruleDef;
	/**比较运算符,如==,>=等*/
	private String compOper;
	/**阈值*/
	private String compVal; 
	/**依赖类型*/
	private String dependType;
	
	public String getZbCode() {
		return zbCode;
	}
	public void setZbCode(String zbCode) {
		this.zbCode = zbCode;
	}
	public String getZbName() {
		return zbName;
	}
	public void setZbName(String zbName) {
		this.zbName = zbName;
	}
	public String getZbType() {
		return zbType;
	}
	public void setZbType(String zbType) {
		this.zbType = zbType;
	}
	public String getZbDef() {
		return zbDef;
	}
	public void setZbDef(String zbDef) {
		this.zbDef = zbDef;
	}
	public String getProcDepend() {
		return procDepend;
	}
	public void setProcDepend(String procDepend) {
		this.procDepend = procDepend;
	}
	public String getGbasDepend() {
		return gbasDepend;
	}
	public void setGbasDepend(String gbasDepend) {
		this.gbasDepend = gbasDepend;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getCycle() {
		return cycle;
	}
	public void setCycle(String cycle) {
		this.cycle = cycle;
	}
	public String getOnlineDate() {
		return onlineDate;
	}
	public void setOnlineDate(String onlineDate) {
		this.onlineDate = onlineDate;
	}
	public String getOfflineDate() {
		return offlineDate;
	}
	public void setOfflineDate(String offlineDate) {
		this.offlineDate = offlineDate;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getCreater() {
		return creater;
	}
	public void setCreater(String creater) {
		this.creater = creater;
	}
	public String getDeveloper() {
		return developer;
	}
	public void setDeveloper(String developer) {
		this.developer = developer;
	}
	public String getCreaterName() {
		return createrName;
	}
	public void setCreaterName(String createrName) {
		this.createrName = createrName;
	}
	public String getDeveloperName() {
		return developerName;
	}
	public void setDeveloperName(String developerName) {
		this.developerName = developerName;
	}
	public String getManagerName() {
		return managerName;
	}
	public void setManagerName(String managerName) {
		this.managerName = managerName;
	}
	public String getManager() {
		return manager;
	}
	public void setManager(String manager) {
		this.manager = manager;
	}
	public String getBoiCode() {
		return boiCode;
	}
	public void setBoiCode(String boiCode) {
		this.boiCode = boiCode;
	}
	public String getPriority() {
		return priority;
	}
	public void setPriority(String priority) {
		this.priority = priority;
	}
	public String getExpectEndDay() {
		return expectEndDay;
	}
	public void setExpectEndDay(String expectEndDay) {
		this.expectEndDay = expectEndDay;
	}
	public String getExpectEndTime() {
		return expectEndTime;
	}
	public void setExpectEndTime(String expectEndTime) {
		this.expectEndTime = expectEndTime;
	}
	
	public String getRuleType() {
		return ruleType;
	}
	public void setRuleType(String ruleType) {
		this.ruleType = ruleType;
	}
	public String getRuleDef() {
		return ruleDef;
	}
	public void setRuleDef(String ruleDef) {
		this.ruleDef = ruleDef;
	}
	public String getCompOper() {
		return compOper;
	}
	public void setCompOper(String compOper) {
		this.compOper = compOper;
	}
	public String getCompVal() {
		return compVal;
	}
	public void setCompVal(String compVal) {
		this.compVal = compVal;
	}
	public String getDependType() {
		return dependType;
	}
	public void setDependType(String dependType) {
		this.dependType = dependType;
	}
	
	@Override
	public String toString() {
		return "ZbDef [zbCode=" + zbCode + ", zbName=" + zbName + ", zbType="
				+ zbType + ", zbDef=" + zbDef + ", procDepend=" + procDepend
				+ ", gbasDepend=" + gbasDepend + ", status=" + status
				+ ", cycle=" + cycle + ", onlineDate=" + onlineDate
				+ ", offlineDate=" + offlineDate + ", remark=" + remark
				+ ", creater=" + creater + ", developer=" + developer
				+ ", manager=" + manager + ", boiCode=" + boiCode
				+ ", priority=" + priority + ", expectEndDay=" + expectEndDay
				+ ", expectEndTime=" + expectEndTime + ", ruleType=" + ruleType
				+ ", ruleDef=" + ruleDef + ", compOper=" + compOper
				+ ", compVal=" + compVal + ", dependType=" + dependType + "]";
	}
	
}
