package com.asiainfo.hb.bass.data.model;

import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.asiainfo.hb.bass.data.service.KpiService;
import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.util.DateUtil;
import com.asiainfo.hb.core.util.LogUtil;
import com.asiainfo.hb.web.models.User;

/**
 * KPI数据访问对象
 * 
 * @author 李志坚
 * @since 2017-03-05
 */
@SuppressWarnings("unused")
@Repository
public class KpiDao implements KpiService {

	public Logger logger = LoggerFactory.getLogger(KpiDao.class);

	private JdbcTemplate jdbcTemplate;

	@SuppressWarnings("all")
	@Autowired
	private void setJdbcTemplate(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	private static final String DATATABLENAME_PREFIX = "KPI_COMP_";

	/**
	 * 指标定义加载sql
	 */
	private static final String KPIDEFAll = "select c.*, value(formula, '1') formula, value(formula_unit, '') formula_unit, value(kpi_format, '###,###.00') kpi_format from (select a.kpi_code, a.kpi_name, b.kpi_unit, a.logic_kpicode, a.kpi_type, a.cycle, a.compdimcode, a.kpi_scope_code, a.kpi_sql, a.priority, a.state, a.start_dt, a.end_dt, dbname, a.kpi_des, a.remark, value(a.version, 'v1.0') version, a.create_user, a.create_time, a.update_user, a.update_time from kpi_def a left join kpi_logic_def b on a.logic_kpicode = b.logic_kpicode) c left join kpi_def_visit d on c.kpi_code = d.kpi_code ";

	/**
	 * 获取现行kpi的组合维度
	 */
	private static final String KPI_COMP_DIM_SQL = "select compdimcode, compdimname, a.dimcode,dimname,columecode,parentcode,columevalue,colvaltype from kpi_comp_dim a,KPI_SIMPLE_DIM_VERTICAL b where a.dimcode=b.dimcode and compdimcode = '?' order by compdimcode,a.dimcode,parentcode";

	/**
	 * 获取全部指标定义
	 */
	public List<KpiDef> getDefAll() throws Exception {
		logger.debug("所有定义的指标信息：" + KPIDEFAll);
		return jdbcTemplate.query(KPIDEFAll, new KpiDefQuery());
	}

	private static final class KpiDefQuery implements RowMapper<KpiDef> {
		@Override
		public KpiDef mapRow(ResultSet rs, int rowNum) throws SQLException {
			KpiDef kpiDef = new KpiDef();
			kpiDef.setKpiId(rs.getString("KPI_CODE"));
			kpiDef.setKpiName(rs.getString("KPI_NAME"));
			kpiDef.setKpiUnit(rs.getString("KPI_UNIT"));
			kpiDef.setLogicId(rs.getString("LOGIC_KPICODE"));
			kpiDef.setKpidefType(rs.getString("KPI_TYPE"));
			kpiDef.setCycle(rs.getString("CYCLE"));
			kpiDef.setCompdimId(rs.getString("COMPDIMCODE"));
			kpiDef.setKpiScopeId(rs.getString("KPI_SCOPE_CODE"));
			kpiDef.setKpiSql(rs.getString("KPI_SQL"));
			kpiDef.setState(rs.getString("STATE"));
			kpiDef.setStart_dt(rs.getTimestamp("START_DT"));
			kpiDef.setEnd_dt(rs.getTimestamp("END_DT"));
			kpiDef.setDbname(rs.getString("DBNAME"));
			kpiDef.setKpiDes(rs.getString("KPI_DES"));
			kpiDef.setRemark(rs.getString("REMARK"));
			kpiDef.setVersion(rs.getString("VERSION"));
			kpiDef.setCreater(rs.getString("CREATE_USER"));
			kpiDef.setCreate_dt(rs.getTimestamp("CREATE_TIME"));
			kpiDef.setUpdater(rs.getString("UPDATE_USER"));
			kpiDef.setUpdate_dt(rs.getTimestamp("UPDATE_TIME"));
			kpiDef.setFormula(rs.getString("FORMULA"));
			kpiDef.setFormatValue(rs.getString("KPI_FORMAT"));
			kpiDef.setFormulaUnit(rs.getString("FORMULA_UNIT"));
			StringBuffer dataTableName = new StringBuffer("");
			dataTableName.append(DATATABLENAME_PREFIX + rs.getString("COMPDIMCODE"));
			if (kpiDef.getCycle() != null && ("A".equalsIgnoreCase(kpiDef.getCycle()) || "D".equalsIgnoreCase(kpiDef.getCycle()))) {
				dataTableName.append("_D_VERTICAL");
			} else if (null != kpiDef.getCycle() && ("M".equalsIgnoreCase(kpiDef.getCycle()) || "Y".equalsIgnoreCase(kpiDef.getCycle()))) {
				dataTableName.append("_M_VERTICAL");
			}
			kpiDef.setDataTableName(dataTableName.toString());
			return kpiDef;
		}
	}

	/**
	 * 获取单个指标定义
	 */
	public KpiDef getKpiDefById(String kpiId) throws Exception {
		String sql = KPIDEFAll + " where c.kpi_code='" + kpiId + "'";
		logger.debug("getKpiDefById的SQL：" + sql);
		List<KpiDef> kpiDefList = jdbcTemplate.query(sql, new KpiDefQuery());
		if (kpiDefList != null && kpiDefList.size() > 0) {
			KpiDef kpiDef = kpiDefList.get(0);
			return kpiDef;
		} else {
			return null;
		}
	}

	/**
	 * 根据组合维度代码，查询组合维度列表
	 */
	public List<DimCompDef> getKpiDim(String compDimCode) throws Exception {
		List<DimCompDef> dimCompDefList = new ArrayList<DimCompDef>();
		String sql = KPI_COMP_DIM_SQL.replace("?", compDimCode);
		List<Map<String, Object>> resultList = jdbcTemplate.queryForList(sql);
		for (Map<String, Object> map : resultList) {
			DimCompDef dimCompDef = new DimCompDef();
			dimCompDef.setCompDimCode((String) map.get("COMPDIMCODE"));
			dimCompDef.setCompDimName((String) map.get("COMPDIMNAME"));
			dimCompDef.setDimCode((String) map.get("DIMCODE"));
			dimCompDef.setDimName((String) map.get("DIMNAME"));
			dimCompDef.setColumeCode((String) map.get("COLUMECODE"));
			dimCompDef.setParentCode((String) map.get("PARENTCODE"));
			dimCompDef.setColumeValue((String) map.get("COLUMEVALUE"));
			dimCompDef.setColValType((String) map.get("COLVALTYPE"));
			dimCompDefList.add(dimCompDef);
		}
		return dimCompDefList;
	}

	@Override
	public List<Kpi> getKpiByIndicatorMenuId(String indicatorMenuId, String opTime, String reqDimCode, String reqDimVal) throws Exception {
		if (StringUtils.isEmpty(indicatorMenuId)) {
			return null;
		}
		String dateType = "";
		if (opTime != null) {
			opTime = opTime.replaceAll("-", "");
			opTime = opTime.replaceAll("_", "");
			opTime = opTime.replaceAll("/", "");
		} else {
			throw new Exception("日期不能为空");
		}
		if (opTime.length() == 6) {
			dateType = "M";
		} else if (opTime.length() == 8) {
			dateType = "D";
		} else {
			throw new Exception("日期格式不正确");
		}
		BocIndicatorMenu menu = getBocIndicatorMenuById(indicatorMenuId);
		if (menu == null) {
			return null;
		}
		String dailyCode = menu.getDailyCode();
		String dailyCumulateCode = menu.getDailyCumulateCode();
		String monthlyCode = menu.getMonthlyCode();
		String monthlyCumulateCode = menu.getMonthlyCumulateCode();

		if (dateType.equals("D")) {
			List<Kpi> dailyList = getKpiData(indicatorMenuId, dailyCode, dailyCumulateCode, opTime, reqDimCode, reqDimVal);
			return dailyList;
		} else if (dateType.equals("M")) {
			List<Kpi> monthlyList = getKpiData(indicatorMenuId, monthlyCode, monthlyCumulateCode, opTime, reqDimCode, reqDimVal);
			return monthlyList;
		}
		return null;
	}
	
	/**
	 * 向数据库中添加查询信息的方法
	 * 
	 * 
	 */
	@Override
	public void insertKpiLog(String id, String kpicode, String date, String user) {
		String sql = "select kpi_code,kpi_name,category from BOC_INDICATOR_MENU,kpi_def where kpi_code='" + kpicode + "' and id=" + id + "";
		List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);
		for (Map<String, Object> m : list) {
			String sql1 = "insert into fpf_kpi_visit (kpi_code,kpi_name,kpi_category,user_name,visit_time) values('" + m.get("kpi_code") + "','" + m.get("kpi_name") + "','" + m.get("category") + "','" + user + "','" + date + "')";
			jdbcTemplate.update(sql1);
		}
	}
	
