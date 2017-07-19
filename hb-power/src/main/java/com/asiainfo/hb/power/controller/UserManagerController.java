package com.asiainfo.hb.power.controller;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.core.util.Encryption;
import com.asiainfo.hb.power.models.PageQueryParam;
import com.asiainfo.hb.power.service.MenuRightService;
import com.asiainfo.hb.power.service.UserGroupMapService;
import com.asiainfo.hb.power.service.UserMangerService;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;



@Controller
@RequestMapping("/userManager")
@SessionAttributes({ SessionKeyConstants.USER })
@SuppressWarnings("unused")
public class UserManagerController extends BaseDao{
	
	public Logger logger = LoggerFactory.getLogger(UserManagerController.class);
	
	@Autowired
	UserMangerService userService;
	
	@Autowired
	UserGroupMapService ugmService;
	
	@Autowired
	private MenuRightService m_MenuRightService;
	
	protected String menuid =null;
	//删除
	@RequestMapping("/deleteUser")
	public String deleteUser(@RequestParam("userid") String userid){
		logger.info("deleteUser------------>");
		userService.delete(userid);
		return "redirect:userManage";
	}
	
	//批量删除
	@RequestMapping("/batchDeletes")
    @ResponseBody
    public void batchDeletes(HttpServletRequest request,HttpServletResponse response){
		logger.info("batchDeletes------------>");
        String items = request.getParameter("delitems");
        List<String> delList = new ArrayList<String>();
        String[] strs = items.split(",");
        String userids = "";
        for (String str : strs) {
        	userids+="'"+str+"',";
        }
        userService.batchDeletes(userids);
    }
	
	
	
	//保存修改
	@RequestMapping("/save")
	public String update(HttpServletRequest req) throws ParseException{
		 logger.info("save------------>");
		 String userid = req.getParameter("d_userid");
		 String username = req.getParameter("d_username");
		 String cityid =  req.getParameter("d_cityid");
		 String status_ = req.getParameter("d_status");
		 int status = Integer.parseInt(status_);
		 String mobilephone = req.getParameter("d_mobilephone");
		 String email = req.getParameter("d_email");
		 String str = req.getParameter("d_createtime");
		 /*
		 SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		 String createtime = sdf.parse(str).toLocaleString();
		 */
	     userService.update(userid.trim(),username.trim(),cityid,status,mobilephone.trim(),email.trim());
		 return "redirect:userManage";
	}
	
	
	//增加
	@RequestMapping("/addUser")
	public String add(HttpServletRequest req) throws ParseException{
		 logger.info("add------------>");
		 String userid = req.getParameter("c_userid");
		 String cityid =  req.getParameter("c_cityid");
		 Map<String,Object> map = userService.getAreaNameByAid(cityid);
		 String visitArea = map.get("areaname")==null?"":map.get("areaname").toString();
		 String username = req.getParameter("c_username");
		 String pwd = Encryption.encrypt("111");
		 String status_ = req.getParameter("c_status");
		 int status = Integer.parseInt(status_);
		 String mobilephone =   req.getParameter("c_mobilephone");
		 String email = req.getParameter("c_email");
		 Date createtime = new Date();
	     userService.add(userid.trim(),cityid,username.trim(),pwd,status,mobilephone.trim(),email.trim(),createtime,visitArea);
	     return "redirect:userManage";
	}
	
	
	//全查询
	@RequestMapping("/userManage")
	public String pageQueryByName(PageQueryParam param,ModelMap model,HttpServletRequest req,@ModelAttribute(SessionKeyConstants.USER) User user) {
		 logger.info("pageQueryByName------------>");
		 String menuitemid = req.getParameter("menuid");
			String suserid = user.getId();
			if(menuitemid!=null){
				menuid = menuitemid;
			}
		Map<String,String> searchMap = new HashMap<String, String>();
		String userid = req.getParameter("userid")==null?param.getUserid():req.getParameter("userid");
		String username = req.getParameter("username")==null?param.getUsername():req.getParameter("username");
		String cityid = req.getParameter("cityid")==null?param.getCityid():req.getParameter("cityid");
		searchMap.put("userid", userid);
		searchMap.put("username", username);
		searchMap.put("cityid", cityid);
		param.setUserid(userid);
		param.setUsername(username);
		param.setCityid(cityid);
		int totalCount = userService.getUserCount(userid,username,cityid);
		int pageCount;
		String groupName = user.getGroupName();
		int isadmin = user.getSperAdmin();
		String allRightFlag = "NO";
		if((isadmin==1)||groupName.equals("云化经分开发人员")||groupName.equals("湖北移动业支经分用户组")){
			allRightFlag = "YES";
		}
		if (totalCount % param.getPageSize() == 0) {
			pageCount = totalCount / param.getPageSize();
		} else {
			pageCount = totalCount / param.getPageSize() + 1;
		}
		List<Map<String, Object>> list = userService.getUsers(userid,username,cityid,param.getIndexNum(),param.getPageSize());
		List<Map<String,Object>> arealist = userService.getvisitAreaList();
		List<Map<String, Object>> powerlist = m_MenuRightService.getUserMenuPower(menuid,suserid);
		param.setPageCount(pageCount);
		model.addAttribute("arealist", arealist);
		model.addAttribute("param", param);
		model.addAttribute("list", list);
		model.addAttribute("parameterMap",searchMap);
		model.addAttribute("powerList", powerlist);
		model.addAttribute("power", JsonHelper.getInstance().write(powerlist));
		model.addAttribute("allRightFlag", allRightFlag);
		return "ftl/user/userManager";
	}
	
	
	@RequestMapping("/updateVisit")
	@ResponseBody
	public Map<String,Object> updateVisit(HttpServletRequest request,Model model){
		logger.info("updateVisit------------>");
		Map<String,Object> result = new HashMap<String,Object>();
		String areas = request.getParameter("areas");
		String uID = request.getParameter("uID");
		logger.info("areas : "+areas+" , "+" uID "+uID);
		boolean flag = userService.updateVisitArea(areas, uID);
		result.put("flag", flag);
		return result;
	}
	
