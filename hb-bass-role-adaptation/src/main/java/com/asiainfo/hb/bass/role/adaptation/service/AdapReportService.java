/**
 * 
 */
package com.asiainfo.hb.bass.role.adaptation.service;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import com.asiainfo.hb.web.models.User;

/**
 * @author zhanggm
 * @date 2016年5月16日
 */
@Service
public interface AdapReportService {

	public List<Map<String, Object>> getReportDataByPage(Integer menuId,String orderByStr,String nameLike,String isKeyWord,
			String pageNumStr,User user);
	public List<Map<String, Object>> getReportLevelChild(String menuId,User user, String reportName);
	public List<Map<String, Object>> getReportLevelMain(String menuId, String reportName);
	public List<Map<String, Object>> getHotReport(Integer menuId);
	
}
