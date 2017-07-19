package com.asiainfo.hb.core.util;

import com.asiainfo.hb.core.models.BeanFactory;
import com.asiainfo.hb.core.models.Configuration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.JedisCommands;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.exceptions.JedisException;

import java.io.*;


/**
 * Jedis Cache 工具类
 * 
 * @author lijie9
 * @date 2016年5月16日
 */
public class JedisUtils {

	private static Logger log = LoggerFactory.getLogger(JedisUtils.class);

	private static boolean serviceFlag = true;
	private static long serviceFailTime = 0;
	public static final long RETRY_INTERVAL = Long.parseLong(Configuration.getInstance().getProperty("com.asiainfo.hb.redis.server.retryInterval"));

	private static JedisCluster jedisCluster = null;
	private static JedisPool jedisPool = null;

	public static final boolean isUseCache = isUseCache();
	public static final boolean isCluster = isCluster();
	//缓存时间，2小时7200
	public static final int cacheSeconds = Integer.parseInt(Configuration.getInstance().getProperty("com.asiainfo.hb.redis.server.cacheSeconds"));
	//缓存日期，在读取某一KPI数据时，缓存前N天的相关数据
	public static final int cacheDays = Integer.parseInt(Configuration.getInstance().getProperty("com.asiainfo.hb.redis.server.cacheDays"));

	public static JedisCluster getJedisCluster() {
		return jedisCluster;
	}

	static {
		if (isCluster){
			jedisCluster = (JedisCluster)BeanFactory.getBean("jedisCluster");
		} else {
			jedisPool = (JedisPool)BeanFactory.getBean("jedisPool");
		}
	}

	public static boolean exists(String key){
		if (!isServiceCanUse()){
			return false;
		}
		boolean isExists = false;
		JedisCommands jc = null;
		try {
			jc = getResource();
			if (jc != null) {
				isExists = jc.exists(key);
			}
		} catch (Exception e) {
			doWithServiceFlag();
			log.warn("jedis error!");
		} finally {
			if (jc != null){
				returnResource(jc);
			}
		}
		return isExists;
	}

	public static void flushDB(){
		if (!isServiceCanUse()){
			return;
		}
		Jedis jedis = null;
		try {
			jedis = getResource();
			jedis.flushDB();
		} catch (Exception e) {
			doWithServiceFlag();
			log.warn("flushDB error!");
		} finally {
			if (jedis != null){
				jedis.close();
			}
		}
	}

	/**
	 * 获取缓存
	 * @param key 键
	 * @return 值
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getObject(String key) {
		if (!isServiceCanUse()){
			return null;
		}
		T value = null;
		Jedis jc = getResource();
		try {
			if (isCluster){
				if (jedisCluster.exists(getBytesKey(key))) {
					value = (T) unserialize(jedisCluster.get(getBytesKey(key)));
				}
			} else {
				jc = getResource();
				if (jc.exists(getBytesKey(key))) {
					value = (T) unserialize(jc.get(getBytesKey(key)));
					//log.debug("getObject {} = {}", key, value);
				}
			}
		} catch (Exception e) {
			doWithServiceFlag();
			log.warn("getObject {} = {}", key, value, e);
		} finally {
			if (jc != null){
				jc.close();
			}
		}
		return value;
	}

	/**
	 * 获取缓存
	 * @param key 键
	 * @return 值
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getObject(String key, String field) {
		if (!isServiceCanUse()){
			return null;
		}
		T value = null;
		Jedis jedis = null;
		try {
			if (isCluster){
				if (jedisCluster.hexists(getBytesKey(key), getBytesKey(field))) {
					value = (T) unserialize(jedisCluster.hget(getBytesKey(key), getBytesKey(field)));
				}
			} else {
				jedis = getResource();
				if (jedis.hexists(getBytesKey(key), getBytesKey(field))) {
					value = (T) unserialize(jedis.hget(getBytesKey(key), getBytesKey(field)));
					//log.debug("getObject {} = {}", key, value);
				}
			}
		} catch (Exception e) {
			doWithServiceFlag();
			log.warn("getObject {} = {}", key, value, e);
		} finally {
			if (jedis != null){
				jedis.close();
			}
		}
		return value;
	}

	/**
	 * 设置缓存
	 * @param key 键
	 * @param value 值
	 * @param cacheSeconds 超时时间，0为不超时
	 * @return
	 */
	public static String setObject(String key, Object value, int cacheSeconds) {
		if (!isServiceCanUse()){
			return null;
		}
		String result = null;
		Jedis jedis = null;
		try {
			if (isCluster){
				result = jedisCluster.set(getBytesKey(key), serialize(value));
				if (cacheSeconds != 0) {
					jedisCluster.expire(key, cacheSeconds);
				}
			} else {
				jedis = getResource();
				result = jedis.set(getBytesKey(key), serialize(value));
				if (cacheSeconds != 0) {
					jedis.expire(key, cacheSeconds);
				}
			}
			//log.debug("setObject {} = {}", key, value);
		} catch (Exception e) {
			doWithServiceFlag();
			log.warn("setObject {} = {}", key, value, e);
		} finally {
			if (jedis != null){
				jedis.close();
			}
		}
		return result;
	}

