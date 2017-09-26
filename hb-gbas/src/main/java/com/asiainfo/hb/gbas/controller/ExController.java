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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.asiainfo.hb.gbas.model.ExDao;
import com.asiainfo.hb.gbas.model.ExDef;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * 接口管理
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/ex")
public class ExController {
	
	private Logger mLog = LoggerFactory.getLogger(ExController.class);
	
	@Autowired
	private ExDao mExDao;
	
	/**
	 * 接口管理页面入口
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping("/index")
	public String index(HttpSession session, Model model){
		User user = (User) session.getAttribute(SessionKeyConstants.USER);
		model.addAttribute("userId", user.getId());
		model.addAttribute("userName", user.getName());
		model.addAttribute("isAdmin", mExDao.checkIsAdmin(user.getId()));
		return "ftl/ex";
	}

	@RequestMapping("/getExList")
	@ResponseBody
	public Map<String, Object> getExList(HttpServletRequest req){
		
		String exCycle = req.getParameter("exCycle");
		String status = req.getParameter("status");
		String exName = req.getParameter("exName");
		String exCode = req.getParameter("exCode");
		String developer = req.getParameter("developer");
		
		ExDef exDef = new ExDef();
		exDef.setCycle(exCycle);
		exDef.setStatus(status);
		exDef.setExName(exName);
		exDef.setExCode(exCode);
		exDef.setDeveloperName(developer);
		
		mLog.debug("参数：exCycle=" + exCycle + ",status=" + status + ",exName=" + exName + ",exCode=" + exCode);
		
		return mExDao.getExList(exDef, req);
	}
	
	
	@RequestMapping(value="/saveExDef")
	@ResponseBody
	public boolean saveExDef(HttpServletResponse resp, HttpServletRequest req,ExDef exDef, HttpSession session){
		String optType = req.getParameter("optType");
		if("edit".equals(optType)){
			mExDao.updateEx(exDef);
			return true;
		}
		
		if("updateDev".equals(optType)){
			mExDao.updateDevelop(exDef);
			return true;
		}
		
		User user = (User) session.getAttribute(SessionKeyConstants.USER);
		exDef.setCreater(user.getId());
		exDef.setCreaterName(user.getName());
		exDef.setStatus("0");
		return mExDao.saveExDef(exDef);
	}
	
	@RequestMapping("/updateStatus")
	@ResponseBody
	public void updateStatus(HttpServletRequest req){
		String exCode = req.getParameter("exCode");
		String status = req.getParameter("status");
		mExDao.updateStatus(exCode, status);
	}

	/**
	 * 查询接口code是否唯一
	 * @param req
	 * @return
	 */
	@RequestMapping("/checkExCode")
	@ResponseBody
	public boolean checkExCode(HttpServletRequest req){
		String exCode = req.getParameter("exCode");
		return mExDao.checkExCode(exCode);
	}
	
}
