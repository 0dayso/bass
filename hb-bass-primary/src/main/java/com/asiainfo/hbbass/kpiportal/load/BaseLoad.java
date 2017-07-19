package com.asiainfo.hbbass.kpiportal.load;

import java.sql.Connection;
import java.util.Map;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.cache.CacheServerFactory;
import com.asiainfo.hbbass.component.util.Util;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityLoad;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValue;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueCell;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueCells;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueState;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalException;

/**
 * 把DefaultLoad中的一些方法提取出来，给PercentLoad用
 * 
 * @author Mei Kefu
 * @date 2009-12-29
 * 
 * @date 2010-8-2 增加集团网格的层次维度，目前还只有武汉的，所有只是临时使用，以后会扩展到全省使用这个集团层次维度
 * 
 * @date 2010-12-31 增加load时的SQL缓存支持
 */
@SuppressWarnings({ "unused", "serial" })
public abstract class BaseLoad implements KPIEntityLoad {

	protected KPIEntity kpiEntity;

	protected void putObjectToCache(String sql, Object obj) {
		CacheServerFactory.getInstance().getCache("SQL").put(Util.md5(sql), obj);
	}

	protected Object getObjectFromCache(String key) {
		return CacheServerFactory.getInstance().getCache("SQL").get(Util.md5(key));
	}

	public void setKpiEntity(KPIEntity kpiEntity) {
		this.kpiEntity = kpiEntity;
	}

	protected Connection getConnection() {
		// return ConnectionManage.getInstance().getDWConnection();
		return ConnectionManage.getInstance().getWEBConnection();
	}

	protected void releaseConnection(Connection conn) {
		ConnectionManage.getInstance().releaseConnection(conn);
	}

	protected boolean isAggre() {
		return kpiEntity != null && kpiEntity.getDate().split("-").length == 2;
	}

	/**
	 * loadDuring的每个值的赋值，为了加入KPIEntityValueFiter的使用
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	protected KPIEntityValue duringGetValue(Double num, KPIEntityValueState state) {
		KPIEntityValue value = new KPIEntityValue();
		value.setFilter(kpiEntity.getValueFilter());
		value.setCurrent(new KPIEntityValueCells(value));
		value.getCurrent().getCells().add(new KPIEntityValueCell(num.doubleValue() / kpiEntity.getKpiMetaData().getDivision(), state));
		return value;
	}

	@SuppressWarnings("unchecked")
	protected KPIEntityValue duringGetValue(Double num, Double den, KPIEntityValueState state) {

		if (den == null) {
			return duringGetValue(num, state);
		} else {
			KPIEntityValue value = new KPIEntityValue();
			value.setFilter(kpiEntity.getValueFilter());
			value.setCurrent(new KPIEntityValueCells(value));
			value.getCurrent().getCells().add(new KPIEntityValueCell(num.doubleValue() / kpiEntity.getKpiMetaData().getDivision(), den.doubleValue(), state));
			return value;
		}
	}

	protected static class DBMapping {
		String tableName = "";
		String regionId = "region_id";
		String regionName = "region_name";
		String parentId = "parent_id";

		String brandCol = "''";
		String brandCondi = "";

		String cacheLevel = "3";
	}

	protected DBMapping dbMapping() {

		DBMapping mapping = new DBMapping();

		String appName = kpiEntity.getKpiAppData().getName();
		if ("ChannelD".equalsIgnoreCase(appName)) {
			mapping.tableName = "kpi_total_daily";
			mapping.regionId = "channel_code";
			mapping.regionName = "channel_name";
			mapping.parentId = "parent_channel_code";
		} else if ("ChannelM".equalsIgnoreCase(appName)) {
			mapping.tableName = "kpi_total_monthly";
			mapping.regionId = "channel_code";
			mapping.regionName = "channel_name";
			mapping.parentId = "parent_channel_code";
		} else if ("BureauD".equalsIgnoreCase(appName)) {
			mapping.tableName = "kpi_bureau_town_daily";
		} else if ("BureauM".equalsIgnoreCase(appName)) {
			mapping.tableName = "kpi_bureau_town_monthly";
		} else if ("GroupcustD".equalsIgnoreCase(appName)) {
			mapping.tableName = "kpi_ent_daily";
			mapping.regionId = "channel_code";
			mapping.regionName = "channel_name";
			mapping.parentId = "parent_channel_code";
		} else if ("GroupcustM".equalsIgnoreCase(appName)) {
			mapping.tableName = "kpi_ent_monthly";
			mapping.regionId = "channel_code";
			mapping.regionName = "channel_name";
			mapping.parentId = "parent_channel_code";
		} else if ("CollegeD".equalsIgnoreCase(appName)) {
			mapping.tableName = "kpi_college_daily";
			mapping.brandCol = " t1.brand_id ";
			mapping.brandCondi = " and t1.brand_id=t2.brand_id";
		} else if ("CollegeM".equalsIgnoreCase(appName)) {
			mapping.tableName = "kpi_college_monthly";
			mapping.brandCol = " t1.brand_id ";
			mapping.brandCondi = " and t1.brand_id=t2.brand_id";
		} else if ("EntGridD".equalsIgnoreCase(appName)) {
			mapping.tableName = "NMK.GRID_KPI_DAYLY";
			mapping.regionId = "grid_id";
			mapping.regionName = "grid_name";
			mapping.cacheLevel = "5";
		} else if ("CsD".equalsIgnoreCase(appName)) {
			mapping.tableName = "kpi_cs_daily";
			mapping.regionId = "channel_code";
			mapping.regionName = "channel_name";
			mapping.parentId = "parent_channel_code";
			mapping.brandCol = " t1.brand_id ";
			mapping.brandCondi = " and t1.brand_id=t2.brand_id";
		} else if ("CsM".equalsIgnoreCase(appName)) {
			mapping.tableName = "kpi_cs_monthly";
			mapping.regionId = "channel_code";
			mapping.regionName = "channel_name";
			mapping.parentId = "parent_channel_code";
			mapping.brandCol = " t1.brand_id ";
			mapping.brandCondi = " and t1.brand_id=t2.brand_id";
		}

		return mapping;
	}

	@SuppressWarnings("rawtypes")
	public void setKpiEntityMap(Map map) {
	}
}
