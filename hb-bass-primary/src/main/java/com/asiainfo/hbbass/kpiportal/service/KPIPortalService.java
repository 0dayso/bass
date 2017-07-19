package com.asiainfo.hbbass.kpiportal.service;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.kpiportal.core.KPIAppData;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityCache;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityContainer;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityContainerFactory;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityInitialize;
import com.asiainfo.hbbass.kpiportal.core.KPIMetaData;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;

/**
 * 缓存的外部访问接口
 * 
 * @author Mei Kefu
 * 
 */
public class KPIPortalService {
	private static Logger LOG = Logger.getLogger(KPIPortalService.class);

	private static KPIEntityContainer kpiEntityContainer = KPIEntityContainerFactory.getInstance();

	/**
	 * 查找单个Entity
	 * 
	 * @param appName
	 *            : kpi应用的名称
	 * @param date
	 *            : 时间
	 * @param zbCode
	 *            : 指标编码
	 * @param regionId
	 *            : 地域维度
	 * @return
	 */
	public static KPIEntity.Entity getKPIEntity(String appName, String date, String zbCode, String regionId) {
		return getKPIEntity(getKPI(appName, date, zbCode), regionId);
	}

	/**
	 * 查找单个Entity
	 * 
	 * @param kpiEntity
	 *            :
	 * @param regionId
	 *            : 地域维度
	 * @return
	 */
	public static KPIEntity.Entity getKPIEntity(KPIEntity kpiEntity, String regionId) {
		if (kpiEntity != null) {
			KPIEntity.Entity entity = (KPIEntity.Entity) kpiEntity.getIndex().get(regionId);
			if (entity != null && entity.getChildren() == null) {
				LOG.info("加载子节点,zbCode:" + kpiEntity.getId() + "name:" + entity.getName());
				getNoCachedKPI(kpiEntity, regionId);
			}
			return entity;
		} else {
			return null;
		}

	}

	protected static KPIEntity getNoCachedKPI(String appName, String date, String zbCode, String regionId) {
		return getNoCachedKPI(getKPI(appName, date, zbCode), regionId);
	}

	protected static KPIEntity getNoCachedKPI(KPIEntity kpiEntity, String regionId) {
		return kpiEntity.getKpiEntityLoad().loadNoCached((String) regionId);
	}

	/**
	 * 
	 * @param appName
	 *            : kpi应用的名称
	 * @param date
	 *            : 时间
	 * @param zbCode
	 *            : 指标编码
	 * @return
	 */
	public static KPIEntity getKPI(String appName, String date, String zbCode) {
		/*
		 * Map map = getKPIMap(appName, date); return (KPIEntity)
		 * map.get(zbCode);
		 */
		// 2010-4-16 修改KPI的取值方法，为了cacheserver取了多

		// 2010-5-31 直接去取单独的KPI偶尔会报序列化错误
		/*
		 * if(date==null || date.length()==0){ date =
		 * getKPIAppData(appName).getCurrent(); } KPIEntityCache kpiEntityCache
		 * = kpiEntityContainer.getCache(appName); return
		 * kpiEntityCache.getKPIEntity(date, zbCode);
		 */
		return (KPIEntity) getKPIMap(appName, date).get(zbCode);
	}

