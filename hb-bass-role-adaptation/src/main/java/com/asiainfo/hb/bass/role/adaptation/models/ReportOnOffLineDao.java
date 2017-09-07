package com.asiainfo.hb.bass.role.adaptation.models;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;
import com.asiainfo.hb.bass.role.adaptation.service.ReportOnOffLineService;
import com.asiainfo.hb.web.models.CommonDao;

@Repository
public class ReportOnOffLineDao extends CommonDao implements ReportOnOffLineService{

	@Override
	public Map<String, Object> getHasOnlineReport(String menuId, String reportName,String reportId, int perPage, int currentPage) {
		String rowSql = "select replace(resource_id,' ','') resource_id, resource_name,resource_uri, resource_desc, to_char(lastupdate,'YYYY-MM-DD HH24:MI:SS') lastupdate ," +
				" b.sort_name sort_name ,b.id sort_id, b.menu_name, b.menu_id, b.sort " +
				" from fpf_irs_resource a " +
				" left join (select s.id id,s.menu_id, s.name sort_name, s.sort, m.name menu_name from fpf_irs_resource_sort s " +
				" left join boc_indicator_menu m on s.menu_id=m.id) b " +
				" on a.irs_resource_sort_id = b.id " +
				" where 1=1";
		String countSql = "select count(1) from fpf_irs_resource a left join " +
				" fpf_irs_resource_sort b on a.irs_resource_sort_id = b.id where 1=1";
		
		StringBuffer condition = new StringBuffer();
		condition.append(" and type_id=2 and state='在用' ");
		if(!StringUtils.isEmpty(menuId)){
			condition.append(" and b.menu_id=").append(menuId);
		}
		if(!StringUtils.isEmpty(reportName)){
			condition.append(" and resource_name like '%").append(reportName).append("%'");
		}
		
		if(!StringUtils.isEmpty(reportId)){
			condition.append(" and resource_id like '%").append(reportId).append("%'");
		}
		return page(rowSql + condition.toString(), countSql  + condition.toString(),
				perPage, currentPage, " menu_id, sort, resource_name");
	}
	

	@Override
	public List<Map<String, Object>> getMenuList() {
		String sql = "select id, name from boc_indicator_menu  where pid is null order by id";
		return jdbcTemplate.queryForList(sql);
	}

	@Override
	public void offLineRpt(String reportId, String url) {
		String stateSql = "";
		if(url.indexOf("/ve/") > 0){
			String rid = url.substring(url.indexOf("/ve/") + 4);
			stateSql = "update doota_ve set state='下线' where id='" + rid + "'";
		}else{
			String rid = url.substring(url.indexOf("/report/") + 8);
			stateSql = "update fpf_irs_subject set status='下线' where id=" + rid ;
		}
		String delSql = "delete from fpf_irs_resource where resource_id=?";
		this.jdbcTemplate.update(stateSql);
		this.jdbcTemplate.update(delSql, new Object[]{reportId});
		
	}

	@Override
	public Map<String, Object> getWaitOnLineReport(String name, String id, int perPage, int currentPage) {
		String pageSql = "select id, name, descr, to_char(create_dt,'YYYY-MM-DD HH24:MI:SS') create_dt, state from doota_ve where 1=1 ";
		String countSql = "select count(1) from doota_ve where 1=1 ";
		StringBuffer condition = new StringBuffer();
		condition.append(" and state != '在用'");
		if(!StringUtils.isEmpty(name)){
			condition.append(" and name like '%").append(name).append("%'");
		}
		if(!StringUtils.isEmpty(id)){
			condition.append(" and id like '%").append(id).append("%'");
		}
		return page(pageSql + condition.toString(), countSql + condition.toString(), perPage, currentPage, " create_dt desc");
	}

