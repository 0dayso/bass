package com.asiainfo.hbbass.kpiportal.load;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityInitialize;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityLoad;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValue;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueCell;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueCells;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueState;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalException;
import com.asiainfo.hbbass.kpiportal.service.KPIPortalService;

/**
 * 占比的计算指标加载
 * 
 * @author Mei Kefu
 * @date 2010-12-30 修改了从map中取需要的原始指标，如果map中没有就直接加载该指标，不从service中取数了
 */
@SuppressWarnings({ "unused", "serial" })
public class PercentLoad extends BaseLoad implements KPIEntityLoad {
	private static Logger LOG = Logger.getLogger(PercentLoad.class);

	@SuppressWarnings("rawtypes")
	private Map map;

	@SuppressWarnings("rawtypes")
	public void setKpiEntityMap(Map map) {
		this.map = map;
	}

	@SuppressWarnings("rawtypes")
	protected Map constants = new HashMap();// 常量值

	@Override
	public KPIEntity load(KpiDataStore dataStore) throws KPIPortalException {
		return load();
	}
	
	@SuppressWarnings("unchecked")
	public KPIEntity load() throws KPIPortalException {
		try {
			kpiEntity.getKpiMetaData().parseArithmetic();
			String[] numZbCodes = kpiEntity.getKpiMetaData().numerator.split(",");

			String[] denZbCodes = kpiEntity.getKpiMetaData().denominator.split(",");

			Object[] numKpi = new Object[numZbCodes.length];
			Object[] denKpi = new Object[denZbCodes.length];

			/*
			 * if(map==null){ map =
			 * KPIPortalService.getKPIMap(kpiEntity.getKpiAppData().getName(),
			 * kpiEntity.getDate()); } if(map==null){
			 * LOG.warn("取不到计算的原始数据，无法计算"); return null; } //初始化分子 numKpi[0]=
			 * (KPIEntity)map.get(numZbCodes[0]);
			 */

			numKpi[0] = getOriKPIEntity(numZbCodes[0]);
			if (numKpi[0] == null) {
				LOG.warn("基础指标:" + numZbCodes[0] + "没有加载,该计算指标不能处理");
				return null;
			}
			KPIEntity newKPIEntity = (KPIEntity) ((KPIEntity) numKpi[0]).clone();// 克隆第一个值
			/*
			 * // 替换到原KPI的值 ，增加了parentKPI字段后必须手工赋值 20091229
			 * //也可以换成numKpi[0].setKPIMetaData, kpiEntity=numKpi[0];
			 * kpiEntity.setRoot
			 * (((KPIEntity)numKpi[0]).getRoot());//付给当前KPIEntity
			 * kpiEntity.setIndex(((KPIEntity)numKpi[0]).getIndex());
			 * kpiEntity.getRoot
			 * ().setRootKPIEntity(kpiEntity);//把KPI的root的新父节点赋值一下
			 * ，要不然从子得到父的时候会值分子KPI的引用
			 */

			newKPIEntity.setDate(kpiEntity.getDate());
			newKPIEntity.setKpiAppData(kpiEntity.getKpiAppData());
			newKPIEntity.setKpiEntityLoad(kpiEntity.getKpiEntityLoad());
			newKPIEntity.setKpiMetaData(kpiEntity.getKpiMetaData());
			newKPIEntity.setValueFilter(kpiEntity.getValueFilter());
			newKPIEntity.getKpiEntityLoad().setKpiEntity(newKPIEntity);

			kpiEntity = newKPIEntity;

			for (int i = 1; i < numKpi.length; i++) {
				// numKpi[i]= (KPIEntity)map.get(numZbCodes[i]);

				numKpi[i] = getOriKPIEntity(numZbCodes[i]);

				if (numKpi[i] == null) {
					LOG.warn("基础指标:" + numZbCodes[i] + "没有加载,该计算指标不能处理");
					return null;
				}
			}
			// 初始化分母
			for (int i = 0; i < denKpi.length; i++) {
				if (!denZbCodes[i].matches("\\$.*")) {
					// denKpi[i]= (KPIEntity)map.get(denZbCodes[i]);
					denKpi[i] = getOriKPIEntity(denZbCodes[i]);
					if (denKpi[i] == null) {
						LOG.warn("基础指标:" + denZbCodes[i] + "没有加载,该计算指标不能处理");
						return null;
					}
				} else {
					LOG.info("基础指标:" + denZbCodes[i] + "为常量");
					denKpi[i] = denZbCodes[i];
					constants.put(denZbCodes[i], denZbCodes[i]);
				}
			}

			init(kpiEntity.getIndex(), numKpi, denKpi);
			kpiEntity.getKpiEntityLoad().setKpiEntity(kpiEntity);

		} catch (Exception e) {
			e.printStackTrace();
			throw new KPIPortalException(e);
		}
		LOG.info("指标:" + kpiEntity.getId() + kpiEntity.getKpiAppData().getName() + kpiEntity.getName() + " size:" + kpiEntity.getIndex().size() + " 初始化成功");
		return kpiEntity;
	}

