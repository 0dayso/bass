package com.asiainfo.hbbass.irs.report.core;

/**
 *	报表元信息的容器
 *
 * @author Mei Kefu
 * @date 2009-7-25
 */
public interface ReportContainer {
	
	public Object get(String key);
	
	public void put(String key, Report report);
	
	public void remove(String key);
	
	public int size();
}
