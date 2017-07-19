package com.asiainfo.hbbass.component.cache;

import java.util.HashMap;
import java.util.Map;

/**
 * CacheServerFactory
 * 
 * @author Mei Kefu
 * @date 2010-4-19
 * @date 2010-12-31 发现由于CacheServerL2CacheImpl 不是单例所有它的锁没有生效，有可能重复加载KPI，修改为单例模式
 */
public class CacheServerFactory {

	@SuppressWarnings("rawtypes")
	private Map map = new HashMap();

	private static CacheServerFactory factory = new CacheServerFactory();

	private CacheServerFactory() {

	}

	public static CacheServerFactory getInstance() {
		return factory;
	}

	@SuppressWarnings("unchecked")
	public CacheServerCache getCache(String name) {
		CacheServerCache cache = null;
		try {
			if (!map.containsKey(name)) {
				CacheServerL2CacheImpl.LOG.debug(name+"is  null");
				cache = new CacheServerL2CacheImpl(name);
				map.put(name, cache);
			} else {
				CacheServerL2CacheImpl.LOG.debug(name+"is not null");
				cache = (CacheServerCache) map.get(name);
			}
		} catch (Exception e) {
		
			e.printStackTrace();
		}
		return cache;
	}
}
