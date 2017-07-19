package com.asiainfo.bass.log.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.core.models.BaseDao;

@SuppressWarnings("unused")
@Repository
public class UtilDao extends BaseDao{
	/**
	 * 查询城市
	 * 
	 */
	public List<Map<String,Object>> selectCity(){
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		Map<String,Object> map=new HashMap<String, Object>();
		String sql = "select cityid,cityname from FPF_user_city  order by cityid";
		list=jdbcTemplate.queryForList(sql);
		return list;
	}
	/**
	 * 判断值是否为空
	 */
	public boolean isNull(String params){
		if(params!=null&&params.length()>0){
			return true;
		}else{
			return false;
		}
	}
	/***
	 * 
	 * 查询语句都往这里走
	 * @param params
	 * @param totalRows
	 * @param totalPage
	 * @param rows
	 * @param page
	 * @param order
	 * @return
	 */
	public Map<String, Object> where(Map<String, Object> params,String totalRows,String totalPage,int rows,int page,String order){
		List<Object> list = new ArrayList<Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		String sql="";
		Map<String, Object> map=new HashMap<String, Object>();
		if(params!=null && !params.isEmpty()){
			for(String key:params.keySet()){
				if(key.contains("like")){
					sql = sql +" and "+key+" ? ";
					list.add("%"+params.get(key)+"%");
				}else{
					sql = sql +" and "+key+" = ? ";
					list.add(params.get(key));
				}
			}
		}
		Object[] obj=list.toArray();
		totalRows=totalRows+sql;
		totalPage=totalPage+sql;
		totalRows=sqlPageHelper.getLimitSQL(totalRows, rows,(page-1)*rows,order);
		map.put("total", jdbcTemplate.queryForObject(totalPage,obj,Integer.class));
		map.put("rows",jdbcTemplate.queryForList(totalRows,obj));
		return map;
	}
	//不带参数查询
	public Map<String,Object> page(String totalRows,String totalPage,int rows,int page,String order){
		Map<String,Object> map=new HashMap<String, Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		totalRows=sqlPageHelper.getLimitSQL(totalRows, rows,(page-1)*rows,order);
		map.put("total", jdbcTemplate.queryForObject(totalPage,Integer.class));
		map.put("rows",jdbcTemplate.queryForList(totalRows));
		return map;
		
	}
}
