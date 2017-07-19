/**
 * 
 */
package com.asiainfo.hb.core.datastore;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.dbunit.Assertion;
import org.dbunit.database.DatabaseConnection;
import org.dbunit.database.IDatabaseConnection;
import org.dbunit.database.QueryDataSet;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.xml.FlatXmlDataSetBuilder;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.DataSourceUtils;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.AbstractTransactionalJUnit4SpringContextTests;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.models.JsonHelper;

/**
 * @author Mei Kefu
 *
 *
 * test_tab ddl

CREATE TABLE TEST_TAB (
  ID	INTEGER not null,
  value decimal(16,4),
  NAME	VARCHAR(32),
  DATE	TIMESTAMP
);

 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
//@TransactionConfiguration(defaultRollback = true)
public class SqlUpdateTest extends AbstractTransactionalJUnit4SpringContextTests{
	
	@Autowired
	private SqlUpdate sqlUpdate;
	
	@Autowired
	private JsonHelper jsonHelper;
	
	private IDatabaseConnection conn;
	
	private Connection con;
	
	@Autowired
	private DataSource dataSource;

	private FlatXmlDataSetBuilder builder = new FlatXmlDataSetBuilder();
	
	@Before
	public void initDbunit() throws Exception {
		con = DataSourceUtils.getConnection(dataSource);
		conn = new DatabaseConnection(con);
		
		String ddl = "CREATE TABLE TEST_TAB (ID	INTEGER not null,value decimal(16,4),NAME	VARCHAR(32),DATE	TIMESTAMP)";
		Connection conn_new = dataSource.getConnection();
//		conn_new.setAutoCommit(false);
		conn_new.createStatement().execute(ddl);
//		conn_new.commit();
		conn_new.close();
	}
	
	@After
	public void after() throws SQLException{
		DataSourceUtils.releaseConnection(con, dataSource);
		con.rollback();
		String ddl = "drop TABLE TEST_TAB";
		Connection conn_new = dataSource.getConnection();
//		conn_new.setAutoCommit(false);
		conn_new.createStatement().execute(ddl);
//		conn_new.commit();
		conn_new.close();
	}
	
	String dataSourceStr = "";
	String tableName = "test_tab";
	
	@SuppressWarnings({ "rawtypes" })
	protected Object insert(){
		String primaryKey = "id";
		String cmd="insert";
		String str = "[{id:11,name:'123',value:'-0.063',date:'2011-9-20 12:00:00.0'},{id:12,name:'456',value:'0.02',date:'2011-7-12 12:00:00.0'}]";
		List records = (List)jsonHelper.read(str);
		return sqlUpdate.cud(cmd, dataSourceStr, tableName, primaryKey, records);
	}
	
	@SuppressWarnings({ "rawtypes", "unused" })
	@Test
	public void testTimestamp(){
		String primaryKey = "id";
		String cmd="insert";
		String str = "[{id:11,name:'123',value:'-0.063',date:'2011-9-20T12:00:00'},{id:12,name:'456',value:'0.02',date:'2011-7-12T12:00:00'}]";
		List records = (List)jsonHelper.read(str);
		Object obj = sqlUpdate.cud(cmd, dataSourceStr, tableName, primaryKey, records);
		
		QueryDataSet actual = new QueryDataSet(conn);
		try {
			actual.addTable("test_tab","select * from test_tab where id in(11,12) order by id");
			IDataSet expected = builder.build(new ClassPathResource("com/asiainfo/pst/datastore/sql_update.xml").getFile());
			Assertion.assertEquals(expected, actual);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	/**
	 * 测试插入成功
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Test
	public void testSuccess() {
		
		try {
			Object actualRes = insert();
			
			Map expectedRes = new HashMap();
			expectedRes.put("success", true);
			expectedRes.put("msg", "成功更新数据");
			Assert.assertEquals(expectedRes, actualRes);
			
			QueryDataSet actual = new QueryDataSet(conn);
			actual.addTable("test_tab","select * from test_tab where id in(11,12) order by id");
			IDataSet expected = builder.build(new ClassPathResource("com/asiainfo/pst/datastore/sql_update.xml").getFile());
			Assertion.assertEquals(expected, actual);
		
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}

	/**
	 * 测试插入失败
	 */
	@SuppressWarnings({ "rawtypes", "deprecation" })
	@Test
	public void testFailed() {
		String cmd = "insert";
		String primaryKey = "id";
		try {
			//测试插入失败
			String str = "[{id:11,name:'123',date:'2011-9-20 12:00:00.0'},{name:'456',date:'2011-7-12 12:00:00.0'}]";
			List records = (List)jsonHelper.read(str);
			Object actualRes = sqlUpdate.cud(cmd, dataSourceStr, tableName, primaryKey, records);
			Assert.assertFalse((Boolean)((Map)actualRes).get("success"));
			//同一个会话（session）应该有一个成功一个失败
			String countSql = "select count(*) from test_tab where id in(11,12)";
			JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
			Assert.assertEquals(1, jdbcTemplate.queryForInt(countSql));
			
			//不同的会话应该是0，因为操作是一个事务，一条失败全部失败
			Connection conn_new = dataSource.getConnection();
			ResultSet rs = conn_new.createStatement().executeQuery(countSql);
			if(rs.next()){
				Assert.assertEquals(0, rs.getInt(1));
			}
			rs.close();
			conn_new.close();
			
			System.out.println(((Map)actualRes).get("msg"));

		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Test
	public void testUpdateNoExistColumn(){
		insert();
		try {
			QueryDataSet actual = new QueryDataSet(conn);
			actual.addTable("test_tab","select * from test_tab where id in (11,12) order by id");
			IDataSet expected = builder.build(new ClassPathResource("com/asiainfo/pst/datastore/sql_update.xml").getFile());
			Assertion.assertEquals(expected, actual);
			String primaryKey = "id";
			String cmd = "update";
			String str = "[{id:11,name:'修改',value:'-0.001',date:'2011-9-21 12:00:00.0',noexistcolumn:12},{id:12,name:'修改1',date:'2011-7-11 12:00:00.0'}]";
			List records = (List)jsonHelper.read(str);
			Object actualRes = sqlUpdate.cud(cmd, dataSourceStr, tableName, primaryKey, records);
			Map expectedRes = new HashMap();
			expectedRes.put("success", true);
			expectedRes.put("msg", "成功更新数据");
			actual = new QueryDataSet(conn);
			actual.addTable("test_tab","select * from test_tab where id in(11,12) order by id");
			expected = builder.build(new ClassPathResource("com/asiainfo/pst/datastore/sql_update_modify.xml").getFile());
			Assertion.assertEquals(expected, actual);
			Assert.assertEquals(expectedRes, actualRes);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Test
	public void testUpdate(){
		insert();
		try {
			QueryDataSet actual = new QueryDataSet(conn);
			actual.addTable("test_tab","select * from test_tab where id in(11,12)  order by id");
			IDataSet expected = builder.build(new ClassPathResource("com/asiainfo/pst/datastore/sql_update.xml").getFile());
			Assertion.assertEquals(expected, actual);
			String primaryKey = "id";
			String cmd = "update";
			String str = "[{id:11,name:'修改',value:'-0.001',date:'2011-9-21 12:00:00.0'},{id:12,name:'修改1',date:'2011-7-11 12:00:00.0'}]";
			List records = (List)jsonHelper.read(str);
			Object actualRes = sqlUpdate.cud(cmd, dataSourceStr, tableName, primaryKey, records);
			Map expectedRes = new HashMap();
			expectedRes.put("success", true);
			expectedRes.put("msg", "成功更新数据");
			actual = new QueryDataSet(conn);
			actual.addTable("test_tab","select * from test_tab where id in(11,12) order by id");
			expected = builder.build(new ClassPathResource("com/asiainfo/pst/datastore/sql_update_modify.xml").getFile());
			Assertion.assertEquals(expected, actual);
			Assert.assertEquals(expectedRes, actualRes);
			
			
			//测试复合主键
			primaryKey = "id,name";
			cmd = "update";
			str = "[{id:11,name:'修改',date:'2010-12-31 12:00:00.0',value:-0.063},{id:12,name:'修改1',date:'2010-12-31 12:00:00.0',value:0.02}]";
			records = (List)jsonHelper.read(str);
			actualRes = sqlUpdate.cud(cmd, dataSourceStr, tableName, primaryKey, records);
			expectedRes = new HashMap();
			expectedRes.put("success", true);
			expectedRes.put("msg", "成功更新数据");
			actual = new QueryDataSet(conn);
			actual.addTable("test_tab","select * from test_tab where id in(11,12) order by id");
			expected = builder.build(new ClassPathResource("com/asiainfo/pst/datastore/sql_update_modify2.xml").getFile());
			Assertion.assertEquals(expected, actual);
			Assert.assertEquals(expectedRes, actualRes);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Test
	public void testUpdate1(){
		//测试更新同一条记录
		insert();
		try {
			QueryDataSet actual = new QueryDataSet(conn);
			actual.addTable("test_tab","select * from test_tab where id in(11,12)  order by id");
			IDataSet expected = builder.build(new ClassPathResource("com/asiainfo/pst/datastore/sql_update.xml").getFile());
			Assertion.assertEquals(expected, actual);
			
			String primaryKey = "id";
			String cmd = "update";
			String str = "[{id:11,name:'修改'},{id:11,name:'修改1',date:'2011-12-31 12:00:00.0'}]";
			List records = (List)jsonHelper.read(str);
			Object actualRes = sqlUpdate.cud(cmd, dataSourceStr, tableName, primaryKey, records);
			Map expectedRes = new HashMap();
			expectedRes.put("success", true);
			expectedRes.put("msg", "成功更新数据");
			actual = new QueryDataSet(conn);
			actual.addTable("test_tab","select * from test_tab where id in(11) order by id");
			expected = builder.build(new ClassPathResource("com/asiainfo/pst/datastore/sql_update_modify3.xml").getFile());
			Assertion.assertEquals(expected, actual);
			Assert.assertEquals(expectedRes, actualRes);
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Test
	public void testDelete(){
		try {
			insert();
			QueryDataSet actual = new QueryDataSet(conn);
			actual.addTable("test_tab","select * from test_tab where id in(11,12)");
			Assert.assertEquals(2, actual.getTable("test_tab").getRowCount());
			
			String cmd="delete";
			String str = "[{id:11,name:'修改',date:'2011-9-21 12:00:00.0'},{id:12,name:'修改1',date:'2011-7-11 12:00:00.0'}]";
			List records = (List)jsonHelper.read(str);
			
			String primaryKey = "id";
			Object actualRes = sqlUpdate.cud(cmd, dataSourceStr, tableName, primaryKey, records);
			actual = new QueryDataSet(conn);
			actual.addTable("test_tab", "select * from test_tab where id in(11,12)");
			Assert.assertEquals(0, actual.getTable("test_tab").getRowCount());
			Map expectedRes = new HashMap();
			expectedRes.put("success", true);
			expectedRes.put("msg", "成功更新数据");
			Assert.assertEquals( expectedRes,actualRes);
			
			//复合主键删除
			insert();
			actual = new QueryDataSet(conn);
			actual.addTable("test_tab","select * from test_tab where id in(11,12)");
			Assert.assertEquals(2, actual.getTable("test_tab").getRowCount());
			
			cmd="delete";
			str = "[{id:11,name:'123',date:'2011-9-21 12:00:00.0'},{id:12,name:'456',date:'2011-7-11 12:00:00.0'}]";
			records = (List)jsonHelper.read(str);
			
			primaryKey = "id,name";
			actualRes = sqlUpdate.cud(cmd, dataSourceStr, tableName, primaryKey, records);
			actual = new QueryDataSet(conn);
			actual.addTable("test_tab", "select * from test_tab where id in(11,12)");
			Assert.assertEquals(0, actual.getTable("test_tab").getRowCount());
			expectedRes = new HashMap();
			expectedRes.put("success", true);
			expectedRes.put("msg", "成功更新数据");
			Assert.assertEquals(expectedRes,actualRes);
			
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
		
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Test
	public void testDeleteZeroRow(){
		try {
			String cmd="delete";
			String str = "[{id:11,name:'修改',date:'2011-9-21 12:00:00.0'},{id:12,name:'修改1',date:'2011-7-11 12:00:00.0'}]";
			List records = (List)jsonHelper.read(str);
			
			String primaryKey = "id";
			Object actualRes = sqlUpdate.cud(cmd, dataSourceStr, tableName, primaryKey, records);
			QueryDataSet actual = new QueryDataSet(conn);
			actual.addTable("test_tab", "select * from test_tab where id in(11,12)");
			Assert.assertEquals(0, actual.getTable("test_tab").getRowCount());
			Map expectedRes = new HashMap();
			expectedRes.put("success", true);
			expectedRes.put("msg", "成功更新数据");
			Assert.assertEquals(expectedRes,actualRes);
			
		} catch (Exception e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		}
		
	}

}
