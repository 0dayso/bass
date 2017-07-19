package com.asiainfo.hbbass.kpiportal.cache;

import org.apache.log4j.Logger;

import net.sf.ehcache.CacheException;
import net.sf.ehcache.Ehcache;
import net.sf.ehcache.bootstrap.BootstrapCacheLoader;

public class KPIEntityContainerInitialize implements BootstrapCacheLoader {
	private final static Logger LOG = Logger.getLogger(KPIEntityContainerInitialize.class);

	public boolean isAsynchronous() {
		return false;
	}

	public void load(Ehcache cache) throws CacheException {
		LOG.debug("....开始加载KPIEntity");

	}

	public Object clone() throws CloneNotSupportedException {
		return new KPIEntityContainerInitialize();
	}
}
