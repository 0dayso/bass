package com.asiainfo.hb.core.datastore;

import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.models.JsonHelper;

/**
 * 
 * @author Mei Kefu
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
public class ClobTest {
	
	@Autowired
	private SqlUpdate sqlUpdate;
	
	@Autowired
	private SqlQuery sqlQuery;
	
	@Before
	public  void startup(){
		JdbcTemplate jt = new JdbcTemplate();
		jt.update("create table lob_tab(id int,col_clob clob)");
	}
	
	@After
	public void tearDown(){
		JdbcTemplate jt = new JdbcTemplate();
		jt.update("drop table lob_tab");
	}
	
	@SuppressWarnings("rawtypes")
	@Test
	public void db2Test(){
		String primaryKey = "id";
		String cmd="insert";
		String str = "[{id:11,col_clob:'中文测试abc'}]";
		List records = (List)JsonHelper.getInstance().read(str);
		Map obj = (Map)sqlUpdate.cud(cmd, "", "lob_tab", primaryKey, records);
		
		assertTrue((Boolean)obj.get("success"));
		
		SqlQueryResultVo resultVo = sqlQuery.queryLimit("select * from lob_tab", "", "-1", "0");
		
		assertEquals("中文测试abc", resultVo.getRoot().get(0).get("COL_CLOB"));
		
	}
}
