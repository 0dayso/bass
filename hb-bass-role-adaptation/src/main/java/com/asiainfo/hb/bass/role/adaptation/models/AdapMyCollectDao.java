/**
 * 
 */
package com.asiainfo.hb.bass.role.adaptation.models;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.hb.bass.role.adaptation.service.AdapMyCollectService;
import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.util.IsNumber;
import com.asiainfo.hb.web.models.User;

/**
 * @author zhanggm
 * @category colloctdata loading...
 */
@SuppressWarnings("unused")
@Repository
public class AdapMyCollectDao extends BaseDao implements AdapMyCollectService{

	public Logger logger = LoggerFactory.getLogger(AdapMyCollectDao.class);
	private JdbcTemplate jdbcTemplate;
	
	@SuppressWarnings("all")
	@Autowired
	private void setJdbcTemplate(DataSource dataSource){
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	public  List<Map<String,Object>> getCollect(Integer menuId,String resourceName,String startDate,
			String endDate,String resourceType,String pageNumStr,User user) {
		List<Map<String,Object>> list = null ;
		if(menuId==0){
			return null;
		}
		try {
			resourceName = resourceName.trim();
			startDate = startDate.trim();
			endDate = endDate.trim();
			resourceType = resourceType.trim();
			
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("select * from ( ");
			if(resourceType.equals("0") || resourceType.equals("报表")){
				sqlStr.append("select b.resource_id id,resource_name name, resource_uri uri, resource_type type,")
						.append(" TO_CHAR(a.create_dt,'YYYY-MM-DD HH24:MI:SS') CREATE_DT, a.menu_id, a.user_id ")
						.append(" from fpf_irs_FAVORITES a left join fpf_irs_resource b on a.resource_id=b.resource_id ")
						.append(" where a.resource_type='报表'");
			}
			if(resourceType.equals("0")){
				sqlStr.append(" union all ");
			}
			
			if(resourceType.equals("0") || resourceType.equals("应用")){
				sqlStr.append("select b.resource_id id,resource_name name, resource_uri uri, resource_type type, ")
						.append("TO_CHAR(a.create_dt,'YYYY-MM-DD HH24:MI:SS') CREATE_DT, a.menu_id, a.user_id ")
						.append(" from fpf_irs_FAVORITES a left join fpf_irs_application b on a.resource_id=b.resource_id ")
						.append(" where a.resource_type='应用'");
			}
			sqlStr.append(")");
			sqlStr.append(" where id is not null and user_id=? and menu_id=?");
			
			if (!resourceName.equals("")){
				sqlStr.append(" and name like '%"+resourceName+"%' ");
			}
			if (!startDate.equals("") && !endDate.equals("")){
				sqlStr.append(" and date(create_dt) between date(\'"+startDate+"\') and date(\'"+endDate+"\') ");
			}else if (!startDate.equals("")){
				sqlStr.append(" and date(create_dt) between date(\'"+startDate+"\') and DATE(current date) ");
			}else if (!endDate.equals("")){
				sqlStr.append(" and date(create_dt) <= date(\'"+endDate+"\') ");
			}
			sqlStr.append(" order by create_dt desc");
//			if (pageNumStr != null && IsNumber.isNumeric(pageNumStr.trim())){
//				int _num = Integer.parseInt(pageNumStr.trim());
//				_sql.append(" where ROW_NO between "+((_num-1)*10+1)+" and "+(_num*10)+" ");
//			}else{
//				_sql.append(" where ROW_NO between 1 and 10 ");
//			}
			
			list = jdbcTemplate.queryForList(sqlStr.toString(), new Object[]{user.getId(),menuId});
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
		return list;
	}
	public  Map<String,Object> deleteCollect(String rid,Integer menuId,User user, String type) {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = "删除失败!";
		boolean flag = false ;
		try {
			if(rid==null || rid.trim().equals("")){
				msg= "缺少参数！";
			}else{
				StringBuffer sql =new StringBuffer().append("delete from FPF_IRS_FAVORITES WHERE  resource_id='")
						.append(rid).append("' and user_id ='").append(user.getId())
						.append("' and menu_id=").append(menuId).append(" and resource_type='").append(type).append("' ");
				logger.info("delete sql="+sql.toString());
				jdbcTemplate.execute(sql.toString());
				logger.info("删除我的收藏资源成功--  报表ID:" + rid);
				flag= true;
				msg= "删除成功";
			}
		} catch (Exception e) {
			logger.info("删除我的收藏资源失败:"+e.getMessage());
			e.printStackTrace();
			flag= false;
			msg="删除我的收藏资源失败"+e.getMessage();
		}
		result.put("msg",msg);
		result.put("flag", flag);
		return result;
	}
	public  Map<String,Object> addCollect(String rid,Integer menuId,User user, String type) {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = "收藏失败!";
		boolean flag = false ;
		try {
			String sql = "select count(*) num from FPF_IRS_FAVORITES where USER_ID=? and RESOURCE_ID=? and MENU_ID = ? and resource_type=?";
			int count = jdbcTemplate.queryForObject(sql,Integer.class, new Object[]{user.getId(),rid,menuId, type});
			if (count==0){
				sql = "insert into FPF_IRS_FAVORITES(USER_ID,RESOURCE_ID,MENU_ID,CREATER_ID, resource_type) values(?,?,?,?,?)" ;
				jdbcTemplate.update(sql, new Object[]{user.getId(),rid,menuId,user.getId(),type});
				msg = "收藏成功!";
				flag = true;
			}else{
				msg = "请不要重复收藏";
			}
		} catch (Exception e) {
			msg = e.getMessage();
		}
		result.put("msg",msg);
		result.put("flag", flag);
		return result;
	}
	public 	List<Map<String, Object>> getHotCollect(Integer menuId){
		if (menuId == null) {
			return null;
		}
		StringBuffer sql=new StringBuffer().append("select resource_id id,resource_uri uri,resource_name text,type_id type,menu_id from FPF_IRS_RESOURCE a ")
						.append(",(select opername,count(*) num from FPF_VISITLIST where date(create_dt)>=(current date - 30 days) and date ")
						.append("(create_dt)<=current date group by opername) b,(select id,name from BOC_INDICATOR_MENU where deep=1) ")
						.append(" c where c.id=a.menu_id and a.menu_id=? and state='在用' AND resource_id=opername order by num desc ")
						.append(" FETCH FIRST 10 ROWS ONLY with ur");
		return jdbcTemplate.queryForList(sql.toString(), menuId);
	}
	public List<Map<String, Object>> getCollectTypes() {
		return jdbcTemplate.queryForList("select id KEY,RESOURCE_NAME VALUE from FPF_IRS_RESOURCETYPE where id not in (1,6,7)");
	}
}
