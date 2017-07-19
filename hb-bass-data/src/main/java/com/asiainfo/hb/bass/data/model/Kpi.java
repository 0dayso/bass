package com.asiainfo.hb.bass.data.model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DecimalFormat;

import org.codehaus.jackson.annotate.JsonIgnore;

/**
 * KPI数据模型
 * 
 * @author 李志坚
 * @since 2017-03-05
 */
@SuppressWarnings("serial")
public class Kpi implements Serializable {
	private String menuId;
	private String kpiCode;
	private String accumulationKpiCode;
	private String kpiName;
	private String opTime;
	private String dimCode;
	private String dimVal;
	@JsonIgnore
	private String regionId;
	private String regionName;
	@JsonIgnore
	private BigDecimal current;
	@JsonIgnore
	private BigDecimal yesterday;
	@JsonIgnore
	private BigDecimal lastMonth;
	@JsonIgnore
	private BigDecimal lastYear;
	
	private BigDecimal dailyCurrent;//日
	private BigDecimal dailyComparedYesterday;//较昨日
	private BigDecimal dailyComparedLastMonth;//较上月
	private BigDecimal dailyAccumulation;//日累计
	private BigDecimal dailyAccumulationComparedLastMonth;//日累计较上月
	private BigDecimal dailyAccumulationComparedLastYear;//日累计较去年

	private BigDecimal monthlyCurrent;//月
	private BigDecimal monthlyComparedLastMonth;//较上月
	private BigDecimal monthlyComparedLastYear;//较去年同期
	private BigDecimal monthlyAccumulation;//月累计
	private BigDecimal monthlyAccumulationComparedLastMonth;//月累计较上月
	private BigDecimal monthlyAccumulationComparedLastYear;//月累计较去年
	@JsonIgnore
	private int level;
	private String kpiUnit;
	private String description;
	private String sql;

	@JsonIgnore
	public final static DecimalFormat percentFormat = new DecimalFormat("0.00%"), digitFormat = new DecimalFormat("###,###.00");

	public String getMenuId() {
		return menuId;
	}

	public void setMenuId(String menuId) {
		this.menuId = menuId;
	}

	public String getKpiCode() {
		return kpiCode;
	}

	public void setKpiCode(String kpiCode) {
		this.kpiCode = kpiCode;
	}

	public String getOpTime() {
		return opTime;
	}

	public void setOpTime(String opTime) {
		this.opTime = opTime;
	}

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

	public BigDecimal getCurrent() {
		return current;
	}

	public void setCurrent(BigDecimal current) {
		this.current = current;
	}

	public BigDecimal getYesterday() {
		return yesterday;
	}

	public void setYesterday(BigDecimal yesterday) {
		this.yesterday = yesterday;
	}

	public BigDecimal getLastMonth() {
		return lastMonth;
	}

	public void setLastMonth(BigDecimal lastMonth) {
		this.lastMonth = lastMonth;
	}

	public BigDecimal getLastYear() {
		return lastYear;
	}

	public void setLastYear(BigDecimal lastYear) {
		this.lastYear = lastYear;
	}

	public String getDimCode() {
		return dimCode;
	}

	public void setDimCode(String dimCode) {
		this.dimCode = dimCode;
	}

	public String getDimVal() {
		return dimVal;
	}

	public void setDimVal(String dimVal) {
		this.dimVal = dimVal;
	}

	public BigDecimal getDailyCurrent() {
		return dailyCurrent;
	}

	public void setDailyCurrent(BigDecimal dailyCurrent) {
		this.dailyCurrent = dailyCurrent;
	}

	public BigDecimal getDailyComparedYesterday() {
		return dailyComparedYesterday;
	}

	public void setDailyComparedYesterday(BigDecimal dailyComparedYesterday) {
		this.dailyComparedYesterday = dailyComparedYesterday;
	}

	public BigDecimal getDailyComparedLastMonth() {
		return dailyComparedLastMonth;
	}

	public void setDailyComparedLastMonth(BigDecimal dailyComparedLastMonth) {
		this.dailyComparedLastMonth = dailyComparedLastMonth;
	}

	public BigDecimal getDailyAccumulation() {
		return dailyAccumulation;
	}

	public void setDailyAccumulation(BigDecimal dailyAccumulation) {
		this.dailyAccumulation = dailyAccumulation;
	}

	public BigDecimal getDailyAccumulationComparedLastMonth() {
		return dailyAccumulationComparedLastMonth;
	}

	public void setDailyAccumulationComparedLastMonth(BigDecimal dailyAccumulationComparedLastMonth) {
		this.dailyAccumulationComparedLastMonth = dailyAccumulationComparedLastMonth;
	}

	public BigDecimal getDailyAccumulationComparedLastYear() {
		return dailyAccumulationComparedLastYear;
	}

	public void setDailyAccumulationComparedLastYear(BigDecimal dailyAccumulationComparedLastYear) {
		this.dailyAccumulationComparedLastYear = dailyAccumulationComparedLastYear;
	}

	public BigDecimal getMonthlyCurrent() {
		return monthlyCurrent;
	}

	public void setMonthlyCurrent(BigDecimal monthlyCurrent) {
		this.monthlyCurrent = monthlyCurrent;
	}

	public BigDecimal getMonthlyComparedLastMonth() {
		return monthlyComparedLastMonth;
	}

	public void setMonthlyComparedLastMonth(BigDecimal monthlyComparedLastMonth) {
		this.monthlyComparedLastMonth = monthlyComparedLastMonth;
	}

	public BigDecimal getMonthlyComparedLastYear() {
		return monthlyComparedLastYear;
	}

	public void setMonthlyComparedLastYear(BigDecimal monthlyComparedLastYear) {
		this.monthlyComparedLastYear = monthlyComparedLastYear;
	}

	public BigDecimal getMonthlyAccumulation() {
		return monthlyAccumulation;
	}

	public void setMonthlyAccumulation(BigDecimal monthlyAccumulation) {
		this.monthlyAccumulation = monthlyAccumulation;
	}

	public BigDecimal getMonthlyAccumulationComparedLastMonth() {
		return monthlyAccumulationComparedLastMonth;
	}

	public void setMonthlyAccumulationComparedLastMonth(BigDecimal monthlyAccumulationComparedLastMonth) {
		this.monthlyAccumulationComparedLastMonth = monthlyAccumulationComparedLastMonth;
	}

	public BigDecimal getMonthlyAccumulationComparedLastYear() {
		return monthlyAccumulationComparedLastYear;
	}

	public void setMonthlyAccumulationComparedLastYear(BigDecimal monthlyAccumulationComparedLastYear) {
		this.monthlyAccumulationComparedLastYear = monthlyAccumulationComparedLastYear;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public static DecimalFormat getPercentformat() {
		return percentFormat;
	}

	public static DecimalFormat getDigitformat() {
		return digitFormat;
	}

	public String getKpiName() {
		return kpiName;
	}

	public void setKpiName(String kpiName) {
		this.kpiName = kpiName;
	}

	public String getAccumulationKpiCode() {
		return accumulationKpiCode;
	}

	public void setAccumulationKpiCode(String accumulationKpiCode) {
		this.accumulationKpiCode = accumulationKpiCode;
	}

	public String getSql() {
		return sql;
	}

	public void setSql(String sql) {
		this.sql = sql;
	}

	public String getKpiUnit() {
		return kpiUnit;
	}

	public void setKpiUnit(String kpiUnit) {
		this.kpiUnit = kpiUnit;
	}
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}


}
