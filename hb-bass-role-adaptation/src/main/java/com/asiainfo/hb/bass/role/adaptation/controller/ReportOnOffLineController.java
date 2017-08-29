package com.asiainfo.hb.bass.role.adaptation.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.bass.role.adaptation.service.ReportOnOffLineService;

/**
 * 报表上下线
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/report/onoffline")
public class ReportOnOffLineController {
	
	@Autowired
	private ReportOnOffLineService mReportService;
	
	@RequestMapping("/index")
	public String index(){
		return "ftl/reportOnOffLine/index";
	}
	
	@RequestMapping("/online")
	public String online(Model model){
		model.addAttribute("menuList", mReportService.getMenuList());
		return "ftl/reportOnOffLine/online";
	}
	
	@RequestMapping("/offline")
	public String offline(Model model){
		model.addAttribute("menuList", mReportService.getMenuList());
		return "ftl/reportOnOffLine/offline";
	}
	
	@RequestMapping("/changeSort")
	@ResponseBody
	public void changeSort(HttpServletRequest req){
		String menuId = req.getParameter("menuId");
		String sortId = req.getParameter("sortId");
		String rid = req.getParameter("rid");
		mReportService.changeSort(rid, menuId, sortId);
	}
	
	/**
	 * 查询已上线报表
	 * @param req
	 * @return
	 */
	@RequestMapping("/getHasOnlineReport")
	@ResponseBody
	public Object getHasOnlineReport(HttpServletRequest req){
		String page = req.getParameter("page");
		String rows = req.getParameter("rows");
		int perPage = 10;
		int currentPage = 1;
		if(!StringUtils.isEmpty(page)){
			currentPage = Integer.valueOf(page);
		}
		if(!StringUtils.isEmpty(rows)){
			perPage = Integer.valueOf(rows);
		}
		
		String menuId = req.getParameter("menuId");
		String reportName = req.getParameter("reportName");
		String reportId = req.getParameter("reportId");
		
		return mReportService.getHasOnlineReport(menuId, reportName,reportId, perPage, currentPage);
	}
	
	@RequestMapping(value="/offlineRpt")
	@ResponseBody
	public void offlineRpt(HttpServletRequest req){
		String reportId = req.getParameter("reportId");
		String url = req.getParameter("resourceUri");
		mReportService.offLineRpt(reportId, url);
	}
	
	@RequestMapping("/getWaitOnLineReport")
	@ResponseBody
	public Object getWaitOnLineReport(HttpServletRequest req){
		String page = req.getParameter("page");
		String rows = req.getParameter("rows");
		int perPage = 10;
		int currentPage = 1;
		if(!StringUtils.isEmpty(page)){
			currentPage = Integer.valueOf(page);
		}
		if(!StringUtils.isEmpty(rows)){
			perPage = Integer.valueOf(rows);
		}
		
		String rid = req.getParameter("rid");
		String name = req.getParameter("name");
		
		return mReportService.getWaitOnLineReport(name, rid, perPage, currentPage);
	}
	
	@RequestMapping("/getSortList")
	@ResponseBody
	public List<Map<String, Object>> getSortList(HttpServletRequest req){
		String menuId = req.getParameter("menuId");
		String name = req.getParameter("sortName");
		List<Map<String, Object>> list = mReportService.getSortList(menuId, name);
		list.get(0).put("selected", true);
		return list;
	}
	
	@RequestMapping("/onLineRpt")
	@ResponseBody
	public void onLineRpt(HttpServletRequest req){
		String rid = req.getParameter("rid");
		String menuId = req.getParameter("menuId");
		String sortId = req.getParameter("sortId");
		String sortNum = req.getParameter("sortNum");
		String keyWord = req.getParameter("keyWord");
		String rptCycle = req.getParameter("rptCycle");
		mReportService.onLineRpt(menuId, sortId, rid, sortNum, keyWord, rptCycle);
	}
	
	@RequestMapping("/addRptSort")
	@ResponseBody
	public void addRptSort(HttpServletRequest req){
		String menuId = req.getParameter("menuId");
		String name = req.getParameter("name");
		String sortNum = req.getParameter("sortNum");
		String sortId = req.getParameter("sortId");
		if(StringUtils.isEmpty(sortId)){
			mReportService.addRptSort(menuId, name, sortNum);
		}else{
			mReportService.updateRptSort(sortId, menuId, name, sortNum);
		}
	}

	
	@RequestMapping("/delRptSort")
	@ResponseBody
	public void delRptSort(HttpServletRequest req){
		String sortIds = req.getParameter("ids");
		mReportService.deleteRptSort(sortIds);
	}
}
