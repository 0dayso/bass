/**
 * 
 */
package com.asiainfo.bass.apps.controllers;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.bass.apps.models.SzReportDao;

/**
 * @author zhangds
 *
 */
@Controller
@RequestMapping(value = "/mstr")
public class SzMSTRController {

	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(SzMSTRController.class);
	@Autowired
	private SzReportDao dao ;
	
	@RequestMapping(value = "/m")
	public @ResponseBody String loginCheck(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		String szToken = request.getParameter("szToken");
		
		return dao.getXml(szToken);
	}
}
