package com.asiainfo.bass.log.controllers;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.bass.log.model.LogCheckModel;
import com.asiainfo.bass.log.service.LogCheckService;
import com.asiainfo.hb.web.SessionKeyConstants;

@Controller
@RequestMapping("/logCheck")
@SessionAttributes({ SessionKeyConstants.USER })
public class LogCheckController {
	@Autowired
	LogCheckService logCheckService;
	@RequestMapping("/selectcyti")
	@ResponseBody
	public List<Map<String,Object>> selectcyti(){
		return logCheckService.selectCity();
	}
	@RequestMapping("/selectLogCheck")
	@ResponseBody
	public Map<String,Object> selectLogCheck(LogCheckModel logCheckModel){
		return logCheckService.selectLogCheck(logCheckModel);
	}
	@RequestMapping("/select")
	public String selelct(){
		return "ftl/log/logcheck";
	}
}
