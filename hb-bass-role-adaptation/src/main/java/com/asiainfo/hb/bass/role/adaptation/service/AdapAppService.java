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
public interface AdapAppService {
	public List<Map<String, Object>> getAppData(String sid,String orderType,String searchVal,String appType,
			String pageNum,User user);
	public List<Map<String, Object>> getHotApp(Integer menuId);
	public List<Map<String, Object>> getAppType();
	public List<Map<String, Object>> getZtDetail(String resource);
	public List<Map<String, Object>> getZtShow(String resource);
	public List<Map<String, Object>> getHotZt();
	
	/**
	 * 查询专题详情
	 * @param resId
	 * @return
	 */
	public Map<String, Object> getTopicDetail(String resId);
	
	/**
	 * 查询专题下级资源
	 * @param resId
	 * @return
	 */
	public List<Map<String, Object>> getSubTopics(String resId);
	
}