	/**
	 * 查询KPI数据
	 * 
	 * @param menuId
	 * @param kpiCode
	 * @param kpiCumulateCode
	 * @param opTime
	 * @param reqDimCode
	 * @param reqDimVal
	 * @return
	 * @throws Exception
	 */
	public List<Kpi> getKpiData(String menuId, String kpiCode, String kpiCumulateCode, String opTime, String reqDimCode, String reqDimVal) throws Exception {
		if (StringUtils.isEmpty(menuId)) {
			logger.error("指标menuId:" + menuId + "为空");
			return null;
		}
		if (StringUtils.isEmpty(kpiCode) && StringUtils.isEmpty(kpiCumulateCode)) {
			logger.error("kpiCode:" + kpiCode + "为空" + "，并且kpiCumulateCode:" + kpiCumulateCode + "也为空");
			// return null;
		}
		List<Kpi> kpiList = new ArrayList<Kpi>();
		String dateType = "";
		if (opTime != null) {
			opTime = opTime.replaceAll("-", "");
			opTime = opTime.replaceAll("_", "");
			opTime = opTime.replaceAll("/", "");
		} else {
			throw new Exception("日期不能为空");
		}
		if (opTime.length() == 6) {
			dateType = "M";
		} else if (opTime.length() == 8) {
			dateType = "D";
		} else {
			throw new Exception("日期格式不正确");
		}
		String sql = "";
		try {
			if (reqDimCode != null && reqDimCode.length() > 0 && null != opTime && (opTime.length() == 6 || opTime.length() == 8)) {
				// 查指标
				KpiDef kpiDef = getKpiDefById(kpiCode);
				// 如果指标代码没有配置，则查累计指标
				if (kpiDef == null) {
					kpiDef = getKpiDefById(kpiCumulateCode);
				}
				List<DimCompDef> dimList = null;
				DimCompDef reqDim = null;
				if (kpiDef != null && kpiDef.getDataTableName() != null) {
					dimList = getKpiDim(kpiDef.getCompdimId());
					reqDim = getDimByDimCode(dimList, reqDimCode);
					// 默认两级
					StringBuffer sbf = new StringBuffer("select * from (");
					sbf.append(getJoinSql(menuId, kpiDef, opTime, dimList, reqDim, reqDimCode, reqDimVal, 0));// 当前级维度
					sbf.append(" union all ");
					sbf.append(getJoinSql(menuId, kpiDef, opTime, dimList, reqDim, reqDimCode, reqDimVal, 1));// 下一级维度
					sbf.append(")");
					sbf.append(" order by dim_val,kpi_code,a_kpi_code with ur ");
					sql = sbf.toString();
				} else if (kpiDef == null) {
					logger.error("kpiDef为空");
					return null;
				} else if (kpiDef != null && kpiDef.getDataTableName() == null) {
					logger.error(kpiCode + "的kpiDef.getDataTableName()的结果为空");
					return null;
				}
			} else {
				logger.debug("传入的以下参数不正确：kpicode:" + kpiCode + "，日期：" + opTime + "，维度类型：" + reqDimCode + "，维度值：" + reqDimVal);
			}
			if (sql != null && sql.trim().length() > 0) {
				logger.debug("KPI查询时的SQL为：" + sql);
				Kpi sqlE = new Kpi();
				sqlE.setSql(sql);
				kpiList.add(sqlE);
				List<Map<String, Object>> resultList = jdbcTemplate.queryForList(sql);
				for (Map<String, Object> map : resultList) {
					Kpi kpi = new Kpi();
					kpi.setMenuId(menuId);
					kpi.setKpiCode((String) map.get("KPI_CODE"));
					kpi.setAccumulationKpiCode((String) map.get("A_KPI_CODE"));
					kpi.setKpiName((String) map.get("KPI_NAME"));
					kpi.setKpiUnit((String) map.get("KPI_UNIT"));
					kpi.setOpTime(String.valueOf(map.get("OP_TIME")));
					kpi.setDimCode((String) map.get("DIM_CODE"));
					kpi.setDimVal((String) map.get("DIM_VAL"));
					kpi.setRegionName((String) map.get("REGION_NAME"));
					if (dateType.equals("D")) {
						kpi.setDailyCurrent((BigDecimal) map.get("CURRENT"));
						kpi.setDailyComparedYesterday((BigDecimal) map.get("comparedYesterday"));
						kpi.setDailyComparedLastMonth((BigDecimal) map.get("comparedLastMonth"));
						kpi.setDailyAccumulation((BigDecimal) map.get("A_CURRENT"));
						kpi.setDailyAccumulationComparedLastMonth((BigDecimal) map.get("a_comparedLastMonth"));
						kpi.setDailyAccumulationComparedLastYear((BigDecimal) map.get("a_comparedLastYear"));
					}
					if (dateType.equals("M")) {
						kpi.setMonthlyCurrent((BigDecimal) map.get("CURRENT"));
						kpi.setMonthlyComparedLastMonth((BigDecimal) map.get("comparedLastMonth"));
						kpi.setMonthlyComparedLastYear((BigDecimal) map.get("comparedLastYear"));
						kpi.setMonthlyAccumulation((BigDecimal) map.get("A_CURRENT"));
						kpi.setMonthlyAccumulationComparedLastMonth((BigDecimal) map.get("a_comparedLastMonth"));
						kpi.setMonthlyAccumulationComparedLastYear((BigDecimal) map.get("a_comparedLastYear"));
					}
					kpi.setLevel(map.get("LEVEL") == null ? 0 : Integer.valueOf(map.get("LEVEL").toString()));
					kpiList.add(kpi);
				}
			}
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
		}
		return kpiList;
	}

