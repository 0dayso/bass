package com.asiainfo.hb.bass.frame.access;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@SessionAttributes({SessionKeyConstants.USER})
public class AccessOtherSysController {
	@RequestMapping(value="/accessOtherSys")
	public String accessOtherSys(WebRequest request,@ModelAttribute(SessionKeyConstants.USER) User user){
		String redirectPath = request.getParameter("redirectPath");
		String encode_userid = (String) request.getAttribute("encode_userid", WebRequest.SCOPE_SESSION);
		if(encode_userid == null){
			encode_userid = DES.encode(user.getId());
			request.setAttribute("encode_userid", encode_userid, WebRequest.SCOPE_SESSION);
		}
		String resultPath = "redirect:"+redirectPath;
		if(redirectPath.indexOf("?")>=0){
			resultPath += "&access_user_id="+encode_userid;
		}else{
			resultPath += "?access_user_id="+encode_userid;
		}
		
		return resultPath;
	}
	
	@RequestMapping(value="/accessTo29")
	public String accessTo29(WebRequest request,@ModelAttribute(SessionKeyConstants.USER) User user){
		String reportid = request.getParameter("reportid");
		String encode_userid = (String) request.getAttribute("encode_userid", WebRequest.SCOPE_SESSION);
		if(encode_userid == null){
			encode_userid = DES.encode(user.getId());
			request.setAttribute("encode_userid", encode_userid, WebRequest.SCOPE_SESSION);
		}
		String resultPath = "redirect:http://10.25.124.29/mvc/report/"+reportid;
		if(resultPath.indexOf("?")>=0){
			resultPath += "&access_user_id="+encode_userid;
		}else{
			resultPath += "?access_user_id="+encode_userid;
		}
		
		return resultPath;
	}
	
}
