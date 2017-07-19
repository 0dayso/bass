package com.asiainfo.hb.bass.frame.controller;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.bass.frame.models.NoticeBean;
import com.asiainfo.hb.bass.frame.service.NoticeService;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping("/HBBassSysNote")
@SessionAttributes({SessionKeyConstants.USER})
public class HBBassSysNoteController {
	@Autowired
	NoticeService noticeService;
	
	@RequestMapping("/manager/index")
	public String redirectSysNoteManagerIndex(HttpServletRequest request,HttpServletResponse response,@ModelAttribute(SessionKeyConstants.USER) User user,Model model){
		List<NoticeBean> noticeList = noticeService.getSystemNotices();
		model.addAttribute("notices", JsonHelper.getInstance().write(noticeList));
		return "ftl/sysnote/noteManager";
	}
	
	@RequestMapping("/manager/query")
	@ResponseBody
	public String queryNotice(@RequestParam("noticetitle")String noticetitle,
							  @RequestParam("noticemsg")String noticemsg,
							  @RequestParam("notice_start_dt")String notice_start_dt,
							  @RequestParam("notice_end_dt")String notice_end_dt,
							  @ModelAttribute(SessionKeyConstants.USER) User user){
		List<NoticeBean> noticeList = noticeService.queryNotice(noticetitle, noticemsg, notice_start_dt, notice_end_dt);
		return JsonHelper.getInstance().write(noticeList);
	}
	
	@RequestMapping("/manager/add")
	@ResponseBody
	public String addNotice(@RequestParam("noticetitle")String noticetitle,
							@RequestParam("noticemsg")String noticemsg,
							@RequestParam("notice_start_dt")String notice_start_dt,
							@RequestParam("notice_end_dt")String notice_end_dt,
							@RequestParam("extend_color")String extend_color,
							@RequestParam("status")String status,
							@ModelAttribute(SessionKeyConstants.USER) User user){
		noticeService.addNotice(noticetitle, noticemsg, notice_start_dt, notice_end_dt, extend_color, status, user.getId());
		Map<String,String> result = new HashMap<String,String>();
		result.put("result", "ok");
		return JsonHelper.getInstance().write(result);
	}
	
	@RequestMapping("/manager/publish")
	@ResponseBody
	public String publishNotice(@RequestParam("noticeId")String noticeId, @RequestParam("status")String status){
		noticeService.publishNotice(noticeId,status);
		Map<String,String> result = new HashMap<String,String>();
		result.put("result", "ok");
		return JsonHelper.getInstance().write(result);
	}
	
	@RequestMapping("/manager/delete")
	@ResponseBody
	public String deleteNotice(@RequestParam("noticeId")String noticeId){
		noticeService.removeNotice(noticeId);
		Map<String,String> result = new HashMap<String,String>();
		result.put("result", "ok");
		return JsonHelper.getInstance().write(result);
	}
	
	@RequestMapping("/manager/update")
	@ResponseBody
	public String updateNotice(@RequestParam("noticeId")String noticeId,
							@RequestParam("noticetitle")String noticetitle,
							@RequestParam("noticemsg")String noticemsg,
							@RequestParam("notice_start_dt")String notice_start_dt,
							@RequestParam("notice_end_dt")String notice_end_dt,
							@RequestParam("extend_color")String extend_color,
							@RequestParam("status")String status,
							@ModelAttribute(SessionKeyConstants.USER) User user){
		noticeService.updateNotice(noticeId,noticetitle, noticemsg, notice_start_dt, notice_end_dt, extend_color, status);
		Map<String,String> result = new HashMap<String,String>();
		result.put("result", "ok");
		return JsonHelper.getInstance().write(result);
	}
	
	
}
