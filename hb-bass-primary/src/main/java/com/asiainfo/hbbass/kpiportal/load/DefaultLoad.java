package com.asiainfo.hbbass.kpiportal.load;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import org.apache.log4j.Logger;

import com.asiainfo.bass.components.models.ConnectionManage;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityLoad;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValue;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueCell;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueCells;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueState;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalException;

/**
 * 默认加载方式
 * 
 * @author Mei Kefu
 * 
 */
public class DefaultLoad extends BaseLoad implements KPIEntityLoad {
	private static Logger LOG = Logger.getLogger(DefaultLoad.class);
	private static final long serialVersionUID = -1586183001923813081L;

	@SuppressWarnings("rawtypes")
	public KPIEntity loadNoCached(String parentRegionId) throws KPIPortalException {

		String sql = "";
		String appName = kpiEntity.getKpiAppData().getName();
		DBMapping dbMapping = dbMapping();
		if ("ChannelD".equalsIgnoreCase(appName))
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value(targetvalue,0) targetvalue,sum(case when time_id =? then value end) as current,value(sum(case when time_id =? then value end),0) as pre,value(sum(case when time_id =? then value end),0) as before,value(sum(case when time_id =? then value end),0) as year from "
					+ dbMapping.tableName + /*"_channel_" + parentRegionId.substring(3, 5) +*/ " left join kpiportal_target on ZB_CODE=ZBCODE and CHANNEL_CODE=AREA_ID where time_id in (?,?,?,?) and zb_code = ? and parent_channel_code=? group by channel_code,parent_channel_code,targetvalue order by current desc with ur";
		else if ("ChannelM".equalsIgnoreCase(appName))
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value(targetvalue,0) targetvalue,sum(case when time_id =? then value end) as current,value(sum(case when time_id =? then value end),0) as pre,value(sum(case when time_id =? then value end),0) as before,value(sum(case when time_id =? then value end),0) as year from "
					+ dbMapping.tableName + " left join kpiportal_target on ZB_CODE=ZBCODE and CHANNEL_CODE=AREA_ID where time_id in (?,?,?,?) and zb_code = ? and parent_channel_code=? group by channel_code,parent_channel_code,targetvalue order by current desc with ur";
		else if ("BureauD".equalsIgnoreCase(appName))
			sql = "select region_id, max(value(region_name,'')) region_name,parent_id,'' brand_id,targetvalue,sum(case when time_id =? then value end) as current,value(sum(case when time_id =? then value end),0) as pre,value(sum(case when time_id =? then value end),0) as before,value(sum(case when time_id =? then value end),0) as year from "
					+ dbMapping.tableName + " left join kpiportal_target on ZB_CODE=ZBCODE and region_id=AREA_ID where time_id in (?,?,?,?) and zb_code = ? and parent_id=? group by region_id,parent_id,targetvalue,level order by current desc with ur";
		else if ("BureauM".equalsIgnoreCase(appName))
			sql = "select region_id, max(value(region_name,'')) region_name,parent_id,'' brand_id,targetvalue,sum(case when time_id =? then value end) as current,value(sum(case when time_id =? then value end),0) as pre,value(sum(case when time_id =? then value end),0) as before,value(sum(case when time_id =? then value end),0) as year from "
					+ dbMapping.tableName + " left join kpiportal_target on ZB_CODE=ZBCODE and region_id=AREA_ID where time_id in (?,?,?,?) and zb_code = ? and parent_id=? group by region_id,parent_id,targetvalue,level order by current desc with ur";
		else if ("GroupcustD".equalsIgnoreCase(appName))
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value(targetvalue,0) targetvalue,sum(case when time_id =? then value end) as current,value(sum(case when time_id =? then value end),0) as pre,value(sum(case when time_id =? then value end),0) as before,value(sum(case when time_id =? then value end),0) as year from "
					+ dbMapping.tableName + " left join kpiportal_target on ZB_CODE=ZBCODE and CHANNEL_CODE=AREA_ID where time_id in (?,?,?,?) and zb_code = ? and parent_channel_code=? group by channel_code,parent_channel_code,targetvalue order by current desc with ur";
		else if ("GroupcustM".equalsIgnoreCase(appName))
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value(targetvalue,0) targetvalue,sum(case when time_id =? then value end) as current,value(sum(case when time_id =? then value end),0) as pre,value(sum(case when time_id =? then value end),0) as before,value(sum(case when time_id =? then value end),0) as year from "
					+ dbMapping.tableName + " left join kpiportal_target on ZB_CODE=ZBCODE and CHANNEL_CODE=AREA_ID where time_id in (?,?,?,?) and zb_code = ? and parent_channel_code=? group by channel_code,parent_channel_code,targetvalue order by current desc with ur";
		else if ("CollegeD".equalsIgnoreCase(appName))
			sql = "select region_id, max(value(region_name,'')) region_name,parent_id,value(targetvalue,0) targetvalue,value(brand_id,'-1') brand_id,sum(case when time_id =? then value end) as current,value(sum(case when time_id =? then value end),0) as pre,value(sum(case when time_id =? then value end),0) as before,value(sum(case when time_id =? then value end),0) as year from "
					+ dbMapping.tableName + " left join kpiportal_target on ZB_CODE=ZBCODE and region_id=AREA_ID where time_id in (?,?,?,?) and zb_code = ? and parent_id=? group by region_id,parent_id,targetvalue,level,brand_id order by current desc with ur";
		else if ("CollegeM".equalsIgnoreCase(appName))
			sql = "select region_id, max(value(region_name,'')) region_name,parent_id,value(targetvalue,0) targetvalue,value(brand_id,'-1') brand_id,sum(case when time_id =? then value end) as current,value(sum(case when time_id =? then value end),0) as pre,value(sum(case when time_id =? then value end),0) as before,value(sum(case when time_id =? then value end),0) as year from "
					+ dbMapping.tableName + " left join kpiportal_target on ZB_CODE=ZBCODE and region_id=AREA_ID where time_id in (?,?,?,?) and zb_code = ? and parent_id=? group by region_id,parent_id,targetvalue,level,brand_id order by current desc with ur";
		else if ("CsD".equalsIgnoreCase(appName))
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,value(brand_id,'-1') brand_id,value(targetvalue,0) targetvalue,sum(case when time_id =? then value end) as current,value(sum(case when time_id =? then value end),0) as pre,value(sum(case when time_id =? then value end),0) as before,value(sum(case when time_id =? then value end),0) as year from "
					+ dbMapping.tableName + " left join kpiportal_target on ZB_CODE=ZBCODE and CHANNEL_CODE=AREA_ID where time_id in (?,?,?,?) and zb_code = ? and parent_channel_code=? group by channel_code,parent_channel_code,targetvalue,brand_id order by current desc with ur";
		else if ("CsM".equalsIgnoreCase(appName))
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,value(brand_id,'-1') brand_id,value(targetvalue,0) targetvalue,sum(case when time_id =? then value end) as current,value(sum(case when time_id =? then value end),0) as pre,value(sum(case when time_id =? then value end),0) as before,value(sum(case when time_id =? then value end),0) as year from "
					+ dbMapping.tableName + " left join kpiportal_target on ZB_CODE=ZBCODE and CHANNEL_CODE=AREA_ID where time_id in (?,?,?,?) and zb_code = ? and parent_channel_code=? group by channel_code,parent_channel_code,targetvalue,brand_id order by current desc with ur";

		LOG.info("默认加载非缓存数据SQL:" + sql);
		Connection conn = null;
		List list = null;
		try {
			String[] dates = KPIPortalContext.calDate(kpiEntity.getDate());
			String current = kpiEntity.getDate();
			String pre = dates[0];
			String before = dates[1];
			String year = dates[2];
			String zbCode = kpiEntity.getId();

			String cacheKey = sql + current + pre + before + year + current + pre + before + year + zbCode + parentRegionId;

			list = (List) getObjectFromCache(cacheKey);
			if (list == null) {
				conn = ConnectionManage.getInstance().getDWConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, current);
				ps.setString(2, pre);
				ps.setString(3, before);
				ps.setString(4, year);
				ps.setString(5, current);
				ps.setString(6, pre);
				ps.setString(7, before);
				ps.setString(8, year);
				ps.setString(9, zbCode);
				ps.setString(10, parentRegionId);
				list = mapping(resultsetMappList(ps.executeQuery()));
				ps.close();

				putObjectToCache(cacheKey, list);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(conn);
		}
		KPIEntity newKPIEntity = noCachedprocess(list, parentRegionId);
		return newKPIEntity;
	}

