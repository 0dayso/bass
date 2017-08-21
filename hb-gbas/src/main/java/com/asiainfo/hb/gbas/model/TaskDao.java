package com.asiainfo.hb.gbas.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Repository;


@Repository
public class TaskDao extends CommonDao{
	
	public Map<String, Object> getTaskList(Map<String, Object> params, HttpServletRequest req){
		
		String rowSql = "select type,gbas_code, cycle, etl_cycle_id, etl_status,to_char(dispatch_time,'YYYY-MM-DD HH24:MI:SS') dispatch_time," +
				" to_char(exec_start_time,'YYYY-MM-DD HH24:MI:SS') exec_start_time, to_char(exec_end_time,'YYYY-MM-DD HH24:MI:SS') exec_end_time " +
				" from gbas.run_dispatch where 1=1 ";
		String countSql = "select count(1) from gbas.run_dispatch where 1=1 ";
		
		int[] pageParam = this.pageParam(req);
		
		return queryPage(dwJdbcTemplate, params, rowSql, countSql, pageParam[0], pageParam[1], " etl_cycle_id");
	}
	
	/**public Map<String, Object> getNodeData(String gbasCode){
		Map<String, Object> map = new HashMap<String, Object>();
		
		String nodeSql = "WITH PPL (ID,PiD,NAME) AS  ( " +
				"SELECT ID,PID,NAME FROM st.d3_test WHERE name='DwdCdrWlanDm' " +
				"UNION ALL " +
				"SELECT child.ID,child.pID,child.NAME FROM PPL parent,st.d3_test child WHERE child.id =parent.pid ) " +
				"SELECT distinct(id) code,name FROM PPL";
		
		String edgeSql = "WITH PPL (ID,PiD,NAME) AS  " +
				"( SELECT ID,PID,NAME FROM st.d3_test WHERE name='DwdCdrWlanDm' " +
				"UNION ALL " +
				"SELECT child.ID,child.pID,child.NAME FROM PPL parent,st.d3_test child WHERE child.id =parent.pid ) " +
				"SELECT id code, pid depend_code FROM PPL where pid !=0";
		
		List<Map<String, Object>> nodeList = this.dwJdbcTemplate.queryForList(nodeSql);
		List<Map<String, Object>> edgeList = this.dwJdbcTemplate.queryForList(edgeSql);
		
		map.put("nodes", nodeList);
		map.put("edges", edgeList);
		return map;
	}**/
	
	
	public Map<String, Object> getNodeData(String gbasCode){
		Map<String, Object> map = new HashMap<String, Object>();
		
		String nodeSql = "WITH PPL (code, depend_code) AS  ( " +
				"SELECT code, depend_code FROM gbas.code_relation WHERE code='" + gbasCode + "' " +
				"UNION ALL " +
				"SELECT child.code,child.depend_code FROM PPL parent,gbas.code_relation child WHERE child.code =parent.depend_code) " +
				"SELECT distinct(code) code FROM (select code from ppl union all select depend_code code from ppl)";
		
		String edgeSql = "WITH PPL (code, depend_code) AS  ( " +
				"SELECT code, depend_code FROM gbas.code_relation WHERE code='" + gbasCode + "' " +
				"UNION ALL " +
				"SELECT child.code,child.depend_code FROM PPL parent,gbas.code_relation child WHERE child.code =parent.depend_code) " +
				"SELECT code, depend_code FROM PPL";
		
		List<Map<String, Object>> nodeList = this.dwJdbcTemplate.queryForList(nodeSql);
		List<Map<String, Object>> edgeList = this.dwJdbcTemplate.queryForList(edgeSql);
		
		map.put("nodes", nodeList);
		map.put("edges", edgeList);
		return map;
	}

}
