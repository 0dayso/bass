package com.asiainfo.hb.gbas.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.web.models.CommonDao;

@Repository
public class ZbDao extends CommonDao{
	
	private Logger mLog = LoggerFactory.getLogger(ZbDao.class);

	public boolean saveZbDef(ZbDef zbDef){
		mLog.debug("-----saveZbDef-----" + zbDef);
		if(!checkZbCode(zbDef.getZbCode())){
			return false;
		}
		
		String sql = "insert into gbas.zb_def (zb_code, zb_name,boi_code, zb_type, zb_def,rule_type,rule_def,comp_oper,comp_val," +
				" depend_type,proc_depend, gbas_depend, status, cycle, online_date," +
				" offline_date, remark, creater, developer, manager,creater_name, developer_name, manager_name, priority,expect_end_day, expect_end_time) values(" +
				" ?,?,?,?,?,?,?,?,?,?,?,?,?,?,'" + zbDef.getOnlineDate() + "','" + zbDef.getOfflineDate() +"',?,?,?,?,?,?,?,?,?,?)";
		
		this.jdbcTemplate.update(sql, new Object[]{zbDef.getZbCode(), zbDef.getZbName(), zbDef.getBoiCode(), zbDef.getZbType(),zbDef.getZbDef(),
				zbDef.getRuleType(), zbDef.getRuleDef(), zbDef.getCompOper(), zbDef.getCompVal(), zbDef.getDependType(),
				zbDef.getProcDepend(), zbDef.getGbasDepend(), zbDef.getStatus(), zbDef.getCycle(), zbDef.getRemark(), zbDef.getCreater(),
				zbDef.getDeveloper(), zbDef.getManager(), zbDef.getCreaterName(), zbDef.getDeveloperName(), zbDef.getManagerName(),
				zbDef.getPriority(), zbDef.getExpectEndDay(), zbDef.getExpectEndTime()});
		insertRelation(zbDef.getZbCode(), zbDef.getGbasDepend());
		return true;
	}
	
	public void updateZb(ZbDef zbDef){
		mLog.debug("-----updateZb-----" + zbDef);
		String sql = "update gbas.zb_def set zb_name=?,cycle=?,boi_code=?, zb_def=?,zb_type=?,rule_type=?,rule_def=?,comp_oper=?,comp_val=? ," +
				" depend_type=?,proc_depend=?, gbas_depend=?,status=?,online_date='" + zbDef.getOnlineDate() + "'" +
				",offline_date='" + zbDef.getOfflineDate() + "',remark=?,developer=?,manager=?,developer_name=?, manager_name=?," +
				" priority=?,expect_end_day=? ,expect_end_time=? where zb_code=?";
		
		this.jdbcTemplate.update(sql, new Object[]{zbDef.getZbName(), zbDef.getCycle(), zbDef.getBoiCode(), zbDef.getZbDef(), zbDef.getZbType(), zbDef.getRuleType(),
				zbDef.getRuleDef(),zbDef.getCompOper(),zbDef.getCompVal(),zbDef.getDependType(),zbDef.getProcDepend(),zbDef.getGbasDepend(),
				zbDef.getStatus(), zbDef.getRemark(), zbDef.getDeveloper(), zbDef.getManager(),zbDef.getDeveloperName(), zbDef.getManagerName(),
				zbDef.getPriority(),zbDef.getExpectEndDay(), zbDef.getExpectEndTime(), zbDef.getZbCode()});
		insertRelation(zbDef.getZbCode(), zbDef.getGbasDepend());
	}
	
	private void insertRelation(String zbCode, String gbasDepend){
		String[] codeArr = gbasDepend.split(";");
		List<String> sqlList = new ArrayList<String>();
		for(String gbasCode: codeArr){
			if(isNotNull(gbasCode)){
				sqlList.add("delete from gbas.code_relation where code='" + zbCode + "' and depend_code='" + gbasCode + "'");
				sqlList.add("insert into gbas.code_relation (code, depend_code) values('" + zbCode + "','" + gbasCode +"')");
			}
		}
		if(sqlList.size() != 0){
			this.jdbcTemplate.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
		}
		
	}
	
	public void deleteZb(String zbCode){
		mLog.debug("-----deleteZb-----zbCode:" + zbCode);
		String sql = "delete from gbas.zb_def where zb_code=?";
		this.jdbcTemplate.update(sql, new Object[]{zbCode});
	}
	

	public Map<String, Object> getZbList(ZbDef zbDef, HttpServletRequest req){
		mLog.debug("-----getZbList-----");
		String pageSql = "select * from gbas.zb_def where 1=1 ";
		String countSql = "select count(1) from gbas.zb_def where 1=1 ";
		
		Map<String , Object> condition = new HashMap<String , Object>();
		condition.put("zb_type", zbDef.getZbType());
		condition.put("cycle", zbDef.getCycle());
		condition.put("status", zbDef.getStatus());
		condition.put("zb_name like", zbDef.getZbName());
		condition.put("zb_code like", zbDef.getZbCode());
		
		int[] pageParam = this.pageParam(req);
		
		return where(condition, pageSql, countSql, pageParam[0], pageParam[1], " zb_code");
	}
	
	public boolean checkZbCode(String zbCode){
		String sql = "select * from gbas.zb_def where zb_code=?";
		List<Map<String, Object>> list = this.jdbcTemplate.queryForList(sql, new Object[]{zbCode});
		if(list != null && list.size() > 0){
			return false;
		}
		return true;
	}
	
	public Map<String, Object> getUserList(String name, String id, String cityId, HttpServletRequest req){
		String sql = "select userid, username, AREA_name areaname from st.fpf_user_user a " +
				" left join st.FPF_BT_AREA b on a.cityid=b.AREA_ID where 1=1 ";
		String countSql = "select count(1) from st.fpf_user_user where 1=1 ";
		String condition = "";
		if(isNotNull(name)){
			condition += " and username like '%" + name + "%'";
		}
		if(isNotNull(id)){
			condition += " and userid like '%" + id + "%'";
		}
		if(isNotNull(cityId)){
			condition += " and cityid=" + cityId;
		}
		
		int[] pageParam = this.pageParam(req);
		
		return page(sql+condition , countSql + condition, pageParam[0], pageParam[1], "userId");
	}
	
}
