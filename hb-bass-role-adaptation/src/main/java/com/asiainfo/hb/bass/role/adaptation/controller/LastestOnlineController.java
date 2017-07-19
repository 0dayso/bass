package com.asiainfo.hb.bass.role.adaptation.controller;

import java.util.HashMap;
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
@Controller
@RequestMapping("/LastestOnline")
@SessionAttributes({ SessionKeyConstants.USER })
public class LastestOnlineController {
	
	private static Logger logger = Logger.getLogger(LastestOnlineController.class);

	@Autowired
	AdapService adapService;

	/**
	 * 最新上线信息查询
	 * @param name 名称
	 * @param rows 显示条数（easyui-自带）
	 * @param page 当前页数（easyui-自带）
	 * @return
	 */
	@RequestMapping(value = "/LastestOnlineIndex")
	@ResponseBody
	public Map<String, Object> getAllLastestOnlineReport(String name, String rows, String page) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("a.resource_name", name);
		map.put("pageSize", rows);
		map.put("pageNum", page);
		try {
			return adapService.getAllLastOnlineReport(map);
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
			return map;
		}
	}

	@RequestMapping(value = "/LastestOnlineMenu")
	public String goToLastestOnlineReport() {
		return "ftl/LastestOnline/LastestOnlineMenu";
	}
}
