package com.asiainfo.hb.ftp.controllers;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.ftp.models.FileLogDao;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * 日志查询
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/fileLog")
public class FileLogController {
	
	@Autowired
	private FileLogDao logDao;
	
	@RequestMapping(value="/getLogInfo")
	@ResponseBody
	public Map<String, Object> getLogInfo(HttpServletRequest req, HttpSession session){
		String userName = req.getParameter("userName");
		String operType = req.getParameter("operType");
		String startTime = req.getParameter("startTime");
		String endTime = req.getParameter("endTime");
		String fileName = req.getParameter("fileName");
		String page = req.getParameter("page");
		String rows = req.getParameter("rows");
		User user = (User)session.getAttribute(SessionKeyConstants.USER);
		return logDao.getFileLog(user.getId(),fileName, userName, operType, startTime, endTime, page, rows);
	}
	
}
