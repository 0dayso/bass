package com.asiainfo.hb.power.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.power.service.UserRoleMapService;
import com.asiainfo.hb.web.SessionKeyConstants;


@Controller
@RequestMapping("/userRoleMapManager")
@SessionAttributes({ SessionKeyConstants.USER })
public class UserRoleMapControllerbak {
	
	public Logger logger = LoggerFactory.getLogger(UserRoleMapControllerbak.class);

	@Autowired
	UserRoleMapService userRoleMapService;
	
	
	/**
	 * 根据角色ID,name查询角色列表
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/getUserRoles")
	@ResponseBody
	public List<Map<String,Object>> getUserRoles(HttpServletRequest request,Model model){
		logger.info("getUserRoles------------>");
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String roleid=request.getParameter("roleId");
		String rolename=request.getParameter("roleName");
		String userId = request.getParameter("userId");
		list = userRoleMapService.getRoleGroupByParam(roleid, rolename, userId);
		return list;
		
	}

	
	/**
	 * 查询用户下的所有角色列表
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/getUserAndRole")
	@ResponseBody	
	public List<Map<String,Object>> getUserAndRoleByUserid(HttpServletRequest request,Model model){
		logger.info("getUserAndRole------------>");
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String userid=request.getParameter("userid");
		list = userRoleMapService.getRoleListByUserId(userid);
		return list;
		
	}
	
	/**
	 * 根据条件查询下角色的所有用户列表
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("/getRoleAndUserByParam")
	@ResponseBody	
	public List<Map<String,Object>> getRoleAndUserByParam(HttpServletRequest request,Model model){
		logger.info("getRoleAndUserByParam------------>");
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String roleid=request.getParameter("roleid");
		String userid=request.getParameter("userid");
		String username=request.getParameter("username");
		String cityid = request.getParameter("cityid");
		list = userRoleMapService.getUserListByParam(roleid,userid,username,cityid);
		return list;
		
	}
	
	/**
	 * 根据单个用户，多个角色，删除FPF_USER_ROLE_MAP
	 * @param request
	 * @param mode
	 * @return
	 */
	@RequestMapping("/bachDelete")
	@ResponseBody	
	public Map<String,Object> bachDeleteUserAndRoleMap(HttpServletRequest request,Model mode){
		logger.info("bachDelete------------>");
		Map<String,Object> result = new HashMap<String,Object>();
		List<Object> list = new ArrayList<Object>();
		boolean flag = false;
		try {
			String roleids = request.getParameter("roleids");
			String userid = request.getParameter("userid");
			String[] split = roleids.split(",");
			for (int i = 0; i < split.length; i++) {
				list.add(split[i]);
			}
			flag = userRoleMapService.bachDeleteUserAndRoleMap(list, userid);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		result.put("flag", flag);
		return result;
	}
	
	/**
	 * 根据单个角色，多个用户，删除FPF_USER_ROLE_MAP
	 * @param request
	 * @param mode
	 * @return
	 */
	@RequestMapping("/bachDeleteRoleUsers")
	@ResponseBody	
	public Map<String,Object> bachDeleteRoleAndUserMap(HttpServletRequest request,Model mode){
		logger.info("bachDelete------------>");
		Map<String,Object> result = new HashMap<String,Object>();
		List<Object> list = new ArrayList<Object>();
		boolean flag = false;
		try {
			String userids = request.getParameter("userids");
			String roleid = request.getParameter("roleid");
			String[] split = userids.split(",");
			for (int i = 0; i < split.length; i++) {
				list.add(split[i]);
			}
			flag = userRoleMapService.bachDeleteUserAndRoleMap(roleid,list);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		result.put("flag", flag);
		return result;
	}
	
	/**
	 * 根据单个USERID,多个ROLEID插入数据
	 * @param request
	 * @param mode
	 * @return
	 */
	@RequestMapping("/bachInsert")
	@ResponseBody
	public Map<String,Object> bachInsertUserAndRoleMap(HttpServletRequest request,Model mode){
		logger.info("bachInsert------------>");
		Map<String,Object> result = new HashMap<String,Object>();
		boolean flag = false;
		try {
			String roleids = request.getParameter("roleids");
			String userid = request.getParameter("userid");
			String[] split = roleids.split(",");
			userRoleMapService.insertUserAndroleMap(split,userid);
			flag = true;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		result.put("flag", flag);
		return result;
	}
	
	
	/**
	 * 根据单个ROLEID,多个插入USERID数据
	 * @param request
	 * @param mode
	 * @return
	 */
	@RequestMapping("/bachInsertRoleUsers")
	@ResponseBody
	public Map<String,Object> bachInsertroleAndUserMap(HttpServletRequest request,Model mode){
		logger.info("bachInsertRoleUsers------------>");
		Map<String,Object> result = new HashMap<String,Object>();
		boolean flag = false;
		try {
			String userids = request.getParameter("userids");
			String roleid = request.getParameter("roleid");
			String[] split = userids.split(",");
			userRoleMapService.insertUserAndroleMap(roleid,split);
			flag = true;
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		result.put("flag", flag);
		return result;
	}
	

}