	/**
	 * 组装SQL
	 * 
	 * @param def
	 * @param opTime
	 * @param dimList
	 * @param reqDim
	 * @param reqDimCode
	 * @param dimValue
	 * @param level
	 * @return
	 */
	private String getJoinSql(String menuId, KpiDef def, String opTime, List<DimCompDef> dimList, DimCompDef reqDim, String reqDimCode, String reqDimValue, int level) throws Exception {
		String dateType = "";
		String yesterday = "";
		String lastMonth = "";
		String lastYear = "";

		if (opTime != null && opTime.length() == 8) {// 日
			dateType = "day";
			yesterday = DateUtil.date2String(DateUtil.getDateByIntervalDays(DateUtil.parseStringToUtilDate(opTime), -1), "yyyyMMdd");
			lastMonth = DateUtil.date2String(DateUtil.getDateByIntervalMonths(DateUtil.parseStringToUtilDate(opTime), -1), "yyyyMMdd");
			lastYear = DateUtil.date2String(DateUtil.getDateByIntervalYears(DateUtil.parseStringToUtilDate(opTime), -1), "yyyyMMdd");
		}
		if (opTime != null && opTime.length() == 6) {// 月
			dateType = "month";
			lastMonth = DateUtil.date2String(DateUtil.getDateByIntervalMonths(DateUtil.parseStringToUtilDate(opTime), -1), "yyyyMM");
			lastYear = DateUtil.date2String(DateUtil.getDateByIntervalYears(DateUtil.parseStringToUtilDate(opTime), -1), "yyyyMM");
		}

		DimCompDef dim = getDim(dimList, reqDim, reqDimCode, level);

		StringBuffer sbf = new StringBuffer("");
		if (dateType.equals("day") && def != null && def.getDataTableName() != null && opTime != null) {
			sbf.append(
					"select kpi_code,a_kpi_code,case when kpi_name is null then a_kpi_name else kpi_name end as kpi_name,kpi_unit,case when op_time is null then a_op_time else op_time end as op_time,case when dim_code is null then a_dim_code else dim_code end as dim_code,case when dim_val is null then a_dim_val else dim_val end as dim_val,case when region_name is null then a_region_name else region_name end as region_name,current,comparedYesterday,comparedLastMonth,a_current,a_comparedLastMonth,a_comparedLastYear from (");
			sbf.append(
					"select kpi_code,kpi_name,kpi_unit,op_time,dim_code,dim_val,region_name,DECIMAL(current,20,2) current,DECIMAL(yesterday,20,2) yesterday,DECIMAL(last_month,20,2) last_month,DECIMAL(last_year,20,2) last_year,case when yesterday is not null and yesterday <> 0 then DECIMAL((((DECIMAL(current,20,4))) / yesterday -1)*100,20,2) else null end comparedYesterday,case when last_month is not null and last_month <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_month -1)*100,20,2) else null end comparedLastMonth,case when last_year is not null and last_year <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_year -1)*100,20,2) else null end comparedLastYear from (");
			sbf.append("select a.kpi_code,menu.name as kpi_name,kpi_unit," + opTime + "  op_time ,");
			sbf.append("dim_code,dim_val,value region_name");
			sbf.append(",kpi_val/division current,yesterday/division yesterday,last_month/division last_month,last_year/division last_year");
			sbf.append(" from " + def.getDataTableName() + " a ,(");
			sbf.append(dim.getColumeValue() + ") b ,(select * from boc_indicator_menu  where id=" + menuId + ") menu ");
			sbf.append(" where a.dim_val=b.key ");
			if (level == 0) {
				sbf.append(" and a.dim_val='" + reqDimValue + "'");
			} else if (level == 1) {
				sbf.append(" and b.parent='" + reqDimValue + "'");
			}
			sbf.append(" and a.dim_code='" + dim.getColumeCode() + "'");
			
			sbf.append(" and a.kpi_code=menu.daily_code and op_time =" + opTime);
			sbf.append(" ) c ");
			sbf.append(") m full join ");
			sbf.append("(");
			sbf.append(
					"select kpi_code as a_kpi_code,a_kpi_name,a_kpi_unit,op_time as a_op_time,dim_code as a_dim_code,dim_val as a_dim_val,region_name as a_region_name,DECIMAL(current,20,2) as a_current,DECIMAL(yesterday,20,2) as a_yesterday,DECIMAL(last_month,20,2) as a_last_month,DECIMAL(last_year,20,2) as a_last_year,case when yesterday is not null and yesterday <> 0 then DECIMAL((((DECIMAL(current,20,4))) / yesterday -1)*100,20,2) else null end a_comparedYesterday,case when last_month is not null and last_month <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_month -1)*100,20,2) else null end a_comparedLastMonth,case when last_year is not null and last_year <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_year -1)*100,20,2) else null end a_comparedLastYear from (");
			sbf.append("select a.kpi_code,menu.name as a_kpi_name,kpi_unit as a_kpi_unit," + opTime + "  op_time ,");
			sbf.append("dim_code,dim_val,value region_name");
			sbf.append(",kpi_val/division current,yesterday/division yesterday,last_month/division last_month,last_year/division last_year");
			sbf.append(" from " + def.getDataTableName() + " a ,(");
			sbf.append(dim.getColumeValue() + ") b ,(select * from boc_indicator_menu  where id=" + menuId + ") menu  ");
			sbf.append(" where a.dim_val=b.key ");
			if (level == 0) {
				sbf.append(" and a.dim_val='" + reqDimValue + "'");
			} else if (level == 1) {
				sbf.append(" and b.parent='" + reqDimValue + "'");
			}
			sbf.append(" and a.dim_code='" + dim.getColumeCode() + "'");
			
			sbf.append(" and a.kpi_code=menu.daily_cumulate_code and op_time =" + opTime);//累计指标
			sbf.append(" ) c ");
			sbf.append(") n on m.dim_val = n.a_dim_val");
		}
		if (dateType.equals("month") && def != null && def.getDataTableName() != null && opTime != null) {
			sbf.append(
					"select kpi_code,a_kpi_code,case when kpi_name is null then a_kpi_name else kpi_name end as kpi_name,kpi_unit,case when op_time is null then a_op_time else op_time end as op_time,case when dim_code is null then a_dim_code else dim_code end as dim_code,case when dim_val is null then a_dim_val else dim_val end as dim_val,case when region_name is null then a_region_name else region_name end as region_name,current,comparedYesterday,comparedLastMonth,a_current,a_comparedLastMonth,a_comparedLastYear from (");
			sbf.append(
					"select kpi_code,kpi_name,kpi_unit,op_time,dim_code,dim_val,region_name,DECIMAL(current,20,2) current,DECIMAL(yesterday,20,2) yesterday,DECIMAL(last_month,20,2) last_month,DECIMAL(last_year,20,2) last_year,case when yesterday is not null and yesterday <> 0 then DECIMAL((((DECIMAL(current,20,4))) / yesterday -1)*100,20,2) else null end comparedYesterday,case when last_month is not null and last_month <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_month -1)*100,20,2) else null end comparedLastMonth,case when last_year is not null and last_year <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_year -1)*100,20,2) else null end comparedLastYear from (");
			sbf.append("select a.kpi_code,menu.name as kpi_name,kpi_unit," + opTime + "  op_time ,");
			sbf.append("dim_code,dim_val,value region_name");
			sbf.append(",kpi_val/division current,yesterday/division yesterday,last_month/division last_month,last_year/division last_year");
			sbf.append(" from " + def.getDataTableName() + " a ,(");
			sbf.append(dim.getColumeValue() + ") b ,(select * from boc_indicator_menu  where id=" + menuId + ") menu ");
			sbf.append(" where a.dim_val=b.key ");
			if (level == 0) {
				sbf.append(" and a.dim_val='" + reqDimValue + "'");
			} else if (level == 1) {
				sbf.append(" and b.parent='" + reqDimValue + "'");
			}
			sbf.append(" and a.dim_code='" + dim.getColumeCode() + "'");
			
			sbf.append(" and a.kpi_code=menu.MONTHLY_CODE and op_time =" + opTime);
			sbf.append(" ) c ");
			sbf.append(") m full join ");
			sbf.append("(");
			sbf.append(
					"select kpi_code as a_kpi_code,a_kpi_name,a_kpi_unit,op_time as a_op_time,dim_code as a_dim_code,dim_val as a_dim_val,region_name as a_region_name,DECIMAL(current,20,2) as a_current,DECIMAL(yesterday,20,2) as a_yesterday,DECIMAL(last_month,20,2) as a_last_month,DECIMAL(last_year,20,2) as a_last_year,case when yesterday is not null and yesterday <> 0 then DECIMAL((((DECIMAL(current,20,4))) / yesterday -1)*100,20,2) else null end a_comparedYesterday,case when last_month is not null and last_month <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_month -1)*100,20,2) else null end a_comparedLastMonth,case when last_year is not null and last_year <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_year -1)*100,20,2) else null end a_comparedLastYear from (");
			sbf.append("select a.kpi_code,menu.name as a_kpi_name,kpi_unit as a_kpi_unit," + opTime + "  op_time ,");
			sbf.append("dim_code,dim_val,value region_name");
			sbf.append(",kpi_val/division current,yesterday/division yesterday,last_month/division last_month,last_year/division last_year");
			sbf.append(" from " + def.getDataTableName() + " a ,(");
			sbf.append(dim.getColumeValue() + ") b ,(select * from boc_indicator_menu  where id=" + menuId + ") menu  ");
			sbf.append(" where a.dim_val=b.key ");
			if (level == 0) {
				sbf.append(" and a.dim_val='" + reqDimValue + "'");
			} else if (level == 1) {
				sbf.append(" and b.parent='" + reqDimValue + "'");
			}
			sbf.append(" and a.dim_code='" + dim.getColumeCode() + "'");
			
			sbf.append(" and a.kpi_code=menu.MONTHLY_CUMULATE_CODE and op_time =" + opTime);//累计指标
			sbf.append(" ) c ");
			sbf.append(") n on m.dim_val = n.a_dim_val");
		}
		return sbf.toString();
	}

