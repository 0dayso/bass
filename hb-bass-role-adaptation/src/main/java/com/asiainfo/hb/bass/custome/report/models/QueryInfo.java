package com.asiainfo.hb.bass.custome.report.models;


public class QueryInfo {
	private String reportId;
	private String kpiDate;
	private String areaCode;
	private String countyX;
	private String countyList;
	private String marktingX;
	private String marketingCenters;

	public String getReportId() {
		return reportId;
	}

	public void setReportId(String reportId) {
		this.reportId = reportId;
	}

	public String getKpiDate() {
		return kpiDate;
	}

	public void setKpiDate(String kpiDate) {
		this.kpiDate = kpiDate;
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public String getCountyX() {
		return countyX;
	}

	public void setCountyX(String countyX) {
		this.countyX = countyX;
	}

	public String getCountyList() {
		return countyList;
	}

	public void setCountyList(String countyList) {
		this.countyList = countyList;
	}

	public String getMarktingX() {
		return marktingX;
	}

	public void setMarktingX(String marktingX) {
		this.marktingX = marktingX;
	}

	public String getMarketingCenters() {
		return marketingCenters;
	}

	public void setMarketingCenters(String marketingCenters) {
		this.marketingCenters = marketingCenters;
	}

	@Override
	public String toString() {
		return "QueryInfo [reportId=" + reportId + ", kpiDate=" + kpiDate + ", areaCode=" + areaCode + ", countyX="
				+ countyX + ", countyList=" + countyList + ", marktingX=" + marktingX + ", marketingCenters="
				+ marketingCenters + "]";
	}

}
