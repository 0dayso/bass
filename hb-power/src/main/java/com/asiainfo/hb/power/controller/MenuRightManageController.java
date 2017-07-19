package com.asiainfo.hb.power.controller;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.power.service.MenuRightService;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * 菜单权限管理
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/menuRightMana")
@SessionAttributes({ SessionKeyConstants.USER })
public class MenuRightManageController {
	private static final int pageSize = 6;
	 
	@Autowired
	private MenuRightService m_MenuRightService;
	
	protected String menuid =null;
	
	
	/**
	 * 查询菜单
	 * @param model
	 * @param req
	 * @return
	 */
	@RequestMapping("/menuRight")
	public String menuRight(Model model,HttpServletRequest req,@ModelAttribute(SessionKeyConstants.USER) User user){
		String menuitemid = req.getParameter("menuid");
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
		List<Map<String, Object>> list = m_MenuRightService.getMenuList();
		List<Map<String, Object>> powerlist = m_MenuRightService.getUserMenuPower(menuid,userid);
		model.addAttribute("menuList", JsonHelper.getInstance().write(list));
		model.addAttribute("sysMenus", list);
		model.addAttribute("allRightFlag", allRightFlag);
		model.addAttribute("powerList", powerlist);
		model.addAttribute("power", JsonHelper.getInstance().write(powerlist));
		return "ftl/menu/menuRight";
	}
	
	/**
	 * 查询已绑定角色数量
	 * @param req
	 * @return
	 */
	@RequestMapping("/queryBindRoleCount")
	@ResponseBody
	public Map<String, Object> queryBindRoleCount(HttpServletRequest req){
		Map<String, Object> map = new HashMap<String, Object>();
		String menuId = req.getParameter("menuId");
		String roleName = req.getParameter("roleName");
		int totalCount = m_MenuRightService.getBindRoleCount(menuId, roleName);
		map.put("totalCount", totalCount);
		map.put("pageCount", getPageCount(totalCount));
		return map;
	}
	
	/**
	 * 已绑定角色分页查询
	 * @param req
	 * @return
	 */
	@RequestMapping("/queryBindRole")
	@ResponseBody
	public List<Map<String, Object>> queryBindRole(HttpServletRequest req){
		String menuId = req.getParameter("menuId");
		int currentPage = Integer.parseInt(req.getParameter("currentPage"));
		String roleName = req.getParameter("roleName");
		List<Map<String, Object>> list = m_MenuRightService.getBindRoleList(menuId, roleName, (currentPage-1)* pageSize, pageSize);
		return list;
	}
	
	/**
	 * 查询未绑定角色数量
	 * @param req
	 * @return
	 */
	@RequestMapping("/queryUnbRoleCount")
	@ResponseBody
	public Map<String, Object> queryUnbRoleCount(HttpServletRequest req){
		Map<String, Object> map = new HashMap<String, Object>();
		String menuId = req.getParameter("menuId");
		String roleName = req.getParameter("roleName");
		int totalCount = m_MenuRightService.getUnbRoleCount(menuId, roleName);
		map.put("totalCount", totalCount);
		map.put("pageCount", getPageCount(totalCount));
		return map;
	}
	
	/**
	 * 未绑定角色分页查询
	 * @param req
	 * @return
	 */
	@RequestMapping("/queryUnbRole")
	@ResponseBody
	public List<Map<String, Object>> queryUnbRole(HttpServletRequest req){
		String menuId = req.getParameter("menuId");
		int currentPage = Integer.parseInt(req.getParameter("currentPage"));
		String roleName = req.getParameter("roleName");
		List<Map<String, Object>> list = m_MenuRightService.getUnbRoleList(menuId, roleName, (currentPage-1)* pageSize, pageSize);
		return list;
	}
	
	/**
	 * 角色绑定
	 * @param req
	 * @return
	 */
	@RequestMapping("/bindRole")
	@ResponseBody
	public Map<String, Object> bindRole(HttpServletRequest req){
		Map<String, Object> map = new HashMap<String, Object>();
		String menuId = req.getParameter("menuId");
		String roles = req.getParameter("roles");
		String[] roleList = roles.split(",");
		for(String roleId: roleList){
			m_MenuRightService.saveRole(menuId, roleId);
		}
		map.put("flag", true);
		return map;
	}
	
