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
			StringBuffer _sql = new StringBuffer("select * from (select A.RESOURCE_URI RESOURCE_URI,A.name RESOURCE_NAME,A.type RESOURCE_TYPE,TO_CHAR(A.time,'YYYY-MM-DD HH24:MI:SS') CREATE_DT,A.resource_id ID,A.userId USERID,")
								.append("A.menuId MENUID,count, ROW_NUMBER() OVER() as ROW_NO from (select t.resource_name name,q.resource_name type,p.create_dt time,p.resource_id resource_id,p.user_id userId,p.menu_id menuId,")
								.append("t.resource_uri resource_uri,count(1) over() as count from FPF_irs_resource t,FPF_IRS_FAVORITES p,FPF_IRS_RESOURCETYPE q where t.resource_id = p.resource_id and t.menu_id = p.menu_id and t.type_id = q.id and p.user_id=? ");
			if(menuId !=-1){
				_sql.append("and p.menu_id=? ");
			}
			if (!resourceName.equals("")){
				_sql.append(" and t.resource_name like '%"+resourceName+"%' ");
			}
			if (!startDate.equals("") && !endDate.equals("")){
				_sql.append(" and date(p.create_dt) between date(\'"+startDate+"\') and date(\'"+endDate+"\') ");
			}else if (!startDate.equals("")){
				_sql.append(" and date(p.create_dt) between date(\'"+startDate+"\') and DATE(current date) ");
			}else if (!endDate.equals("")){
				_sql.append(" and date(p.create_dt) <= date(\'"+endDate+"\') ");
			}
			if (!resourceType.equals("") && !resourceType.equals("0")){
				_sql.append(" and q.id = "+resourceType+"");
			}
			_sql.append(" order by time desc) as A order by row_no)");
//			if (pageNumStr != null && IsNumber.isNumeric(pageNumStr.trim())){
//				int _num = Integer.parseInt(pageNumStr.trim());
//				_sql.append(" where ROW_NO between "+((_num-1)*10+1)+" and "+(_num*10)+" ");
//			}else{
//				_sql.append(" where ROW_NO between 1 and 10 ");
//			}
			if(menuId ==-1){
				list = jdbcTemplate.queryForList(_sql.toString(), new Object[]{user.getId()});
			}else{
				list = jdbcTemplate.queryForList(_sql.toString(), new Object[]{user.getId(),menuId});
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
		return list;
	}
	public  Map<String,Object> deleteCollect(String rid,Integer menuId,User user) {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = "删除失败!";
		boolean flag = false ;
		try {
			if(rid==null || rid.trim().equals("")){
				msg= "缺少参数！";
			}else{
				StringBuffer sql =new StringBuffer().append("delete from FPF_IRS_FAVORITES WHERE  resource_id='")
						.append(rid).append("' and user_id ='").append(user.getId()).append("' and menu_id=").append(menuId);
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
	public  Map<String,Object> addCollect(String rid,Integer menuId,User user) {
		Map<String,Object> result = new HashMap<String,Object>();
		String msg = "收藏失败!";
		boolean flag = false ;
		try {
			String sql = "select count(*) num from FPF_IRS_FAVORITES where USER_ID=? and RESOURCE_ID=? and MENU_ID = ?";
			int count = jdbcTemplate.queryForObject(sql,Integer.class, new Object[]{user.getId(),rid,menuId});
			if (count==0){
				sql = "insert into FPF_IRS_FAVORITES(USER_ID,RESOURCE_ID,MENU_ID,CREATER_ID) values(?,?,?,?)" ;
				jdbcTemplate.update(sql, new Object[]{user.getId(),rid,menuId,user.getId()});
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
