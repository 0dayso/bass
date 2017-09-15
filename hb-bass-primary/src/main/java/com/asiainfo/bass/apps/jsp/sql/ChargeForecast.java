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
		String sql = "select 1 from kpi_comp_cd005_m_vertical where kpi_code='MCD005L00001' and dim_code='PROV_ID' and dim_val='HB' and op_time='"
				+ timeid + "' with ur";
		log.debug("SQL=" + sql);
		List list = (List) sqlQuery.query(sql);
		return list;
	}

	public static StringBuilder chargeForecastSql(StringBuilder sb1,
			StringBuilder sb2, StringBuilder sb, String currentyyyyMM)
			throws Exception {

		StringBuilder sql = new StringBuilder(
				"select @col1@,decimal(sum(kpi_val),16,2) from kpi_comp_cd005_m_vertical where kpi_code='MCD005L00001' and dim_code='PROV_ID' and dim_val='HB' and op_time in (");
		sql.append(sb.length() == 0 ? "''" : sb.toString());
		sql.append(")  group by op_time union all select '@col2@',decimal(t1.va,16,2)/t2.va*t3.va from ");

		sql.append("(select sum(kpi_val) va from kpi_comp_cd005_m_vertical where kpi_code='MCD005L00001' and dim_code='PROV_ID' and dim_val='HB' and op_time  in (");
		sql.append(sb1.toString()).append("))t1");

		sql.append(",(select sum(kpi_val) va from kpi_comp_cd005_m_vertical where kpi_code='MCD005L00001' and dim_code='PROV_ID' and dim_val='HB' and op_time  in (");
		sql.append(sb2.toString()).append("))t2");
		sql.append(",(select kpi_val va from kpi_comp_cd005_m_vertical where kpi_code='MCD005L00001' and dim_code='PROV_ID' and dim_val='HB' and op_time='");
		sql.append(currentyyyyMM).append("' ) t3 order by 1 with ur");
		log.debug("SQL=" + sql);
		return sql;
	}

	public static String chargeForecastSql(StringBuilder sql,
			String currentyyyyMM) throws Exception {

		String sqlStr = sql.toString()
				.replaceAll("@col1@", "substr(op_time,1,6)")
				.replaceAll("@col2@", currentyyyyMM);
		log.debug("sqlStr=" + sqlStr);
		return sqlStr;
	}

	public static String chargeForecastChart(StringBuilder sql,
			String currentyyyyMM) throws Exception {

		String sqlStr = sql
				.toString()
				.replaceAll("@col1@", "substr(op_time,3,4),'收入(万元)'")
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
				"select a.area_name area_name,decimal(t1.va,16,4)*decimal(t2.va,16,4)/decimal(t3.va,16,4) ,t4.va from (select dim_val,kpi_val va from  kpi_comp_cd005_m_vertical where kpi_code='MCD005L00001' and op_time ='")
				.append(currentyyyyMM)
				.append("') t1,")
				.append("(select dim_val,sum(kpi_val) va from kpi_comp_cd005_m_vertical where kpi_code='MCD005L00001' and op_time in (")
				.append(sb1.toString())
				.append(") group by dim_val) t2,")
				.append("(select dim_val,sum(kpi_val) va from kpi_comp_cd005_m_vertical where kpi_code='MCD005L00001' and op_time in (")
				.append(sb2.toString())
				.append(") group by dim_val) t3, ")
				.append("(select dim_val,sum(kpi_val) va from kpi_comp_cd005_m_vertical where kpi_code='MCD005L00001' and op_time ='")
				.append(preyyyyMM)
				.append("' group by dim_val) t4 ")
				.append(",mk.bt_area  a ")
				.append(" where a.area_code=t1.dim_val  and t1.dim_val=t2.dim_val and t2.dim_val=t3.dim_val and t4.dim_val=t3.dim_val  order by 2 desc with ur");
		log.debug("sql2=" + sql2);
		return sql2;
	}
}