	/**
	 * 2010-12-30 取得需要计算的KPIEntity
	 * 
	 * @param kpiCode
	 * @return
	 */
	protected KPIEntity getOriKPIEntity(String kpiId) {
		KPIEntity newKpiEntity = null;
		if (map != null && map.size() > 0 && map.containsKey(kpiId)) {
			LOG.debug(kpiId + this.kpiEntity.getKpiAppData().getName() + "在Map中");
			newKpiEntity = (KPIEntity) map.get(kpiId);
		} else if (kpiId != null && kpiId.length() > 0) {
			LOG.info("Map中没有，加载原始指标" + kpiId + this.kpiEntity.getKpiAppData().getName());
			// newKpiEntity =
			// KPIEntityInitialize.loadKPIEntity(this.kpiEntity.getDate(),
			// this.kpiEntity.getKpiAppData().getName(), kpiId);
		}
		return newKpiEntity;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected void init(Map index, Object[] numKpi, Object[] denKpi) {

		/**
		 * 多维度不统一的计算，比如三家市场占有率的计算移动是三个品牌维度，联通和电信是一个品牌维度，通过state来取每个值的时候就会取到对方的
		 * 所以要先计算是否多维度，配置在KPIEntityValueState.@DimensionEnum中全部的维度计算
		 */
		boolean isMultiDim = false;

		for (int i = 0; i < numKpi.length; i++) {
			if (denKpi[i] instanceof KPIEntity) {
				KPIEntity kpiEntity = (KPIEntity) denKpi[i];
				// KPIEntity.Entity entity =
				// (KPIEntity.Entity)kpiEntity.getIndex().get("HB");
				// 20100114nocache加载计算时在计算时这个地方会报空指针
				KPIEntity.Entity entity = (KPIEntity.Entity) kpiEntity.getRoot();
				if (entity.getValue().getCurrent().getCells().size() > 1) {
					isMultiDim = true;
					break;
				}
			}
		}
		if (!isMultiDim) {
			for (int i = 0; i < denKpi.length; i++) {
				if (denKpi[i] instanceof KPIEntity) {
					KPIEntity kpiEntity = (KPIEntity) denKpi[i];
					// KPIEntity.Entity entity =
					// (KPIEntity.Entity)kpiEntity.getIndex().get("HB");
					KPIEntity.Entity entity = (KPIEntity.Entity) kpiEntity.getRoot();
					if (entity.getValue().getCurrent().getCells().size() > 1) {
						isMultiDim = true;
						break;
					}
				}
			}
		}

		String[] numSigns = kpiEntity.getKpiMetaData().numberatorSign.split(",");
		String[] denSigns = kpiEntity.getKpiMetaData().denominatorSign.split(",");

		for (Iterator iterator = index.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();// 遍历克隆的第一个kpi
			KPIEntity.Entity entity = (KPIEntity.Entity) entry.getValue();

			try {
				KPIEntityValue value = entity.getValue();// 计算里面KPIEntityValue

				// 20091223增加配置一个targetValue来设置固定的考核值，试用于占比类型
				value.setTargetValue(new Double(kpiEntity.getKpiMetaData().getTargetValue()));

				KPIEntityValueCells cellsCurrent = new KPIEntityValueCells(value), cellsPre = new KPIEntityValueCells(value), cellsBefore = new KPIEntityValueCells(value), cellsYear = new KPIEntityValueCells(value);

				List stateList = value.getCurrent().getCells();
				// 如果只有一个state就不取全部的state
				if (isMultiDim) {
					stateList = KPIEntityValueState.getAllState();
				}

				for (int i = 0; i < stateList.size(); i++) {

					KPIEntityValueState state = null;
					// 判断是否只有一个state的不同取法
					if (stateList.size() > 1) {
						state = (KPIEntityValueState) stateList.get(i);
					} else {
						state = ((KPIEntityValueCell) stateList.get(i)).getState();
					}

					// 先计算分子值
					double[] dNumberator = calculate(state, numKpi, entity.getKey(), numSigns);

					// 计算分母值
					double[] dDenominator = calculate(state, denKpi, entity.getKey(), denSigns);

					Double dCurrentNum = null;
					Double dCurrentDen = null;
					if (dDenominator[0] == 0) {
						dCurrentNum = new Double(0);
					} else {
						dCurrentNum = new Double(dNumberator[0] / kpiEntity.getKpiMetaData().getDivision());
						dCurrentDen = new Double(dDenominator[0]);
					}
					cellsCurrent.getCells().add(new KPIEntityValueCell(dCurrentNum, dCurrentDen, state));

					Double dPreNum = null;
					Double dPreDen = null;
					if (dDenominator[1] == 0) {
						dPreNum = new Double(0);
					} else {
						dPreNum = new Double((dNumberator[1]) / kpiEntity.getKpiMetaData().getDivision());
						dPreDen = new Double((dDenominator[1]));
					}
					cellsPre.getCells().add(new KPIEntityValueCell(dPreNum, dPreDen, state));

					Double dBeforeNum = null;
					Double dBeforeDen = null;
					if (dDenominator[2] == 0) {
						dBeforeNum = new Double(0);
					} else {
						dBeforeNum = new Double((dNumberator[2]) / kpiEntity.getKpiMetaData().getDivision());
						dBeforeDen = new Double((dDenominator[2]));
					}
					cellsBefore.getCells().add(new KPIEntityValueCell(dBeforeNum, dBeforeDen, state));

					Double dYearNum = null;
					Double dYearDen = null;
					if (dDenominator[3] == 0) {
						dYearNum = new Double(0);
					} else {
						dYearNum = new Double((dNumberator[3]) / kpiEntity.getKpiMetaData().getDivision());
						dYearDen = new Double((dDenominator[3]));
					}
					cellsYear.getCells().add(new KPIEntityValueCell(dYearNum, dYearDen, state));
				}

				value.setCurrent(cellsCurrent);
				value.setPre(cellsPre);
				value.setBefore(cellsBefore);
				value.setYear(cellsYear);
			} catch (Exception e) {
				e.printStackTrace();
				LOG.error(entity.getKey() + ":" + entity.getName() + "计算失败" + e.getMessage(), e);
			}
		}
	}

	protected double[] calculate(KPIEntityValueState state, Object[] kpis, String entityKey, String[] signs) {
		double[] result = new double[4];
		KPIEntity.Entity entity1 = null;
		if (kpis[0] instanceof KPIEntity) {
			entity1 = (KPIEntity.Entity) ((KPIEntity) kpis[0]).getIndex().get(entityKey);// 先取第一个值付给result
			if (entity1 != null) {// 为空直接返回0
				result[0] = entity1.getCurrentValue(state);
				result[1] = entity1.getPreValue(state);
				result[2] = entity1.getBeforeValue(state);
				result[3] = entity1.getYearValue(state);
				for (int i = 1; i < kpis.length; i++) {
					calculate1(state, result, kpis[i], entityKey, signs, i);
				}
			}
		} else {
			result[0] = getConstant(kpis[0]);
			result[1] = result[0];
			result[2] = result[0];
			result[3] = result[0];
			for (int i = 1; i < kpis.length; i++) {
				calculate1(state, result, kpis[i], entityKey, signs, i);
			}
		}
		return result;
	}

	protected double[] calculate1(KPIEntityValueState state, double[] result, Object kpi, String entityKey, String[] signs, int i) {
		double[] value = new double[4];
		if (kpi instanceof KPIEntity) {
			KPIEntity.Entity entity1 = (KPIEntity.Entity) ((KPIEntity) kpi).getIndex().get(entityKey);
			if (entity1 != null) {
				value[0] = entity1.getCurrentValue(state);
				value[1] = entity1.getPreValue(state);
				value[2] = entity1.getBeforeValue(state);
				value[3] = entity1.getYearValue(state);
			}
		} else {
			value[0] = getConstant(kpi);
			value[1] = value[0];
			value[2] = value[0];
			value[3] = value[0];
		}
		result[0] = calculate2(result[0], value[0], signs, i);
		result[1] = calculate2(result[1], value[1], signs, i);
		result[2] = calculate2(result[2], value[2], signs, i);
		result[3] = calculate2(result[3], value[3], signs, i);
		return result;
	}

	protected double calculate2(double result, double dValue, String[] signs, int i) {
		if ("+".equals(signs[i - 1]))
			result += dValue;
		else if ("-".equals(signs[i - 1]))
			result -= dValue;
		else if ("*".equals(signs[i - 1]))
			result *= dValue;
		else if ("/".equals(signs[i - 1]))
			result /= dValue;
		return result;
	}

	/**
	 * 返回的Map(time_id,Map1) Map1(regionName,Double_Value)
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map loadDuring(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) throws KPIPortalException {

		kpiEntity.getKpiMetaData().parseArithmetic();
		String[] numZbCodes = kpiEntity.getKpiMetaData().numerator.split(",");
		String[] numSigns = kpiEntity.getKpiMetaData().numberatorSign.split(",");
		String[] denZbCodes = kpiEntity.getKpiMetaData().denominator.split(",");
		String[] denSigns = kpiEntity.getKpiMetaData().denominatorSign.split(",");

		Object[] numKpiMap = new Object[numZbCodes.length];
		Object[] denKpiMap = new Object[denZbCodes.length];

		// 初始化分子
		for (int i = 0; i < numKpiMap.length; i++) {
			numKpiMap[i] = KPIPortalService.getKPI(kpiEntity.getKpiAppData().getName(), kpiEntity.getDate(), numZbCodes[i]).getKpiEntityLoad().loadDuring(regionIds, state, timeStart, timeEnd);
		}
		// 初始化分母
		for (int i = 0; i < denKpiMap.length; i++) {

			if (!denZbCodes[i].matches("\\$.*")) {
				denKpiMap[i] = KPIPortalService.getKPI(kpiEntity.getKpiAppData().getName(), kpiEntity.getDate(), denZbCodes[i]).getKpiEntityLoad().loadDuring(regionIds, state, timeStart, timeEnd);

			} else {
				LOG.info("基础指标:" + denZbCodes[i] + "为常量");
				denKpiMap[i] = denZbCodes[i];
				constants.put(denZbCodes[i], denZbCodes[i]);
			}
		}
		Map map = (Map) numKpiMap[0];// 第一个必需不能是常量
		for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
			try {
				Map.Entry entry = (Map.Entry) iterator.next();// 每天的值time_id
				Map innerMap = (Map) entry.getValue();// 每个地域的值
				for (Iterator iterator2 = innerMap.entrySet().iterator(); iterator2.hasNext();) {
					Map.Entry innerEntry = (Map.Entry) iterator2.next();
					// 计算每个地域的值
					double dNumberator = calculateDuring(numKpiMap, state, (String) entry.getKey(), (String) innerEntry.getKey(), numSigns);
					double dDenominator = calculateDuring(denKpiMap, state, (String) entry.getKey(), (String) innerEntry.getKey(), denSigns);
					// 重构使用KPIEntityValue 20091229
					if (dDenominator == 0)
						innerEntry.setValue(duringGetValue(0d, state));
					else
						innerEntry.setValue(duringGetValue(dNumberator, dDenominator, state));
				}
			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		return map;
	}

	@SuppressWarnings("rawtypes")
	protected double calculateDuring(Object[] maps, KPIEntityValueState state, String outterKey, String innerKey, String[] signs) {
		double result = 0d;
		Map innerMap = null;
		if (maps[0] instanceof Map) {
			innerMap = (Map) ((Map) maps[0]).get(outterKey);
			if (innerMap != null && innerMap.containsKey(innerKey)) {
				KPIEntityValue entityValue = (KPIEntityValue) innerMap.get(innerKey);
				result = entityValue.getCurrentValue(state);
				for (int i = 1; i < maps.length; i++) {
					result = calculateDuring1(result, maps, state, outterKey, innerKey, signs, i);
				}
			}
		} else {
			result = getConstant(maps[0]);
			for (int i = 1; i < maps.length; i++) {
				result = calculateDuring1(result, maps, state, outterKey, innerKey, signs, i);
			}
		}
		return result;
	}

	@SuppressWarnings("rawtypes")
	protected double calculateDuring1(double result, Object[] maps, KPIEntityValueState state, String outterKey, String innerKey, String[] signs, int i) {
		double value = 0d;
		if (maps[i] instanceof Map) {
			Map innerMap = (Map) ((Map) maps[i]).get(outterKey);
			if (innerMap != null && innerMap.containsKey(innerKey)) {
				KPIEntityValue entityValue = (KPIEntityValue) innerMap.get(innerKey);
				value = entityValue.getCurrentValue(state);
				if ("+".equals(signs[i - 1]))
					result += value;
				else if ("-".equals(signs[i - 1]))
					result -= value;
				else if ("*".equals(signs[i - 1]))
					result *= value;
				else if ("/".equals(signs[i - 1]))
					result /= value;
			} else {
				result = 0d;
			}
		} else {
			value = getConstant(maps[i]);
		}
		/*
		 * if("+".equals(signs[i-1]))result +=value; else
		 * if("-".equals(signs[i-1]))result -=value; else
		 * if("*".equals(signs[i-1]))result *=value; else
		 * if("/".equals(signs[i-1]))result /=value;
		 */
		return result;
	}