	/**
	 * 设置缓存
	 * @param key 键
	 * @param value 值
	 * @param cacheSeconds 超时时间，0为不超时
	 * @return
	 */
	public static String setObject(String key, String field, Object value, int cacheSeconds) {
		if (!isServiceCanUse()){
			return null;
		}
		String result = null;
		Jedis jedis = null;
		try {
			if (isCluster){
				result = jedisCluster.hset(getBytesKey(key), getBytesKey(field), serialize(value)) + "";
				if (cacheSeconds != 0) {
					jedisCluster.expire(key, cacheSeconds);
				}
			} else {
				jedis = getResource();
				result = jedis.hset(getBytesKey(key), getBytesKey(field), serialize(value)) + "";
				if (cacheSeconds != 0) {
					jedis.expire(key, cacheSeconds);
				}
			}
			//log.debug("setObject {} = {}", key, value);
		} catch (Exception e) {
			doWithServiceFlag();
			log.warn("setObject {} = {}", key+"_"+field, value, e);
		} finally {
			if (jedis != null){
				jedis.close();
			}
		}
		return result;
	}

	/**
	 * 获取byte[]类型Key
	 * @param object
	 * @return
	 */
	public static byte[] getBytesKey(Object object){
		if(object instanceof String){
    		return getBytes((String)object);
    	}else{
    		return serialize(object);
    	}
	}
    /**
     * 转换为字节数组
     * @param str
     * @return
     */
    public static byte[] getBytes(String str){
    	if (str != null){
    		try {
				return str.getBytes("UTF-8");
			} catch (UnsupportedEncodingException e) {
				return null;
			}
    	}else{
    		return null;
    	}
    }
	
	/**
	 * 序列化对象
	 * @param object
	 * @return
	 */
	public static byte[] serialize(Object object) {
		ObjectOutputStream oos = null;
		ByteArrayOutputStream baos = null;
		try {
			if (object != null){
				baos = new ByteArrayOutputStream();
				oos = new ObjectOutputStream(baos);
				oos.writeObject(object);
				return baos.toByteArray();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			try {
				if (baos != null) {
					baos.close();
				}
				if (oos != null) {
					oos.close();
				}
			}catch (Exception e){
				e.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * 反序列化对象
	 * @param bytes
	 * @return
	 */
	public static Object unserialize(byte[] bytes){
		ByteArrayInputStream bais = null;
		ObjectInputStream ois = null;
		try {
			if (bytes != null && bytes.length > 0){
				bais = new ByteArrayInputStream(bytes);
				ois = new ObjectInputStream(bais);
				return ois.readObject();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			try {
				if (bais != null) {
					bais.close();
				}
				if (ois != null) {
					ois.close();
				}
			}catch (Exception e){
				e.printStackTrace();
			}
		}
		return null;
	}

	public static boolean isUseCache(){
		return isCachedSomething("com.asiainfo.hb.redis.server.isUseCache");
	}

	public static boolean isCluster(){
		return isCachedSomething("com.asiainfo.hb.redis.server.isCluster");
	}

	public static boolean isCachedKpi(){
		return isCachedSomething("com.asiainfo.hb.redis.server.isCached.kpi");
	}

	public static boolean isCachedOther(){
		return isCachedSomething("com.asiainfo.hb.redis.server.isCached.other");
	}

	public static boolean isOnlyUseCache(){
		return isCachedSomething("com.asiainfo.hb.redis.server.isCached.isOnlyUseCache");
	}

	/**
	 * 根据配置判断是否需要进行缓存
	 * @param propertyName
	 * @return
	 */
	private static boolean isCachedSomething(String propertyName){
		boolean isCacheKpi = false;
		String isCached = Configuration.getInstance().getProperty(propertyName);
		if ("true".equals(isCached)){
			isCacheKpi = true;
		}
		return isCacheKpi;
	}

	/**
	 * 如果在缓存中不存在，则根据传入的方法获取并缓存起来
	 * @param redisKey
	 * @param dao
	 * @param methodName
	 * @param params
	 * @param <T>
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static <T> T isNotExistedThenGetAndPut(String redisKey, Object dao, String methodName, Object... params){
		T sth = null;
		try {
			Class<?>[] classes = new Class[params.length];
			for (int i = 0; i < params.length; i++) {
				if (params[i] == null){
					classes[i] = String.class;	//当传入为null时，默认为String
				} else {
					classes[i] = params[i].getClass();
				}
			}
			if (isCachedOther() ){
				if (JedisUtils.exists(redisKey)){
					sth = (T)JedisUtils.getObject(redisKey);
				} else {
					sth = (T)dao.getClass().getMethod(methodName, classes).invoke(dao, params);
					JedisUtils.setObject(redisKey, sth, 0);
				}
			}  else {
				sth = (T)dao.getClass().getMethod(methodName, classes).invoke(dao, params);
			}
		} catch (Exception e){
			log.warn("无效的类和方法", e);
		}
		return sth;
	}

	/**
	 * 获取资源
	 * @return
	 * @throws JedisException
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getResource() throws JedisException {
		if (!isServiceCanUse()){
			return null;
		}
		T jc = null;
		try {
			if (isCluster){
				jc = (T)jedisCluster;
			} else {
				jc = (T)jedisPool.getResource();
			}
		} catch (JedisException e) {
			log.warn("getResource.", e);
			doWithServiceFlag();
			if (!isCluster && jc instanceof Jedis){
				((Jedis)jc).close();
			}
			throw e;
		}
		return jc;
	}

	public static void returnResource(JedisCommands jc) throws JedisException {
		if (jc instanceof Jedis){
			((Jedis)jc).close();
		}
	}

	public static boolean isServiceCanUse() {
		boolean canUse = true;
		//当前时间离失败时间过去了10分钟，则重置服务默认可用，再次尝试
		if (isUseCache && (serviceFlag || (!serviceFlag && System.currentTimeMillis() - serviceFailTime > RETRY_INTERVAL))){
			serviceFlag = true;
		} else {
			canUse = false;
			log.error("redis系统不可用，请检查服务器是否正常！");
		}
		return canUse;
	}

	public static void doWithServiceFlag(){
		if (serviceFlag) {
			serviceFlag = false;
			serviceFailTime = System.currentTimeMillis();
		}
	}
}
