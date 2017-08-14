package com.asiainfo.hb.web.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.util.StringUtils;

import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.core.models.BaseDao;

public class CommonDao  extends BaseDao{

	private static Logger log = Logger.getLogger(CommonDao.class);

	/**
	 * 判断值是否为空
	 */
	public boolean isNull(String params) {
		if (params != null && params.length() > 0) {
			return true;
		} else {
			return false;
		}
	}

	/***
	 * 
	 * 带参数分页语句
	 * 
	 * @param params
	 * @param totalRows
	 * @param totalPage
	 * @param rows
	 * @param page
	 * @param order
	 * @return
	 */

	public Map<String, Object> where(Map<String, Object> params, String totalRows, String totalPage, int rows, int page, String order) {
		List<Object> list = new ArrayList<Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper(jdbcTemplate);
		String sql = "";
		Map<String, Object> map = new HashMap<String, Object>();
		if (params != null && !params.isEmpty()) {
			for (String key : params.keySet()) {
				if(!StringUtils.isEmpty(params.get(key))){
					if (key.contains("like")) {
						sql = sql + " and " + key + " ? ";
						list.add("%" + params.get(key) + "%");
					} else {
						sql = sql + " and " + key + " = ? ";
						list.add(params.get(key));
					}
				}
			}
		}
		Object[] obj = list.toArray();
		totalRows = totalRows + sql;
		totalPage = totalPage + sql;
		totalRows = sqlPageHelper.getLimitSQL(totalRows, rows, (page - 1) * rows, order);
		map.put("total", jdbcTemplate.queryForObject(totalPage, obj, Integer.class));
		map.put("rows", jdbcTemplate.queryForList(totalRows, obj));
		return map;
	}

	// 不带参数查询
	public Map<String, Object> page(String totalRows, String totalPage, int rows, int page, String order) {
		log.debug("------------Paging------------");
		Map<String, Object> map = new HashMap<String, Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper(jdbcTemplate);
		totalRows = sqlPageHelper.getLimitSQL(totalRows, rows, (page - 1) * rows, order);
		map.put("total", jdbcTemplate.queryForObject(totalPage, Integer.class));
		List<Map<String,Object>> list =jdbcTemplate.queryForList(totalRows);
		for(int i=0;i<list.size();i++){
			list.get(i).remove("pseudo_column_rownum");
		}
		map.put("rows", list);
		return map;
	}

}