	@SuppressWarnings("rawtypes")
	public static KPIEntity getFirstKPI(String appName, String date, String zbCodes) {
		// 如果为单指标就只取单指标 2010-4-16
		if (zbCodes != null && !"all".equalsIgnoreCase(zbCodes) && !"income".equalsIgnoreCase(zbCodes) && !"traffic".equalsIgnoreCase(zbCodes) && !"user".equalsIgnoreCase(zbCodes) && !"vas".equalsIgnoreCase(zbCodes) && !"chlrec".equalsIgnoreCase(zbCodes) && !"chluser".equalsIgnoreCase(zbCodes)
				&& zbCodes.split(",").length == 1) {

			return getKPI(appName, date, zbCodes);
		} else {
			Map map = getKPIMap(appName, date);
			if (map == null)
				return null;
			if (zbCodes == null || "all".equalsIgnoreCase(zbCodes)) {
				for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
					Map.Entry object = (Map.Entry) iterator.next();
					if (object.getValue() != null)
						return (KPIEntity) object.getValue();
				}
			} else if ("income".equalsIgnoreCase(zbCodes) || "traffic".equalsIgnoreCase(zbCodes) || "user".equalsIgnoreCase(zbCodes) || "vas".equalsIgnoreCase(zbCodes) || "chlrec".equalsIgnoreCase(zbCodes) || "chluser".equalsIgnoreCase(zbCodes)) {
				for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
					Map.Entry object = (Map.Entry) iterator.next();
					KPIEntity kpi = (KPIEntity) object.getValue();
					if (kpi != null && zbCodes.equalsIgnoreCase(kpi.getKind()))
						return kpi;
				}
			} else {
				String[] arr = zbCodes.split(",");
				for (int i = 0; i < arr.length; i++) {
					if (map.containsKey(arr[i]) && map.get(arr[i]) != null)
						return (KPIEntity) map.get(arr[i]);
				}
			}
		}
		return null;
	}

	/**
	 * 
	 * @param appName
	 *            : kpi应用的名称
	 * @param date
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static Map getKPIMap(String appName, String date) {
		KPIEntityCache kpiEntityCache = kpiEntityContainer.getCache(appName);

		// 2010-3-2修改成支持date为null
		if (date == null || date.length() == 0) {
			String tmpDate = getKPIAppData(appName).getCurrent();
			return kpiEntityCache.getKPIEntities(tmpDate);
		} else {
			return kpiEntityCache.getKPIEntities(date);
		}
	}

	public static KPIAppData getKPIAppData(String appName) {
		return (KPIAppData) KPIPortalContext.getKpiApp().get(appName);
	}

	/**
	 * 
	 * @param appName
	 *            : kpi应用的名称
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static Map getAKPIMap(String appName) {

		KPIEntityCache kpiEntityCache = kpiEntityContainer.getCache(appName);
		Map map = getKPIMap(appName, getKPIAppData(appName).getCurrent());
		if (map == null || map.size() == 0) {
			List list = kpiEntityCache.getKeys();
			for (int i = 0; i < list.size(); i++) {
				map = kpiEntityCache.getKPIEntities((String) list.get(i));
				if (map != null && map.size() > 0)
					break;
			}
		}
		return map;
	}

	/**
	 * 
	 * @param appName
	 *            : kpi应用的名称
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static KPIEntity getAKPIEntity(String appName) {
		KPIEntity kpiEntity = null;

		Map map = getAKPIMap(appName);

		for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry obj = (Map.Entry) iterator.next();

			kpiEntity = (KPIEntity) obj.getValue();
			if (kpiEntity.getIndex().size() > 0)
				break;
		}

		return kpiEntity;
	}

	/**
	 * 更新缓存内容删除掉过期的实体 锁防止另外的线程读到null
	 * 
	 * 
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void updateIndex() {
		KPIEntityCache[] caches = kpiEntityContainer.getCaches();

		for (int j = 0; j < caches.length; j++) {

			KPIEntityCache kpiEntityCache = caches[j];

			LOG.info("开始清除过期的缓存,缓存天数为:" + kpiEntityCache.size());
			Calendar calendar = GregorianCalendar.getInstance();

			calendar.add(Calendar.DATE, -7);

			String expireDate = KPIPortalContext.DAILY_FORMAT.format(calendar.getTime());

			Set removeSet = new HashSet();
			try {
				List list = kpiEntityCache.getKeys();

				for (int i = 0; i < list.size(); i++) {
					String date = (String) list.get(i);
					LOG.info("判断日期:" + date);
					if (date.length() == 8 && Integer.parseInt(expireDate) > Integer.parseInt(date))
						removeSet.add(date);
					else if (date.length() == 6 && !(date.equalsIgnoreCase(getKPIAppData(kpiEntityCache.getName()).getCurrent()) || date.equalsIgnoreCase(getKPIAppData(kpiEntityCache.getName()).getPre())))
						removeSet.add(date);
				}

				synchronized (kpiEntityCache) {
					for (Iterator iterator = removeSet.iterator(); iterator.hasNext();) {
						String removeDate = (String) iterator.next();
						kpiEntityCache.removeKPIEntity(removeDate);
						LOG.info("清除日期：" + removeDate);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				LOG.error(e.getMessage(), e);
			}
			LOG.info("完成清除过期的缓存,缓存天数为:" + kpiEntityCache.size());
		}
	}

	/**
	 * 刷新KpiEntry
	 * 
	 * @param appName
	 *            : kpi应用的名称
	 * @param date
	 *            : 时间
	 * @param zbCode
	 *            : 指标编码
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void refreshKPIEntity(String appName, String date, String zbCode) {
		LOG.info("重新加载:" + zbCode + "，日期：" + date);
		if (zbCode != null) {
			Map map = getKPIMap(appName, date);

			KPIEntity kpi = (KPIEntity) map.get(zbCode);
			if (kpi != null) {
				map.put(kpi.getId(), kpi.clone());
			} else {// 修改没有在map中的时候从配置文件加载
				KPIPortalContext.parse();
				List list = (List) KPIPortalContext.KPI_META.get(appName);
				KPIAppData appData = (KPIAppData) KPIPortalContext.getKpiApp().get(appName);
				KPIMetaData kpiMetaData = null;
				for (int i = 0; i < list.size(); i++) {
					kpiMetaData = (KPIMetaData) list.get(i);
					if (zbCode.equalsIgnoreCase(kpiMetaData.getId()))
						break;
				}
				KPIEntityInitialize.initKPIEntity(date, appData, kpiMetaData, map,null);
				LOG.info(appName + " " + date + ":加载完成" + map.size());
			}
			// 增加这段代码，使用CacheServer必须重新put一次
			KPIEntityCache kpiEntityCache = KPIEntityContainerFactory.getInstance().getCache(appName);
			kpiEntityCache.putKPIEntity(date, map);
		}
	}

	@SuppressWarnings("rawtypes")
	public static void refreshKPIEntities(String appName, String date) {
		if (date == null || date.length() == 0) {
			date = ((KPIAppData) KPIPortalContext.getKpiApp().get(appName)).getCurrent();
		}
		LOG.info("重新加载日期：" + date);
		Map map = KPIEntityInitialize.initKpisMap(appName, date);
		KPIEntityCache kpiEntityCache = KPIEntityContainerFactory.getInstance().getCache(appName);
		kpiEntityCache.removeKPIEntity(date);
		kpiEntityCache.putKPIEntity(date, map);
	}
}