	/**
	 * 获取当前维度或者下级维度
	 * 
	 * @param dimList
	 * @param reqDim
	 * @param reqDimCode
	 * @param level
	 * @return
	 * @throws Exception
	 */
	private DimCompDef getDim(List<DimCompDef> dimList, DimCompDef reqDim, String reqDimCode, int level) throws Exception {
		if (level == 0) {// 当前维度
			return reqDim;
		}
		if (level == 1) {// 下级维度
			for (DimCompDef dimCompDef : dimList) {
				if (reqDim.getDimCode().equalsIgnoreCase(dimCompDef.getParentCode())) {
					return dimCompDef;
				}
			}
		}
		return null;
	}

	/**
	 * 从当前KPI定义对应的所有维度中查询当前请求维度类型的维度
	 * 
	 * @param dimCompDefList
	 *            复合维度和简单维度关联的结果集列表
	 * @param dimCode
	 *            如'CITY_ID'
	 * @return 通用型维度模型
	 */
	private DimCompDef getDimByDimCode(List<DimCompDef> dimCompDefList, String dimCode) throws Exception {
		DimCompDef dim = null;
		if (dimCompDefList != null && dimCode != null) {
			for (DimCompDef dimCompDef : dimCompDefList) {
				if (dimCode.equalsIgnoreCase(dimCompDef.getColumeCode())) {
					dim = dimCompDef;
					break;
				}
			}
		}
		return dim;
	}

