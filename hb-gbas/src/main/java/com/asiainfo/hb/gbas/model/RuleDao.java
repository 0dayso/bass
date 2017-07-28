package com.asiainfo.hb.gbas.model;

import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import com.asiainfo.hb.web.models.CommonDao;

@Repository
public class RuleDao extends CommonDao{
	
	private Logger mLog = LoggerFactory.getLogger(RuleDao.class);

	public void saveRuleDef(RuleDef ruleDef){
		mLog.debug("-----saveRuleDef-----" + ruleDef);
		
		String sql = "insert into gbas.rule_def (rule_code, rule_name,boi_code, rule_type, rule_def, proc_depend,gbas_depend, status, cycle, online_date," +
				" offline_date, remark, creater, developer, manager, priority,expect_end_day, expect_end_time,comp_oper,val) values(" +
				" ?,?,?,?,?,?,?,?,?,'" + ruleDef.getOnlineDate() + "','" + ruleDef.getOfflineDate() +"',?,?,?,?,?,?,?,?,?)";
		
		this.jdbcTemplate.update(sql, new Object[]{ruleDef.getRuleCode(), ruleDef.getRuleName(), ruleDef.getBoiCode(), ruleDef.getRuleType(),
				ruleDef.getRuleDef(), ruleDef.getProcDepend(), ruleDef.getGbasDepend(), ruleDef.getStatus(), ruleDef.getCycle(), ruleDef.getRemark(), ruleDef.getCreater(),
				ruleDef.getDeveloper(), ruleDef.getManager(), ruleDef.getPriority(), ruleDef.getExpectEndDay(), ruleDef.getExpectEndTime(),
				ruleDef.getCompOper(), ruleDef.getVal()});
	}
	
	public void updateRule(RuleDef ruleDef){
		mLog.debug("-----updateRule-----" + ruleDef);
		String sql = "update gbas.rule_def set rule_name=?, rule_def=?,rule_type=?,proc_depend=?,gbas_depend=?,status=?,online_date='" + ruleDef.getOnlineDate() + "'" +
				",offline_date='" + ruleDef.getOfflineDate() + "',remark=?,developer=?,manager=?,priority=?,expect_end_day=?" +
				",expect_end_time=?,comp_oper=?,val=? where rule_code=?";
		
		this.jdbcTemplate.update(sql, new Object[]{ruleDef.getRuleName(), ruleDef.getRuleDef(), ruleDef.getRuleType(), ruleDef.getProcDepend(),
				ruleDef.getGbasDepend(), ruleDef.getStatus(), ruleDef.getRemark(), ruleDef.getDeveloper(), ruleDef.getManager(), ruleDef.getPriority(),
				ruleDef.getExpectEndDay(), ruleDef.getExpectEndTime(),ruleDef.getCompOper(), ruleDef.getVal(), ruleDef.getRuleCode()});
	}
	
	public void deleteRule(String ruleCode){
		mLog.debug("-----deleteRule-----ruleCode:" + ruleCode);
		String sql = "delete from gbas.rule_def where rule_code=?";
		this.jdbcTemplate.update(sql, new Object[]{ruleCode});
	}
	
	public String getNextNum(){
		mLog.debug("-----getNextNum-----");
		String sql = "select max(substr(rule_code ,8,11)) num from gbas.rule_def";
		Map<String, Object> map = this.jdbcTemplate.queryForMap(sql);
		int i = 0;
		if(map != null && map.get("num") != null){
			String nums = (String) map.get("num");
			i = Integer.valueOf(nums.trim());
		}
		return String.format("%04d", ++i);
	}	
	
	public Map<String, Object> getRuleList(RuleDef ruleDef, int rows, int page){
		mLog.debug("-----getRuleList-----");
		String pageSql = "select * from gbas.rule_def where 1=1 ";
		String countSql = "select count(1) from gbas.rule_def where 1=1 ";
		
		Map<String , Object> condition = new HashMap<String , Object>();
		condition.put("rule_type", ruleDef.getRuleType());
		condition.put("cycle", ruleDef.getCycle());
		condition.put("status", ruleDef.getStatus());
		condition.put("rule_name like", ruleDef.getRuleName());
		condition.put("rule_code like", ruleDef.getRuleCode());
		
		return where(condition, pageSql, countSql, rows, page, " rule_code");
	}
	
}
