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
@RequestMapping("/TopkpiCenter")
@SessionAttributes({ SessionKeyConstants.USER })
public class TopKpiController {
	
	private static Logger logger = Logger.getLogger(TopKpiController.class);
	
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
	@RequestMapping("/topkpiIndex")
	@ResponseBody
	public Map<String, Object> getTopKpi(String kpiname,String rows,String page){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("kpiname", kpiname);
		map.put("pageSize", rows);
		map.put("pageNum", page);
		try {
			return adapService.getAllTopKpi(map);
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
			return null;
		}
	}
	
	@RequestMapping("/TopKpi")
	public String goToTopKpi(){
		return "ftl/TopKpi/TopKpi";
	}
	
}
