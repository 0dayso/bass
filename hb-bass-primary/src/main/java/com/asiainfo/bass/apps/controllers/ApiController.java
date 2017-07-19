package com.asiainfo.bass.apps.controllers;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.asiainfo.bass.apps.models.Issue;
import com.asiainfo.bass.apps.models.IssueDao;

@Controller
@RequestMapping(value = "/api")
public class ApiController {

	@Autowired
	private IssueDao issueDao;
	
	private static Logger LOG = Logger.getLogger(ApiController.class);
	
	/**
	 * 问题申告回复内容回传
	 * @param req
	 * @return
	 */
	@RequestMapping(value = "/issue/reply")
	@ResponseBody
	public Object issueReply(HttpServletRequest req){
		String issueId = req.getParameter("issueId");
		String reply = req.getParameter("content");
		String bomcId = req.getParameter("bomcId");
		LOG.info("BOMC问题申告结果回传：issue=" + issueId + ";content=" + reply + ";bomcId=" + bomcId);
		List<Issue> list = issueDao.getIssueById(issueId);
		LOG.info("查询结果条数：" + list != null ? list.size(): 0);
		JSONObject obj = new JSONObject();
		if(list != null && list.size()>0){
			Issue issue = list.get(0);
			String info = issue.getContent();
			String title = "";
			int index = (info.substring(1, info.length())).indexOf("#");
			if(index>0){
				String[] contents = info.split("#");
				title = contents[1];
			}
			String rep = "#回复：" + title + "#" + reply;
			
			Map<String, Object> typeInfo = issueDao.getTypeInfo(issue.getType());
			String userId = (String) typeInfo.get("userid");
			String userName = (String) typeInfo.get("username");
			
			issueDao.saveReply(issueId, rep, bomcId, userId, userName, issue.getType());
			obj.put("code", "1");
			obj.put("msg", "成功");
		}else{
			obj.put("code", "0");
			obj.put("msg", "根据单号：" + issueId + "，未找到对应申告信息");
		}
		
		return obj;
	}
	
	@RequestMapping(value = "/issue/principalChange")
	@ResponseBody
	public Object principalChange(HttpServletRequest req){
		String issueId = req.getParameter("issueId");
		String principal = req.getParameter("principal");
		String phone = req.getParameter("phone");
		String type = req.getParameter("type");
		LOG.info("BOMC修改责任人：issueId=" +issueId + "；principal=" + principal + "；type=" + type + "；phone=" + phone);
		JSONObject obj = new JSONObject();
		if(StringUtils.isEmpty(issueId) || StringUtils.isEmpty(principal) || StringUtils.isEmpty(type)){
			obj.put("code", "0");
			obj.put("msg", "请求参数不完整");
			return obj;
		}
		
		List<Issue> list = issueDao.getIssueById(issueId);
		LOG.info("查询结果条数：" + list != null ? list.size(): 0);
		if(list == null || list.size()==0){
			obj.put("code", "0");
			obj.put("msg", "根据单号：" + issueId + "，未找到对应申告信息");
			return obj;
		}
		
		issueDao.changePrincipal(issueId, type, principal);
		obj.put("code", "1");
		obj.put("msg", "success");
		return obj;
	}
	
}
