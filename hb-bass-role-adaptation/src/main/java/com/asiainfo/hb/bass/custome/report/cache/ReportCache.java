package com.asiainfo.hb.bass.custome.report.cache;

import org.springframework.stereotype.Component;

import com.asiainfo.hb.core.cache.CacheServer;
import com.asiainfo.hb.core.cache.CacheServerFactory;

@Component
public class ReportCache {
	private CacheServer cache = null;

	public ReportCache() {
		this.cache = CacheServerFactory.getInstance().getCache("report");
	}

	public Object get(String key) {
		Object obj = this.cache.get(key);
		return obj;
	}
	public void set(String key, Object value) {
		this.cache.put(key, value);
	}
}
