package com.asiainfo.hb.gbas.controller;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.core.util.DateUtil;
import com.asiainfo.hb.gbas.model.AnalyseDao;

@Controller
@RequestMapping("/analyse")
public class AnalyseController {
	
	@Autowired
	private AnalyseDao mAnalyseDao;

	/**
	 * 指标波动性分析页面入口
	 * @return
	 */
	@RequestMapping("/zbFluctuate")
	public String zbFluctuate(Model model){
		model.addAttribute("gbasList", JsonHelper.getInstance().write(mAnalyseDao.getGbasList()));
		return "ftl/analyse/zbFluctuate";
	}
	
	@RequestMapping("/getGbasData")
	@ResponseBody
	public Map<String, Object> getGbasData(HttpServletRequest req) throws Exception{
		String cycle = req.getParameter("cycle");
		String startTime = req.getParameter("startTime");
		String endTime = req.getParameter("endTime");
		String gbasCodes = req.getParameter("gbasCodes");
		String type = req.getParameter("type");
		
		startTime = startTime.replace("-", "");
		endTime = endTime.replace("-", "");
		String sdfPattern;
		if("daily".equals(cycle)){
			sdfPattern = "yyyyMMdd";    
		}else{
			sdfPattern = "yyyyMM"; 
		}
		JSONArray dateList = initDate(startTime, endTime, sdfPattern);
		
		String[] codeArr = gbasCodes.split(",");
		List<Map<String, Object>> list = mAnalyseDao.getGbasData(cycle, dateList.getString(0).toString(), 
				dateList.get(dateList.size() - 1).toString(), gbasCodes);
		JSONArray result = new JSONArray();
		JSONObject temp;
		JSONArray dataList = null;
		JSONArray nameList = new JSONArray();
		Map<String, Object> res = new HashMap<String, Object>();
		for(String code: codeArr){
			temp = new JSONObject();
			dataList = new JSONArray();
			String gbasName = "";
			for(int i=0; i<dateList.size(); i++){
				float value = 0f;
				for(Map<String, Object> map: list){
					if(code.equals((String)map.get("gbas_code"))){
						gbasName = String.valueOf(map.get("gbas_name"));
						if((String.valueOf(map.get("time_id"))).equals(dateList.get(i))){
							value = ((BigDecimal) map.get("gbas_val")).floatValue();
							break;
						}
					}
				}
				dataList.add(value);
			}
			if(StringUtils.isEmpty(gbasName)){
				gbasName = mAnalyseDao.getGbasNameByCode(code, type);
			}
			temp.put("data", dataList);
			temp.put("type", "line");
			temp.put("name", gbasName);
			nameList.add(gbasName);
			result.add(temp);
		}
		
		res.put("lineData", result);
		res.put("timeList", dateList);
		res.put("nameList", nameList);
		return res;
	}
	
	
	private JSONArray initDate(String startTime, String endTime, String sdfPattern) throws Exception{
		SimpleDateFormat sdf = new SimpleDateFormat(sdfPattern);
		Date startDate = null;
		Date endDate = null;
		if(StringUtils.isEmpty(startTime)){
			if(StringUtils.isEmpty(endTime)){
				endTime = DateUtil.getCurrentDate(sdfPattern);
			}
			if(sdfPattern.length() == 8){
				startDate = DateUtil.getDateByIntervalDays(sdf.parse(endTime), -7);
			}else{
				startDate = DateUtil.getDateByIntervalMonths(sdf.parse(endTime), -6);
			}
			startTime = sdf.format(startDate);
		}
		
		if(!StringUtils.isEmpty(startTime) && StringUtils.isEmpty(endTime)){
			String currentTime = DateUtil.getCurrentDate(sdfPattern);
			if(sdfPattern.length() == 8){
				endDate = DateUtil.getDateByIntervalDays(sdf.parse(startTime), 7);
			}else{
				endDate = DateUtil.getDateByIntervalMonths(sdf.parse(startTime), 6);
			}
			endTime = sdf.parse(currentTime).after(endDate)? sdf.format(endDate): currentTime;
		}
		
		List<Date> dateList = null;
		if(sdfPattern.length() == 8){
			dateList = DateUtil.getDatesBetweenTwoDate(sdf.parse(startTime), sdf.parse(endTime));
		}else{
			dateList = DateUtil.getDatesBetweenTwoMon(sdf.parse(startTime), sdf.parse(endTime));
		}
		JSONArray dateArr = new JSONArray();
		for(Date date : dateList){
			dateArr.add(sdf.format(date));
		}
		
		return dateArr;
	}
	
}
