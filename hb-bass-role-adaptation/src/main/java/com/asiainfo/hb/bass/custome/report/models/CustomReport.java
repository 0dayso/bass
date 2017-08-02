package com.asiainfo.hb.bass.custome.report.models;

import java.util.ArrayList;
import java.util.List;

/**
 * 自定义报表配置表
 * 数据库表:st.fpf_irs_cusmtom_report
 * @author King-Pan
 *
 */
public class CustomReport {
	/**
	 * 自定义报表id
	 */
	private String reportId;
	/**
	 * 自定义报表名称
	 */
	private String reportName;
	/**
	 * 自定义报表描述
	 */
	private String reportDesc;
	/**
	 * 用户id
	 */
	private String userId;
	
	private List<CustomReportMap> reportMapList = new ArrayList<CustomReportMap>();

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

	public String getReportDesc() {
		return reportDesc;
	}

	public void setReportDesc(String reportDesc) {
		this.reportDesc = reportDesc;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public List<CustomReportMap> getReportMapList() {
		return reportMapList;
	}

	public void setReportMapList(List<CustomReportMap> reportMapList) {
		this.reportMapList = reportMapList;
	}

	@Override
	public String toString() {
		return "CustomReport [reportId=" + reportId + ", reportName=" + reportName + ", reportDesc=" + reportDesc
				+ ", userId=" + userId + ", reportMapList=" + reportMapList + "]";
	}
	
}
