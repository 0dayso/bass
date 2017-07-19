package com.asiainfo.hbbass.kpiportal.load;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
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
 * 年累计收入
 * 
 * @author Mei Kefu
 * @date 2010-4-30
 */
public class ChargeAccumulateLoad extends DefaultLoad implements KPIEntityLoad {

	private static Logger LOG = Logger.getLogger(ChargeAccumulateLoad.class);
	private static final long serialVersionUID = -8572000678977700565L;
	// private String constants =
	// ",'@month0131','@month022#','@month0331','@month0430','@month0531','@month0630','@month0731','@month0831','@month0930','@month1031','@month1130'";

	private String constants = ",'@month01','@month02','@month03','@month04','@month05','@month06','@month07','@month08','@month09','@month10','@month11','@month12'";

	private String loadIndicator = 
			",value(sum(case when time_id in (?@curPiece) then value end),0) as current" 
			+ ",value(sum(case when time_id in (?@curPiece) then value end),0) as pre" 
			+ ",value(sum(case when time_id in (?@befPiece) then value end),0) as before"
			+ ",value(sum(case when time_id in (?@yearPiece) then value end),0) as year"
			+ ",value(sum(case when time_id in (''@curPiece) then value end),0) as month_accu_value";

	/**
	 * 计算累计的日期部分
	 * 
	 * @return
	 */
	private String getDatePiece(String month, String year) {

		int nMonth = Integer.parseInt(month);
		String temp = constants.substring(0, (nMonth - 1) * 11);
		if (temp.length() > 0) {
			temp = temp.replaceAll("@month", year);
		}
		return temp;
	}
	
	@Override
	public KPIEntity load(KpiDataStore dataStore) throws KPIPortalException {
		return load();
	}

