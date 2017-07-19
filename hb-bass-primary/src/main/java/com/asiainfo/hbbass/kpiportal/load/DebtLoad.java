package com.asiainfo.hbbass.kpiportal.load;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
 * 月欠费率计算
 * 
 * 继承了DefaultLoad,所以是按照SQL来计算的
 * 
 * @author Mei Kefu
 * 
 */
public class DebtLoad extends DefaultLoad implements KPIEntityLoad {

	private static Logger LOG = Logger.getLogger(DebtLoad.class);
	private static final long serialVersionUID = 752950786623550933L;
	private String loadIndicator = ",value(1-case when sum(case when time_id =? and zb_code=? then value end)=0 then 1 else double(sum(case when time_id =? and zb_code=? then value end))/sum(case when time_id =? and zb_code=? then value end) end,0) as current"
			+ ",value(1-case when sum(case when time_id =? and zb_code=? then value end)=0 then 1 else double(sum(case when time_id =? and zb_code=? then value end))/sum(case when time_id =? and zb_code=? then value end) end,0) as pre"
			+ ",value(1-case when sum(case when time_id =? and zb_code=? then value end)=0 then 1 else double(sum(case when time_id =? and zb_code=? then value end))/sum(case when time_id =? and zb_code=? then value end) end,0) as before" + ", 0 as year";

