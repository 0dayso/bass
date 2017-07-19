package com.asiainfo.hbbass.component.cache;

import java.util.Map;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheException;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import org.apache.log4j.Logger;

/**
 * 使用两级缓存 一级缓存只是缓存很少量的数据，过期时间为3分钟。为本地JVM中*需要配置本地的cache文件 二级缓存使用CacheServer
 * 只有get操作才使用L1Cache，作为对L2Cache对get的优化，减少网络开销(主要是KPIEntity太大)
 * 
 * @author Mei Kefu
 * @date 2010-4-19
 */
public class CacheServerL2CacheImpl extends CacheServerCacheImpl {

	public static Logger LOG = Logger.getLogger(CacheServerL2CacheImpl.class);

	private Cache l1Cache = null;// 本JVM一级缓存

	public CacheServerL2CacheImpl(String name) {
		super(name);
		LOG.debug("CacheServerL2CacheImpl----------start");
		
		try {
			CacheManager cacheManager = CacheManager.create(CacheServerL2CacheImpl.class.getClassLoader().getResourceAsStream("hbbass_ehcache.xml"));
			l1Cache = cacheManager.getCache(name);
		} catch (CacheException e) {
		
			e.printStackTrace();
		} catch (IllegalStateException e) {
				e.printStackTrace();
		} catch (ClassCastException e) {
			
			e.printStackTrace();
		}
		
		LOG.debug("CacheServerL2CacheImpl----------end");
	}

	@SuppressWarnings("deprecation")
	protected Object getL1Cache(String key) {
		if(l1Cache!=null){
			Element element = l1Cache.get(key);
			if (element != null) {
				LOG.debug("L1Cache 命中，key：" + key);
				return element.getValue();
			} else {
				LOG.debug("L1Cache 没有命中，key：" + key);
				return null;
			}
		}
		return null;
	}

	protected void putL1Cache(String key, Object obj) {
		l1Cache.put(new Element(key, obj));
	}

	private byte[] lock = new byte[0];

	public Object get(String key) {

		Object obj = getL1Cache(key);

		if (obj == null) {
			// 防止多次在二级缓存中取值，加锁
			synchronized (lock) {
				LOG.debug("锁定对象:" + this.getName() + " key:" + key);
				obj = getL1Cache(key);
				if (obj == null) {
					obj = super.get(key);
					if (obj != null) {
						putL1Cache(key, obj);
					}
				}
			}
		}
		return obj;
	}

	public Object get(String key, String subKey) {
		/*
		 * Object obj = get(key); Object obj1 = null; if(obj!=null && obj
		 * instanceof Map){ Map map = (Map)obj; obj1 = map.get(subKey); }
		 * 
		 * return obj1;
		 */
		Object obj = getL1Cache(key);
		Object obj1 = null;
		if (obj == null) {
			obj1 = super.get(key, subKey);
		} else if (obj != null && obj instanceof Map) {
			@SuppressWarnings("rawtypes")
			Map map = (Map) obj;
			obj1 = map.get(subKey);
		}
		return obj1;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		

	}

}
