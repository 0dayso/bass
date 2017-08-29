package com.asiainfo.hb.bass.custome.report.web;

import java.util.HashMap;
import java.util.Map;

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
import org.springframework.web.servlet.ModelAndView;

import com.asiainfo.hb.bass.custome.report.ReportContext;
import com.asiainfo.hb.bass.custome.report.models.CustomReport;
import com.asiainfo.hb.bass.custome.report.models.QueryInfo;
import com.asiainfo.hb.bass.custome.report.service.CustomReportService;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@SessionAttributes({ SessionKeyConstants.USER })
@RequestMapping("/custom/reports")
@Controller
public class CustomReportController {
	private Logger logger = Logger.getLogger(CustomReportController.class);
	
	@Autowired
	private ReportContext context;

	@Autowired
	private CustomReportService customReportService;
	

	@RequestMapping("/page")
	public String page() {
		return "ftl/custom-report/index";
	}
	
	@RequestMapping("/{reportId}")
	public ModelAndView report(@PathVariable("reportId")String reportId) {
		ModelAndView view = new ModelAndView("ftl/custom-report/report");
		context.setReportId(reportId);
		context.init();
		String defaultDate = context.getSearchDate();
		view.addObject("reportId", reportId);
		view.addObject("defaultDate", defaultDate);
		view.addObject("type", context.getType());
		logger.info("<------> reportId = " + reportId + ",defaultDate = " + defaultDate + ",type = " + context.getType());
		return view;
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

	@RequestMapping(value = { "/getCityList" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object getCityList() {
		return customReportService.getCityList();
	}
	
	@RequestMapping(value = { "/getCountyList" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object getCountyList(@RequestParam("areaCode") String areaCode) {
		return customReportService.getCountyList(areaCode);
	}

	@RequestMapping(value = { "/getCategory" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object getCategory() {
		return customReportService.getCategorys();
	}
	
	
	@RequestMapping(value = { "/query" }, method = { RequestMethod.POST })
	@ResponseBody
	public Object query(QueryInfo info) {
		Map<String, Object> result = new HashMap<String,Object>();
		System.out.println("<--------->"+info);
		context.setReportId(info.getReportId());
		context.setInfo(info);
		context.init();
		context.inittHead();
		result.put("header", context.getColumns());
		return result;
	}
	
	@RequestMapping(value = { "/reportPageList" })
	@ResponseBody
	public Object reportPageList(@RequestParam(value = "page", defaultValue = "1") Integer page,
			@RequestParam(value = "rows", defaultValue = "10") Integer rows,QueryInfo info) {
		logger.info("<----parameters---->page=" + page + ",rows=" + rows+",info"+info);
		context.setReportId(info.getReportId());
		context.setInfo(info);
		context.init();
		context.inittHead();
		context.query(page, rows);
		logger.info("type:" + context.type);
		return context.getDatas();
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
