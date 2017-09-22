package com.asiainfo.hb.gbas.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.gbas.model.Monitor;
import com.asiainfo.hb.gbas.model.MonitorDao;

/**
 * 接口时限告警
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/monitor")
public class MonitorController {
	
	private Logger mLog = LoggerFactory.getLogger(MonitorController.class);
	
	@Autowired
	private MonitorDao monitorDao;
	
	@RequestMapping("/index")
	public String index(){
		return "ftl/monitor";
	}
	
	@RequestMapping("/getGroupList")
	@ResponseBody
	public List<Map<String, Object>> getGroupList(){
		return monitorDao.getGroupList();
	}
	
	@RequestMapping("/getMonitorList")
	@ResponseBody
	public Map<String, Object> getMonitorList(HttpServletRequest req){
		String name = req.getParameter("name");
		String cycle = req.getParameter("cycle");
		mLog.debug("------>getMonitorList, name=" + name + ",cycle=" + cycle);
		return monitorDao.getMonitorList(req, name, cycle);
	}
	
	@RequestMapping("/saveMonitor")
	@ResponseBody
	public void saveMonitor(HttpServletRequest req, Monitor monitor){
		if(!StringUtils.isEmpty(monitor.getGroupId())){
			monitor.setGroupId(monitor.getGroupId().replace(",", ";"));
		}
		if(StringUtils.isEmpty(monitor.getChkId())){
			monitorDao.saveMonitor(monitor);
			return;
		}
		monitorDao.updateMonitor(monitor);
	}
	
	@RequestMapping("/getLogList")
	@ResponseBody
	public List<Map<String, Object>> getLogList(HttpServletRequest req){
		String chkId = req.getParameter("chkId");
		return monitorDao.getLogList(chkId);
	}

}