	public double getConstant(Object key) {
		double result = 0d;

		try {
			String value = (String) constants.get(key);
			if (value.equalsIgnoreCase((String) key)) {
				if (value.replaceAll("\\$", "").matches("[0-9|\\.]*")) {
					value = value.replaceAll("\\$", "");
				} else if ("$date".equalsIgnoreCase(value)) {
					value = kpiEntity.getDate().substring(6, 8);
				}
			}
			result = Double.parseDouble(value);
		} catch (Exception e) {
			LOG.error("常量取得报错");
			e.printStackTrace();
		}
		return result;
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public KPIEntity loadNoCached(String parentRegionId) throws KPIPortalException {
		kpiEntity.getKpiMetaData().parseArithmetic();
		String[] numZbCodes = kpiEntity.getKpiMetaData().numerator.split(",");
		String[] denZbCodes = kpiEntity.getKpiMetaData().denominator.split(",");

		Object[] numKpi = new Object[numZbCodes.length];
		Object[] denKpi = new Object[denZbCodes.length];

		// 初始化分子
		for (int i = 0; i < numKpi.length; i++) {
			numKpi[i] = KPIPortalService.getKPI(kpiEntity.getKpiAppData().getName(), kpiEntity.getDate(), numZbCodes[i]).getKpiEntityLoad().loadNoCached(parentRegionId);

			if (numKpi[i] == null)
				return null;

		}
		// 初始化分母
		for (int i = 0; i < denKpi.length; i++) {
			if (!denZbCodes[i].matches("\\$.*")) {
				denKpi[i] = KPIPortalService.getKPI(kpiEntity.getKpiAppData().getName(), kpiEntity.getDate(), denZbCodes[i]).getKpiEntityLoad().loadNoCached(parentRegionId);

			} else {
				LOG.info("基础指标:" + denZbCodes[i] + "为常量");
				denKpi[i] = denZbCodes[i];
				constants.put(denZbCodes[i], denZbCodes[i]);
			}
		}

		KPIEntity newKPIEntity = (KPIEntity) numKpi[0];

		init(((KPIEntity) numKpi[0]).getIndex(), numKpi, denKpi);

		KPIEntity.Entity rootEntity = (KPIEntity.Entity) newKPIEntity.getRoot();

		Map cacheChildren = new HashMap();

		cacheChildren.put(rootEntity.getKey(), rootEntity);
		KPIEntity.Entity[] newlist = ((KPIEntity.Entity) newKPIEntity.getRoot()).getOrderChildren("current");
		for (int i = 0; i < 10 && i < newlist.length; i++) {
			cacheChildren.put(newlist[i].getKey(), newlist[i]);
		}

		((KPIEntity.Entity) kpiEntity.getIndex().get(parentRegionId)).setChildren(cacheChildren);

		return newKPIEntity;
	}

	public static void main(String[] args) {
		System.out.println("$1a.1".replaceAll("\\$", "").matches("[0-9|\\.]*"));
	}
}
