package com.asiainfo.hb.gbas.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;


@Repository
public class AnalyseDao extends CommonDao{
	
	private Logger mLog = LoggerFactory.getLogger(AnalyseDao.class);
	
	
	/**
	 * 获取所有的gbas配置
	 * @return
	 */
	public Map<String, Object> getGbasList(){
		mLog.debug("------>getGbasList");
		String zbSql = "select zb_code code, zb_name name, cycle from gbas.zb_def where status=1";
		String exSql = "select ex_code code, ex_name name, cycle from gbas.ex_def where status=1";
		Map<String, Object> resMap= new HashMap<String, Object>();
		resMap.put("zbList", this.dwJdbcTemplate.queryForList(zbSql));
		resMap.put("exList", this.dwJdbcTemplate.queryForList(exSql));
		return resMap;
	}
	
	/**
	 * 获取多个gbas值
	 * @param cycle
	 * @param startTime
	 * @param endTime
	 * @param gbasCodes
	 * @return
	 */
	public List<Map<String, Object>> getGbasData(String cycle, String startTime, String endTime, String gbasCodes){
		mLog.debug("------>getGbasData,cycle:"+cycle+"; startTime:"+startTime+"; endTime:"+endTime+"; gbasCodes:" + gbasCodes);
		String tableName = "monthly".equals(cycle) ? "BOI_TOTAL_monthly" : "BOI_TOTAL_DAILY";
		StringBuffer sql = new StringBuffer();
		sql.append("select * from gbas.").append(tableName);
		sql.append(" where time_id between ").append(startTime).append(" and ").append(endTime);
		sql.append(" and gbas_code in (").append(gbasCodes).append(")");
		mLog.debug("sql:" + sql.toString());
		return this.dwJdbcTemplate.queryForList(sql.toString());
	}
	
	/**
	 * 获取单个指标gbas_val,gbas_val1
	 * @param cycle
	 * @param startTime
	 * @param endTime
	 * @param gbasCode
	 * @return
	 */
	public List<Map<String, Object>> getOneGbasData(String cycle, String startTime, String endTime, String gbasCode){
		mLog.debug("------>getOneGbasData,cycle:"+cycle+"; startTime:"+startTime+"; endTime:"+endTime+"; gbasCodes:" + gbasCode);
		String tableName = "monthly".equals(cycle) ? "BOI_TOTAL_monthly" : "BOI_TOTAL_DAILY";
		String condition = " where time_id between " + startTime + " and " + endTime 
				+ " and gbas_code='" + gbasCode + "'";
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("select time_id, gbas_val val, 'gbas_val' name from gbas.").append(tableName).append(condition);
		strBuf.append(" union all ");
		strBuf.append("select time_id, gbas_val1 val, 'gbas_val1' name from gbas.").append(tableName).append(condition);
		mLog.debug("sql:" + strBuf.toString());
		return this.dwJdbcTemplate.queryForList(strBuf.toString());
	}
	
	/**
	 * 根据gbas_code查询名称
	 * @param gbasCode
	 * @param type
	 * @return
	 */
	public String getGbasNameByCode(String gbasCode, String type){
		mLog.debug("------>getGbasNameByCode, gbasCode:"+gbasCode+"; type:" + type);
		String sql = "";
		if(type.equals("zb")){
			sql = "select max(zb_name) name from gbas.zb_def where zb_code=?";
		}else{
			sql = "select max(ex_name) name from gbas.ex_def where ex_code=?";
		}
		String name = "";
		Map<String, Object> map = this.dwJdbcTemplate.queryForMap(sql, new Object[]{gbasCode});
		if(!map.isEmpty()){
			name = (String) map.get("name");
		}
		return name;
	}
	
	/**
	 * 保存模板
	 * @param name
	 * @param cycle
	 * @param type
	 * @param gbasCodes
	 * @param isFirstPageShow
	 * @param userId
	 */
	public void saveTemplate(String name, String cycle,String type, String gbasCodes,String isFirstPageShow, String userId){
		mLog.debug("------>saveTemplate, name:"+name+"; cycle:"+cycle+"; type:"+type+"; isFirstPageShow:"+isFirstPageShow+"; userId:" + userId);
		String idSql = "select value(max(id), 0) from gbas.analyse_template";
		int id = this.dwJdbcTemplate.queryForObject(idSql, Integer.class) + 1;
		List<String> sqlList = new ArrayList<String>();
		sqlList.add("insert into gbas.analyse_template (id, name, cycle, type, is_first_page_show, creater_id) values (" 
				+ id + ",'" + name + "', '" + cycle + "','" + type + "','" + isFirstPageShow + "','" + userId + "')");
		String[] gbasCodeArr = gbasCodes.split(",");
		for(String gbasCode: gbasCodeArr){
			sqlList.add("insert into gbas.analyse_template_ext (id, GBAS_CODE) values (" + id + ",'" + gbasCode + "')");
		}
		this.dwJdbcTemplate.batchUpdate(sqlList.toArray(new String[sqlList.size()]));
	}
	
	/**
	 * 查询模板信息
	 * @param userId
	 * @param name
	 * @return
	 */
	public List<Map<String, Object>> getTemplate(String userId, String name){
		mLog.debug("------>getTemplate");
		String sql = "select id, name, cycle, type, is_first_page_show, to_char(create_time,'YYYY-MM-DD HH24:MI:SS') create_time " +
				" from gbas.ANALYSE_TEMPLATE where creater_id='" + userId + "'";
		if(isNotNull(name)){
			sql += " and name like '%" + name + "%'";
		}
		sql += " order by create_time desc";
		return this.dwJdbcTemplate.queryForList(sql);
	}
	
	public List<Map<String, Object>> getTemplateExt(String userId, String cycle){
		mLog.debug("------>getTemplateExt");
		String sql = "select name,codes, type from gbas.analyse_template a left join " +
				" (select id, replace(replace(xml2clob(xmlagg(xmlelement(NAME a, gbas_code))),'<A>',''),'</A>',',') codes " +
				" from gbas.analyse_template_ext group by id) b " +
				" on a.id=b.id " +
				" where a.creater_id='" + userId + "' and cycle='" + cycle + "' and is_first_page_show='1'" +
				" order by create_time desc " +
				" FETCH FIRST 6 ROWS ONLY with ur";
		return this.dwJdbcTemplate.queryForList(sql);
	}
	
	public void updateTemplate(String ids, String firstPageShow){
		mLog.debug("------>updateTemplate");
		String sql = "update gbas.ANALYSE_TEMPLATE set is_first_page_show='" + firstPageShow + "' where id in (" + ids + ")";
		this.dwJdbcTemplate.update(sql);
	}
	
	public void deleteTemplate(String ids){
		mLog.debug("------>deleteTemplate");
		String sql = "delete from gbas.ANALYSE_TEMPLATE where id in (" + ids + ")";
		String extSql = "delete from gbas.ANALYSE_TEMPLATE_ext where id in (" + ids + ")";
		this.dwJdbcTemplate.update(sql);
		this.dwJdbcTemplate.update(extSql);
	}
	
}