	public BocIndicatorMenu getBocIndicatorMenuById(String bocIndicatorMenuId) throws Exception {
		BocIndicatorMenu menu = null;
		String sql = "select * from boc_indicator_menu where id=" + bocIndicatorMenuId;
		List<Map<String, Object>> bocIndicatorMenuList = jdbcTemplate.queryForList(sql);
		if (bocIndicatorMenuList != null && bocIndicatorMenuList.size() == 1) {
			menu = new BocIndicatorMenu();
			Map<String, Object> map = bocIndicatorMenuList.get(0);
			menu.setMenuId(String.valueOf(map.get("ID")));
			menu.setPid(map.get("PID") == null ? "" : map.get("PID").toString());
			menu.setMenuName((String) map.get("NAME"));
			menu.setDailyCode((String) map.get("DAILY_CODE"));
			menu.setDailyCumulateCode((String) map.get("DAILY_CUMULATE_CODE"));
			menu.setMonthlyCode((String) map.get("MONTHLY_CODE"));
			menu.setMonthlyCumulateCode((String) map.get("MONTHLY_CUMULATE_CODE"));
			menu.setCategory((String) map.get("CATEGORY"));
			menu.setBureauDailyCode((String) map.get("BUREAU_DAILY_CODE"));
			menu.setBureauDailyCumulateCode((String) map.get("BUREAU_DAILY_CUMULATE_CODE"));
			menu.setBureauMonthlyCode((String) map.get("BUREAU_MONTHLY_CODE"));
			menu.setBureauMonthlyCumulateCode((String) map.get("BUREAU_MONTHLY_CUMULATE_CODE"));
		}
		return menu;
	}

