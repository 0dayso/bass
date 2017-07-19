package com.asiainfo.hb.bass.data;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.asiainfo.hb.core.util.RedisClient;

import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisCluster;
import redis.clients.jedis.JedisPoolConfig;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath*/conf/spring/*.xml", "classpath*/conf/*.xml" })
public class RedisClientTest {
	public Logger logger = LoggerFactory.getLogger(RedisClientTest.class);
	RedisClient redisClient = null;
	
	@Test
	public void testRedis() {
		 RedisClient redisClient = RedisClient.getInstance();
		 logger.debug("redisClient:"+redisClient);
		 Jedis jedis = redisClient.getJedis();
		 jedis.auth("adminKpi2");
		 jedis.set("K10001:20110101", "xxxx");
		 logger.info("K10001:20110101值为：" + jedis.get("K10001:20110101"));
		// for (int i = 0; i < 1; i++) {
		// Jedis jedis = redisClient.getJedis();
		// //jedis.auth("adminKpi");
		// jedis.flushDB();
		// jedis.set("K10001:20110101", "xxxx");
		// jedis.set("K10001:20110101", "yyyy");
		// jedis.set("K10001:20110101", "zzzz");
		// logger.info("k2:" + jedis.get("K10001:20110101"));
		// }
		// JedisUtils.setObject("K10001", "xxxx", 0);
		// logger.info("k2:" + JedisUtils.getObject("K10001"));
		//
		Set<HostAndPort> jedisClusterNodes = new HashSet<HostAndPort>();
		jedisClusterNodes.add(new HostAndPort("192.168.3.33", 7000));
		jedisClusterNodes.add(new HostAndPort("192.168.3.33", 7001));
		jedisClusterNodes.add(new HostAndPort("192.168.3.33", 7002));
		jedisClusterNodes.add(new HostAndPort("192.168.3.33", 7003));
		jedisClusterNodes.add(new HostAndPort("192.168.3.33", 7004));
		jedisClusterNodes.add(new HostAndPort("192.168.3.33", 7005));
		// 3个master 节点
		JedisCluster jc = new JedisCluster(jedisClusterNodes, 3000, 3000, 5, "adminKpi", new JedisPoolConfig());
		String key = "3434";
		System.out.println("key:"+key+",value:"+jc.get(key));
		jc.set(key, "bar4");
		System.out.println("key:"+key+",value:"+jc.get(key));
		
		try {
			jc.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
//		JedisCluster jedisCluster = (JedisCluster) BeanFactory.getBean("jedisCluster");
//		String v1 = jedisCluster.get("3434");
//		System.out.println("v1:"+v1);
//		System.out.println(JedisUtils.getObject("3434"));
	}
}
