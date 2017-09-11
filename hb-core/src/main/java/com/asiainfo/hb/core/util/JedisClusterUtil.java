package com.asiainfo.hb.core.util;

import java.util.LinkedHashSet;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.JedisPoolConfig;

/**
 * @author 李志坚
 * @since 2017年03月27日
 */
public class JedisClusterUtil {

	private static Logger logger = LoggerFactory.getLogger(JedisClusterUtil.class);

	static Set<HostAndPort> jedisClusterNodes = new LinkedHashSet<HostAndPort>();
	static JedisPoolConfig poolConfig = new JedisPoolConfig();
	static JedisCluster jedisCluster = null;
	static JedisClusterUtil instance = null;
	static String AUTH_PASS = "adminKpi";

	public JedisClusterUtil() {
		init();
	}

	public void init() {
		// 最大连接数
		poolConfig.setMaxTotal(400);
		// 最大空闲数
		poolConfig.setMaxIdle(64);
		// 最大允许等待时间，如果超过这个时间还未获取到连接，则会报JedisException异常：
		// Could not get a resource from the pool
		poolConfig.setMaxWaitMillis(2 * 1000);
//		jedisClusterNodes.add(new HostAndPort("192.168.1.200", 7000));
//		jedisClusterNodes.add(new HostAndPort("192.168.1.200", 7001));
//		jedisClusterNodes.add(new HostAndPort("192.168.1.200", 7002));
//		jedisClusterNodes.add(new HostAndPort("192.168.1.200", 7003));
//		jedisClusterNodes.add(new HostAndPort("192.168.1.200", 7004));
//		jedisClusterNodes.add(new HostAndPort("192.168.1.200", 7005));

		jedisClusterNodes.add(new HostAndPort("10.25.125.83", 6379));
		jedisClusterNodes.add(new HostAndPort("10.25.125.83", 6380));
		jedisClusterNodes.add(new HostAndPort("10.25.125.84", 6379));
		jedisClusterNodes.add(new HostAndPort("10.25.125.84", 6380));
		jedisClusterNodes.add(new HostAndPort("10.25.125.85", 6379));
		jedisClusterNodes.add(new HostAndPort("10.25.125.85", 6380));
		jedisClusterNodes.add(new HostAndPort("10.25.125.86", 6379));
		jedisClusterNodes.add(new HostAndPort("10.25.125.86", 6380));
		
//		jedisClusterNodes.add(new HostAndPort("10.25.125.171", 7000));
//		jedisClusterNodes.add(new HostAndPort("10.25.125.171", 7001));
//		jedisClusterNodes.add(new HostAndPort("10.25.125.171", 7002));
//		jedisClusterNodes.add(new HostAndPort("10.25.125.171", 7003));
//		jedisClusterNodes.add(new HostAndPort("10.25.125.171", 7004));
//		jedisClusterNodes.add(new HostAndPort("10.25.125.171", 7005));
		 
//		jedisClusterNodes.add(new HostAndPort("10.31.97.133", 7000));
//		jedisClusterNodes.add(new HostAndPort("10.31.97.133", 7001));
//		jedisClusterNodes.add(new HostAndPort("10.31.97.133", 7002));
//		jedisClusterNodes.add(new HostAndPort("10.31.97.133", 7003));
//		jedisClusterNodes.add(new HostAndPort("10.31.97.133", 7004));
//		jedisClusterNodes.add(new HostAndPort("10.31.97.133", 7005));

		jedisCluster = new JedisCluster(jedisClusterNodes, 3000, 3000, 5, AUTH_PASS, new JedisPoolConfig());
	}

	public static JedisClusterUtil getInstance() {
		if (instance == null) {
			instance = new JedisClusterUtil();
		}
		return instance;
	}

	public JedisCluster getJedisCluster() {
		return jedisCluster;
	}

	public static Set<HostAndPort> getJedisClusterNodes() {
		return jedisClusterNodes;
	}

	public static JedisPoolConfig getPoolConfig() {
		return poolConfig;
	}

	public static void main(String[] args) {
		JedisCluster jedisCluster = null;
		try {
			jedisCluster = JedisClusterUtil.getInstance().getJedisCluster();
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
		}
		logger.info("获得的jedisCluster为：" + jedisCluster);
	}

}
