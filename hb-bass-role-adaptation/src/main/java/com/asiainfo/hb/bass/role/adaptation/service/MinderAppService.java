package com.asiainfo.hb.bass.role.adaptation.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

/**
 * 营销资源管理
 * @author xiaoh
 *
 */
@Service
public interface MinderAppService {
	
	public List<Map<String, Object>> getCity();
	
	public Map<String, Object> queryCostMaxTime();
	
	public List<Map<String, Object>> queryCostData(String time, String areaCode);

}