	@RequestMapping("/checkUser")
	@ResponseBody
	public Map<String,Object> checkUser(HttpServletRequest request,Model model){
		logger.info("checkUser------------>");
		Map<String,Object> result = new HashMap<String,Object>();
		boolean flag = false;
		String userid=request.getParameter("c_userid");
		List<Map<String,Object>> list = userService.getUserByUid(userid);
		if(list.size()>0){
			flag = true;
		}
		result.put("flag", flag);
		return result;
	}
	
	
	@RequestMapping("/updateUserGroup")
	@ResponseBody
	public Map<String,Object> updateUserGroupMap(HttpServletRequest request,Model model){
		logger.info("updateUserGroup------------>");
		Map<String,Object> result = new HashMap<String,Object>();
		boolean flag = false;
		try {
			String oldGroupId = request.getParameter("oldGroupId");
			String newGroupId = request.getParameter("newGroupId");
			String userId = request.getParameter("userid");
			flag = ugmService.updateUserGroupMap(oldGroupId, newGroupId, userId);
		} catch (Exception e) {
			
			e.printStackTrace();
		}
		result.put("flag", flag);
		return result;
	}
	
	/**
	 * 查询已关联用户组
	 * @param req
	 * @return
	 */
	@RequestMapping("/getConnectUserGroup")
	@ResponseBody
	public List<Map<String, Object>> getConnectUserGroup(HttpServletRequest req){
		String userId = req.getParameter("userId");
		String groupName = req.getParameter("groupName");
		logger.info("getConnectUserGroup, user:" + userId + ", groupName:" + groupName);
		List<Map<String, Object>> list = ugmService.getConnectUserGroup(userId, groupName);
		logger.info("getConnectUserGroup result size:" + list.size());
		return list;
	}
	
	/**
	 * 查询未关联用户组
	 * @param req
	 * @return
	 */
	@RequestMapping("/getUnconnectUserGroup")
	@ResponseBody
	public List<Map<String, Object>> getUnconnectUserGroup(HttpServletRequest req){
		String userId = req.getParameter("userId");
		String groupName = req.getParameter("groupName");
		logger.info("getUnconnectUserGroup, user:" + userId + ", groupName:" + groupName);
		List<Map<String, Object>> list = ugmService.getUnconnectUserGroup(userId, groupName);
		logger.info("getUnconnectUserGroup result size:" + list.size());
		return list;
	}
	
	/**
	 * 删除用户组关联
	 * @param req
	 * @return
	 */
	@RequestMapping("/delUserGroup")
	@ResponseBody
	public boolean delUserGroup(HttpServletRequest req){
		String userId = req.getParameter("userId");
		String groups = req.getParameter("groups");
		String[] groupList = groups.split(",");
		String groupIds = "";
		for(String groupId : groupList){
			if(!StringUtils.isEmpty(groupIds)){
				groupIds += ",";
			}
			groupIds += "'" + groupId + "'";
		}
		logger.info("delUserGroup, userId:" + userId + ", groupIds:" + groupIds);
		ugmService.delUserGroup(userId, groupIds);
		return true;
	}
	
	/**
	 * 关联用户组
	 * @param req
	 * @return
	 */
	@RequestMapping("/addUserGroup")
	@ResponseBody
	public boolean addUserGroup(HttpServletRequest req){
		String userId = req.getParameter("userId");
		String groups = req.getParameter("groups");
		String[] groupIds = groups.split(",");
		for(String groupId : groupIds){
			ugmService.addUserGroupMap(userId, groupId);
		}
		return true;
	}
}
