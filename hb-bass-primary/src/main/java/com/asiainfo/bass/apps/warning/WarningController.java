package com.asiainfo.bass.apps.warning;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping(value = "/warning")
@SessionAttributes({SessionKeyConstants.USER , "mvcPath", "contextPath" })
public class WarningController {
	
	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(WarningController.class);
	
	@Autowired
	private WarningDao warningDao;
	
	@Autowired
	private WarningService warningService;
	
	@RequestMapping(value = "/satisfied", method = RequestMethod.GET)
	public String satisfied(@ModelAttribute("user") User user, Model model) {
		String currentUser = JsonHelper.getInstance().write(user);		
		model.addAttribute("currentUser",currentUser);
		return "ftl/warning/satisfied";
	}
	
	@RequestMapping(value = "/touch", method = RequestMethod.GET)
	public String touch(@ModelAttribute("user") User user, Model model) {
		String currentUser = JsonHelper.getInstance().write(user);		
		model.addAttribute("currentUser",currentUser);
		return "ftl/warning/touch";
	}
	
	@RequestMapping(value = "/business", method = RequestMethod.GET)
	public String business(@ModelAttribute("user") User user, Model model) {
		String currentUser = JsonHelper.getInstance().write(user);		
		model.addAttribute("currentUser",currentUser);
		return "ftl/warning/business";
	}
	
	/**
	 * 程帆设置预警值页面
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/config", method = RequestMethod.GET)
	public String config(@ModelAttribute("user") User user, Model model) {
		String currentUser = JsonHelper.getInstance().write(user);		
		model.addAttribute("currentUser",currentUser);
		return "ftl/warning/nodeConfig";
	}
	
	/**
	 * 程帆设置预警值页面
	 * @param user
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/elevenConfig", method = RequestMethod.GET)
	public String elevenConfig(@ModelAttribute("user") User user, Model model) {
		String currentUser = JsonHelper.getInstance().write(user);		
		model.addAttribute("currentUser",currentUser);
		return "ftl/warning/elevenConfig";
	}
	
	/**
	 * 保存预警值页面
	 * @param user
	 * @param model
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/svaeConfig", method = RequestMethod.PUT)
	public @ResponseBody
	Map svaeConfig(HttpServletResponse response, @ModelAttribute("user") User user, Model model, @RequestParam String red, @RequestParam String orange, @RequestParam String blue, @RequestParam String type, @RequestParam String code, @RequestParam String business){
		Map msg = new HashMap();
		msg.put("status", "设置成功");
		try{
			warningDao.saveConfig(red,orange,blue,type,code,business);
		}catch(Exception e){
			msg.put("status", "设置失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/satisfiedImport", method = RequestMethod.POST)
	public void satisfiedImport(HttpServletResponse response, @ModelAttribute("user") User user, @RequestParam String ds, @RequestParam String type){
		Map msg = new HashMap();
		msg.put("message", "执行成功");
		//修改记录
		try {
			warningService.updateWarning(ds,type, user.getId());
			//删除临时表
			warningDao.delete(ds, type);
			//增加日志记录
			warningDao.insertLog(ds, type, user.getId(), user.getCityId());
			//删除临时表
			warningDao.deleteTemp(ds, type);
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		try {
			response.getWriter().print(JsonHelper.getInstance().write(msg));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
}
