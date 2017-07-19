package com.asiainfo.bass.apps.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.bass.apps.models.FinanceAdjustDao;

/**
 * 财务调整
 * 
 * @author zhangwei
 * @date 2012-5-4
 */
@Controller
@RequestMapping(value = "/finance")
//@SessionAttributes({ "user", "mvcPath", "contextPath" })
@SessionAttributes({ "mvcPath"})
public class FinanceAdjustController {
	
	private static Logger LOG = Logger.getLogger(ReportController.class);
	
	@Autowired
	private FinanceAdjustDao financeAdjustDao;
	
	/**
	 * 跳转查询条件页面
	 */
	@RequestMapping(value = "/bat", method = RequestMethod.GET)
	public String getBat(HttpSession session, HttpServletRequest request, Model model, @ModelAttribute("mvcPath") String mvcPath) {
		return "ftl/financeAdjust/content";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/batList", method = RequestMethod.GET)
	public List getDim() {
		List list = financeAdjustDao.getBatList();
		LOG.info(list.toString());
		return list;
	}
	
	/**
	 * 新增
	 * @param rep_id
	 * @param rep_name
	 * @param xml
	 * @param rep_sql
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/save", method = RequestMethod.PUT)
	public @ResponseBody
	Map save(@RequestParam String rep_id,@RequestParam String rep_name, @RequestParam String xml, @RequestParam String rep_sql, @RequestParam String rep_papr, @RequestParam String type, @RequestParam String email, @RequestParam String phone) {
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try {
			//rep_id、rep_name不能为空
			if(!"".equals(rep_id) && rep_id!=null){
				if(!"".equals(rep_name) && rep_name!=null){
					int count = financeAdjustDao.getBatCount(rep_id);
					if(count>0){
						msg.put("status", "报表ID已经存在，请重新填写报表ID");
					}else if(count==0){
						financeAdjustDao.save(rep_id, rep_name, xml, rep_sql, rep_papr, type, email, phone);
					}
				}
				else{
					msg.put("status", "报表名称不能为空");
				}
			}else {
				msg.put("status", "报表ID不能为空");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}
	
	/**
	 * 修改
	 * @param rep_id
	 * @param rep_name
	 * @param xml
	 * @param rep_sql
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/update", method = RequestMethod.PUT)
	public @ResponseBody
	Map update(@RequestParam String rep_id,@RequestParam String rep_name, @RequestParam String xml, @RequestParam String rep_sql, @RequestParam String rep_papr, @RequestParam String type, @RequestParam String email, @RequestParam String phone) {
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try {
			//rep_id、rep_name不能为空
			if(!"".equals(rep_id) && rep_id!=null){
				if(!"".equals(rep_name) && rep_name!=null){
					financeAdjustDao.update(rep_id, rep_name, xml, rep_sql, rep_papr, type, email, phone);
				}
				else{
					msg.put("status", "报表名称不能为空");
				}
			}else {
				msg.put("status", "报表ID不能为空");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}
	
	/**
	 * 删除
	 * 
	 * @param sid
	 * @param name
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/bat", method = RequestMethod.DELETE)
	public @ResponseBody
	Map deleteDim(@RequestParam String rep_id) {
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try {
			financeAdjustDao.delBat(rep_id);
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}
	
	/**
	 * 跳转查询条件页面
	 */
	@RequestMapping(value = "/history", method = RequestMethod.GET)
	public String getHistoryInfo(HttpSession session, HttpServletRequest request, Model model, @ModelAttribute("mvcPath") String mvcPath) {
		return "ftl/financeAdjust/historyInfo";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/historyInfoList", method = RequestMethod.GET)
	public List getHistoryInfoList() {
		List list = financeAdjustDao.getHistoryInfoList();
		LOG.info(list.toString());
		return list;
	}
	
	/**
	 * 跳转查询条件页面
	 */
	@RequestMapping(value = "/earning", method = RequestMethod.GET)
	public String getEarning(HttpSession session, HttpServletRequest request, Model model, @ModelAttribute("mvcPath") String mvcPath) {
		return "ftl/financeAdjust/earning";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/earningList", method = RequestMethod.GET)
	public List getEarningList() {
		List list = financeAdjustDao.getHistoryInfoList();
		LOG.info(list.toString());
		return list;
	}
	
	/**
	 * 跳转查询条件页面
	 */
	@RequestMapping(value = "/rate", method = RequestMethod.GET)
	public String getRate(HttpSession session, HttpServletRequest request, Model model, @ModelAttribute("mvcPath") String mvcPath) {
		return "ftl/financeAdjust/rate";
	}
	
	/**
	 * 跳转查询条件页面
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "{menuid}/rate", method = RequestMethod.GET)
	public String getRateByMenu(@PathVariable("menuid") String menuid, HttpServletRequest request, Model model, @ModelAttribute("mvcPath") String mvcPath) {
		List list = financeAdjustDao.getReportList(menuid);
		model.addAttribute("twis", list);
		return "ftl/financeAdjust/rateByMenu";
	}

}