	/**
	 * 计算放入缓存中的索引，虽然会重复计算，但是相对数据库的开销和以后的维护还是这样更合理
	 * 
	 * @param regionIds
	 * @param state
	 * @param timeStart
	 * @param timeEnd
	 * @return
	 */
	protected String keySQL(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) {
		return duringProcessSQL(regionIds, state, timeStart, timeEnd);
	}

	@SuppressWarnings("rawtypes")
	public final Map loadDuring(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) throws KPIPortalException {
		/*
		 * CacheServerCache cache =
		 * CacheServerFactory.getInstance().getCache("SQL");
		 * 
		 * String key=keySQL(regionIds, state, timeStart,timeEnd); Map map =
		 * (Map)(cache!=null?cache.get(Util.md5(key)):null);
		 * if(map==null||map.size()==0){ synchronized (this){
		 * LOG.debug("锁定对象："+key); map =
		 * (Map)(cache!=null?cache.get(Util.md5(key)):null);
		 * if(map==null||map.size()==0){ map = loadDuringData(regionIds, state,
		 * timeStart,timeEnd); if(cache!=null) cache.put(Util.md5(key), map); }
		 * } } return map;
		 */

		String key = keySQL(regionIds, state, timeStart, timeEnd);
		Map map = (Map) getObjectFromCache(key);
		if (map == null || map.size() == 0) {
			synchronized (this) {
				LOG.debug("锁定对象：" + key);
				map = (Map) getObjectFromCache(key);
				if (map == null || map.size() == 0) {
					map = loadDuringData(regionIds, state, timeStart, timeEnd);
					putObjectToCache(key, map);
				}
			}
		}
		return map;
	}

