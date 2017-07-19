package com.asiainfo.hb.core.datastore;

import static org.junit.Assert.*;


import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.asiainfo.hb.core.models.JdbcTemplate;

/**
 * 
 * @author Mei Kefu
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
public class SqlserverTest {
	
	@Test
	public void testConnect(){
		JdbcTemplate jt = new JdbcTemplate("sqlserver");
		assertEquals("sqlserver", jt.getDatabaseType());
		
		SqlPageHelper sqlPageHelper = jt.getSqlPageHelper();
		
		jt.update("drop table test_unit_abc");
		jt.update("create table test_unit_abc(ids int)");
		
		System.out.println(sqlPageHelper.getLimitSQL("select * from test_unit_abc", 10, 1));
		
		jt.update("drop table test_unit_abc");
	}
	
	@Test
	public void testPageSql(){
		
	}
}
