package com.asiainfo.hb.custom.report.service;

import java.util.List;
import java.util.Map;

import com.asiainfo.hb.custom.report.models.ComboboxBean;
import com.asiainfo.hb.custom.report.models.CustomReport;
import com.asiainfo.hb.custom.report.models.CustomReportMap;
import com.asiainfo.hb.custom.report.models.ReportInfo;

public interface CustomReportService {
	
	List<ComboboxBean> getCategorys();
	
	/**
	 * 通过指标类型和指标类别查询指标列表
	 * @param codeType 指标类型(日指标,日累计指标,月指标,月累计指标)
	 * @param category 指标类别(用户/流量/高校/...)
	 * @return
	 */
	List<Map<String, Object>> getReportTypeList(String codeType,String category,String menuIds);
	
	/**
	 * 查询已经选择了的指标
	 * @param reportId
	 * @return
	 */
	List<CustomReportMap> querySelectReport(String reportId);

	Map<String, Object> getReportPageList(int page, int rows, String userId);

	Map<String, Object> deleteCustomReport(String userId, String reportId);

	Map<String, Object> saveCustomReport(CustomReport report);
	
	Map<String, String> getIndicatorMenus();
	
	List<ReportInfo> getReportList(String reportId);
	/**
	 * 查询全省市区信息
	 * @return
	 */
	List<Map<String, Object>> getCityList();
	/**
	 * 通过市区编码查询县市信息
	 * @param areaCode
	 * @return
	 */
	List<Map<String, Object>> getCountyList(String areaCode);
	
	/**
	 * 通过指标类型查询指标最新日期
	 * @param type: 日指标/月指标
	 * @param kpiCode 指标编码
	 * @return
	 */
	String getKpiDefaultDate(String type,String kpiCode);
	
	Map<String, Object> getReportQueryDate(int page, int rows, String sql,Map<String, Object> parameters);
	
}
