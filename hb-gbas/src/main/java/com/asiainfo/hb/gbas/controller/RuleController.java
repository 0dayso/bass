package com.asiainfo.hb.gbas.controller;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import com.asiainfo.hb.gbas.model.RuleDao;
import com.asiainfo.hb.gbas.model.RuleDef;

/**
 * 规则管理
 * @author xiaoh
 *
 */
@Controller
@RequestMapping("/rule")
public class RuleController {
	
	private Logger mLog = LoggerFactory.getLogger(RuleController.class);

	@Autowired
	private RuleDao mRuleDao;
	
	@RequestMapping("/index")
	public String index(HttpSession session, Model model){
		String userId = (String) session.getAttribute("loginname");
		model.addAttribute("userId", userId);
		return "ftl/rule";
	}
	
	@RequestMapping("/getRuleList")
	@ResponseBody
	public Map<String, Object> getRuleList(HttpServletRequest req){
		
		String ruleType = req.getParameter("ruleType");
		String ruleCycle = req.getParameter("ruleCycle");
		String status = req.getParameter("status");
		String ruleName = req.getParameter("ruleName");
		String ruleCode = req.getParameter("ruleCode");
		
		RuleDef ruleDef = new RuleDef();
		ruleDef.setRuleType(ruleType);
		ruleDef.setCycle(ruleCycle);
		ruleDef.setStatus(status);
		ruleDef.setRuleName(ruleName);
		ruleDef.setRuleCode(ruleCode);
		
		String page = req.getParameter("page");
		String rows = req.getParameter("rows");
		int perPage = 10;
		int currentPage = 1;
		if(!StringUtils.isEmpty(page)){
			currentPage = Integer.valueOf(page);
		}
		if(StringUtils.isEmpty(rows)){
			perPage = Integer.valueOf(rows);
		}
		
		mLog.debug("参数：page=" + page + ", rows=" + rows + ",ruleType=" + ruleType + ",ruleCycle=" +
					ruleCycle + ",status=" + status + ",ruleName=" + ruleName + ",ruleCode=" + ruleCode);
		
		return mRuleDao.getRuleList(ruleDef, perPage, currentPage);
	}
	
	
	@RequestMapping("/saveRuleDef")
	@ResponseBody
	public void saveRuleDef(RuleDef ruleDef, HttpSession session){
		if(!StringUtils.isEmpty(ruleDef.getRuleCode())){
			mRuleDao.updateRule(ruleDef);
			return;
		}
		
		String userId = (String) session.getAttribute("loginname");
		ruleDef.setCreater(userId);
		//生成rulecode
		StringBuffer strBuf = new StringBuffer();
		if(ruleDef.getCycle().equals("daily")){
			strBuf.append("D");
		}else{
			strBuf.append("M");
		}
		strBuf.append(ruleDef.getBoiCode());
		strBuf.append("R");
		strBuf.append(mRuleDao.getNextNum());
		mLog.info("生成规则编码：" + strBuf.toString());
		
		ruleDef.setRuleCode(strBuf.toString());	
		
		mRuleDao.saveRuleDef(ruleDef);
	}

	@RequestMapping("/deleteRuleDef")
	@ResponseBody
	public void deleteRuleDef(HttpServletRequest req){
		String ruleCode = req.getParameter("ruleCode");
		mRuleDao.deleteRule(ruleCode);
	}
	
}
