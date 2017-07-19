package com.asiainfo.hb.power.controller;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.power.models.PageQueryParam;
import com.asiainfo.hb.power.service.MenuRightService;
import com.asiainfo.hb.power.service.RoleService;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * 角色管理
 * 
 * @author 李志坚 Date: 2016-10-24 下午04:33:47
 */
@Controller
@RequestMapping("/role")
@SessionAttributes({ SessionKeyConstants.USER })
public class RoleController extends BaseDao {
	@Autowired
	RoleService roleService;
	
	@Autowired
	private MenuRightService m_MenuRightService;
	
	protected String menuid =null;
	
	public Logger logger = LoggerFactory.getLogger(RoleController.class);

	// 管理页面
	@SuppressWarnings("rawtypes")
	@RequestMapping("/manage")
	public String manage(PageQueryParam pageQueryParam, ModelMap model, HttpServletRequest request ,@ModelAttribute(SessionKeyConstants.USER) User user) throws Exception {
		Map parameterMap = new HashMap();
		String roleName = request.getParameter("roleName");
		if(roleName!=null)
		roleName = URLDecoder.decode(roleName, "UTF-8");
		int totalCount = roleService.getRoleCount(roleName);
		int pageCount;
		String groupName = user.getGroupName();
		int isadmin = user.getSperAdmin();
		String allRightFlag = "NO";
		if((isadmin==1)||groupName.equals("云化经分开发人员")||groupName.equals("湖北移动业支经分用户组")){
			allRightFlag = "YES";
		}
		String menuitemid = request.getParameter("menuid");
		String userid = user.getId();
		if(menuitemid!=null){
			menuid = menuitemid;
		}
		if (totalCount % pageQueryParam.getPageSize() == 0) {
			pageCount = totalCount / pageQueryParam.getPageSize();
		} else {
			pageCount = totalCount / pageQueryParam.getPageSize() + 1;
		}
		List<Map<String, Object>> list = roleService.queryRole(roleName, pageQueryParam.getIndexNum(), pageQueryParam.getPageSize());
		List<Map<String, Object>> powerlist = m_MenuRightService.getUserMenuPower(menuid,userid);
		pageQueryParam.setPageCount(pageCount);
		model.addAttribute("parameterMap", parameterMap);
		model.addAttribute("list", list);
		model.addAttribute("pageQueryParam", pageQueryParam);
		model.addAttribute("powerList", powerlist);
		model.addAttribute("power", JsonHelper.getInstance().write(powerlist));
		model.addAttribute("allRightFlag", allRightFlag);
		return "ftl/role/manage";
	}

	// 保存新增
	@RequestMapping("/addSave")
	public String addSave(PageQueryParam param, ModelMap model, HttpServletRequest request) throws Exception {
		String roleName = request.getParameter("roleName_c");
		roleService.add(roleName);
		return "redirect:manage";
	}

	// 保存修改
	@RequestMapping("/editSave")
	public String editSave(PageQueryParam param, ModelMap model, HttpServletRequest request) throws Exception {
		String roleId = request.getParameter("roleId_u");
		String roleName = request.getParameter("roleName_u");
		roleService.update(roleId, roleName);
		return "redirect:manage";
	}

	// 删除
	@RequestMapping("/delete")
	public String delete(PageQueryParam param, ModelMap model, HttpServletRequest request) throws Exception {
		String roleId = request.getParameter("roleId");
		roleService.delete(roleId);
		return "redirect:manage";
	}

	// 批量删除
	@RequestMapping("/batchDelete")
	@ResponseBody
	public void batchDelete(HttpServletRequest request, HttpServletResponse response) {
		String items = request.getParameter("delitems");
		String[] strs = items.split(",");
		String ids = "";
		for (String str : strs) {
			ids += "'" + str + "',";
		}
		roleService.batchDelete(ids);
	}

	// 判断是否已经存在类似的记录
	@RequestMapping("/checkExist")
	@ResponseBody
	public Map<String, Object> checkExist(HttpServletRequest request, Model model) {
		Map<String, Object> result = new HashMap<String, Object>();
		boolean flag = false;
		String roleName = request.getParameter("roleName");
		List<Map<String, Object>> list = roleService.queryRole(roleName, 0, 999999);
		if (list.size() > 0) {
			flag = true;
		}
		result.put("flag", flag);
		return result;
	}
	
