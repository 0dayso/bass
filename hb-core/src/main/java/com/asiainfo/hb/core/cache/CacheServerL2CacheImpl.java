package com.asiainfo.hb.core.cache;

import java.util.List;
import java.util.Map;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import org.apache.log4j.Logger;

/**
 * 使用两级缓存
 * 一级缓存只是缓存很少量的数据，过期时间为3分钟。为本地JVM中*需要配置本地的cache文件
 * 二级缓存使用CacheServer 
 * 只有get操作才使用L1Cache，作为对L2Cache对get的优化，减少网络开销(主要是KPIEntity太大)
 * 
 * @author Mei Kefu
 * @date 2010-4-19
 * 
 * @date 2012-1-12 更新缓存把CacheServerImpl作为属性放入，没有CacheServer时就使用本机的一级缓存，防止没有缓存服务器时的报错
 */
public class CacheServerL2CacheImpl implements CacheServer{
	
	public static Logger LOG = Logger.getLogger(CacheServerL2CacheImpl.class);
	
	private Cache l1Cache=null;//本JVM一级缓存
	
	private CacheServerImpl l2Cache=null;//二级缓存服务器
	
	private String name="";
	
	public CacheServerL2CacheImpl(String name)throws CacheServerException {
		this.name=name;
		try {
			l2Cache=new CacheServerImpl(name);
			LOG.info("缓存服务器["+name+"]连接成功");
		} catch (CacheServerException e) {
			l2Cache=null;
			LOG.warn("缓存服务器连接失败，没有使用缓存服务器");
		}
		try {
			CacheManager cacheManager = CacheManager.create(CacheServerL2CacheImpl.class.getClassLoader().getResourceAsStream("conf/hbbass_ehcache.xml"));
			l1Cache = cacheManager.getCache(name);
		} catch (Exception e) {
			throw new CacheServerException("本VM的EhCache缓存["+getName()+"]建立错误，"+e.getMessage(),e);
		}
		if(l1Cache==null){
			throw new CacheServerException("本VM的EhCache缓存["+getName()+"]建立错误");
		}
		LOG.info("本VM的EhCache缓存["+name+"]创建成功");
	}
	
	@SuppressWarnings("deprecation")
	protected Object getL1Cache(String key){
		Element element = l1Cache.get(key);
		if(element!=null){
//			LOG.debug("L1Cache 命中，key："+key);
			return element.getValue();
		}else{
//			LOG.debug("L1Cache 没有命中，key："+key);
			return null;
		}
		
	}
	@Override
	public void put(String key,Object obj){
		if(obj!=null){
			//l1Cache.put(new Element(key,obj));
			if(l2Cache!=null){
				l2Cache.put(key, obj);
			}else{//2012-5-23 当缓存服务器不启用的时候就启动本JVM的一级缓存
				l1Cache.put(new Element(key,obj));
			}
		}
	}
	
	private byte[] lock = new byte[0];
	
	@Override
	public Object get(String key){
		Object obj = getL1Cache(key);
		if(obj==null && l2Cache!=null){
			//防止多次在二级缓存中取值，加锁
			synchronized (lock) {
				LOG.debug("锁定对象:"+this.name+" key:"+key);
				obj = getL1Cache(key);
				if(obj==null){
					obj=l2Cache.get(key);
					/*if(obj!=null){
						put(key, obj);
					}*/
				}
			}
		}
		return obj;
	}
	
	@SuppressWarnings("rawtypes")
	public Object get(String key, String subKey){
	/*	Object obj = get(key);
		Object obj1 = null;
		if(obj!=null && obj instanceof Map){
			Map map = (Map)obj;
			obj1 = map.get(subKey);
		}
		
		return obj1;
		*/
		Object obj = getL1Cache(key);
		Object obj1 = null;
		if(obj==null && l2Cache!=null){
			obj1=l2Cache.get(key, subKey);
		}else if(obj!=null && obj instanceof Map){
			Map map = (Map)obj;
			obj1=map.get(subKey);
		}
		return obj1;
	}
	
	/**
	 * @param args
	 */
	@SuppressWarnings("rawtypes")
	public static void main(String[] args) {
		
		CacheServer cacheSql;
		try {
			cacheSql = new CacheServerL2CacheImpl("KPI");
			List list = cacheSql.getKeys();
			
			for (int i = 0; i < list.size(); i++) {
				String string = (String)list.get(i);
				
				cacheSql.remove(string);
			}
		} catch (CacheServerException e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public void remove(String key){
		l1Cache.remove(key);
		if(l2Cache!=null){
			l2Cache.remove(key);
		}
	}

	@SuppressWarnings("rawtypes")
	@Override
	public List getKeys(){
		if(l2Cache!=null){
			return l2Cache.getKeys();
		}else{
			return l1Cache.getKeys();
		}
	}

	@Override
	public int getSize(){
		if(l2Cache!=null){
			return l2Cache.getSize();
		}else{
			return l1Cache.getSize();
		}
	}

	@Override
	public String getName(){
		return name;
	}
}
