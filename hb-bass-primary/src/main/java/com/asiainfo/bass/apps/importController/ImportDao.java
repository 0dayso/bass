package com.asiainfo.bass.apps.importController;

import java.util.HashMap;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.apps.log.LogActionDao;
import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
public class ImportDao {

@SuppressWarnings("unused")
private static Logger LOG = Logger.getLogger(LogActionDao.class);
	
	@Autowired
	private DataSource dataSource;

	@Autowired
	private DataSource dataSourceDw;

	@Autowired
	private DataSource dataSourceNl;
	
	@SuppressWarnings("rawtypes")
	public List getTempListByMonthId(String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		return jdbcTemplate.queryForList("select fee_id, taskid, fee_name from nmk.specail_gprs_fee_cfg_temp with ur");
	}
	
	public boolean checkInfo(String feeId, String monthId, String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		@SuppressWarnings("rawtypes")
		List list = jdbcTemplate.queryForList("select * from nmk.specail_gprs_fee_cfg where fee_id=? and update_time=?", new Object[] {feeId, monthId});
		boolean flag = false;
		if(list!=null && list.size()>0){
			flag = true;
		}
		return flag;
	}
	
	public void insert(String feeId, String feeName, String monthId, String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		jdbcTemplate.update("insert into nmk.specail_gprs_fee_cfg values(?,?,?)", new Object[] {feeId,feeName,monthId});
	}
	
	public void update(String feeId, String feeName, String monthId, String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		jdbcTemplate.update("update nmk.specail_gprs_fee_cfg set fee_name = ? where fee_id=? and update_time=?", new Object[] {feeName, feeId, monthId});
	}
	
	public void deleteTemp(String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		jdbcTemplate.update("delete from nmk.specail_gprs_fee_cfg_temp");
	}
	
	@SuppressWarnings("rawtypes")
	public List getTmpList(String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		return jdbcTemplate.queryForList("select task_id, acc_nbr, manager_accnbr from nmk.manager_mbuser_tmp with ur ");
	}
	
	public void updateTmpForRepeat(String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		jdbcTemplate.update("insert into nmk.manager_mbuser_view_tmp select * from nmk.manager_mbuser_tmp where acc_nbr in (select acc_nbr from nmk.manager_mbuser_tmp group by acc_nbr having count(*) >1)");
		jdbcTemplate.update("delete from nmk.manager_mbuser_tmp where acc_nbr in (select acc_nbr from nmk.manager_mbuser_tmp group by acc_nbr having count(*) >1)");
	}
	
	public void updateTmpForExption(String ds, String numbers){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		jdbcTemplate.update("insert into nmk.manager_mbuser_view_tmp select * from nmk.manager_mbuser_tmp where acc_nbr in ("+numbers+")");
		jdbcTemplate.update("delete from nmk.manager_mbuser_tmp where acc_nbr in ("+numbers+")");
	}
	
	@SuppressWarnings("rawtypes")
	public int getExptionCount(String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		List list = jdbcTemplate.queryForList("select count(*) count from nmk.manager_mbuser_view_tmp");
		HashMap map = (HashMap)list.get(0);
		return Integer.parseInt(map.get("count").toString());
	}
	
	@SuppressWarnings("rawtypes")
	public int getImportCount(String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		List list = jdbcTemplate.queryForList("select count(*) count from nmk.manager_mbuser_tmp");
		HashMap map = (HashMap)list.get(0);
		return Integer.parseInt(map.get("count").toString());
	}
	
	public void deleteViewTmp(String ds, String userid){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		jdbcTemplate.update("delete from nmk.manager_mbuser_view_tmp where task_id like '%"+userid+"'");
	}
	
	public void deleteViewRegionTmp(String ds, String userid){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		jdbcTemplate.update("delete from nmk.manager_region_view_tmp where task_id like '%"+userid+"'");
	}
	
	@SuppressWarnings("rawtypes")
	public List getRegionTmpList(String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		return jdbcTemplate.queryForList("select task_id,manager_accnbr,manager_name, county_name,zone_name from nmk.manager_region_tmp with ur ");
	}
	
	public void updateRegionTmpForRepeat(String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		jdbcTemplate.update("insert into nmk.manager_region_view_tmp select * from nmk.manager_region_tmp where manager_accnbr in (select manager_accnbr from nmk.manager_region_tmp group by manager_accnbr having count(*) >1)");
		jdbcTemplate.update("delete from nmk.manager_region_tmp where manager_accnbr in (select manager_accnbr from nmk.manager_region_tmp group by manager_accnbr having count(*) >1)");
	}
	
	public void updateRegionTmpForExption(String ds, String numbers){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		jdbcTemplate.update("insert into nmk.manager_region_view_tmp select * from nmk.manager_region_tmp where manager_accnbr in ("+numbers+")");
		jdbcTemplate.update("delete from nmk.manager_region_tmp where manager_accnbr in ("+numbers+")");
	}
	
	@SuppressWarnings("rawtypes")
	public int getRegionExptionCount(String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		List list = jdbcTemplate.queryForList("select count(*) count from nmk.manager_region_view_tmp");
		HashMap map = (HashMap)list.get(0);
		return Integer.parseInt(map.get("count").toString());
	}
	
	@SuppressWarnings("rawtypes")
	public int getRegionImportCount(String ds){
		JdbcTemplate jdbcTemplate = null;
		if("wb".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		}else if("dw".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}else if("nl".equals(ds)){
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		}
		List list = jdbcTemplate.queryForList("select count(*) count from nmk.manager_region_tmp");
		HashMap map = (HashMap)list.get(0);
		return Integer.parseInt(map.get("count").toString());
	}
}
