package com.asiainfo.hbbass.kpiportal.core;

import java.io.Serializable;

/**
 * KPI的值对象
 * 
 * @author Mei Kefu
 * 
 *         2009-12-29日修改，增加KPIEntityValue到KPIEntity.Entity的应用（能从子找到父）
 */
public class KPIEntityValue implements Serializable {

	private static final long serialVersionUID = -6215191807636570356L;

	private KPIEntity.Entity parentEntity;// 保存父KPIEntity.Entity的值，能从子找到父

	private KPIEntityValueFilter filter;// 保存这个字段是在during里面，没有parentEntity时加载filter的引用

	private String
	/** ****** 地域编码 ********* */
	regionId,
	/** ****** 地域名称 ********* */
	regionName, parentId;

	private Double
	/** ****** 目标值 ********* */
	targetValue;

	private KPIEntityValueCells
	/** ****** KPI值 ********* */
	current,
	/** ****** 环比值 ********* */
	pre,
	/** ****** 同比值 ********* */
	before,
	/** ****** 年同比值 ********* */
	year;

	public String getRegionId() {
		return regionId;
	}

	public void setRegionId(String regionId) {
		this.regionId = regionId;
	}

	public String getRegionName() {
		return regionName;
	}

	public void setRegionName(String regionName) {
		this.regionName = regionName;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId;
	}

	public Double getTargetValue() {
		return targetValue;
	}

	public void setTargetValue(Double targetValue) {
		this.targetValue = targetValue;
	}

	public Double getCurrentValue(KPIEntityValueState state) {

		return current.getValue(state);
	}

	public KPIEntityValueCells getCurrent() {
		return current;
	}

	public void setCurrent(KPIEntityValueCells current) {
		this.current = current;
	}

	public Double getPreValue(KPIEntityValueState state) {
		return pre.getValue(state);
	}

	public KPIEntityValueCells getPre() {
		return pre;
	}

	public void setPre(KPIEntityValueCells pre) {
		this.pre = pre;
	}

	public Double getBeforeValue(KPIEntityValueState state) {
		return before.getValue(state);
	}

	public KPIEntityValueCells getBefore() {
		return before;
	}

	public void setBefore(KPIEntityValueCells before) {
		this.before = before;
	}

	public Double getYearValue(KPIEntityValueState state) {
		return year.getValue(state);
	}

	public KPIEntityValueCells getYear() {
		return year;
	}

	public void setYear(KPIEntityValueCells year) {
		this.year = year;
	}

	public String toString() {
		return KPIPortalContext.DECIMAL_FORMAT.format(current.getValue());
	}

	public KPIEntity.Entity getParentEntity() {
		return parentEntity;
	}

	public void setParentEntity(KPIEntity.Entity parentEntity) {
		this.parentEntity = parentEntity;
	}

	public KPIEntityValueFilter getFilter() {

		if (parentEntity != null)
			return parentEntity.getParentKPIEntity().getValueFilter();
		else if (filter != null)
			return filter;
		else
			return KPIEntityValueFilter.NULL;
	}

	public void setFilter(KPIEntityValueFilter filter) {
		this.filter = filter;
	}

}
