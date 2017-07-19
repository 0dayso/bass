package com.asiainfo.hb.core.cache;

import java.util.List;

/**
 * CacheServer
 * 
 * @author Mei Kefu
 * @date 2010-4-15
 */
public interface CacheServer {
	
	public void put(String key,Object obj);
	
	public Object get(String key);
	
	/**
	 * 专门给Element中的值为Map的数据使用，取数时不用拿整个Map
	 * @param key
	 * @param subKey
	 * @return
	 */
	public Object get(String key,String subKey);
	
	public void remove(String key);

	@SuppressWarnings("rawtypes")
	public List getKeys();
	
	public int getSize();
	
	public String getName();
}
