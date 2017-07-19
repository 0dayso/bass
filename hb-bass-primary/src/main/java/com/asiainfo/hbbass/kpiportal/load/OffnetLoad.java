package com.asiainfo.hbbass.kpiportal.load;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityLoad;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueState;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalException;

/**
 * 月离网率计算
 * 
 * 继承了DefaultLoad,所以是按照SQL来计算的
 * 
 * @author Mei Kefu
 * 
 */
public class OffnetLoad extends DefaultLoad implements KPIEntityLoad {

	private static Logger LOG = Logger.getLogger(OffnetLoad.class);
	private static final long serialVersionUID = -7494676025483550441L;
	private String loadIndicator = ",value(case when sum(case when time_id in (?,?) and zb_code=? then value end)=0 then 0 else 2*double(sum(case when time_id =? and zb_code=? then value end))/sum(case when time_id in (?,?) and zb_code=? then value end) end,0) as current"
			+ ",value(case when sum(case when time_id in (?,?) and zb_code=? then value end)=0 then 0 else 2*double(sum(case when time_id =? and zb_code=? then value end))/sum(case when time_id in (?,?) and zb_code=? then value end) end,0) as pre"
			+ ",value(case when sum(case when time_id in (?,?) and zb_code=? then value end)=0 then 0 else 2*double(sum(case when time_id =? and zb_code=? then value end))/sum(case when time_id in (?,?) and zb_code=? then value end) end,0) as before" + ", 0 as year";

	@Override
	public KPIEntity load(KpiDataStore dataStore) throws KPIPortalException {
		return load();
	}
	/**
	 * 
	 * select region_id, max(region_name) region_name,parent_id,'' ,case when
	 * sum(case when time_id in ('200904','200905') and zb_code='BM0051' then
	 * value end) = 0 then 0 else value(double(sum(case when time_id ='200905'
	 * and zb_code='BM0005' then value end))/sum(case when time_id ='200904' and
	 * zb_code='BM0001' then value end),0) - (-2) end as current ,int('0')*1 as
	 * year from kpi_bureau_total_monthly where TIME_ID in
	 * ('200905','200904','200903','200805','200804') and zb_code in
	 * ('BM0053','BM0051') and "LEVEL"=0 group by REGION_ID,parent_id
	 */
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
		@SuppressWarnings("rawtypes")
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
			ps.setString(2, current);
			ps.setString(3, current1);
			ps.setString(4, originIds[1]);
			ps.setString(5, current);
			ps.setString(6, originIds[0]);
			ps.setString(7, current);
			ps.setString(8, current1);
			ps.setString(9, originIds[1]);
			ps.setString(10, pre);
			ps.setString(11, pre1);
			ps.setString(12, originIds[1]);
			ps.setString(13, pre);
			ps.setString(14, originIds[0]);
			ps.setString(15, pre);
			ps.setString(16, pre1);
			ps.setString(17, originIds[1]);
			ps.setString(18, before);
			ps.setString(19, before1);
			ps.setString(20, originIds[1]);
			ps.setString(21, before);
			ps.setString(22, originIds[0]);
			ps.setString(23, before);
			ps.setString(24, before1);
			ps.setString(25, originIds[1]);
			ps.setString(26, current);
			ps.setString(27, pre);
			ps.setString(28, pre1);
			ps.setString(29, before);
			ps.setString(30, before1);
			ps.setString(31, originIds[0]);
			ps.setString(32, originIds[1]);

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

