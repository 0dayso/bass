package com.asiainfo.hbbass.kpiportal.load;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityLoad;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueState;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalException;

/**
 * 开门红的净增用户数计算,暂时支持日
 * 
 * @author Mei Kefu
 * @date 2009-12-26
 */
public class SFMNetIncrease extends DefaultLoad implements KPIEntityLoad {

	private static Logger LOG = Logger.getLogger(SFMNetIncrease.class);
	private static final long serialVersionUID = -2884433593943804747L;
	private String loadIndicator = ",value(sum(case when time_id =? then value end)-sum(case when time_id =? then value end),0) as current" + ",value(sum(case when time_id =? then value end)-sum(case when time_id =? then value end),0) as pre"
			+ ",value(sum(case when time_id =? then value end)-sum(case when time_id =? then value end),0) as before" + ",value(sum(case when time_id =? then value end)-sum(case when time_id =? then value end),0) as year";

	private String consDate = "20091130";

	@Override
	public KPIEntity load(KpiDataStore dataStore) throws KPIPortalException {
		return load();
	}
	/**
	 * 
	 * select channel_code, max(channel_name) region_name,parent_channel_code,''
	 * ,sum(case when time_id ='20091222' then value end)-sum(case when time_id
	 * ='20091122' then value end) as current ,value(sum(case when time_id
	 * ='20091221' then value end)-sum(case when time_id ='20091121' then value
	 * end),0) as pre ,value(sum(case when time_id ='20091122' then value
	 * end)-sum(case when time_id ='20091022' then value end),0) as before
	 * ,value(sum(case when time_id ='20081222' then value end)-sum(case when
	 * time_id ='20081122' then value end),0) as year from kpi_total_daily
	 * where TIME_ID in (
	 * '20091222','20091122','20091221','20091121','20091022','20081222','20081122')
	 * and zb_code='K10005' and channel_code='HB' group by
	 * channel_code,parent_channel_code
	 */
	@SuppressWarnings("rawtypes")
	public KPIEntity load() throws KPIPortalException {

		String sql = "";
		String appName = kpiEntity.getKpiAppData().getName();

		if ("ChannelD".equalsIgnoreCase(appName)) {
			DBMapping mapping = dbMapping();
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=channel_code),0) targetvalue" + loadIndicator + " from " + mapping.tableName
					+ " where time_id in (?,?,?,?,?,?,?) and zb_code = ? and length(channel_code)<=8 and channel_code like 'HB%' group by channel_code,parent_channel_code order by channel_code with ur";
		} else if ("BureauD".equalsIgnoreCase(appName)) {
			DBMapping mapping = dbMapping();
			sql = "select region_id, max(region_name) region_name,parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=region_id),0) targetvalue" + loadIndicator + " from " + mapping.tableName
					+ " where time_id in (?,?,?,?,?,?,?) and zb_code = ? and level<=3 group by region_id,parent_id,level order by level,region_id with ur";
		}
		String originIds = kpiEntity.getKpiMetaData().getOriginIds();

		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		List list = null;
		try {
			String zbCode = kpiEntity.getId();
			String current = dateFilter(kpiEntity.getDate());
			String[] dates = KPIPortalContext.calDate(current);
			String pre = dates[0];
			String before = dates[1];
			String year = dates[2];
			/*
			 * String curBefore=before; String
			 * preBefore=KPIPortalContext.calDate(pre)[1]; String
			 * befBefore=KPIPortalContext.calDate(before)[1]; String
			 * yearBefore=KPIPortalContext.calDate(year)[1];
			 */
			LOG.debug("SQL:" + sql);
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, zbCode);
			ps.setString(2, dateFilter(current));
			ps.setString(3, consDate);
			ps.setString(4, dateFilter(pre));
			ps.setString(5, consDate);
			ps.setString(6, dateFilter(before));
			ps.setString(7, consDate);
			ps.setString(8, dateFilter(year));
			ps.setString(9, consDate);
			ps.setString(10, dateFilter(current));
			ps.setString(11, consDate);
			ps.setString(12, dateFilter(pre));
			ps.setString(13, consDate);
			ps.setString(14, dateFilter(before));
			ps.setString(15, dateFilter(year));
			ps.setString(16, consDate);
			ps.setString(17, originIds);

			list = mapping(resultsetMappList(ps.executeQuery()));

			ps.close();
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
		process(list);

		return kpiEntity;
	}

	/**
	 * 开门红的时间，小于20091201的就返回0
	 */
	protected String dateFilter(String date) {
		String result = "0";
		if (Integer.parseInt(date) >= 20091201) {
			result = date;
		} else if (Integer.parseInt(date) > 20100228) {
			date = "20100228";
		}
		return result;
	}

	@SuppressWarnings("rawtypes")
	public KPIEntity loadNoCached(String parentRegionId) throws KPIPortalException {

		String sql = "";
		String appName = kpiEntity.getKpiAppData().getName();

		if ("ChannelD".equalsIgnoreCase(appName)) {
			DBMapping mapping = dbMapping();
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=channel_code),0) targetvalue" + loadIndicator + " from " + mapping.tableName
					+ " where time_id in (?,?,?,?,?,?,?) and zb_code = ? and parent_channel_code=? group by channel_code,parent_channel_code order by current desc with ur";
		} else if ("BureauD".equalsIgnoreCase(appName)) {
			DBMapping mapping = dbMapping();
			sql = "select region_id, max(region_name) region_name,parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=region_id),0) targetvalue" + loadIndicator + " from " + mapping.tableName
					+ " where time_id in (?,?,?,?,?,?,?) and zb_code = ? and parent_id=? group by region_id,parent_id,level order by level,current desc with ur";
		}
		String originIds = kpiEntity.getKpiMetaData().getOriginIds();

		Connection conn = ConnectionManage.getInstance().getDWConnection();
		List list = null;
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			String zbCode = kpiEntity.getId();
			String current = dateFilter(kpiEntity.getDate());
			String[] dates = KPIPortalContext.calDate(current);
			String pre = dates[0];
			String before = dates[1];
			String year = dates[2];

			/*
			 * String curBefore=before; String
			 * preBefore=KPIPortalContext.calDate(pre)[1]; String
			 * befBefore=KPIPortalContext.calDate(before)[1]; String
			 * yearBefore=KPIPortalContext.calDate(year)[1];
			 */

			ps.setString(1, zbCode);
			ps.setString(2, dateFilter(current));
			ps.setString(3, consDate);
			ps.setString(4, dateFilter(pre));
			ps.setString(5, consDate);
			ps.setString(6, dateFilter(before));
			ps.setString(7, consDate);
			ps.setString(8, dateFilter(year));
			ps.setString(9, consDate);
			ps.setString(10, dateFilter(current));
			ps.setString(11, consDate);
			ps.setString(12, dateFilter(pre));
			ps.setString(13, consDate);
			ps.setString(14, dateFilter(before));
			ps.setString(15, dateFilter(year));
			ps.setString(16, consDate);
			ps.setString(17, originIds);
			ps.setString(18, parentRegionId);

			list = mapping(resultsetMappList(ps.executeQuery()));

			ps.close();
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

		return noCachedprocess(list, parentRegionId);
	}

	@Override
	protected String keySQL(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) {
		DBMapping mapping = dbMapping();
		String tableName = mapping.tableName;
		String regionId = mapping.regionId;
		String regionName = mapping.regionName;

		StringBuffer pieceT1 = new StringBuffer("select time_id");
		StringBuffer pieceT2 = new StringBuffer();

		String[] areas = regionIds.split(",");
		for (int i = 0; i < areas.length; i++) {
			String aliasArea = areas[i].replaceAll("'HB.", "").replaceAll("'", "").replaceAll("\\.", "");
			pieceT1.append(",max(case when " + regionId + "=").append(areas[i]).append(" then " + regionName + " end)").append(" as n_").append(aliasArea).append(",sum(case when " + regionId + "=").append(areas[i]).append(" then value end)").append(" as v_").append(aliasArea);
		}
		String tableStr = " from  " + tableName + " where time_id between ";
		pieceT1.append(tableStr);
		pieceT2.append(pieceT1);
		pieceT1.append("'").append(dateFilter(timeStart)).append("'").append(" and ").append("'").append(dateFilter(timeEnd)).append("'");

		pieceT2.append("'").append(consDate).append("'").append(" and ").append("'").append(consDate).append("'");

		String tailStr = " and " + regionId + " in (" + regionIds + ") and zb_code ='" + kpiEntity.getKpiMetaData().getOriginIds() + "' " + state.toPredication() + " group by time_id order by 1";

		pieceT1.append(tailStr);
		pieceT2.append(tailStr);

		return pieceT1.toString() + " " + pieceT2.toString();
	}

	/**
	 * 由于是日数据，如果用sql很可能日期对应错误，所以使用2次查询，在程序里面来处理 select time_id ,max(case when
	 * region_id='HB.ES' then region_name end) as n_es,sum(case when
	 * region_id='HB.ES' then value end) v_es ,max(case when region_id='HB.EZ'
	 * then region_name end) as n_ez,sum(case when region_id='HB.EZ' then value
	 * end) v_ez from kpi_bureau_total_daily where TIME_ID between '20091129'
	 * and '20091201' and zb_code='K10005' and region_id in ('HB.ES','HB.EZ')
	 * group by time_id order by 1
	 * 
	 * 返回的Map(time_id,Map1) Map1(regionName,Double_Value)
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	protected Map loadDuringData(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) throws KPIPortalException {

		DBMapping mapping = dbMapping();
		String tableName = mapping.tableName;
		String regionId = mapping.regionId;
		String regionName = mapping.regionName;

		StringBuffer pieceT1 = new StringBuffer("select time_id");
		StringBuffer pieceT2 = new StringBuffer();

		String[] areas = regionIds.split(",");
		for (int i = 0; i < areas.length; i++) {
			String aliasArea = areas[i].replaceAll("'HB.", "").replaceAll("'", "").replaceAll("\\.", "");
			pieceT1.append(",max(case when " + regionId + "=").append(areas[i]).append(" then " + regionName + " end)").append(" as n_").append(aliasArea).append(",sum(case when " + regionId + "=").append(areas[i]).append(" then value end)").append(" as v_").append(aliasArea);
		}
		String tableStr = " from  " + tableName + " where time_id between ";
		pieceT1.append(tableStr);
		pieceT2.append(pieceT1);
		pieceT1.append("'").append(dateFilter(timeStart)).append("'").append(" and ").append("'").append(dateFilter(timeEnd)).append("'");

		pieceT2.append("'").append(consDate).append("'").append(" and ").append("'").append(consDate).append("'");

		String tailStr = " and " + regionId + " in (" + regionIds + ") and zb_code ='" + kpiEntity.getKpiMetaData().getOriginIds() + "' " + state.toPredication() + " group by time_id order by 1";

		pieceT1.append(tailStr);
		pieceT2.append(tailStr);

		LOG.info("加载时间段,用于比较分析SQL:" + pieceT1 + ", SQL2:" + pieceT2);
		Map map = new TreeMap();
		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			// 先运行sql2，把数据存在一个map中结构是{date||region,value}，后面在来取数据计算
			Statement stat = conn.createStatement();
			ResultSet rs1 = stat.executeQuery(pieceT2.toString());
			Map pieceMap2 = new HashMap();

			while (rs1.next()) {
				String date = rs1.getString(1);
				for (int i = 0; i < areas.length; i++) {
					String key = rs1.getString(i * 2 + 2);
					String value = rs1.getString(i * 2 + 3);
					pieceMap2.put(date + key, value);
				}
			}
			rs1.close();

			ResultSet rs = stat.executeQuery(pieceT1.toString());
			while (rs.next()) {
				Map innerMap = new TreeMap();
				String date = rs.getString(1);
				for (int i = 0; i < areas.length; i++) {
					String key = rs.getString(i * 2 + 2);
					String value = rs.getString(i * 2 + 3);

					String value2 = (String) pieceMap2.get(consDate + key);// 取需要计算的SQL2的值

					// 计算数值
					innerMap.put(key, duringGetValue((Double.valueOf(value).doubleValue() - Double.valueOf(value2).doubleValue()), state));
				}
				map.put(date, innerMap);
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

}
