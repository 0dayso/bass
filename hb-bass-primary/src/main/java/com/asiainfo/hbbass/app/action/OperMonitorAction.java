package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.chart.FusionChartHelper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;

/**
 * 
 * @author Mei Kefu
 * @date 2010-1-28
 * 
 * @date 2010-11-9 增加市场运营信息快报导入方法
 */
@SuppressWarnings({"rawtypes"})
public class OperMonitorAction extends Action {

	private static Logger LOG = Logger.getLogger(OperMonitorAction.class);

	public void chartkpiconntrywide(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String sql = request.getParameter("sql");
		String name = request.getParameter("name");
		// String ds = request.getParameter("ds");
		if (sql != null) {
			// sql = new String(sql.getBytes("iso-8859-1"),"utf-8");
			// name =new String(name.getBytes("gbk"),"utf-8");
			LOG.debug("SQL=" + sql);
			SQLQuery sqlQuery = null;
			// if("web".equalsIgnoreCase(ds))
			sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list", "AiomniDB");
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
			String result = FusionChartHelper.chartNormal(list, options);
			request.setAttribute("result", result);
			request.getRequestDispatcher("/hbapp/resources/old/translateData.jsp").forward(request, response);
		}
	}

	public void chargeAlert(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String date1 = request.getParameter("date1");
		String date2 = request.getParameter("date2");
		String zbCode = request.getParameter("zbCode");
		String area = request.getParameter("area");
		String condition = "";
		if ("K10002".equalsIgnoreCase(zbCode))
			condition += "and charge_type in ('LOCAL','TOLL','ROAM','IP')";
		if (!"0".equalsIgnoreCase(area))
			condition += " and channel_code like '" + area + "%'";

		String sql = "select substr(time_id,7,2)" + ",'本月',value(decimal(sum(case when substr(time_id,5,2)=substr('@date1',5,2) then value end),16,2)/10000,0)" + ",'上月同期',value(decimal(sum(case when substr(time_id,5,2)=substr('@date2',5,2) then value end),16,2)/10000,0) "
				+ "from nmk.kpi_wave_daily where (time_id between substr('@date1',1,6)||'01' and '@date1' or time_id between substr('@date2',1,6)||'01' and '@date2') and ZB_CODE='" + zbCode + "' " + condition + "  group by substr(time_id,7,2) with ur";
		sql = sql.replaceAll("@date1", date1).replaceAll("@date2", date2);
		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
		List list = (List) sqlQuery.query(sql);

		FusionChartHelper.Options options = new FusionChartHelper.Options();
		options.setCaption("");
		String result = FusionChartHelper.chartMultiCol(list, options);
		request.setAttribute("result", result);
		request.getRequestDispatcher("/hbapp/resources/old/translateData.jsp").forward(request, response);
	}

	@ActionMethod(isLog = false)
	public void chargeForecast(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String[] sqls = chargeForecastSQL();
		String currentyyyyMM = sqls[3];
		String type = request.getParameter("type");
		if ("grid".equalsIgnoreCase(type)) {
			String sqlStr = sqls[0].toString().replaceAll("@col1@", "substr(time_id,1,6)").replaceAll("@col2@", currentyyyyMM);
			response.getWriter().print(sqlStr);
		} else if ("chart".equalsIgnoreCase(type)) {
			String sqlStr = sqls[0].toString().replaceAll("@col1@", "substr(time_id,3,4),'收入(万元)'").replaceAll("@col2@", currentyyyyMM.substring(2, 6) + "','收入(万元)");
			SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
			List list = (List) sqlQuery.query(sqlStr);

			FusionChartHelper.Options options = new FusionChartHelper.Options();
			options.setCaption("");
			String result = FusionChartHelper.chartMultiCol(list, options);
			request.setAttribute("result", result);
			request.getRequestDispatcher("/hbapp/resources/old/translateData.jsp").forward(request, response);
		} else if ("city".equalsIgnoreCase(type)) {
			response.getWriter().print("{\"date\": \"" + currentyyyyMM.substring(0, 6) + "\",\"sql\":\"" + sqls[1] + "\"}");
		}
	}

