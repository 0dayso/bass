package com.asiainfo.hb.gbas.model;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.asiainfo.hb.web.models.CommonDao;

@Repository
public class TaskDao extends CommonDao{
	
	
	public Map<String, Object> getTaskList(Map<String, Object> params, Integer curPage, Integer perPage){
		
		String rowSql = "select * from gbas.run_dispatch where 1=1 ";
		String countSql = "select count(1) from gbas.run_dispatch where 1=1 ";
		return where(params, rowSql, countSql, perPage, curPage, " etl_cycle_id");
	}
	
	public Map<String, Object> getNodeData(){
		Map<String, Object> map = new HashMap<String, Object>();
		
		String nodeSql = "WITH PPL (ID,PiD,NAME) AS  ( " +
				"SELECT ID,PID,NAME FROM st.d3_test WHERE name='DwdCdrWlanDm' " +
				"UNION ALL " +
				"SELECT child.ID,child.pID,child.NAME FROM PPL parent,st.d3_test child WHERE child.id =parent.pid ) " +
				"SELECT distinct(id),name FROM PPL";
		
		String edgeSql = "WITH PPL (ID,PiD,NAME) AS  " +
				"( SELECT ID,PID,NAME FROM st.d3_test WHERE name='DwdCdrWlanDm' " +
				"UNION ALL " +
				"SELECT child.ID,child.pID,child.NAME FROM PPL parent,st.d3_test child WHERE child.id =parent.pid ) " +
				"SELECT distinct(pid||','||id) val FROM PPL where pid !=0";
		
		List<Map<String, Object>> nodeList = this.jdbcTemplate.queryForList(nodeSql);
		List<Map<String, Object>> edgeList = this.jdbcTemplate.queryForList(edgeSql);
		
		map.put("nodes", nodeList);
		map.put("edges", edgeList);
		return map;
	}

}