	@Override
	public List<Map<String, Object>> getSortList(String menuId, String name) {
		String sql = "select a.id, menu_id, a.name, sort, b.name menu_name from fpf_irs_resource_sort a " +
				" left join boc_indicator_menu b on a.menu_id=b.id where 1=1";
		if(!StringUtils.isEmpty(menuId)){
			sql += " and menu_id=" + menuId;
		}
		if(!StringUtils.isEmpty(name)){
			sql += " and a.name like '%" + name + "%' ";
		}
		sql += " order by menu_id, sort";
		return this.jdbcTemplate.queryForList(sql);
	}

	@Override
	public void onLineRpt(String menuId, String sortId, String rid, String sortNum, String keyWord, String rptCycle) {
		String stateSql = "update doota_ve set state='在用' where id=?";
		String qrySql = "select * from doota_ve where id=?";
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");//可以方便地修改日期格式
		String sql = "insert into fpf_irs_resource (RESOURCE_ID,RESOURCE_URI,RESOURCE_NAME,TYPE_ID,MENU_ID,CREATE_DT,RESOURCE_DESC,CREATER_ID,LASTUPDATE," +
				"STATE,KEYWORDS,IRS_RESOURCE_SORT_ID,SORT,RESOURCE_CYCLE) values (?,?,?,?,?,'" + dateFormat.format(new Date()) + "',?,?,current TIMESTAMP,?,?,?,?,?)";
		
		Map<String, Object> detailMap = this.jdbcTemplate.queryForMap(qrySql, new Object[]{rid});
		this.jdbcTemplate.update(stateSql, new Object[]{rid});
		if("".equals(sortNum)){
			sortNum = null;
		}
		this.jdbcTemplate.update(sql, new Object[]{rid+"N", "/hubei-customer/ve/"+rid, detailMap.get("name"), 2, menuId, 
				detailMap.get("descr"), detailMap.get("user_id"), "在用", keyWord, sortId, sortNum, rptCycle});
	}

	@Override
	public void addRptSort(String menuId, String name, String sortNum) {
		if(StringUtils.isEmpty(sortNum)){
			String sortSql = "select value(max(sort),0) from fpf_irs_resource_sort where menu_id=" + menuId;
			int sort = this.jdbcTemplate.queryForObject(sortSql, Integer.class) + 1;
			sortNum = sort + "";
		}
		String idSql = "select value(max(id),0) from fpf_irs_resource_sort";
		int id = this.jdbcTemplate.queryForObject(idSql, Integer.class) + 1;
		String sql = "insert into fpf_irs_resource_sort (ID,MENU_ID,NAME,SORT) values(?,?,?,?)";
		this.jdbcTemplate.update(sql, new Object[]{id, menuId, name, sortNum});
	}

	@Override
	public void deleteRptSort(String ids) {
		String sql = "delete from fpf_irs_resource_sort where id in (" + ids + ")";
		String resSql = "update fpf_irs_resource set irs_resource_sort_id=null where irs_resource_sort_id in (" + ids + ")";
		this.jdbcTemplate.update(sql);
		this.jdbcTemplate.update(resSql);
	}

	@Override
	public void updateRptSort(String sortId, String menuId, String name,
			String sortNum) {
		if(StringUtils.isEmpty(sortNum)){
			String sortSql = "select value(max(sort),0) from fpf_irs_resource_sort where menu_id=" + menuId;
			int sort = this.jdbcTemplate.queryForObject(sortSql, Integer.class) + 1;
			sortNum = sort + "";
		}
		String sql = "update fpf_irs_resource_sort set menu_id=?,name=?,sort=? where id=?";
		this.jdbcTemplate.update(sql, new Object[]{menuId, name, sortNum, sortId});
		String resSql = "update fpf_irs_resource set menu_id=? where irs_resource_sort_id=?";
		this.jdbcTemplate.update(resSql, new Object[]{menuId, sortId});
	}


	@Override
	public void changeSort(String rid, String menuId, String sortId) {
		String sql = "update fpf_irs_resource set menu_id=?, irs_resource_sort_id=? where resource_id=?";
		this.jdbcTemplate.update(sql, new Object[]{menuId, sortId, rid});
	}

}
