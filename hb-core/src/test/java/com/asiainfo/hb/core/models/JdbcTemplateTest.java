/**
 * 
 */
package com.asiainfo.hb.core.models;

import javax.sql.DataSource;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @author Mei Kefu
 * 
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/conf/spring/*.xml" })
public class JdbcTemplateTest {

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		jdbcTemplate = new JdbcTemplate(dataSource, false);
		int count = jdbcTemplate.queryForObject("select count(*) from SYSIBM.SYSTABLES",Integer.class);
		System.out.println(count);
		Assert.assertEquals(count,398);
	}

	@Test
	public void testDb2() {
		Assert.assertEquals(jdbcTemplate.getDatabaseType(), "db2");
	}
/*
	private JdbcTemplate jdbcTemplateOrcl;

	@Autowired
	public void setOracle(DataSource oracle) {
		jdbcTemplateOrcl = new JdbcTemplate(oracle, false);
	}

	@Test
	public void testOrcl() {
		Assert.assertEquals(jdbcTemplateOrcl.getDatabaseType(), "oracle");
	}*/

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		

	}

}
