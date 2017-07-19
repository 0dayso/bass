package com.asiainfo.hb.power.controller;

import java.io.UnsupportedEncodingException;
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
import com.asiainfo.hb.web.SessionKeyConstants;

@Controller
@RequestMapping("/menuManage")
@SessionAttributes({ SessionKeyConstants.USER })
@SuppressWarnings({"rawtypes","unused"})
public class MenuManageControllerbak {
	
	@Autowired
	MenuManageService menuService;
	
	@RequestMapping("/tableMenu")
	@ResponseBody
	public List<Map<String,Object>> getAllMenuBytable( @RequestParam("tableName")String tableName){
		String menuTable = "FPF_SYS_MENU_ITEMS";
		if(tableName.equals("jf")){
			menuTable = "FPF_SYS_MENU_ITEM";
		}
		return menuService.queryAllMenuByMenuTab(menuTable);
	}
	
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
		return "ftl/menu/menuManage";
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
	
	@SuppressWarnings({ "unchecked" })
	@RequestMapping({ "/detailMenu" })
	@ResponseBody
	public Map initNewMenuModfiy(@RequestParam("menuId") String menuId,
			@RequestParam("tableName") String tableName) {
		String menuTable = "FPF_SYS_MENU_ITEMS";
		if(tableName.equals("jf")){
			menuTable = "FPF_SYS_MENU_ITEM";
		}else if(tableName.equals("yh")){
			menuTable = "FPF_SYS_MENU_ITEMS";
		}
		Map map = menuService.queryMenuByMenuId(menuId,menuTable);
		if(map==null||map.get("menuitemid")==null){
			map = new HashMap();
			map.put("menuitemid", "error");
			return map;
		}
		String[]  powers= map.get("power").toString().split(",");
		map.put("poweradd", powers[0]);
		map.put("powerdel", powers[1]);
		map.put("poweredi", powers[2]);
		map.put("powersel", powers[3]);
		map.put("tableName", tableName);
		return map;
	}
	
