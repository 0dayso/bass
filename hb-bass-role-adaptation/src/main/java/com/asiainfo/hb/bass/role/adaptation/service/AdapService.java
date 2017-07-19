package com.asiainfo.hb.bass.role.adaptation.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

/**
 * top5排行榜数据
 * @author yuanbiao
 * 2016-5-16
 */
@SuppressWarnings("rawtypes")
@Service
public interface AdapService {
	/**
	 * 指标访问量 T05
	 * @param mid
	 * @param userId
	 * @return
	 */
	public List getHotKpisTop(String mid,String userId);
	/**
	 * 销售活动评估报表
	 * @param mid
	 * @param userId
	 * @return
	 */
	public List getReportSortTop(String mid,String sid,String userId);
	/**
	 * 营销活动评估应用
	 * @param mid
	 * @param userId
	 * @return
	 */
	public List getRelaApps(String mid,String sid,String userId);
	/**
	 * 报表中心
	 * @param mid
	 * @param sid
	 * @param userId
	 * @return
	 */
	public List getRelaReports(String mid,String sid,String userId);
	/**
	 * 我的收藏
	 * @param mid
	 * @param sid
	 * @param userId
	 * @return
	 */
	public List getRelaCollect(String mid,String sid,String userId);
	/**
	 * 最新上线
	 * @param mid
	 * @param sid
	 * @param userId
	 * @return
	 */
	public List getLastOnlineReport(String mid,String sid,String userId);
	/**
	 * 公告
	 * @return
	 */
	public List getTopThreeNews();
	public List getTopKpi();
	public Map<String, Object> getAllTopKpi(Map<String, Object> params) throws Exception;
	/**
	 * 公告信息页面
	 * @return
	 */
	public Map<String, Object> getAllNotice(Map<String,Object> params) throws Exception;
	
	/**
	 * 根据条件查询最新上线
	 */
	public Map<String, Object> getAllLastOnlineReport(Map<String, Object> params) throws Exception;
	
	public List getCity(String provId);
	public List getCountry(String cityId);
	public List getMarket(String countyId);
	public List queryApplyAbiList();
	
	public int getNotice(Map map);
	public int delNotce(Integer newsid);
}
