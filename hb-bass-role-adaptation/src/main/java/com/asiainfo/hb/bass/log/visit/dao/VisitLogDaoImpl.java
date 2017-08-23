package com.asiainfo.hb.bass.log.visit.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.bass.custome.report.dao.CustomReportDaoImpl;
import com.asiainfo.hb.bass.log.visit.models.VisitInfo;
import com.asiainfo.hb.core.datastore.Db2SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.models.JdbcTemplate;

@Repository
public class VisitLogDaoImpl implements VisitLogDao {
	
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
	public Map<String, Object> getPageList(Integer page, Integer rows,Map<String,Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		SqlPageHelper sqlPageHelper = new Db2SqlPageHelper();
		List<Object> args = new ArrayList<>();
		StringBuffer sqlBuf = new StringBuffer();
		sqlBuf.append("select area_id,areaName,count(1) times,	 count(distinct loginname) count from ( ");
		sqlBuf.append("SELECT a.areaName areaName,v.area_id area_id,LOGINNAME loginname,CREATE_DT create_date FROM ");
		sqlBuf.append("area a,fpf_visitlist v WHERE a.AREA_ID=v.AREA_ID AND v.CREATE_DT IS NOT null) where 1=1 ");
		String whereSql = "";
		if(params.containsKey("areaId")) {
			whereSql +=" AND AREA_ID=? ";
			args.add(params.get("areaId"));
		}
		if(params.containsKey("startDate")) {
			whereSql +=" AND create_date >= timestamp(?) ";
			args.add(params.get("startDate"));
		}
		if(params.containsKey("endDate")) {
			whereSql +=" AND create_date < timestamp(?) ";
			args.add(params.get("endDate"));
		}
		sqlBuf.append(whereSql).append(" GROUP BY areaName,area_id ");
		
		String sql = sqlBuf.toString();
		String totalPage = "select count(*) from ( " + sql + " ) ";
		String totalRows = sqlPageHelper.getLimitSQL(sql, rows, (page - 1) * rows, "area_id");
		
		result.put("total", jdbcTemplate.queryForObject(totalPage, args.toArray(), Integer.class));
		List<VisitInfo> reports = jdbcTemplate.query(totalRows,
				new BeanPropertyRowMapper<VisitInfo>(VisitInfo.class), args.toArray());
		result.put("rows", reports);
		LOG.debug("the page result: " + result);
		LOG.debug("totalPage: " + totalPage);
		LOG.debug("totalRows: " + totalRows);
		return result;
	}

	@Override
	public List<Map<String, Object>> getCityList() {
		String sql = "select '-1' id,'-1' code ,'请选择地市' name from sysibm.sysdummy1  union all ";
		sql += "select area_id id,areacode code,areaname name from st.area t order by id with ur";
		return jdbcTemplate.queryForList(sql);
	}

}
