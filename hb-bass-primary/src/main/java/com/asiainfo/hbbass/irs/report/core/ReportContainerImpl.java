package com.asiainfo.hbbass.irs.report.core;

import java.util.List;
import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

/**
 *
 * @author Mei Kefu
 * @date 2009-7-25
 */
@SuppressWarnings("rawtypes")
public class ReportContainerImpl implements ReportContainer {

	private CacheManager cacheManager = null;
	
	private Cache cache = null;
	
	public ReportContainerImpl(){
		cacheManager=CacheManager.create(ReportContainerImpl.class.getClassLoader().getResourceAsStream("hbbass_ehcache.xml"));
		cache = cacheManager.getCache("ReportMeta");
	}
	
	@SuppressWarnings("deprecation")
	public Object get(String key) {
		Element element = cache.get(key);
		return element!=null?element.getValue():null;
	}

	public List getKeys() {
		return cache.getKeys();
	}

	public void put(String key, Report report) {
		cache.put(new Element(key,report));
	}

	public void remove(String key) {
		cache.remove(key);
	}

	public int size() {
		return cache.getSize();
	}
	
}
