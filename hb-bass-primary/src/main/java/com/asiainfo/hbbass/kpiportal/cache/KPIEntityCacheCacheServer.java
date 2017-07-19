package com.asiainfo.hbbass.kpiportal.cache;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.component.cache.CacheServerCache;
import com.asiainfo.hbbass.component.cache.CacheServerFactory;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityCache;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityInitialize;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;

/**
 * 使用ehcache server
 * 
 * @author Mei Kefu
 * @date 2010-4-15
 * 
 * @date 2010-4-20 修改getKPIEntities方法使其更合理
 */
public class KPIEntityCacheCacheServer implements KPIEntityCache {

	private CacheServerCache cache = null;

	private Logger LOG = Logger.getLogger(KPIEntityCacheCacheServer.class);

	public KPIEntityCacheCacheServer(String name) {
		cache = CacheServerFactory.getInstance().getCache(name);
		holderTimes = new HashMap<String,Integer>();
		
		holderTimes.put("ChannelD", 30);
		holderTimes.put("ChannelM", 12);
		holderTimes.put("BureauD", 6);
		holderTimes.put("BureauM", 6);
		holderTimes.put("CollegeD", 6);
		holderTimes.put("CollegeM", 6);
	}

	@SuppressWarnings("rawtypes")
	public KPIEntity getKPIEntity(String date, String zbCode) {
		KPIEntity kpiEntity = (KPIEntity) cache.get(date, zbCode);

		if (kpiEntity == null) {
			Map map = getKPIEntities(date);
			if (map != null) {
				kpiEntity = (KPIEntity) map.get(zbCode);
			}
		}
		return kpiEntity;
	}

	private byte[] lock = new byte[0];
	
	
	private Map<String,Integer> holderTimes;
	private DateFormat df = new SimpleDateFormat("yyyyMMdd");
	
	@SuppressWarnings("rawtypes")
	public Map getKPIEntities(String date) {
		Object obj = cache.get(date);
		if (obj == null) {
			synchronized (lock) {
				LOG.debug("锁定对象：" + cache.getName() + " date:" + date);
				obj = cache.get(date);
				if (obj == null) {
					Map map = KPIEntityInitialize.initKpisMap(cache.getName(), date);
					
					if(holderTimes.containsKey(cache.getName())){
						
						String defaultDate = KPIPortalContext.getAppDefaultDate(cache.getName());
						
						Calendar c = null;
						int minDate = 0;
						if(date.length()==8){
							c = new GregorianCalendar(Integer.parseInt(defaultDate.substring(0, 4)), Integer.parseInt(defaultDate.substring(4, 6))-1, Integer.parseInt(defaultDate.substring(6, 8)));
							c.add(Calendar.DATE, -1*holderTimes.get(cache.getName()));
							minDate = Integer.parseInt(df.format(c.getTime()));
						}else{
							c = new GregorianCalendar(Integer.parseInt(defaultDate.substring(0, 4)), Integer.parseInt(defaultDate.substring(4, 6))-1, 1);
							c.add(Calendar.MONTH, -1*holderTimes.get(cache.getName()));
							minDate = Integer.parseInt(df.format(c.getTime()).substring(0,6));
						}
						
						int maxDate = Integer.parseInt(defaultDate);
						int curDate = Integer.parseInt(date);
						if(curDate >= minDate && curDate <= maxDate){
							putKPIEntity(date, map);
						}
					}else{
						putKPIEntity(date, map);
					}
					
					return map;// 这里不用删除是为了防止，加载一天的指标的时候发起的两个请求，后面一个请求又加载了一遍。通过后面这个请求来删除
				} else {
					Map map = (Map) obj;
					if (map == null || map.size() < 5) {
						removeKPIEntity(date);
						return new HashMap();
					} else {
						return map;
					}
				}
			}
		} else {
			Map map = (Map) obj;
			if (map == null || map.size() < 5) {
				synchronized (lock) {// 先锁对象会造成，在加载其他的指标时，阻塞了其他已经加载过的指标
					/*
					 * map = (Map)obj; if( map==null || map.size()<5 ){
					 * removeKPIEntity(date); return new HashMap(); }else{
					 * return map; }
					 */
					removeKPIEntity(date);
					return new HashMap();
				}
			} else {
				return map;
			}
		}
		/*
		 * Map map = (Map)obj; if(map!=null && map.size()==0){ synchronized
		 * (this){ map = (Map)cache.get(date);
		 * 
		 * if(map==null||map.size()==0){ map =
		 * KPIEntityInitialize.initKpi(cache.getName(),date); putKPIEntity(date,
		 * map); } } } if(map!=null && map.size()==0) map =
		 * (Map)cache.get(date);
		 * 
		 * if( map==null || map.size()==0 ){ removeKPIEntity(date); } return
		 * map;
		 */
	}

	@SuppressWarnings("rawtypes")
	public void putKPIEntity(String date, Map map) {
		cache.put(date, map);
	}

	public void removeKPIEntity(String date) {
		cache.remove(date);
	}

	@SuppressWarnings("rawtypes")
	public List getKeys() {
		return cache.getKeys();
	}

	public int size() {
		return cache.getSize();
	}

	public String getName() {
		return cache.getName();
	}

}
