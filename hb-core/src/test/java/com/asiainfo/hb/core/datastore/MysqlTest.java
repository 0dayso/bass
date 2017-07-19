package com.asiainfo.hb.core.datastore;

import static junit.framework.Assert.*;

import java.util.List;
import java.util.Map;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;

import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.models.JsonHelper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
@TransactionConfiguration(defaultRollback = true)
public class MysqlTest extends AbstractTransactionalJUnit4SpringContextTests{
	
	@Autowired
	private SqlUpdate sqlUpdate;
	
	@Autowired
	private SqlQuery sqlQuery;
	
	@SuppressWarnings("deprecation")
	@Test
	public void testBasic(){
		
		JdbcTemplate jt = new JdbcTemplate("mysql");
		
		assertEquals("mysql",jt.getDatabaseType());
		
		String sql = "select * from information_schema.tables";
		
		SqlQueryResultVo result = sqlQuery.queryLimit(sql, "mysql","-1","1");
		
		assertEquals(jt.queryForInt("select count(*) from information_schema.tables") , result.getRoot().size());
	}
	
	@SuppressWarnings("rawtypes")
	@Test
	public void testBlob(){
		JdbcTemplate jt = new JdbcTemplate("mysql");
		jt.update("create table blob_test(id int,name varchar(16),col_blob blob)");
		
		String primaryKey = "id";
		String tableName="blob_test";
		String cmd = "insert";
		String str = "[{id:1,name:'测试',col_blob:'中文abc'}]";
		List records = (List)JsonHelper.getInstance().read(str);
		Map actualRes = (Map)sqlUpdate.cud(cmd, "mysql", tableName, primaryKey, records);
		
		assertTrue((Boolean)actualRes.get("success"));
		
		String sql = "select * from blob_test where id=1";
		SqlQueryResultVo result = sqlQuery.queryLimit(sql, "mysql","-1","1");
		
		assertTrue( result.getRoot().get(0).get("COL_BLOB") instanceof String);
		assertFalse(result.getRoot().get(0).get("COL_BLOB") instanceof byte[]);
		assertEquals("中文abc", result.getRoot().get(0).get("COL_BLOB"));
		assertEquals("测试", result.getRoot().get(0).get("NAME"));
		
		actualRes = (Map)sqlUpdate.cud("delete", "mysql", tableName, primaryKey, records);
		
		jt.update("drop table blob_test");
	}
	
}
