package com.asiainfo.bass.apps.stock;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping(value = "/stock")
@SessionAttributes({SessionKeyConstants.USER , "mvcPath", "contextPath" })
public class StockController {
	
	@Autowired
	private StockService stockService;
	
	@RequestMapping(method = RequestMethod.GET)
	public String regionManage(@ModelAttribute("user") User user, Model model) {
		return "ftl/stock/regionManage";
	}
	
	@RequestMapping(value="personManage", method = RequestMethod.GET)
	public String personManage(WebRequest request, @ModelAttribute("user") User user, Model model) {
		String parent_region_name = request.getParameter("parent_region_name");
		String parent_region_level = request.getParameter("parent_region_level");
		model.addAttribute("parent_region_name", parent_region_name);
		model.addAttribute("parent_region_level", parent_region_level);
		return "ftl/stock/personManage";
	}
	
	@RequestMapping(value="marketingManage", method = RequestMethod.GET)
	public String marketingManage(WebRequest request, @ModelAttribute("user") User user, Model model) {
		String parent_region_name = request.getParameter("parent_region_name");
		model.addAttribute("parent_region_name", parent_region_name);
		return "ftl/stock/marketingManage";
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "saveCounty", method = RequestMethod.PUT)
	public @ResponseBody
	Map saveCounty(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user){
		String region_name = request.getParameter("region_name");
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			//判断是否存在改县域
			int result = stockService.getCountByRegionName(region_name);
			if(result>0){
				msg.put("status", "已存在该县域，操作失败");
			}else{
				stockService.saveCounty(region_name);
			}
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "savePersonManager", method = RequestMethod.PUT)
	public @ResponseBody
	Map savePersonManager(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user){
		String region_name = request.getParameter("region_name");
		String manager_name = request.getParameter("manager_name");
		String manager_accnbr = request.getParameter("manager_accnbr");
		String manager_type = request.getParameter("manager_type");
		String region_level = request.getParameter("region_level");
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			//判断是否存在改县域
			int result = stockService.getCountForPersonManager(manager_name,manager_accnbr);
			if(result>0){
				msg.put("status", "操作失败");
			}else{
				stockService.savePersonManager(region_name, manager_name, manager_accnbr, manager_type, region_level);
			}
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "deleteCounty", method = RequestMethod.DELETE)
	public @ResponseBody
	Map deleteCounty(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user){
		String region_name = request.getParameter("region_name");
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			stockService.deleteCounty(region_name);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "deletePersonManager", method = RequestMethod.DELETE)
	public @ResponseBody
	Map deletePersonManager(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user){
		String region_name = request.getParameter("region_name");
		String manager_name = request.getParameter("manager_name");
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			stockService.deletePersonManager(region_name,manager_name);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "saveMarketing", method = RequestMethod.PUT)
	public @ResponseBody
	Map saveMarketing(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user){
		String region_name = request.getParameter("region_name");
		String parent_region_name = request.getParameter("parent_region_name");
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			//判断是否存在改县域
			int result = stockService.getCountByRegionName(region_name);
			if(result>0){
				msg.put("status", "已存在该营销中心，操作失败");
			}else{
				stockService.saveMarketing(region_name, parent_region_name);
			}
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}

}
