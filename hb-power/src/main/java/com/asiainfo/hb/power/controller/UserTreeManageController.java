package com.asiainfo.hb.power.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.power.service.MenuRightService;
import com.asiainfo.hb.power.service.UserTreeManageService;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping("/userTreeManage")
@SessionAttributes({ SessionKeyConstants.USER })
@SuppressWarnings({"rawtypes","unused"})
public class UserTreeManageController {
	
	@Autowired
	UserTreeManageService treeUserService;
	
	@Autowired
	private MenuRightService m_MenuRightService;
	
	protected String menuid =null;
	
	@RequestMapping("/treeUserManage")
	public String treeManage(Model model, HttpServletRequest request ,@ModelAttribute(SessionKeyConstants.USER) User user){
		String menuitemid = request.getParameter("menuid");
		String userid = user.getId();
		String groupName = user.getGroupName();
		int isadmin = user.getSperAdmin();
		String allRightFlag = "NO";
		if((isadmin==1)||groupName.equals("云化经分开发人员")||groupName.equals("湖北移动业支经分用户组")){
			allRightFlag = "YES";
		}
		if(menuitemid!=null){
			menuid = menuitemid;
		}
		List list = treeUserService.queryMenus();
		List<Map<String, Object>> powerlist = m_MenuRightService.getUserMenuPower(menuid,userid);
		model.addAttribute("powerList",powerlist);
		model.addAttribute("power", JsonHelper.getInstance().write(powerlist));
		model.addAttribute("smsMenus", list);
		model.addAttribute("allRightFlag", allRightFlag);
		return "ftl/menu/treeUserManage";
	}
	
	@RequestMapping("/treeUser")
	@ResponseBody
	public List<Map<String,Object>> getAllMenuBytable(){
		return treeUserService.queryAlltreeUser();
	}
	
