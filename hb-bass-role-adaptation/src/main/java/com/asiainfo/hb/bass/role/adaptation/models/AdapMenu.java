/**
 * 
 */
package com.asiainfo.hb.bass.role.adaptation.models;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

/**
 * @author zhangds
 * @date 2015年11月13日
 * @category 对应BOC_INDICATOR_MENU表的bean
 */
@SuppressWarnings("serial")
public class AdapMenu implements Serializable {
	private int deep;
	private String menuId,parentmenuId,menuName,dailyCode,dailyCumulateCode,monthlyCode,
					monthlyCumulateCode,category, bureauDailyCode, 
					bureauDailyCumulateCode, bureauMonthlyCode, bureauMonthlyCumulateCode,
					hasChild;
	private Map<String,Object> valueD;
	private Map<String,Object> valueAD;
	List<AdapMenu> children;
	public int getDeep() {
		return deep;
	}
	public void setDeep(int deep) {
		this.deep = deep;
	}
	public String getMenuId() {
		return menuId;
	}
	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}
	public String getParentmenuId() {
		return parentmenuId;
	}
	public void setParentmenuId(String parentmenuId) {
		this.parentmenuId = parentmenuId;
	}
	public String getMenuName() {
		return menuName;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
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
	public Map<String, Object> getValueD() {
		return valueD;
	}
	public void setValueD(Map<String, Object> valueD) {
		this.valueD = valueD;
	}
	public Map<String, Object> getValueAD() {
		return valueAD;
	}
	public void setValueAD(Map<String, Object> valueAD) {
		this.valueAD = valueAD;
	}
	public List<AdapMenu> getChildren() {
		return children;
	}
	public void setChildren(List<AdapMenu> children) {
		this.children = children;
	}
	
	
}
