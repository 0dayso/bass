package com.asiainfo.hb.bass.report.maintenance.service;

import java.util.HashMap;
import java.util.Map;

import org.apache.camel.RuntimeCamelException;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.bass.report.maintenance.dao.ReportMaintenanceDao;
import com.asiainfo.hb.bass.report.maintenance.models.ReportMaintenance;
import com.asiainfo.hb.core.util.IdGen;

@Service
public class ReportMaintenanceServiceImpl implements ReportMaintenanceService {

	@Autowired
	private ReportMaintenanceDao reportMaintenanceDao;
	
	@Override
	public Map<String, Object> getReportPageList(int page, int rows, ReportMaintenance reportMaintenance) {
		return reportMaintenanceDao.getReportPageList(page, rows, reportMaintenance);
	}

	@Override
	public Map<String, Object> saveOrUpdateReportMaintenance(ReportMaintenance reportMaintenance) {
		Map<String, Object> result = new HashMap<String,Object>();
		
		if(reportMaintenance==null) {
			throw new RuntimeCamelException("The ReportMaintenance is not allow null.");
			
		}
		if(StringUtils.isNotBlank(reportMaintenance.getId())) {
			//更新操作
			reportMaintenanceDao.update(reportMaintenance);
			result.put("msg", "修改成功");
		}else {
			reportMaintenance.setId(IdGen.genId());
			reportMaintenanceDao.save(reportMaintenance);
			result.put("msg", "新增成功");
		}
		result.put("status", true);
		return result;
	}

	@Override
	public Map<String, Object> delete(String id) {
		Map<String, Object> result = new HashMap<>();
		if (StringUtils.isBlank(id)) {
			result.put("msg",
					"the parameters: id=" + id + " not allowed for null");
			result.put("status", "500");
		} else {
			reportMaintenanceDao.delete(id);
			result.put("msg", "删除成功");
			result.put("status", "200");
		}
		
		return result;
	}

	@Override
	public String getReportType(String reportId) {
		return reportMaintenanceDao.getReportType(reportId);
	}

}
