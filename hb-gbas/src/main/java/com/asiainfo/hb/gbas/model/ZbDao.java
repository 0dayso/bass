package com.asiainfo.hb.gbas.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

@Repository
public class ZbDao extends CommonDao{
	
	private Logger mLog = LoggerFactory.getLogger(ZbDao.class);

	public boolean saveZbDef(ZbDef zbDef){
		mLog.debug("------>saveZbDef," + zbDef);
		if(!checkZbCode(zbDef.getZbCode())){
			return false;
		}
		
		String sql = "insert into gbas.zb_def (zb_code, zb_name,status, creater, creater_name, developer, developer_name) values(?,?,?,?,?,?,?)";
		
		this.dwJdbcTemplate.update(sql, new Object[]{zbDef.getZbCode(), zbDef.getZbName(), zbDef.getStatus(), zbDef.getCreater(), zbDef.getCreaterName(),
				zbDef.getDeveloper(), zbDef.getDeveloperName()});
		return true;
	}
	
	public void updateDevelop(ZbDef zbDef){
		mLog.debug("------>updateDevelop");
		String sql = "update gbas.zb_def set zb_name=?, developer=?, developer_name=? where zb_code=?";
		this.dwJdbcTemplate.update(sql, new Object[]{zbDef.getZbName(), zbDef.getDeveloper(), zbDef.getDeveloperName(), zbDef.getZbCode()});
	}
	
	public void updateStatus(String zbCode, String status){
		mLog.debug("------>updateStatus");
		String sql = "update gbas.zb_def set status=? where zb_code=?";
		this.dwJdbcTemplate.update(sql, new Object[]{status, zbCode});
	}
	
	public void updateZb(ZbDef zbDef){
		mLog.debug("------>updateZb," + zbDef);
		String sql = "update gbas.zb_def set zb_name=?,cycle=?,boi_code=?, zb_def=?,zb_type=?,rule_type=?,rule_def=?,comp_oper=?,comp_val=? ," +
				" depend_type=?,proc_depend=?, gbas_depend=?,online_date='" + zbDef.getOnlineDate() + "'" +
				",offline_date='" + zbDef.getOfflineDate() + "',remark=?,developer=?,manager=?,developer_name=?, manager_name=?," +
				" priority=?,expect_end_day=? ,expect_end_time=? where zb_code=?";
		if("".equals(zbDef.getPriority())){
			zbDef.setPriority("99");
		}
		if("".equals(zbDef.getExpectEndDay())){
			zbDef.setExpectEndDay(null);
		}
		if("".equals(zbDef.getExpectEndTime())){
			zbDef.setExpectEndTime(null);
		}
		
		this.dwJdbcTemplate.update(sql, new Object[]{zbDef.getZbName(), zbDef.getCycle(), zbDef.getBoiCode(), zbDef.getZbDef(), zbDef.getZbType(), zbDef.getRuleType(),
				zbDef.getRuleDef(),zbDef.getCompOper(),zbDef.getCompVal(),zbDef.getDependType(),zbDef.getProcDepend(),zbDef.getGbasDepend(),
				zbDef.getRemark(), zbDef.getDeveloper(), zbDef.getManager(),zbDef.getDeveloperName(), zbDef.getManagerName(),
				zbDef.getPriority(),zbDef.getExpectEndDay(), zbDef.getExpectEndTime(), zbDef.getZbCode()});
		insertRelation(zbDef.getZbCode(), zbDef.getProcDepend());
	}
	
	private void insertRelation(String zbCode, String gbasDepend){
		mLog.debug("------>insertRelation");
		String[] codeArr = gbasDepend.split(";");
		String delSql = "delete from gbas.proc_deps where proc=?";
		List<String> sqlList = new ArrayList<String>();
		for(String gbasCode: codeArr){
			if(isNotNull(gbasCode)){
				sqlList.add("insert into gbas.proc_deps (proc, proc_dep) values('" + zbCode + "','" + gbasCode +"')");
			}
		}
		this.dwJdbcTemplate.update(delSql, new Object[]{zbCode});
		if(sqlList.size() != 0){
			this.dwJdbcTemplate.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
		}
		
	}
	
	public Map<String, Object> getZbList(ZbDef zbDef, HttpServletRequest req){
		mLog.debug("-----getZbList-----");
		String pageSql = "select * from gbas.zb_def where 1=1 ";
		String countSql = "select count(1) from gbas.zb_def where 1=1 ";
		
		Map<String , Object> condition = new HashMap<String , Object>();
		condition.put("zb_type", zbDef.getZbType());
		condition.put("cycle", zbDef.getCycle());
		condition.put("status", zbDef.getStatus());
		condition.put("zb_name like", zbDef.getZbName());
		condition.put("zb_code like", zbDef.getZbCode());
		condition.put("developer_name like", zbDef.getDeveloperName());
		
		int[] pageParam = this.pageParam(req);
		
		return queryPage(dwJdbcTemplate, condition, pageSql, countSql, pageParam[0], pageParam[1], " zb_code");
	}
	
	public boolean checkZbCode(String zbCode){
		mLog.debug("------>checkZbCode");
		String sql = "select * from gbas.zb_def where zb_code=?";
		List<Map<String, Object>> list = this.dwJdbcTemplate.queryForList(sql, new Object[]{zbCode});
		if(list != null && list.size() > 0){
			return false;
		}
		return true;
	}
	
}