	public List<Kpi> getKpiByTime(String indicatorMenuId, String startTime, String endTime, String reqDimCode, String reqDimVal) throws Exception {
		if (StringUtils.isEmpty(indicatorMenuId)) {
			return null;
		}
		String dateType = "";
		if (startTime != null && endTime != null) {
			startTime = startTime.replaceAll("-", "");
			startTime = startTime.replaceAll("_", "");
			startTime = startTime.replaceAll("/", "");
			endTime = endTime.replaceAll("-", "");
			endTime = endTime.replaceAll("_", "");
			endTime = endTime.replaceAll("/", "");
		} else {
			throw new Exception("日期不能为空");
		}
		if (startTime.length() == 6 && endTime.length() == 6) {
			dateType = "M";
		} else if (startTime.length() == 8 && endTime.length() == 8) {
			dateType = "D";
		} else {
			throw new Exception("日期格式不正确");
		}
		BocIndicatorMenu menu = getBocIndicatorMenuById(indicatorMenuId);
		String dailyCode = menu.getDailyCode();
		String dailyCumulateCode = menu.getDailyCumulateCode();
		String monthlyCode = menu.getMonthlyCode();
		String monthlyCumulateCode = menu.getMonthlyCumulateCode();

		if (dateType.equals("D")) {
			List<Kpi> dailyList = getKpiByDuring(indicatorMenuId,dailyCode,dailyCumulateCode,startTime,endTime, reqDimCode, reqDimVal);
				return dailyList;
		} else if (dateType.equals("M")) {
			List<Kpi> monthlyList = getKpiByDuring(indicatorMenuId,monthlyCode,monthlyCumulateCode,startTime, endTime, reqDimCode, reqDimVal);
			return monthlyList;
		}
		return null;
	}
	public List<Kpi> getKpiByDuring(String menuId,String kpiCode,String kpiCumulateCode, String startTime, String endTime, String reqDimCode, String reqDimVal) throws Exception {
		if (StringUtils.isEmpty(menuId)) {
			logger.error("指标menuId:" + menuId + "为空");
			return null;
		}
		if (StringUtils.isEmpty(kpiCode) && StringUtils.isEmpty(kpiCumulateCode)) {
			logger.error("kpiCode:" + kpiCode + "为空" + "，并且kpiCumulateCode:" + kpiCumulateCode + "也为空");
			return null;
		}
		List<Kpi> kpiList = new ArrayList<Kpi>();
		String dateType = "";
		if (startTime != null && endTime != null) {
			startTime = startTime.replaceAll("-", "");
			startTime = startTime.replaceAll("_", "");
			startTime = startTime.replaceAll("/", "");
			endTime = endTime.replaceAll("-", "");
			endTime = endTime.replaceAll("_", "");
			endTime = endTime.replaceAll("/", "");
		} else {
			throw new Exception("日期不能为空");
		}
		if (startTime.length() == 6 && endTime.length() == 6) {
			dateType = "M";
		} else if (startTime.length() == 8 && endTime.length() == 8) {
			dateType = "D";
		} else {
			throw new Exception("日期格式不正确");
		}
		String sql = "";
		try {
			if (reqDimCode != null && reqDimCode.length() > 0  && null != startTime && (startTime.length() == 6 || startTime.length() == 8) && null != endTime
					&& (endTime.length() == 6 || endTime.length() == 8)) {
				KpiDef kpiDef = getKpiDefById(kpiCode);
				// 如果指标代码没有配置，则查累计指标
				if (kpiDef == null) {
					kpiDef = getKpiDefById(kpiCumulateCode);
				}
				List<DimCompDef> dimList = null;
				DimCompDef reqDim = null;
				if (kpiDef != null && kpiDef.getDataTableName() != null) {
					dimList = getKpiDim(kpiDef.getCompdimId());
					reqDim = getDimByDimCode(dimList, reqDimCode);
					StringBuffer sbf = new StringBuffer("");
					sbf.append(getJoinSqlByTime(menuId,kpiDef, startTime, endTime, dimList, reqDim, reqDimCode, reqDimVal));
					String str = sbf.substring(0, sbf.length() - 11);
					str+="order by op_time";
					sql = str.toString();
				} else if (kpiDef == null) {
					logger.error("kpiDef为空");
				} else if (kpiDef != null && kpiDef.getDataTableName() == null) {
					logger.error(kpiCode + "的kpiDef.getDataTableName()的结果为空");
				}
			} else {
				logger.debug("传入的以下参数不正确：kpicode:" + kpiCode + "，日期：" + startTime + ",结束时间" + endTime + "，维度类型：" + reqDimCode + "，维度值：" + reqDimVal);
			}

			if (sql != null && sql.trim().length() > 0) {
				logger.debug("KPI查询时的SQL为：" + sql);
				List<Map<String, Object>> resultList = jdbcTemplate.queryForList(sql);
				for (Map<String, Object> map : resultList) {
					Kpi kpi = new Kpi();
					kpi.setMenuId(menuId);
					kpi.setKpiCode((String) map.get("KPI_CODE"));
					kpi.setAccumulationKpiCode((String) map.get("A_KPI_CODE"));
					kpi.setKpiName((String) map.get("KPI_NAME"));
					kpi.setKpiUnit((String) map.get("KPI_UNIT"));
					kpi.setOpTime(String.valueOf(map.get("OP_TIME")));
					kpi.setDimCode((String) map.get("DIM_CODE"));
					kpi.setDimVal((String) map.get("DIM_VAL"));
					kpi.setRegionName((String) map.get("REGION_NAME"));
					kpi.setDailyCurrent((BigDecimal) map.get("CURRENT"));
					kpi.setDailyAccumulation((BigDecimal) map.get("A_CURRENT"));
					if (dateType.equals("D")) {
						kpi.setDailyComparedYesterday((BigDecimal) map.get("comparedYesterday"));
						kpi.setDailyComparedLastMonth((BigDecimal) map.get("comparedLastMonth"));
						kpi.setDailyAccumulationComparedLastMonth((BigDecimal) map.get("a_comparedLastMonth"));
						kpi.setDailyAccumulationComparedLastYear((BigDecimal) map.get("a_comparedLastYear"));
					}
					if (dateType.equals("M")) {
						kpi.setMonthlyComparedLastMonth((BigDecimal) map.get("comparedLastMonth"));
						kpi.setMonthlyComparedLastYear((BigDecimal) map.get("comparedLastYear"));
					}
					kpi.setLevel(map.get("LEVEL") == null ? 0 : Integer.valueOf(map.get("LEVEL").toString()));
					kpiList.add(kpi);
				}
			}
		} catch (Exception e) {
			logger.error(LogUtil.getExceptionMessage(e));
		}
		return kpiList;
	}

