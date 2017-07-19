/**
 * 
 */
package com.asiainfo.hb.bass.frame.models;

import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.asiainfo.hb.core.models.JdbcTemplate;

/**
 * @author zhangds
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
public class Test {

	//@org.junit.Test
	@SuppressWarnings("unused")
	public void getTest(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate("");
	}
}
