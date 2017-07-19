package com.asiainfo.hbbass.kpiportal.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueState;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;

/**
 * 
 * BIR用到，需要重构KPIPortalViewService，改写View层，使用json数据交换
 * 
 * @author Mei Kefu
 * @date 2010-3-2
 */
public class KPIPortalViewJsonService {

	private static Logger LOG = Logger.getLogger(KPIPortalViewJsonService.class);

	/**
	 * 取得单个Kpi
	 * 
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static Map getKpi(String appName, String zbCode, String date, String area, KPIEntityValueState state) {

		KPIEntity kpi = KPIPortalService.getKPI(appName, date, zbCode);

		return transferKpi(kpi, area, state);
	}

	/**
	 * 在相同的时间和appName中取得多个Kpi，这个效率更高 对外接口的包装，通过参数拿取KPIEntity的值
	 * 
	 * @param appName
	 * @param zbCodes
	 * @param date
	 *            可以不需要，当传null时就取本appName的最新一天的值
	 * @param area
	 *            可以不需要，当传null时就取全省
	 * @param state
	 * 
	 * @return json的list: [{kpi的属性},{}]
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static List getKpisUseAppName(String appName, String zbCodes, String date, String area, KPIEntityValueState state) {
		List result = new ArrayList();
		List list = new ArrayList();
		if (zbCodes != null && !"all".equalsIgnoreCase(zbCodes) && !"income".equalsIgnoreCase(zbCodes) && !"traffic".equalsIgnoreCase(zbCodes) && !"user".equalsIgnoreCase(zbCodes) && !"vas".equalsIgnoreCase(zbCodes) && !"chlrec".equalsIgnoreCase(zbCodes) && !"chluser".equalsIgnoreCase(zbCodes)
				&& zbCodes.split(",").length == 1) { // 取单个KPI

			Map map = getKpi(appName, zbCodes, date, area, state);

			if (map != null && map.size() > 0)
				result.add(map);

		} else {// 取多zbCode的情况

			Map map = KPIPortalService.getKPIMap(appName, date);

			if (map != null) {
				if (zbCodes == null || "all".equalsIgnoreCase(zbCodes)) {
					for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
						Map.Entry object = (Map.Entry) iterator.next();
						if (object.getValue() != null)
							list.add(object.getValue());
					}
				} else if ("income".equalsIgnoreCase(zbCodes) || "traffic".equalsIgnoreCase(zbCodes) || "user".equalsIgnoreCase(zbCodes) || "vas".equalsIgnoreCase(zbCodes) || "chlrec".equalsIgnoreCase(zbCodes) || "chluser".equalsIgnoreCase(zbCodes)) {
					for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
						Map.Entry object = (Map.Entry) iterator.next();
						KPIEntity kpi = (KPIEntity) object.getValue();
						if (kpi != null && zbCodes.equalsIgnoreCase(kpi.getKind()))
							list.add(kpi);
					}
				} else {
					String[] arr = zbCodes.split(",");
					for (int i = 0; i < arr.length; i++) {
						if (map.containsKey(arr[i]) && map.get(arr[i]) != null)
							list.add(map.get(arr[i]));
					}
				}
			}

			for (int i = 0; i < list.size(); i++) {
				KPIEntity kpiEntry = (KPIEntity) list.get(i);
				result.add(transferKpi(kpiEntry, area, state));
			}
		}

		LOG.debug("appName" + appName + " zbCodes" + zbCodes + " date" + date + " list.size" + list.size());
		return result;
	}

	/**
	 * 在不同的时间和appName中取得多个Kpi
	 * 
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static List getKpis(List kpis, KPIEntityValueState state) {
		List result = new ArrayList();
		for (int i = 0; i < kpis.size(); i++) {

			Map map = (Map) kpis.get(i);

			String appName = (String) map.get("appname");
			String zbCode = (String) map.get("zbcode");
			String date = (String) map.get("date");
			String area = (String) map.get("area");
			Map obj = (Map) getKpi(appName, zbCode, date, area, state);

			if (obj != null && obj.size() > 0)
				result.add(obj);
		}

		return result;
	}

	/**
	 * 把KPIEntity对象转换成Map,方便转成Json字符串
	 * 
	 * @param kpiEntry
	 * @param entry
	 * @param state
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected static Map transferKpi(KPIEntity kpiEntry, String area, KPIEntityValueState state) {

		Map kpiProperty = new HashMap();

		if (kpiEntry != null) {

			if (area == null || area.length() == 0) {// area为空就取全省
				area = "HB";
			}

			KPIEntity.Entity entry = (KPIEntity.Entity) kpiEntry.getIndex().get(area);

			if (entry != null) {

				kpiProperty.put("id", kpiEntry.getId());
				kpiProperty.put("name", kpiEntry.getName());
				kpiProperty.put("appName", kpiEntry.getKpiAppData().getName());
				kpiProperty.put("date", kpiEntry.getDate());
				kpiProperty.put("instruction", kpiEntry.getKpiMetaData().getInstruction());
				if (kpiEntry.getKpiMetaData().getFormatType().length() > 0)
					kpiProperty.put("formatType", kpiEntry.getKpiMetaData().getFormatType());
				if (kpiEntry.getKpiMetaData().getTargetType().length() > 0)
					kpiProperty.put("targetType", kpiEntry.getKpiMetaData().getTargetType());

				/*
				 * if(kpiEntry.getKpiMetaData().getTargetValue()!=0){
				 * kpiProperty.put("targetValue",
				 * kpiEntry.getKpiMetaData().getTargetValue()); }
				 */

				kpiProperty.put("current", KPIPortalContext.DECIMAL_FORMAT.format(entry.getCurrentValue(state)));

				kpiProperty.put("pre", KPIPortalContext.DECIMAL_FORMAT.format(entry.getPreValue(state)));

				kpiProperty.put("before", KPIPortalContext.DECIMAL_FORMAT.format(entry.getBeforeValue(state)));

				kpiProperty.put("huanbi", entry.getHuanBi());
				kpiProperty.put("tongbi", entry.getTongBi());

				if (kpiEntry.getDate().length() == 8) {
					kpiProperty.put("year", KPIPortalContext.DECIMAL_FORMAT.format(entry.getYearValue(state)));

					kpiProperty.put("yeartongbi", entry.getYearTongBi());
				}
				kpiProperty.put("progress", entry.getProgress());
				kpiProperty.put("target", entry.getTarget());
			}
		}
		return kpiProperty;
	}
}
