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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.power.service.MenuManageService;
import com.asiainfo.hb.power.service.UserItemsManageService;
import com.asiainfo.hb.power.service.UserTreeManageService;
import com.asiainfo.hb.web.SessionKeyConstants;

/**
 * @author zhaob 
 * @date 2016年8月24日
 */
@Controller
@RequestMapping("/userItmesManage")
@SessionAttributes({ SessionKeyConstants.USER })
@SuppressWarnings({"rawtypes"})
public class UserItemsManageControllerbak {
	@Autowired
	MenuManageService menuService;
	@Autowired
	UserItemsManageService itemsManageService;
	@Autowired
	UserTreeManageService treeUserService;
	/**
	 * 展示角色tree信息
	 * @param model
	 * @return 角色id group_id（treeNodeId）、角色名称group_name（treeNodeName）
	 */
	@RequestMapping("/treeUserManage")
	public String treeUserManage(Model model){
		List list = treeUserService.queryMenus();
		model.addAttribute("smsMenus", list);
		return "ftl/user/userGroupManage";
	}
	/**
	 * 根据group_id（treeNodeId）对查询结果进行分组
	 * @return 
	 */
	@RequestMapping("/treeUser")
	@ResponseBody
	public List<Map<String,Object>> getAllMenuBytable(){
		return treeUserService.queryAlltreeUser();
	}
	@RequestMapping("/tableMenu")
	@ResponseBody
	public List<Map<String,Object>> getAllMenuBytable( @RequestParam("tableName")String tableName){
		String menuTable = "FPF_SYS_MENU_ITEMS";
		if(tableName.equals("jf")){
			menuTable = "FPF_SYS_MENU_ITEM";
		}
		return menuService.queryAllMenuByMenuTab(menuTable);
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
	/**
	 * 展示菜单tree信息
	 * @param tableName
	 * @return
	 */
	@RequestMapping("/treeManage")
	public String treeManage(Model model, HttpServletRequest request){
		String tableName = request.getParameter("tableName");
		if(tableName==null)
			tableName="yh";
		String menuTable = "FPF_SYS_MENU_ITEMS";
		if(tableName.equals("jf")){
			menuTable = "FPF_SYS_MENU_ITEM";
		}
		List list = menuService.queryMenus("1",menuTable);
		model.addAttribute("smsMenus", list);
		model.addAttribute("tableType",tableName);
		return "ftl/user/userGroupManage";
		//ftl/user/userGroupManage
	}
	
	@RequestMapping("/newTreeNodeId")
	@ResponseBody
	public String createNewNodeId(@RequestParam("tableName")String tableName) {
		String menuTable = "FPF_SYS_MENU_ITEMS";
		if(tableName.equals("jf")){
			menuTable = "FPF_SYS_MENU_ITEM";
		}
		int menuId = menuService.createNewMenuId(menuTable);
		return menuId + "";
	} 
	
	/**
	 * 展示菜单权限信息状态  1、add 2、del 3、edi 4、sel
	 * @param menuId
	 * @param tableName
	 * @return
	 */
	@SuppressWarnings({ "unchecked" })
	@RequestMapping({ "/detailMenu" })
	@ResponseBody
	public Map detailMenu(@RequestParam("menuId") String menuId,@RequestParam("roleId") int roleId) {
		Map map = null;
		List<Map<String,Object>> list = itemsManageService.getPowerbymenuid(Integer.valueOf(roleId),Integer.valueOf(menuId));
		if(list.size()>0){
			map = list.get(0);
		}
		if(map==null||map.get("power")==null){
			map = new HashMap();
			map.put("power", "error");
			return map;
		}
		String[]  powers= map.get("power").toString().split(",");
		map.put("poweradd", powers[0]);
		map.put("powerdel", powers[1]);
		map.put("poweredi", powers[2]);
		map.put("powersel", powers[3]);
		return map;
	}
	/**
	 * FPF_USER_GROUP
	 *   根据groupId
	 * @param menuId 菜单id
	 * @return map包含数据集合
	 */
	
	//根据前台传入的角色id查询出对应菜单信息
	@RequestMapping({ "/getMenuManageNode" })
	@ResponseBody
	public List<Map<String,Object>> getMenuManageNode(HttpServletRequest request,Model model) {
		//System.out.println("groupId="+groupId);
		int groupId = Integer.valueOf(request.getParameter("groupId"));
		List<Map<String,Object>> list=itemsManageService.queryByGroupid(groupId);
		return list;
	}
	
	/**
	 * 根据取消选中的菜单Id  删除对应的菜单权限信息
	 * @param treenodeid
	 * @return boolean:  flag= true OR false
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping({ "/deleteTreeUser" })
	@ResponseBody
	public Object deleteTreeUser(HttpServletRequest request,Model model) {
		Map result = new HashMap();
		String menuId=request.getParameter("menuId");
		String roleId=request.getParameter("roleId");
		System.out.println("menuId="+menuId);
//		System.out.println("roleId="+roleId);
		boolean falg =  itemsManageService.deletebypId(Integer.valueOf(roleId),Integer.valueOf(menuId));
		result.put("falg", falg);
		return result;
	}
	//保存方法保存 选中的角色树、菜单树 以及设置权限信息
	@RequestMapping({ "/addUserItems" })
	@ResponseBody
	public Object addUserItems(HttpServletRequest request,Model model){
		boolean falg =true;
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,Object> menuMap = new HashMap<String, Object>();
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		
		String groupId = request.getParameter("roleId");
		String menuId= request.getParameter("menuId");
		String firstNode = request.getParameter("firstNode");
		String power = "N,N,N,Y";//默认值
		
		menuMap =  menuService.queryMenuByMenuId(menuId, "FPF_SYS_MENU_ITEMS");
		power = menuMap.get("power").toString();
		falg = itemsManageService.addUserItems(groupId,menuId,power);
		if(firstNode.equals("yes")){
			list = itemsManageService.getAllParentItemsBycid(String.valueOf(menuId));
			if(falg==true&&list.size()>0){
				itemsManageService.addUserParentItems(groupId,list);
			}
		}
		
		result.put("falg", falg);
		return result;
	}
	//修改方法 根据选中的菜单树 更改权限信息
	@RequestMapping({ "/updateByMenuId" })
	@ResponseBody
	public Map updateByMenuId(HttpServletRequest request,Model model) {
		Map<String,Object> map = new HashMap<String, Object>();
		 String menuid = request.getParameter("menuId");
		 String roleid = request.getParameter("roleId");
		 String poweradd = request.getParameter("poweradd");
		 System.out.println("poweradd="+poweradd);
			if (poweradd == null||poweradd.trim().equals(""))
				poweradd = "N";
			String powerdel = request.getParameter("powerdel");
			if (powerdel == null||powerdel.trim().equals(""))
				powerdel = "N";
			String poweredi = request.getParameter("poweredi");
			if (poweredi == null||poweredi.trim().equals(""))
				poweredi = "N";
			String powersel = request.getParameter("powersel");
			if (powersel == null||powersel.trim().equals(""))
				powersel = "N";
		 String	power = poweradd+","+powerdel+","+poweredi+","+powersel;
		 boolean flag = itemsManageService.updateByMenuid(Integer.valueOf(roleid),Integer.valueOf(menuid), power);
		 map.put("flag",flag);
		 return map;
	}
	
	
	
}
