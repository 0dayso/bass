package com.asiainfo.hb.core.datastore;

import java.util.List;
import java.util.Map;

import static org.junit.Assert.*;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.models.JsonHelper;

/**
 * 
 * 必须要FPF_USER_USER 表的支持
 * 
 * @author Mei Kefu
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
public class SqlQueryTest{
	
	@Autowired
	private SqlQuery sqlQuery;
	
	@SuppressWarnings({ "rawtypes", "unused", "deprecation" })
	@Test
	public void testQuery(){
		String sql = "select userid,username,status,date(createtime) date,createtime from FPF_USER_USER";
		String dataSource="";
		String limit="10";
		String start="0";
		SqlQueryResultVo result = sqlQuery.queryLimit(sql, dataSource, limit, start);
		
		assertNotNull(result);//不等为空
		
		List data = result.getRoot();
		assertEquals(Integer.valueOf(limit).intValue(),data.size());
		
		Map fristLineData = (Map)data.get(0);
		//assertEquals
		
		//返回的对象格式
		validateMetaInfo(result);
		
		//测试返回的总数据行数
		Integer count = (Integer)result.getCount();
		
		assertEquals(new JdbcTemplate(dataSource,false).queryForInt("select count(*) from FPF_USER_USER"),count.intValue());
		
		//sql语句报错就是返回一个错误信息在对象中
		String sqlError = "select userid,username,status,date(createtime) date,createtime from FPF_USER_USER where err";
		SqlQueryResultVo resultError = sqlQuery.queryLimit(sqlError, dataSource, limit, start);
		assertEquals("SQL语句有错误",resultError.getMessage());
		
		
		//limit 为-1 返回所有的数据
		String limitMax = "-1";
		SqlQueryResultVo resultTotal = sqlQuery.queryLimit(sql, dataSource, limitMax, start);
		Integer countTotal = (Integer)resultTotal.getCount();
		List dataTotal = (List)resultTotal.getRoot();
		assertEquals(countTotal.intValue(),dataTotal.size());
		
		
		//测试返回空数据的 fields 和 columnModel 不为空
		String sqlCountZero = "select userid,username,status,date(createtime) date,createtime from FPF_USER_USER where 1=2";
		SqlQueryResultVo resultCountZero = sqlQuery.queryLimit(sqlCountZero, dataSource, limit, start);
		validateMetaInfo(resultCountZero);
	}
	
	@SuppressWarnings({ "rawtypes" })
	private void validateMetaInfo(SqlQueryResultVo result){
		List fields = (List)result.getFields();
		Map fielsId = (Map)fields.get(0);
		assertEquals("USERID",fielsId.get("name"));
		assertEquals("string",fielsId.get("type"));
		
		Map fielsName = (Map)fields.get(1);
		assertEquals("USERNAME",fielsName.get("name"));
		assertEquals("string",fielsName.get("type"));
		
		Map fielsCity = (Map)fields.get(2);
		assertEquals("STATUS",fielsCity.get("name"));
		assertEquals("int",fielsCity.get("type"));
		
		Map fieldsDate = (Map)fields.get(3);
		assertEquals("DATE",fieldsDate.get("name"));
		assertEquals("date",fieldsDate.get("type"));
		assertEquals("Y-m-d",fieldsDate.get("dateFormat"));
		
		Map fieldsTimestamp = (Map)fields.get(4);
		assertEquals("CREATETIME",fieldsTimestamp.get("name"));
		assertEquals("date",fieldsTimestamp.get("type"));
		assertEquals("Y-m-d H:i:s",fieldsTimestamp.get("dateFormat"));
		
		List columnModel = (List)result.getColumnModel();
		Map columnModelId = (Map)columnModel.get(0);
		assertEquals("USERID",columnModelId.get("dataIndex"));
		assertEquals("USERID",columnModelId.get("header"));
		assertEquals("string",columnModelId.get("type"));
		
		Map columnModelName = (Map)columnModel.get(1);
		assertEquals("USERNAME",columnModelName.get("dataIndex"));
		assertEquals("USERNAME",columnModelName.get("header"));
		assertEquals("string",columnModelName.get("type"));
		
		Map columnModelCity = (Map)columnModel.get(2);
		assertEquals("STATUS",columnModelCity.get("dataIndex"));
		assertEquals("STATUS",columnModelCity.get("header"));
		assertEquals("int",columnModelCity.get("type"));
		
	}
	
	@SuppressWarnings({ "rawtypes" })
	@Test
	public void testDimMapping(){
		String sql = "select area_id,cust_name, sex_id,birth_date,brand_id,tm_tid,nbilling_tid from nmk.gmi_mbuser_200610";
		String dataSource="";
		String limit="25";
		String start="0";
		String mapJsonStr = "{\"sex_id\":\"DIM_PUB_SEX\",\"area_id\":\"DIM_AREACOUNTY\",\"nbilling_tid\":\"DIM_BRAND\"}";
		Map dimMappingList = (Map)JsonHelper.getInstance().read(mapJsonStr);
		
		Map<String,Map<String,String>> dimMap = sqlQuery.fetchDimMapping(dimMappingList, dataSource);
		
		assertTrue(dimMap.get("SEX_ID").size()>0);
		
		SqlQueryResultVo result = sqlQuery.queryLimit(sql, dataSource, limit, start,dimMappingList);
		List root = (List)result.getRoot();
		assertEquals(((Map)root.get(0)).get("AREA_ID"),"武汉市");
		System.out.println(result);
		
		List columnModel = (List)result.getColumnModel();
		
		Map sexCol = (Map)columnModel.get(2);
		
		assertEquals("SEX_ID",sexCol.get("dataIndex"));
		
		assertEquals("string",sexCol.get("type"));
	}
}
