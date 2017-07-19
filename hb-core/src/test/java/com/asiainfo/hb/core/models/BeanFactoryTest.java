package com.asiainfo.hb.core.models;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.context.support.GenericApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.web.context.support.XmlWebApplicationContext;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
public class BeanFactoryTest {
	
	@SuppressWarnings("deprecation")
	@Test
	public void test(){
		JdbcTemplate j =  new JdbcTemplate("DWDB");
		Assert.assertEquals(1, j.queryForInt( "values 1"));
	}
	
	/*@Test
	public void testForClass(){
		SmsSender smsSender = BeanFactory.getBean(SmsSender.class);
		Assert.assertNotNull(smsSender);
	}*/
	
	@SuppressWarnings("resource")
	@Test
	public void test1(){
		Object ddd = new GenericApplicationContext();
		Assert.assertFalse(ddd instanceof XmlWebApplicationContext);
	}
}
