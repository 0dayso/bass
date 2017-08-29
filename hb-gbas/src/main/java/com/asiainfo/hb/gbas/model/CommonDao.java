package com.asiainfo.hb.gbas.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.core.models.JdbcTemplate;

public class CommonDao {
	
	/**web库**/
	protected JdbcTemplate jdbcTemplate;
	
	/**仓库**/
	protected JdbcTemplate dwJdbcTemplate;

	@Autowired
	public void setJdbcTemplate(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	@Autowired
	public void setDwJdbcTemplate(DataSource dataSourceDw) {
		this.dwJdbcTemplate = new JdbcTemplate(dataSourceDw);
	}
	
	public boolean isNotNull(String param){
		if(param != null && param.length() != 0){
			return true;
		}
		return false;
	}
	
	public int[] pageParam(HttpServletRequest req){
		int[] param = new int[2];
		String page = req.getParameter("page");
		String rows = req.getParameter("rows");
		int perPage = 10;
		int currentPage = 1;
		if(isNotNull(page)){
			currentPage = Integer.valueOf(page);
		}
		if(isNotNull(rows)){
			perPage = Integer.valueOf(rows);
		}
		param[0] = perPage;
		param[1] = currentPage;
		return param;
	}
	
	/**
	 * 查询分页数据
	 * @param jdbcTemplate
	 * @param condition 查询条件
	 * @param pageSql 行SQL
	 * @param countSql 总数SQL
	 * @param perPage 每页展示几条
	 * @param currentPage 当前页
	 * @param order 排序
	 * @return
	 */
	public Map<String, Object> queryPage(JdbcTemplate jdbcTemplate, Map<String, Object> condition, String pageSql, String countSql, int perPage, int currentPage, String order){
		List<Object> list = new ArrayList<Object>();
		String conditionStr = "";
		if (condition != null && !condition.isEmpty()) {
			for (String key : condition.keySet()) {
				if(!StringUtils.isEmpty(condition.get(key))){
					if (key.contains("like")) {
						conditionStr = conditionStr + " and " + key + " ? ";
						list.add("%" + condition.get(key) + "%");
					} else {
						conditionStr = conditionStr + " and " + key + " = ? ";
						list.add(condition.get(key));
					}
				}
			}
		}
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper(jdbcTemplate);
		countSql += conditionStr;
		pageSql = sqlPageHelper.getLimitSQL(pageSql + conditionStr, perPage, (currentPage - 1) * perPage, order);
		Object[] obj = list.toArray();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("total", jdbcTemplate.queryForObject(countSql, obj, Integer.class));
		map.put("rows", jdbcTemplate.queryForList(pageSql, obj));
		return map;
	}
	
}
