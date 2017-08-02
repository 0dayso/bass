package com.asiainfo.hb.bass.custome.report.dao;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.bass.custome.report.models.ComboboxBean;
import com.asiainfo.hb.bass.custome.report.models.CustomReport;
import com.asiainfo.hb.bass.custome.report.models.CustomReportMap;
import com.asiainfo.hb.bass.custome.report.models.ReportInfo;
import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.core.models.JdbcTemplate;


/**
 * 自定义报表DAO操作
 * 
 * @author King-Pan
 *
 */
@Repository
public class CustomReportDaoImpl implements CustomReportDao {

	private static Logger LOG = Logger.getLogger(CustomReportDaoImpl.class);

	private JdbcTemplate jdbcTemplate;
	
	private NamedParameterJdbcTemplate jdbcTemplateN;

	public NamedParameterJdbcTemplate getJdbcTemplateN() {
		return jdbcTemplateN;
	}
	@Autowired
	public void setJdbcTemplateN(NamedParameterJdbcTemplate jdbcTemplateN) {
		this.jdbcTemplateN = jdbcTemplateN;
	}

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	@Override
	public List<ComboboxBean> getCategorys() {
		String sql = "select distinct category id,category text from st.boc_indicator_menu order by category";
		List<ComboboxBean> categorys = jdbcTemplate.query(sql,
				new BeanPropertyRowMapper<ComboboxBean>(ComboboxBean.class));
		return categorys;
	}

	@Override
	public Map<String, Object> getReportPageList(int page, int rows, String userId) {
		Map<String, Object> result = new HashMap<String, Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		String sql = "select report_id reportId,report_name reportName,report_desc reportDesc,user_id userId from fpf_irs_cusmtom_report t where t.user_id=? ";
		String totalPage = "select count(*) from ( " + sql + " ) ";
		String totalRows = sqlPageHelper.getLimitSQL(sql, rows, (page - 1) * rows, "reportId");
		result.put("total", jdbcTemplate.queryForObject(totalPage, new Object[] { userId }, Integer.class));
		List<CustomReport> reports = jdbcTemplate.query(totalRows,
				new BeanPropertyRowMapper<CustomReport>(CustomReport.class), new Object[] { userId });
		result.put("rows", reports);
		LOG.info("the page result: " + result);
		return result;
	}

	@Override
	public void deleteCustomReport(String userId, String reportId) {
		String sql = "delete from fpf_irs_cusmtom_report t where t.user_id=? and report_id=?";
		jdbcTemplate.update(sql, new Object[] { userId, reportId });
	}

	@Override
	public void deleteCustomReportMap(String reportId) {
		String sql = "delete from fpf_irs_cusmtom_report_map t where report_id=?";
		jdbcTemplate.update(sql, new Object[] { reportId });
	}

	@Override
	public void saveCustomReport(CustomReport report) {
		jdbcTemplate.update("insert into fpf_irs_cusmtom_report values(?,?,?,?)", new Object[] { report.getReportId(),
				report.getReportName(), report.getReportDesc(), report.getUserId() });
	}

	@Override
	public void saveCustomReportMap(List<Object[]> listArgs) {
		jdbcTemplate.batchUpdate("insert into fpf_irs_cusmtom_report_map values(?,?,?,?)", listArgs);
	}

	@Override
	public void updateCustomReport(CustomReport report) {
		String sql = "update fpf_irs_cusmtom_report set report_name=? ,report_desc=? where report_id=?";
		jdbcTemplate.update(sql, new Object[] { report.getReportName(), report.getReportDesc(), report.getReportId() });
	}

	@Override
	public List<CustomReportMap> querySelectReport(String reportId) {
		String sql = "select menu.name as id,report_id reportId,indicator_menu_id indicatorMenuId,kpi_code kpiCode from st.fpf_irs_cusmtom_report_map map,st.boc_indicator_menu menu where map.indicator_menu_id =menu.id and report_id=?";
		return jdbcTemplate.query(sql, new BeanPropertyRowMapper<CustomReportMap>(CustomReportMap.class),
				new Object[] { reportId });
	}

