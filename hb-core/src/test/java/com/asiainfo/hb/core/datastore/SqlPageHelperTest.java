package com.asiainfo.hb.core.datastore;

import static junit.framework.Assert.*;
import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class SqlPageHelperTest{
	
	@Test
	public void testDb2Sql(){
		String sql ="select a.local_call_charge as AT2_2,a.ldxs_charge as AT2_20,b.area_id as AT1_7,b.nbilling_tid as AT1_14,b.channel_code as AT1_9,b.mcust_lid as AT1_5,b.sex_id as AT1_4,b.acc_nbr as AT1_2,c.sum_call_times as AT3_2,d.sum_call_times as AT3_2_P1,e.term_bind_lastdt as AT4_6,b.eff_date as AT1_10,b.act_tid as AT1_11,b.brand_id as AT1_12,b.tm_tid as AT1_13,b.age as AT1_6,b.county_id as AT1_8 from NMK.GMI_MBUSER_ACCTITEM_201108 a,NMK.DW_MBUSER_INFO_201108 b,NMK.AMS_MBUSER_201108 c,NMK.AMS_MBUSER_201107 d,NMK.GMI_SERV_BIND_201108 e where d.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = e.SERV_ID and b.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = a.MBUSER_ID and (b.mbuser_id>=2700000000000 and b.mbuser_id<=2700000010003) and (b.county_id in ( 'HB.WH.01')) and (b.area_id in ( 'HB.WH')) and (b.mcust_lid in ( 'VC1200','2'));";
		int limit=30;
		int start=30;
		//sqlQuery.queryLimit(sql, dataSource, limit, start);
		SqlPageHelper sqlPageHelper = new Db2SqlPageHelper();
		
		System.out.println(sqlPageHelper.getLimitSQL(sql, limit, start));
		
		assertEquals("select * from (select t.*,rownumber() over() as pseudo_column_rownum from (select a.local_call_charge as AT2_2,a.ldxs_charge as AT2_20,b.area_id as AT1_7,b.nbilling_tid as AT1_14,b.channel_code as AT1_9,b.mcust_lid as AT1_5,b.sex_id as AT1_4,b.acc_nbr as AT1_2,c.sum_call_times as AT3_2,d.sum_call_times as AT3_2_P1,e.term_bind_lastdt as AT4_6,b.eff_date as AT1_10,b.act_tid as AT1_11,b.brand_id as AT1_12,b.tm_tid as AT1_13,b.age as AT1_6,b.county_id as AT1_8 from NMK.GMI_MBUSER_ACCTITEM_201108 a,NMK.DW_MBUSER_INFO_201108 b,NMK.AMS_MBUSER_201108 c,NMK.AMS_MBUSER_201107 d,NMK.GMI_SERV_BIND_201108 e where d.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = e.SERV_ID and b.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = a.MBUSER_ID and (b.mbuser_id>=2700000000000 and b.mbuser_id<=2700000010003) and (b.county_id in ( 'HB.WH.01')) and (b.area_id in ( 'HB.WH')) and (b.mcust_lid in ( 'VC1200','2')) order by 1) t) t2 where pseudo_column_rownum between 31 and 60 with ur"
		,sqlPageHelper.getLimitSQL(sql, limit, start));
	}
	
	@Test
	public void testOracleSql(){
		String sql ="select a.local_call_charge as AT2_2,a.ldxs_charge as AT2_20,b.area_id as AT1_7,b.nbilling_tid as AT1_14,b.channel_code as AT1_9,b.mcust_lid as AT1_5,b.sex_id as AT1_4,b.acc_nbr as AT1_2,c.sum_call_times as AT3_2,d.sum_call_times as AT3_2_P1,e.term_bind_lastdt as AT4_6,b.eff_date as AT1_10,b.act_tid as AT1_11,b.brand_id as AT1_12,b.tm_tid as AT1_13,b.age as AT1_6,b.county_id as AT1_8 from NMK.GMI_MBUSER_ACCTITEM_201108 a,NMK.DW_MBUSER_INFO_201108 b,NMK.AMS_MBUSER_201108 c,NMK.AMS_MBUSER_201107 d,NMK.GMI_SERV_BIND_201108 e where d.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = e.SERV_ID and b.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = a.MBUSER_ID and (b.mbuser_id>=2700000000000 and b.mbuser_id<=2700000010003) and (b.county_id in ( 'HB.WH.01')) and (b.area_id in ( 'HB.WH')) and (b.mcust_lid in ( 'VC1200','2'));";
		int limit=30;
		int start=30;
		//sqlQuery.queryLimit(sql, dataSource, limit, start);
		SqlPageHelper sqlPageHelper = new OracleSqlPageHelper();
		
		System.out.println(sqlPageHelper.getLimitSQL(sql, limit, start));
		
		assertEquals("select * from (select t.*,rownum as pseudo_column_rownum from (select a.local_call_charge as AT2_2,a.ldxs_charge as AT2_20,b.area_id as AT1_7,b.nbilling_tid as AT1_14,b.channel_code as AT1_9,b.mcust_lid as AT1_5,b.sex_id as AT1_4,b.acc_nbr as AT1_2,c.sum_call_times as AT3_2,d.sum_call_times as AT3_2_P1,e.term_bind_lastdt as AT4_6,b.eff_date as AT1_10,b.act_tid as AT1_11,b.brand_id as AT1_12,b.tm_tid as AT1_13,b.age as AT1_6,b.county_id as AT1_8 from NMK.GMI_MBUSER_ACCTITEM_201108 a,NMK.DW_MBUSER_INFO_201108 b,NMK.AMS_MBUSER_201108 c,NMK.AMS_MBUSER_201107 d,NMK.GMI_SERV_BIND_201108 e where d.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = e.SERV_ID and b.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = a.MBUSER_ID and (b.mbuser_id>=2700000000000 and b.mbuser_id<=2700000010003) and (b.county_id in ( 'HB.WH.01')) and (b.area_id in ( 'HB.WH')) and (b.mcust_lid in ( 'VC1200','2'))) t order by 1) t2 where pseudo_column_rownum between 31 and 60"
		,sqlPageHelper.getLimitSQL(sql, limit, start));
	}
	
	@Test
	public void testMysql(){
		String sql ="select a.local_call_charge as AT2_2,a.ldxs_charge as AT2_20,b.area_id as AT1_7,b.nbilling_tid as AT1_14,b.channel_code as AT1_9,b.mcust_lid as AT1_5,b.sex_id as AT1_4,b.acc_nbr as AT1_2,c.sum_call_times as AT3_2,d.sum_call_times as AT3_2_P1,e.term_bind_lastdt as AT4_6,b.eff_date as AT1_10,b.act_tid as AT1_11,b.brand_id as AT1_12,b.tm_tid as AT1_13,b.age as AT1_6,b.county_id as AT1_8 from NMK.GMI_MBUSER_ACCTITEM_201108 a,NMK.DW_MBUSER_INFO_201108 b,NMK.AMS_MBUSER_201108 c,NMK.AMS_MBUSER_201107 d,NMK.GMI_SERV_BIND_201108 e where d.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = e.SERV_ID and b.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = a.MBUSER_ID and (b.mbuser_id>=2700000000000 and b.mbuser_id<=2700000010003) and (b.county_id in ( 'HB.WH.01')) and (b.area_id in ( 'HB.WH')) and (b.mcust_lid in ( 'VC1200','2'));";
		int limit=30;
		int start=30;
		//sqlQuery.queryLimit(sql, dataSource, limit, start);
		SqlPageHelper sqlPageHelper = new MysqlSqlPageHelper();
		
		System.out.println(sqlPageHelper.getLimitSQL(sql, limit, start));
		
		assertEquals("select a.local_call_charge as AT2_2,a.ldxs_charge as AT2_20,b.area_id as AT1_7,b.nbilling_tid as AT1_14,b.channel_code as AT1_9,b.mcust_lid as AT1_5,b.sex_id as AT1_4,b.acc_nbr as AT1_2,c.sum_call_times as AT3_2,d.sum_call_times as AT3_2_P1,e.term_bind_lastdt as AT4_6,b.eff_date as AT1_10,b.act_tid as AT1_11,b.brand_id as AT1_12,b.tm_tid as AT1_13,b.age as AT1_6,b.county_id as AT1_8 from NMK.GMI_MBUSER_ACCTITEM_201108 a,NMK.DW_MBUSER_INFO_201108 b,NMK.AMS_MBUSER_201108 c,NMK.AMS_MBUSER_201107 d,NMK.GMI_SERV_BIND_201108 e where d.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = e.SERV_ID and b.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = a.MBUSER_ID and (b.mbuser_id>=2700000000000 and b.mbuser_id<=2700000010003) and (b.county_id in ( 'HB.WH.01')) and (b.area_id in ( 'HB.WH')) and (b.mcust_lid in ( 'VC1200','2')) limit 31 , 60"
		,sqlPageHelper.getLimitSQL(sql, limit, start));
	}
	
	@Test
	public void testSqlserverSql(){
		String sql ="select a.local_call_charge as AT2_2,a.ldxs_charge as AT2_20,b.area_id as AT1_7,b.nbilling_tid as AT1_14,b.channel_code as AT1_9,b.mcust_lid as AT1_5,b.sex_id as AT1_4,b.acc_nbr as AT1_2,c.sum_call_times as AT3_2,d.sum_call_times as AT3_2_P1,e.term_bind_lastdt as AT4_6,b.eff_date as AT1_10,b.act_tid as AT1_11,b.brand_id as AT1_12,b.tm_tid as AT1_13,b.age as AT1_6,b.county_id as AT1_8 from NMK.GMI_MBUSER_ACCTITEM_201108 a,NMK.DW_MBUSER_INFO_201108 b,NMK.AMS_MBUSER_201108 c,NMK.AMS_MBUSER_201107 d,NMK.GMI_SERV_BIND_201108 e where d.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = e.SERV_ID and b.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = a.MBUSER_ID and (b.mbuser_id>=2700000000000 and b.mbuser_id<=2700000010003) and (b.county_id in ( 'HB.WH.01')) and (b.area_id in ( 'HB.WH')) and (b.mcust_lid in ( 'VC1200','2'));";
		int limit=30;
		int start=30;
		//sqlQuery.queryLimit(sql, dataSource, limit, start);
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		
		System.out.println(sqlPageHelper.getLimitSQL(sql, limit, start,"ordcol"));
		
		assertEquals("select * from (select t.*,ROW_NUMBER() over(order by ordcol) as pseudo_column_rownum from (select a.local_call_charge as AT2_2,a.ldxs_charge as AT2_20,b.area_id as AT1_7,b.nbilling_tid as AT1_14,b.channel_code as AT1_9,b.mcust_lid as AT1_5,b.sex_id as AT1_4,b.acc_nbr as AT1_2,c.sum_call_times as AT3_2,d.sum_call_times as AT3_2_P1,e.term_bind_lastdt as AT4_6,b.eff_date as AT1_10,b.act_tid as AT1_11,b.brand_id as AT1_12,b.tm_tid as AT1_13,b.age as AT1_6,b.county_id as AT1_8 from NMK.GMI_MBUSER_ACCTITEM_201108 a,NMK.DW_MBUSER_INFO_201108 b,NMK.AMS_MBUSER_201108 c,NMK.AMS_MBUSER_201107 d,NMK.GMI_SERV_BIND_201108 e where d.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = e.SERV_ID and b.MBUSER_ID = c.MBUSER_ID and b.MBUSER_ID = a.MBUSER_ID and (b.mbuser_id>=2700000000000 and b.mbuser_id<=2700000010003) and (b.county_id in ( 'HB.WH.01')) and (b.area_id in ( 'HB.WH')) and (b.mcust_lid in ( 'VC1200','2'))) t) t2 where pseudo_column_rownum between 31 and 60 "
		,sqlPageHelper.getLimitSQL(sql, limit, start,"ordcol"));
	}
}
