package com.asiainfo.hb.gbas.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.gbas.model.DocManageDao;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * 文档管理
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/docManage")
public class DocManageController {
	
	@Autowired
	private DocManageDao mDocManageDao;
	
	@RequestMapping("/index")
	public String index(){
		return "ftl/docManage/index";
	}
	
	@RequestMapping("/markdown")
	public String markdown(Model model, HttpServletRequest req){
		String docId = req.getParameter("docId");
		String version = req.getParameter("version");
		Map<String, Object> map = mDocManageDao.getMdContent(docId, version);
		model.addAttribute("content", map.get("content"));
		model.addAttribute("docId", docId);
		model.addAttribute("version", version);
		return "ftl/docManage/markdown";
	}
	
	@RequestMapping("/getDocInfoList")
	@ResponseBody
	public Map<String, Object> getDocInfoList(HttpServletRequest req){
		String name = req.getParameter("name");
		String userName = req.getParameter("userName");
		return mDocManageDao.getDocInfoList(name, userName, req);
	}
	
	@RequestMapping("/saveDocInfo")
	@ResponseBody
	public void saveDocInfo(HttpServletRequest req, HttpSession session){
		String name = req.getParameter("name");
		String desc = req.getParameter("desc");
		String docId = req.getParameter("docId");
		if(StringUtils.isEmpty(docId)){
			User user = (User) session.getAttribute(SessionKeyConstants.USER);
			mDocManageDao.saveDocInfo(name, desc, user);
			return;
		}
		
		mDocManageDao.updateDocInfo(docId, name, desc);
	}
	
	@RequestMapping("/delDoc")
	@ResponseBody
	public void delDoc(HttpServletRequest req){
		String docId = req.getParameter("docId");
		mDocManageDao.delDoc(docId);
	}
	
	@RequestMapping("/saveMdContent")
	@ResponseBody
	public void saveMdContent(HttpServletRequest req, HttpSession session){
		String content = req.getParameter("content");
		String version = req.getParameter("version");
		String docId = req.getParameter("docId");
		User user = (User)session.getAttribute(SessionKeyConstants.USER);
		mDocManageDao.updateContent(docId, content, user, version);
	}
	
	@RequestMapping("/submitMdContent")
	@ResponseBody
	public void submitMdContent(HttpServletRequest req, HttpSession session){
		String docId = req.getParameter("docId");
		String content = req.getParameter("content");
		User user = (User)session.getAttribute(SessionKeyConstants.USER);
		mDocManageDao.saveContent(docId, content, user);
	}
	
	@RequestMapping("/getVersionList")
	@ResponseBody
	public List<Map<String, Object>> getVersionList(HttpServletRequest req){
		String docId = req.getParameter("docId");
		return mDocManageDao.getVersionList(docId);
	}

}