	@Override
	public KPIEntity load(KpiDataStore dataStore) throws KPIPortalException {
		return load();
	}
	/**
	 * 
	 * select region_id, max(region_name) region_name,parent_id,'' ,case when
	 * sum(case when time_id ='200904' and zb_code='BM0001' then value end) = 0
	 * then 0 else value(double(sum(case when time_id ='200905' and
	 * zb_code='BM0005' then value end))/sum(case when time_id ='200904' and
	 * zb_code='BM0001' then value end),0) - (-2) end as current ,int('0')*1 as
	 * year from kpi_bureau_total_monthly where TIME_ID in
	 * ('200905','200904','200903','200805','200804') and zb_code in
	 * ('BM0005','BM0001') and "LEVEL"=0 group by REGION_ID,parent_id
	 */
	@SuppressWarnings("rawtypes")
	public KPIEntity load() throws KPIPortalException {

		String sql = "";
		String appName = kpiEntity.getKpiAppData().getName();
		DBMapping dbMapping = dbMapping();
		if ("ChannelM".equalsIgnoreCase(appName))
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=channel_code),0) targetvalue" + loadIndicator + " from " + dbMapping.tableName
					+ " where time_id in (?,?,?,?,?) and zb_code in (?,?) and length(channel_code)<=8 and channel_code like 'HB%' group by channel_code,parent_channel_code order by channel_code with ur";
		else if ("BureauM".equalsIgnoreCase(appName))
			sql = "select region_id, max(region_name) region_name,parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=region_id),0) targetvalue" + loadIndicator + " from " + dbMapping.tableName
					+ " where time_id in (?,?,?,?,?) and zb_code in (?,?) and level<=3 group by region_id,parent_id,level order by level,region_id with ur";

		String[] originIds = kpiEntity.getKpiMetaData().getOriginIds().split(",");

		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		List list = null;
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			String[] dates = KPIPortalContext.calDate(kpiEntity.getDate());
			String zbCode = kpiEntity.getId();
			String current = kpiEntity.getDate();
			String pre = dates[0];
			String before = dates[1];

			String[] dates1 = KPIPortalContext.calDate(pre);
			String current1 = pre;
			String pre1 = dates1[0];
			String before1 = dates1[1];

			ps.setString(1, zbCode);
			ps.setString(2, current1);
			ps.setString(3, originIds[1]);
			ps.setString(4, current);
			ps.setString(5, originIds[0]);
			ps.setString(6, current1);
			ps.setString(7, originIds[1]);
			ps.setString(8, pre1);
			ps.setString(9, originIds[1]);
			ps.setString(10, pre);
			ps.setString(11, originIds[0]);
			ps.setString(12, pre1);
			ps.setString(13, originIds[1]);
			ps.setString(14, before1);
			ps.setString(15, originIds[1]);
			ps.setString(16, before);
			ps.setString(17, originIds[0]);
			ps.setString(18, before1);
			ps.setString(19, originIds[1]);
			ps.setString(20, current);
			ps.setString(21, pre);
			ps.setString(22, pre1);
			ps.setString(23, before);
			ps.setString(24, before1);
			ps.setString(25, originIds[0]);
			ps.setString(26, originIds[1]);

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
		DBMapping dbMapping = dbMapping();
		if ("ChannelM".equalsIgnoreCase(appName))
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,0 brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=channel_code),0) targetvalue" + loadIndicator + " from " + dbMapping.tableName
					+ " where time_id in (?,?,?,?,?) and zb_code in (?,?) and parent_channel_code=? group by channel_code,parent_channel_code order by current desc with ur";
		else if ("BureauM".equalsIgnoreCase(appName))
			sql = "select region_id, max(region_name) region_name,parent_id,0 brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=region_id),0) targetvalue" + loadIndicator + " from " + dbMapping.tableName
					+ " where time_id in (?,?,?,?,?) and zb_code in (?,?) and parent_id=? group by region_id,parent_id,level order by level,current desc with ur";

		String[] originIds = kpiEntity.getKpiMetaData().getOriginIds().split(",");

		Connection conn = ConnectionManage.getInstance().getDWConnection();
		List list = null;
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			String[] dates = KPIPortalContext.calDate(kpiEntity.getDate());
			String zbCode = kpiEntity.getId();
			String current = kpiEntity.getDate();
			String pre = dates[0];
			String before = dates[1];

			String[] dates1 = KPIPortalContext.calDate(pre);
			String current1 = pre;
			String pre1 = dates1[0];
			String before1 = dates1[1];

			ps.setString(1, zbCode);
			ps.setString(2, current1);
			ps.setString(3, originIds[1]);
			ps.setString(4, current);
			ps.setString(5, originIds[0]);
			ps.setString(6, current1);
			ps.setString(7, originIds[1]);
			ps.setString(8, pre1);
			ps.setString(9, originIds[1]);
			ps.setString(10, pre);
			ps.setString(11, originIds[0]);
			ps.setString(12, pre1);
			ps.setString(13, originIds[1]);
			ps.setString(14, before1);
			ps.setString(15, originIds[1]);
			ps.setString(16, before);
			ps.setString(17, originIds[0]);
			ps.setString(18, before1);
			ps.setString(19, originIds[1]);
			ps.setString(20, current);
			ps.setString(21, pre);
			ps.setString(22, pre1);
			ps.setString(23, before);
			ps.setString(24, before1);
			ps.setString(25, originIds[0]);
			ps.setString(26, originIds[1]);
			ps.setString(27, parentRegionId);

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

		StringBuffer sql = new StringBuffer("select t1.time_id");

		StringBuffer pirectT1 = new StringBuffer("select time_id");
		StringBuffer pirectT2 = new StringBuffer("select replace(substr(char(date(char(insert(time_id,5,0,'-')||'-01'))+1 month),1,7),'-','') time_id");
		String[] originIds = kpiEntity.getKpiMetaData().getOriginIds().split(",");
		String[] areas = regionIds.split(",");
		for (int i = 0; i < areas.length; i++) {
			String aliasArea = areas[i].replaceAll("'HB.", "").replaceAll("'", "").replaceAll("\\.", "");
			pirectT1.append(",max(case when " + regionId + "=").append(areas[i]).append(" then " + regionName + " end)").append(" as n_").append(aliasArea).append(",sum(case when " + regionId + "=").append(areas[i]).append(" then value end)").append(" as v_").append(aliasArea);

			pirectT2.append(",sum(case when " + regionId + "=").append(areas[i]).append(" then value end)").append(" as v1_").append(aliasArea);

			sql.append(",n_").append(aliasArea).append(",value(1-case when v1_").append(aliasArea).append("=0 then 1 else double(v_").append(aliasArea).append(")/v1_").append(aliasArea).append(" end,0)");
		}
		String tableStr = " from " + tableName + " where time_id between ";
		pirectT1.append(tableStr);
		pirectT2.append(tableStr);

		pirectT1.append("'").append(timeStart).append("'").append(" and ").append("'").append(timeEnd).append("'");
		pirectT2.append("replace(substr(char(date(char(insert('").append(timeStart).append("',5,0,'-')||'-01'))-1 month),1,7),'-','')").append(" and ").append("replace(substr(char(date(char(insert('").append(timeEnd).append("',5,0,'-')||'-01'))-1 month),1,7),'-','')");

		String tailStr = " and " + regionId + " in (" + regionIds + ") and zb_code ='@zbCodes' " + state.toPredication() + " group by time_id order by 1";

		pirectT1.append(tailStr.replaceAll("@zbCodes", originIds[0]));
		pirectT2.append(tailStr.replaceAll("@zbCodes", originIds[1]));

		sql.append(" from (").append(pirectT1).append(" ) t1 left join (").append(pirectT2).append(" ) t2 on t1.time_id=t2.time_id order by 1 with ur");

		return sql.toString();
	}

	/**
	 * select t1.time_id ,n_es,value(case when v_es1=0 then 1 else
	 * double(v_es)/v_es1 end -1,0) ,n_ez,value(double(v_ez)/v_ez1-1,0) from (
	 * select time_id ,max(case when region_id='HB.ES' then region_name end) as
	 * n_es,sum(case when region_id='HB.ES' then value end) v_es ,max(case when
	 * region_id='HB.EZ' then region_name end) as n_ez,sum(case when
	 * region_id='HB.EZ' then value end) v_ez from kpi_bureau_total_monthly
	 * where TIME_ID in ('200905','200904','200805') and zb_code='BM0001' and
	 * region_id in ('HB.ES','HB.EZ') group by time_id order by 1) t1 left join
	 * ( select replace(substr(char(date(char(insert(time_id,5,0,'-')||'-01'))+1
	 * month),1,7),'-','') time_id ,sum(case when region_id='HB.ES' then value
	 * end) v_es1 ,sum(case when region_id='HB.EZ' then value end) v_ez1 from
	 * kpi_bureau_total_monthly where TIME_ID in ('200904','200903','200804')
	 * and zb_code='BM0001' and region_id in ('HB.ES','HB.EZ') group by time_id
	 * order by 1) t2 on t1.time_id=t2.time_id order by 1
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	protected Map loadDuringData(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) throws KPIPortalException {

		DBMapping mapping = dbMapping();
		String tableName = mapping.tableName;
		String regionId = mapping.regionId;
		String regionName = mapping.regionName;

		StringBuffer sql = new StringBuffer("select t1.time_id");

		StringBuffer pirectT1 = new StringBuffer("select time_id");
		StringBuffer pirectT2 = new StringBuffer("select replace(substr(char(date(char(insert(time_id,5,0,'-')||'-01'))+1 month),1,7),'-','') time_id");
		String[] originIds = kpiEntity.getKpiMetaData().getOriginIds().split(",");
		String[] areas = regionIds.split(",");
		for (int i = 0; i < areas.length; i++) {
			String aliasArea = areas[i].replaceAll("'HB.", "").replaceAll("'", "").replaceAll("\\.", "");
			pirectT1.append(",max(case when " + regionId + "=").append(areas[i]).append(" then " + regionName + " end)").append(" as n_").append(aliasArea).append(",sum(case when " + regionId + "=").append(areas[i]).append(" then value end)").append(" as v_").append(aliasArea);

			pirectT2.append(",sum(case when " + regionId + "=").append(areas[i]).append(" then value end)").append(" as v1_").append(aliasArea);

			sql.append(",n_").append(aliasArea).append(",value(1-case when v1_").append(aliasArea).append("=0 then 1 else double(v_").append(aliasArea).append(")/v1_").append(aliasArea).append(" end,0)");
		}
		String tableStr = " from " + tableName + " where time_id between ";
		pirectT1.append(tableStr);
		pirectT2.append(tableStr);

		pirectT1.append("'").append(timeStart).append("'").append(" and ").append("'").append(timeEnd).append("'");
		pirectT2.append("replace(substr(char(date(char(insert('").append(timeStart).append("',5,0,'-')||'-01'))-1 month),1,7),'-','')").append(" and ").append("replace(substr(char(date(char(insert('").append(timeEnd).append("',5,0,'-')||'-01'))-1 month),1,7),'-','')");

		String tailStr = " and " + regionId + " in (" + regionIds + ") and zb_code ='@zbCodes' " + state.toPredication() + " group by time_id order by 1";

		pirectT1.append(tailStr.replaceAll("@zbCodes", originIds[0]));
		pirectT2.append(tailStr.replaceAll("@zbCodes", originIds[1]));

		sql.append(" from (").append(pirectT1).append(" ) t1 left join (").append(pirectT2).append(" ) t2 on t1.time_id=t2.time_id order by 1 with ur");

		LOG.info("加载时间段,用于比较分析SQL:" + sql);
		Map map = new TreeMap();
		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			Statement stat = conn.createStatement();
			ResultSet rs = stat.executeQuery(sql.toString());
			while (rs.next()) {
				Map innerMap = new TreeMap();
				for (int i = 0; i < areas.length; i++) {
					String key = rs.getString(i * 2 + 2);
					String value = rs.getString(i * 2 + 3);

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
		String regionIds = "'HB.WH','HB.ES'";
		String timeEnd = "200903";
		String timeStart = "200905";
		StringBuffer sql = new StringBuffer("select t1.time_id");

		StringBuffer pirectT1 = new StringBuffer("select time_id");
		StringBuffer pirectT2 = new StringBuffer("select replace(substr(char(date(char(insert(time_id,5,0,'-')||'-01'))+1 month),1,7),'-','') time_id");

		String[] areas = regionIds.split(",");
		for (int i = 0; i < areas.length; i++) {
			String aliasArea = areas[i].replaceAll("'HB.", "").replaceAll("'", "").replaceAll("\\.", "");
			pirectT1.append(",max(case when region_id=").append(areas[i]).append(" then region_name end)").append(" as n_").append(aliasArea).append(",sum(case when region_id=").append(areas[i]).append(" then value end)").append(" as v_").append(aliasArea);

			pirectT2.append(",sum(case when region_id=").append(areas[i]).append(" then value end)").append(" as v1_").append(aliasArea);

			sql.append(",n_").append(aliasArea).append(",value(case when v1_").append(aliasArea).append("=0 then 1 else double(v_").append(aliasArea).append(")/v1_").append(aliasArea).append(" end -1,0)");
		}
		String tableStr = " from  kpi_bureau_total_monthly where time_id between ";
		pirectT1.append(tableStr);
		pirectT2.append(tableStr);

		pirectT1.append("'").append(timeStart).append("'").append(" and ").append("'").append(timeEnd).append("'");
		pirectT2.append("replace(substr(char(date(char(insert('").append(timeStart).append("',5,0,'-')||'-01'))-1 month),1,7),'-','')").append(" and ").append("replace(substr(char(date(char(insert('").append(timeEnd).append("',5,0,'-')||'-01'))-1 month),1,7),'-','')");

		String tailStr = " and region_id in (" + regionIds + ") and zb_code ='" + "123" + "' group by time_id order by 1";

		pirectT1.append(tailStr);
		pirectT2.append(tailStr);

		sql.append(" from (").append(pirectT1).append(" ) t1 left join (").append(pirectT2).append(" ) t2 on t1.time_id=t2.time_id order by 1 with ur");

		System.out.println(sql);

	}
}
