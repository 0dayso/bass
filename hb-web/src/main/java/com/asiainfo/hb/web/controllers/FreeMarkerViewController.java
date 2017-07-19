package com.asiainfo.hb.web.controllers;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 
 * @author Mei Kefu
 * @date 2011-3-15
 */
@Controller
@RequestMapping("/views/ftl/**")
public class FreeMarkerViewController {
	//与@RequestMapping的需要一致
	String mappingValue = "/views/";
	
	@RequestMapping(method=RequestMethod.GET)
	public String ftlRedirect(HttpServletRequest request) {
		String path=request.getRequestURI().replaceAll(request.getSession().getAttribute("mvcPath")+mappingValue, "");
		return path;
	}
}


