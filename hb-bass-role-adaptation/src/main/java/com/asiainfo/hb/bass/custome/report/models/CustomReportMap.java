package com.asiainfo.hb.bass.custome.report.models;

/**
 * 自定义报表配置指标关联表
 * 数据库表: st.fpf_irs_cusmtom_report_map
 * @author King-Pan
 *
 */
public class CustomReportMap {
	/**
	 * 指标关联id
	 */
	private String id;
	/**
	 * 自定义报表配置id
	 */
	private String reportId;
	/**
	 * 指标菜单id
	 */
	private String indicatorMenuId;
	/**
	 * 指标编码
	 */
	private String kpiCode;
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getReportId() {
		return reportId;
	}
	public void setReportId(String reportId) {
		this.reportId = reportId;
	}
	public String getIndicatorMenuId() {
		return indicatorMenuId;
	}
	public void setIndicatorMenuId(String indicatorMenuId) {
		this.indicatorMenuId = indicatorMenuId;
	}
	public String getKpiCode() {
		return kpiCode;
	}
	public void setKpiCode(String kpiCode) {
		this.kpiCode = kpiCode;
	}
	@Override
	public String toString() {
		return "CustomReportMap [id=" + id + ", reportId=" + reportId + ", indicatorMenuId=" + indicatorMenuId
				+ ", kpiCode=" + kpiCode + "]";
	}
}