	/**
	 * 查询角色对应菜单权限
	 * @param request
	 * @return
	 */
	@RequestMapping("/getMenuList")
	@ResponseBody
	public List<Map<String, Object>> getMenuList(HttpServletRequest request){
		String roleId = request.getParameter("roleId");
		String menuName = request.getParameter("menuName");
		List<Map<String, Object>> list = roleService.getMenuList(roleId, menuName);
		return list;
	}
	
	/**
	 * 查询已关联用户组
	 * @param request
	 * @return
	 */
	@RequestMapping("/getConnectGroup")
	@ResponseBody
	public List<Map<String, Object>> getConnectGroup(HttpServletRequest request){
		String roleId = request.getParameter("roleId");
		String groupName = request.getParameter("groupName");
		List<Map<String, Object>> list = roleService.getConnectGroup(roleId, groupName);
		return list;
	}
	
	/**
	 * 添加用户组
	 * @param request
	 * @return
	 */
	@RequestMapping("/addGroup")
	@ResponseBody
	public boolean addGroup(HttpServletRequest request){
		String roleId = request.getParameter("roleId");
		String groups = request.getParameter("groups");
		String[] groupList = groups.split(",");
		for(String groupId: groupList){
			roleService.addGroup(roleId, groupId);
		}
		return true;
	}

	/**
	 * 删除用户组
	 * @param request
	 * @return
	 */
	@RequestMapping("/delGroup")
	@ResponseBody
	public boolean delGroup(HttpServletRequest request){
		String roleId = request.getParameter("roleId");
		String groups = request.getParameter("groups");
		String[] groupList = groups.split(",");
		String groupIds = "";
		for(String groupId : groupList){
			if(!StringUtils.isEmpty(groupIds)){
				groupIds += ",";
			}
			groupIds += "'" + groupId + "'";
		}
		roleService.delGroup(roleId, groupIds);
		return true;
	}
	
	/**
	 * 查询未绑定用户组
	 * @param req
	 * @return
	 */
	@RequestMapping("/getUnConnectGroup")
	@ResponseBody
	public List<Map<String, Object>> getUnConnectGroup(HttpServletRequest req){
		String roleId = req.getParameter("roleId");
		String groupName = req.getParameter("groupName");
		List<Map<String, Object>> list = roleService.getUbConnectGroup(roleId, groupName);
		return list;
	}
	
	/**
	 * 查询已关联的菜单
	 * @param request
	 * @return
	 */
	@RequestMapping("/selectConnectMenu")
	@ResponseBody
	public List<Map<String, Object>> getConnectMenu(HttpServletRequest request){
		String roleId = request.getParameter("roleId");
		String menuName = request.getParameter("menuName");
		List<Map<String, Object>> list = roleService.getConnectMenu(roleId, menuName);
		return list;
	}
	
	/**
	 * 添加菜单
	 * @param request
	 * @return
	 */
	@RequestMapping("/addMenus")
	@ResponseBody
	public boolean addMenus(HttpServletRequest request){
		String roleId = request.getParameter("roleId");
		String menus = request.getParameter("menus");
		String[] menuList = menus.split(",");
		for(String menuId: menuList){
			roleService.addMenus(roleId, menuId);
		}
		return true;
	}

	/**
	 * 删除用户组
	 * @param request
	 * @return
	 */
	@RequestMapping("/delMenus")
	@ResponseBody
	public boolean delMenus(HttpServletRequest request){
		String roleId = request.getParameter("roleId");
		String menus = request.getParameter("menus");
		String[] menuList = menus.split(",");
		String menuIds = "";
		for(String menuId : menuList){
			if(!StringUtils.isEmpty(menuIds)){
				menuIds += ",";
			}
			menuIds += "'" + menuId + "'";
		}
		roleService.delMenus(roleId, menuIds);
		return true;
	}
	
	/**
	 * 查询未绑定用户组
	 * @param req
	 * @return
	 */
	@RequestMapping("/selectUnConnectMenu")
	@ResponseBody
	public List<Map<String, Object>> getUnConnectMenu(HttpServletRequest req){
		String roleId = req.getParameter("roleId");
		String menuName = req.getParameter("menuName");
		List<Map<String, Object>> list = roleService.getUbConnectMenu(roleId, menuName);
		return list;
	}
}
