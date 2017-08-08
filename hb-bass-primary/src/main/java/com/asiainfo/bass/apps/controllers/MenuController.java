package com.asiainfo.bass.apps.controllers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.bass.apps.models.Encryption;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.bass.components.models.JdbcTemplate;

/**
 * 
 * @author Mei Kefu
 * @date 2009-11-11
 */
@Controller
@RequestMapping(value = "/menu")
@SessionAttributes({SessionKeyConstants.USER})
public class MenuController {
	private static Logger LOG = Logger.getLogger(MenuController.class);
	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "{menuId}")
	public String redriect(@ModelAttribute("mvcPath") String mvcPath, @ModelAttribute("user") User user, @PathVariable String menuId, Model model) {
		Map<String, Object> map = jdbcTemplate.queryForMap("select value(url,'') src,kind,menuitemtitle title from sys_menu_item where menuitemid=?", new Object[] { Long.valueOf(menuId) });
		String url = (String) map.get("src");
		String kind = (String) map.get("kind");
		String prefix = "redirect:";
		if ("配置".equalsIgnoreCase(kind)) {
			int sid = jdbcTemplate.queryForObject("select sid from FPF_irs_subject_menu_map where mid=?", new Object[] { Integer.parseInt(menuId) },Integer.class);
			url = mvcPath + "/report/" + sid;
		} else if ("资源包".equalsIgnoreCase(kind)) {
			url = mvcPath + "/rptNavi/" + menuId;
		} else if ("菜单".equalsIgnoreCase(kind) && url.length() == 0) {
			model.addAttribute("url", mvcPath + "/menu/tree/" + menuId);
			model.addAttribute("title", map.get("title"));
			url = mvcPath + "/views/ftl/frame/container";
			prefix = "forward:";
		} 
		else if("菜单".equalsIgnoreCase(kind) && url.length() > 0){
			if(url.indexOf("http://10.25.124.101:8080")>-1){
				//流量终端分布
				if(url.indexOf("http://10.25.124.101:8080?llzd")>-1){
					url = "http://10.25.124.101:8080/MicroStrategy/servlet/mstrWeb?Server=HP101&Project=HuBeiMobile&port=0&evt=2048001&src=mstrWeb.2048001&visMode=0&documentID=323FB227495A2894F165608ACADE5281&currentViewMedia=8&hiddensections=header,path,dockTop,dockLeft,footer";
				}
				//地市流量网络分布 
				else if(url.indexOf("http://10.25.124.101:8080?dsll")>-1){
					url = "http://10.25.124.101:8080/MicroStrategy/servlet/mstrWeb?Server=HP101&Project=HuBeiMobile&port=0&evt=2048001&src=mstrWeb.2048001&visMode=0&documentID=785B8EAE4246FED186B6029C03EAC72E&currentViewMedia=8&hiddensections=header,path,dockTop,dockLeft,footer";
				}
				//县域流量网络分布 
				else if(url.indexOf("http://10.25.124.101:8080?xyll")>-1){
					url = "http://10.25.124.101:8080/MicroStrategy/servlet/mstrWeb?Server=HP101&Project=HuBeiMobile&port=0&evt=2048001&src=mstrWeb.2048001&visMode=0&documentID=BE12E6DC4AC60A1B8B2A53ADB224AC2F&currentViewMedia=8&hiddensections=header,path,dockTop,dockLeft,footer";
				}
				//流量资费分布_订购GPRS可选套餐 
				else if(url.indexOf("http://10.25.124.101:8080?gprs")>-1){
					url = "http://10.25.124.101:8080/MicroStrategy/servlet/mstrWeb?Server=HP101&Project=HuBeiMobile&port=0&evt=2048001&src=mstrWeb.2048001&visMode=0&documentID=4850716A4846D29C647A41BF8402AAE8&currentViewMedia=8&hiddensections=header,path,dockTop,dockLeft,footer";
				}
				//流量资费分布_订购全球通88可选套餐 
				else if(url.indexOf("http://10.25.124.101:8080?qqt88")>-1){
					url = "http://10.25.124.101:8080/MicroStrategy/servlet/mstrWeb?Server=HP101&Project=HuBeiMobile&port=0&evt=2048001&src=mstrWeb.2048001&visMode=0&documentID=0BE926FD45E22A5F464BF7A871770B9F&currentViewMedia=8&hiddensections=header,path,dockTop,dockLeft,footer";
				}
				//流量资费分布_无套餐 
				else if(url.indexOf("http://10.25.124.101:8080?wtc")>-1){
					url = "http://10.25.124.101:8080/MicroStrategy/servlet/mstrWeb?Server=HP101&Project=HuBeiMobile&port=0&evt=2048001&src=mstrWeb.2048001&visMode=0&documentID=2A4560A8487CD6739A0968936BCDC565&currentViewMedia=8&hiddensections=header,path,dockTop,dockLeft,footer";
				}
				//流量客户分布 
				else if(url.indexOf("http://10.25.124.101:8080?llkh")>-1){
					url = "http://10.25.124.101:8080/MicroStrategy/servlet/mstrWeb?Server=HP101&Project=HuBeiMobile&port=0&evt=2048001&src=mstrWeb.2048001&visMode=0&documentID=F12CF51340049F8A8485B09CD42DDF5C&currentViewMedia=8&hiddensections=header,path,dockTop,dockLeft,footer";
				}
				//流量业务分布 
				else if(url.indexOf("http://10.25.124.101:8080?llyw")>-1){
					url = "http://10.25.124.101:8080/MicroStrategy/servlet/mstrWeb?Server=HP101&Project=HuBeiMobile&port=0&evt=2048001&src=mstrWeb.2048001&visMode=0&documentID=5584838340FDD43FBF0A0089EE05F128&currentViewMedia=8&hiddensections=header,path,dockTop,dockLeft,footer";
				}
				String token = Encryption.getRandomMsgId();
				url = url + "&szToken="+token;
				LOG.info("token="+url);
				HashMap map1 = (HashMap)jdbcTemplate.queryForMap("select int(value(max(int(id)),0)) id from sz.mstr_token_info");
				String tokenId = ((Integer)map1.get("id")+1)+"";
				//插入数据表
				jdbcTemplate.update("insert into sz.mstr_token_info(id, token, cityname) values(?,?,?)", new Object[] {tokenId, token, user.getAreaName()});
			}
		}
		return prefix + url;
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "tree/{menuId}")
	// 不写成 {id}/tree是为了不记录日志
	public String nodeTree(WebRequest request, @PathVariable String menuId, @RequestParam String title, Model model) {
		model.addAttribute("id", menuId);
		String sql = "select menuitemtitle from st.FPF_SYS_MENU_ITEMS where menuitemid ="+menuId;
		List list = jdbcTemplate.queryForList(sql);
		Map map = (Map)list.get(0);
		String titlel = (String) map.get("menuitemtitle");
		model.addAttribute("title", titlel);
		return "ftl/frame/thirdMenu";
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "{menuId}/children")
	public @ResponseBody
	List children(@ModelAttribute("mvcPath") String mvcPath, @ModelAttribute("user") User user, @PathVariable String menuId) {
		
		int isAdmin = user.getSperAdmin();
		List<Object> value = new ArrayList<Object>();
		value.add(menuId);
		String sql ="";
		if(isAdmin==1){
			 sql = " select distinct * from FPF_SYS_MENU_ITEMS  where parentid=" + menuId + " and state<>0 order by sortnum with ur";
		}else{
			sql = " select distinct a.* from FPF_SYS_MENU_ITEMS a, "+
					" (select distinct user_id,menu_id from  "+
					" (select a.userid user_id,d.resourceid menu_id from FPF_USER_USER a,FPF_user_group_map b,fpf_group_role_map c ,FPF_sys_menuitem_right d  "+
					" where  a.userid=b.userid and b.group_id = c.group_id and c.role_id = d.operatorid  "+
					" union all select user_id,menu_id from FPF_SYS_MENUITEM_USER )  "+
					" ) b where a.menuitemid = b.menu_id and a.state<>0 and parentid= ? and b.user_id= ?  order by sortnum with ur ";
			String user_id = user.getId();
			value.add(user_id);
			
		}
		List list = new ArrayList();
		try {
			list = jdbcTemplate.queryForList(sql,value.toArray());
		} catch (DataAccessException e) {
			
			e.printStackTrace();
		}
		return list;
	}

	@SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping(value = "topNodes")
	public @ResponseBody
	List topNodes(@ModelAttribute("mvcPath") String mvcPath, @ModelAttribute("user") User user) {
		String user_id = user.getId();
		String sql = "select t1.menuitemid pid,t1.menuitemtitle ptitle  ,t2.menuitemid id,t2.menuitemtitle title ,t2.kind from st.sys_menu_item t1,st.sys_menu_item t2 where t1.menuitemid=t2.menuitemid ";//" select t1.menuitemid pid,t1.menuitemtitle ptitle " + " ,t2.menuitemid id,t2.menuitemtitle title ,t2.kind" + " from sys_menu_item t1,sys_menu_item t2 " + " where t1.parentid =0 and t1.menuitemid in (966,431,3,4,5,6,7,2,749,525,1,1000,98091046)" + " and t2.parentid=t1.menuitemid"
		/*String sql = " select t1.menuitemid pid,t1.menuitemtitle ptitle " + " ,t2.menuitemid id,t2.menuitemtitle title ,t2.kind" + " from sys_menu_item t1,sys_menu_item t2 " + " where t1.parentid =0 and t1.menuitemid in (1000,966,431,6,3,98091224,525,2,1,98091361)" + " and t2.parentid=t1.menuitemid"
				+ " and (t1.accesstoken=0 or t1.menuitemid in (" + " select distinct int(resourceid) from sys_menuitem_right smr," + " (" + " select role_id from user_group_map ugm,GROUP_ROLE_MAP grm where ugm.userid='"
				+ user_id
				+ "' and ugm.group_id=grm.group_id"
				+ " union all"
				+ " select role_id from USER_ROLE_MAP where userid='"
				+ user_id
				+ "') roles"
				+ " where smr.operatorid=role_id"
				+ " ) )"
				+ " and (t2.accesstoken=0 or t2.menuitemid in ("
				+ " select distinct int(resourceid) from sys_menuitem_right smr,"
				+ " ("
				+ " select role_id from user_group_map ugm,GROUP_ROLE_MAP grm where ugm.userid='"
				+ user_id
				+ "' and ugm.group_id=grm.group_id"
				+ " union all"
				+ " select role_id from USER_ROLE_MAP where userid='"
				+ user_id
				+ "') roles"
				+ " where smr.operatorid=role_id"
				+ " ) or t2.menuitemid in (select menu_id from sys_menuitem_user where user_id='" + user_id + "'))"// 增加菜单对用户的关联
				+ " order by t1.sortnum,t2.sortnum with ur"*/;
		LOG.debug("index页面请求topNodes方法时的SQL:" + sql);
		List list = jdbcTemplate.queryForList(sql);
		List result = new ArrayList();
		Map pItem = new HashMap();
		for (int i = 0; i < list.size(); i++) {
			Map child = (Map) list.get(i);
			Integer pid = (Integer) child.get("pid");
			Integer id = (Integer) child.get("id");
			if (!pItem.containsKey(pid)) {
				Map parent = new HashMap();
				pItem.put(pid, parent);
				parent.put("title", child.get("ptitle"));
				parent.put("id", pid);
				parent.put("children", new ArrayList());
				result.add(parent);
			}
			List children = (List) ((Map) pItem.get(pid)).get("children");
			Map newChild = new HashMap();// 不能直接放入，应为child的引用在一级缓存中会缓存，当请求很快的时候这次的操作会影响下次的操作
			newChild.put("id", id);
			newChild.put("title", child.get("title"));
			newChild.put("src", mvcPath + "/menu/" + id);// 全部转向menu/{id}不再这里判断类型
			newChild.put("kind", child.get("kind"));
			children.add(newChild);
		}
		return result;
	}
}
