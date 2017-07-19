package com.asiainfo.hbbass.component.dimension;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.json.JsonHelper;

/**
 * 
 * @author Mei Kefu
 * @date 2009-8-8
 */
public class BassDimCache {

	private static Logger LOG = Logger.getLogger(BassDimCache.class);

	private static BassDimCache BassDimensionCache = new BassDimCache();

	// private JSONWriter jsonWriter = new JSONWriter(false);

	private Cache cache = null;

	private BassDimCache() {
		try {
			CacheManager cacheManager = CacheManager.create(BassDimCache.class.getClassLoader().getResourceAsStream("hbbass_ehcache.xml"));
			cache = cacheManager.getCache("BASS_DIM");
			initialize();
		} catch (Exception e) {
			LOG.error("初始化CacheManger失败：" + e.getMessage(), e);
		}
	}

	public static BassDimCache getInstance() {
		return BassDimensionCache;
	}

	public boolean isKeyInCache(Object key) {
		return cache.isKeyInCache(key);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void initialize() {
		cache.removeAll();

		SQLQuery sqlQuery = null;

		try {
			LOG.info("领导KPI组权限缓存加载");
			sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list", "AiomniDB", false);
			String sql = "select distinct 'kpiportal',userid,'' from (" + " select userid from FPF_USER_GROUP_MAP a,FPF_GROUP_ROLE_MAP b,FPF_SYS_MENUITEM_RIGHT where a.group_id=b.group_id and RESOURCEID='966' and role_id=operatorid " + " union all "
					+ " select userid from  FPF_USER_ROLE_MAP,FPF_SYS_MENUITEM_RIGHT where RESOURCEID='966' and roleid=operatorid) t with ur";
			excuteList((List) sqlQuery.query(sql));
			LOG.info("领导KPI组权限缓存加载'成功'");
		} catch (Exception e) {
			LOG.error("BassDimCache.java:初始化KPI权限失败", e);
			e.printStackTrace();
		}

		try {
			sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list", "JDBC_HB", false);
			// 老的BassDimCache的集成
			Map datas = new HashMap();
			LOG.info("地市Combo加载");
			datas.put("countyCombo", sqlQuery.querys("select dm_city_id,dm_county_id,cityname from FPF_user_city where dm_county_id !='-1' order by 1,2 with ur"));
			datas.put("channeltypeCombo", sqlQuery.querys("select substr(key,1,1),key,value from  DIM_TOTAL where tagname='channeltype' order by 1,2 with ur"));
			LOG.info("地市Combo加载'成功'");

			try {
				Calendar c = GregorianCalendar.getInstance();
				c.add(Calendar.MONTH, -2);
				SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
				LOG.info("客户经理Combo加载");
				datas.put("custmanagerCombo", sqlQuery.querys("select distinct substr(own_org_id,1,8),staff_id,value(staff_name,staff_id) from nwh.ENT_INFO_" + sdf.format(c.getTime()) + " where staff_id is not null and own_org_id is not null and length(rtrim(substr(own_org_id,1,8)))=8 order by 1,2 with ur"));
				initCombo(datas);
				LOG.info("客户经理Combo加载'成功'");
			} catch (Exception e) {
				LOG.error("客户经理Combo加载'失败'");
			}
			// 老的BassDimCache的集成

			LOG.info("pt.dim_total加载");
			excuteList((List) sqlQuery.querys("select tagname,key,value from dim_total with ur"));
			LOG.info("pt.dim_total加载'成功'");

			excuteList((List) sqlQuery.querys("values ('area_id',0,'0')union all select 'area_id',area_id,area_code from mk.bt_area order by 2 with ur"));
			excuteList((List) sqlQuery.querys("values ('area_code','0','全省')union all select 'area_code',area_code,area_name from mk.bt_area order by 2 with ur"));
			LOG.info("县市Combo加载");
			excuteList((List) sqlQuery.querys("select area_code,county_code,county_name from mk.bt_area_all order by 1,2 with ur"));
			LOG.info("地市Combo加载'成功'");

		} catch (Exception e) {
			LOG.error("BassDimCache.java:初始化失败", e);
			e.printStackTrace();
		} finally {
			if (sqlQuery != null)
				sqlQuery.release();
		}
	}

	/**
	 * 初始化List到cache
	 * 
	 * @param list
	 */
	@SuppressWarnings({ "rawtypes", "deprecation", "unchecked" })
	protected void excuteList(List list) {

		Map map = null;
		for (int i = 0; i < list.size(); i++) {

			String[] data = (String[]) list.get(i);

			if (cache.isKeyInCache(data[0])) {
				map = (Map) cache.get(data[0]).getValue();
			} else {
				map = new TreeMap();
				map.put("", "全部");
				cache.put(new Element(data[0], map));
			}

			map.put(data[1], data[2]);
		}
		LOG.info("BassDimCache.init(list) 成功");
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String getArray(String key) {
		Map map = get(key);
		/*
		 * StringBuffer sb = new StringBuffer("["); for (Iterator iterator =
		 * map.entrySet().iterator(); iterator.hasNext();){ Map.Entry entry =
		 * (Map.Entry) iterator.next();
		 * sb.append("[").append("'").append(entry.getKey
		 * ()).append("'").append(",")
		 * .append("'").append(entry.getValue()).append("'").append("],"); }
		 * sb.delete(sb.length()-1, sb.length()); sb.append("]");
		 */// 20091228修改
		List list = new ArrayList();
		for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();
			Map newMap = new HashMap();
			newMap.put("key", entry.getKey());
			newMap.put("value", entry.getValue());
			list.add(newMap);
		}

		return JsonHelper.getInstance().write(list);
	}

	/**
	 * 
	 * @param key
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "deprecation" })
	public Map get(String key) {

		Element element = cache.get(key);

		if (element != null)
			return (Map) element.getValue();

		return null;
	}

	/**
	 * 集成老的BassDimCache的联动缓存
	 * 
	 * @param data
	 * 
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void initCombo(Map data) {

		for (Iterator iterator = data.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();

			Map map = new HashMap();
			cache.put(new Element(entry.getKey(), map));

			List list = (List) entry.getValue();
			for (int i = 0; i < list.size(); i++) {
				String[] arr = (String[]) list.get(i);
				Map innermap = null;
				if (map.containsKey(arr[0])) {
					innermap = (Map) map.get(arr[0]);
				} else {
					innermap = new HashMap();
					map.put(arr[0], innermap);
				}
				innermap.put(arr[1], arr[2]);
			}
		}
		LOG.info("BassDimCache.initCombo(map) 成功");
	}

	/**
	 * 继承老的BassDimCahce的方法，以后应该要去掉这个方法
	 * 
	 * @param tagname
	 * @param name
	 * @return
	 * 
	 */
	@SuppressWarnings("rawtypes")
	public String getCustomFormatResult(String tagname, String name) {
		Map tagCache = get(tagname);
		if (tagCache != null) {
			Map map = (Map) tagCache.get(name);
			StringBuffer sb = new StringBuffer();
			for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();
				sb.append(entry.getKey()).append("@,").append(entry.getValue()).append("@|");
			}
			sb.delete(sb.length() - 2, sb.length());
			return sb.toString();
		} else {
			return "";
		}
	}

}
