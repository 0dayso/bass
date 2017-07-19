package com.asiainfo.hb.bass.data.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.asiainfo.hb.bass.data.model.BocIndicatorMenu;
import com.asiainfo.hb.bass.data.model.DimCompDef;
import com.asiainfo.hb.bass.data.model.Kpi;
import com.asiainfo.hb.bass.data.model.KpiDef;
import com.asiainfo.hb.web.models.User;

/**
 * KPI数据服务
 * 
 * @author 李志坚
 * @since 2017-03-05
 */
@SuppressWarnings("unused")
@Service
public interface KpiService {

	/**
	 * 获取全部指标定义
	 * 
	 * @return List的KpiDef
	 * @throws Exception
	 */
	public List<KpiDef> getDefAll() throws Exception;

	/**
	 * 获取单个指标定义
	 * 
	 * @param defsList
	 *            全部的定义
	 * @param KpiId
	 *            指标的ID
	 * @return 单个KpiDef
	 */
	public KpiDef getKpiDefById(String kpiId) throws Exception;

	/**
	 * 根据组合维度代码，查询组合维度列表
	 * 
	 * @param compDimCode
	 *            组合维度代码，如
	 * @return
	 * @throws Exception
	 */
	public List<DimCompDef> getKpiDim(String compDimCode) throws Exception;

	/**
	 * 查询KPI数据
	 * 
	 * @param indicatorMenuId
	 * @param opTime
	 * @param dimCode
	 * @param dimVal
	 * @return
	 * @throws Exception
	 */
	public List<Kpi> getKpiByIndicatorMenuId(String indicatorMenuId, String opTime, String dimCode, String dimVal) throws Exception;

	/**
	 * 查询KPI数据
	 * 
	 * @param kpiCode
	 * @param opTime
	 * @param endTime
	 * @param dimCode
	 * @param dimVal
	 * @return
	 * @throws Exception
	 */
	public List<Kpi> getKpiByTime(String indicatorMenuId, String startTime, String endTime, String dimCode, String dimVal)throws Exception;
	
	public BocIndicatorMenu getBocIndicatorMenuById(String bocIndicatorMenuId) throws Exception;

	public void insertKpiLog(String id, String kpicode,String date,String username);

}


