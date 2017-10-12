package com.asiainfo.hb.gbas.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.core.util.LogUtil;
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
		model.addAttribute("isAdmin", mZbDao.checkIsAdmin(user.getId()));
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
		String developer = req.getParameter("developer");
		
		try {
			ZbDef zbDef = new ZbDef();
			zbDef.setZbType(zbType);
			zbDef.setCycle(zbCycle);
			zbDef.setStatus(status);
			zbDef.setZbName(zbName);
			zbDef.setZbCode(zbCode);
			zbDef.setDeveloperName(developer);
			
			mLog.debug("参数：zbType:{}, zbCycle:{}, status:{}, zbName:{}, zbCode:{}", new Object[]{zbType, zbCycle, status, zbName, zbCode});
			
			return mZbDao.getZbList(zbDef, req);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
		}
		return new HashMap<String, Object>();
	}
	
	
	@RequestMapping(value="/saveZbDef")
	@ResponseBody
	public Object saveZbDef(HttpServletResponse resp, HttpServletRequest req,ZbDef zbDef, HttpSession session){
		String optType = req.getParameter("optType");
		mLog.debug("optType:{}", optType);
		JSONObject res = new JSONObject();
		try {
			if("edit".equals(optType)){
				mZbDao.updateZb(zbDef);
				return res;
			}
			
			if("updateDev".equals(optType)){
				mZbDao.updateDevelop(zbDef);
				return res;
			}
			
			User user = (User) session.getAttribute(SessionKeyConstants.USER);
			zbDef.setCreater(user.getId());
			zbDef.setCreaterName(user.getName());
			zbDef.setStatus("0");
			mZbDao.saveZbDef(zbDef);
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
	
	@RequestMapping("/updateStatus")
	@ResponseBody
	public Object updateStatus(HttpServletRequest req){
		JSONObject res = new JSONObject();
		try {
			String zbCode = req.getParameter("zbCode");
			String status = req.getParameter("status");
			
			mLog.debug("zbCode:{}, status:{}", new Object[]{zbCode, status});
			
			mZbDao.updateStatus(zbCode, status);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
			res.put("flag", "-1");
			if(null != e.getCause()){
				res.put("msg", e.getCause().getMessage());
			}else{
				res.put("msg", e.toString());
			}
		}
		return res;
	}
	
	/**
	 * 验证指标唯一性
	 * @param req
	 * @return
	 */
	@RequestMapping("/checkZbCode")
	@ResponseBody
	public boolean checkZbCode(HttpServletRequest req){
		String zbCode = req.getParameter("zbCode");
		return mZbDao.checkZbCode(zbCode);
	}
	
	@RequestMapping("/getUserList")
	@ResponseBody
	public Map<String, Object> getUserList(HttpServletRequest req){
		String name = req.getParameter("userName");
		String id = req.getParameter("userId");
		String cityId = req.getParameter("cityId");
		mLog.debug("name:{}, id:{}, cityId:{}", new Object[]{name, id, cityId});
		try {
			return mZbDao.getUserList(name, id, cityId, req);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
		}
		return new HashMap<String, Object>();
	}
	
}
