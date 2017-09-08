package com.asiainfo.hb.bass.role.adaptation.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.asiainfo.hb.bass.role.adaptation.service.AdapService;
import com.asiainfo.hb.core.datastore.SqlPageHelper;
import com.asiainfo.hb.core.datastore.SqlserverSqlPageHelper;
import com.asiainfo.hb.core.models.BaseDao;
@SuppressWarnings("rawtypes")
@Repository
public class AdapDao extends BaseDao implements AdapService {

	@Override
	public List getHotKpisTop(String mid, String userId) {
		
		if (mid == null || "".equals(mid)) {
			return null;
		}
		if (Integer.parseInt(mid) != -1) {
			return jdbcTemplate.queryForList(
					"with rpl(id,name,pid) as "
							+ "(select id,name,pid from boc_indicator_menu where pid = ? union all select b.id,b.name,b.pid from rpl a,boc_indicator_menu b where a.id = b.pid) "
							+ "select r.id,r.name as text ,count,  ROW_NUMBER() OVER() as num from (SELECT id,name FROM RPL )r ,(select count(*)  count,opername  from FPF_VISITLIST where create_dt between current timestamp - 1 months and current timestamp  group by opername ) v where char(r.id) = v.opername order by count desc fetch first 5 rows only with ur",
					new Object[] { Integer.parseInt(mid) });
		} else {
			String sql = "select r.id, r.name as text, U_count as remark, ROW_NUMBER() OVER() as num "
					+ "  from (select id, name, pid  from boc_indicator_menu b "
					+ "  right join FPF_IRS_FAVORITES f on f.resource_id = char(b.id) where f.CREATER_ID = ? and f.menu_id = -1) r, "
					+ " (select count(*) U_count, opername  from FPF_VISITLIST "
					+ " where create_dt between current timestamp - 1 months and current "
					+ "  timestamp  group by opername) v where char(r.id) = v.opername "
					+ " order by U_count desc fetch first 5 rows only with ur";
			return jdbcTemplate.queryForList(sql, userId);
		}
	}

