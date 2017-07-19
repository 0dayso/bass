package com.asiainfo.hb.core.datastore;

import static org.junit.Assert.*;

import java.io.ByteArrayInputStream;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.asiainfo.hb.core.models.JdbcTemplate;

/**
 * 
 * @author Mei Kefu
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
public class OracleTest {
	
	@Test
	public void testConnect(){
		JdbcTemplate jt = new JdbcTemplate("oracle");
		assertEquals("oracle", jt.getDatabaseType());
	}
	
	
	@Test
	public void testBlob(){
		final Object[][] objs ={
				{1,"测试1"}
				,{2,"测试2"}
		};
		JdbcTemplate jt = new JdbcTemplate("oracle");
		try{
			jt.update("create table lob_tab(id int,col_blob blob)");
			jt.batchUpdate("insert into lob_tab values(?,?)", new BatchPreparedStatementSetter() {
				
				@Override
				public void setValues(PreparedStatement ps, int i) throws SQLException {
					Object[] obj =objs[i];
					ps.setInt(1, (Integer)obj[0]);
					ps.setBlob(2, new ByteArrayInputStream(((String)obj[1]).getBytes()));
				}
				
				@Override
				public int getBatchSize() {
					
					return objs.length;
				}
			});
			
			//jt.batchUpdate("insert into lob_tab values(?,?)",Arrays.asList(objs),new int[]{Types.INTEGER,Types.BLOB});
			
			jt.update("insert into lob_tab values(?,?)",new Object[]{3,"测试3".getBytes()});
			
			assertEquals("测试2", new String(jt.queryForObject("select col_blob from lob_tab where id=2", byte[].class)));
			
			assertEquals("测试3", new String(jt.queryForObject("select col_blob from lob_tab where id=3", byte[].class)));
			
		}finally{
			jt.update("drop table lob_tab");
		}
	}
}