	/**
	 * 删除关联角色
	 * @param req
	 * @return
	 */
	@RequestMapping("/unBindRole")
	@ResponseBody
	public Map<String, Object> unBindRole(HttpServletRequest req){
		Map<String, Object> map = new HashMap<String, Object>();
		String menuId = req.getParameter("menuId");
		String roles = req.getParameter("roles");
		String[] roleList = roles.split(",");
		String roleIds = "";
		for(String roleId : roleList){
			if(!StringUtils.isEmpty(roleIds)){
				roleIds += ",";
			}
			roleIds += "'" + roleId + "'";
		}
		m_MenuRightService.deleteRoles(menuId, roleIds);
		return map;
	}
	
	/**
	 * 查询已绑定用户数量
	 * @param req
	 * @return
	 */
	@RequestMapping("/queryBindUserCount")
	@ResponseBody
	public Map<String, Object> queryBindUserCount(HttpServletRequest req){
		Map<String, Object> map = new HashMap<String, Object>();
		String menuId = req.getParameter("menuId");
		String userName = req.getParameter("userName");
		int totalCount = m_MenuRightService.getBindUserCount(menuId, userName);
		map.put("totalCount", totalCount);
		map.put("pageCount", getPageCount(totalCount));
		return map;
	}
	
	/**
	 * 已绑定用户分页查询
	 * @param req
	 * @return
	 */
	@RequestMapping("/queryBindUser")
	@ResponseBody
	public List<Map<String, Object>> queryBindUser(HttpServletRequest req){
		String menuId = req.getParameter("menuId");
		int currentPage = Integer.parseInt(req.getParameter("currentPage"));
		String userName = req.getParameter("userName");
		List<Map<String, Object>> list = m_MenuRightService.getBindUserList(menuId, userName, (currentPage-1)* pageSize, pageSize);
		return list;
	}
	
	/**
	 * 查询未绑定用户数量
	 * @param req
	 * @return
	 */
	@RequestMapping("/queryUnbUserCount")
	@ResponseBody
	public Map<String, Object> queryUnbUserCount(HttpServletRequest req){
		Map<String, Object> map = new HashMap<String, Object>();
		String menuId = req.getParameter("menuId");
		String userName = req.getParameter("userName");
		int totalCount = m_MenuRightService.getUnbUserCount(menuId, userName);
		map.put("totalCount", totalCount);
		map.put("pageCount", getPageCount(totalCount));
		return map;
	}
	
	/**
	 * 未绑定用户分页查询
	 * @param req
	 * @return
	 */
	@RequestMapping("/queryUnbUser")
	@ResponseBody
	public List<Map<String, Object>> queryUnbUser(HttpServletRequest req){
		String menuId = req.getParameter("menuId");
		int currentPage = Integer.parseInt(req.getParameter("currentPage"));
		String userName = req.getParameter("userName");
		List<Map<String, Object>> list = m_MenuRightService.getUnbUserList(menuId, userName, (currentPage-1)* pageSize, pageSize);
		return list;
	}
	
	/**
	 * 用户绑定
	 * @param req
	 * @return
	 */
	@RequestMapping("/bindUser")
	@ResponseBody
	public Map<String, Object> bindUser(HttpServletRequest req){
		Map<String, Object> map = new HashMap<String, Object>();
		String menuId = req.getParameter("menuId");
		String users = req.getParameter("users");
		String[] userList = users.split(",");
		for(String userId: userList){
			m_MenuRightService.saveUser(menuId, userId);
		}
		map.put("flag", true);
		return map;
	}
	
	/**
	 * 删除关联用户
	 * @param req
	 * @return
	 */
	@RequestMapping("/unBindUser")
	@ResponseBody
	public Map<String, Object> unBindUser(HttpServletRequest req){
		Map<String, Object> map = new HashMap<String, Object>();
		String menuId = req.getParameter("menuId");
		String users = req.getParameter("users");
		String[] userList = users.split(",");
		String userIds = "";
		for(String roleId : userList){
			if(!StringUtils.isEmpty(userIds)){
				userIds += ",";
			}
			userIds += "'" + roleId + "'";
		}
		m_MenuRightService.deleteUsers(menuId, userIds);
		return map;
	}
	
	private int getPageCount(int totalCount){
		int pageCount;
		if (totalCount % pageSize == 0) {
			pageCount = totalCount / pageSize;
		} else {
			pageCount = totalCount / pageSize + 1;
		}
		return pageCount == 0 ? 1 : pageCount;
	}
	
	@RequestMapping("/getNextMenuId")
	@ResponseBody
	public int getNextMenuId(){
		int nextId = m_MenuRightService.getNextMenuId();
		return nextId;
	}
	
