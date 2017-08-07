package com.asiainfo.hb.gbas.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
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
	
	@Autowired
	private TaskDao mTaskDao;
	
	@RequestMapping("/index")
	public String index(){
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
		
		String page = req.getParameter("page");
		String rows = req.getParameter("rows");
		int perPage = 10;
		int currentPage = 1;
		if(!StringUtils.isEmpty(page)){
			currentPage = Integer.valueOf(page);
		}
		if(StringUtils.isEmpty(rows)){
			perPage = Integer.valueOf(rows);
		}
		
		return mTaskDao.getTaskList(param, currentPage, perPage);
	}
	
	@RequestMapping("/execCondition")
	public String execCondition(HttpServletRequest req, Model model){
		String gbasCode = req.getParameter("gbasCode");
		model.addAttribute("nodeData", JsonHelper.getInstance().write(mTaskDao.getNodeData(gbasCode)));
		return "ftl/task/execCondition";
	}

}
