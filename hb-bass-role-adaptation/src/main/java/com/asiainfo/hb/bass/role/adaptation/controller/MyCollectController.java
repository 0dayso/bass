/**
 * 
 */
package com.asiainfo.hb.bass.role.adaptation.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.bass.role.adaptation.models.AdapMenu;
import com.asiainfo.hb.bass.role.adaptation.service.AdapMenuService;
import com.asiainfo.hb.bass.role.adaptation.service.AdapMyCollectService;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;


/**
 * @author zhanggm2
 *
 */
@Controller
@RequestMapping("/myCollect")
@SessionAttributes({ SessionKeyConstants.USER })
public class MyCollectController {
	@Autowired
	AdapMyCollectService collectService;
	@Autowired
	AdapMenuService aMenuService;
	
	@RequestMapping(value = "index_bak/{menuId}")
	public String redirectIndex_bak(@PathVariable Integer menuId,HttpServletRequest request, HttpServletResponse response,
			@ModelAttribute(SessionKeyConstants.USER) User user, Model model) {
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		Date endDate=new Date();
		Date startDate=new Date(endDate.getTime()-7*24*60*60*1000);
		List<Map<String,Object>> collectlist=this.getCollect(menuId, "",sdf.format(startDate), sdf.format(endDate), "","1", user);
		List<Map<String,Object>> hotcollectlist=collectService.getHotCollect(menuId);
		List<Map<String,Object>> collecttypelist=collectService.getCollectTypes();
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("key","");
		map.put("value","全部");
		collecttypelist.add(0,map);
		Object count;
		if(collectlist.size()>0){
			count=collectlist.get(0).get("count");
		}else{
			count=0;
		}
		model.addAttribute("totalnum",JsonHelper.getInstance().write(count));
		model.addAttribute("menuid",JsonHelper.getInstance().write(menuId));
		model.addAttribute("collectlist",JsonHelper.getInstance().write(collectlist));
		model.addAttribute("hotcollectlist",JsonHelper.getInstance().write(hotcollectlist));
		model.addAttribute("collecttypelist",JsonHelper.getInstance().write(collecttypelist));
		return "ftl/collect/myCollect_bak";
	}
	
	@RequestMapping(value = "index/{menuId}")
	public String redirectIndex(@PathVariable Integer menuId,HttpServletRequest request, HttpServletResponse response,
			@ModelAttribute(SessionKeyConstants.USER) User user, Model model) {
		List<Map<String,Object>> collecttypelist = collectService.getCollectTypes();
		List<Map<String,Object>> hotcollectlist=collectService.getHotCollect(menuId);
		List<Map<String,Object>> collectlist=this.getCollect(menuId, "","", "", "","1", user);
		AdapMenu _menu = aMenuService.getOneMenus(String.valueOf(menuId));
		model.addAttribute("menuName", null != _menu && null != _menu.getMenuName() ? _menu.getMenuName() : "");
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("key","");
		map.put("value","全部");
		collecttypelist.add(0,map);
		model.addAttribute("collectTypeList", collecttypelist);
		model.addAttribute("hotCollects", hotcollectlist);
		model.addAttribute("collectList", JsonHelper.getInstance().write(collectlist));
		model.addAttribute("menuId", JsonHelper.getInstance().write(menuId));
		model.addAttribute("menuTypes",aMenuService.getRepCenter(""));
		return "ftl/collect/newMyCollect";
	}
	
	@RequestMapping(value="/getCollectInfo") 
	@ResponseBody
	public List<Map<String,Object>> getCollectInfo(HttpServletRequest request, @ModelAttribute(SessionKeyConstants.USER) User user, Model model){
		int menuId = Integer.valueOf(request.getParameter("menuId"));
		String resourceName = request.getParameter("resourceName");
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		String resType = request.getParameter("resType");
		return this.getCollect(menuId, resourceName, startDate, endDate, resType, "1", user);
	}
	
	public List<Map<String,Object>> getCollect(Integer menuId,String resourceName,String startDate,
			String endDate,String resourceType, String pageNumStr,User user){
		return collectService.getCollect(menuId, resourceName, startDate, endDate, resourceType, pageNumStr,user);
	}
	@RequestMapping(value="/getCollectList") 
	public @ResponseBody List<Map<String,Object>> getAppList(
			@RequestParam(value="menuId") Integer menuId, 
			@RequestParam(value="resourceName") String resourceName, 
			@RequestParam(value="startDate") String startDate, 
			@RequestParam(value="endDate") String endDate,
			@RequestParam(value="resourceType") String resourceType, 
			@RequestParam(value="pageNumStr") String pageNumStr,
			@ModelAttribute(SessionKeyConstants.USER) User user){
		return this.getCollect(menuId, resourceName, startDate, endDate, resourceType,pageNumStr,user);
	}
	@RequestMapping(value = "/addCollect")
	public @ResponseBody Map<String,Object> addCollect(
			@RequestParam String rid,
			@RequestParam Integer menuId,
			@ModelAttribute(SessionKeyConstants.USER) User user){
		return collectService.addCollect(rid, menuId, user);
	}

	@RequestMapping(value = "/delCollect")
	public @ResponseBody Map<String,Object> delCollect(
			@RequestParam String rid,
			@RequestParam Integer menuId,
			@ModelAttribute(SessionKeyConstants.USER) User user){
		return collectService.deleteCollect(rid, menuId, user);
	}
}
