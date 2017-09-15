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
public class ExDao extends CommonDao{
	
	private Logger mLog = LoggerFactory.getLogger(ExDao.class);
	
	public boolean saveExDef(ExDef exDef){
		mLog.debug("------>saveExDef," + exDef);
		if(!checkExCode(exDef.getExCode())){
			return false;
		}
		
		String sql = "insert into gbas.ex_def (ex_code, ex_name,status, creater, creater_name, developer, developer_name) values(?,?,?,?,?,?,?)";
		
		this.dwJdbcTemplate.update(sql, new Object[]{exDef.getExCode(), exDef.getExName(), exDef.getStatus(), exDef.getCreater(), exDef.getCreaterName(),
				exDef.getDeveloper(), exDef.getDeveloperName()});
		return true;
	}
	
	public void updateDevelop(ExDef exDef){
		mLog.debug("------>updateDevelop");
		String sql = "update gbas.ex_def set ex_name=?, developer=?, developer_name=? where ex_code=?";
		this.dwJdbcTemplate.update(sql, new Object[]{exDef.getExName(), exDef.getDeveloper(), exDef.getDeveloperName(), exDef.getExCode()});
	}
	
	public void updateStatus(String exCode, String status){
		mLog.debug("------>updateStatus");
		String sql = "update gbas.ex_def set status=? where ex_code=?";
		this.dwJdbcTemplate.update(sql, new Object[]{status, exCode});
	}
	
	public void updateEx(ExDef exDef){
		mLog.debug("------>updateEx," + exDef);
		String sql = "update gbas.ex_def set ex_name=?,cycle=?,boi_code=?, ex_id=?," +
				" depend_type=?,proc_depend=?, gbas_depend=?,online_date='" + exDef.getOnlineDate() + "'" +
				",offline_date='" + exDef.getOfflineDate() + "',remark=?,developer=?,manager=?,developer_name=?, manager_name=?," +
				" priority=?,expect_end_day=? ,expect_end_time=? where ex_code=?";
		if("".equals(exDef.getPriority())){
			exDef.setPriority("99");
		}
		if("".equals(exDef.getExpectEndDay())){
			exDef.setExpectEndDay(null);
		}
		if("".equals(exDef.getExpectEndTime())){
			exDef.setExpectEndTime(null);
		}
		
		this.dwJdbcTemplate.update(sql, new Object[]{exDef.getExName(), exDef.getCycle(), exDef.getBoiCode(), exDef.getExId()
				,exDef.getDependType(),exDef.getProcDepend(),exDef.getGbasDepend(),
				exDef.getRemark(), exDef.getDeveloper(), exDef.getManager(),exDef.getDeveloperName(), exDef.getManagerName(),
				exDef.getPriority(),exDef.getExpectEndDay(), exDef.getExpectEndTime(), exDef.getExCode()});
		insertRelation(exDef.getExCode(), exDef.getProcDepend());
	}
	
	private void insertRelation(String exCode, String gbasDepend){
		mLog.debug("------>insertRelation");
		String[] codeArr = gbasDepend.split(";");
		String delSql = "delete from gbas.proc_deps where proc=?";
		List<String> sqlList = new ArrayList<String>();
		for(String gbasCode: codeArr){
			if(isNotNull(gbasCode)){
				sqlList.add("insert into gbas.proc_deps (proc, proc_dep) values('" + exCode + "','" + gbasCode +"')");
			}
		}
		this.dwJdbcTemplate.update(delSql, new Object[]{exCode});
		if(sqlList.size() != 0){
			this.dwJdbcTemplate.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
		}
		
	}
	
	public Map<String, Object> getExList(ExDef exDef, HttpServletRequest req){
		mLog.debug("-----getExList-----");
		String pageSql = "select * from gbas.ex_def where 1=1 ";
		String countSql = "select count(1) from gbas.ex_def where 1=1 ";
		
		Map<String , Object> condition = new HashMap<String , Object>();
		condition.put("cycle", exDef.getCycle());
		condition.put("status", exDef.getStatus());
		condition.put("ex_name like", exDef.getExName());
		condition.put("ex_code like", exDef.getExCode());
		condition.put("developer_name like", exDef.getDeveloperName());
		
		int[] pageParam = this.pageParam(req);
		
		return queryPage(dwJdbcTemplate, condition, pageSql, countSql, pageParam[0], pageParam[1], " ex_code");
	}
	
	public boolean checkExCode(String exCode){
		mLog.debug("------>checkExCode, exCode=" + exCode);
		String sql = "select * from gbas.ex_def where ex_code=?";
		List<Map<String, Object>> list = this.dwJdbcTemplate.queryForList(sql, exCode);
		if(list == null || list.size() == 0){
			return true;
		}
		return false;
	}
}
