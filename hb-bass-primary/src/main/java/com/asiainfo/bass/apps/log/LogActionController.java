package com.asiainfo.bass.apps.log;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.bass.components.models.Util;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping(value = "/logAction")
@SessionAttributes({SessionKeyConstants.USER , "mvcPath", "contextPath" })
public class LogActionController {
	
	private static Logger LOG = Logger.getLogger(LogActionController.class);
	
	@Autowired
	private LogActionService logActionService;
	
	/**
	 * 帐号管理事件、口令管理事件、权限管理事件查询页面
	 * @param user
	 * @return
	 */
	@RequestMapping(method = RequestMethod.GET)
	public String logAction(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("currentUser", user.getId());
		return "ftl/logAction/logAction";
	}
	
	/**
	 * 用户登录事件、用户注销事件查询
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "logUser",method = RequestMethod.GET)
	public String MMSConfig(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("currentUser", user.getId());
		return "ftl/logAction/logUser";
	}
	
	/**
	 * 新增帐号管理事件、口令管理事件、权限管理事件
	 * @param request
	 * @param response
	 * @param result
	 * @param opertype
	 * @param app_code
	 * @param app_name
	 * @param user
	 */
	@SuppressWarnings("unused")
	@RequestMapping(value = "insertLogAction",method = RequestMethod.POST)
	public void insertLogAction(HttpServletRequest request, HttpServletResponse response, String result, String opertype, String app_code, String app_name, @ModelAttribute("user") User user){
		int res = logActionService.insertLogAction(user.getId(), Util.getRemoteAddr(request), request.getLocalAddr() + ":" + request.getLocalPort(), result, opertype, app_code, app_name);
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "getNextLevel",method = RequestMethod.POST)
	public void getNextLevel(HttpServletRequest request, HttpServletResponse response, @ModelAttribute("user") User user){
		HashMap map = new HashMap();
		String userid = request.getParameter("userid");
		String userids = logActionService.getNextLevel(userid);
		if(userid!=null && userid!=""){
			map.put("users", userids);
			String jsonStr = JsonHelper.getInstance().write(map);
			LOG.info(jsonStr);
			try {
				PrintWriter out = response.getWriter();
				out.print(jsonStr);
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
	}
	
	/**
	 * 日志查询
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "visitlist",method = RequestMethod.GET)
	public String FPF_VISITLIST(@ModelAttribute("user") User user, Model model){
		model.addAttribute("currentUser", user.getId());
		return "ftl/logAction/logVisit";
	}
	
	/**
	 * 日志导出
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "export",method = RequestMethod.GET)
	public String export(@ModelAttribute("user") User user, Model model){
		model.addAttribute("currentUser", user.getId());
		return "ftl/logAction/authorityLogExport";
	}
	
	@RequestMapping(value = "delete",method = RequestMethod.POST)
	public void delete(HttpServletRequest request, @ModelAttribute("user") User user, Model model){
		String loginname = request.getParameter("_currentUser");
		String date1 = request.getParameter("date1");
		String date2 = request.getParameter("date2");
		logActionService.dele(loginname, date1, date2);
	}
	
	/**
	 * 日志查询
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "fileLog",method = RequestMethod.GET)
	public String fileManageLog(@ModelAttribute("user") User user, Model model){
		model.addAttribute("currentUser", user.getId());
		return "ftl/logAction/fileManageLog";
	}
}