	public KPIEntity loadNoCached(String parentRegionId) throws KPIPortalException {

		String sql = "";
		String appName = kpiEntity.getKpiAppData().getName();
		DBMapping dbMapping = dbMapping();
		if ("ChannelM".equalsIgnoreCase(appName))
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=channel_code),0) targetvalue" + loadIndicator + " from " + dbMapping.tableName
					+ " where time_id in (?,?,?,?,?) and zb_code in (?,?) and parent_channel_code=? group by channel_code,parent_channel_code order by current desc with ur";
		else if ("BureauM".equalsIgnoreCase(appName))
			sql = "select region_id, max(region_name) region_name,parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=region_id),0) targetvalue" + loadIndicator + " from " + dbMapping.tableName
					+ " where time_id in (?,?,?,?,?) and zb_code in (?,?) and parent_id=? group by region_id,parent_id,level order by level,current desc with ur";

		String[] originIds = kpiEntity.getKpiMetaData().getOriginIds().split(",");

		Connection conn = ConnectionManage.getInstance().getDWConnection();
		@SuppressWarnings("rawtypes")
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
			ps.setString(2, current);
			ps.setString(3, current1);
			ps.setString(4, originIds[1]);
			ps.setString(5, current);
			ps.setString(6, originIds[0]);
			ps.setString(7, current);
			ps.setString(8, current1);
			ps.setString(9, originIds[1]);
			ps.setString(10, pre);
			ps.setString(11, pre1);
			ps.setString(12, originIds[1]);
			ps.setString(13, pre);
			ps.setString(14, originIds[0]);
			ps.setString(15, pre);
			ps.setString(16, pre1);
			ps.setString(17, originIds[1]);
			ps.setString(18, before);
			ps.setString(19, before1);
			ps.setString(20, originIds[1]);
			ps.setString(21, before);
			ps.setString(22, originIds[0]);
			ps.setString(23, before);
			ps.setString(24, before1);
			ps.setString(25, originIds[1]);
			ps.setString(26, current);
			ps.setString(27, pre);
			ps.setString(28, pre1);
			ps.setString(29, before);
			ps.setString(30, before1);
			ps.setString(31, originIds[0]);
			ps.setString(32, originIds[1]);
			ps.setString(33, parentRegionId);

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
	 * select t1.time_id ,n_es,2*double(v_es)/(v1_es+v2_es)
	 * ,n_ez,2*double(v_ez)/(v1_ez+v2_ez) from (select time_id ,max(case when
	 * region_id='HB.ES' then region_name end) as n_es,sum(case when
	 * region_id='HB.ES' then value end) v_es ,max(case when region_id='HB.EZ'
	 * then region_name end) as n_ez,sum(case when region_id='HB.EZ' then value
	 * end) v_ez from kpi_bureau_total_monthly where TIME_ID in
	 * ('200905','200904','200902') and zb_code ='BM0053' and region_id in
	 * ('HB.ES','HB.EZ') group by time_id order by 1) t1 left join ( select
	 * replace(substr(char(date(char(insert(time_id,5,0,'-')||'-01'))+1
	 * month),1,7),'-','') time_id ,sum(case when region_id='HB.ES' then value
	 * end) v1_es ,sum(case when region_id='HB.EZ' then value end) v1_ez from
	 * kpi_bureau_total_monthly where TIME_ID in ('200904','200903','200902')
	 * and zb_code ='BM0051' and region_id in ('HB.ES','HB.EZ') group by time_id
	 * order by 1) t2 on t1.time_id=t2.time_id left join (select time_id
	 * ,sum(case when region_id='HB.ES' then value end) v2_es ,sum(case when
	 * region_id='HB.EZ' then value end) v2_ez from kpi_bureau_total_monthly
	 * where TIME_ID in ('200905','200904','200902') and zb_code ='BM0051' and
	 * region_id in ('HB.ES','HB.EZ') group by time_id order by 1) t3 on
	 * t1.time_id=t3.time_id order by 1
	 */
	@Override
	protected String duringProcessSQL(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) {
		DBMapping mapping = dbMapping();
		String tableName = mapping.tableName;
		String regionId = mapping.regionId;
		String regionName = mapping.regionName;

		StringBuffer sql = new StringBuffer("select t1.time_id");

		StringBuffer pirectT1 = new StringBuffer("select time_id");
		StringBuffer pirectT3 = new StringBuffer("select time_id");
		StringBuffer pirectT2 = new StringBuffer("select replace(substr(char(date(char(insert(time_id,5,0,'-')||'-01'))+1 month),1,7),'-','') time_id");
		String[] originIds = kpiEntity.getKpiMetaData().getOriginIds().split(",");
		String[] areas = regionIds.split(",");
		for (int i = 0; i < areas.length; i++) {
			String aliasArea = areas[i].replaceAll("'HB.", "").replaceAll("'", "").replaceAll("\\.", "");
			pirectT1.append(",max(case when " + regionId + "=").append(areas[i]).append(" then " + regionName + " end)").append(" as n_").append(aliasArea).append(",sum(case when " + regionId + "=").append(areas[i]).append(" then value end)").append(" as v_").append(aliasArea);

			pirectT2.append(",sum(case when " + regionId + "=").append(areas[i]).append(" then value end)").append(" as v1_").append(aliasArea);

			pirectT3.append(",sum(case when " + regionId + "=").append(areas[i]).append(" then value end)").append(" as v2_").append(aliasArea);

			sql.append(",n_").append(aliasArea).append(",2*value(case when v1_").append(aliasArea).append("+v2_").append(aliasArea).append("=0 then 0 else double(v_").append(aliasArea).append(")/(v1_").append(aliasArea).append("+v2_").append(aliasArea).append(")").append(" end,0)");
		}
		String tableStr = " from " + tableName + " where time_id between ";
		pirectT1.append(tableStr);
		pirectT2.append(tableStr);
		pirectT3.append(tableStr);

		pirectT1.append("'").append(timeStart).append("'").append(" and ").append("'").append(timeEnd).append("'");
		pirectT2.append("replace(substr(char(date(char(insert('").append(timeStart).append("',5,0,'-')||'-01'))-1 month),1,7),'-','')").append(" and ").append("replace(substr(char(date(char(insert('").append(timeEnd).append("',5,0,'-')||'-01'))-1 month),1,7),'-','')");
		pirectT3.append("'").append(timeStart).append("'").append(" and ").append("'").append(timeEnd).append("'");

		String tailStr = " and " + regionId + " in (" + regionIds + ") and zb_code='@zbCodes' " + state.toPredication() + " group by time_id order by 1";

		pirectT1.append(tailStr.replaceAll("@zbCodes", originIds[0]));
		pirectT2.append(tailStr.replaceAll("@zbCodes", originIds[1]));
		pirectT3.append(tailStr.replaceAll("@zbCodes", originIds[1]));

		sql.append(" from (").append(pirectT1).append(" ) t1 left join (").append(pirectT2).append(" ) t2 on t1.time_id=t2.time_id ").append(" left join (").append(pirectT3).append(") t3 on t1.time_id=t3.time_id order by 1 with ur");
		LOG.info("加载时间段,用于比较分析SQL:" + sql);
		return sql.toString();
	}

	/*
	 * @Override protected Map loadDuringData(String regionIds,
	 * KPIEntityValueState state, String timeStart, String timeEnd) throws
	 * KPIPortalException {
	 * 
	 * DBMapping mapping = dbMapping(); String tableName = mapping.tableName;
	 * String regionId = mapping.regionId; String regionName =
	 * mapping.regionName;
	 * 
	 * StringBuffer sql = new StringBuffer("select t1.time_id");
	 * 
	 * StringBuffer pirectT1 = new StringBuffer("select time_id"); StringBuffer
	 * pirectT3 = new StringBuffer("select time_id"); StringBuffer pirectT2 =
	 * new StringBuffer(
	 * "select replace(substr(char(date(char(insert(time_id,5,0,'-')||'-01'))+1 month),1,7),'-','') time_id"
	 * ); String[] originIds =
	 * kpiEntity.getKpiMetaData().getOriginIds().split(","); String[] areas =
	 * regionIds.split(","); for (int i = 0; i < areas.length; i++) { String
	 * aliasArea = areas[i].replaceAll("'HB.", "").replaceAll("'",
	 * "").replaceAll("\\.", "");
	 * pirectT1.append(",max(case when "+regionId+"=")
	 * .append(areas[i]).append(" then "
	 * +regionName+" end)").append(" as n_").append(aliasArea)
	 * .append(",sum(case when "
	 * +regionId+"=").append(areas[i]).append(" then value end)"
	 * ).append(" as v_").append(aliasArea);
	 * 
	 * pirectT2.append(",sum(case when "+regionId+"=").append(areas[i]).append(
	 * " then value end)").append(" as v1_").append(aliasArea);
	 * 
	 * pirectT3.append(",sum(case when "+regionId+"=").append(areas[i]).append(
	 * " then value end)").append(" as v2_").append(aliasArea);
	 * 
	 * sql.append(",n_").append(aliasArea)
	 * .append(",2*value(case when v1_").append
	 * (aliasArea).append("+v2_").append(
	 * aliasArea).append("=0 then 0 else double(v_"
	 * ).append(aliasArea).append(")/(v1_"
	 * ).append(aliasArea).append("+v2_").append
	 * (aliasArea).append(")").append(" end,0)"); } String tableStr =
	 * " from "+tableName+" where time_id between "; pirectT1.append(tableStr);
	 * pirectT2.append(tableStr); pirectT3.append(tableStr);
	 * 
	 * pirectT1.append("'").append(timeStart).append("'").append(" and ").append(
	 * "'").append(timeEnd).append("'");
	 * pirectT2.append("replace(substr(char(date(char(insert('"
	 * ).append(timeStart
	 * ).append("',5,0,'-')||'-01'))-1 month),1,7),'-','')").append
	 * (" and ").append
	 * ("replace(substr(char(date(char(insert('").append(timeEnd)
	 * .append("',5,0,'-')||'-01'))-1 month),1,7),'-','')");
	 * pirectT3.append("'")
	 * .append(timeStart).append("'").append(" and ").append(
	 * "'").append(timeEnd).append("'");
	 * 
	 * 
	 * String tailStr =
	 * " and "+regionId+" in ("+regionIds+") and zb_code='@zbCodes' "
	 * +state.toPredication()+" group by time_id order by 1";
	 * 
	 * pirectT1.append(tailStr.replaceAll("@zbCodes", originIds[0]));
	 * pirectT2.append(tailStr.replaceAll("@zbCodes", originIds[1]));
	 * pirectT3.append(tailStr.replaceAll("@zbCodes", originIds[1]));
	 * 
	 * sql.append(" from (").append(pirectT1).append(" ) t1 left join (").append(
	 * pirectT2
	 * ).append(" ) t2 on t1.time_id=t2.time_id ").append(" left join (")
	 * .append(
	 * pirectT3).append(") t3 on t1.time_id=t3.time_id order by 1 with ur");
	 * 
	 * LOG.info("加载时间段,用于比较分析SQL:"+sql); Map map = new TreeMap(); Connection
	 * conn = ConnectionManage.getInstance().getDWConnection(); try { Statement
	 * stat = conn.createStatement(); ResultSet rs =
	 * stat.executeQuery(sql.toString()); while(rs.next()){ Map innerMap = new
	 * TreeMap(); for (int i = 0; i < areas.length; i++) { String key =
	 * rs.getString(i*2+2); String value = rs.getString(i*2+3);
	 * 
	 * innerMap.put(key, duringGetValue(Double.valueOf(value).doubleValue(),
	 * state)); } map.put(rs.getString(1), innerMap); } rs.close();
	 * stat.close(); } catch (SQLException e) { e.printStackTrace(); }finally{
	 * if(conn!=null) try { conn.close(); } catch (SQLException e) {
	 * e.printStackTrace(); } } return map; }
	 */

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
