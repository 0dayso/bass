package com.asiainfo.bass.apps.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.Util;

/**
 * 
 * 
 * @author zhangwei
 * @date 2012-5-4
 */
@Repository
public class FinanceAdjustDao {

	//正式库
	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}
/*
	//仓库
	private JdbcTemplate jdbcTemplateDw;

	@Autowired
	public void setDataSourceDw(DataSource dataSourceDw) {
		this.jdbcTemplateDw = new JdbcTemplate(dataSourceDw);
	}

	//线库
	private JdbcTemplate jdbcTemplateNl;

	@Autowired
	public void setDataSourceNl(DataSource dataSourceNl) {
		this.jdbcTemplateNl = new JdbcTemplate(dataSourceNl);
	}
	*/
	@SuppressWarnings("rawtypes")
	public List getBatList() {
		return jdbcTemplate.queryForList("select REP_ID, REP_NAME, XML, REP_SQL from NMK.CFG_FINANCE_BAT order by REP_ID with ur");
	}
	
	/**
	 * 查询此rep_id是否已经存在
	 * @param rep_id
	 * @return 
	 */
	public int getBatCount(String rep_id){
		return jdbcTemplate.queryForObject("select count(*) from NMK.CFG_FINANCE_BAT where rep_id="+rep_id,Integer.class);
	}
	
	/**
	 * 新增
	 * @param rep_id
	 * @param rep_name
	 * @param xml
	 * @param rep_sql
	 */
	public void save(String rep_id, String rep_name, String xml, String rep_sql, String rep_papr, String type, String email, String phone){
		jdbcTemplate.update("insert into FPF_IRS_SUBJECT(rep_id,rep_name,xml,rep_sql,rep_papr, type, email, phone) values(?,?,?,?,?,?,?,?)", new Object[] { rep_id, rep_name, xml, rep_sql, rep_papr, type, email, phone });
	}
	
	/**
	 * 保存
	 * @param rep_id
	 * @param rep_name
	 * @param xml
	 * @param rep_sql
	 */
	public void update(String rep_id, String rep_name, String xml, String rep_sql, String rep_papr, String type, String email, String phone){
		jdbcTemplate.update("update NMK.CFG_FINANCE_BAT set rep_name=?,xml=?,rep_sql=?,rep_papr=?, type=?, email=?, phone=? where rep_id=?",  new Object[] { rep_name, xml, rep_sql, rep_papr, type, email, phone, rep_id });
	}
	
	public void delBat(String rep_id){
		jdbcTemplate.update("delete from NMK.CFG_FINANCE_BAT where rep_id =?",  new Object[] { rep_id });
	}
	
	@SuppressWarnings("rawtypes")
	public List getHistoryInfoList(){
		return jdbcTemplate.queryForList("SELECT MONTH_ID, ADJ_MONTH_ID , SERV_ID, ACCT_ITEM_TID, BILL_CHARGE, KIND FROM NWH.DW_ACCT_ITEM_ADJ_HIST ORDER BY MONTH_ID WITH UR");
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List getReportList(String menuid){
		//得到此模块下所有报表ID
		String getIdBySql = "select replace(resource_id,'C','') resource_id from (select replace(resource_id,'N','') resource_id from FPF_IRS_RESOURCE where type_id='2' and resource_id not like 'app%' and resource_id<>'REP048' and menu_id='"+menuid+"')";
		List result = new ArrayList();
		try {
			List listById = jdbcTemplate.queryForList(getIdBySql);
			//得到此模块下所有应用下报表ID
			if(listById!=null && listById.size()>0){
				for(int i=0;i<listById.size();i++){
					HashMap map = (HashMap)listById.get(i);
					String resource_id = String.valueOf(map.get("resource_id")).trim();
					Map<String,Object> info = getCountByReportId(resource_id);
					String count = String.valueOf(info.get("count"));
					String name = String.valueOf(info.get("name"));
					map.put("count", count);
					map.put("name", name);
					result.add(map);
				}
			}
		} catch (DataAccessException e) {
		
			e.printStackTrace();
		}
		return result;
	}
	
	@SuppressWarnings("rawtypes")
	public HashMap<String,Object> getCountByReportId(String resource_id){
		HashMap<String,Object> result = new HashMap<String,Object>();
		String time = Util.getTime(-1, "日");
		String sql = "select count from fpf_ratejob where time_id="+Integer.parseInt(time)+" and id="+Integer.parseInt(resource_id);
		String sql1 = "select name from FPF_IRS_SUBJECT where id="+Integer.parseInt(resource_id);
		List list = jdbcTemplate.queryForList(sql);
		List list1 = jdbcTemplate.queryForList(sql1);
		if(list!=null&&list.size()>0){
			HashMap countMap = (HashMap)list.get(0);
			result.put("count", countMap.get("count").toString());
		}else{
			result.put("count", "0");
		}
		if(list1!=null&&list1.size()>0){
			HashMap nameMap = (HashMap)list1.get(0);
			result.put("name", nameMap.get("name").toString());
		}
		return result;
	}
}

