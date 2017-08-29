package com.asiainfo.hb.bass.custome.report;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.asiainfo.hb.bass.custome.report.models.ColumnInfo;
import com.asiainfo.hb.bass.custome.report.models.QueryInfo;
import com.asiainfo.hb.bass.custome.report.models.ReportInfo;
import com.asiainfo.hb.bass.custome.report.service.CustomReportService;

@Component
public class ReportContext {

	@Autowired
	private CustomReportService customReportService;

	private Logger logger = Logger.getLogger(ReportContext.class);

	public static final String DAY_REPORT_TABLE = "KPI_COMP_CD005_D_VERTICAL";
	public static final String MONTH_REPORT_TABLE = "KPI_COMP_CD005_M_VERTICAL";
	public static final String DAY = "DAY_TYPE";
	public static final String MONTH = "MONTH_TYPE";
	public static final String DATE_FORMAT = "yyyy-MM-dd";
	public static final Integer PAGE = 1;
	public static final Integer ROWS = 10;
	private static final SimpleDateFormat FORMAT_1 = new SimpleDateFormat("yyyy-MM-dd");
	private static final SimpleDateFormat FORMAT_2 = new SimpleDateFormat("yyyyMMdd");

	private static final SimpleDateFormat FORMAT_MONTH_1 = new SimpleDateFormat("yyyy-MM");
	private static final SimpleDateFormat FORMAT_MONTH_2 = new SimpleDateFormat("yyyyMM");
	public String type = null;

	private QueryInfo info = null;

	private List<ColumnInfo> columns = null;

	private List<ReportInfo> reportList;

	private String reportId;

	private String queryDate;

	private String querySQL;

	private Map<String, Object> datas;

	Map<String, Object> parameters = null;

	private String defaultDate;

	public ReportContext() {
	}

	public ReportContext(String reportId) {
		this.reportId = reportId;
	}

