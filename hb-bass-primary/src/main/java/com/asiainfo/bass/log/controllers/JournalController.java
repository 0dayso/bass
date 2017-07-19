package com.asiainfo.bass.log.controllers;


import java.util.Map;



import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.bass.log.model.JournalModel;
import com.asiainfo.bass.log.service.JournalService;
import com.asiainfo.hb.web.SessionKeyConstants;

@Controller
@RequestMapping("/journal")
@SessionAttributes({ SessionKeyConstants.USER })
public class JournalController {
	public Logger logger = LoggerFactory.getLogger(JournalController.class);
	@Autowired
	JournalService journalService;
	@RequestMapping("/selectlog")
	@ResponseBody
	public Map<String,Object> selectjournal (JournalModel journalModel){
		return journalService.selectjournal(journalModel);
	}
	@RequestMapping("/select")
	public String selelct(){
		return "ftl/log/loginlogquery";
		 
	}
}