	/**
	 * 从数据库中加载数据 不是完整的KPIEntity
	 * 
	 * select time_id,max(case when region_id='HB.ES' then region_name
	 * end),sum(case when region_id='HB.ES' then value end),max(case when
	 * region_id='HB.EZ' then region_name end),sum(case when region_id='HB.EZ'
	 * then value end) from kpi_bureau_total_daily where time_id between
	 * '20090406' and '20090416' and region_id in ('HB.ES','HB.EZ') and zb_code
	 * ='K10009' group by time_id order by 1,2 with ur 返回的Map(time_id,Map1)
	 * Map1(regionName,KPIEntityValue)
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected Map loadDuringData(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) throws KPIPortalException {

		String sql = duringProcessSQL(regionIds, state, timeStart, timeEnd);
		LOG.info("加载时间段,用于比较分析SQL:" + sql);
		String[] areas = regionIds.split(",");
		Connection conn = getConnection();
		Map map = new TreeMap();
		try {
			Statement stat = conn.createStatement();
			ResultSet rs = stat.executeQuery(sql);
			while (rs.next()) {
				Map innerMap = new TreeMap();
				for (int i = 0; i < areas.length; i++) {
					String key = rs.getString(i * 2 + 2);
					String value = rs.getString(i * 2 + 3);
					// duringGetValue该方法中还要除一道的，所以这里不用除了
					innerMap.put(key, duringGetValue(Double.valueOf(value).doubleValue(), state));
				}
				map.put(rs.getString(1), innerMap);
			}
			rs.close();
			stat.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				try {
					conn.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
		}
		return map;
	}

	public static void main(String[] args) {
	}

	/**
	 * 默认加载
	 * 
	 * 2010-8-16修改SQL，先取当前时间的，然后左关联以前的时间，这样可以防止已删除的region_id出现在当前时间
	 select t1.region_id, max(value(t1.region_name,'')) region_name,t1.parent_id,value(targetvalue,0) targetvalue,value(t1.brand_id,'-1') brand_id
,max(t1.value) as current
,value(sum(case when t2.time_id ='201006' then t2.value end),0) as pre
,value(sum(case when t2.time_id ='200907' then t2.value end),0) as before
,value(sum(case when t2.time_id ='' then t2.value end),0) as year 
from kpi_college_monthly t1
left join kpiportal_target on t1.ZB_CODE=ZBCODE and t1.region_id=AREA_ID 
left join 
(select * from kpi_college_monthly where time_id in ('201006','200907','') and zb_code='C20007' and level<=3) t2
on t1.ZB_CODE=t2.zb_code and t1.region_id=t2.region_id and t1.brand_id=t2.brand_id and t1.parent_id=t2.parent_id and t1.level=t2.level
where t1.time_id='201007' and t1.zb_code='C20007' and t1.level<=3 
group by t1.region_id,t1.parent_id,targetvalue,t1.level,t1.brand_id 
order by t1.level,t1.region_id with ur;

between的sql

select t1.region_id, max(value(t1.region_name,'')) region_name,t1.parent_id,value(targetvalue,0) targetvalue,value('','-1') brand_id
,sum(t1.value) as current
,0 as pre
,0 as before
,0 as year 
from kpi_bureau_town_monthly t1
left join kpiportal_target on t1.ZB_CODE=ZBCODE and t1.region_id=AREA_ID 
where t1.time_id between '201007' and '201008' and t1.zb_code='BM0034' and t1.level<1  
group by t1.region_id,t1.parent_id,t1.level,targetvalue,''
order by t1.level,t1.region_id with ur;
	 */
	@SuppressWarnings("rawtypes")
	public KPIEntity load() throws KPIPortalException {
		String appName = kpiEntity.getKpiAppData().getName();
		DBMapping dbMapping = dbMapping();

		boolean isAggre = isAggre();

		String piece1 = " and level<=" + dbMapping.cacheLevel;
		String piece2 = " and t1.level=t2.level ";
		String piece3 = " and t1.level<=" + dbMapping.cacheLevel;
		String piece4 = ",t1.level";
		String piece5 = "t1.level,";

		if (appName.startsWith("Channel") || appName.startsWith("Groupcust") || appName.startsWith("Cs")) {// 使用没有level的标识的表
			piece1 = "and length(channel_code)<=8 and channel_code like 'HB%'";
			piece2 = "";
			piece3 = "and length(t1.channel_code)<=8 and t1.channel_code like 'HB%'";
			piece4 = "";
			piece5 = "";
		}

		String sql = "select t1." + dbMapping.regionId + " region_id, max(value(t1." + dbMapping.regionName + ",'')) region_name,t1." + dbMapping.parentId + " parent_id,value(targetvalue,0) targetvalue,value(" + dbMapping.brandCol + ",'-1') brand_id";
		if (!isAggre) {
			sql += " ,max(t1.value) as current" + " ,value(sum(case when t2.time_id =? then t2.value end),0) as pre" + " ,value(sum(case when t2.time_id =? then t2.value end),0) as before" + " ,value(sum(case when t2.time_id =? then t2.value end),0) as year ";
		} else {
			sql += ",sum(t1.value) as current" + ",0 as pre" + ",0 as before" + ",0 as year ";
		}

		sql += " from " + dbMapping.tableName + " t1" + " left join kpiportal_target on t1.ZB_CODE=ZBCODE and t1." + dbMapping.regionId + "=AREA_ID ";
		if (!isAggre) {
			sql += " left join (select * from " + dbMapping.tableName + " where time_id in (?,?,?) and zb_code=?" + piece1 + ") t2" + " on t1.ZB_CODE=t2.zb_code and t1." + dbMapping.regionId + "=t2." + dbMapping.regionId + " and t1." + dbMapping.parentId + "=t2." + dbMapping.parentId + dbMapping.brandCondi + piece2
					+ " where t1.time_id=? and t1.zb_code=? " + piece3;
		} else {
			sql += " where t1.time_id between ? and ? and t1.zb_code=? " + piece3;
		}
		sql += " group by t1." + dbMapping.regionId + ",t1." + dbMapping.parentId + ",targetvalue," + dbMapping.brandCol + piece4 + " order by " + piece5 + "t1." + dbMapping.regionId + " with ur";

		Connection conn = null;
		List list = null;
		try {
			String date = kpiEntity.getDate();
			String zbCode = kpiEntity.getId();
			if (!isAggre) {
				String[] dates = KPIPortalContext.calDate(date);
				String current = date;
				String pre = dates[0];
				String before = dates[1];
				String year = dates[2];
				String cacheKey = sql + pre + before + year + pre + before + year + zbCode + current + zbCode;

				list = (List) getObjectFromCache(cacheKey);
				if (list == null) {
					conn = getConnection();
					PreparedStatement ps = conn.prepareStatement(sql);
					ps.setString(1, pre);
					ps.setString(2, before);
					ps.setString(3, year);
					ps.setString(4, pre);
					ps.setString(5, before);
					ps.setString(6, year);
					ps.setString(7, zbCode);
					ps.setString(8, current);
					ps.setString(9, zbCode);

					list = mapping(resultsetMappList(ps.executeQuery()));
					ps.close();
					// 这一步缓存会造成后面PercentLoad的错误不清楚是神马回事啊
					// putObjectToCache(cacheKey, list);
				}
			} else {
				String[] arr = date.split("-");
				String cacheKey = sql + arr[0] + arr[1] + zbCode;

				list = (List) getObjectFromCache(cacheKey);
				if (list == null) {
					conn = getConnection();
					PreparedStatement ps = conn.prepareStatement(sql);

					ps.setString(1, arr[0]);
					ps.setString(2, arr[1]);
					ps.setString(3, zbCode);

					list = mapping(resultsetMappList(ps.executeQuery()));
					ps.close();
					putObjectToCache(cacheKey, list);
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(conn);
		}

		process(list);

		return kpiEntity;
	}
	
	@SuppressWarnings("rawtypes")
	@Override
	public KPIEntity load(KpiDataStore dataStore) throws KPIPortalException {
		if(dataStore==null || dataStore.getData(kpiEntity.getId())==null){
			return load();
		}
		LOG.info("批量数据加载");
		List data = mapping(dataStore.getData(kpiEntity.getId()));
		process(data);
		return kpiEntity;
	}

	@SuppressWarnings({ "rawtypes", "unused" })
	protected void process(List list) {
		if (list != null && list.size() > 0) {
			KPIEntityValue value = (KPIEntityValue) list.get(0);

			/*if (value.getCurrent().getValue().doubleValue() == 0) {
				LOG.warn("指标:" + kpiEntity.getId() + kpiEntity.getKpiAppData().getName() + kpiEntity.getName() + " " + kpiEntity.getDate() + "还没有出来");
			} else*/ {
				initialize(kpiEntity, list);
				LOG.info("指标:" + kpiEntity.getId() + kpiEntity.getKpiAppData().getName() + kpiEntity.getName() + " " + kpiEntity.getDate() + " size:" + kpiEntity.getIndex().size() + " 初始化成功");
			}
		} else {
			LOG.warn("指标:" + kpiEntity.getId() + kpiEntity.getKpiAppData().getName() + kpiEntity.getName() + " " + kpiEntity.getDate() + "还没有出来");
		}
	}

	/**
	 * 赋值方法吧value值赋给KPI
	 * 
	 * @param kpiEntity
	 * @param list
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected void initialize(KPIEntity kpiEntity, List list) {
		if (list.size() > 0) {
			try {
				KPIEntityValue value = (KPIEntityValue) list.get(0);
																	// noCachedprocess调用这个方法的时候会出问题，第一个节点作为root节点了
				KPIEntity.Entity rootEntity = new KPIEntity.Entity();// 传入父KPIEntity的引用
				rootEntity.setParentKPIEntity(kpiEntity);
				// rootEntity.setRootKPIEntity(kpiEntity);//只有root节点才有这个值
				// rootEntity.setRootEntity(rootEntity);//rootEntity也要set自己
				rootEntity.setValue(value);
				value.setParentEntity(rootEntity);// 传入父Entity的引用
				// value.setFilter(kpiEntity.getValueFilter());
				kpiEntity.setRoot(rootEntity);
				kpiEntity.getIndex().put(value.getRegionId(), rootEntity);

			} catch (Exception e) {
				e.printStackTrace();
				LOG.error(this, e);
			}
		}

		for (int i = 1; i < list.size(); i++) {
			try {
				KPIEntityValue value = (KPIEntityValue) list.get(i);
				KPIEntity.Entity parentEntity = null;
				if (kpiEntity.getIndex().containsKey(value.getParentId())) {
					parentEntity = (KPIEntity.Entity) kpiEntity.getIndex().get(value.getParentId());
				} else {
					parentEntity = kpiEntity.getRoot();
				}
				Map children = parentEntity.getChildren();
				if (children == null) {
					children = new LinkedHashMap();
					parentEntity.setChildren(children);
				}
				KPIEntity.Entity newEntity = new KPIEntity.Entity();// 传入父KPIEntity的引用
				newEntity.setValue(value);
				newEntity.setParentKPIEntity(kpiEntity);
				// newEntity.setRootEntity(kpiEntity.getRoot());
				value.setParentEntity(newEntity);// 传入父Entity的引用
				// value.setFilter(kpiEntity.getValueFilter());
				newEntity.setParent(parentEntity);
				children.put(value.getRegionId(), newEntity);
				kpiEntity.getIndex().put(value.getRegionId(), newEntity);

			} catch (Exception e) {
				e.printStackTrace();
				LOG.error(this, e);
			}
		}
	}

	
	protected List<Map<String,String>> resultsetMappList(ResultSet rs) throws SQLException{
		List<Map<String,String>> rowsData = new ArrayList<Map<String,String>>();
		
		ResultSetMetaData rsmd = rs.getMetaData();
		int colCount = rsmd.getColumnCount();
		while(rs.next()){
			
			Map<String,String> map = new HashMap<String,String>();
			
			for (int i = 0; i < colCount; i++) {
				String colName = rsmd.getColumnName(i+1).toLowerCase();
				map.put(colName, rs.getString(colName));
			}
			/*
			String region_id = rs.getString("region_id");
			String region_name = rs.getString("region_name");
			String parent_id = rs.getString("parent_id");
			String brand_id = rs.getString("brand_id");
			String targetvalue = rs.getString("targetvalue");
			String current = rs.getString("current");
			String pre = rs.getString("pre");
			String before = rs.getString("before");
			String year = rs.getString("year");
			String month_accu_value="0";
			try{
				month_accu_value = rs.getString("month_accu_value");
			}catch(Exception e){
				e.printStackTrace();
			}
			
			
			
			map.put("region_name", region_name);
			map.put("parent_id", parent_id);
			map.put("brand_id", brand_id);
			map.put("targetvalue", targetvalue);
			map.put("current", current);
			map.put("pre", pre);
			map.put("before", before);
			map.put("year", year);
			map.put("month_accu_value", month_accu_value); //算累计值时候用
*/			
			rowsData.add(map);
		}
		rs.close();
		return rowsData;
	}
	
