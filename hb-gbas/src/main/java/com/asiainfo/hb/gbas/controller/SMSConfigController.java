package com.asiainfo.hb.gbas.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.core.util.LogUtil;
import com.asiainfo.hb.gbas.model.SMSConfigDao;

/**
 * 短信告警配置
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/smsConfig")
public class SMSConfigController {
	
	private Logger mLog = LoggerFactory.getLogger(SMSConfigController.class);
	
	@Autowired
	private SMSConfigDao mConfigDao;
	
	/**
	 * 告警人配置页面入口
	 * @return
	 */
	@RequestMapping("/user/index")
	public String userIndex(){
		mLog.debug("---userIndex---");
		return "ftl/smsConfig/user";
	}
	
	/**
	 * 告警群组页面入口
	 * @return
	 */
	@RequestMapping("/group/index")
	public String groupIndex(){
		mLog.debug("---groupIndex---");
		return "ftl/smsConfig/group";
	}
	
	@RequestMapping("/getAlarmUserList")
	@ResponseBody
	public Map<String, Object> getAlarmUserList(HttpServletRequest req){
		try {
			String name = req.getParameter("userName");
			String num = req.getParameter("num");
			return mConfigDao.getAlarmUserList(name, num, req);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
		}
		return new HashMap<String, Object>();
	}
	
	/**
	 * 保存告警人
	 * @param req
	 */
	@RequestMapping("/saveAlarmUser")
	@ResponseBody
	public Object saveAlarmUser(HttpServletRequest req){
		String id = req.getParameter("alarmId");
		String name = req.getParameter("userName");
		String accNbr = req.getParameter("accNbr");
		String remark = req.getParameter("userRemark");
		mLog.info("--->saveAlarmUser,id:{}; name:{}; accNbr:{}; remark:{}", new Object[]{id, name, accNbr, remark});
		JSONObject res = new JSONObject();
		try {
			if(StringUtils.isEmpty(id)){
				mConfigDao.addUser(name, accNbr, remark);
				return res;
			}
			mConfigDao.updateUser(id, name, accNbr, remark);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
			if(null != e.getCause()){
				res.put("msg", e.getCause().getMessage());
			}else{
				res.put("msg", e.toString());
			}
			res.put("flag", "-1");
		}
		return res;
	}
	
	/**
	 * 删除告警人
	 * @param req
	 */
	@RequestMapping("/delAlarmUser")
	@ResponseBody
	public Object delAlarmUser(HttpServletRequest req){
		String ids = req.getParameter("alarmsIds");
		mLog.info("---delAlarmUser---,ids:{}", ids);
		JSONObject res = new JSONObject();
		try {
			mConfigDao.delUser(ids);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
			if(null != e.getCause()){
				res.put("msg", e.getCause().getMessage());
			}else{
				res.put("msg", e.toString());
			}
			res.put("flag", "-1");
		}
		return res;
	}

	/**
	 * 查询所有告警群组
	 * @param req
	 * @return
	 */
	@RequestMapping("/getAlarmGroup")
	@ResponseBody
	public List<Map<String, Object>> getAlarmGroup(HttpServletRequest req){
		String groupId = req.getParameter("groupId");
		String groupName = req.getParameter("groupName");
		String userName = req.getParameter("userName");
		String num = req.getParameter("num");
		try {
			return mConfigDao.getAlarmGroup(groupId, groupName, userName, num);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
		}
		return new ArrayList<Map<String, Object>>();
	}
	
	/**
	 * 获取指定群组中的所有告警人
	 * @param req
	 * @return
	 */
	@RequestMapping("/getUserByGroupId")
	@ResponseBody
	public List<Map<String, Object>> getUserByGroupId(HttpServletRequest req){
		String groupId = req.getParameter("groupId");
		mLog.debug("groupId:{}", groupId);
		try {
			return mConfigDao.getUserByGroupId(groupId);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
		}
		return new ArrayList<Map<String, Object>>();
	}
	
	/**
	 * 保存告警群组
	 * @param req
	 */
	@RequestMapping("/saveAlarmGroup")
	@ResponseBody
	public Object saveAlarmGroup(HttpServletRequest req){
		String operType = req.getParameter("operType");
		String groupId = req.getParameter("groupId");
		String groupName = req.getParameter("groupName");
		String groupType = req.getParameter("groupType");
		mLog.info("---saveAlarmGroup---,operType:{}; groupId:{}; groupName:{}; groupType:{}", new Object[]{operType, groupId, groupName, groupType});
		JSONObject res = new JSONObject();
		try {
			if(operType.equals("edit")){
				mConfigDao.updateAlarmGroup(groupId, groupName, groupType);
				return res;
			}
			String userIds = req.getParameter("userIds");
			mConfigDao.addAlarmGroup(groupId, groupName, groupType, userIds);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
			if(null != e.getCause()){
				res.put("msg", e.getCause().getMessage());
			}else{
				res.put("msg", e.toString());
			}
			res.put("flag", "-1");
		}
		return res;
	}
	
	/**
	 * 检验groupId是否已存在
	 * @param req
	 * @return
	 */
	@RequestMapping("/checkGroupId")
	@ResponseBody
	public boolean checkGroupId(HttpServletRequest req){
		String groupId = req.getParameter("groupId");
		mLog.debug("---checkGroupId---, groupId:{}", groupId);
		return mConfigDao.checkGroupId(groupId);
	}
	
	/**
	 * 删除告警群组
	 * @param req
	 */
	@RequestMapping("/delAlarmGroup")
	@ResponseBody
	public Object delAlarmGroup(HttpServletRequest req){
		String groupId = req.getParameter("groupId");
		JSONObject res = new JSONObject();
		try {
			mConfigDao.delAlartGroup(groupId);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
			if(null != e.getCause()){
				res.put("msg", e.getCause().getMessage());
			}else{
				res.put("msg", e.toString());
			}
			res.put("flag", "-1");
		}
		return res;
	}
	
	/**
	 * 查询不在指定群组中告警人
	 * @param req
	 * @return
	 */
	@RequestMapping("/getNotInUserList")
	@ResponseBody
	public List<Map<String, Object>> getNotInUserList(HttpServletRequest req){
		String groupId = req.getParameter("groupId");
		String userName = req.getParameter("userName");
		String num = req.getParameter("num");
		try {
			return mConfigDao.getNotInUserList(userName, num, groupId);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
		}
		return new ArrayList<Map<String, Object>>();
	}
	
	/**
	 * 删除群组中部分告警人
	 * @param req
	 */
	@RequestMapping("/delGroupUser")
	@ResponseBody
	public Object delGroupUser(HttpServletRequest req){
		String groupId = req.getParameter("groupId");
		String nums = req.getParameter("nums");
		String[] numArr = nums.split(",");
		String accNbrs = "";
		for(String num: numArr){
			if(!StringUtils.isEmpty(accNbrs)){
				accNbrs += ",";
			}
			accNbrs += "'" + num + "'";
		}
		
		JSONObject res = new JSONObject();
		try {
			mConfigDao.delGroupUser(groupId, accNbrs);
		} catch (Exception e) {
			mLog.error(LogUtil.getExceptionMessage(e));
			if(null != e.getCause()){
				res.put("msg", e.getCause().getMessage());
			}else{
				res.put("msg", e.toString());
			}
			res.put("flag", "-1");
		}
		return res;
	}
	
}
