/**
 * 
 */
package com.asiainfo.hb.bass.role.adaptation.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.bass.role.adaptation.service.AdapAppService;
import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.util.IsNumber;
import com.asiainfo.hb.web.models.User;

/**
 * @author zhanggm
 * @category appdata loading...
 */
@Repository
public class AdapAppDao extends BaseDao implements AdapAppService{

	public Logger logger = LoggerFactory.getLogger(AdapAppDao.class);
	private JdbcTemplate jdbcTemplate;
	
	@SuppressWarnings("all")
	@Autowired
	private void setJdbcTemplate(DataSource dataSource){
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	public List<Map<String, Object>> getAppData(String sid,String orderType,String searchVal,String appType,
			String pageNum,User user){
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		try {
			searchVal = java.net.URLDecoder.decode(searchVal, "UTF-8");
			if (sid != null && !sid.trim().equals("") && IsNumber.isNumeric(sid)){
				StringBuffer _sqlSbf = new StringBuffer("");
				_sqlSbf.append("select c.*,(case when rowid<4 then 'hot' else 'nonhot' end) hotFlag,");
				_sqlSbf.append("(case when timerows<4 then 'new' else 'old' end) newFlag  from ");
				_sqlSbf.append("(select rownumber() over(order by value(num,0) desc) as ROWID,");
				_sqlSbf.append("rownumber() over(order by create_dt desc) as TIMEROWS,count(1) over() as count,");
				_sqlSbf.append("a.resource_id,resource_uri,resource_name, menu_id,data_last_upd Lastupdate,");
				_sqlSbf.append("resource_desc,creater_id,resource_img,value(num,0) num,");
				_sqlSbf.append("(select count(*) from FPF_IRS_FAVORITES where USER_ID='"+user.getId()+"' and resource_id = a.resource_id )  isMyCollect from FPF_IRS_RESOURCE a ");
				_sqlSbf.append("left join (select resource_id ");
				_sqlSbf.append(" ,count(*) num from FPF_IRS_FAVORITES group by resource_id ) b");
				_sqlSbf.append(" on a.resource_id=b.resource_id where a.type_id in ");
				if(appType !=null && !"".equals(appType.trim())){
					_sqlSbf.append(appType);
				}else{
					_sqlSbf.append(" (select id from FPF_IRS_RESOURCETYPE where resource_type='应用')");
				}
				
				_sqlSbf.append("  and menu_id="+Integer.parseInt(sid));
				if (searchVal != null && !searchVal.trim().equals("")){
					_sqlSbf.append(" and resource_name like '%"+searchVal.trim()+"%' ");
				}
				_sqlSbf.append(" ) c ");
//				_sqlSbf.append(" where ");
//				_sqlSbf.append(getOrderBy(orderType));
//				if (pageNum != null && IsNumber.isNumeric(pageNum.trim())){
//					int _num = Integer.parseInt(pageNum.trim());
//					_sqlSbf.append(" between "+((_num-1)*10+1)+" and "+(_num*10)+" ORDER BY ");
//				}else{
//					_sqlSbf.append(" between 1 and 10 ORDER BY ");
//				}
				_sqlSbf.append(" ORDER BY ");
				_sqlSbf.append(getOrderBy(orderType));
				_sqlSbf.append(" ASC");
				list = jdbcTemplate.queryForList(_sqlSbf.toString());
			}
		} catch (Exception e) {
			logger.debug(e.getMessage());
		} 
		return list;
	}
	public  List<Map<String, Object>>  getHotApp(Integer menuId) {
		if (menuId == null) {
			return null;
		}
		StringBuffer sql=new StringBuffer().append("select c.* from (select rownumber() over(order by value(num,0) desc) as ROWID,a.resource_id,resource_uri ")
							.append(",resource_name, menu_id,data_last_upd Lastupdate,resource_desc,creater_id,resource_img,value(num,0) num from FPF_IRS_RESOURCE ")
							.append(" a left join (select resource_id,count(*) num from FPF_IRS_FAVORITES group by resource_id) b on a.resource_id ")
							.append("=b.resource_id where a.type_id in (select id from FPF_IRS_RESOURCETYPE where resource_type='应用') and menu_id ")
							.append("= ? ) c where rowid between 1 and 4");
		return jdbcTemplate.queryForList(sql.toString() , menuId);
	}
	public  List<Map<String, Object>>  getAppType() {
		String sql="select id key,resource_name value from FPF_IRS_RESOURCETYPE where resource_type ='应用'";
		return jdbcTemplate.queryForList(sql);
	}

	private String getOrderBy(String orderType){
		if (orderType != null && !orderType.trim().equals("")){
			return orderType.trim();
		}else{
			return "rowid";
		}
		
	}
	@Override
	public List<Map<String, Object>> getZtDetail(String rid) {
		String sql ="select * from (select resource_id id,resource_name name from fpf_irs_resource  where resource_id = ?  ) a," +
				    " (select count(*) views from fpf_visitlist where opername = ?)  b"; 
		return jdbcTemplate.queryForList(sql,new Object[] {rid, rid });
	}
	@Override
	public List<Map<String, Object>> getZtShow(String rid) {
		if ((rid == null) || ("".equals(rid))) {
		      return null;
		    }
		    return this.jdbcTemplate
		      .queryForList(
		      "select specialtopic_name imgurl from fpf_IRS_SPECIALTOPICS where resource_id =?", new Object[] { 
		      rid });
	}
	
	public List<Map<String, Object>> getHotZt() {
	    return this.jdbcTemplate
	      .queryForList(" select resource_id id,resource_uri uri,resource_name name from fpf_IRS_RESOURCE a ,  " +
	      		"(select opername,count  (*) num from fpf_VISITLIST where date(create_dt)>=(current date - 30 days) and date(create_dt)<=current date  group by opername) b  " +
	      		"where state='在用' AND (type_id in (select id from fpf_irs_resourcetype where resource_type  ='应用')) AND resource_id=opername " +
	      		"order by num desc FETCH FIRST 10 ROWS ONLY with ur");
	  }
	
	@Override
	public Map<String, Object> getTopicDetail(String resId) {
		String sql = "select a.resource_name name,a.resource_desc desc, max(b.deep) deep from fpf_irs_resource a " +
				" left join fpf_irs_specialtopics b on a.resource_id=b.resource_id " +
				" where a.resource_id =? group by (a.resource_name, a.resource_desc)";
		return this.jdbcTemplate.queryForMap(sql, new Object[]{resId});
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getSubTopics(String resId) {
		String sql = "select a.id,a.pid,a.deep,a.SPECIALTOPIC_NAME sname,b.resource_id rid," +
				" b.resource_uri uri,b.resource_name rname,a.icon icon from fpf_irs_specialtopics a " +
				" left join  fpf_irs_resource b on a.resource_sub_id = b.resource_id " +
				" where a.state ='在用' and a.resource_id =?  order by deep desc, pid, id";
		Map<String ,Object> temp = new HashMap<String, Object>();
		Map<String ,Object> temp1 = new HashMap<String, Object>();
		List<Map<String, Object>> resList = new ArrayList<Map<String,Object>>();
		List<Map<String, Object>> list = this.jdbcTemplate.queryForList(sql, new Object[]{resId});
		
		for(Map<String, Object> map : list){
			if(temp.containsKey(String.valueOf(map.get("pid")))){//将三级数据放入temp
				List<Map<String, Object>> child = (List<Map<String, Object>>) temp.get(String.valueOf(map.get("pid")));
				child.add(map);
				temp.put(String.valueOf(map.get("pid")), child);
			}else if(temp1.containsKey(String.valueOf(map.get("pid")))){//将二级数据放入temp1
				List<Map<String, Object>> child = (List<Map<String, Object>>) temp1.get(String.valueOf(map.get("pid")));
				map.put("child", temp.get(String.valueOf(map.get("id"))));
				child.add(map);
				temp1.put(String.valueOf(map.get("pid")), child);
			}else if(String.valueOf(map.get("deep")).equals("1")){//将二级数据作为一级子数据
				map.put("child", temp1.get(String.valueOf(map.get("id"))));
				resList.add(map);
			}else{
				List<Map<String, Object>> arr = new ArrayList<Map<String,Object>>();
				if(String.valueOf(map.get("deep")).equals("3")){
					arr.add(map);
					temp.put(String.valueOf(map.get("pid")), arr);
				}else{
					map.put("child", temp.get(String.valueOf(map.get("id"))));
					arr.add(map);
					temp1.put(String.valueOf(map.get("pid")), arr);
				}
			}
		}
		return resList;
	}
}
