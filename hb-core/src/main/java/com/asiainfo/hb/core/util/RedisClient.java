package com.asiainfo.hb.core.util;

import java.util.ArrayList;
import java.util.List;

import com.asiainfo.hb.core.models.Configuration;
import com.asiainfo.hb.core.util.IsNumber;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;
import redis.clients.jedis.JedisPoolConfig;
import redis.clients.jedis.JedisShardInfo;
import redis.clients.jedis.ShardedJedis;
import redis.clients.jedis.ShardedJedisPool;

/**
 * @author 李志坚
 * @since 2017年03月27日
 */
public class RedisClient {

	private static RedisClient rc = new RedisClient();
	private JedisPool jedisPool;// 非切片连接池
	private ShardedJedisPool shardedJedisPool;// 切片连接池
	private String serverIp = "";
	private int serverPort = 0;
	private String authPwd = "";
	@SuppressWarnings("unused")
	private boolean isSharded = false;

	public RedisClient() {
		init();
		initialPool();
		initialShardedPool();
	}

	public void init() {
		serverIp = Configuration.getInstance().getProperty("com.asiainfo.hb.redis.server.ip");
		String port = Configuration.getInstance().getProperty("com.asiainfo.hb.redis.server.port");
		if (null != port && IsNumber.isNumeric(port)) {
			serverPort = Integer.parseInt(port);
		}
		authPwd = Configuration.getInstance().getProperty("com.asiainfo.hb.redis.server.auth");
		String isShardedStr = Configuration.getInstance().getProperty("com.asiainfo.hb.redis.server.isSharded");
		if (null != isShardedStr) {
			isSharded = Boolean.parseBoolean(isShardedStr);
		}
	}

	public static RedisClient getInstance() {
		return rc;
	}

	/**
	 * 初始化非切片池
	 */
	private void initialPool() {
		// 池基本配置
		JedisPoolConfig config = new JedisPoolConfig();
		config.setMaxTotal(60000);
		config.setMaxIdle(300);
		config.setMaxWaitMillis(2000);
		// 在borrow一个jedis实例时，是否提前进行validate操作；如果为true，则得到的jedis实例均是可用的；
		config.setTestOnBorrow(true);
		jedisPool = new JedisPool(config, serverIp, serverPort, 2000, authPwd);
	}

	public Jedis getJedis() {
		if (null != jedisPool)
			return jedisPool.getResource();
		return null;
	}

	/**
	 * 初始化切片池
	 */
	private void initialShardedPool() {
		// 池基本配置
		JedisPoolConfig config = new JedisPoolConfig();
		config.setMaxIdle(200);
		config.setMaxWaitMillis(1000l);
		config.setTestOnBorrow(true);
		// slave链接
		List<JedisShardInfo> shards = new ArrayList<JedisShardInfo>();
		JedisShardInfo info = new JedisShardInfo(serverIp, serverPort);
		info.setPassword("adminKpi");
		shards.add(info);

		// 构造池
		shardedJedisPool = new ShardedJedisPool(config, shards);
	}

	public ShardedJedis getShardedJedis() {
		if (null != shardedJedisPool)
			return shardedJedisPool.getResource();
		return null;
	}
}
