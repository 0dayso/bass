package com.asiainfo.hb.gbas.model;

import java.util.HashMap;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import com.asiainfo.hb.web.models.CommonDao;

@Repository
public class ZbDao extends CommonDao{
	
	private Logger mLog = LoggerFactory.getLogger(ZbDao.class);

	public void saveZbDef(ZbDef zbDef){
		mLog.debug("-----saveZbDef-----" + zbDef);
		
		String sql = "insert into gbas.zb_def (zb_code, zb_name,boi_code, zb_type, zb_def, depends, status, cycle, online_date," +
				" offline_date, remark, creater, developer, manager, priority,expect_end_day, expect_end_time) values(" +
				" ?,?,?,?,?,?,?,?,'" + zbDef.getOnlineDate() + "','" + zbDef.getOfflineDate() +"',?,?,?,?,?,?,?)";
		
		this.jdbcTemplate.update(sql, new Object[]{zbDef.getZbCode(), zbDef.getZbName(), zbDef.getBoiCode(), zbDef.getZbType(),
				zbDef.getZbDef(), zbDef.getDepends(), zbDef.getStatus(), zbDef.getCycle(), zbDef.getRemark(), zbDef.getCreater(),
				zbDef.getDeveloper(), zbDef.getManager(), zbDef.getPriority(), zbDef.getExpectEndDay(), zbDef.getExpectEndTime()});
	}
	
	public void updateZb(ZbDef zbDef){
		mLog.debug("-----updateZb-----" + zbDef);
		String sql = "update gbas.zb_def set zb_name=?, zb_def=?,zb_type=? ,depends=?,status=?,online_date='" + zbDef.getOnlineDate() + "'" +
				",offline_date='" + zbDef.getOfflineDate() + "',remark=?,developer=?,manager=?,priority=?,expect_end_day=?" +
				",expect_end_time=? where zb_code=?";
		
		this.jdbcTemplate.update(sql, new Object[]{zbDef.getZbName(), zbDef.getZbDef(), zbDef.getZbType(), zbDef.getDepends(),
				zbDef.getStatus(), zbDef.getRemark(), zbDef.getDeveloper(), zbDef.getManager(), zbDef.getPriority(),
				zbDef.getExpectEndDay(), zbDef.getExpectEndTime(), zbDef.getZbCode()});
	}
	
	public void deleteZb(String zbCode){
		mLog.debug("-----deleteZb-----zbCode:" + zbCode);
		String sql = "delete from gbas.zb_def where zb_code=?";
		this.jdbcTemplate.update(sql, new Object[]{zbCode});
	}
	
	public String getNextNum(){
		mLog.debug("-----getNextNum-----");
		String sql = "select max(substr(zb_code ,8,11)) num from gbas.zb_def";
		Map<String, Object> map = this.jdbcTemplate.queryForMap(sql);
		int i = 0;
		if(map != null && map.get("num") != null){
			String nums = (String) map.get("num");
			i = Integer.valueOf(nums.trim());
		}
		return String.format("%04d", ++i);
	}	
	
	public Map<String, Object> getZbList(ZbDef zbDef, int rows, int page){
		mLog.debug("-----getZbList-----");
		String pageSql = "select * from gbas.zb_def where 1=1 ";
		String countSql = "select count(1) from gbas.zb_def where 1=1 ";
		
		Map<String , Object> condition = new HashMap<String , Object>();
		condition.put("zb_type", zbDef.getZbType());
		condition.put("cycle", zbDef.getCycle());
		condition.put("status", zbDef.getStatus());
		condition.put("zb_name like", zbDef.getZbName());
		condition.put("zb_code like", zbDef.getZbCode());
		
		return where(condition, pageSql, countSql, rows, page, " zb_code");
	}
	
}
