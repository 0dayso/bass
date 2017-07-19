package com.asiainfo.hb.bass.role.adaptation.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
/**
 * @author zuoyl
 * 
 * */
@Service
public interface KpiVisitService {
	public List<Map<String,Object>> getNum();

	public void insertKpiLog(String id, String kpicode, String date, String user);

	void insertKpi(int id, String kpicode);
}
