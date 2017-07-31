package com.asiainfo.hb.custom.report.models;

/**
 * 指标信息
 * @author king-pan
 *
 */
public class ReportInfo {
	/**
	 * 自定义指标id
	 */
	private String reportId;
	/**
	 * 指标配置Id
	 */
	private String menuId;
	/**
	 * 指标名称
	 */
	private String menuName;
	/**
	 * 指标类型: 日指标,月指标
	 */
	private String type;
	/**
	 * kpi编码
	 */
	private String kpiCode;

	public String getReportId() {
		return reportId;
	}

	public void setReportId(String reportId) {
		this.reportId = reportId;
	}

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

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getKpiCode() {
		return kpiCode;
	}

	public void setKpiCode(String kpiCode) {
		this.kpiCode = kpiCode;
	}

	@Override
	public String toString() {
		return "ReportInfo [reportId=" + reportId + ", menuId=" + menuId + ", menuName=" + menuName + ", type=" + type
				+ ", kpiCode=" + kpiCode + "]";
	}

}
