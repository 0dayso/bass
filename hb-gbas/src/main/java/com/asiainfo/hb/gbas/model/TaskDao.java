package com.asiainfo.hb.gbas.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;


@Repository
public class TaskDao extends CommonDao{
	
	private Logger mLog = LoggerFactory.getLogger(TaskDao.class);
	
	public Map<String, Object> getTaskList(Map<String, Object> params, HttpServletRequest req){
		mLog.debug("------>getTaskList");
		String rowSql = "select id, type,gbas_code, cycle, etl_cycle_id, etl_status,to_char(dispatch_time,'YYYY-MM-DD HH24:MI:SS') dispatch_time," +
				" to_char(exec_start_time,'YYYY-MM-DD HH24:MI:SS') exec_start_time, to_char(exec_end_time,'YYYY-MM-DD HH24:MI:SS') exec_end_time " +
				" from gbas.run_dispatch where 1=1 ";
		String countSql = "select count(1) from gbas.run_dispatch where 1=1 ";
		
		int[] pageParam = this.pageParam(req);
		
		return queryPage(dwJdbcTemplate, params, rowSql, countSql, pageParam[0], pageParam[1], " etl_cycle_id");
	}
	
//	public Map<String, Object> getNodeData(String gbasCode){
//		Map<String, Object> map = new HashMap<String, Object>();
//		
//		String nodeSql = "WITH PPL (ID,PiD,NAME) AS  ( " +
//				"SELECT ID,PID,NAME FROM st.d3_test WHERE name='DwdCdrWlanDm' " +
//				"UNION ALL " +
//				"SELECT child.ID,child.pID,child.NAME FROM PPL parent,st.d3_test child WHERE child.id =parent.pid ) " +
//				"SELECT distinct(id) code,name FROM PPL";
//		
//		String edgeSql = "WITH PPL (ID,PiD,NAME) AS  " +
//				"( SELECT ID,PID,NAME FROM st.d3_test WHERE name='DwdCdrWlanDm' " +
//				"UNION ALL " +
//				"SELECT child.ID,child.pID,child.NAME FROM PPL parent,st.d3_test child WHERE child.id =parent.pid ) " +
//				"SELECT id code, pid depend_code FROM PPL where pid !=0";
//		
//		List<Map<String, Object>> nodeList = this.dwJdbcTemplate.queryForList(nodeSql);
//		List<Map<String, Object>> edgeList = this.dwJdbcTemplate.queryForList(edgeSql);
//		
//		map.put("nodes", nodeList);
//		map.put("edges", edgeList);
//		return map;
//	}
	
	
	public Map<String, Object> getNodeData(String gbasCode){
		mLog.debug("------>getNodeData");
		Map<String, Object> map = new HashMap<String, Object>();
		String nodeSql = "WITH PPL (proc, proc_dep) AS  ( " +
				"SELECT proc, proc_dep FROM gbas.proc_deps WHERE proc='" + gbasCode + "' " +
				"UNION ALL " +
				"SELECT child.proc,child.proc_dep FROM PPL parent,gbas.proc_deps child WHERE child.proc =parent.proc_dep) " +
				"SELECT distinct(proc) proc FROM (select proc from ppl union all select proc_dep proc from ppl)";
		mLog.debug("nodeSql" + nodeSql);
		String edgeSql = "WITH PPL (proc, proc_dep) AS  ( " +
				"SELECT proc, proc_dep FROM gbas.proc_deps WHERE proc='" + gbasCode + "' " +
				"UNION ALL " +
				"SELECT child.proc,child.proc_dep FROM PPL parent,gbas.proc_deps child WHERE child.proc =parent.proc_dep) " +
				"SELECT proc, proc_dep FROM PPL";
		mLog.debug("edgeSql:" + edgeSql);
		List<Map<String, Object>> nodeList = this.dwJdbcTemplate.queryForList(nodeSql);
		List<Map<String, Object>> edgeList = this.dwJdbcTemplate.queryForList(edgeSql);
		
		map.put("nodes", nodeList);
		map.put("edges", edgeList);
		return map;
	}
	
	public List<Map<String, Object>> getDepsProcStatus(String gbasCode, String etlCycle){
		mLog.debug("--->getDepsProcStatus");
		String statusSql = " WITH PPL (proc, proc_dep) AS  ( " +
				" SELECT proc, proc_dep FROM gbas.proc_deps WHERE proc=? " +
				 "UNION ALL " +
				" SELECT child.proc,child.proc_dep FROM PPL parent,gbas.proc_deps child WHERE child.proc =parent.proc_dep) " +
				" select a.proc proc, b.etl_state status from " +
				" (SELECT distinct(proc) proc FROM (select proc from ppl union all select proc_dep proc from ppl)) a " +
				" left join (select * from nwh.DP_ETL_COM where etl_state=3 and etl_cycle_id=?) b on a.proc=b.etl_progname" +
				" where proc != ?";
		return this.dwJdbcTemplate.queryForList(statusSql, new Object[]{gbasCode, etlCycle, gbasCode});
	}
	
	public void updateStatus(String id, String status){
		mLog.debug("--->updateStatus");
		String sql = "update gbas.run_dispatch set etl_status=? where id=?";
		this.dwJdbcTemplate.update(sql, new Object[]{status, id});
	}
	
	public List<Map<String, Object>> queryLog(String id){
		mLog.debug("--->queryLog");
		String sql = "select type, gbas_code, to_char(err_time,'YYYY-MM-DD HH24:MI:SS') err_time, " +
				"err_msg from gbas.err_msg_log where type_id=? order by err_time desc";
		return this.dwJdbcTemplate.queryForList(sql, id);
	}
}
