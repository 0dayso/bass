package com.asiainfo.hb.power.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.power.service.UserGroupMapService;
import com.asiainfo.hb.web.SessionKeyConstants;
@Controller
@RequestMapping("/userGroupMap")
@SessionAttributes({ SessionKeyConstants.USER })
public class UserGroupMapControllerbak {

	
	@Autowired
	UserGroupMapService userGroupMapService;
	
	
	@RequestMapping({"/userGroupMapManage"})
	public String index(){
		return "ftl/menu/userGroupMapManage";
	}
	
	@RequestMapping({ "/getUserInfo" })
	@ResponseBody
	public List<Map<String,Object>> getUserInfo(HttpServletRequest request,Model model) {
		 String userid = request.getParameter("userid");
		 String username = request.getParameter("username");
		 String groupid = request.getParameter("groupid");
		 String roleid = request.getParameter("roleid");
		 String cityid = request.getParameter("cityid");
		 List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		 if(groupid!=null){
			 list = userGroupMapService.getUserInfoNoInGroupid(userid, username, groupid,cityid);
		 }else {
			 list = userGroupMapService.getUserInfoNoInRoleid(userid, username, roleid,cityid);
		}
		 return list;
	}
	
	@RequestMapping({ "/addUsers" })
	@ResponseBody
	public List<Map<String,Object>> addUsers(HttpServletRequest request,Model model) {
		 String userids = request.getParameter("userids");
		 String groupid = request.getParameter("groupid");
		 String[] userid = userids.split(",");
		userGroupMapService.addUserGroupMap(userid, groupid);
		 List<Map<String,Object>> list = userGroupMapService.getUserInfoBygroupID(groupid,null,null,null);
		 return list;
		 
	}
	
	@RequestMapping({ "/getUserInfobyGroupId" })
	@ResponseBody
	public List<Map<String,Object>> getUserInfoBygroupID(HttpServletRequest request,Model model) {
		 String groupid = request.getParameter("groupid");
		 String userid = request.getParameter("userid");
		 String username = request.getParameter("username");
		 String cityid = request.getParameter("cityid");
		 List<Map<String,Object>> list = userGroupMapService.getUserInfoBygroupID(groupid, userid, username, cityid);
		 return list;
	}
	
	@RequestMapping({ "/deleteUsers" })
	@ResponseBody
	public Map<String,Object> deleteUsers(HttpServletRequest request,Model model) {
		Map<String,Object> map = new HashMap<String, Object>();
		 String groupid = request.getParameter("groupid");
		 String userids = request.getParameter("userids");
		 String userid[] = userids.split(",");
		 List<String> useridlist = new ArrayList<String>();
		 for (int i = 0; i < userid.length; i++) {
			 useridlist.add(userid[i]);
		}
		 boolean flag =  userGroupMapService.deleteUserGroupMapbyId(groupid, useridlist);
		 map.put("flag", flag);
		 map.put("userids", useridlist);
		 return map;
	}
	
}
