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
 * 开门红的累计收入，用户数
 * 
 * @author Mei Kefu
 * @date 2009-12-26
 */
public class SFMAccumulate extends DefaultLoad implements KPIEntityLoad {

	private static Logger LOG = Logger.getLogger(SFMAccumulate.class);
	private static final long serialVersionUID = 1764797114044123660L;
	private String consDate1 = "20091231";

	private String consDate2 = "20100131";

	private String loadIndicator = ",value(sum(case when time_id in (?,'" + consDate1 + "','" + consDate2 + "') then value end),0) as current" + ",value(sum(case when time_id in (?,'" + consDate1 + "','" + consDate2 + "') then value end),0) as pre" + ",value(sum(case when time_id in (?,'" + consDate1 + "','"
			+ consDate2 + "') then value end),0) as before" + ",value(sum(case when time_id in (@yearPiece) then value end),0) as year";

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
					+ " where time_id in (?,?,?,?,?,@yearPiece) and zb_code = ? and length(channel_code)<=8 and channel_code like 'HB%' group by channel_code,parent_channel_code order by channel_code with ur";
		} else if ("BureauD".equalsIgnoreCase(appName)) {
			DBMapping mapping = dbMapping();
			sql = "select region_id, max(region_name) region_name,parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=region_id),0) targetvalue" + loadIndicator + " from " + mapping.tableName
					+ " where time_id in (?,?,?,?,?,@yearPiece) and zb_code = ? and level<=3 group by region_id,parent_id,level order by level,region_id with ur";
		}
		String originIds = kpiEntity.getKpiMetaData().getOriginIds();

		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		List list = null;
		try {
			String zbCode = kpiEntity.getId();
			String current = dateFilter(kpiEntity.getDate());
			String[] dates = KPIPortalContext.calDate(current);
			String pre = dateFilter(dates[0]);
			String before = dateFilter(dates[1]);

			String year = dates[2];

			StringBuilder sb = new StringBuilder();
			sb.append("'").append(year).append("'");
			if (Integer.parseInt(year) > 20081231) {
				sb.append(",'20081231'");
			}

			if (Integer.parseInt(year) > 20090131) {
				sb.append(",'20090131'");
			}
			sql = sql.replaceAll("@yearPiece", sb.toString());

			LOG.debug("SQL:" + sql);
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, zbCode);
			ps.setString(2, current);
			ps.setString(3, pre);
			ps.setString(4, before);
			ps.setString(5, current);
			ps.setString(6, pre);
			ps.setString(7, before);
			ps.setString(8, consDate1);
			ps.setString(9, consDate2);
			ps.setString(10, originIds);

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

	@SuppressWarnings("rawtypes")
	public KPIEntity loadNoCached(String parentRegionId) throws KPIPortalException {

		String sql = "";
		String appName = kpiEntity.getKpiAppData().getName();

		if ("ChannelD".equalsIgnoreCase(appName)) {
			DBMapping mapping = dbMapping();
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=channel_code),0) targetvalue" + loadIndicator + " from " + mapping.tableName
					+ " where time_id in (?,?,?,?,?@yearPiece) and zb_code = ? and parent_channel_code=? group by channel_code,parent_channel_code order by current desc with ur";
		} else if ("BureauD".equalsIgnoreCase(appName)) {
			DBMapping mapping = dbMapping();
			sql = "select region_id, max(region_name) region_name,parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=region_id),0) targetvalue" + loadIndicator + " from " + mapping.tableName
					+ " where time_id in (?,?,?,?,?@yearPiece) and zb_code = ? and parent_id=? group by region_id,parent_id,level order by level,current desc with ur";
		}
		String originIds = kpiEntity.getKpiMetaData().getOriginIds();

		Connection conn = ConnectionManage.getInstance().getDWConnection();
		List list = null;
		try {

			String zbCode = kpiEntity.getId();
			String current = dateFilter(kpiEntity.getDate());
			String[] dates = KPIPortalContext.calDate(current);
			String pre = dateFilter(dates[0]);
			String before = dateFilter(dates[1]);

			String year = dates[2];

			StringBuilder sb = new StringBuilder();
			sb.append("'").append(year).append("'");
			if (Integer.parseInt(year) > 20081231) {
				sb.append(",'20081231'");
			}

			if (Integer.parseInt(year) > 20090131) {
				sb.append(",'20090131'");
			}
			sql = sql.replaceAll("@yearPiece", sb.toString());

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, zbCode);
			ps.setString(2, current);
			ps.setString(3, pre);
			ps.setString(4, before);
			ps.setString(5, current);
			ps.setString(6, pre);
			ps.setString(7, before);
			ps.setString(8, consDate1);
			ps.setString(9, consDate2);
			ps.setString(10, originIds);
			ps.setString(11, parentRegionId);

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

	@Override
	protected String keySQL(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) {
		String sql = duringProcessSQL(regionIds, state, dateFilter(timeStart), dateFilter(timeEnd)).replaceAll(kpiEntity.getId(), kpiEntity.getKpiMetaData().getOriginIds());
		LOG.info("加载时间段,用于比较分析SQL:" + sql);

		DBMapping mapping = dbMapping();
		String tableName = mapping.tableName;
		String regionId = mapping.regionId;
		String sql2 = "select " + regionId + ",value(sum(value),0) from " + tableName + " where time_id in ('" + consDate1 + "','" + consDate2 + "') and " + regionId + " in (" + regionIds + ") and zb_code ='" + kpiEntity.getKpiMetaData().getOriginIds() + "' group by " + regionId + " with ur";

		return sql + " " + sql2;
	}

	/**
	 * 取出 20091231和20100131的数据 返回的Map(time_id,Map1)
	 * Map1(regionName,Double_Value)
	 */
	@Override
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected Map loadDuringData(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) throws KPIPortalException {

		String sql = duringProcessSQL(regionIds, state, dateFilter(timeStart), dateFilter(timeEnd)).replaceAll(kpiEntity.getId(), kpiEntity.getKpiMetaData().getOriginIds());
		LOG.info("加载时间段,用于比较分析SQL:" + sql);
		String[] areas = regionIds.split(",");

		DBMapping mapping = dbMapping();
		String tableName = mapping.tableName;
		String regionId = mapping.regionId;
		String sql2 = "select " + regionId + ",value(sum(value),0) from " + tableName + " where time_id in ('" + consDate1 + "','" + consDate2 + "') and " + regionId + " in (" + regionIds + ") and zb_code ='" + kpiEntity.getKpiMetaData().getOriginIds() + "' group by " + regionId + " with ur";

		Map map = new TreeMap();
		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			// 先运行sql2，把数据存在一个map中结构是{region,value}，后面在来取数据计算
			Statement stat = conn.createStatement();
			ResultSet rs1 = stat.executeQuery(sql2);
			Map conts = new HashMap();

			while (rs1.next()) {
				String key = rs1.getString(1);
				Double value = Double.valueOf(rs1.getDouble(2));
				conts.put(key, value);
			}
			rs1.close();

			ResultSet rs = stat.executeQuery(sql);
			while (rs.next()) {
				Map innerMap = new TreeMap();
				for (int i = 0; i < areas.length; i++) {
					String key = rs.getString(i * 2 + 2);
					String value = rs.getString(i * 2 + 3);

					Double value2 = (Double) conts.get(key);// 取需要计算的SQL2的值

					double dValue2 = 0;

					if (value2 != null) {
						dValue2 = value2.doubleValue();
					}

					// 计算值
					innerMap.put(key, duringGetValue((Double.valueOf(value).doubleValue() + dValue2), state));
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

}
