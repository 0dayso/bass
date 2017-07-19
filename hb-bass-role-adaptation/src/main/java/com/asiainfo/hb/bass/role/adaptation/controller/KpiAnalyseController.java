package com.asiainfo.hb.bass.role.adaptation.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.asiainfo.hb.bass.role.adaptation.service.KpiAnalyseService;

/**
 * 
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/kpiAna")
public class KpiAnalyseController {
	
	@Autowired
	KpiAnalyseService anaService;
	
	@RequestMapping(value = "/{bocId}")
	public String index(@PathVariable String bocId, Model model){
		
		Map<String ,Object> kpiInfo = anaService.getKpiInfo(bocId);
		String date = getLastDay();
		model.addAttribute("bocId", bocId);
		model.addAttribute("date", date);
		model.addAttribute("kpiName", kpiInfo.get("name") != null ? kpiInfo.get("name"):"");
		model.addAttribute("kpiDesc", kpiInfo.get("desc") != null ? kpiInfo.get("desc"):"");
		
		return "ftl/kpiAna/kpiAna";
	}
	
	private String getLastDay(){
		Date date=new Date();//取时间
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(date);
		calendar.add(Calendar.DATE,-1);//把日期往后增加一天.整数往后推,负数往前移动
		date=calendar.getTime(); //这个时间就是日期往后推一天的结果 
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		String dateString = formatter.format(date);
		return dateString;
	}
	
}
