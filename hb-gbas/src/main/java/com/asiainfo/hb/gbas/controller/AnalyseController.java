package com.asiainfo.hb.gbas.controller;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.core.util.DateUtil;
import com.asiainfo.hb.core.util.LogUtil;
import com.asiainfo.hb.gbas.model.AnalyseDao;

/**
 * 指标分析
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/analyse")
public class AnalyseController {
	
	private Logger mLog = LoggerFactory.getLogger(AnalyseController.class);
	
	@Autowired
	private AnalyseDao mAnalyseDao;
	
	/**
	 * 指标分析大屏展示，cycle：daily/monthly
	 * @param model
	 * @param cycle
	 * @return
	 */
	@RequestMapping("/index/{cycle}")
	public String index(Model model, @PathVariable String cycle){
		mLog.debug("--->index, cycle:{}", cycle);
		model.addAttribute("cycle", cycle);
		return "ftl/analyse/index";
	}
	
	@RequestMapping("/getTemplAnalyse")
	@ResponseBody
	public Object getTemplAnalyse(HttpServletRequest req, HttpSession session) throws Exception{
		String cycle = req.getParameter("cycle");
		String startTime = req.getParameter("startTime");
		String endTime = req.getParameter("endTime");
		mLog.info("--->getTemplAnalyse, cycle:{}, startTime:{} ,endTime:{}", new Object[]{cycle, startTime, endTime});
		String userId = (String) session.getAttribute("loginname");
		List<Map<String, Object>> resList = new ArrayList<Map<String, Object>>();
		try {
			List<Map<String, Object>> templateList = mAnalyseDao.getTemplateExt(userId, cycle);
			String sdfPattern;
			if("daily".equals(cycle)){
				sdfPattern = "yyyyMMdd";    
			}else{
				sdfPattern = "yyyyMM"; 
			}
			JSONArray dateList = initDate(startTime, endTime, sdfPattern);
			mLog.info("dateList.size=" + dateList.size());
			
			Map<String, Object> temp = null;
			for(Map<String, Object> map: templateList){
				temp = new HashMap<String, Object>();
				temp.put("name", (String)map.get("name"));
				String codes = (String) map.get("codes");
				codes = codes.substring(0, codes.length() - 1);
				String[] codeArr = codes.split(",");
				if(codeArr.length == 1){
					temp.put("anaData", getOneGbasData(dateList, codes, cycle));
				}else{
					temp.put("anaData", getMultGbasData(dateList, codeArr, cycle, (String)map.get("type")));
				}
				resList.add(temp);
			}
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
			JSONObject obj = new JSONObject();
			if(null != e.getCause()){
				obj.put("msg", e.getCause().getMessage());
			}else{
				obj.put("msg", e.toString());
			}
			obj.put("flag", "-1");
			return obj;
		}
		return resList;
	}

	/**
	 * 指标波动性分析页面入口
	 * @return
	 */
	@RequestMapping("/zbFluctuate")
	public String zbFluctuate(Model model){
		mLog.debug("--->zbFluctuate");
		model.addAttribute("gbasList", JsonHelper.getInstance().write(mAnalyseDao.getGbasList()));
		return "ftl/analyse/zbFluctuate";
	}
	
	@RequestMapping("/getGbasData")
	@ResponseBody
	public Object getGbasData(HttpServletRequest req) throws Exception{
		String cycle = req.getParameter("cycle");
		String startTime = req.getParameter("startTime");
		String endTime = req.getParameter("endTime");
		String gbasCodes = req.getParameter("gbasCodes");
		String type = req.getParameter("type");
		mLog.info("--->getGbasData, cycle:{}; startTime:{}; endTime:{}; gbasCodes:{}; type:{}", new Object[]{cycle, startTime, endTime, gbasCodes, type});
		
		String sdfPattern;
		if("daily".equals(cycle)){
			sdfPattern = "yyyyMMdd";    
		}else{
			sdfPattern = "yyyyMM"; 
		}
		try {
			JSONArray dateList = initDate(startTime, endTime, sdfPattern);
			String[] codeArr = gbasCodes.split(",");
			if(codeArr.length == 1){
				return getOneGbasData(dateList, gbasCodes, cycle);
			}else{
				return getMultGbasData(dateList, codeArr, cycle, type);
			}
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
			JSONObject res = new JSONObject();
			if(null != e.getCause()){
				res.put("msg", e.getCause().getMessage());
			}else{
				res.put("msg", e.toString());
			}
			res.put("flag", "-1");
			return res;
		}
	}
	
	/**
	 * 多个指标分析图数据获取
	 * @param dateList
	 * @param codeArr
	 * @param cycle
	 * @param type
	 * @return
	 */
	private Map<String, Object> getMultGbasData(JSONArray dateList, String[] codeArr, String cycle, String type){
		mLog.debug("--->getMultGbasData, dateList.size:{}; codeArr:{}; cycle:{}; type:{}",
				new Object[]{dateList.size(), codeArr, cycle, type});
		String codes = "";
		for(String code: codeArr){
			codes += "'" + code + "',";
		}
		codes = codes.substring(0, codes.length() -1);
		List<Map<String, Object>> list = mAnalyseDao.getGbasData(cycle, dateList.getString(0).toString(), 
				dateList.get(dateList.size() - 1).toString(), codes);
		JSONArray result = new JSONArray();
		JSONObject temp;
		JSONArray dataList = null;
		JSONArray nameList = new JSONArray();
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
			temp.put("name", gbasName == null ?"": gbasName);
			nameList.add(gbasName == null ?"": gbasName);
			result.add(temp);
		}
		
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("lineData", result);
		res.put("timeList", dateList);
		res.put("nameList", nameList);
		return res;
	}
	
	/**
	 * 单个指标分析图数据获取
	 * @param dateList
	 * @param gbasCode
	 * @param cycle
	 * @return
	 */
	private Map<String, Object> getOneGbasData(JSONArray dateList, String gbasCode, String cycle){
		mLog.debug("--->getOneGbasData, dateList.size:{}; gbasCode:{}; cycle:{}", new Object[]{dateList.size(), gbasCode, cycle});
		Map<String, Object> res = new HashMap<String, Object>();
		List<Map<String, Object>> list = mAnalyseDao.getOneGbasData(cycle, dateList.get(0).toString(),
				dateList.get(dateList.size() - 1).toString(), gbasCode);
		JSONArray nameList = new JSONArray();
		nameList.add("val");
		nameList.add("val1");
		JSONArray dataList = new JSONArray();
		JSONArray dataList1 = new JSONArray();
		for(int i=0; i<dateList.size(); i++){
			float value = 0f;
			float value1 = 0f;
			for(Map<String, Object> map : list){
				if(String.valueOf(map.get("time_id")).equals(dateList.get(i))){
					if(String.valueOf(map.get("name")).equals("gbas_val")){
						value = ((BigDecimal) map.get("val")).floatValue();
					}
					
					if(String.valueOf(map.get("name")).equals("gbas_val1")){
						value1 = ((BigDecimal) map.get("val")).floatValue();
					}
				}
			}
			dataList.add(value);
			dataList1.add(value1);
		}
		JSONArray lineData = new JSONArray();
		JSONObject obj = new JSONObject();
		obj.put("name", nameList.get(0));
		obj.put("type", "line");
		obj.put("data", dataList);
		lineData.add(obj);
		
		obj = new JSONObject();
		obj.put("name", nameList.get(1));
		obj.put("type", "line");
		obj.put("data", dataList1);
		lineData.add(obj);
		
		res.put("lineData", lineData);
		res.put("timeList", dateList);
		res.put("nameList", nameList);
		return res;
	}
	
	/**
	 * 时间段初始化
	 * @param startTime
	 * @param endTime
	 * @param sdfPattern
	 * @return
	 * @throws Exception
	 */
	private JSONArray initDate(String startTime, String endTime, String sdfPattern) throws Exception{
		JSONArray dateArr = new JSONArray();
		
		if(!StringUtils.isEmpty(startTime) && !StringUtils.isEmpty(endTime) && startTime.equals(endTime)){
			dateArr.add(startTime.replace("-", ""));
			return dateArr;
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat(sdfPattern);
		Date startDate = null;
		Date endDate = null;
		if(startTime != null){
			startTime = startTime.replace("-", "");
		}
		if(endTime != null){
			endTime = endTime.replace("-", "");
		}
		
		
		if(StringUtils.isEmpty(startTime)){
			if(StringUtils.isEmpty(endTime)){
				endTime = DateUtil.getCurrentDate(sdfPattern);
			}
			if(sdfPattern.length() == 8){
				startDate = DateUtil.getDateByIntervalDays(sdf.parse(endTime), -6);
			}else{
				startDate = DateUtil.getDateByIntervalMonths(sdf.parse(endTime), -5);
			}
			startTime = sdf.format(startDate);
		}
		
		if(!StringUtils.isEmpty(startTime) && StringUtils.isEmpty(endTime)){
			String currentTime = DateUtil.getCurrentDate(sdfPattern);
			if(!sdf.parse(startTime).before(sdf.parse(currentTime))){
				endTime = startTime;
			}else{
				if(sdfPattern.length() == 8){
					endDate = DateUtil.getDateByIntervalDays(sdf.parse(startTime), 6);
				}else{
					endDate = DateUtil.getDateByIntervalMonths(sdf.parse(startTime), 5);
				}
				endTime = sdf.parse(currentTime).after(endDate)? sdf.format(endDate): currentTime;
			}
		}
		
		List<Date> dateList = null;
		if(sdfPattern.length() == 8){
			dateList = DateUtil.getDatesBetweenTwoDate(sdf.parse(startTime), sdf.parse(endTime));
		}else{
			dateList = DateUtil.getDatesBetweenTwoMon(sdf.parse(startTime), sdf.parse(endTime));
		}
		
		for(Date date : dateList){
			dateArr.add(sdf.format(date));
		}
		
		return dateArr;
	}
	
	@RequestMapping("/saveTemplate")
	@ResponseBody
	public Object saveTemplate(HttpServletRequest req, HttpSession session){
		String userId = (String) session.getAttribute("loginname");
		String name = req.getParameter("name");
		String cycle = req.getParameter("cycle");
		String type = req.getParameter("type");
		String gbasCode = req.getParameter("gbasCode");
		String isFirstPageShow = req.getParameter("isFirstPageShow");
		mLog.info("--->saveTemplate, name:{}; cycle:{}; type:{}; gbasCode:{}; isFirstPageShow:{}", new Object[]{name, cycle, type, gbasCode, isFirstPageShow});
		JSONObject res = new JSONObject();
		try {
			mAnalyseDao.saveTemplate(name, cycle, type, gbasCode, isFirstPageShow, userId);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
			if(null != e.getCause()){
				res.put("msg", e.getCause().getMessage());
			}else{
				res.put("msg", e.toString());
			}
			res.put("flag", "-1");
		}
		return res;
	}
	
	@RequestMapping("/getTemplate")
	@ResponseBody
	public List<Map<String, Object>> getTemplate(HttpServletRequest req, HttpSession session){
		String userId = (String) session.getAttribute("loginname");
		String name = req.getParameter("name");
		try {
			return mAnalyseDao.getTemplate(userId, name);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
		}
		return new ArrayList<Map<String, Object>>();
	}
	
	@RequestMapping("/templageOper")
	@ResponseBody
	public Object templageOper(HttpServletRequest req){
		String ids = req.getParameter("ids");
		String operType = req.getParameter("operType");
		mLog.info("--->templageOper, ids:{}; operType:{}", new Object[]{ids, operType});
		JSONObject res = new JSONObject();
		try {
			if(operType.equals("setShow")){
				mAnalyseDao.updateTemplate(ids, "1");
			}else if(operType.equals("cancelShow")){
				mAnalyseDao.updateTemplate(ids, "0");
			}else if(operType.equals("del")){
				mAnalyseDao.deleteTemplate(ids);
			}
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
			if(null != e.getCause()){
				res.put("msg", e.getCause().getMessage());
			}else{
				res.put("msg", e.toString());
			}
			res.put("flag", "-1");
		}
		return res;
	}
}
