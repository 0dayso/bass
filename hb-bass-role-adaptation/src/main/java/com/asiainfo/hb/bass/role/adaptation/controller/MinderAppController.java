package com.asiainfo.hb.bass.role.adaptation.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.bass.role.adaptation.service.MinderAppService;

/**
 * 营销资源管理
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/minderApp")
public class MinderAppController {
	
	@Autowired
	MinderAppService mindService;
	
	@RequestMapping(value = "/index")
	public String index(Model model){
		List<Map<String, Object>> cityList = mindService.getCity();
		Map<String, Object> timeMap = mindService.queryCostMaxTime();
		String maxTime = "";
		if(!StringUtils.isEmpty(timeMap.get("maxtime"))){
			maxTime = String.valueOf(timeMap.get("maxtime"));
			maxTime = maxTime.substring(0, 4) + "-" + maxTime.substring(4, 6);
		}
		model.addAttribute("cityList", cityList);
		model.addAttribute("defaultTime", maxTime);
		return "ftl/minderapp/cawu_index";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/queryCostData")
	@ResponseBody
	public List<Map<String, Object>> queryCostData(HttpServletRequest request){
		String time = request.getParameter("time");
		String areaCode = request.getParameter("areaCode");
		time = time.replace("-", "");
		List<Map<String, Object>> list = mindService.queryCostData(time, areaCode);
		if(list != null && list.size()>0){
			Map<String, Object> temp = new HashMap<String, Object>();
			List<Map<String, Object>> resultList = new ArrayList<Map<String,Object>>();
			for(Map<String, Object> map : list){
				if(String.valueOf(map.get("level")).equals("0")){
					List<Map<String,Object>> childArr = new ArrayList<Map<String,Object>>();
					temp.put((String) map.get("cost_code"), childArr);
					map.put("child", temp.get(String.valueOf(map.get("cost_code"))));
					resultList.add(map);
				}else{
					List<Map<String, Object>> child = (List<Map<String, Object>>) temp.get(String.valueOf(map.get("p_cost_code")));
					child.add(map);
					temp.put(String.valueOf(map.get("p_cost_code")) , child);
				}
			}
			return resultList;
		}
		return new ArrayList<Map<String,Object>>();
	}

}
