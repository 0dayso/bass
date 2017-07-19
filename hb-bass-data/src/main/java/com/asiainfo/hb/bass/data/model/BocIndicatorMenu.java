package com.asiainfo.hb.bass.data.model;

/**
 * 上线指标配置的数据模型，对应表BOC_INDICATOR_MENU
 * 
 * @author 李志坚
 * @since 2017-03-05
 */
public class BocIndicatorMenu {

	private String menuId, menuName, pid, dailyCode, dailyCumulateCode, monthlyCode, monthlyCumulateCode, category, bureauDailyCode, bureauDailyCumulateCode, bureauMonthlyCode, bureauMonthlyCumulateCode, hasChild;

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public String getMenuName() {
		return menuName;
	}

	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

	public String getDailyCode() {
		return dailyCode;
	}

	public void setDailyCode(String dailyCode) {
		this.dailyCode = dailyCode;
	}

	public String getDailyCumulateCode() {
		return dailyCumulateCode;
	}

	public void setDailyCumulateCode(String dailyCumulateCode) {
		this.dailyCumulateCode = dailyCumulateCode;
	}

	public String getMonthlyCode() {
		return monthlyCode;
	}

	public void setMonthlyCode(String monthlyCode) {
		this.monthlyCode = monthlyCode;
	}

	public String getMonthlyCumulateCode() {
		return monthlyCumulateCode;
	}

	public void setMonthlyCumulateCode(String monthlyCumulateCode) {
		this.monthlyCumulateCode = monthlyCumulateCode;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getBureauDailyCode() {
		return bureauDailyCode;
	}

	public void setBureauDailyCode(String bureauDailyCode) {
		this.bureauDailyCode = bureauDailyCode;
	}

	public String getBureauDailyCumulateCode() {
		return bureauDailyCumulateCode;
	}

	public void setBureauDailyCumulateCode(String bureauDailyCumulateCode) {
		this.bureauDailyCumulateCode = bureauDailyCumulateCode;
	}

	public String getBureauMonthlyCode() {
		return bureauMonthlyCode;
	}

	public void setBureauMonthlyCode(String bureauMonthlyCode) {
		this.bureauMonthlyCode = bureauMonthlyCode;
	}

	public String getBureauMonthlyCumulateCode() {
		return bureauMonthlyCumulateCode;
	}

	public void setBureauMonthlyCumulateCode(String bureauMonthlyCumulateCode) {
		this.bureauMonthlyCumulateCode = bureauMonthlyCumulateCode;
	}

	public String getHasChild() {
		return hasChild;
	}

	public void setHasChild(String hasChild) {
		this.hasChild = hasChild;
	}

}
