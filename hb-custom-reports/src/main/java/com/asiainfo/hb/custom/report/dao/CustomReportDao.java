package com.asiainfo.hb.custom.report.dao;

import java.util.List;
import java.util.Map;

import com.asiainfo.hb.custom.report.models.ComboboxBean;
import com.asiainfo.hb.custom.report.models.CustomReport;
import com.asiainfo.hb.custom.report.models.CustomReportMap;

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
}