package com.asiainfo.hb.gbas.controller;

import javax.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
public class GbasFrameController {

	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(Model model, HttpSession session){
		User user = (User) session.getAttribute(SessionKeyConstants.USER);
		model.addAttribute("userName", user.getName());
		return "ftl/index";
	}
	
}
