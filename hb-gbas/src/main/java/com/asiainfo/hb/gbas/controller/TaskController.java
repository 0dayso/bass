package com.asiainfo.hb.gbas.controller;

import java.util.HashMap;
import java.util.List;
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
	
	/**
	 * 任务运行概况页面入口
	 * @return
	 */
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
	
	/**
	 * 查看执行条件页面入口
	 * @param req
	 * @param model
	 * @return
	 */
	@RequestMapping("/execCondition")
	public String execCondition(HttpServletRequest req, Model model){
		String gbasCode = req.getParameter("gbasCode");
		mLog.debug("---execCondition---, gbasCode:" + gbasCode);
		model.addAttribute("nodeData", JsonHelper.getInstance().write(mTaskDao.getNodeData(gbasCode)));
		return "ftl/task/execCondition";
	}
	
	/**
	 * 修改任务状态，强制执行和重新执行只该状态，后台监控执行
	 * @param req
	 */
	@RequestMapping("/updateStatus")
	@ResponseBody
	public void updateStatus(HttpServletRequest req){
		String id = req.getParameter("id");
		String status = req.getParameter("status");
		mLog.info("------>updateStatus; id=" + id + ", status=" + status);
		mTaskDao.updateStatus(id, status);
	}

	@RequestMapping("/getLog")
	@ResponseBody
	public List<Map<String, Object>> getLog(HttpServletRequest req){
		String id = req.getParameter("id");
		mLog.debug("------>getLog; id=" + id);
		return mTaskDao.queryLog(id);
	}
	
	@RequestMapping("/getDepsProcStatus")
	@ResponseBody
	public List<Map<String, Object>> getDepsProcStatus(HttpServletRequest req){
		String etlCycle = req.getParameter("etlCycle");
		String gbasCode = req.getParameter("gbasCode");
		return mTaskDao.getDepsProcStatus(gbasCode, etlCycle);
	}
}
