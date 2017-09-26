package com.asiainfo.hb.gbas.model;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.core.util.DateUtil;

@Repository
public class MonitorDao extends CommonDao{
	
	private Logger mLog = LoggerFactory.getLogger(MonitorDao.class);

	public Map<String, Object> getMonitorList(HttpServletRequest req, String name, String cycle){
		mLog.debug("--->getMonitorList");
		String pageSql = "select chkid, name, type, group_id, acc_nbr, create_date, to_char(next_time,'YYYY-MM-DD HH24:MI:SS') next_time," +
				" start_time, end_time, cycle, warn_interval, sql_def, err_times from gbas.monitor_cfg where 1=1";
		String countSql = "select count(1) from gbas.monitor_cfg where 1=1";
		StringBuffer condition = new StringBuffer();
		if(isNotNull(name)){
			condition.append(" and name like '%").append(name).append("%'");
		}
		
		if(isNotNull(cycle)){
			condition.append(" and cycle='").append(cycle).append("'");
		}
		
		int[] pageParam = this.pageParam(req);
		return queryPage(dwJdbcTemplate, null, pageSql + condition.toString(), countSql + condition.toString(),
				pageParam[0], pageParam[1], " chkid desc");
	}
	
	public void saveMonitor(Monitor monitor){
		mLog.debug("--->saveMonitor");
		String currentDate = DateUtil.getCurrentDate("yyyy-MM-dd");
		String insertSql = "insert into gbas.monitor_cfg (name, type,group_id, acc_nbr, create_date," +
				"cycle, warn_interval, sql_def, err_times) values (?,?,?,?,'" + currentDate + "',?,?,?,?)";
		this.dwJdbcTemplate.update(insertSql, new Object[]{monitor.getName(), monitor.getType(), monitor.getGroupId(),
				monitor.getAccNbr(), monitor.getCycle(), monitor.getWarnInterval(), monitor.getSqlDef(), 0});
	}
	
	public void updateMonitor(Monitor monitor){
		mLog.debug("--->updateMonitor");
		String sql = "update gbas.monitor_cfg set name=?, type=?, group_id=?, acc_nbr=?, cycle=?, warn_interval=?" +
				", sql_def=? where chkid=?";
		this.dwJdbcTemplate.update(sql, new Object[]{monitor.getName(), monitor.getType(), monitor.getGroupId(), monitor.getAccNbr(),
				monitor.getCycle(), monitor.getWarnInterval(), monitor.getSqlDef(), monitor.getChkId()});
	}
	
	public List<Map<String, Object>> getLogList(String chkId){
		mLog.debug("--->getLogList");
		String sql = "select group_id, acc_nbr,msg, status, to_char(create_time,'YYYY-MM-DD HH24:MI:SS') create_time," +
				" to_char(update_time,'YYYY-MM-DD HH24:MI:SS') update_time from gbas.monitor_log where chkid=" + chkId + " order by logid desc";
		return this.dwJdbcTemplate.queryForList(sql);
	}
	
	public List<Map<String, Object>> getGroupList(){
		mLog.debug("--->getGroupList");
		String sql = "select replace(group_id, ' ','') id, replace(max(group_remark),' ','') name from nwh.PROC_ALARM group by group_id order by group_id";
		return this.dwJdbcTemplate.queryForList(sql);
	}
	
}
