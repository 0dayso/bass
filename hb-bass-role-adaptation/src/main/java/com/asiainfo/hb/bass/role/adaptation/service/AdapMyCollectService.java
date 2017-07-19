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
 */
@Service
public interface AdapMyCollectService {
	
	public  List<Map<String,Object>> getCollect(Integer menuId,String resourceName,String startDate,
			String endDate,String resourceType,String pageNumStr,User user);
	public  Map<String,Object> deleteCollect(String rid,Integer menuId,User user);
	public  Map<String,Object> addCollect(String rid,Integer menuId,User user);
	public 	List<Map<String, Object>> getHotCollect(Integer menuId);
	public  List<Map<String, Object>> getCollectTypes();
}