	public String getSearchDate() {
		getTypeInfo();
		if (reportList != null && reportList.size() > 0) {
			defaultDate = customReportService.getKpiDefaultDate(type, reportList.get(0).getKpiCode());

			try {
				if (type.equals(DAY)) {
					if (StringUtils.isBlank(defaultDate)) {
						defaultDate = FORMAT_1.format(new Date());
					} else {
						defaultDate = FORMAT_1.format(FORMAT_2.parse(defaultDate));
					}
				} else {
					if (StringUtils.isBlank(defaultDate)) {
						defaultDate = FORMAT_MONTH_1.format(new Date());
					} else {
						defaultDate = FORMAT_MONTH_1.format(FORMAT_MONTH_2.parse(defaultDate));
					}
				}
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}
		if (StringUtils.isBlank(defaultDate)) {
			defaultDate = FORMAT_1.format(new Date());
		}
		return defaultDate;
	}

	public void init() {
		parameters = new HashMap<String, Object>();
		// 查询指标配置信息
		getReportInfo();
		// 判断指标类型: 日指标/月指标
		getTypeInfo();
	}

	private void getTypeInfo() {
		if (reportList != null && reportList.size() > 0) {
			String kpiCode = reportList.get(0).getKpiCode();
			if (kpiCode.startsWith("DCD") || kpiCode.startsWith("ACD")) {
				type = DAY;
			} else {
				type = MONTH;
			}
		}
	}

	private void getReportInfo() {
		reportList = customReportService.getReportList(reportId);
		logger.info("the reports is " + reportList);
	}

	public void inittHead() {
		columns = new ArrayList<ColumnInfo>();
		// 指标查询第一列默认为地市
		columns.add(new ColumnInfo("CITY", "地市", 200));

		// 第二列需要判断是否又县市细分
		if (StringUtils.isNotBlank(info.getCountyX())) {
			columns.add(new ColumnInfo("COUNTRY", "县市", 200));
		}

		// 第三列需要判断是否有营销中心细分
		if (StringUtils.isNotBlank(info.getMarktingX())) {
			columns.add(new ColumnInfo("marktingName", "营销中心", 200));
		}
		// 第四列开始凭借指标值列
		for (int i = 0; i < reportList.size(); i++) {
			columns.add(new ColumnInfo(reportList.get(i).getKpiCode(), reportList.get(i).getMenuName(), 200));
			// 对比数据也在这儿添加 TODO
		}
	}

	public void query(int page, int rows) {

		// 获取报表周期
		initQueryDate();
		// 获取sql
		initFullSql();
		// 获取数据
		getReportDatas(page, rows);
	}

	private void getReportDatas(int page, int rows) {
		datas = customReportService.getReportQueryDate(page, rows, querySQL, parameters);
	}

	/**
	 * 获取报表周期,如果kpiDate为null则默认为当前日期
	 */
	private void initQueryDate() {
		try {
			if (type.equals(DAY)) {
				if (StringUtils.isBlank(info.getKpiDate())) {
					queryDate = FORMAT_1.format(new Date());
				} else {
					queryDate = FORMAT_1.format(FORMAT_2.parse(info.getKpiDate()));
				}
			} else {
				if (StringUtils.isBlank(info.getKpiDate())) {
					queryDate = FORMAT_MONTH_1.format(new Date());
				} else {
					queryDate = FORMAT_MONTH_1.format(FORMAT_MONTH_2.parse(info.getKpiDate()));
				}
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 初始化嵌套查询内部SQL
	 */
	private String initQuerySql() {
		StringBuffer sb = new StringBuffer();
		sb.append("select dim_val ");
		String kpiCode = null;
		if (reportList == null || reportList.size() == 0) {
			throw new RuntimeException("自定义报表中配置的指标不能为空");
		}
		StringBuffer kpis = new StringBuffer("(");
		for (int i = 0; i < reportList.size(); i++) {
			kpiCode = reportList.get(i).getKpiCode();
			sb.append(" ,sum(decode(kpi_code,'" + kpiCode + "',kpi_val,0)) as ");
			sb.append(kpiCode);
			kpis.append("'" + kpiCode + "',");
			// 在此处添加对比数据,TODO
		}
		sb.append(" from ").append(getTableNameByType()).append(" ");
		sb.append(" where kpi_code in ");
		if (kpis.length() > 1) {
			sb.append(kpis.substring(0, kpis.length() - 1) + " ) ");
		}

		sb.append(" group by  dim_val,op_time");
		sb.append(" order by dim_val ");
		return sb.toString();
	}

	/**
	 * 初始化完整SQL
	 */
	public void initFullSql() {
		StringBuffer fullSQL = new StringBuffer();
		String sql = initQuerySql();
		StringBuffer citySQL = new StringBuffer();
		citySQL.append(
				"select t.*,length(t.dim_val) len,city.CITY_NAME as city,city.CITY_NAME as country,'' as marking ");
		citySQL.append(" from DIM_PUB_CITY city ,(");
		citySQL.append(sql);
		citySQL.append(" ) t where city.CITY_ID  = t.dim_val");

		StringBuffer countrySQL = new StringBuffer();
		countrySQL.append(
				"select t.*,length(t.dim_val) len,city.CITY_NAME as city,county.county_name as country,'' as marking ");
		countrySQL.append(" from DIM_PUB_CITY city ,dim_pub_county county,(");
		countrySQL.append(sql);
		countrySQL.append(" ) t where county.county_id  =t.dim_val and city.city_id = county.city_id ");

		// 添加条件
		if (StringUtils.isNoneBlank(info.getMarktingX()) && StringUtils.isNotBlank(info.getMarketingCenters())) {
			// TODO 营销中心过滤
		}
		if (StringUtils.isNotBlank(info.getCountyX()) && StringUtils.isNotBlank(info.getCountyList())) {
			parameters.put("countyId", info.getCountyList());
			countrySQL.append(" and county.county_id=:countyId ");
		}
		if (StringUtils.isNotBlank(info.getAreaCode()) && !info.getAreaCode().equals("HB")) {
			countrySQL.append(" and city.city_id = :cityId ");
			citySQL.append(" and city.city_id = :cityId ");
			parameters.put("cityId", info.getAreaCode());
		}

		fullSQL.append(citySQL);
		fullSQL.append(" union all ");
		fullSQL.append(countrySQL);
		fullSQL.append(" order by len,dim_val asc ");
		querySQL = fullSQL.toString();
	}

	private String getTableNameByType() {
		if (type.equals(DAY)) {
			return DAY_REPORT_TABLE;
		} else {
			return MONTH_REPORT_TABLE;
		}
	}

	public QueryInfo getInfo() {
		return info;
	}

	public void setInfo(QueryInfo info) {
		this.info = info;
	}

	public String getReportId() {
		return reportId;
	}

	public void setReportId(String reportId) {
		this.reportId = reportId;
	}

	public Map<String, Object> getDatas() {
		return datas;
	}

	public void setDatas(Map<String, Object> datas) {
		this.datas = datas;
	}

	public List<ColumnInfo> getColumns() {
		return columns;
	}

	public void setColumns(List<ColumnInfo> columns) {
		this.columns = columns;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDefaultDate() {
		return defaultDate;
	}

	public void setDefaultDate(String defaultDate) {
		this.defaultDate = defaultDate;
	}

	public String getQueryDate() {
		return queryDate;
	}

	public void setQueryDate(String queryDate) {
		this.queryDate = queryDate;
	}

}
