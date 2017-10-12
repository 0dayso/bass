package com.asiainfo.hb.gbas.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.core.util.LogUtil;
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
		try {
			return monitorDao.getGroupList();
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
		}
		return new ArrayList<Map<String, Object>>();
	}
	
	@RequestMapping("/getMonitorList")
	@ResponseBody
	public Map<String, Object> getMonitorList(HttpServletRequest req){
		String name = req.getParameter("name");
		String cycle = req.getParameter("cycle");
		mLog.debug("------>getMonitorList, name:{}, cycle:{}", new Object[]{name, cycle});
		try {
			return monitorDao.getMonitorList(req, name, cycle);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
		}
		return new HashMap<String, Object>();
	}
	
	@RequestMapping("/saveMonitor")
	@ResponseBody
	public Object saveMonitor(HttpServletRequest req, Monitor monitor){
		if(!StringUtils.isEmpty(monitor.getGroupId())){
			monitor.setGroupId(monitor.getGroupId().replace(",", ";"));
		}
		JSONObject res = new JSONObject();
		try {
			if(StringUtils.isEmpty(monitor.getChkId())){
				monitorDao.saveMonitor(monitor);
				return res;
			}
			monitorDao.updateMonitor(monitor);
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
	
	@RequestMapping("/getLogList")
	@ResponseBody
	public List<Map<String, Object>> getLogList(HttpServletRequest req){
		String chkId = req.getParameter("chkId");
		try {
			return monitorDao.getLogList(chkId);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
		}
		return new ArrayList<Map<String, Object>>();
	}

}
