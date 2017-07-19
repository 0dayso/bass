package com.asiainfo.hb.bass.role.adaptation.service;

import java.util.Map;
import org.springframework.stereotype.Service;

/**
 * 
 * @author xiaoh
 *
 */
@Service
public interface KpiAnalyseService {
	
	public Map<String, Object> getKpiInfo(String bocId);

}
