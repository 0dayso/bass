package com.asiainfo.bass.apps.models;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.BassDimHelper;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.models.User;

/**
 * 
 * 
 * @author Mei Kefu
 * @date 2011-3-4
 */
@Repository
public class ReportDao {
	
	private static Logger LOG = Logger.getLogger(ReportDao.class);

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	private JdbcTemplate jdbcTemplateDw;

	@Autowired
	public void setDataSourceDw(DataSource dataSourceDw) {
		this.jdbcTemplateDw = new JdbcTemplate(dataSourceDw);
	}

	private JdbcTemplate jdbcTemplateNl;

	@Autowired
	public void setDataSourceNl(DataSource dataSourceNl) {
		this.jdbcTemplateNl = new JdbcTemplate(dataSourceNl);
	}

	@Autowired
	private BassDimHelper bassDimHelper;

	public Report getReportById(int id) {
		return getReportById(id, "0", null);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map getTimeLine(int id, String userid) {
		LOG.info("id=" + id + ",userID=" + userid);
		Map timeLine = new HashMap();
		try {
			try {
				String sql="select resp responsible,proc from (select sid,max(case when code='Proc' then value end) proc,max(case when code='Resp' then value end) resp from FPF_IRS_SUBJECT_EXT where code in ('Resp','Proc') group by sid) a where sid=? with ur";
				
				for(Map<String, Object> Main:jdbcTemplate.queryForList(sql, new Object[] { id })){
					timeLine=Main;
				}
//				timeLine = (Map) jdbcTemplate.queryForMap(
//						"select resp responsible,proc from (select sid,max(case when code='Proc' then value end) proc,max(case when code='Resp' then value end) resp from FPF_IRS_SUBJECT_EXT where code in ('Resp','Proc') group by sid) a where sid=? with ur",
//						new Object[] { id });
			} catch (Exception e) {
				LOG.info("timeLine查询异常1：" + e.getMessage());
				e.printStackTrace();
			}
			if (timeLine == null) {
				timeLine = new HashMap();
			}
			String proc = (String) timeLine.get("proc");
			if (proc != null && proc.length() > 0) {
				Map map = (Map) jdbcTemplate.queryForMap("select max(etl_cycle_id) task,max(dest_time) dest_time from dp_etl_com_dw where etl_progname=? with ur", new Object[] { proc });
				if (map != null) {
					String task = String.valueOf(map.get("task"));
					String dest_time = String.valueOf(map.get("dest_time")).trim();
					String text = "";
					if (dest_time != null && dest_time.length() > 0 && dest_time != "null") {
						if (task.length() == 6) {
							text += "每月" + dest_time + "号";
						} else if (task.length() == 8) {
							text += "每日" + dest_time;
						}
					}
					timeLine.put("timeline", text);
					String run = "0";
					String check = "0";
					List roleList = jdbcTemplate.queryForList("select a.role_id from FPF_GROUP_ROLE_MAP a inner join FPF_USER_GROUP b on a.group_id=b.group_id inner join FPF_USER_GROUP_MAP c on b.group_id = c.group_id inner join FPF_USER_USER d on c.userid=d.userid where d.userid=?", new Object[]{ userid });
					if(roleList!=null && roleList.size()>0){
						for(int i=0;i<roleList.size();i++){
							Map roleMap = (Map)roleList.get(i);
							if(roleMap.get("role_id").toString().equals("8a99fcbb21955ec701219758e9080004")){
								check = "2";
								break;
							}
						}
					}
					if("2".equals(check)){
						Map runMap = (Map) jdbcTemplate.queryForMap("select id,name,user_id,value,etl_cycle_id,etl_begintime,etl_endtime,case when etl_state=0 then '正在运行' when etl_state=2 then '程序出错' when  etl_state=3 then '成功完成' else '状态不明' end etl_state ,dest_time,int(avg_runtime/60)+1 avg_runtime,value(creater,'无') creater from(select * from FPF_IRS_SUBJECT aa,FPF_IRS_SUBJECT_EXT bb where aa.id=bb.sid and bb.code='Proc' and status='在用') a left join  dp_etl_com_dw b on upper(a.value)=upper(b.ETL_PROGNAME) left join proc_dw c on upper(a.value)=upper(c.proc_name) where id=?", new Object[] { id });
						if(!runMap.isEmpty()){
							run = "1";
							String value = runMap.get("value").toString();
							String cycle = runMap.get("etl_cycle_id").toString();
							String userId = runMap.get("user_id").toString();
							String begintime = runMap.get("etl_begintime").toString();
							String endtime = runMap.get("etl_endtime").toString();
							String status = runMap.get("etl_state").toString();
							String creater = runMap.get("creater").toString();
							String runtime = runMap.get("avg_runtime").toString()+"分钟";
							timeLine.put("value", value);
							timeLine.put("cycle", cycle);
							timeLine.put("userId", userId);
							timeLine.put("begintime", begintime);
							timeLine.put("endtime", endtime);
							timeLine.put("status", status);
							timeLine.put("creater", creater);
							timeLine.put("runtime", runtime);
						}
						List list = jdbcTemplate.queryForList("select * from (select id,value from (select * from FPF_IRS_SUBJECT where id =?) aa ,FPF_IRS_SUBJECT_EXT bb where aa.id=bb.sid and bb.code='Proc' and status='在用') x left join (select bb.intercode,bb.DATECYCLE,bb.EXPORTSTATE,WEBSTATE,EXPORTROWS,WEBLOADROWS,char(web_time) web_time,proc_name from DATA_TRANS_CONFIG_DW aa , (select a.intercode,b.DATECYCLE,EXPORTSTATE,WEBSTATE,EXPORTROWS,WEBLOADROWS,char(web_time) from (select INTERCODE,max(id) id from DATA_TRANS_LOG_DW   group by INTERCODE) a   left join (select  id,INTERCODE,DATECYCLE,EXPORTSTATE,WEBSTATE,EXPORTROWS,WEBLOADROWS,char(web_time) web_time  from DATA_TRANS_LOG_DW  order by INTERCODE) b on a.INTERCODE=b.intercode and a.id=b.id  ) bb where aa.intercode=bb.intercode) y on upper(x.value)=upper(y.proc_name)", new Object[] { id });
						if(list!=null && list.size()>0){
							timeLine.put("fenfaList", list);
						}
					}
					timeLine.put("run", run);
					timeLine.put("check", check);
				}
			}
		} catch (Exception e) {
			LOG.info("timeLine查询异常2：" + e.getMessage());
			e.printStackTrace();
		}
		LOG.info("查询结束,timeLine是否为空：" + timeLine.isEmpty());
		return timeLine;
	}
	
	public Report getReportById(int id, String regionId, User user) {
		Report report = new Report();
		report = getReportById(id,regionId,user,null,null,null);
		return report;
	}

	@SuppressWarnings("rawtypes")
	public Report getReportById(int id, String regionId, User user, String time, String city, String condition) {
		Report report = new Report();
		report.setId(id);
		// 分公司市场经理、工号管理员两类用户组的权限需开放全省权限
		if (null != user) {
			LOG.info("user不为空");
			if (user.getGroupName().indexOf("分公司领导(跨地市KPI)") != -1 || user.getGroupName().indexOf("工号管理员") != -1 || (user.getGroupName().indexOf("市场") != -1 && user.getGroupName().indexOf("经理") != -1)) {
				report.setRegionId("0");
			} else {
				report.setRegionId(user.getCityId());
			}
		} else {
			LOG.info("user为空");
			report.setRegionId(regionId);
		}

		List list = (List) jdbcTemplate.queryForList("select name,desc from FPF_IRS_SUBJECT where id=? and KIND='配置' ", new Object[] { Integer.valueOf(id) });
		LOG.info("list结果1：" + list.size());
		if (list.size() > 0) {
			Map map = (Map) list.get(0);
			LOG.info("name：" + (String) map.get("name"));
			report.setName((String) map.get("name"));
		}

		list = (List) jdbcTemplate.queryForList("select code,value from FPF_IRS_SUBJECT_EXT where sid=? ", new Object[] { Integer.valueOf(id) });
		LOG.info("list结果2：" + list.size());
		for (int i = 0; i < list.size(); i++) {
			Map map = (Map) list.get(i);

			if ("Grid".equalsIgnoreCase((String) map.get("code"))) {
				report.setGrid((String) map.get("value"));
			} else if ("DS".equalsIgnoreCase((String) map.get("code"))) {
				report.setDs((String) map.get("value"));
			} else if ("Cache".equalsIgnoreCase((String) map.get("code"))) {
				report.setIsCached((String) map.get("value"));
			} else if ("UseExcel".equalsIgnoreCase((String) map.get("code"))) {
				report.setUseExcel((String) map.get("value"));
			} else if ("UseChart".equalsIgnoreCase((String) map.get("code"))) {
				report.setUseChart((String) map.get("value"));
			} else if ("MaxTime".equalsIgnoreCase((String) map.get("code"))) {
				String str = (String) map.get("value");
				if(str!= null){
					report.setMaxTime(str.indexOf(";")>0?str.substring(0, str.indexOf(";")):str);
				}
			} else if ("SQL".equalsIgnoreCase((String) map.get("code"))) {
				String sql=((String) map.get("value"));
				sql=sql.replaceAll("PT.","ST.");
				report.setOriSQL(sql);
			} else if ("Code".equalsIgnoreCase((String) map.get("code"))) {
				report.setCodeData((String) map.get("value"));
			} else if ("AreaAll".equalsIgnoreCase((String) map.get("code"))) {
				report.setIsAreaAll((String) map.get("value"));
			}
		}
		
		if(null != time && !"".equals(time)){
			LOG.info("time=" + time);
			report.setMaxTime(time);
		}
		if(city != null && !"null".equals(city))
		{
			LOG.info("city=" + city);
			report.setRegionId(city);
			report.setIsAreaAll("false");
		}
		report.setDimensionData(initDimensionPiece(report,condition));
		report.setHeaderData(initHeaderPiece(report));
		
		report.setSql(genSQL(report));
		report.setDownHeader(genDownHeader(id));
		return report;
	}

	/**
	 * 返回默认运行的SQL
	 * 
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public String genSQL(Report report) {

		// 1.处理 {condiPiece}
		// aihb.AjaxHelper.parseCondition()，这个还比较简单，应为默认有数据的就只有时间和地域（省或地市）
		// 2.处理{colPiece} 只处理地市
		// 3.处理{groupPiece} 只处理地市
		// 4.处理{orderPiece} 暂时不处理
		String oriSQL = report.getOriSQL();
		String sql = oriSQL.replaceAll("\r\n", " ");
		String condiPiece = "";
		String colPiece = "";
		String groupPiece = "";
		String orderPiece = " order by 1";
		List list = jdbcTemplate.queryForList("select label,name,dbname,opertype,datasource,defval from FPF_IRS_SUBJECT_DIM where sid=?  with ur", new Object[] { report.getId() });

		for (int i = 0; i < list.size(); i++) {

			Map map = (Map) list.get(i);
			String datasource = (String) map.get("datasource");
			String dbname = (String) map.get("dbname");
			String operType = (String) map.get("opertype");

			if ("comp:date".equalsIgnoreCase(datasource) || "comp:month".equalsIgnoreCase(datasource)) {
				String defaultTime = bassDimHelper.calDefDate("comp:date".equalsIgnoreCase(datasource) ? "yyyyMMdd" : "yyyyMM")[0];
				/*
				 * if(maxTime.length()>0){ SQLQuery sqlQuery1 =
				 * SQLQueryContext.getInstance
				 * ().getSQLQuery(SQLQueryContext.SQLQueryName.LIST);
				 * 
				 * List _list=(List)sqlQuery1.query(maxTime); String[] line =
				 * (String[])_list.get(0); defaultTime = line[0]; }else{
				 * defaultTime
				 * =bassDimHelper.calDefDate("comp:date".equalsIgnoreCase
				 * (datasource)?"yyyyMMdd":"yyyyMM")[0]; }
				 */

				if (dbname != null && dbname.length() > 0) {

					condiPiece += " and " + dbname + "=";
					if (!"int".equalsIgnoreCase(operType)) {
						condiPiece += "'";
					}

					condiPiece += defaultTime;

					if (!"int".equalsIgnoreCase(operType)) {
						condiPiece += "'";
					}

				}

				// 处理如{time}这样的问题
				String name = (String) map.get("name");
				if (sql.matches(".*\\{" + name + "\\}.*")) {
					sql = sql.replaceAll("\\{" + name + "\\}", defaultTime);
				}
			} else if ("comp:city".equalsIgnoreCase(datasource)) {

				if (!"0".equalsIgnoreCase(report.getRegionId())) {
					condiPiece += " and " + dbname + "='" + bassDimHelper.areaIdMap.get(report.getRegionId()) + "'";
				}
				colPiece = "(select value(max(number),99999) from REP_AREA_REGION where area_code=" + dbname + ") city_order, value((select alias_area_name from (select area_code alias_area_code,area_name alias_area_name from bt_area) alias_t1 where alias_area_code=" + dbname + "),case when grouping(" + dbname
						+ ")=1 then '总计' else " + dbname + " end) city";
				// colPiece="value((select alias_area_name from (select area_code alias_area_code,area_name alias_area_name from mk.bt_area) alias_t1 where alias_area_code="+dbname+"),'总计') city";
				groupPiece = "rollup(" + dbname + ")";
			}
		}

		String result = sql.replaceAll("\\{condiPiece\\}", condiPiece).replaceAll("\\{colPiece\\}", colPiece).replaceAll("\\{groupPiece\\}", groupPiece).replaceAll("\\{orderPiece\\}", orderPiece);
		LOG.info("sql结果：" + result);
		return result;
	}

	/**
	 * 下载的表头
	 * 
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map genDownHeader(int id) {
		Map downHeader = new HashMap();
		List list = (List) jdbcTemplate.queryForList("select name,data_index from FPF_IRS_SUBJECT_INDICATOR where sid=? ", new Object[] { id });

		for (int i = 0; i < list.size(); i++) {
			Map map = (Map) list.get(i);
			String dataIndex = ((String) map.get("data_index")).toUpperCase();
			String name = (String) map.get("name");
			String[] arrName = name.split(",");
			if (arrName.length > 1) {
				List names = new ArrayList();
				for (int j = 0; j < arrName.length; j++) {
					names.add(arrName[j]);
				}
				downHeader.put(dataIndex, names);
			} else {
				downHeader.put(dataIndex, name);
			}
		}
		return downHeader;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String initDimensionPiece(Report report,String condition) {
		List list = (List) jdbcTemplate.queryForList("select label,name,dbname,opertype,datasource,defval from FPF_IRS_SUBJECT_DIM where sid=? order by seq", new Object[] { Integer.valueOf(report.getId()) });
		int num = 3;
		StringBuilder sb = new StringBuilder();
		if (list != null && list.size() > 0) {
			sb.append("<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>");

			int count = list.size() % num == 0 ? list.size() : (list.size() / num + 1) * num;

			for (int i = 0; i < count; i++) {
				if (i % num == 0) {
					sb.append("<tr class='dim_row'>");
				}

				if (i >= list.size()) {
					sb.append("<td class='dim_cell_title'></td>").append("<td class='dim_cell_content'></td>");
				} else {
					Map map = (Map) list.get(i);
					String content = "";
					String detail = "";
					String datasource = (String) map.get("datasource");
					String label = (String) map.get("label");
					String name = (String) map.get("name");
					String dbname = (String) map.get("dbname");
					String operType = (String) map.get("opertype");
					String defval = (String) map.get("defval");

					try {
						if (("comp:date".equalsIgnoreCase(datasource) || "comp:month".equalsIgnoreCase(datasource)) && report.getMaxTime().length() > 0) {
							String _maxTime = null;
							if(null != report.getMaxTime() && report.getMaxTime().toUpperCase().startsWith("SELECT")){
								if (report.getDs().equalsIgnoreCase("web")) {
									_maxTime = (String) jdbcTemplate.queryForObject(report.getMaxTime(), String.class);
								} else if (report.getDs().equalsIgnoreCase("nl")) {
									_maxTime = (String) jdbcTemplateNl.queryForObject(report.getMaxTime(), String.class);
								} else {
									_maxTime = (String) jdbcTemplateDw.queryForObject(report.getMaxTime(), String.class);
								}
							}else{
								_maxTime = report.getMaxTime();
							}
							if (_maxTime != null) {
								defval = _maxTime;
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}

					if ("between".equalsIgnoreCase(operType)) {
						content = "<input class=form_input_between id=from_" + name + " name=from_" + name + "> 到 <input class=form_input_between name=" + name + ">";
					} else if ("range".equalsIgnoreCase(operType)) {
						content = "<select class=form_input_between id=range_" + name
								+ "><option selected value='='>等于</option><option value='>'>大于</option><option value='<'>小于</option><option value='>='>大于等于</option><option value='<='>小于等于</option></select> <input style='padding-left:5px;' class=form_input_between name=" + name + ">";
					} else if ("comp:date".equalsIgnoreCase(datasource)) {
						content = bassDimHelper.time(name, "yyyyMMdd", defval);
					} else if ("comp:month".equalsIgnoreCase(datasource)) {
						content = bassDimHelper.time(name, "yyyyMM", defval);
					} else if ("comp:city".equalsIgnoreCase(datasource)) {

						if ("true".equalsIgnoreCase(report.getIsAreaAll())) {
							content = bassDimHelper.areaCodeHtml(name, report.getRegionId(), "areacombo(1)", true);
						} else {
							content = bassDimHelper.areaCodeHtml(name, report.getRegionId(), "areacombo(1)");
						}
					} else if ("comp:county".equalsIgnoreCase(datasource)) {
						content = bassDimHelper.comboSeleclHtml(name);
						detail = " <input id='countyDetail' type='checkbox'>细分";
					} else if ("comp:channel".equalsIgnoreCase(datasource)) {
						content = "<input type='text' name='" + name + "'>";
						detail = " <input id='channelDetail' type='checkbox'>细分";
					} else if ("comp:county_bureau".equalsIgnoreCase(datasource)) {
						content = bassDimHelper.comboSeleclHtml(name, "areacombo(2)");
						detail = " <input id='countyDetail' type='checkbox'>细分";
					} else if ("comp:marketing_center".equalsIgnoreCase(datasource)) {
						content = bassDimHelper.comboSeleclHtml(name, "areacombo(3)");
						detail = " <input id='mcDetail' type='checkbox'>细分";
					} else if ("comp:town".equalsIgnoreCase(datasource)) {
						content = bassDimHelper.comboSeleclHtml(name, "areacombo(4)");
						detail = " <input id='townDetail' type='checkbox'>细分";
					} else if ("comp:cell".equalsIgnoreCase(datasource)) {
						content = bassDimHelper.comboSeleclHtml(name);
						detail = " <input id='cellDetail' type='checkbox'>细分";
					} else if ("comp:college".equalsIgnoreCase(datasource)) {
						content = bassDimHelper.comboSeleclHtml(name);
						detail = " <input id='collegeDetail' type='checkbox'>细分";
					} else if ("comp:entCounty".equalsIgnoreCase(datasource)) {
						content = bassDimHelper.comboSeleclHtml(name, "areacombo(2)");
						detail = " <input id='entCountyDetail' type='checkbox'>细分";
					} else if ("comp:custmgr".equalsIgnoreCase(datasource)) {
						content = bassDimHelper.comboSeleclHtml(name, "areacombo(3)");
						detail = " <input id='custmgrDetail' type='checkbox'>细分";
					} else if (datasource.startsWith("comp:")) {
						content = bassDimHelper.selectHtml(datasource.replace("comp:", ""));
					} else if (datasource.startsWith("select:")) {
						String tem = datasource.replaceAll("select:", "");
						Object obj = JsonHelper.getInstance().read(tem);
						if (obj instanceof List) {
							List options = (List) obj;
							if (options.size() > 0){
								String region = (String)bassDimHelper.areaCodeMap.get(report.getRegionId());
								for(int j=0;j<options.size();j++){
									Map mapRegion = (Map) options.get(j);
									if(mapRegion.get("value").equals(region)){
										mapRegion.put("selected", true);
										break ;
									}
								}
								content = bassDimHelper.renderSelect(name, options);
							}
						}

					} else if (datasource.startsWith("input:")) {
						if(condition!=null && !"null".equals(condition)){
							condition = condition.replaceAll("\\$", "#");
							if(condition.indexOf("#")>-1){
								String[] conditions = condition.split("#");
								if(name.toUpperCase().equals(conditions[0].toUpperCase())){
									content = "<input type='text' value='"+conditions[1]+"' name='" + name + "' >";
								}else{
									content = "<input type='text' name='" + name + " ' value=''>";
								}
							}else{
								content = "<input type='text' name='" + name + " ' value=''>";
							}
//							content = "<input type='text' name='" + name + "' value='111111'>";
						}else{
							content = "<input type='text' name='" + name + "' value=''>";
						}
					} else if (datasource.startsWith("sql:")) {
						String tem = datasource.replaceAll("sql:", "");
						// SQLQuery
						// sqlQuery1=SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT,
						// null, false);
						List options = null;
						try {

							if (report.getDs().equalsIgnoreCase("web")) {
								options = (List) jdbcTemplate.queryForList(tem);
							} else if (report.getDs().equalsIgnoreCase("nl")) {
								options = (List) jdbcTemplateNl.queryForList(tem);
							} else {
								options = (List) jdbcTemplateDw.queryForList(tem);
							}
						} catch (Exception e) {
							e.printStackTrace();
						}
						//if (options != null && options.size() > 0)
							content = bassDimHelper.renderSelect(name, options);
					}

					if ("comp:date".equalsIgnoreCase(datasource) || "comp:month".equalsIgnoreCase(datasource)) {
						sb.append("<td class='dim_cell_title'><span onclick='swichDate()' title='点击切换时间类型' style='cursor:hand;font-size: 12px'>" + label + detail + "</span> <span style='display:none;font-size: 12px'><input id='timeDetail' type='checkbox' checked='checked'>细分 </span></td>");
					} else {
						sb.append("<td class='dim_cell_title'>" + label + detail + "</td>");
					}

					if (datasource == null || datasource.length() == 0) {
						content = "<input type='hidden' name='" + name + "'>";
					}

					sb.append("<td class='dim_cell_content'><dim id='aidim_" + name + "' name='" + name + "' dbName=\"" + dbname + "\" operType=\"" + operType + "\">" + content + "</dim></td>");

				}

				if (i % num == (num - 1)) {
					sb.append("</tr>");
				}
			}

			sb.append("</table>");
		}
		LOG.info("DimensionPiece结果：" + sb.toString());
		return sb.toString();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String initHeaderPiece(Report report) {
		String headerData = "[]";
		List list = jdbcTemplate.queryForList("select name,data_index,value(cell_func,'') cell_func,value(cell_style,'') cell_style,value(title,'')title from FPF_IRS_SUBJECT_INDICATOR where sid=? order by seq ", new Object[] { Integer.valueOf(report.getId()) });

		for (int i = 0; i < list.size(); i++) {
			Map map = (Map) list.get(i);

			List names = new ArrayList();

			String[] arrName = ((String) map.get("name")).split(",");

			for (int j = 0; j < arrName.length; j++) {
				names.add(arrName[j]);
			}

			map.put("name", names);

			Object obj = map.get("data_index");
			map.put("dataIndex", String.valueOf(obj).toLowerCase());
			map.remove("data_index");

			obj = map.get("cell_func");
			map.put("cellFunc", obj);
			map.remove("cell_func");

			obj = map.get("cell_style");
			map.put("cellStyle", obj);
			map.remove("cell_style");
		}

		headerData = JsonHelper.getInstance().write(list);
		LOG.info("head查询结果：" + headerData);
		return headerData;
	}

	@SuppressWarnings("rawtypes")
	public List getCorrealtiveReport(Report report) {
		LOG.info("id=" + report.getId());
		List list=new ArrayList();
		try{
		String sql = " select id,name,desc,kind,dy_uname from FPF_bir_subject_correlation" + " ,(" + " select a.*" + " ,case when kind='动态' and a.status='开发' then value((select area_name from bt_area where int(cityid)=area_id),'省公司')||username end dy_uname from FPF_IRS_SUBJECT a" + " left join FPF_IRS_PACKAGE b on a.pid=b.id"
				+ " left join FPF_USER_USER c on b.user_id=c.userid" + " where ((kind='配置' and a.status='在用') or kind='动态') " + " ) t " + " where SOURCE=? and target=id order by value desc fetch first 30 rows only with ur";

		 list = (List) jdbcTemplate.queryForList(sql, new Object[] { Integer.valueOf(report.getId()) });
		LOG.info("getCorrealtiveReport执行结束");
		}catch(Exception e){
			e.printStackTrace();
		}
		return list;
	}

	public void saveCode(Integer sid, String code) {
		jdbcTemplate.update("delete from FPF_IRS_SUBJECT_EXT where sid=? and code='Code'", new Object[] { sid });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Code',?)", new Object[] { sid, code });
	}

	public void saveSQL(int sid, String sql, String grid, String maxTime, String cache, String ds, String excel, String chart, String areaAll) {
		jdbcTemplate.update("delete from FPF_IRS_SUBJECT_EXT where sid=? and code in ('SQL','Grid','MaxTime','DS','Cache','UseExcel','UseChart','AreaAll')", new Object[] { sid });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'SQL',?)", new Object[] { sid, sql });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Grid',?)", new Object[] { sid, grid });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'MaxTime',?)", new Object[] { sid, maxTime });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Cache',?)", new Object[] { sid, cache });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'DS',?)", new Object[] { sid, ds });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'UseExcel',?)", new Object[] { sid, excel });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'UseChart',?)", new Object[] { sid, chart });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'AreaAll',?)", new Object[] { sid, areaAll });
	}

	public void delDim(int sid, String name) {
		jdbcTemplate.update("delete from FPF_IRS_SUBJECT_DIM where sid=? and name=?", new Object[] { sid, name });
		jdbcTemplate.update("delete from FPF_IRS_SUBJECT_DIM where sid=? and name=?", new Object[] { sid, name });
	}

	public void saveDim(int sid, String label, String name, String dbname, String opertype, String defval, String datasource, int seq) {
		jdbcTemplate.update("delete from FPF_IRS_SUBJECT_DIM where sid=? and name=?", new Object[] { sid, name });

		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_DIM(sid,label,name,dbname,opertype,defval,datasource,seq) values(?,?,?,?,?,?,?,?)", new Object[] { sid, label, name, dbname, opertype, defval, datasource, seq });
	}

	@SuppressWarnings("rawtypes")
	public void saveHeader(final int sid, final List list) throws Exception {

		jdbcTemplate.update("delete from FPF_IRS_SUBJECT_INDICATOR where sid=?", new Object[] { sid });

		jdbcTemplate.batchUpdate("insert into FPF_IRS_SUBJECT_INDICATOR(sid,name,data_index,cell_func,cell_style,title,seq) values(?,?,?,?,?,?,?)", new BatchPreparedStatementSetter() {

			public void setValues(PreparedStatement ps, int i) throws SQLException {
				Map map = (Map) list.get(i);
				List names = (List) map.get("name");

				String name = "";

				for (int j = 0; j < names.size(); j++) {
					if (name.length() > 0)
						name += ",";

					name += names.get(j);
				}
				ps.setInt(1, sid);
				ps.setString(2, name);
				ps.setString(3, (String) map.get("dataIndex"));
				ps.setString(4, (String) map.get("cellFunc"));
				ps.setString(5, (String) map.get("cellStyle"));
				ps.setString(6, (String) map.get("title"));
				ps.setInt(7, i + 1);
			}

			public int getBatchSize() {
				return list.size();
			}
		});
	}

	public void save(String name, String desc, String user, String proc, String resp, String source_table, String caliber_descript) throws Exception {
		int subjectId = jdbcTemplate.queryForObject("values nextval for IRS_SUBJECT_id",Integer.class);
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT(id,name,desc,user_id,kind,caliber_descript) values(?,?,?,?,'配置',?)", new Object[] { subjectId, name, desc, user, caliber_descript });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Proc',?)", new Object[] { subjectId, proc });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Resp',?)", new Object[] { subjectId, resp });
		int index = source_table.indexOf(",");
		if (index > -1) {
			String[] source_tables = source_table.split(",");
			for (int i = 0; i < source_tables.length; i++) {
				jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'SrcTab" + i + "',?)", new Object[] { subjectId, source_tables[i] });
			}
		} else {
			jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'SrcTab',?)", new Object[] { subjectId, source_table });
		}
	}

	public void update(int sid, String name, String desc, String user, String proc, String resp, String source_table, String caliber_descript) throws Exception {
		jdbcTemplate.update("update FPF_IRS_SUBJECT set name=?,desc=?,user_id=?,caliber_descript=? where id =?", new Object[] { name, desc, user, caliber_descript, sid });
		jdbcTemplate.update("delete from FPF_IRS_SUBJECT_EXT where sid =? and (code in ('Proc','Resp') or code like 'SrcTab%') ", new Object[] { sid });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Proc',?)", new Object[] { sid, proc });
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'Resp',?)", new Object[] { sid, resp });
		int index = source_table.indexOf(",");
		if (index > -1) {
			String[] source_tables = source_table.split(",");
			for (int i = 0; i < source_tables.length; i++) {
				jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'SrcTab" + i + "',?)", new Object[] { sid, source_tables[i] });
			}
		} else {
			jdbcTemplate.update("insert into FPF_IRS_SUBJECT_EXT(sid,code,value) values(?,'SrcTab',?)", new Object[] { sid, source_table });
		}
	}

	@SuppressWarnings("rawtypes")
	public List getDim() {
		return jdbcTemplateDw.queryForList("select distinct name,tagname from dim_total order by name with ur");
	}

	@SuppressWarnings("rawtypes")
	public String getCaliber(int sid) {
		LOG.info("getCaliber查询：" + sid);
		String caliber = "";
		Map map = new HashMap();
		String sql="select caliber_descript from FPF_IRS_SUBJECT where id=?";
		for(Map<String, Object> Main:jdbcTemplate.queryForList(sql,  new Object[] { sid })){
			map=Main;
		}
		//Map map = jdbcTemplate.queryForMap("select caliber_descript from FPF_IRS_SUBJECT where id=?", new Object[] { sid });
		if ((String) map.get("caliber_descript") == null) {
			caliber = "";
		} else {
			caliber = (String) map.get("caliber_descript");
		}
		LOG.info("getCaliber查询结束");
		return caliber;
	}
	
	@SuppressWarnings("rawtypes")
	public String getReportStatus(int sid){
		String status = "";
		Map map = jdbcTemplate.queryForMap("select status from FPF_IRS_SUBJECT where id=?", new Object[] { sid });
		if ((String) map.get("status") == null) {
			status = "";
		} else {
			status = (String) map.get("STATUS");
		}
		return status;
	}
	public void inservalue(String id ,String userid){
		String hql="INSERT INTO FPF_VISITLIST(loginname,opername,create_dt) VALUES ('"+userid+"','"+id+"',CURRENT DATE)";
		 try {
			int a=jdbcTemplate.update(hql);
			System.out.println(a);
		} catch (DataAccessException e) {
				e.printStackTrace();
		}
	}
	
}