	@Override
	public List getRelaReports(String mid, String sid, String userId) {
		
		 List<Map<String, Object>> list =new ArrayList<Map<String,Object>>();
		if (mid == null || "".equals(mid)) {
			return null;
		}
		try {
			String sql = "";
			if (Integer.parseInt(mid) != -1) {
				sql = " select resource_id id,resource_uri uri,resource_name text,value(U_count,0) remark,ROW_NUMBER() over() num " +
						" from FPF_IRS_RESOURCE a left join (select opername, count(*) U_count from FPF_VISITLIST " +
						" where date(create_dt) >= (current date - 30 days) and date(create_dt) <= current date group by opername) b " +
						" on a.resource_id=b.opername inner join(select id, name from BOC_INDICATOR_MENU where deep = 1) c " +
						" on a.menu_id = c.id inner join (select id from FPF_IRS_RESOURCETYPE where resource_name = '报表') d " +
						" on d.id=a.type_id where c.id = ? and state = '在用' order by remark desc FETCH FIRST 5 ROWS ONLY with ur";
				list=jdbcTemplate.queryForList(sql, Integer.parseInt(mid));
				return list; 
			} else {
				if (sid == null || "".equals(sid)) {
					sql = "select replace(a.resource_id,' ','') id,resource_uri uri,resource_name text,type_id type, "
							+ "menu_id,U_count remark,row_number() over() num from FPF_IRS_RESOURCE a, "
							+ " (select opername rid, count(*) U_count from FPF_VISITLIST "
							+ " where date(create_dt) >= (current date - 30 days) "
							+ " and date(create_dt) <= current date group by opername) b, "
							+ " (select f.resource_id rid, f.user_id from FPF_IRS_FAVORITES f) d "
							+ " where state = '在用' and (a.type_id = 2 ) and b.rid = d.rid AND d.user_id = ?"
							+ " and a.resource_id = d.rid   order by U_count desc FETCH FIRST 5 ROWS ONLY with ur";
				} else {
					sql = "select replace(a.resource_id,' ','') id,resource_uri uri,resource_name text,type_id type, "
							+ "menu_id,U_count remark,row_number() over() num from FPF_IRS_RESOURCE a, "
							+ " (select opername rid, count(*) U_count from FPF_VISITLIST "
							+ " where date(create_dt) >= (current date - 30 days) "
							+ " and date(create_dt) <= current date group by opername) b, "
							+ " (select f.resource_id rid, f.user_id from FPF_IRS_FAVORITES f where f.MENU_ID=" + sid
							+ ") d " + " where state = '在用' and (a.type_id = 2 ) and b.rid = d.rid AND d.user_id = ?"
							+ " and a.resource_id = d.rid   order by U_count desc FETCH FIRST 5 ROWS ONLY with ur";
				}
				
				return jdbcTemplate.queryForList(sql, userId);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List getReportSortTop(String mid, String sid, String userId) {
		
		List<Map<String, Object>> list = null;
		try {
			String sql = "SELECT A.ID,A.NAME as text,(SELECT resource_uri FROM FPF_IRS_RESOURCE where resource_id= a.id and type_id=2) as URI,A.PID, VALUE(B.count,0),0 level,ROW_NUMBER() over() as num FROM FPF_IRS_RESOURCE_SORT A "
					+ " left JOIN (SELECT COUNT(*) count,IRS_RESOURCE_SORT_ID ID FROM FPF_IRS_RESOURCE GROUP BY IRS_RESOURCE_SORT_ID )"
					+ " B ON A.ID = B.ID " + " where A.MENU_ID = char(" + mid
					+ ") ORDER BY A.SORT FETCH FIRST 5 ROWS ONLY";
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List getRelaApps(String mid, String sid, String userId) {
		
		if (mid == null || "".equals(mid)) {
			return null;
		}
		try {
			String sql = "";
			if (Integer.parseInt(mid) != -1) {
				sql = "select t.name as text,t.uri,t.id,t.count as remark,t.menu_id,row_number() over() num from (select a.resource_id id,resource_uri uri,"
						+ " resource_name name ,type_id type,menu_id ,value(count,0) count from FPF_IRS_RESOURCE "
						+ " a left join (select opername,count(*) count from FPF_VISITLIST where "
						+ " date(create_dt)>=(current date - 30 days) and date(create_dt)<=current date "
						+ " group by opername) b on a.resource_id = b.opername inner join "
						+ "(select id,name from BOC_INDICATOR_MENU where deep=1) c on c.id=a.menu_id inner join "
						+ "(select id typeid,resource_type ttype from FPF_IRS_RESOURCETYPE ) d "
						+ " on a.type_id = d.typeid where c.id=? and d.ttype='应用'and state='在用' and  a.resource_id!='app9' "
						+ " order by count desc FETCH FIRST 5 ROWS ONLY ) t with ur";

				return jdbcTemplate.queryForList(sql, Integer.parseInt(mid));
			} else {
				if (sid == null || "".equals(sid)) {
					sql = "select a.resource_id id,resource_uri uri,resource_name text,type_id type, "
							+ "menu_id,count as remark,row_number() over() num from FPF_IRS_RESOURCE a, "
							+ " (select opername rid, count(*) count from FPF_VISITLIST "
							+ " where date(create_dt) >= (current date - 30 days) "
							+ " and date(create_dt) <= current date group by opername) b, "
							+ " (select f.resource_id rid, f.user_id from FPF_IRS_FAVORITES f) d "
							+ " where state = '在用' and (a.type_id = 3 or a.type_id = 4) and b.rid = d.rid AND d.user_id = ?"
							+ " and a.resource_id = d.rid  ";
				} else {
					sql = "select a.resource_id id,resource_uri uri,resource_name text,type_id type, "
							+ "menu_id,count as remark,row_number() over() num from FPF_IRS_RESOURCE a, "
							+ " (select opername rid, count(*) count from FPF_VISITLIST "
							+ " where date(create_dt) >= (current date - 30 days) "
							+ " and date(create_dt) <= current date group by opername) b, "
							+ " (select f.resource_id rid, f.user_id from FPF_IRS_FAVORITES f where f.MENU_ID=" + sid
							+ ") d "
							+ " where state = '在用' and (a.type_id = 3 or a.type_id = 4) and b.rid = d.rid AND d.user_id = ?"
							+ " and a.resource_id = d.rid  " + " order by count desc FETCH FIRST 5 ROWS ONLY with ur";
				}

				return jdbcTemplate.queryForList(sql, userId);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List getLastOnlineReport(String mid, String sid, String userId) {
		
		
		String sql ="select r.resource_id id,char(date(lastupdate)) dt,resource_name name,resource_desc desc from FPF_irs_resource r "
				+ "where r.state='在用' and length(lastupdate)>0  order by lastupdate desc fetch first 30 rows only with ur";
		
		return jdbcTemplate.queryForList(sql);
		/*
		if (mid == null) {
			return null;
		}
		try {
			if (Integer.parseInt(mid) == -1) {
				if (sid == null || "".equals(sid)) {
					return jdbcTemplate.queryForList("select a.resource_id id, resource_uri uri, resource_name name,"
							+ " resource_desc desc, ROW_NUMBER() over() rownum, create_dt dt,a.resource_img  from FPF_IRS_RESOURCE a,"
							+ " (select resource_id, CREATER_ID from FPF_IRS_FAVORITES where CREATER_ID = ?) c"
							+ " where a.resource_id = c.resource_id and state = '在用' "
							+ "AND (type_id in (select id from FPF_IRS_RESOURCETYPE where resource_name = '报表'))"
							+ " order by a.create_dt desc FETCH FIRST 5 ROWS ONLY with ur", userId);
				} else {
					return jdbcTemplate.queryForList("select a.resource_id id, resource_uri uri, resource_name name,"
							+ " resource_desc desc, ROW_NUMBER() over() rownum, create_dt dt,a.resource_img  from FPF_IRS_RESOURCE a,"
							+ " (select resource_id, CREATER_ID from FPF_IRS_FAVORITES where CREATER_ID = ? and MENU_ID="
							+ sid + ") c" + " where a.resource_id = c.resource_id and state = '在用' "
							+ "AND (type_id in (select id from FPF_IRS_RESOURCETYPE where resource_name = '报表'))"
							+ " order by a.create_dt desc FETCH FIRST 5 ROWS ONLY with ur", userId);
				}

			} else {
				if (Integer.parseInt(mid) != -2) {
					return jdbcTemplate.queryForList(
							"select resource_id id, resource_uri uri, resource_name name,  resource_desc desc, "
									+ " ROW_NUMBER() over() rownum, create_dt dt,a.resource_img from FPF_IRS_RESOURCE a "
									+ " where a.menu_id = ? and state = '在用' "
									+ " AND (type_id in (select id from FPF_IRS_RESOURCETYPE where resource_name = '报表')) "
									+ " order by a.create_dt desc FETCH FIRST 5 ROWS ONLY with ur",
							Integer.parseInt(mid));
				} else {
					return jdbcTemplate
							.queryForList("select id,char(date(lastupd)) dt,name,kind,desc from fpf_irs_subject where "
									+ "status='在用' and kind='配置'  order by lastupd "
									+ " desc fetch first 30 rows only with ur");
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
		*/
	}
	@Override
	public List getTopKpi() {
		return jdbcTemplate.queryForList(
				"select kpi_name kpiname,count(1) ct from FPF_KPI_VISIT group by kpi_name order by ct desc fetch first 7 rows only");
	}
	/**
	 * 根据条件查询热门kpi
	 */
	public Map<String, Object> getAllTopKpi(Map<String, Object> params) throws Exception{
		String sql = "select kpi_name kpiname,count(1) ct from FPF_KPI_VISIT group by kpi_name ";
		String totalPage = "select count(*) from FPF_KPI_VISIT  ";
		String orderBy = "ct desc";
		return getResultMap(params,sql,totalPage,orderBy,null);
	}
	
	@Override
	public List getTopThreeNews() {
		return jdbcTemplate.queryForList(
				"select newsid,TO_CHAR(newsdate,'YYYY-MM-DD HH24:MI:SS') as newsdate,newstitle,newsmsg,valid_begin_date,valid_end_date,creator from FPF_USER_NEWS order by newsdate desc,valid_begin_date desc fetch first 30 rows only with ur");
	}
	
	/**
	 * 根据条件查询最新上线
	 */
	public Map<String, Object> getAllLastOnlineReport(Map<String, Object> params) throws Exception{
//		String sql = "SELECT ID,CHAR(DATE(LASTUPD)) DT,NAME,KIND,DESC FROM ST.FPF_IRS_RESOURCE WHERE STATUS='在用' AND KIND='配置' ";
//		String totalPage = "select count(*) from fpf_irs_subject where status='在用' and kind='配置' ";
		String sql1 = "SELECT a.RESOURCE_ID AS RID, A.RESOURCE_NAME AS NAME,VALUE(A.RESOURCE_DESC, '') AS DESC, "
				+"A.RESOURCE_URI AS URL, A.IRS_RESOURCE_SORT_ID AS SID, VALUE(DATA_LAST_UPD, '') AS DT "
//				+"(SELECT COUNT(*)"
//				+"FROM FPF_IRS_FAVORITES"
//				+"WHERE USER_ID = 'admin'"
//				+"AND RESOURCE_ID = a.resource_id ) AS favsNum"
				+"FROM FPF_IRS_RESOURCE a, FPF_IRS_RESOURCE_SORT B "
				+"WHERE a.STATE = '在用' AND (a.TYPE_ID IN (SELECT id "
				+"FROM FPF_IRS_RESOURCETYPE WHERE resource_name = '报表') "
				+"OR a.TYPE_ID IN (SELECT id FROM FPF_IRS_RESOURCETYPE "
				+"WHERE RESOURCE_NAME = '自定义报表')) AND B.ID = A.IRS_RESOURCE_SORT_ID";
//				+"ORDER BY A.IRS_RESOURCE_SORT_ID, A.sort";
		String totalPage1 = "SELECT  COUNT(*) CNT FROM FPF_IRS_RESOURCE a, FPF_IRS_RESOURCE_SORT B "
				+"WHERE a.STATE = '在用' AND (a.TYPE_ID IN (SELECT id "
				+"FROM FPF_IRS_RESOURCETYPE WHERE RESOURCE_NAME = '报表') "
				+"OR a.TYPE_ID IN (SELECT id FROM FPF_IRS_RESOURCETYPE "
				+"WHERE RESOURCE_NAME = '自定义报表')) "
				+"AND B.ID = A.IRS_RESOURCE_SORT_ID ";
		
		String orderBy = " dt desc ";
		return getResultMap(params,sql1,totalPage1,orderBy,null);
	}
	
	/**
	 * 根据条件查询公告信息
	 */
	@Override
	public Map<String, Object> getAllNotice(Map<String, Object> params) throws Exception{
		String sql = "select newsid,TO_CHAR(newsdate,'YYYY-MM-DD HH24:MI:SS') as newsdate,newstitle,newsmsg,valid_begin_date,creator from FPF_USER_NEWS where 1=1 ";
		String totalPage = "select count(*) from FPF_USER_NEWS where 1=1 ";
		String orderBy = " newsdate desc,valid_begin_date desc ";
		return getResultMap(params,sql,totalPage,orderBy,"newsdate");
	}
	
	private Map<String, Object> getResultMap(Map<String, Object> params,String sql, String totalPage, String orderBy, String timeParams) throws Exception{
		int pageSize = 20;
		int pageNum = 1;
		String condition = "";
		List<String> list = new ArrayList<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		SqlPageHelper sqlPageHelper = new SqlserverSqlPageHelper();
		for(String key : params.keySet()){
			if(params.get(key) == null){
				continue;
			}
			String val = params.get(key).toString().trim();
			if (key.equalsIgnoreCase("startDate") && StringUtils.hasText(val)) {//查询的开始时间
				condition += " and "+timeParams+" > to_date(?,'yyyy-MM-dd') ";
				list.add(val);
				continue;
			}else if (key.equalsIgnoreCase("endDate") && StringUtils.hasText(val)) {//查询的结束时间
				condition += " and "+timeParams+" < to_date(?,'yyyy-MM-dd') ";
				list.add(val);
				continue;
			}else if (key.equalsIgnoreCase("pageSize") && StringUtils.hasText(val)) {//一页显示行数
				pageSize = Integer.parseInt(val);
				continue;
			}else if (key.equalsIgnoreCase("pageNum") && StringUtils.hasText(val)) {//当前页
				pageNum = Integer.parseInt(val);
				continue;
			}else if(StringUtils.hasText(val)){//其他查询字段
				condition += " and "+key+" like ? ";
				list.add("%" + val + "%");
			}
		}
		sql += condition;
		totalPage += condition;
		sql = sqlPageHelper.getLimitSQL(sql, pageSize, (pageNum - 1) * pageSize, orderBy);
		map.put("total", jdbcTemplate.queryForObject(totalPage,Integer.class, list.toArray()));
		map.put("rows", jdbcTemplate.queryForList(sql, list.toArray()));
		return map;
	}

	@Override
	public List getRelaCollect(String mid, String sid, String userId) {
		
		if (mid == null) {
			return null;
		}
		try {
			if (Integer.parseInt(mid) == -1) {
				if (sid == null || "".equals(sid)) {
					return jdbcTemplate.queryForList("select a.resource_id id, resource_uri uri, resource_name text,"
							+ "type_id type, menu_id,count remark, row_number() over() num"
							+ "  from FPF_IRS_RESOURCE a,"
							+ "  (select resource_id rid, count(*) count from FPF_IRS_FAVORITES where user_id = ?  group by resource_id) b"
							+ " where state = '在用' and a.resource_id = b.rid"
							+ " order by count desc FETCH FIRST 5 ROWS ONLY with ur", userId);
				} else {
					return jdbcTemplate.queryForList("select a.resource_id id, resource_uri uri, resource_name text,"
							+ "type_id type, menu_id,count remark, row_number() over() num"
							+ "  from FPF_IRS_RESOURCE a,"
							+ "  (select resource_id rid, count(*) count from FPF_IRS_FAVORITES where user_id = ? and menu_id = "
							+ sid + " group by resource_id) b" + " where state = '在用' and a.resource_id = b.rid"
							+ " order by count desc FETCH FIRST 5 ROWS ONLY with ur", userId);
				}
			} else {
				return jdbcTemplate.queryForList("select a.resource_id id, resource_uri uri, resource_name text,"
						+ " type_id type, menu_id,count remark, row_number() over() num" + "  from FPF_IRS_RESOURCE a,"
						+ " (select resource_id rid, count(*) count from FPF_IRS_FAVORITES where user_id = ? group by resource_id) b,"
						+ " (select id, name from BOC_INDICATOR_MENU where deep = 1) c"
						+ " where c.id = a.menu_id and c.id = ? and state = '在用'" + " and a.resource_id = b.rid"
						+ " order by count desc FETCH FIRST 5 ROWS ONLY with ur", userId, Integer.parseInt(mid));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List getCity(String provId) {
		List<Map<String, Object>> list = null;
		String sql = "";
		try {
			if (StringUtils.isEmpty(provId)) {
				sql = "select * from ST_DIM_CITY";
			} else {
				sql = "select * from ST_DIM_CITY" + " where prov_id='" + provId + "'";
			}
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List getCountry(String cityId) {
		List<Map<String, Object>> list = null;
		String sql = "";
		try {
			if (StringUtils.isEmpty(cityId)) {
				sql = "select * from ST_DIM_COUNTRY";
			} else {
				sql = "select * from ST_DIM_COUNTRY" + " where CITY_ID='" + cityId + "'";
			}
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List getMarket(String countyId) {
		List<Map<String, Object>> list = null;
		String sql = "";
		try {
			if (StringUtils.isEmpty(countyId)) {
				sql = "select * from ST_DIM_MARKET";
			} else {
				sql = "select * from ST_DIM_MARKET" + " where COUNTY_ID='" + countyId + "'";
			}
			list = jdbcTemplate.queryForList(sql);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@Override
	public List queryApplyAbiList() {
		String sql="select TYPE,USERNAME,MOBILE from fpf_IRS_APPLICATION_CHARGE";
		return jdbcTemplate.queryForList(sql);
	}

	@Override
	public int getNotice(Map map) {
		String sql ="update FPF_USER_NEWS set newstitle='"+map.get("newstitle")+"',newsmsg='"+map.get("newsmsg")+"',newsdate='"+map.get("newsdate")+"',creator='"+map.get("creator")+"' where newsid='"+map.get("newsid")+"'";
		return jdbcTemplate.update(sql);
	}

	@Override
	public int delNotce(Integer newsid) {
		String sql = "delete from FPF_USER_NEWS where newsid="+newsid;
		return jdbcTemplate.update(sql);
	}

}
