package com.asiainfo.hb.bass.role.adaptation.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.bass.role.adaptation.service.AdapService;
import com.asiainfo.hb.core.util.LogUtil;
import com.asiainfo.hb.web.SessionKeyConstants;

/**
 * 
 * @author chendb
 *
 */
@SuppressWarnings("unused")
@Controller
@RequestMapping("/NoticeCenter")
@SessionAttributes({ SessionKeyConstants.USER })
public class NoticeController {
	
	private static Logger logger = Logger.getLogger(NoticeController.class);
	
	@Autowired
	AdapService adapService;

	/**
	 * 公告信息页面查询
	 * @param newstitle 公告标题
	 * @param startDate 开始时间
	 * @param endDate   结束时间
	 * @param rows		显示条数（easyui-自带）
	 * @param page		当前页数（easyui-自带）
	 * @return
	 */
	@RequestMapping("/noticeIndex")
	@ResponseBody
	public Map<String, Object> getAllNotice(String newstitle, String startDate, String endDate,String rows,String page){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("newstitle", newstitle);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("pageSize", rows);
		map.put("pageNum", page);
		try {
			return adapService.getAllNotice(map);
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
			return null;
		}
	}
	
	@RequestMapping("/noticeMenu")
	public String goToNotice(){
		return "ftl/notice/noticeMenu";
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping("/EditNotice")
	@ResponseBody
	public int editNot(Integer newsid,String newstitle, String newsmsg, String newsdate,String creator){
		Map map = new HashMap();
		map.put("newstitle", newstitle);
		map.put("newsmsg", newsmsg);
		map.put("newsdate", newsdate);
		map.put("creator", creator);
		map.put("newsid", newsid);
		try {
			return adapService.getNotice(map);
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
			return -1;
		}
	}
	
	@RequestMapping("/delNotice")
	@ResponseBody
	public int delNotice(Integer newsid){
		System.out.println(newsid);
		try {
			return adapService.delNotce(newsid);
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
			return -1;
		}
	}
}
