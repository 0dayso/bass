package com.asiainfo.hbbass.kpiportal.core;

/**
 * KPI实体的容器(缓存)
 * 
 * @author Mei Kefu
 * 
 */
public interface KPIEntityContainer {
	public KPIEntityCache getCache(String name);

	public KPIEntityCache[] getCaches();
}
