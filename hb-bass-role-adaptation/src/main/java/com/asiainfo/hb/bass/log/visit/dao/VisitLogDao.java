package com.asiainfo.hb.bass.log.visit.dao;

import java.util.List;
import java.util.Map;


public interface VisitLogDao {
	Map<String, Object> getPageList(Integer page, Integer rows,Map<String,Object> params);
	
	/**
	 * 查询全省市区信息
	 * @return
	 */
	List<Map<String, Object>> getCityList();
}
