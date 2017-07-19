package com.asiainfo.hb.web.controllers;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.hb.web.models.Visit;
import com.asiainfo.hb.web.models.VisitService;
import com.asiainfo.hb.web.util.WebUtil;

/**
 * 打开TAB页时记录日志
 * @author xiaoh
 *
 */
@Controller
@RequestMapping(value = "/visit")
@SessionAttributes({SessionKeyConstants.USER})
public class VisitController {
	
	@Autowired
	private VisitService visitService;
	
	@RequestMapping(value= "/insertLog")
	@ResponseBody
	public void insertLog(HttpServletRequest req, @ModelAttribute(SessionKeyConstants.USER) User user){
		long beginTime = System.currentTimeMillis();
		String rid = req.getParameter("rid");
		String rurl = req.getParameter("rurl");
		String menuIdTrack= "";
		String menuTrack = "";
		
		String uri = "";
		String param = "";
		String[] uriArr = rurl.split("\\?");
		if(uriArr.length > 0){
			uri = uriArr[0];
			if(uriArr.length > 1){
				param = uriArr[1];
			}
		}
		//记录菜单日志
		if(rurl.contains("menuid=") || rurl.endsWith("/ve/ide")){
			Map<String, String> map = visitService.getMenuTrace(rid);
			menuIdTrack = map.get("menuIdTrack");
			menuTrack = map.get("menuTrack");
		
			Visit log = new Visit();
			log.setTrack(menuTrack);
			log.setTrackId(menuIdTrack);
			log.setUri(uri);
			log.setParam(param);
			
			saveLog(log, req, beginTime);
			return;
		}
		
		Visit log = new Visit();
		log.setTrack("");
		log.setTrackId("");
		log.setUri(uri);
		log.setParam(param);
		log.setOperName(rid);
		
		saveLog(log, req, beginTime);
	}
	
	private void saveLog(Visit log, HttpServletRequest req, long beginTime){
		HttpSession session = req.getSession();
		User user = (User) session.getAttribute(SessionKeyConstants.USER);
		
		log.setLoginName(user.getId());
		log.setAreaId(user.getCityId());
		log.setIpAddr(WebUtil.getRemoteAddr(req));
		log.setAppServ(req.getLocalAddr()+":"+req.getLocalPort());
		log.setUa((String) session.getAttribute("UA"));
		String url = log.getUri().replace("..", (String)session.getAttribute("mvcPath"));
		session.setAttribute("LAST-URL", url);
		log.setUri(url);
		visitService.saveLog(log, beginTime);
	}

}