	@RequestMapping("/getUserGroupByName")
	@ResponseBody
	public List<Map<String,Object>> getUserGroupByName(HttpServletRequest request,Model model){
		String groupName = request.getParameter("groupName");
		return treeUserService.selectUserGroupbyParam(groupName);

	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping({ "/deleteMenu" })
	@ResponseBody
	public Object deleteTreeUser(@RequestParam("treenodeid") String treenodeid) {
		Map result = new HashMap();
		boolean falg =  treeUserService.deleteTreeUserId(treenodeid);
		result.put("falg", falg);
		return result;
	}
	
	@RequestMapping("/newTreeNodeId")
	@ResponseBody
	public String createNewNodeId() {
		int menuId = treeUserService.createNewMenuId();
		return menuId + "";
	} 
	
	@SuppressWarnings({ "unchecked" })
	@RequestMapping({ "/detailMenuNode" })
	@ResponseBody
	public Map detailMenuNode(@RequestParam("menuId") String menuId) {
		Map<String,Object> map = treeUserService.queryMenuByMenuId(menuId);
		if(map==null||map.get("group_id")==null){
			map = new HashMap();
			map.put("menuitemid", "error");
			return map;
		}
		Object create_time = map.get("create_time");
		Object begin_date = map.get("begin_date");
		Object end_date = map.get("end_date");
		if(create_time!=null)
		map.put("create_time", create_time.toString().substring(0, 19));
		if(begin_date!=null)
			map.put("begin_date", begin_date.toString().substring(0, 19));
		if(end_date!=null)
			map.put("end_date", end_date.toString().substring(0, 19));
		return map;
	}
	
	@RequestMapping({ "/inserUserGroup" })
	public String inserUserGroup(HttpServletRequest request,Model model) {
		 String groupid = request.getParameter("groupid");
		 String groupname = request.getParameter("groupname");
		 String parentid = request.getParameter("parentid");
		 String createtime = request.getParameter("createtime");
		 String begindate = request.getParameter("startdate").length()==0?null:request.getParameter("startdate");
		 String enddate = request.getParameter("enddate").length()==0?null:request.getParameter("enddate");
		 String userlimit = request.getParameter("userlimit");
		 String sortnum = request.getParameter("sortnum");
		 String status = request.getParameter("status");
		 treeUserService.addUserGroup(groupid, groupname, parentid, Integer.parseInt(status), new Date(), begindate, enddate, Integer.parseInt(userlimit), Integer.parseInt(sortnum));
		return "redirect:treeUserManage";
	}
	
	@RequestMapping({ "/updateUserGroup" })
	public String updateUserGroup(HttpServletRequest request,Model model) {
		 String groupid = request.getParameter("groupid");
		 String groupname = request.getParameter("groupname");
		 String parentid = request.getParameter("parentid");
		 String createtime = request.getParameter("createtime");
		 String begindate = request.getParameter("startdate").length()==0?null:request.getParameter("startdate");
		 String enddate = request.getParameter("enddate").length()==0?null:request.getParameter("enddate");
		 String userlimit = request.getParameter("userlimit");
		 String sortnum = request.getParameter("sortnum");
		 String status = request.getParameter("status");
		 treeUserService.updateUserGroup(groupid, groupname, parentid, Integer.parseInt(status), begindate, enddate, Integer.parseInt(userlimit), Integer.parseInt(sortnum));
		return "redirect:treeUserManage";
	}
	
	@RequestMapping({ "/updateUserGroupMap" })
	public String updateUserGroupMap(HttpServletRequest request,Model model) {
		 String groupid = request.getParameter("groupid");
		 String parentid = request.getParameter("parentid");
		 String oldparentid = request.getParameter("oldparentid");
		 treeUserService.updateUserGroupMap(groupid, parentid, oldparentid);
		
		return "redirect:treeUserManage";
	}
	

	
	@RequestMapping({ "/updateNewMenu" })
	@ResponseBody
	public Map<String,Object> updateNewMenu(HttpServletRequest request,Model model) {
		Map<String,Object> map = new HashMap<String, Object>();
		 String userids = request.getParameter("menuId");
		 String groupid = request.getParameter("menuname");
		 boolean flag = treeUserService.updateGroupName(userids, groupid);
		 map.put("flag",flag);
		 return map;
		 
	}
	
	/**
	 * 查询已关联角色
	 * @param req
	 * @return
	 */
	@RequestMapping({"/getConnectRole"})
	@ResponseBody
	public List<Map<String, Object>> getConnectRole(HttpServletRequest req){
		String groupId = req.getParameter("groupId");
		String roleName = req.getParameter("roleName");
		List<Map<String, Object>> list = treeUserService.getConnectRole(groupId, roleName);
		return list;
	}
	
	/**
	 * 查询未关联角色
	 * @param req
	 * @return
	 */
	@RequestMapping({"/getUnConnectRole"})
	@ResponseBody
	public List<Map<String, Object>> getUnConnectRole(HttpServletRequest req){
		String groupId = req.getParameter("groupId");
		String roleName = req.getParameter("roleName");
		List<Map<String, Object>> list = treeUserService.getUnConnectRole(groupId, roleName);
		return list;
	}
	
	/**
	 * 关联角色
	 * @param req
	 * @return
	 */
	@RequestMapping({"/addRole"})
	@ResponseBody
	public boolean addRole(HttpServletRequest req){
		String groupId = req.getParameter("groupId");
		String roles = req.getParameter("roles");
		String[] roleIds = roles.split(",");
		for(String roleId : roleIds){
			treeUserService.addRole(groupId, roleId);
		}
		return true;
	}
	
	/**
	 * 删除角色关联
	 * @param req
	 * @return
	 */
	@RequestMapping({"/delRole"})
	@ResponseBody
	public boolean delRole(HttpServletRequest req){
		String groupId = req.getParameter("groupId");
		String roles = req.getParameter("roles");
		String[] roleList = roles.split(",");
		String roleIds = "";
		for(String roleId : roleList){
			if(!StringUtils.isEmpty(roleIds)){
				roleIds += ",";
			}
			roleIds += "'" + roleId + "'";
		}
		treeUserService.delRole(groupId, roleIds);
		return true;
	}
}
