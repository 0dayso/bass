package com.asiainfo.hb.bass.report.maintenance.dao;

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

import com.asiainfo.hb.bass.report.maintenance.models.ReportMaintenance;
import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.util.IdGen;

@Repository
public class ReportMaintenanceDaoImpl implements ReportMaintenanceDao {

	private static Logger LOG = Logger.getLogger(ReportMaintenanceDaoImpl.class);

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
	public void save(ReportMaintenance maintenance) {
		String sql = "INSERT INTO fpf_report_maintenance (ID, REPORT_ID, REPORT_NAME,procedure_name, DEVELOPER_NAME, MANAGER, LEVEL, ONLINE, MAINTENANCE,expectation_date) "
				+ "VALUES (:id, :reportId, :reportName,:procedureName,:developerName ,:manager,:level,:online, :maintenance,:expectationDate)";
		jdbcTemplateN.update(sql, objectToMap(maintenance));
	}

	private Map<String, String> objectToMap(ReportMaintenance maintenance) {
		Map<String, String> map = new HashMap<String, String>();
		if (maintenance == null) {
			throw new RuntimeException("ReportMaintenance not allow null.");
		}
		if (StringUtils.isNotBlank(maintenance.getId())) {
			map.put("id", maintenance.getId());
		} else {
			map.put("id", IdGen.genId());
		}
		if (StringUtils.isNotBlank(maintenance.getReportId())) {
			map.put("reportId", maintenance.getReportId());
		}

		if (StringUtils.isNotBlank(maintenance.getReportName())) {
			map.put("reportName", maintenance.getReportName());
		}
		if (StringUtils.isNotBlank(maintenance.getProcedureName())) {
			map.put("procedureName", maintenance.getProcedureName());
		}
		if (StringUtils.isNotBlank(maintenance.getDeveloperName())) {
			map.put("developerName", maintenance.getDeveloperName());
		}
		if (StringUtils.isNotBlank(maintenance.getManager())) {
			map.put("manager", maintenance.getManager());
		}
		if (StringUtils.isNotBlank(maintenance.getLevelVal())) {
			map.put("level", maintenance.getLevelVal());
		}

		if (StringUtils.isNotBlank(maintenance.getOnlineVal())) {
			map.put("online", maintenance.getOnlineVal());
		}

		if (StringUtils.isNotBlank(maintenance.getMaintenanceVal())) {
			map.put("maintenance", maintenance.getMaintenanceVal());
		}
		
		if (StringUtils.isNotBlank(maintenance.getExpectationDate())) {
			map.put("expectationDate", maintenance.getExpectationDate());
		}
		/*
		if (StringUtils.isNotBlank(maintenance.getActualDate())) {
			map.put("actualDate", maintenance.getActualDate());
		}*/

		return map;
	}

	@Override
	public void delete(String id) {
		String sql = "delete from fpf_report_maintenance where id = ?";
		jdbcTemplate.update(sql, new Object[] { id });

	}

	@Override
	public void update(ReportMaintenance maintenance) {
		String sql = "update fpf_report_maintenance  set REPORT_ID = :reportId, REPORT_NAME = :reportName,procedure_name = :procedureName,"
				+ " DEVELOPER_NAME = :developerName ,MANAGER = :manager,LEVEL = :level,ONLINE = :online, MAINTENANCE = :maintenance,expectation_date = :expectationDate "
				+ " where id = :id";
		jdbcTemplateN.update(sql, objectToMap(maintenance));
	}

	@Override
	public Map<String, Object> getReportPageList(int page, int rows, ReportMaintenance maintenance) {
		Map<String, Object> result = new HashMap<String, Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		String sql = "select ID id," + "	 REPORT_ID reportId," + "	 REPORT_NAME reportName,"
				+ "	 procedure_name procedureName," + "	 DEVELOPER_NAME developerName," + "	 MANAGER manager,"
				+ "	 decode(LEVEL,'0','低','1','中','2','高','其他级别') level, " + "	 LEVEL levelVal, "
				+ "  expectation_date as expectationDate,"
				+ "  actual_date actualDate,"
				+ "	 decode(ONLINE,'0','未上线','1','上线','2','下线','其他状态') online," + "	 ONLINE onlineVal, "
				+ "	 decode(MAINTENANCE,'0','未交维','1','已交维','其他状态') maintenance," + "	 MAINTENANCE maintenanceVal, "
				+ " expectation_date expectationDate"
				+ "    from   fpf_report_maintenance where 1 = 1 ";
	
		Map<String, String> map = objectToMap(maintenance);
		if (map.containsKey("reportId")) {
			sql += " and report_id like :reportId ";
			map.put("reportId", "%" + map.get("reportId") + "%");
		}
		if (map.containsKey("reportName")) {
			sql += " and report_name like :reportName ";
			map.put("reportName", "%" + map.get("reportName") + "%");
		}
		if (map.containsKey("procedureName")) {
			sql += " and procedure_Name like :procedureName ";
			map.put("procedureName", "%" + map.get("procedureName") + "%");
		}
		if (map.containsKey("developerName")) {
			sql += " and developer_Name like :developerName ";
			map.put("developerName", "%" + map.get("developerName") + "%");
		}
		if (map.containsKey("manager")) {
			sql += " and manager like :manager ";
			map.put("manager", "%" + map.get("manager") + "%");
		}
		if (map.containsKey("level")) {
			sql += " and level like :level ";
			map.put("level", "%" + map.get("level") + "%");
		}
		if (map.containsKey("online")) {
			sql += " and online like :online ";
			map.put("online", "%" + map.get("online") + "%");
		}
		if (map.containsKey("maintenance")) {
			sql += " and maintenance like :maintenance ";
			map.put("maintenance", "%" + map.get("maintenance") + "%");
		}

		String totalPage = "select count(*) from ( " + sql + " ) ";
		String totalRows = sqlPageHelper.getLimitSQL(sql, rows, (page - 1) * rows, "id");
		result.put("total", jdbcTemplateN.queryForObject(totalPage, map, Integer.class));
		List<ReportMaintenance> maintenances = jdbcTemplateN.query(totalRows, map, new BeanPropertyRowMapper<ReportMaintenance>(ReportMaintenance.class));
		result.put("rows", maintenances);
		LOG.info("the page result: " + result);
		return result;
	}

}
