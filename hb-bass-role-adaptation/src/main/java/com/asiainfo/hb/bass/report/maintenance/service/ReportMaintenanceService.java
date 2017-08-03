package com.asiainfo.hb.bass.report.maintenance.service;

import java.util.Map;

import com.asiainfo.hb.bass.report.maintenance.models.ReportMaintenance;

public interface ReportMaintenanceService {
	Map<String, Object> getReportPageList(int page, int rows, ReportMaintenance reportMaintenance);

	Map<String, Object> saveOrUpdateReportMaintenance(ReportMaintenance reportMaintenance);
	
	Map<String, Object> delete(String id);
}
