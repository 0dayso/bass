package com.asiainfo.hb.bass.role.adaptation.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.bass.role.adaptation.models.AdapMenu;
import com.asiainfo.hb.bass.role.adaptation.service.AdapMenuService;
import com.asiainfo.hb.bass.role.adaptation.service.AdapReportService;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping("/reportCenter")
@SessionAttributes({ SessionKeyConstants.USER })
public class ReportCenterController {
	@Autowired
	AdapReportService rptService;
	@Autowired
	AdapMenuService aMenuService;

	@RequestMapping(value = "index/{menuId}")
	public String redirectIndex(@PathVariable Integer menuId, HttpServletRequest request, String name, HttpServletResponse response, @ModelAttribute(SessionKeyConstants.USER) User user, Model model) {
		List<Map<String, Object>> hotReports = this.getHotReport(menuId);
		List<Map<String, Object>> reportList = this.getReportRelaData(String.valueOf(menuId), user, "");
		AdapMenu _menu = aMenuService.getOneMenus(String.valueOf(menuId));
		model.addAttribute("menuName", null != _menu && null != _menu.getMenuName() ? _menu.getMenuName() : "");
		model.addAttribute("hotReports", hotReports);
		model.addAttribute("reportList", JsonHelper.getInstance().write(reportList));
		model.addAttribute("menuId", JsonHelper.getInstance().write(menuId));
		model.addAttribute("reportMenu", aMenuService.getRepCenter(name));
		model.addAttribute("title",aMenuService.getTitle(menuId));
		return "ftl/report/newReportCenter";
	}

	// 根据前台传过来name进行查询
	@RequestMapping(value = "/MenuSearch")
	@ResponseBody
	public Map<String, Object> MenuSearch(String name) {
		Map<String, Object> map = new HashMap<String, Object>();
		for (Map<String, Object> Main : aMenuService.getRepCenter(name)) {
			map = Main;
		}
		return map;

	}

	// 获取报表中心左侧菜单数据
	@RequestMapping(value = "/getRepCenter")
	@ResponseBody
	public List<Map<String, Object>> getRepCenter(@ModelAttribute(SessionKeyConstants.USER) User user, @RequestParam(value = "menuId") String menuId) {

		List<Map<String, Object>> reportList = this.getReportRelaData(String.valueOf(menuId), user, "");
		return reportList;
	}

	@RequestMapping(value = "/getReportList")
	public @ResponseBody List<Map<String, Object>> getReportList(@RequestParam(value = "menuId") Integer menuId, @RequestParam(value = "orderByStr") String orderByStr, @RequestParam(value = "nameLike") String nameLike,
			@RequestParam(value = "isKeyWord") String isKeyWord, @RequestParam(value = "pageNumStr") String pageNumStr, @ModelAttribute(SessionKeyConstants.USER) User user, HttpServletRequest request) {
		return this.getReportDataByPage(menuId, orderByStr, nameLike, isKeyWord, pageNumStr, user);
	}

	@RequestMapping(value = "/getReportTable")
	public @ResponseBody List<Map<String, Object>> getReportTable(@RequestParam(value = "menuId") String menuId, @ModelAttribute(SessionKeyConstants.USER) User user, HttpServletRequest request) {
		return this.getReportRelaData(menuId, user, "");
	}

	@RequestMapping(value = "/getReportInfo")
	@ResponseBody
	public List<Map<String, Object>> getReportInfo(@ModelAttribute(SessionKeyConstants.USER) User user, HttpServletRequest request) {
		String menuId = request.getParameter("menuId");
		String reportName = request.getParameter("reportName");
		return this.getReportRelaData(menuId, user, reportName);
	}

	public List<Map<String, Object>> getReportRelaData(String menuId, User user, String reportName) {
		List<Map<String, Object>> rptLevel0 = rptService.getReportLevelMain(menuId, reportName.trim());
		List<Map<String, Object>> rptLevel1 = rptService.getReportLevelChild(menuId, user, reportName.trim());
		for (Map<String, Object> mapMain : rptLevel0) {
			String id = mapMain.get("id").toString().trim();
			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			for (Map<String, Object> mapChild : rptLevel1) {
				String sid = mapChild.get("sid").toString().trim();
				if (id.equals(sid)) {
					list.add(mapChild);
				}
			}
			mapMain.put("child", list);
		}
		return rptLevel0;
	}

	public List<Map<String, Object>> getReportDataByPage(Integer menuId, String orderByStr, String nameLike, String isKeyWord, String pageNumStr, User user) {
		List<Map<String, Object>> list = rptService.getReportDataByPage(menuId, orderByStr, nameLike, isKeyWord, pageNumStr, user);
		return list;
	}

	@RequestMapping(value = "/getHotReport")
	public @ResponseBody List<Map<String, Object>> getHotReport(Integer menuId) {
		return rptService.getHotReport(menuId);
	}
}
