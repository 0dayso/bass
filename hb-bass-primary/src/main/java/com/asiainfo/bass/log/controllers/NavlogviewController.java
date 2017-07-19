package com.asiainfo.bass.log.controllers;



import java.util.HashMap;
import java.util.List;
import java.util.Map;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.bass.log.model.JournalModel;
import com.asiainfo.bass.log.model.NavlogviewModel;
import com.asiainfo.bass.log.service.JournalService;
import com.asiainfo.bass.log.service.NavlogviewService;
import com.asiainfo.hb.web.SessionKeyConstants;

@SuppressWarnings("unused")
@Controller
@RequestMapping("/navlogview")
@SessionAttributes({ SessionKeyConstants.USER })
public class NavlogviewController {
	
	@Autowired
	NavlogviewService navlogviewlService;
	@RequestMapping("/selectnavlogview")
	@ResponseBody
	public Map<String,Object> selectnavlogview (NavlogviewModel navlogviewModel){
		return navlogviewlService.selectnavlogview(navlogviewModel);
	}
	@RequestMapping("/selectCity")
	@ResponseBody
	public List<Map<String,Object>> selectCity(){
		return navlogviewlService.selectCity();
	}
	@RequestMapping("/select")
	public String selelct(){
		return "ftl/log/navlogview";
	}
}
