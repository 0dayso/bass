package com.asiainfo.hb.core.models;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
public class ConfigurationTest {
	
	@Test
	public void test(){
		Assert.assertEquals("中文测试", Configuration.getInstance().getProperty("cntest"));
		Assert.assertEquals("hahah", Configuration.getInstance().getProperty("test"));
		Assert.assertEquals("http://localhost:8082/ehcache/rest", Configuration.getInstance().getProperty("com.asiainfo.pst.cache.cacheURI"));
	}
}
