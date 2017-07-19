package com.asiainfo.hb.ftp.models;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.core.util.IdGen;
import com.asiainfo.hb.ftp.controllers.FileMgrController;

@SuppressWarnings("unused")
@Repository
public class CommonDao extends BaseDao {
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
	 * 带参数语句都往这里走
	 * 
	 * @param params
	 *            条件参数
	 * @param totalRows
	 * @param totalPage
	 * @param rows
	 * @param page
	 * @param order
	 * @return
	 */
	IdGen id = new IdGen();

	public Map<String, Object> where(Map<String, Object> params, String totalRows, String totalPage, int rows, int page, String order) {
		List<Object> list = new ArrayList<Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
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
		Map<String, Object> map = new HashMap<String, Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		totalRows = sqlPageHelper.getLimitSQL(totalRows, rows, (page - 1) * rows, order);
		map.put("total", jdbcTemplate.queryForObject(totalPage, Integer.class));
		map.put("rows", jdbcTemplate.queryForList(totalRows));
		return map;
	}

	public List<Map<String, Object>> select(Map<String, Object> params, String selectsql) {
		List<Object> list = new ArrayList<Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		String sql = "";
		Map<String, Object> map = new HashMap<String, Object>();
		if (params != null && !params.isEmpty()) {
			for (String key : params.keySet()) {
				if (key.contains("like")) {
					sql = sql + " and " + key + " ? ";
					list.add("%" + params.get(key) + "%");
				} else {
					sql = sql + " and " + key + " = ? ";
					list.add(params.get(key));
				}
			}
		}
		Object[] obj = list.toArray();
		selectsql = selectsql + sql;
		return jdbcTemplate.queryForList(selectsql, obj);
	}

	public boolean update(String status, Date approve_time, String approve_opinion, String file_id) {
		String sql = "update ST.FPF_FILE set status=?, approve_time=?, approve_opinion=? where file_id=?";
		int a = 0;
		try {
			a = jdbcTemplate.update(sql, status, approve_time, approve_opinion, file_id);
		} catch (DataAccessException e) {
		
			e.printStackTrace();
		}
		if (a == 0) {
			return false;
		} else {
			return true;
		}
	}


}
