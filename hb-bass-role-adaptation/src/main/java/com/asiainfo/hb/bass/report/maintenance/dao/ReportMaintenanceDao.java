package com.asiainfo.hb.bass.report.maintenance.dao;

import java.util.Map;

import com.asiainfo.hb.bass.report.maintenance.models.ReportMaintenance;

public interface ReportMaintenanceDao {
	void save(ReportMaintenance maintenance);
	void delete(String id);
	void update(ReportMaintenance maintenance);
	Map<String, Object> getReportPageList(int page, int rows, ReportMaintenance maintenance);
}