	/**
	 * 映射方法，把数据库值，映射成KPIEntityValue
	 * 
	 * @param rs
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected List mapping(List<Map<String,String>> rowsData) {
		List result = new ArrayList();
		Map kpiEntityValueMap = new HashMap();
		KPIEntityValue value = null;
		
		for (Map<String,String> row : rowsData) {
			
			String region_id = row.get("region_id");
			double division = kpiEntity.getKpiMetaData().getDivision();
			String temp = "";
			if (!kpiEntityValueMap.containsKey(region_id)) {

				value = new KPIEntityValue();
				value.setRegionId(region_id);
				value.setRegionName(row.get("region_name"));
				value.setParentId(row.get("parent_id"));

				temp = row.get("targetvalue");
				if (temp == null || temp.length() == 0)
					temp = "0";
				value.setTargetValue(new Double(Double.valueOf(temp).doubleValue() / division));

				value.setCurrent(new KPIEntityValueCells(value));
				value.setPre(new KPIEntityValueCells(value));
				value.setBefore(new KPIEntityValueCells(value));
				value.setYear(new KPIEntityValueCells(value));

				result.add(value);
				kpiEntityValueMap.put(value.getRegionId(), value);

			} else {
				value = (KPIEntityValue) kpiEntityValueMap.get(region_id);
			}

			KPIEntityValueState state = new KPIEntityValueState();// 没有设置parentEntity，到后面再设置
			//  维度只有一个
			state.setBrand(row.get("brand_id"));

			temp = row.get("current");
			if (temp == null || temp.length() == 0)
				temp = "0";
			value.getCurrent().getCells().add(new KPIEntityValueCell(new Double(Double.valueOf(temp).doubleValue() / division), state));

			temp = row.get("pre");
			if (temp == null || temp.length() == 0)
				temp = "0";
			value.getPre().getCells().add(new KPIEntityValueCell(new Double(Double.valueOf(temp).doubleValue() / division), state));

			temp = row.get("before");
			if (temp == null || temp.length() == 0)
				temp = "0";
			value.getBefore().getCells().add(new KPIEntityValueCell(new Double(Double.valueOf(temp).doubleValue() / division), state));

			temp = row.get("year");
			if (temp == null || temp.length() == 0)
				temp = "0";
			value.getYear().getCells().add(new KPIEntityValueCell(new Double(Double.valueOf(temp).doubleValue() / division), state));

		}
		return result;
	}

	/**
	 * 为了子类继承使用
	 */
	protected String duringProcessSQL(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) {
		DBMapping mapping = dbMapping();
		String tableName = mapping.tableName;
		String regionId = mapping.regionId;
		String regionName = mapping.regionName;

		StringBuffer columns = new StringBuffer("time_id");

		String[] areas = regionIds.split(",");
		for (int i = 0; i < areas.length; i++) {
			columns.append(",max(case when ").append(regionId).append("=").append(areas[i]).append(" then ").append(regionName).append(" end),sum(case when ").append(regionId).append("=").append(areas[i]).append(" then  value  end)");
		}

		String sql = "select " + columns.toString() + " from " + tableName + " where time_id between '" + timeStart + "' and '" + timeEnd + "' and " + regionId + " in (" + regionIds + ") and zb_code ='" + kpiEntity.getId() + "' " + (state != null ? state.toPredication() : "") + " group by time_id order by 1,2 with ur";
		return sql;
	}

	/**
	 * 给Nocache用
	 * 
	 * @param list
	 * @param parentRegionId
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected KPIEntity noCachedprocess(List list, String parentRegionId) {
		KPIEntity newKPIEntity = null;
		if (list != null && list.size() > 0) {
			newKPIEntity = new KPIEntity();
			initialize(newKPIEntity, list);// 使用这个方法有问题,第一个value会作为root节点
		}
		if (newKPIEntity != null) {

			KPIEntity.Entity rootEntity = (KPIEntity.Entity) newKPIEntity.getRoot();

			KPIEntity.Entity[] newlist = rootEntity.getOrderChildren("current");

			Map cacheChildren = new HashMap();
			// 还要把rootEntity加进去
			cacheChildren.put(rootEntity.getKey(), rootEntity);
			// 写死了只取10个
			for (int i = 0; i < 10 && i < newlist.length; i++) {
				cacheChildren.put(newlist[i].getKey(), newlist[i]);
			}
			((KPIEntity.Entity) kpiEntity.getIndex().get(parentRegionId)).setChildren(cacheChildren);
		}
		return newKPIEntity;
	}

}