	@Override
	public List<Map<String, Object>> getReportTypeList(String codeType, String category, String menuIds) {
		String sql = "";
		Object[] args = new Object[] { category };
		if (codeType.equals("daily_code")) {// 日指标
			sql += "select id,name text,daily_code kpiCode from st.boc_indicator_menu where  length(daily_code)>0 and ";
		} else if (codeType.equals("daily_cumulate_code")) {// 日累计指标
			sql += "select id,name text,daily_cumulate_code kpiCode from st.boc_indicator_menu where  length(daily_cumulate_code)>0 and ";
		} else if (codeType.equals("monthly_code")) {// 月指标
			sql += "select id,name text,monthly_code kpiCode from st.boc_indicator_menu where  length(monthly_code)>0 and ";
		} else if (codeType.equals("monthly_cumulate_code")) {// 月累计指标
			sql += "select id,name text,monthly_cumulate_code kpiCode from st.boc_indicator_menu where  length(monthly_cumulate_code)>0 and ";
		} else {
			sql += "select id,name text,daily_code kpiCode from st.boc_indicator_menu where ";
		}
		sql += " category = ?";

		if (StringUtils.isNotBlank(menuIds)) {
			sql += " and id not in(";
			String[] ids = menuIds.split(",");
			args = new Object[ids.length + 1];
			args[0] = category;
			for (int i = 0; i < ids.length; i++) {
				sql += "?,";
				args[i + 1] = ids[i];
			}
			sql = sql.substring(0, sql.length() - 1);
			sql += ")";
		}

		LOG.info("sql---->" + sql + ",args=" + Arrays.toString(args));

		return jdbcTemplate.queryForList(sql, args);
	}

	@Override
	public List<Map<String, Object>> getIndicatorMenus() {
		return jdbcTemplate.queryForList("select t.iD ,t.name from BOC_INDICATOR_MENU t");
	}

	@Override
	public List<ReportInfo> getReportList(String reportId) {
		String sql = "select m.REPORT_ID reportId,t.ID menuId,t.NAME menuName,'' type, m.KPI_CODE kpiCode from ST.BOC_INDICATOR_MENU t ,st.FPF_IRS_CUSMTOM_REPORT_map m where t.ID = m.INDICATOR_MENU_ID and m.REPORT_ID= ?";
		List<ReportInfo> reports = jdbcTemplate.query(sql, new BeanPropertyRowMapper<ReportInfo>(ReportInfo.class),
				new Object[] { reportId });
		return reports;
	}

	@Override
	public List<Map<String, Object>> getCountyList(String areaCode) {
		String sql = "select county_id id,county_name name from st.DIM_PUB_COUNTY ";
		if (areaCode.equals("HB")) {
			return jdbcTemplate.queryForList(sql);
		}
		sql += " where city_id =?";
		return jdbcTemplate.queryForList(sql, new Object[] { areaCode });
	}

	@Override
	public String getDaylyDate(String kpiCode) {
		String sql = "select max(op_time) from KPI_COMP_CD005_D_VERTICAL where kpi_code =?";
		return jdbcTemplate.queryForObject(sql, String.class, new Object[] { kpiCode });
	}

	@Override
	public String getMonthlyDate(String kpiCode) {
		String sql = "select max(op_time) from KPI_COMP_CD005_M_VERTICAL where kpi_code =?";
		return jdbcTemplate.queryForObject(sql, String.class, new Object[] { kpiCode });
	}

	@Override
	public List<Map<String, Object>> getCityList() {
		String sql = "select city_id id,city_name name from st.DIM_PUB_CITY t order by AREA_CODE";
		return jdbcTemplate.queryForList(sql);
	}

	@Override
	public Map<String, Object> getReportQueryDate(int page, int rows, String sql, Map<String, Object> parameters) {
		LOG.info("<==========================================>");
		LOG.info("<=========>sql->"+sql);
		LOG.info("<=========>page->"+page);
		LOG.info("<=========>rows->"+rows);
		LOG.info("<=========>parameters->"+parameters);
		Map<String, Object> result = new HashMap<String, Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		String totalPage = "select count(*) from ( " + sql + " ) ";
		LOG.info("<=========>totalPage->"+totalPage);
		String totalRows = sqlPageHelper.getLimitSQL(sql, rows, (page - 1) * rows, "dim_val");
		LOG.info("<=========>totalRows->"+totalRows);
		
		result.put("total", jdbcTemplateN.queryForObject(totalPage, parameters, Integer.class));
		List<Map<String, Object>> reports = jdbcTemplateN.queryForList(totalRows, parameters);
		result.put("rows", reports);
		LOG.info("the page result: " + result);
		LOG.info("<==========================================>");
		return result;
	}

}
