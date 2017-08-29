package com.asiainfo.hb.bass.role.adaptation.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public interface ReportOnOffLineService {
	
	public List<Map<String, Object>> getMenuList();

	/**
	 * 查询已上线报表
	 * @return
	 */
	public Map<String, Object> getHasOnlineReport(String menuId, String reportName,String reportId, int perPage, int currentPage);
	
	public void changeSort(String rid, String menuId, String sortId);
	
	public void offLineRpt(String reportId, String url);
	
	public Map<String, Object> getWaitOnLineReport(String name, String id, int perPage, int currentPage);
	
	public List<Map<String, Object>> getSortList(String menuId, String name);
	
	public void onLineRpt(String menuId, String sortId, String rid, String sortNum, String keyWord, String rptCycle);
	
	public void addRptSort(String menuId, String name, String sortNum);
	
	public void deleteRptSort(String ids);
	
	public void updateRptSort(String sortId, String menuId, String name, String sortNum);
}
