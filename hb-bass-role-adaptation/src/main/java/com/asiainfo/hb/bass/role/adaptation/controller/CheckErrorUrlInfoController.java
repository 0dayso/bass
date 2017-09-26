package com.asiainfo.hb.bass.role.adaptation.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.bass.role.adaptation.service.CheckErrorUrlInfoService;

/**
 * 查询定时访问失败的url信息
 * @author chendb
 *
 */
@Controller
@RequestMapping("/CheckErrorUrlInfo")
public class CheckErrorUrlInfoController {
	
	private int rows = 20;//默认行数
	private int page = 1;//默认当前页

	@Autowired
	CheckErrorUrlInfoService checkErrorUrlInfoService;
	
	@RequestMapping("/index")
	public String online(Model model){
		return "ftl/errorPageInfo/errorPageInfo";
	}
	
	@RequestMapping("/getAllErrorUrlInfo")	
	@ResponseBody
	public Object getAllErrorUrlInfo(HttpServletRequest request){
		String menuItemTitle = request.getParameter("menuitemtitle");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		int pageSize = request.getParameter("rows") ==null?rows:Integer.valueOf(request.getParameter("rows"));
		int pageNum = request.getParameter("page") ==null?page:Integer.valueOf(request.getParameter("page"));
		return checkErrorUrlInfoService.getErrorUrlInfo(menuItemTitle, startDate, endDate, pageSize, pageNum);
	}
	
	@RequestMapping("/delErrorUrl")
	@ResponseBody
	public void delErrorUrlInfo(HttpServletRequest request){
		String errorPageId = request.getParameter("errorPageIds");
		checkErrorUrlInfoService.deleteInfo(errorPageId);
	}
}
