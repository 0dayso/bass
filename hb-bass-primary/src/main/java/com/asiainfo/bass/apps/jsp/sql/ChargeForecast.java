package com.asiainfo.bass.apps.jsp.sql;

import java.util.List;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.chart.FusionChartHelper;
@SuppressWarnings("rawtypes")
public class ChargeForecast {
	static Logger log = org.apache.log4j.Logger.getLogger("JSPOMAction");

	public static String chartKpiConntryWide(String sql, String name)
			throws Exception {
		// sql = new String(sql.getBytes("iso-8859-1"),"utf-8");
		// name =new String(name.getBytes("gbk"),"utf-8");
		log.debug("SQL=" + sql);
		SQLQuery sqlQuery = null;
		// if("web".equalsIgnoreCase(ds))
		sqlQuery = SQLQueryContext.getInstance()
				.getSQLQuery("list", "AiomniDB");
		// else SQLQueryContext.getInstance().getSQLQuery("list");
		List list = (List) sqlQuery.query(sql);
		FusionChartHelper.Options options = new FusionChartHelper.Options();
		options.setCaption(name);
		options.setShowNames("1");
		options.setShowValues("1");
		options.setSetElement(new String[] { "name", "value", "color" });
		int flag = 0;
		for (int i = 0; i < list.size(); i++) {
			String[] line = (String[]) list.get(i);
			if ("湖北".equalsIgnoreCase(line[0]))
				line[2] = flag == 1 ? "D64646" : "008ED6";
			else if ("全国平均".equalsIgnoreCase(line[0])) {
				line[2] = "AFD8F8";
				flag = 1;
			}
		}
		return FusionChartHelper.chartMultiCol(list, options);
	}

	public static String chargeAlert(String date1, String date2, String zbCode,
			String area) throws Exception {
		String condition = "";
		if ("K10002".equalsIgnoreCase(zbCode))
			condition += "and charge_type in ('LOCAL','TOLL','ROAM','IP')";
		if (!"0".equalsIgnoreCase(area))
			condition += " and channel_code like '" + area + "%'";

		String sql = "select substr(time_id,7,2)"
				+ ",'本月',value(decimal(sum(case when substr(time_id,5,2)=substr('@date1',5,2) then value end),16,2)/10000,0)"
				+ ",'上月同期',value(decimal(sum(case when substr(time_id,5,2)=substr('@date2',5,2) then value end),16,2)/10000,0) "
				+ "from nmk.kpi_wave_daily where (time_id between substr('@date1',1,6)||'01' and '@date1' or time_id between substr('@date2',1,6)||'01' and '@date2') and ZB_CODE='"
				+ zbCode + "' " + condition
				+ "  group by substr(time_id,7,2) with ur";
		sql = sql.replaceAll("@date1", date1).replaceAll("@date2", date2);
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
		log.debug("SQL=" + sql);
		List list = (List) sqlQuery.query(sql);
		FusionChartHelper.Options options = new FusionChartHelper.Options();
		options.setCaption("");
		return FusionChartHelper.chartMultiCol(list, options);
	}

	public static List chargeForecastList(String timeid) throws Exception {

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
		String sql = "select 1 from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id='"
				+ timeid + "' with ur";
		log.debug("SQL=" + sql);
		List list = (List) sqlQuery.query(sql);
		return list;
	}

	public static StringBuilder chargeForecastSql(StringBuilder sb1,
			StringBuilder sb2, StringBuilder sb, String currentyyyyMM)
			throws Exception {

		StringBuilder sql = new StringBuilder(
				"select @col1@,decimal(sum(value),16,2)/10000 from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id in (");
		sql.append(sb.length() == 0 ? "''" : sb.toString());
		sql.append(")  group by time_id union all select '@col2@',decimal(t1.va,16,2)/t2.va*t3.va/10000 from ");

		sql.append("(select sum(value) va from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id in (");
		sql.append(sb1.toString()).append("))t1");

		sql.append(",(select sum(value) va from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id in (");
		sql.append(sb2.toString()).append("))t2");
		sql.append(",(select value va from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id='");
		sql.append(currentyyyyMM).append("' ) t3 order by 1 with ur");
		log.debug("SQL=" + sql);
		return sql;
	}

	public static String chargeForecastSql(StringBuilder sql,
			String currentyyyyMM) throws Exception {

		String sqlStr = sql.toString()
				.replaceAll("@col1@", "substr(time_id,1,6)")
				.replaceAll("@col2@", currentyyyyMM);
		log.debug("sqlStr=" + sqlStr);
		return sqlStr;
	}

	public static String chargeForecastChart(StringBuilder sql,
			String currentyyyyMM) throws Exception {

		String sqlStr = sql
				.toString()
				.replaceAll("@col1@", "substr(time_id,3,4),'收入(万元)'")
				.replaceAll("@col2@",
						currentyyyyMM.substring(2, 6) + "','收入(万元)");
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
		List list = (List) sqlQuery.query(sqlStr);
		log.debug("sqlStr=" + sqlStr);

		FusionChartHelper.Options options = new FusionChartHelper.Options();
		options.setCaption("");
		String result = FusionChartHelper.chartMultiCol(list, options);
		return result;
	}

	public static StringBuilder chargeForecastCity(StringBuilder sb1,
			StringBuilder sb2, String currentyyyyMM, String preyyyyMM)
			throws Exception {

		StringBuilder sql2 = new StringBuilder();
		sql2.append(
				"select (select area_name from mk.bt_area where area_code=t1.channel_code),decimal(t1.va,16,4)*decimal(t2.va,16,4)/decimal(t3.va,16,4)/10000 ,t4.va/10000 from (select channel_code,value va from  kpi_total_daily where zb_code='K10001' and time_id ='")
				.append(currentyyyyMM)
				.append("' and parent_channel_code='HB') t1,")
				.append("(select channel_code,sum(value) va from kpi_total_daily where zb_code='K10001' and time_id in (")
				.append(sb1.toString())
				.append(") and parent_channel_code='HB' group by channel_code) t2,")
				.append("(select channel_code,sum(value) va from kpi_total_daily where zb_code='K10001' and time_id in (")
				.append(sb2.toString())
				.append(") and parent_channel_code='HB' group by channel_code) t3, ")
				.append("(select channel_code,sum(value) va from kpi_total_daily where zb_code='K10001' and time_id ='")
				.append(preyyyyMM)
				.append("' and parent_channel_code='HB' group by channel_code) t4 ")
				.append(" where t1.channel_code=t2.channel_code and t2.channel_code=t3.channel_code and t4.channel_code=t3.channel_code  order by 2 desc with ur");
		log.debug("sql2=" + sql2);
		return sql2;
	}
}
