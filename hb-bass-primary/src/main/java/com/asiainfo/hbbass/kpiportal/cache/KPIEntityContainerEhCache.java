package com.asiainfo.hbbass.kpiportal.cache;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import net.sf.ehcache.CacheManager;

import com.asiainfo.hbbass.kpiportal.core.KPIEntityCache;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityContainer;

public class KPIEntityContainerEhCache implements KPIEntityContainer {

	private static Logger LOG = Logger.getLogger(KPIEntityContainerEhCache.class);

	private CacheManager cacheManager = null;

	public KPIEntityContainerEhCache() {
		try {
			cacheManager = CacheManager.create(KPIEntityContainerEhCache.class.getClassLoader().getResourceAsStream("hbbass_ehcache.xml"));
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error("初始化CacheManger失败：" + e.getMessage(), e);
		}
	}

	@SuppressWarnings("rawtypes")
	private static Map map = new HashMap();

	@SuppressWarnings("unchecked")
	public KPIEntityCache getCache(String name) {
		KPIEntityCacheEhCache cache = null;
		cache = (KPIEntityCacheEhCache) map.get(name);
		if (cache == null) {
			cache = new KPIEntityCacheEhCache(cacheManager.getCache(name));
			map.put(name, cache);
		}
		return cache;
	}

	public KPIEntityCache[] getCaches() {
		String[] names = cacheManager.getCacheNames();

		KPIEntityCache[] caches = new KPIEntityCache[names.length];

		for (int i = 0; i < caches.length; i++) {
			caches[i] = getCache(names[i]);
		}
		return caches;
	}
}
