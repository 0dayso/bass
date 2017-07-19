package com.asiainfo.hbbass.kpiportal.cache;

import java.util.List;
import java.util.Map;

import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityCache;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityInitialize;

import net.sf.ehcache.Cache;
import net.sf.ehcache.Element;
@SuppressWarnings({"rawtypes"})
public class KPIEntityCacheEhCache implements KPIEntityCache {

	private Cache cache = null;

	public KPIEntityCacheEhCache() {
		super();
	}

	public KPIEntityCacheEhCache(Cache cache) {
		super();
		this.cache = cache;
	}

	public Cache getCache() {
		return cache;
	}

	public void setCache(Cache cache) {
		this.cache = cache;
	}

	public KPIEntity getKPIEntity(String date, String zbCode) {
		return (KPIEntity) getKPIEntities(date).get(zbCode);
	}

	private byte[] lock = new byte[0];
	@SuppressWarnings("deprecation")
	public Map getKPIEntities(String date) {
		Element element = cache.get(date);
		if (element == null) {
			synchronized (lock) {
				element = cache.get(date);
				if (element == null) {
					Map map = KPIEntityInitialize.initKpisMap(cache.getName(), date);
					element = new Element(date, map);
					cache.put(element);
				}
			}
		}

		
		Map map = (Map) element.getValue();
		if (map.size() == 0) {
			synchronized (lock) {
				element = cache.get(date);
				if (element != null) {
					map = (Map) cache.get(date).getValue();
				}
				if (element == null || map.size() == 0) {
					map = KPIEntityInitialize.initKpisMap(cache.getName(), date);
					putKPIEntity(date, map);
				}
			}
		}
		map = (Map) cache.get(date).getValue();
		if (map == null || map.size() == 0)
			cache.remove(date);
		return map;
	}

	public void putKPIEntity(String date, Map map) {
		cache.put(new Element(date, map));
	}

	public void removeKPIEntity(String date) {
		cache.remove(date);
	}

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
