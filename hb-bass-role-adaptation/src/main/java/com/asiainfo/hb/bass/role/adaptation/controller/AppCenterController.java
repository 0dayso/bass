package com.asiainfo.hb.bass.role.adaptation.controller;

import com.asiainfo.hb.bass.role.adaptation.models.AdapMenu;
import com.asiainfo.hb.bass.role.adaptation.service.AdapAppService;
import com.asiainfo.hb.bass.role.adaptation.service.AdapMenuService;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * @author zhanggm
 *
 */
@Controller
@RequestMapping("/appCenter")
@SessionAttributes({SessionKeyConstants.USER})
public class AppCenterController {
    @Autowired
    AdapAppService appService;
    @Autowired
	AdapMenuService aMenuService;

    @RequestMapping(value = "index_bak/{menuId}")
    public String redirectIndex_bak(@PathVariable Integer menuId, HttpServletRequest request, HttpServletResponse response,
        @ModelAttribute(SessionKeyConstants.USER) User user, Model model) {
        List<Map<String, Object>> applist = this.getAppData(String.valueOf(menuId), "", "", "", "1", user);
        List<Map<String, Object>> hotapplist = this.getHotapp(menuId);
        List<Map<String, Object>> apptypelist = appService.getAppType();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("key", "");
        map.put("value", "全部");
        apptypelist.add(0, map);
        model.addAttribute("menuid", JsonHelper.getInstance().write(menuId));
        model.addAttribute("apptypelist",JsonHelper.getInstance().write(apptypelist));
        model.addAttribute("hotapp", JsonHelper.getInstance().write(hotapplist));
        model.addAttribute("applist", JsonHelper.getInstance().write(applist));
        Object count;
        if (applist.size() > 0) {
            count = applist.get(0).get("count");
        } else {
            count = 0;
        }
        model.addAttribute("totalnum", JsonHelper.getInstance().write(count));
        return "ftl/app/appCenter_bak";
    }

    @RequestMapping(value = "index/{menuId}")
    public String redirectIndex(@PathVariable Integer menuId, HttpServletRequest request, HttpServletResponse response,
        @ModelAttribute(SessionKeyConstants.USER) User user, Model model) {
    	List<Map<String, Object>> appList = this.getAppData(String.valueOf(menuId), "", "", "", "1", user);
    	List<Map<String, Object>> hotAppList = this.getHotapp(menuId);
    	AdapMenu _menu = aMenuService.getOneMenus(String.valueOf(menuId));
		model.addAttribute("menuName", null != _menu && null != _menu.getMenuName() ? _menu.getMenuName() : "");
    	model.addAttribute("appList", JsonHelper.getInstance().write(appList));
    	model.addAttribute("hotAppList", hotAppList);
    	List<Map<String, Object>> apptypelist = appService.getAppType();
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("key", "");
        map.put("value", "全部");
        apptypelist.add(0, map);
    	model.addAttribute("apptypelist",apptypelist);
    	model.addAttribute("menuId", JsonHelper.getInstance().write(menuId));
    	model.addAttribute("menuTypes",aMenuService.getRepCenter(""));
    	//return "ftl/app/appCenter";
    	return "ftl/app/newAppCenter";
    }
    @RequestMapping(value = "/getAppList")
    public @ResponseBody List<Map<String, Object>> getAppList( 
    		@RequestParam(value = "sid") String sid, 
    		@RequestParam(value = "orderByStr") String orderByStr, 
    		@RequestParam(value = "searchVal") String searchVal, 
    		@RequestParam(value = "appType") String appType, 
    		@RequestParam(value = "pageNumStr") String pageNumStr, 
    		@ModelAttribute(SessionKeyConstants.USER) User user) {
        return this.getAppData(sid, orderByStr, searchVal, appType, pageNumStr, user);
    }
    
    @RequestMapping(value = "/getAppInfo")
    @ResponseBody
    public List<Map<String, Object>> getAppInfo(@ModelAttribute(SessionKeyConstants.USER) User user,HttpServletRequest req){
    	String menuId = req.getParameter("menuId");
    	String appName = req.getParameter("appName");
    	String appType = req.getParameter("appType");
    	String orderType = req.getParameter("orderType");
    	return this.getAppData(menuId, orderType, appName, appType, "1", user);
    }

    public List<Map<String, Object>> getAppData(String sid, String orderType,
        String searchVal, String appType, String pageNum, User user) {
        List<Map<String, Object>> list = appService.getAppData(sid, orderType, searchVal, appType, pageNum, user);
        return list;
    }

    @RequestMapping(value = "/getHotReport")
    public @ResponseBody List<Map<String, Object>> getHotapp(Integer menuId) {
        return appService.getHotApp(menuId);
    }
    
    @RequestMapping({"/getHotZt"})
    @ResponseBody
    public Object getHotZt() {
    	return appService.getHotZt();
    }
    
    
    @RequestMapping(value = "/appzt")
    public String getappzt(HttpServletRequest request,Model model) {
    	String menuId=request.getParameter("menuId");
    	List<Map<String,Object>> detailZtList = new ArrayList<Map<String,Object>>();
    	List<Map<String,Object>> showZtList = new ArrayList<Map<String,Object>>();
    	List<Map<String,Object>> hotZtList = new ArrayList<Map<String,Object>>();
    	hotZtList = appService.getHotZt();
    	detailZtList = appService.getZtDetail(menuId);
    	showZtList = appService.getZtShow(menuId);
    	model.addAttribute("detail", detailZtList.get(0));
    	model.addAttribute("show", showZtList.get(0));
    	model.addAttribute("hot", hotZtList);
        return "ftl/app/appCenterZt1";
    }
    
    @RequestMapping(value ="/subSpecialTopic")
	public String getSpecialList(HttpServletRequest req, Model model){
		String resId = req.getParameter("resId");
		List<Map<String, Object>> subTopicList = appService.getSubTopics(resId);
		Map<String, Object> topicDetail = appService.getTopicDetail(resId);
		
		model.addAttribute("topicDetail", topicDetail);
		model.addAttribute("subTopics", subTopicList);
		return "ftl/app/specialTopic";
	}
}
