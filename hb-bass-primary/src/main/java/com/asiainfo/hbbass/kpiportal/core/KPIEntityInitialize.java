package com.asiainfo.hbbass.kpiportal.core;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.log4j.Logger;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hbbass.kpiportal.load.KpiDataStore;
import com.asiainfo.hbbass.kpiportal.service.KPIPortalService;

/**
 * Web容器启动的时候整体加载KPI
 * 
 * @author Mei Kefu
 * 
 */
public class KPIEntityInitialize {
	private static Logger LOG = Logger.getLogger(KPIEntityInitialize.class);

	@SuppressWarnings("rawtypes")
	public static void initialize() {
		Map map = KPIPortalContext.getKpiApp();
		for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();
			KPIAppData appData = (KPIAppData) entry.getValue();
			initialize(appData.getName());
		}
		
		Thread thread = new Thread(new Runnable() {
			@Override
			public void run() {
				try {
					Thread.sleep(10000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				LOG.info("开始加载缓存历史数据");
				KPIEntityInitialize.loadHolderKpi();
			}
		});
		thread.start();
//		initialize("ChannelD");
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static void loadHolderKpi(){
		Map<String,Integer> holderTimes = new HashMap<String,Integer>();
		holderTimes.put("ChannelD", 30);
		holderTimes.put("ChannelM", 12);
		holderTimes.put("BureauD", 5);
		holderTimes.put("BureauM", 5);
		holderTimes.put("CollegeD", 5);
		holderTimes.put("CollegeM", 5);
		
		
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		
		for (Iterator iterator = holderTimes.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry<String, Integer> entry = (Map.Entry<String, Integer>) iterator.next();
			String appName = entry.getKey();
			Calendar c = null;
			if(holderTimes.containsKey(appName)){
				int times = holderTimes.get(appName);
				KPIAppData appData = (KPIAppData) KPIPortalContext.getKpiApp().get(appName);
				String current = appData.getCurrent();
				if(current.length()==8){
					c = new GregorianCalendar(Integer.valueOf(current.substring(0, 4)), Integer.valueOf(current.substring(4, 6))-1, Integer.valueOf(current.substring(6, 8)));
				}else{
					c = new GregorianCalendar(Integer.valueOf(current.substring(0, 4)), Integer.valueOf(current.substring(4, 6))-1, 1);
				}
				
				KPIEntityCache kpiEntityCache = KPIEntityContainerFactory.getInstance().getCache(appName);
				for (int i = 0; i < times; i++) {
					String date ="";
					if(current.length()==8){
						c.add(Calendar.DATE, -1);
						date = df.format(c.getTime());
					}else{
						c.add(Calendar.MONTH, -1);
						date = df.format(c.getTime()).substring(0,6);
					}
					
					if (kpiEntityCache.getKPIEntities(date).size() == 0) {
						kpiEntityCache.putKPIEntity(date, initKpisMap(appName, date));
					}
				}
			}
			
		}
		
	}
			

	/**
	 * 容器启动的时候加载，如果缓存中存在就不在加载了，如果要重新刷新缓存不能使用这个方法，要使用
	 * {@link KPIPortalService.refreshKPIEntities}
	 * 
	 * @param appName
	 */
	public static void initialize(String appName) {

		LOG.info("初始化KPI应用:" + appName);

		KPIEntityCache kpiEntityCache = KPIEntityContainerFactory.getInstance().getCache(appName);
		KPIAppData appData = (KPIAppData) KPIPortalContext.getKpiApp().get(appName);
		if (kpiEntityCache.getKPIEntities(appData.getCurrent()).size() == 0) {
			// 2010-4-16使用cacheserver，这部分代码是在初始化的servlet中运行，需要判断cache中是否已经存在
			kpiEntityCache.putKPIEntity(appData.getCurrent(), initKpisMap(appData.getName(), appData.getCurrent()));
		}
		// process(KPIEntityContainerFactory.getInstance().getCache(appName),
		// (KPIAppData)KPIPortalContext.getKpiApp().get(appName));
	}

	/*
	 * protected static void process(KPIEntityCache kpiEntityCache, KPIAppData
	 * appData){
	 * 
	 * if(kpiEntityCache.getKPIEntities(appData.getCurrent()).size()==0){
	 * //2010-4-16使用cacheserver，这部分代码是在初始化的servlet中运行，需要判断cache中是否已经存在
	 * kpiEntityCache.putKPIEntity(appData.getCurrent(),
	 * initKpi(appData.getName(), appData.getCurrent())); } }
	 */

	/**
	 * 
	 * @param date
	 * @param appName
	 * @param kpiId
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static KPIEntity loadKPIEntity(String date, String appName, String kpiId) {
		if (date == null) {
			return null;
		}
		KPIAppData appData = (KPIAppData) KPIPortalContext.getKpiApp().get(appName);
		List list = (List) KPIPortalContext.KPI_META.get(appName);
		KPIMetaData kpiMetaData = null;
		for (int i = 0; i < list.size(); i++) {
			kpiMetaData = (KPIMetaData) list.get(i);
			if (kpiId.equalsIgnoreCase(kpiMetaData.getId())) {
				break;
			}
		}
		return initKPIEntity(date, appData, kpiMetaData, null,null);
	}

	/**
	 * 初始化一整天的KPIEntity
	 */
	@SuppressWarnings("rawtypes")
	public static Map initKpisMap(String appName, String date) {
		LOG.info(date + ":开始初始化KPI");

		KPIPortalContext.parse();

		List list = (List) KPIPortalContext.KPI_META.get(appName);

		KPIAppData appData = (KPIAppData) KPIPortalContext.getKpiApp().get(appName);

		//Map checkMap = dataQualityMap(date, "");

		//增加批量从数据库中查询
		KpiDataStore kpiDataStore = new KpiDataStore(appName,date);
		
		Map map = new TreeMap();
		for (int i = 0; i < list.size(); i++) {
			KPIMetaData kpiMetaData = (KPIMetaData) list.get(i);
			/*String kpiId = kpiMetaData.getId();
			//if (checkMap == null || !checkMap.containsKey(kpiId) || (checkMap.containsKey(kpiId) && "0".equalsIgnoreCase(String.valueOf(checkMap.get(kpiId))))) {
				initKPIEntity(date, appData, kpiMetaData, map);
			/*} else {
				LOG.warn("质量稽核不通过，不加载该Kpi");
			}*/
			initKPIEntity(date, appData, kpiMetaData, map,kpiDataStore);
		}
		LOG.info(appName + " " + date + ":加载完成" + map.size());
		return map;
	}

	/**
	 * 
	 */
	@SuppressWarnings({ "unused", "rawtypes" })
	private static Map dataQualityMap(String date, String kpiId) {
		String checkUri = "http://10.25.124.46/ldc_new/dqCheck";
		HttpClient client = new HttpClient();
		try {
			// String uri=checkUri.replaceAll("\\{date\\}",
			// date).replaceAll("\\{kpiId\\}", kpiId);
			PostMethod method = new PostMethod(checkUri);
			method.addParameter("OP_TIME", date);
			method.addParameter("ZBCODE", kpiId);
			int code = client.executeMethod(method);
			if (code == 200) {
				String str = method.getResponseBodyAsString();
				Object obj = JsonHelper.getInstance().read(str);
				if (obj instanceof Map) {
					return (Map) obj;
				}
			} else {
				LOG.error("链接返回状态不正确：" + code);
			}
			method.releaseConnection();
		} catch (Exception e) {
			LOG.error("链接不正确：" + e.getMessage(), e);
		}
		return null;
	}

	/**
	 * 初始化一个KPIEntity
	 * 
	 * @param date
	 * @param appData
	 * @param kpiMetaData
	 * @return
	 * @throws ClassNotFoundException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static KPIEntity initKPIEntity(String date, KPIAppData appData, KPIMetaData kpiMetaData, Map map,KpiDataStore kpiDataStore) {
		KPIEntity kpiEntity = null;
		if(date.length()==8||date.length()==6){
			try {
				kpiEntity = new KPIEntity();
				kpiEntity.setDate(date);
				kpiEntity.setKpiAppData(appData);
				kpiEntity.setKpiMetaData(kpiMetaData);
				KPIMetaData kpiMetaData1 = kpiEntity.getKpiMetaData();
				Class cls = Class.forName(kpiMetaData1.getLoadClassName());
				kpiEntity.setKpiEntityLoad((KPIEntityLoad) cls.newInstance());
				if (kpiEntity.getKpiMetaData().getFilterClassName().length() > 0) {
					LOG.info(kpiEntity.getId() + "的ValueFiter：" + kpiEntity.getKpiMetaData().getFilterClassName());
					cls = Class.forName(kpiEntity.getKpiMetaData().getFilterClassName());
					kpiEntity.setValueFilter((KPIEntityValueFilter) cls.newInstance());
				}
				kpiEntity.getKpiEntityLoad().setKpiEntity(kpiEntity);

				if (map != null) {
					kpiEntity.getKpiEntityLoad().setKpiEntityMap(map);// 这个必须在load前面
				}

				kpiEntity = kpiEntity.getKpiEntityLoad().load(kpiDataStore);// load方法的返回值直接赋给KPI

				if (map != null && kpiEntity.getIndex().size() > 0) {
					map.put(kpiEntity.getId(), kpiEntity);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else{
			LOG.error("周期不正确 date["+date+"]" );
		}
		
		return kpiEntity;
	}

	/**
	 *不在使用该方法，使用缓存自行清理
	 * @param appName
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void updateIndex(String appName) {
		KPIEntityCache kpiEntityCache = KPIEntityContainerFactory.getInstance().getCache(appName);
		LOG.info("开始清除过期的缓存,缓存天数为:" + kpiEntityCache.size());
		Calendar calendar = GregorianCalendar.getInstance();

		calendar.add(Calendar.DATE, -7);

		String expireDate = KPIPortalContext.DAILY_FORMAT.format(calendar.getTime());

		Set removeSet = new HashSet();
		try {

			for (int i = 0; i < kpiEntityCache.getKeys().size(); i++) {

				String date = (String) kpiEntityCache.getKeys().get(i);
				LOG.info("判断日期:" + date);
				if (date.length() == 8 && Integer.parseInt(expireDate) > Integer.parseInt(date))
					removeSet.add(date);
				else if (date.length() == 6 && !(date.equalsIgnoreCase(((KPIAppData) KPIPortalContext.getKpiApp().get(appName)).getCurrent()) || date.equalsIgnoreCase(((KPIAppData) KPIPortalContext.getKpiApp().get(appName)).getPre())))
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
