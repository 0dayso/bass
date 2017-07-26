package com.asiainfo.hb.custom.report.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.core.util.IdGen;
import com.asiainfo.hb.custom.report.dao.CustomReportDao;
import com.asiainfo.hb.custom.report.models.ComboboxBean;
import com.asiainfo.hb.custom.report.models.CustomReport;
import com.asiainfo.hb.custom.report.models.CustomReportMap;
import com.asiainfo.hb.custom.report.service.CustomReportService;

@Service
public class CustomReportServiceImpl implements CustomReportService {

	@Autowired
	private CustomReportDao reportDao;

	@Override
	public List<ComboboxBean> getCategorys() {
		List<ComboboxBean> listBox = reportDao.getCategorys();
		if (listBox != null && listBox.size() > 0) {
			listBox.get(0).setSelected(true);
		}
		return listBox;
	}

	@Override
	public Map<String, Object> getReportPageList(int page, int rows, String userId) {
		return reportDao.getReportPageList(page, rows, userId);
	}

	@Override
	public Map<String, Object> deleteCustomReport(String userId, String reportId) {
		Map<String, Object> result = new HashMap<>();
		if (StringUtils.isBlank(reportId) || StringUtils.isBlank(userId)) {
			result.put("msg",
					"the parameters: userd=" + userId + ",reportId=" + reportId + " all not allowed for null");
			result.put("status", "500");
		} else {
			reportDao.deleteCustomReport(userId, reportId);
			reportDao.deleteCustomReportMap(reportId);
			result.put("msg", "删除成功");
			result.put("status", "200");
		}
		return result;
	}

	@Override
	public Map<String, Object> saveCustomReport(CustomReport report) {
		Map<String, Object> result = new HashMap<>();
		Boolean updateFlag = true;
		List<CustomReportMap> reportMapList = report.getReportMapList();
		if (StringUtils.isBlank(report.getReportId())) {// 新增操作
			report.setReportId(IdGen.genId());
			reportDao.saveCustomReport(report);
			updateFlag = false;
		} else { // 更新操作
			reportDao.updateCustomReport(report);
		}
		
		saveReportMap(reportMapList, report.getReportId(), updateFlag);
		if (updateFlag) {
			result.put("msg", "修改成功");
		} else {
			result.put("msg", "新增成功");
		}
		result.put("status", true);
		return result;
	}

	/**
	 * 新增自定义报表配置关联表: 新增自定义报表时,新增关联 更新自定义报表时,删除旧的关联,新增新的关联
	 * 
	 * @param reportMapList
	 * @param reportId
	 * @param updateFlag
	 */
	private void saveReportMap(List<CustomReportMap> reportMapList, String reportId, boolean updateFlag) {
		if (updateFlag) {
			reportDao.deleteCustomReportMap(reportId);
		}
		if (reportMapList != null && reportMapList.size() > 0) {
			List<Object[]> listArgs = new ArrayList<Object[]>();
			for (int i = 0; i < reportMapList.size(); i++) {
				listArgs.add(new Object[] { IdGen.genId(), reportId, reportMapList.get(i).getIndicatorMenuId(),
						reportMapList.get(i).getKpiCode() });
			}
			reportDao.saveCustomReportMap(listArgs);
		}
	}

	@Override
	public List<Map<String, Object>> getReportTypeList(String codeType, String category,String menuIds) {
		if (StringUtils.isBlank(codeType) || StringUtils.isBlank(category)) {
			throw new RuntimeException("the codeType = " + codeType + ",category=" + category + " not allow for null.");
		}
		return reportDao.getReportTypeList(codeType, category,menuIds);
	}

	@Override
	public List<CustomReportMap> querySelectReport(String reportId) {
		return reportDao.querySelectReport(reportId);
	}

}