	@ActionMethod(isLog = false)
	public static String[] chargeForecastSQL() {

		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		Calendar cal = GregorianCalendar.getInstance();
		int lastDate = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		if (lastDate == cal.get(Calendar.DATE)) {
			SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
			List list = (List) sqlQuery.query("select 1 from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id='" + (sdf.format(cal.getTime()) + (lastDate - 1)) + "' with ur");

			if (list.size() == 0) {
				cal.add(Calendar.MONTH, -1);
			}
		} else {
			cal.add(Calendar.MONTH, -1);
		}

		StringBuilder sb1 = new StringBuilder();
		StringBuilder sb2 = new StringBuilder();
		StringBuilder sb = new StringBuilder();

		lastDate = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		String currentyyyyMM = sdf.format(cal.getTime()) + (lastDate - 1);
		String yearStr = String.valueOf(cal.get(Calendar.YEAR));
		String preyyyyMM = "";
		for (int i = 0; i < 12; i++) {
			cal.add(Calendar.MONTH, -1);
			lastDate = cal.getActualMaximum(Calendar.DAY_OF_MONTH);

			String yyyyMM = sdf.format(cal.getTime());
			if (i == 0)
				preyyyyMM = yyyyMM + lastDate;
			if (sb1.length() > 0)
				sb1.append(",");
			sb1.append("'").append(yyyyMM + lastDate).append("'");

			if (yyyyMM.startsWith(yearStr)) {
				if (sb.length() > 0)
					sb.append(",");
				sb.append("'").append(yyyyMM + lastDate).append("'");
			}
			if (sb2.length() > 0)
				sb2.append(",");
			sb2.append("'").append(yyyyMM + (lastDate - 1)).append("'");
		}
		StringBuilder sql = new StringBuilder("select @col1@,decimal(sum(value),16,2)/10000 from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id in (");
		sql.append(sb.length() == 0 ? "''" : sb.toString());
		sql.append(")  group by time_id ");

		StringBuilder sb3 = new StringBuilder("select '@col2@',decimal(t1.va,16,2)/t2.va*t3.va/10000 from ");
		sb3.append("(select sum(value) va from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id in (");
		sb3.append(sb1.toString()).append("))t1");

		sb3.append(",(select sum(value) va from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id in (");
		sb3.append(sb2.toString()).append("))t2");
		sb3.append(",(select value va from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id='");
		sb3.append(currentyyyyMM).append("' ) t3 ");

		sql.append(" union all ").append(sb3).append(" order by 1 with ur");

		String sqlStr = sql.toString();// .replaceAll("@col1@",
										// "substr(time_id,1,6)").replaceAll("@col2@",
										// currentyyyyMM);

		LOG.info(sqlStr);

		StringBuilder sql2 = new StringBuilder();

		sql2.append("select (select area_name from mk.bt_area where area_code=t1.channel_code),decimal(t1.va,16,4)*decimal(t2.va,16,4)/decimal(t3.va,16,4)/10000 ,t4.va/10000 from (select channel_code,value va from  kpi_total_daily where zb_code='K10001' and time_id ='").append(currentyyyyMM)
				.append("' and parent_channel_code='HB') t1,").append("(select channel_code,sum(value) va from kpi_total_daily where zb_code='K10001' and time_id in (").append(sb1.toString()).append(") and parent_channel_code='HB' group by channel_code) t2,")
				.append("(select channel_code,sum(value) va from kpi_total_daily where zb_code='K10001' and time_id in (").append(sb2.toString()).append(") and parent_channel_code='HB' group by channel_code) t3, ")
				.append("(select channel_code,sum(value) va from kpi_total_daily where zb_code='K10001' and time_id ='").append(preyyyyMM).append("' and parent_channel_code='HB' group by channel_code) t4 ")
				.append(" where t1.channel_code=t2.channel_code and t2.channel_code=t3.channel_code and t4.channel_code=t3.channel_code  order by 2 desc with ur");

		LOG.info(sql2);

		String sql3 = sb3.toString().replaceAll("@col2@", currentyyyyMM);
		LOG.info(sql3);

		return new String[] { sqlStr, sql2.toString(), sql3, currentyyyyMM };
	}

	/**
	 * 市场运营信息快报导入
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void omDailyImport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		try {

			String content = request.getParameter("content");
			// if(content!=null)content = new
			// String(content.getBytes("iso-8859-1"),"utf-8");
			int maxsize = 4000;
			String timeid = request.getParameter("time_id");
			String[] contents = new String[content.length() / maxsize + 1];

			for (int i = 0; i < contents.length; i++) {
				contents[i] = content.substring(i * maxsize, ((i + 1) * maxsize > content.length() ? content.length() : (i + 1) * maxsize));
			}

			conn = ConnectionManage.getInstance().getWEBConnection();

			Statement stat = conn.createStatement();
			stat.execute("delete from FPF_OM_MMSREPORT where time_id='" + timeid + "'");
			stat.close();

			String sql = "insert into FPF_OM_MMSREPORT(time_id,content) values(?,?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			for (int i = 0; i < contents.length; i++) {
				ps.setString(1, timeid);
				ps.setString(2, contents[i]);
				ps.execute();
			}
			ps.close();

		} catch (SQLException e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}

	}

	public static void main(String[] args) {
		System.out.println(chargeForecastSQL());
	}
}