	@RequestMapping({ "/deleteMenu" })
	@ResponseBody
	public Object deleteMenuByMenuId(@RequestParam("menuItemId") int menuId,
			@RequestParam("tableName") String tableName) {
		Map result = new HashMap();
		String menuTable = "FPF_SYS_MENU_ITEMS";
		if(tableName.equals("jf")){
			menuTable = "FPF_SYS_MENU_ITEM";
		}
		menuService.delMenuAndRoleMenuByMenuId(menuId,menuTable);
		return result;
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping({ "/newMenuOrUpdateTitle" })
	@ResponseBody
	public Object createMenuOrUpdateMenuTitle(@RequestParam("menuItemId") String menuId,
			@RequestParam("parentId") String pid, @RequestParam("menuItemTitle") String menuItemTitle,
			@RequestParam("tableName") String tableName) {
		Map result = new HashMap();
		String menuTable = "FPF_SYS_MENU_ITEMS";
		if(tableName.equals("jf")){
			menuTable = "FPF_SYS_MENU_ITEM";
		}
		Map map = menuService.queryMenuByMenuId(menuId, menuTable);
		if(map!=null){
			menuService.modifyMenuTitle(menuItemTitle,menuId, menuTable);
			map.put("menuitemtitle", menuItemTitle);
			map.put("tableName", tableName);
			String[]  powers= map.get("power").toString().split(",");
			map.put("poweradd", powers[0]);
			map.put("powerdel", powers[1]);
			map.put("poweredi", powers[2]);
			map.put("powersel", powers[3]);
			map.put("tableName", tableName);
			map.put("action", "modify");
			return map;
		}else{
			int maxSortNum = menuService.queryMaxSortNumByPid(Integer.parseInt(pid),menuTable)+1;
			result.put("sortnum", maxSortNum);
			result.put("menuitemid", menuId);
			result.put("tableName",tableName);
			result.put("menuitemtitle", menuItemTitle);
			result.put("parentid", pid);
			result.put("action", "insertMenu");
			result.put("poweradd", "N");
			result.put("powerdel", "N");
			result.put("poweredi", "N");
			result.put("powersel", "Y");
			result.put("iconurl", "");
			result.put("url", "");
			result.put("state", "");
			result.put("menutype", "");
		}
		return result;
	}
	
	@RequestMapping({ "/insertMenu" })
	public String insertMenu(HttpServletRequest request, @RequestParam("menuId") int menuId,
			@RequestParam("parentId") int pid, Model model,@RequestParam("tableName")String tableName) {
		String power = "N,N,N,Y";
		String menuTable = "FPF_SYS_MENU_ITEMS";
		if(tableName.equals("jf")){
			menuTable = "FPF_SYS_MENU_ITEM";
		}
		String menuItemTitle = request.getParameter("menuItemTitle");
		String sortNum = request.getParameter("sortNum");
		if (sortNum == null)
			sortNum = "0";
		if (menuItemTitle == null)
			menuItemTitle = "";
		String pic1 = request.getParameter("iconurl");
		if (pic1 == null)
			pic1 = "";
		String url = request.getParameter("url");
		if (url == null)
			url = "";
		String status = request.getParameter("state");
		if (status == null)
			status = "0";
		String menutype = request.getParameter("menutype");
		if (menutype == null)
			menutype = "0";
		if(tableName.equals("jf")){
			if(menutype.equals("0")){
				menutype="菜单";
			}else if(menutype.equals("1")){
				menutype="配置";
			}else{
				menutype="资源包";
			}
		}
		String poweradd = request.getParameter("poweradd");
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
		power =poweradd+","+powerdel+","+poweredi+","+powersel;
		menuService.insertMenu(menuId, pid,menuItemTitle,Integer.parseInt(sortNum), 
				url, pic1,Integer.parseInt(status),menutype,power,menuTable);
		List list = menuService.queryMenus("1",menuTable);
		model.addAttribute("smsMenus", list);
		model.addAttribute("tableType",tableName);
		return "ftl/menu/menuManage";
	}
	
	@RequestMapping({ "/modify" })
	public String midifyMenu(HttpServletRequest request, @RequestParam("menuId") int menuId,
			@RequestParam("parentId") int pid, Model model,@RequestParam("tableName")String tableName) {
		String power = "N,N,N,Y";
		String menuTable = "FPF_SYS_MENU_ITEMS";
		if(tableName.equals("jf")){
			menuTable = "FPF_SYS_MENU_ITEM";
		}
		String menuItemTitle = request.getParameter("menuItemTitle");
		System.out.println(menuItemTitle);
		String sortNum = request.getParameter("sortNum");
		if (sortNum == null)
			sortNum = "0";
		if (menuItemTitle == null)
			menuItemTitle = "";
		String pic1 = request.getParameter("iconurl");
		if (pic1 == null)
			pic1 = "";
		String url = request.getParameter("url");
		if (url == null)
			url = "";
		String status = request.getParameter("state");
		if (status == null)
			status = "0";
		String menutype = request.getParameter("menutype");
		if (menutype == null)
			menutype = "0";
		if(tableName.equals("jf")){
			if(menutype.equals("0")){
				menutype="菜单";
			}else if(menutype.equals("1")){
				menutype="配置";
			}else{
				menutype="资源包";
			}
		}
		String poweradd = request.getParameter("poweradd");
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
		power = poweradd+","+powerdel+","+poweredi+","+powersel;
		menuService.updateMenu(menuId, pid,menuItemTitle,Integer.parseInt(sortNum), 
				url, pic1,Integer.parseInt(status),menutype,power,menuTable);
		List list = menuService.queryMenus("1",menuTable);
		model.addAttribute("smsMenus", list);
		model.addAttribute("tableType",tableName);
		return "ftl/menu/menuManage";
	}
}
