package com.asiainfo.hb.core.cache;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.log4j.Logger;

/**
 * CacheServerFactory
 * 
 * @author Mei Kefu
 * @date 2010-4-19
 * @date 2010-12-31 发现由于CacheServerL2CacheImpl 不是单例所有它的锁没有生效，有可能重复加载KPI，修改为单例模式
 */
public class CacheServerFactory {
	
	private Map<String,CacheServer> map = new HashMap<String,CacheServer>(); 
	
	private static CacheServerFactory factory = new CacheServerFactory();
	
	private static Logger LOG = Logger.getLogger(CacheServerFactory.class);
	
	private CacheServerFactory(){
		
	}
	
	public static CacheServerFactory getInstance(){
		return factory;
	}
	
	public CacheServer getCache(String name){
		CacheServer cache = null;
		
		if(!map.containsKey(name)){
			try {
				cache = new CacheServerL2CacheImpl(name);
			} catch (CacheServerException e) {
				LOG.error("创建一级缓存错误，"+e.getMessage(),e);
				cache = new LocalCache(name);
			}
			map.put(name, cache);
		}else{
			cache = map.get(name);
		}
		return cache;
	}
	
	private final class LocalCache implements CacheServer{
		private Map<String,Object> cache=new ConcurrentHashMap<String,Object>();
		private String name="";
		public LocalCache(String name){
			this.name=name;
			LOG.warn("本VM的HashMap缓存["+name+"]创建成功-->存在OOM风险，不能作为生产环境使用，请尽快检查EhCache配置");
		}
		@Override
		public void put(String key, Object obj){
			cache.put(key, obj);
		}

		@Override
		public Object get(String key){
			return cache.get(key);
		}

		@Override
		public Object get(String key, String subKey){
			return null;
		}

		@Override
		public void remove(String key){
			cache.remove(key);
		}

		@SuppressWarnings("rawtypes")
		@Override
		public List getKeys(){
			return null;
		}

		@Override
		public int getSize(){
			return 0;
		}

		@Override
		public String getName(){
			return name;
		}
	}
}
