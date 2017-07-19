package com.asiainfo.bass.apps.gprs;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;


@Controller
@RequestMapping(value = "/gprs")
@SessionAttributes({SessionKeyConstants.USER , "mvcPath", "contextPath" })
public class GPRSController {

	private static Logger LOG = Logger.getLogger(GPRSController.class);
	
	@Autowired
	private GPRSService gprsService;
	
	@RequestMapping(value = "gprsLevel", method = RequestMethod.GET)
	public String gprsLevel(@ModelAttribute("user") User user, Model model) {
		String time = gprsService.getMaxTime();
		model.addAttribute("time", time);
		return "ftl/gprs/gprsLevel";
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public String index(@ModelAttribute("user") User user, Model model) {
		String time = gprsService.getMaxTime();
		String zb_code = "D00002";
		String chtyid = user.getCityId();
		String channel_code="HB.WH";
		if(!chtyid.equals("0")){
			channel_code = gprsService.getChannelCode(chtyid);
		}
		model.addAttribute("time", time);
		model.addAttribute("zb_code", zb_code);
		model.addAttribute("channel_code", channel_code);
		return "ftl/gprs/index";
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value="createImage", method = RequestMethod.POST)
	public void createImage(WebRequest request, HttpServletResponse response,@ModelAttribute("user") User user, Model model) {
		String time = request.getParameter("time");
		String zb_code = request.getParameter("zb_code");
		String zb_name = gprsService.getNameByCode(zb_code);
		HashMap result = gprsService.createImage(time, zb_code);
		result.put("zb_name", zb_name);
		result.put("zb_code", zb_code);
		result.put("time", time);
		try {
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="cityTree", method = RequestMethod.POST)
	public void cityTree(WebRequest request, HttpServletResponse response,@ModelAttribute("user") User user, Model model){
		String time = request.getParameter("time");
		List list = gprsService.getCityTree(time);
		try {
			String jsonStr = JsonHelper.getInstance().write(list);
			LOG.info(jsonStr);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
