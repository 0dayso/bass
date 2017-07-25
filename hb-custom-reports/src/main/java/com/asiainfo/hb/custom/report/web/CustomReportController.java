package com.asiainfo.hb.custom.report.web;

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
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.custom.report.models.CustomReport;
import com.asiainfo.hb.custom.report.service.CustomReportService;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@SessionAttributes({ SessionKeyConstants.USER })
@RequestMapping("/custom/reports")
@Controller
public class CustomReportController {
	private Logger logger = Logger.getLogger(CustomReportController.class);

	@Autowired
	private CustomReportService customReportService;

	@RequestMapping("/page")
	public String page() {
		return "ftl/custom-report/index";
	}
	
	@RequestMapping("/{reportId}")
	public String report(@PathVariable("reportId")String reportId) {
		return "ftl/custom-report/report";
	}

	@RequestMapping(value = { "/list" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object listPage(@RequestParam(value = "page", defaultValue = "1") Integer page,
			@RequestParam(value = "rows", defaultValue = "10") Integer rows,
			@ModelAttribute(SessionKeyConstants.USER) User user) {
		String userId = user.getId();
		logger.info("<----parameters---->page=" + page + ",rows=" + rows);
		return customReportService.getReportPageList(page, rows, userId);
	}

	@RequestMapping(value = { "/getReportTypeList" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object getReportTypeList(@RequestParam("codeType") String codeType,
			@RequestParam("category") String category,@RequestParam(value="menuIds",defaultValue="") String menuIds) {
		return customReportService.getReportTypeList(codeType, category,menuIds);
	}

	@RequestMapping(value = { "/getCategory" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object getCategory() {
		return customReportService.getCategorys();
	}

	@RequestMapping(value = { "/delete/{reportId}" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object delete(@PathVariable("reportId") String reportId,
			@ModelAttribute(SessionKeyConstants.USER) User user) {
		String userId = user.getId();
		logger.info("the delete parameters: reportId=" + reportId + ",userId=" + userId);
		return customReportService.deleteCustomReport(userId, reportId);
	}

	@RequestMapping(value = { "/save" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object save(@RequestBody CustomReport report, @ModelAttribute(SessionKeyConstants.USER) User user) {
		report.setUserId(user.getId());
		return customReportService.saveCustomReport(report);
	}
	
	@RequestMapping(value = { "/querySelectReport" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object querySelectReport(@RequestParam("reportId") String reportId) {
		return customReportService.querySelectReport(reportId);
	}

}
