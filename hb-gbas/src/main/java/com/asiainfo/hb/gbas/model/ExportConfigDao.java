package com.asiainfo.hb.gbas.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import com.asiainfo.hb.core.util.DateUtil;

@Repository
public class ExportConfigDao extends CommonDao{
	
	private Logger mLog = LoggerFactory.getLogger(ExportConfigDao.class);
	
	public Map<String, Object> getConfigList(HttpServletRequest req){
		String pageSql = "select * from boi.task_config where task_id is not null";
		String countSql = "select count(1) from boi.task_config where task_id is not null";
		
		int[] pageParam = this.pageParam(req);
		return queryPage(dwJdbcTemplate, null, pageSql, countSql, pageParam[0], pageParam[1], " task_id desc");
	}
	
	public List<Map<String, Object>> getTaskParam(String taskId){
		String sql = "select * from boi.task_param where task_id=" + taskId + " order by param_order";
		return this.dwJdbcTemplate.queryForList(sql);
	}
	
	public void saveTaskParam(String taskId, JSONArray datas){
		String delSql = "delete from boi.task_param where task_id=" + taskId;
		this.dwJdbcTemplate.batchUpdate(delSql);
		int nextId = this.dwJdbcTemplate.queryForObject("select value(max(tp_id), 0) from boi.task_param", Integer.class);
		List<String> insertSqls = new ArrayList<String>();
		JSONObject temp;
		for(int i=0; i<datas.size(); i++){
			temp = datas.getJSONObject(i);
			insertSqls.add("insert into boi.task_param (tp_id, task_id, param_order, param_type, param_len, target_len, conv_param)" +
					"values ("+ (++nextId)+","+ taskId +","+ (i+1) +","+ temp.get("param_type") +","+ temp.get("param_len") 
					+","+ temp.get("target_len") +","+ temp.get("conv_param") + ")");
		}
		this.dwJdbcTemplate.batchUpdate(insertSqls.toArray(new String[insertSqls.size()]));
	}

	
	public Integer getTaskParamColumnCount(String taskId){
		String lastDay = DateUtil.getPreDate("yyyyMMdd");
		String lastMon = DateUtil.getLastMonth();
		String sql = "select sql_describe from boi.task_config where task_id=" + taskId;
		List<Map<String, Object>> list = this.dwJdbcTemplate.queryForList(sql);
		if(list != null&& list.size()>0){
			Map<String, Object> map = list.get(0);
			try {
				String sqlDesc = (String) map.get("sql_describe");
				sqlDesc = sqlDesc.replace("{MON}", lastMon).replace("{INT}", lastDay);
				mLog.info("sqlDesc:" + sqlDesc);
				int columnCount = this.dwJdbcTemplate.queryForRowSet(sqlDesc, null, null).getMetaData().getColumnCount();
				return columnCount;
			} catch (Exception e) {
				mLog.error("查询字段配置列数出错，" + e.toString());
			}
		}
		return 0;
	}
	
	public void saveTaskConfig(TaskConfig config){
		String sql = "insert into boi.task_config (task_id, sql_describe, remark, unit_code, file_standby, " +
				"filter_type, status, task_type, execpath, execname, ftp_flag, createsh) values" +
				" (?,?,?,?,?,?,?,?,?,?,?,?)";
		String idSql = "select value(max(task_id), 0) from boi.task_config";
		int nextId = this.dwJdbcTemplate.queryForObject(idSql, Integer.class) + 1;
		this.dwJdbcTemplate.update(sql, new Object[]{nextId, config.getSqlDescribe(), config.getRemark(), config.getUnitCode(),
				config.getFileStandBy(), config.getFilterType(), config.getStatus(), config.getTaskType(),
				config.getExecPath(), config.getExecName(), config.getFtpFlag(), config.getCreateSh()});
	}
	
	public void updateTaskConfig(TaskConfig config){
		String sql = "update boi.task_config set sql_describe=?, remark=?, unit_code=?, file_standby=?, filter_type=?" +
				", status=?, task_type=?, execpath=?, execname=?, ftp_flag=?, createsh=? where task_id=?";
		this.dwJdbcTemplate.update(sql, new Object[]{config.getSqlDescribe(), config.getRemark(), config.getUnitCode(),
				config.getFileStandBy(), config.getFilterType(), config.getStatus(), config.getTaskType(),
				config.getExecPath(), config.getExecName(), config.getFtpFlag(), config.getCreateSh(), config.getTaskId()});
	}
	
	public void delTaskConfig(String taskId){
		String sql = "delete from boi.task_config where task_id=" + taskId;
		String paramSql = "delete from boi.task_param where task_id=" + taskId;
		this.dwJdbcTemplate.update(sql);
		this.dwJdbcTemplate.update(paramSql);
	}
	
}
