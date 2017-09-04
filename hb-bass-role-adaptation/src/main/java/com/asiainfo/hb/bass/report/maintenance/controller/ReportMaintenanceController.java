package com.asiainfo.hb.bass.report.maintenance.controller;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.bass.report.maintenance.models.ReportMaintenance;
import com.asiainfo.hb.bass.report.maintenance.service.ReportMaintenanceService;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping("/report/maintenance")
public class ReportMaintenanceController {
	
	private Logger logger = Logger.getLogger(ReportMaintenanceController.class);
	
	@Autowired
	private ReportMaintenanceService service;
	
	
	@RequestMapping("/page")
	public String page() {
		return "ftl/report-maintenance/index";
	}
	
	@RequestMapping(value = { "/list" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object listPage(@RequestParam(value = "page", defaultValue = "1") Integer page,
			@RequestParam(value = "rows", defaultValue = "10") Integer rows,ReportMaintenance maintenance,
			@ModelAttribute(SessionKeyConstants.USER) User user) {
		String userId = user.getId();
		logger.info("<----parameters---->page=" + page + ",rows=" + rows+",userId="+userId);
		return service.getReportPageList(page, rows, maintenance);
	}
	
	@RequestMapping(value = { "/delete/{id}" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object delete(@PathVariable("id") String id,
			@ModelAttribute(SessionKeyConstants.USER) User user) {
		String userId = user.getId();
		logger.info("the delete parameters: id=" + id + ",userId=" + userId);
		return service.delete(id);
	}
	
	@RequestMapping(value = { "/save" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object save(@RequestBody ReportMaintenance maintenance, @ModelAttribute(SessionKeyConstants.USER) User user) {
		return service.saveOrUpdateReportMaintenance(maintenance);
	}
	
	
	@RequestMapping(value = { "/getReportType" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object save(@RequestParam(value="reportId",defaultValue="00001111")String reportId) {
		return service.getReportType(reportId);
	}
}