	private Object getJoinSqlByTime(String menuId,KpiDef def, String startTime, String endTime, List<DimCompDef> dimList, DimCompDef reqDim, String reqDimCode, String reqDimVal) throws Exception {
		String dateType = "";
		String yesterday = "";
		String lastMonth = "";
		String lastYear = "";

		SimpleDateFormat sdfd = new SimpleDateFormat("yyyyMMdd");
		SimpleDateFormat sdfm = new SimpleDateFormat("yyyyMM");
		Date dBegin = new Date();
		Date dEnd = new Date();
		List<Date> listDate = new ArrayList<Date>();
		if (startTime.equals(endTime) && startTime != null && endTime != null && startTime.length() == 8 && endTime.length() == 8) { // 默认15天
			startTime = DateUtil.date2String(DateUtil.getDateByIntervalDays(DateUtil.parseStringToUtilDate(startTime), -15), "yyyyMMdd");
			dBegin = sdfd.parse(startTime);
			dEnd = sdfd.parse(endTime);
			listDate = DateUtil.getDatesBetweenTwoDate(dBegin, dEnd);
		} else if (startTime.equals(endTime) && startTime != null && endTime != null && startTime.length() == 6 && endTime.length() == 6) {// 默认15月
			startTime = DateUtil.date2String(DateUtil.getDateByIntervalMonths(DateUtil.parseStringToUtilDate(startTime), -15), "yyyyMM");
			dBegin = sdfm.parse(startTime);
			dEnd = sdfm.parse(endTime);
			listDate = DateUtil.getDatesBetweenTwoMon(dBegin, dEnd);
		} else {
			if (startTime != null && endTime != null && startTime.length() == 8 && endTime.length() == 8) {
				dBegin = sdfd.parse(startTime);
				dEnd = sdfd.parse(endTime);
				listDate = DateUtil.getDatesBetweenTwoDate(dBegin, dEnd);
			} else if (startTime != null && endTime != null && startTime.length() == 6 && endTime.length() == 6) {
				dBegin = sdfm.parse(startTime);
				dEnd = sdfm.parse(endTime);
				listDate = DateUtil.getDatesBetweenTwoMon(dBegin, dEnd);
			}
		}
		StringBuffer sbf = new StringBuffer("");
		for (int i = 0; i < listDate.size(); i++) {
			if (startTime.length() == 8) {
				startTime = sdfd.format(listDate.get(i));
				dateType = "day";
				yesterday = DateUtil.date2String(DateUtil.getDateByIntervalDays(DateUtil.parseStringToUtilDate(startTime), -1), "yyyyMMdd");
				lastMonth = DateUtil.date2String(DateUtil.getDateByIntervalMonths(DateUtil.parseStringToUtilDate(startTime), -1), "yyyyMMdd");
				lastYear = DateUtil.date2String(DateUtil.getDateByIntervalYears(DateUtil.parseStringToUtilDate(startTime), -1), "yyyyMMdd");
			} else if (startTime.length() == 6) {
				startTime = sdfm.format(listDate.get(i));
				dateType = "month";
				lastMonth = DateUtil.date2String(DateUtil.getDateByIntervalMonths(DateUtil.parseStringToUtilDate(startTime), -1), "yyyyMM");
				lastYear = DateUtil.date2String(DateUtil.getDateByIntervalYears(DateUtil.parseStringToUtilDate(startTime), -1), "yyyyMM");
			}
		
			// DimCompDef dim = getDim(dimList, reqDim, reqDimCode, level);
			if (dateType.equals("day") && def != null && def.getDataTableName() != null && startTime != null) {
				sbf.append(
						"select kpi_code,a_kpi_code,case when kpi_name is null then a_kpi_name else kpi_name end as kpi_name,kpi_unit,case when op_time is null then a_op_time else op_time end as op_time,case when dim_code is null then a_dim_code else dim_code end as dim_code,case when dim_val is null then a_dim_val else dim_val end as dim_val,case when region_name is null then a_region_name else region_name end as region_name,current,comparedYesterday,comparedLastMonth,a_current,a_comparedLastMonth,a_comparedLastYear from (");
				sbf.append(
						"select kpi_code,kpi_name,kpi_unit,op_time,dim_code,dim_val,region_name,DECIMAL(current,20,2) current,DECIMAL(yesterday,20,2) yesterday,DECIMAL(last_month,20,2) last_month,DECIMAL(last_year,20,2) last_year,case when yesterday is not null and yesterday <> 0 then DECIMAL((((DECIMAL(current,20,4))) / yesterday -1)*100,20,2) else null end comparedYesterday,case when last_month is not null and last_month <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_month -1)*100,20,2) else null end comparedLastMonth,case when last_year is not null and last_year <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_year -1)*100,20,2) else null end comparedLastYear from (");
				sbf.append("select a.kpi_code,menu.name as kpi_name,kpi_unit," + startTime + "  op_time ,");
				sbf.append("dim_code,dim_val,value region_name");
				sbf.append(",kpi_val/division current,yesterday/division yesterday,last_month/division last_month,last_year/division last_year");
				sbf.append(" from " + def.getDataTableName() + " a ,(");
				sbf.append(reqDim.getColumeValue() + ") b ,(select * from boc_indicator_menu  where id=" + menuId + ") menu ");
				sbf.append(" where a.dim_val=b.key ");
					sbf.append(" and a.dim_val='" + reqDimVal + "'");
				sbf.append(" and a.dim_code='" + reqDim.getColumeCode() + "'");
				
				sbf.append(" and a.kpi_code=menu.daily_code and op_time =" + startTime);
				sbf.append(" ) c ");
				sbf.append(") m full join ");
				sbf.append("(");
				sbf.append(
						"select kpi_code as a_kpi_code,a_kpi_name,a_kpi_unit,op_time as a_op_time,dim_code as a_dim_code,dim_val as a_dim_val,region_name as a_region_name,DECIMAL(current,20,2) as a_current,DECIMAL(yesterday,20,2) as a_yesterday,DECIMAL(last_month,20,2) as a_last_month,DECIMAL(last_year,20,2) as a_last_year,case when yesterday is not null and yesterday <> 0 then DECIMAL((((DECIMAL(current,20,4))) / yesterday -1)*100,20,2) else null end a_comparedYesterday,case when last_month is not null and last_month <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_month -1)*100,20,2) else null end a_comparedLastMonth,case when last_year is not null and last_year <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_year -1)*100,20,2) else null end a_comparedLastYear from (");
				sbf.append("select a.kpi_code,menu.name as a_kpi_name,kpi_unit as a_kpi_unit," + startTime + "  op_time ,");
				sbf.append("dim_code,dim_val,value region_name");
				sbf.append(",kpi_val/division current,yesterday/division yesterday,last_month/division last_month,last_year/division last_year");
				sbf.append(" from " + def.getDataTableName() + " a ,(");
				sbf.append(reqDim.getColumeValue() + ") b ,(select * from boc_indicator_menu  where id=" + menuId + ") menu  ");
				sbf.append(" where a.dim_val=b.key ");
					sbf.append(" and a.dim_val='" + reqDimVal + "'");
				sbf.append(" and a.dim_code='" + reqDim.getColumeCode() + "'");
				
				sbf.append(" and a.kpi_code=menu.daily_cumulate_code and op_time =" + startTime);//累计指标
				sbf.append(" ) c ");
				sbf.append(") n on m.dim_val = n.a_dim_val union all \n");
			}
			if (dateType.equals("month") && def != null && def.getDataTableName() != null && startTime != null) {
				sbf.append(
						"select kpi_code,a_kpi_code,case when kpi_name is null then a_kpi_name else kpi_name end as kpi_name,kpi_unit,case when op_time is null then a_op_time else op_time end as op_time,case when dim_code is null then a_dim_code else dim_code end as dim_code,case when dim_val is null then a_dim_val else dim_val end as dim_val,case when region_name is null then a_region_name else region_name end as region_name,current,comparedYesterday,comparedLastMonth,a_current,a_comparedLastMonth,a_comparedLastYear from (");
				sbf.append(
						"select kpi_code,kpi_name,kpi_unit,op_time,dim_code,dim_val,region_name,DECIMAL(current,20,2) current,DECIMAL(yesterday,20,2) yesterday,DECIMAL(last_month,20,2) last_month,DECIMAL(last_year,20,2) last_year,case when yesterday is not null and yesterday <> 0 then DECIMAL((((DECIMAL(current,20,4))) / yesterday -1)*100,20,2) else null end comparedYesterday,case when last_month is not null and last_month <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_month -1)*100,20,2) else null end comparedLastMonth,case when last_year is not null and last_year <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_year -1)*100,20,2) else null end comparedLastYear from (");
				sbf.append("select a.kpi_code,menu.name as kpi_name,kpi_unit," + startTime + "  op_time ,");
				sbf.append("dim_code,dim_val,value region_name");
				sbf.append(",kpi_val/division current,yesterday/division yesterday,last_month/division last_month,last_year/division last_year");
				sbf.append(" from " + def.getDataTableName() + " a ,(");
				sbf.append(reqDim.getColumeValue() + ") b ,(select * from boc_indicator_menu  where id=" + menuId + ") menu ");
				sbf.append(" where a.dim_val=b.key ");
					sbf.append(" and a.dim_val='" + reqDimVal + "'");
				sbf.append(" and a.dim_code='" + reqDim.getColumeCode() + "'");
				
				sbf.append(" and a.kpi_code=menu.daily_code and op_time =" + startTime);
				sbf.append(" ) c ");
				sbf.append(") m full join ");
				sbf.append("(");
				sbf.append(
						"select kpi_code as a_kpi_code,a_kpi_name,a_kpi_unit,op_time as a_op_time,dim_code as a_dim_code,dim_val as a_dim_val,region_name as a_region_name,DECIMAL(current,20,2) as a_current,DECIMAL(yesterday,20,2) as a_yesterday,DECIMAL(last_month,20,2) as a_last_month,DECIMAL(last_year,20,2) as a_last_year,case when yesterday is not null and yesterday <> 0 then DECIMAL((((DECIMAL(current,20,4))) / yesterday -1)*100,20,2) else null end a_comparedYesterday,case when last_month is not null and last_month <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_month -1)*100,20,2) else null end a_comparedLastMonth,case when last_year is not null and last_year <> 0 then DECIMAL((((DECIMAL(current,20,4))) / last_year -1)*100,20,2) else null end a_comparedLastYear from (");
				sbf.append("select a.kpi_code,menu.name as a_kpi_name,kpi_unit as a_kpi_unit," + startTime + "  op_time ,");
				sbf.append("dim_code,dim_val,value region_name");
				sbf.append(",kpi_val/division current,yesterday/division yesterday,last_month/division last_month,last_year/division last_year");
				sbf.append(" from " + def.getDataTableName() + " a ,(");
				sbf.append(reqDim.getColumeValue() + ") b ,(select * from boc_indicator_menu  where id=" + menuId + ") menu  ");
				sbf.append(" where a.dim_val=b.key ");
					sbf.append(" and a.dim_val='" + reqDimVal + "'");
				sbf.append(" and a.dim_code='" + reqDim.getColumeCode() + "'");
				
				sbf.append(" and a.kpi_code=menu.daily_cumulate_code and op_time =" + startTime);//累计指标
				sbf.append(" ) c ");
				sbf.append(") n on m.dim_val = n.a_dim_val union all \n");
			}
		}
		return sbf.toString();
	}
}
