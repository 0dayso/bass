package com.asiainfo.hb.gbas.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.gbas.model.ZbDao;
import com.asiainfo.hb.gbas.model.ZbDef;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * 指标管理
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/zb")
public class ZbController {
	
	private Logger mLog = LoggerFactory.getLogger(ZbController.class);

	@Autowired
	private ZbDao mZbDao;
	
	@RequestMapping("/index")
	public String index(HttpSession session, Model model){
		User user = (User) session.getAttribute(SessionKeyConstants.USER);
		model.addAttribute("userId", user.getId());
		model.addAttribute("userName", user.getName());
		return "ftl/zb";
	}
	
	@RequestMapping("/getZbList")
	@ResponseBody
	public Map<String, Object> getZbList(HttpServletRequest req){
		
		String zbType = req.getParameter("zbType");
		String zbCycle = req.getParameter("zbCycle");
		String status = req.getParameter("status");
		String zbName = req.getParameter("zbName");
		String zbCode = req.getParameter("zbCode");
		
		ZbDef zbDef = new ZbDef();
		zbDef.setZbType(zbType);
		zbDef.setCycle(zbCycle);
		zbDef.setStatus(status);
		zbDef.setZbName(zbName);
		zbDef.setZbCode(zbCode);
		
		String page = req.getParameter("page");
		String rows = req.getParameter("rows");
		int perPage = 10;
		int currentPage = 1;
		if(!StringUtils.isEmpty(page)){
			currentPage = Integer.valueOf(page);
		}
		if(!StringUtils.isEmpty(rows)){
			perPage = Integer.valueOf(rows);
		}
		
		mLog.debug("参数：page=" + page + ", rows=" + rows + ",zbType=" + zbType + ",zbCycle=" +
					zbCycle + ",status=" + status + ",zbName=" + zbName + ",zbCode=" + zbCode);
		
		return mZbDao.getZbList(zbDef, perPage, currentPage);
	}
	
	
	@RequestMapping(value="/saveZbDef")
	@ResponseBody
	public boolean saveZbDef(HttpServletResponse resp, HttpServletRequest req,ZbDef zbDef, HttpSession session){
		String optType = req.getParameter("optType");
		if(optType.equals("edit")){
			mZbDao.updateZb(zbDef);
			return true;
		}
		
		return mZbDao.saveZbDef(zbDef);
	}

	@RequestMapping("/deleteZbDef")
	@ResponseBody
	public void deleteZbDef(HttpServletRequest req){
		String zbCode = req.getParameter("zbCode");
		mZbDao.deleteZb(zbCode);
	}
	
	@RequestMapping("/checkZbCode")
	@ResponseBody
	public boolean checkZbCode(HttpServletRequest req){
		String zbCode = req.getParameter("zbCode");
		return mZbDao.checkZbCode(zbCode);
	}
	
	@RequestMapping("/getUserList")
	@ResponseBody
	public Map<String, Object> getUserList(HttpServletRequest req){
		String page = req.getParameter("page");
		String rows = req.getParameter("rows");
		int perPage = 10;
		int currentPage = 1;
		if(!StringUtils.isEmpty(page)){
			currentPage = Integer.valueOf(page);
		}
		if(!StringUtils.isEmpty(rows)){
			perPage = Integer.valueOf(rows);
		}
		String name = req.getParameter("userName");
		String id = req.getParameter("userId");
		String cityId = req.getParameter("cityId");
		return mZbDao.getUserList(name, id, cityId, perPage, currentPage);
	}
	
}
