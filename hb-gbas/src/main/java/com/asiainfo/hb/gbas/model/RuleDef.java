package com.asiainfo.hb.gbas.model;

public class RuleDef {
	
	private String ruleCode;
	/**一经接口号*/
	private String boiCode;
	private String ruleName;
	/**1强规则,0弱规则等,默认0*/
	private String ruleType;
	/**sql配置*/
	private String ruleDef;
	/**比较运算符,如==,>=等*/
	private String compOper;
	/**阈值*/
	private String val;
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
	/**开发人*/
	private String developer;
	/**局方负责人*/
	private String manager;
	/**优先级，默认99*/
	private String priority;
	/**预期完成日期 ，0每日,1-31表示1-31日*/
	private String expectEndDay;
	/**预期完成时间 8.5表示8点半 */
	private String expectEndTime;
	
	public String getRuleCode() {
		return ruleCode;
	}
	public void setRuleCode(String ruleCode) {
		this.ruleCode = ruleCode;
	}
	public String getBoiCode() {
		return boiCode;
	}
	public void setBoiCode(String boiCode) {
		this.boiCode = boiCode;
	}
	public String getRuleName() {
		return ruleName;
	}
	public void setRuleName(String ruleName) {
		this.ruleName = ruleName;
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
	public String getVal() {
		return val;
	}
	public void setVal(String val) {
		this.val = val;
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
	public String getManager() {
		return manager;
	}
	public void setManager(String manager) {
		this.manager = manager;
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
	@Override
	public String toString() {
		return "RuleDef [ruleCode=" + ruleCode + ", boiCode=" + boiCode
				+ ", ruleName=" + ruleName + ", ruleType=" + ruleType
				+ ", ruleDef=" + ruleDef + ", compOper=" + compOper + ", val="
				+ val + ", procDepend=" + procDepend + ", gbasDepend="
				+ gbasDepend + ", status=" + status + ", cycle=" + cycle
				+ ", onlineDate=" + onlineDate + ", offlineDate=" + offlineDate
				+ ", remark=" + remark + ", creater=" + creater
				+ ", developer=" + developer + ", manager=" + manager
				+ ", priority=" + priority + ", expectEndDay=" + expectEndDay
				+ ", expectEndTime=" + expectEndTime + "]";
	}
	
}
