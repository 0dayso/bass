package com.asiainfo.hb.bass.log.visit.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.bass.log.visit.service.VisitLogService;

/**
 * 访问日志统计
 * 
 * @author king-pan
 *
 */
@Controller
@RequestMapping("/visit/log")
public class VisitLogController {

	@Autowired
	private VisitLogService visitLogService;

	@RequestMapping("/page")
	public String page() {
		return "ftl/visit-log/index";
	}

	@RequestMapping(value = { "/visitLogList" })
	@ResponseBody
	public Object reportPageList(@RequestParam(value="areaId",required=false) String areaId, @RequestParam(value="startDate",required=false) String startDate,
			@RequestParam(value="endDate",required=false) String endDate) {
		Map<String, Object> params = new HashMap<>();
		if(StringUtils.isNotBlank(areaId)) {
			params.put("areaId", areaId);
		}
		if(StringUtils.isNotBlank(startDate)) {
			params.put("startDate", startDate);
		}
		if(StringUtils.isNotBlank(endDate)) {
			params.put("endDate", endDate);
		}
		System.out.println(params);
		int page = 1;
		int rows = 30;
		return visitLogService.getPageList(page, rows, params);
	}

	@RequestMapping(value = { "/cityList" })
	@ResponseBody
	public Object cityList() {
		return visitLogService.getCityList();
	}

}
