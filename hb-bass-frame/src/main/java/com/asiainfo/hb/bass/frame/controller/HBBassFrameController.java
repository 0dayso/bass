/**
 * 
 */
package com.asiainfo.hb.bass.frame.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.bass.frame.models.MenuBean;
import com.asiainfo.hb.bass.frame.models.NoticeBean;
import com.asiainfo.hb.bass.frame.service.MenuService;
import com.asiainfo.hb.bass.role.adaptation.service.AdapMenuService;
import com.asiainfo.hb.bass.role.adaptation.service.AdapService;
import com.asiainfo.hb.core.models.Configuration;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * @author zhangds
 * 
 */
@Controller
@RequestMapping("/HBBassFrame")
@SessionAttributes({SessionKeyConstants.USER})
@SuppressWarnings({"rawtypes","unused"})
public class HBBassFrameController {
	
	public Logger logger = LoggerFactory.getLogger(HBBassFrameController.class);
	
	@Autowired
	MenuService menuService;
	
	@Autowired
	AdapMenuService aMenuService;
	@Autowired
	AdapService adapService;
	
	@RequestMapping(value="index")
	public String redirectRealIndex(HttpServletRequest request,HttpServletResponse response,@ModelAttribute(SessionKeyConstants.USER) User user,Model model){
		String appName = Configuration.getInstance().getProperty("com.asiainfo.pst.controllers.FrameController.appName");
		String userid = user.getId();
		model.addAttribute("appName", appName==null?"经分首页":appName);
		model.addAttribute("user", user);
		List<MenuBean> list = menuService.getSysAllMenu(userid);
		model.addAttribute("menus", JsonHelper.getInstance().write(list));
		return "ftl/index2/main";
	}
	
	/**
	 * 主页
	 * @param request
	 * @param response
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value="main")
	public String test(HttpServletRequest request,HttpServletResponse response,@ModelAttribute(SessionKeyConstants.USER) User user,Model model){
		List TopThreeNews = adapService.getTopThreeNews();
		List lastestOnlineReport = adapService.getLastOnlineReport("-1", "", user.getId());
		//热门kpi
		List TopKpi=adapService.getTopKpi();
		model.addAttribute("TopKpi",TopKpi);
		//公告
		model.addAttribute("TopThreeNews",TopThreeNews);
		//最新上线
		model.addAttribute("lastestOnlineReport", lastestOnlineReport);
		return "ftl/index2/index";
	}
	
	@RequestMapping(value="/applyAbility")
	public String labilManager(HttpServletRequest request,HttpServletResponse response,@ModelAttribute(SessionKeyConstants.USER) User user,Model model){
	 List  applyAbiList=adapService.queryApplyAbiList();
	 model.addAttribute("applyAbiList", applyAbiList);
		return "ftl/index2/applyAbility";
	}
	
	@RequestMapping(value="")
	public String redirectIndex(HttpServletRequest request,HttpServletResponse response,@ModelAttribute(SessionKeyConstants.USER) User user,Model model){
		String appName = Configuration.getInstance().getProperty("com.asiainfo.pst.controllers.FrameController.appName");
		String userid = user.getId();
		model.addAttribute("appName", appName==null?"经分首页":appName);
		model.addAttribute("user", user);
		List<MenuBean> list = menuService.getSysAllMenu(userid);
		model.addAttribute("menus", JsonHelper.getInstance().write(list));
		return "ftl/main/index";
	}
	
	@RequestMapping(value="/icon")
	public String redirectIcon(HttpServletRequest request,HttpServletResponse response,@ModelAttribute(SessionKeyConstants.USER) User user,Model model){
		String appName = Configuration.getInstance().getProperty("com.asiainfo.pst.controllers.FrameController.appName");
		model.addAttribute("appName", appName==null?"经分首页":appName);
		model.addAttribute("user", user);
		return "ftl/demo/icon";
	}
	@RequestMapping(value="/welcome")
	public String redirectWelcome(HttpServletRequest request,HttpServletResponse response,@ModelAttribute(SessionKeyConstants.USER) User user,Model model){
		model.addAttribute("appName", "欢迎主页面");
		model.addAttribute("user", user);
		return "ftl/index/welcome";
	}
	
	@RequestMapping(value="/getMonthNotice")
	public @ResponseBody Object getMonthNotice(HttpServletRequest request,HttpServletResponse response,
			@ModelAttribute(SessionKeyConstants.USER) User user,Model model){
		String monthStr = request.getParameter("monthStr");
		List<NoticeBean> list = menuService.getCurrentMonthNotices(monthStr);
		return JsonHelper.getInstance().write(list);
	}
}
