package com.asiainfo.hb.gbas.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.gbas.model.TaskDao;

/**
 * 任务运行概况
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/task")
public class TaskController {
	
	private Logger mLog = LoggerFactory.getLogger(TaskController.class);
	
	@Autowired
	private TaskDao mTaskDao;
	
	@RequestMapping("/index")
	public String index(){
		mLog.debug("---index---");
		return "ftl/task/task";
	}
	
	@RequestMapping("/getTaskList")
	@ResponseBody
	public Map<String, Object> getTaskList(HttpServletRequest req){
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("type", req.getParameter("type"));
		param.put("cycle", req.getParameter("cycle"));
		param.put("etl_status", req.getParameter("status"));
		param.put("gbas_code like", req.getParameter("name"));
		
		return mTaskDao.getTaskList(param, req);
	}
	
	@RequestMapping("/execCondition")
	public String execCondition(HttpServletRequest req, Model model){
		String gbasCode = req.getParameter("gbasCode");
		mLog.debug("---execCondition---, gbasCode:" + gbasCode);
		model.addAttribute("nodeData", JsonHelper.getInstance().write(mTaskDao.getNodeData(gbasCode)));
		return "ftl/task/execCondition";
	}

}
