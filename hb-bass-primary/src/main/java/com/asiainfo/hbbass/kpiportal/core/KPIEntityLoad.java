package com.asiainfo.hbbass.kpiportal.core;

import java.io.Serializable;
import java.util.Map;

import com.asiainfo.hbbass.kpiportal.load.KpiDataStore;

/**
 * 加载单个KPIEntity,使用不同的算法
 * 
 * @author Mei Kefu
 * 
 */
public interface KPIEntityLoad extends Serializable {
	/**
	 * 初始化KPI指标
	 * 
	 * @return
	 */
	public KPIEntity load() throws KPIPortalException;

	/**
	 * 初始化不缓存部分的数据,比如乡镇信息就不缓存
	 * 
	 * @param parentRegionId
	 *            :父地域ID
	 * @return
	 * @throws KPIPortalException
	 */
	public KPIEntity loadNoCached(String parentRegionId) throws KPIPortalException;

	/**
	 * 加载一段时间当前值,为比较分析使用
	 * 
	 * @param regionIds
	 *            :多个地域的ID
	 * @param state
	 *            : 维度
	 * @param timeStart
	 *            :开始时间
	 * @param timeEnd
	 *            :截止时间
	 * @return
	 * @throws KPIPortalException
	 */
	@SuppressWarnings("rawtypes")
	public Map loadDuring(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) throws KPIPortalException;

	public void setKpiEntity(KPIEntity kpiEntity);

	/**
	 * 把加载基础指标都传进来,给计算类指标使用
	 * 
	 * @param map
	 */
	@SuppressWarnings("rawtypes")
	public void setKpiEntityMap(Map map);
	
	
	/**
	 * 通过初始化KPI指标
	 * 
	 * @return
	 */
	public KPIEntity load(KpiDataStore dataStore) throws KPIPortalException;

}
