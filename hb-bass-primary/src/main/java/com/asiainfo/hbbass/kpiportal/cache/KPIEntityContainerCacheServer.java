package com.asiainfo.hbbass.kpiportal.cache;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

//import org.apache.log4j.Logger;

import com.asiainfo.hbbass.kpiportal.core.KPIEntityCache;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityContainer;

/**
 * 使用ehcache server
 * 
 * @author Mei Kefu
 * @date 2010-4-15
 */
public class KPIEntityContainerCacheServer implements KPIEntityContainer {

	// private static Logger LOG =
	// Logger.getLogger(KPIEntityContainerCacheServer.class);

	@SuppressWarnings("rawtypes")
	private static Map map = new HashMap();

	@SuppressWarnings("unchecked")
	public KPIEntityCache getCache(String name) {
		KPIEntityCache cache = null;
		cache = (KPIEntityCacheCacheServer) map.get(name);
		if (cache == null) {
			cache = new KPIEntityCacheCacheServer(name);
			map.put(name, cache);
		}
		return cache;
	}

	@SuppressWarnings("rawtypes")
	public KPIEntityCache[] getCaches() {
		// String[] names = cacheManager.getCacheNames();

		KPIEntityCache[] caches = new KPIEntityCache[map.size()];
		int i = 0;
		for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();
			caches[i] = (KPIEntityCache) entry.getValue();
			i++;
		}
		return caches;
	}
}
