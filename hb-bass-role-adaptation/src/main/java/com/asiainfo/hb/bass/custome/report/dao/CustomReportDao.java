package com.asiainfo.hb.bass.custome.report.dao;

import java.util.List;
import java.util.Map;

import com.asiainfo.hb.bass.custome.report.models.ComboboxBean;
import com.asiainfo.hb.bass.custome.report.models.CustomReport;
import com.asiainfo.hb.bass.custome.report.models.CustomReportMap;
import com.asiainfo.hb.bass.custome.report.models.ReportInfo;


public interface CustomReportDao {
	/**
	 * 查询指标分类
	 * 
	 * @return
	 */
	List<ComboboxBean> getCategorys();

	List<Map<String, Object>> getReportTypeList(String codeType, String category,String menuIds);

	/**
	 * 查询自定义报表配置列表
	 */
	Map<String, Object> getReportPageList(int page, int rows, String userId);

	/**
	 * 查询已经选择了的指标
	 * 
	 * @param reportId
	 * @return
	 */
	List<CustomReportMap> querySelectReport(String reportId);

	void deleteCustomReport(String userId, String reportId);

	void deleteCustomReportMap(String reportId);

	void saveCustomReport(CustomReport report);

	void saveCustomReportMap(List<Object[]> listArgs);

	void updateCustomReport(CustomReport report);
	
	List<Map<String, Object>> getIndicatorMenus();
	
	List<ReportInfo> getReportList(String reportId);
	/**
	 * 通过市区编码查询县市信息
	 * @param areaCode
	 * @return
	 */
	List<Map<String, Object>> getCountyList(String areaCode);
	/**
	 * 查询全省市区信息
	 * @return
	 */
	List<Map<String, Object>> getCityList();
	
	String getDaylyDate(String kpiCode);
	
	String getMonthlyDate(String kpiCode);
	
	
	Map<String, Object> getReportQueryDate(int page, int rows, String sql,Map<String, Object> parameters);
}