	@RequestMapping("/saveMenu")
	public String saveMenu(HttpServletRequest req){
		String menuId = req.getParameter("menuId");
		String menuItemTitle = req.getParameter("menuItemTitle");
		String parentId = req.getParameter("parentId");
		String sortNum = req.getParameter("sortNum");
		if(StringUtils.isEmpty(sortNum)){
			sortNum = "0";
		}
		String iconUrl = req.getParameter("iconUrl");
		if(StringUtils.isEmpty(iconUrl)){
			iconUrl = "";
		}
		
		String url = req.getParameter("url");
		String state = req.getParameter("state");
		String menuType = req.getParameter("menuType");
		String powerAdd = req.getParameter("powerAdd");
		String[] munuPowerNames = req.getParameterValues("munu_power_name");
		String[] munuPowerIds = req.getParameterValues("munu_power_id");
		if(StringUtils.isEmpty(powerAdd)){
			powerAdd = "N";
		}
		
		String powerDel = req.getParameter("powerDel");
		if(StringUtils.isEmpty(powerDel)){
			powerDel = "N";
		}
		
		String powerEdit = req.getParameter("powerEdi");
		if(StringUtils.isEmpty(powerEdit)){
			powerEdit = "N";
		}
		String powerQry = req.getParameter("powerSel");
		if(StringUtils.isEmpty(powerQry)){
			powerQry = "N";
		}
		
		String power = powerAdd + "," + powerDel + "," + powerEdit + "," + powerQry;
		m_MenuRightService.saveMenu(menuId, menuItemTitle, parentId, sortNum, iconUrl, url, state, menuType, power);
		
		int num = m_MenuRightService.getNewSort(menuId);
		for (int i = 0; i < munuPowerNames.length; i++) {
			String powerName = munuPowerNames[i];
			String powerid = munuPowerIds[i];
			String createPowerId = menuId+"_"+num;
			if(!StringUtils.isEmpty(powerName)){
				if(StringUtils.isEmpty(powerid)){
					String[] power_des = powerName.split("-");
					m_MenuRightService.insertMenuPower(menuId, createPowerId, power_des[0], power_des[1], power_des[2], num);//
					num = num+1;
				}else{
					String[] power_des = powerName.split("-");
					m_MenuRightService.updateMenuPower(menuId, powerid, power_des[0],power_des[1],power_des[2]);
				}
			}
		}
		return "redirect:menuRight";
	}
	
	@RequestMapping("/delMenu")
	@ResponseBody
	public Boolean delMenu(HttpServletRequest req){
		String menuId = req.getParameter("menuId");
		m_MenuRightService.delMenu(menuId);
		return true;
	}
	
	@RequestMapping("/getMenuDetail")
	@ResponseBody
	public Map<String, Object> getMenuDetail(HttpServletRequest req){
		String menuId = req.getParameter("menuId");
		Map<String, Object> map = m_MenuRightService.getMenuDetail(menuId);
		List<Map<String, Object>> list = m_MenuRightService.getPowerByMenuId(menuId);
		String power = (String) map.get("power");
		if(!StringUtils.isEmpty(power)){
			String[] powers = power.split(",");
			map.put("poweradd", powers[0]);
			map.put("powerdel", powers[1]);
			map.put("poweredit", powers[2]);
			map.put("powerqry", powers[3]);
		}
		map.put("powers", list);
		return map;
	}
	
	@RequestMapping("/getAllPowerAndCheck")
	@ResponseBody
	public List<Map<String, Object>> getAllPowerAndCheck(HttpServletRequest req){
		
		List<Map<String, Object>> list = new ArrayList<Map<String,Object>>();
		String menuid = req.getParameter("menuId");
		String roleid = req.getParameter("roleId");
		
		list = m_MenuRightService.getAllPowerAndCheck(menuid, roleid);
		return list;
	}
	
	@RequestMapping("/addPowerToRole")
	@ResponseBody
	public Map<String, Object> addPowerToRole(HttpServletRequest req){
		Map<String, Object> map = new HashMap<String, Object>();
		boolean flag = false;
		String menuid = req.getParameter("menuId");
		String roleid = req.getParameter("roleId");
		String powerids = req.getParameter("powerIds");
		String[] powerid = powerids.split(",");
		flag = m_MenuRightService.deleteAllRolePower(menuid);
		if(flag){
			for (int i = 0; i < powerid.length; i++) {
				flag = m_MenuRightService.addPowerToRole(roleid, menuid, powerid[i]);
				if(flag==false) break;
			}
		}
		map.put("flag", flag);
		return map;
	}
	
}