	/**
	 * 
	 * select a.channel_code region_id,max(value(a.channel_name,a.channel_code))
	 * region_name,a.parent_channel_code parent_id,''
	 * brand_id,value(targetvalue,0) targetvalue ,sum(case when a.time_id in
	 * ('20100429','201001','201002','201003') then value end) as current
	 * ,value(sum(case when a.time_id in ('20100428','201001','201002','201003')
	 * then value end),0) as pre ,value(sum(case when a.time_id in
	 * ('20100329','201001','201002') then value end),0) as before
	 * ,value(sum(case when a.time_id in ('20090429','200901','200902','200903')
	 * then value end),0) as year from ( select
	 * time_id,channel_code,channel_name,parent_channel_code,value from
	 * kpi_total_daily where time_id in
	 * ('20100429','20100428','20100329','20090429') and zb_code = 'K10001' and
	 * length(channel_code)<=5 and channel_code like 'HB%' union all select
	 * time_id,channel_code,channel_name,parent_channel_code,value from
	 * kpi_total_monthly where time_id in
	 * ('201001','201002','201003','200901','200902','200903') and zb_code =
	 * 'K20001' and length(channel_code)<=5 and channel_code like 'HB%' ) a left
	 * join kpiportal_target on 'KC0010'=ZBCODE and a.CHANNEL_CODE=AREA_ID group
	 * by a.channel_code,a.parent_channel_code,targetvalue order by
	 * a.channel_code with ur
	 * 
	 * --月 select a.channel_code
	 * region_id,max(value(a.channel_name,a.channel_code))
	 * region_name,a.parent_channel_code parent_id,''
	 * brand_id,value(targetvalue,0) targetvalue ,sum(case when a.time_id in
	 * ('201004','201001','201002','201003') then value end) as current
	 * ,value(sum(case when a.time_id in ('201003','201001','201002') then value
	 * end),0) as pre ,value(sum(case when a.time_id in
	 * ('200904','200901','200902','200903') then value end),0) as before ,'' as
	 * year from kpi_total_monthly a left join kpiportal_target on
	 * 'KC0010'=ZBCODE and a.CHANNEL_CODE=AREA_ID where time_id in (
	 * '201004','201001','201002','201003','200904','200901','200902','200903')
	 * and zb_code = 'K20001' and length(channel_code)<=5 and channel_code like
	 * 'HB%' group by a.channel_code,a.parent_channel_code,targetvalue order by
	 * a.channel_code with ur;
	 */
	@SuppressWarnings("rawtypes")
	public KPIEntity load() throws KPIPortalException {

		String sql = "";
		String appName = kpiEntity.getKpiAppData().getName();
		DBMapping dbMapping = dbMapping();
		if ("ChannelD".equalsIgnoreCase(appName)) {

			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=channel_code),0) targetvalue" + loadIndicator + " from ("

			+ "select time_id,channel_code,channel_name,parent_channel_code,value from " + dbMapping.tableName + " where time_id in (?,?,?,?) and zb_code = ? and length(channel_code)<=8 and channel_code like 'HB%'" + " union all "
					+ " select time_id,channel_code,channel_name,parent_channel_code,value from kpi_total_monthly where time_id in (''@curPiece@befPiece@yearPiece) and zb_code = ? and length(channel_code)<=8 and channel_code like 'HB%'" + ") a "

					+ "group by channel_code,parent_channel_code order by channel_code with ur";
		} else if ("BureauD".equalsIgnoreCase(appName)) {

			sql = "select region_id, max(region_name) region_name,parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=region_id),0) targetvalue" + loadIndicator

			+ " from ("

			+ "select time_id,region_id,region_name,parent_id,level,value from " + dbMapping.tableName + " where time_id in (?,?,?,?) and zb_code = ? and level<=3" + " union all "
					+ " select time_id,region_id,region_name,parent_id,level,value from kpi_bureau_town_monthly where time_id in (''@curPiece@befPiece@yearPiece) and zb_code = ? and level<=3" + ") a "

					// +" from "+mapping.tableName+" where time_id in (?,?,?,?@curPiece@befPiece@yearPiece) and zb_code = ? and level<=3 "

					+ "group by region_id,parent_id,level order by level,region_id with ur";
		} else if ("ChannelM".equalsIgnoreCase(appName)) {
			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=channel_code),0) targetvalue" + loadIndicator + " from " + dbMapping.tableName + " a "
					+ " where time_id in (?,?,?,?,?@curPiece@befPiece@yearPiece) and zb_code = ? and length(channel_code)<=5 and channel_code like 'HB%' " + "group by channel_code,parent_channel_code order by channel_code with ur";
		} else if ("BureauM".equalsIgnoreCase(appName)) {
			sql = "select region_id, max(region_name) region_name,parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=region_id),0) targetvalue" + loadIndicator + " from " + dbMapping.tableName + " a "
					+ " where time_id in (?,?,?,?,?@curPiece@befPiece@yearPiece) and zb_code = ? and level<=3 " + "group by region_id,parent_id,level order by level,region_id with ur";
		}
		String[] originIds = kpiEntity.getKpiMetaData().getOriginIds().split(",");

		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		List<Map<String,String>> data = null;
		List list = null;
		try {
			String zbCode = kpiEntity.getId();
			String current = kpiEntity.getDate();
			String[] dates = KPIPortalContext.calDate(current);
			String pre = dates[0];
			String before = dates[1];
			String year = dates[2];

			sql = sql.replaceAll("@curPiece", getDatePiece(current.substring(4, 6), current.substring(0, 4))).replaceAll("@befPiece", getDatePiece(before.substring(4, 6), before.substring(0, 4))).replaceAll("@yearPiece", year.length() > 6 ? getDatePiece(year.substring(4, 6), year.substring(0, 4)) : "");

			LOG.debug("SQL:" + sql);
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, zbCode);
			ps.setString(2, current);
			ps.setString(3, pre);
			ps.setString(4, before);
			ps.setString(5, year);
			ps.setString(6, current);
			ps.setString(7, pre);
			ps.setString(8, before);
			ps.setString(9, year);
			ps.setString(10, originIds[0]);
			ps.setString(11, originIds[1]);

			data=resultsetMappList(ps.executeQuery());
			
			list = mapping(data);

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
		
		if(data!=null && data.size()>0){
			Map<String,String> first = (Map<String,String>)data.get(0);
			String _current=first.get("current");
			String _month_accu_value=first.get("month_accu_value");
			
			if(!_current.equalsIgnoreCase(_month_accu_value)){
				process(list);
			}else{
				LOG.warn(kpiEntity.getDate()+"-"+kpiEntity.getId()+"指标数据还没有出来");
			}
		}

		return kpiEntity;
	}

	@SuppressWarnings("rawtypes")
	public KPIEntity loadNoCached(String parentRegionId) throws KPIPortalException {

		String sql = "";
		String appName = kpiEntity.getKpiAppData().getName();
		DBMapping dbMapping = dbMapping();
		if ("ChannelD".equalsIgnoreCase(appName)) {

			sql = "select channel_code region_id,max(value(channel_name,channel_code)) region_name,parent_channel_code parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=channel_code),0) targetvalue" + loadIndicator

			+ " from ("

			+ "select time_id,channel_code,channel_name,parent_channel_code,value from " + dbMapping.tableName + " where time_id in (?,?,?,?) and zb_code = ? and parent_channel_code=? " + " union all "
					+ " select time_id,channel_code,channel_name,parent_channel_code,value from kpi_total_monthly where time_id in (''@curPiece@befPiece@yearPiece) and zb_code = ? and parent_channel_code=?" + ") a "

					+ "group by channel_code,parent_channel_code order by current desc with ur";

			// +" from "+mapping.tableName+" where time_id in (?,?,?,?@curPiece@befPiece@yearPiece) and zb_code = ? and parent_channel_code=? group by channel_code,parent_channel_code order by current desc with ur";
		} else if ("BureauD".equalsIgnoreCase(appName)) {
			// DBMapping mapping = dbMapping();
			sql = "select region_id, max(region_name) region_name,parent_id,'' brand_id,value((select targetvalue from kpiportal_target where zbcode=? and AREA_ID=region_id),0) targetvalue" + loadIndicator

			+ " from ("

			+ "select time_id,region_id,region_name,parent_id,value from " + dbMapping.tableName + " where time_id in (?,?,?,?) and zb_code = ? and parent_id=?" + " union all "
					+ " select time_id,region_id,region_name,parent_id,value from kpi_bureau_town_monthly where time_id in (''@curPiece@befPiece@yearPiece) and zb_code = ? and parent_id=?" + ") a "

					// +" from "+mapping.tableName+" where time_id in (?,?,?,?@curPiece@befPiece@yearPiece) and zb_code = ? and level<=3 "

					+ "group by region_id,parent_id order by current desc with ur";

			// +" from "+mapping.tableName+" where time_id in (?,?,?,?@curPiece@befPiece@yearPiece) and zb_code = ? and parent_id=? group by region_id,parent_id,level order by level,current desc with ur";
		}
		String[] originIds = kpiEntity.getKpiMetaData().getOriginIds().split(",");

		Connection conn = ConnectionManage.getInstance().getWEBConnection();
		List list = null;
		try {

			String zbCode = kpiEntity.getId();
			String current = kpiEntity.getDate();
			String[] dates = KPIPortalContext.calDate(current);
			String pre = dates[0];
			String before = dates[1];
			String year = dates[2];

			sql = sql.replaceAll("@curPiece", getDatePiece(current.substring(4, 6), current.substring(0, 4))).replaceAll("@befPiece", getDatePiece(before.substring(4, 6), before.substring(0, 4))).replaceAll("@yearPiece", getDatePiece(year.substring(4, 6), year.substring(0, 4)));
			LOG.info("SQL:" + sql);
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, zbCode);
			ps.setString(2, current);
			ps.setString(3, pre);
			ps.setString(4, before);
			ps.setString(5, year);
			ps.setString(6, current);
			ps.setString(7, pre);
			ps.setString(8, before);
			ps.setString(9, year);
			ps.setString(10, originIds[0]);
			ps.setString(11, parentRegionId);
			ps.setString(12, originIds[1]);
			ps.setString(13, parentRegionId);

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
		String[] OriZbCodes = kpiEntity.getKpiMetaData().getOriginIds().split(",");
		String sql = duringProcessSQL(regionIds, state, (timeStart), (timeEnd)).replaceAll(kpiEntity.getId(), OriZbCodes[0]);
		LOG.info("加载时间段,用于比较分析SQL:" + sql);

		String tableName = "kpi_total_monthly";
		String regionId = "channel_code";
		String regionName = "channel_name";

		String appName = kpiEntity.getKpiAppData().getName();

		if (appName.startsWith("Bureau")) {
			tableName = "kpi_bureau_town_monthly";
			regionId = "region_id";
			regionName = "region_name";
		}

		// 生成SQL
		// 判断跨年没有，跨年肯定是上一年的所有月份
		String timeStartYear = timeStart.substring(0, 4);
		String timeEndYear = timeEnd.substring(0, 4);
		StringBuffer sb1 = new StringBuffer();
		sb1.append("select ").append(regionName);
		if (timeStartYear.equalsIgnoreCase(timeEndYear)) {// 没有跨年
			int endMonth = Integer.parseInt(timeEnd.substring(4, 6));
			int startMonth = Integer.parseInt(timeStart.substring(4, 6));
			for (int i = startMonth; i <= endMonth; i++) {
				sb1.append(",value(sum(case when time_id in (''").append(getDatePiece(String.valueOf(i), timeEndYear)).append(") then value end),0)").append(" c").append(timeEndYear).append((i > 9 ? "" : "0")).append(i).append(" ");
			}
			sb1.append("from ").append(tableName).append(" where time_id in (''").append(getDatePiece(String.valueOf(endMonth), timeEndYear));

		} else {// 跨年

			StringBuffer sb2 = new StringBuffer();// 总的时间

			int endMonth = Integer.parseInt(timeEnd.substring(4, 6));
			int startMonth = Integer.parseInt(timeStart.substring(4, 6));

			// 起始年的
			for (int i = startMonth; i <= 12; i++) {
				sb1.append(",value(sum(case when time_id in (''").append(getDatePiece(String.valueOf(i), timeStartYear)).append(") then value end),0)").append(" c").append(timeStartYear).append((i > 9 ? "" : "0")).append(i).append(" ");
			}
			sb2.append(getDatePiece("13", timeStartYear));
			// 中间的年
			int nStartYear = Integer.parseInt(timeStartYear);
			int nEndYear = Integer.parseInt(timeEndYear);
			for (int j = nStartYear + 1; j < nEndYear; j++) {
				String tempYear = String.valueOf(j);
				for (int i = 1; i <= 12; i++) {
					sb1.append(",value(sum(case when time_id in (''").append(getDatePiece(String.valueOf(i), tempYear)).append(") then value end),0)").append(" c").append(tempYear).append((i > 9 ? "" : "0")).append(i).append(" ");
				}
				sb2.append(getDatePiece("13", timeStartYear));
			}

			// 结束年的
			for (int i = 1; i <= endMonth; i++) {
				sb1.append(",value(sum(case when time_id in (''").append(getDatePiece(String.valueOf(i), timeEndYear)).append(") then value end),0)").append(" c").append(timeEndYear).append((i > 9 ? "" : "0")).append(i).append(" ");
			}
			sb2.append(getDatePiece(String.valueOf(endMonth), timeStartYear));
			sb1.append("from ").append(tableName).append(" where time_id in (''").append(sb2);
		}
		sb1.append(") and ").append(regionId).append(" in (").append(regionIds).append(") and zb_code ='").append(OriZbCodes[1]).append("' group by ").append(regionName).append(" with ur");

		String sql2 = sb1.toString();

		return sql + " " + sql2;
	}

	/**
	 * 取出每个月的累计的值 返回的Map(time_id,Map1) Map1(regionName,Double_Value)
	 * 
	 * 
	 * select channel_code ,value(sum(case when time_id in ('201001') then value
	 * end),0) ,value(sum(case when time_id in ('201001','201002') then value
	 * end),0) ,value(sum(case when time_id in ('201001','201002','201003') then
	 * value end),0) from kpi_total_monthly where time_id in
	 * ('201001','201002','201003') and channel_code in ('HB.ES','HB.HS') and
	 * zb_code ='K20001' group by channel_code with ur
	 */
	@Override
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected Map loadDuringData(String regionIds, KPIEntityValueState state, String timeStart, String timeEnd) throws KPIPortalException {
		String[] OriZbCodes = kpiEntity.getKpiMetaData().getOriginIds().split(",");
		String sql = duringProcessSQL(regionIds, state, (timeStart), (timeEnd)).replaceAll(kpiEntity.getId(), OriZbCodes[0]);
		LOG.info("加载时间段,用于比较分析SQL:" + sql);
		String[] areas = regionIds.split(",");

		String tableName = "kpi_total_monthly";
		String regionId = "channel_code";
		String regionName = "channel_name";

		String appName = kpiEntity.getKpiAppData().getName();

		if (appName.startsWith("Bureau")) {
			tableName = "kpi_total_bureau_monthly";
			regionId = "region_id";
			regionName = "region_name";
		}

		// 生成SQL
		// 判断跨年没有，跨年肯定是上一年的所有月份
		String timeStartYear = timeStart.substring(0, 4);
		String timeEndYear = timeEnd.substring(0, 4);
		StringBuffer sb1 = new StringBuffer();
		sb1.append("select ").append(regionName);
		if (timeStartYear.equalsIgnoreCase(timeEndYear)) {// 没有跨年
			int endMonth = Integer.parseInt(timeEnd.substring(4, 6));
			int startMonth = Integer.parseInt(timeStart.substring(4, 6));
			for (int i = startMonth; i <= endMonth; i++) {
				sb1.append(",value(sum(case when time_id in (''").append(getDatePiece(String.valueOf(i), timeEndYear)).append(") then value end),0)").append(" c").append(timeEndYear).append((i > 9 ? "" : "0")).append(i).append(" ");
			}
			sb1.append("from ").append(tableName).append(" where time_id in (''").append(getDatePiece(String.valueOf(endMonth), timeEndYear));

		} else {// 跨年

			StringBuffer sb2 = new StringBuffer();// 总的时间

			int endMonth = Integer.parseInt(timeEnd.substring(4, 6));
			int startMonth = Integer.parseInt(timeStart.substring(4, 6));

			// 起始年的
			for (int i = startMonth; i <= 12; i++) {
				sb1.append(",value(sum(case when time_id in (''").append(getDatePiece(String.valueOf(i), timeStartYear)).append(") then value end),0)").append(" c").append(timeStartYear).append((i > 9 ? "" : "0")).append(i).append(" ");
			}
			sb2.append(getDatePiece("13", timeStartYear));
			// 中间的年
			int nStartYear = Integer.parseInt(timeStartYear);
			int nEndYear = Integer.parseInt(timeEndYear);
			for (int j = nStartYear + 1; j < nEndYear; j++) {
				String tempYear = String.valueOf(j);
				for (int i = 1; i <= 12; i++) {
					sb1.append(",value(sum(case when time_id in (''").append(getDatePiece(String.valueOf(i), tempYear)).append(") then value end),0)").append(" c").append(tempYear).append((i > 9 ? "" : "0")).append(i).append(" ");
				}
				sb2.append(getDatePiece("13", timeStartYear));
			}

			// 结束年的
			for (int i = 1; i <= endMonth; i++) {
				sb1.append(",value(sum(case when time_id in (''").append(getDatePiece(String.valueOf(i), timeEndYear)).append(") then value end),0)").append(" c").append(timeEndYear).append((i > 9 ? "" : "0")).append(i).append(" ");
			}
			sb2.append(getDatePiece(String.valueOf(endMonth), timeStartYear));
			sb1.append("from ").append(tableName).append(" where time_id in (''").append(sb2);
		}
		sb1.append(") and ").append(regionId).append(" in (").append(regionIds).append(") and zb_code ='").append(OriZbCodes[1]).append("' group by ").append(regionName).append(" with ur");

		String sql2 = sb1.toString();

		Map map = new TreeMap();
		Connection conn = ConnectionManage.getInstance().getDWConnection();
		try {
			// 先运行sql2，把数据存在一个map中结构是{region,value}，后面在来取数据计算
			Statement stat = conn.createStatement();
			ResultSet rs1 = stat.executeQuery(sql2);
			Map conts = new HashMap();
			ResultSetMetaData rsmd = rs1.getMetaData();
			while (rs1.next()) {
				String key = rs1.getString(1);
				for (int i = 1; i < rsmd.getColumnCount(); i++) {
					String name = rsmd.getColumnName(i + 1);
					Double value = Double.valueOf(rs1.getDouble(i + 1));
					conts.put(name + key, value);
				}
			}
			rs1.close();

			ResultSet rs = stat.executeQuery(sql);
			while (rs.next()) {
				Map innerMap = new TreeMap();
				String time = "C" + rs.getString(1).substring(0, 6);
				for (int i = 0; i < areas.length; i++) {

					String key = rs.getString(i * 2 + 2);
					String value = rs.getString(i * 2 + 3);

					Double value2 = (Double) conts.get(time + key);// 取需要计算的SQL2的值

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
		String constants = ",'@month01','@month02','@month03','@month04','@month05','@month06','@month07','@month08','@month09','@month10','@month11'";
		constants = constants.substring(0, (7 - 1) * 11);

		System.out.println(constants);
		String date = "20100427";
		int target = Integer.parseInt(date.substring(6, 8));
		java.util.Calendar c = new java.util.GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, target);

		System.out.println(c.get(java.util.Calendar.DAY_OF_YEAR));
	}

}
