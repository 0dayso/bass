package com.asiainfo.hb.gbas.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.gbas.model.ExportConfigDao;
import com.asiainfo.hb.gbas.model.TaskConfig;

/**
 * 导出配置管理
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/exportConfig")
public class ExportConfigController {
	
	@Autowired
	private ExportConfigDao mExportDao;
	private Logger mLog = LoggerFactory.getLogger(ExportConfigController.class);
	
	@RequestMapping("/index")
	public String index(){
		return "ftl/exportConfig";
	}
	
	@RequestMapping("/getConfigList")
	@ResponseBody
	public Map<String, Object> getConfigList(HttpServletRequest req){
		return mExportDao.getConfigList(req);
	}
	
	@RequestMapping("/getTaskParam")
	@ResponseBody
	public List<Map<String, Object>> getTaskParam(HttpServletRequest req){
		String taskId = req.getParameter("taskId");
		List<Map<String, Object>> list = mExportDao.getTaskParam(taskId);
		if(list != null && list.size() > 0){
			return list;
		}
		return this.initParam(taskId);
	}
	
	private List<Map<String, Object>> initParam(String taskId){
		int count = mExportDao.getTaskParamColumnCount(taskId);
		List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
		Map<String, Object> map;
		for(int i=0; i<count; i++){
			map = new HashMap<String, Object>();
			map.put("param_type", "0");
			map.put("param_len", "3");
			map.put("target_len", "10");
			map.put("conv_param", "0");
			list.add(map);
		}
		return list;
	}

	@RequestMapping("/saveTaskParam")
	@ResponseBody
	public void saveTaskParam(HttpServletRequest req){
		String taskId = req.getParameter("taskId");
		String datas = req.getParameter("rows");
		mLog.info("------>saveTaskParam; taskId=" + taskId);
		JSONArray arr = JSONArray.fromObject(datas);
		mExportDao.saveTaskParam(taskId, arr);
	}
	
	@RequestMapping("/saveTaskConfig")
	@ResponseBody
	public void saveTaskConfig(HttpServletRequest req, TaskConfig config){
		if("".equals(config.getFilterType())){
			config.setFilterType(null);
		}
		
		if("".equals(config.getStatus())){
			config.setStatus(null);
		}
		
		if("".equals(config.getTaskType())){
			config.setTaskType(null);
		}
		
		if(StringUtils.isEmpty(config.getTaskId())){
			mExportDao.saveTaskConfig(config);
			return;
		}
		
		mExportDao.updateTaskConfig(config);
	}
	
	@RequestMapping("/delTaskConfig")
	@ResponseBody
	public void delTaskConfig(HttpServletRequest req){
		String taskId = req.getParameter("taskId");
		mExportDao.delTaskConfig(taskId);
	}
	
}
