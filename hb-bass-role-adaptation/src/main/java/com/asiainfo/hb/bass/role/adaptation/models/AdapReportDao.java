/**
 * 
 */
package com.asiainfo.hb.bass.role.adaptation.models;

import java.util.List;
import java.util.Map;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import com.asiainfo.hb.bass.role.adaptation.service.AdapReportService;
import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.util.IsNumber;
import com.asiainfo.hb.web.models.User;

/**
 * @author zhanggm
 * @category reportdata loading...
 */
@Repository
public class AdapReportDao extends BaseDao implements AdapReportService{

	public Logger logger = LoggerFactory.getLogger(AdapReportDao.class);
	private JdbcTemplate jdbcTemplate;
	
	@SuppressWarnings("all")
	@Autowired
	private void setJdbcTemplate(DataSource dataSource){
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	public List<Map<String, Object>> getReportDataByPage(Integer menuId,String orderByStr,String nameLike,String isKeyWord,
			String pageNumStr,User user){
		List<Map<String,Object>> list = null ;
		try {
			if (menuId != null && Integer.valueOf(menuId) > 0 ){
				StringBuffer _sqlSbf = new StringBuffer("");
				_sqlSbf.append("select * from ( select ROW_NUMBER() OVER(order by ");
				if (orderByStr != null && !orderByStr.trim().equals("")){
					if (orderByStr.trim().equalsIgnoreCase("create_dt")){
						_sqlSbf.append("create_dt");
					}else{
						_sqlSbf.append("num") ;
					}
				}else{
					_sqlSbf.append("num") ;
				}
				_sqlSbf.append(" DESC) AS ROWSNUM,");
				_sqlSbf.append("reportid,name,desc,uri,create_dt,num,count,favsNum,keywords from ");
				_sqlSbf.append("(select resource_id reportid,resource_name NAME,resource_desc DESC,replace(keywords,'，',',') keywords,resource_uri uri,create_dt,value(NUM,0) NUM,count(1) over() as count,");
				_sqlSbf.append("(select count(*) from FPF_IRS_FAVORITES where user_id=? and type='报表' and resource_id=a.resource_id) favsNum from FPF_IRS_RESOURCE a");
				_sqlSbf.append(" left join (select opername,count(*) num from FPF_VISITLIST ");
				_sqlSbf.append("where create_dt between current timestamp - 1 months and current timestamp group by opername) b on resource_id=opername ");
				_sqlSbf.append("where menu_id=? ");
				_sqlSbf.append("and STATE='在用' and (type_id in (select id from FPF_IRS_RESOURCETYPE where resource_name='报表') or (type_id in (select id from FPF_IRS_RESOURCETYPE where resource_name='自定义报表') and CREATER_ID = ?))  ");
				if (nameLike != null && !nameLike.trim().equals("")){
					nameLike = java.net.URLDecoder.decode(nameLike, "UTF-8");
					if(isKeyWord !=null &&!"".equals(isKeyWord)){
						_sqlSbf.append("and ucase(keywords) like '%"+nameLike.trim().toUpperCase()+"%' ");
						jdbcTemplate.update("insert into FPF_IRS_RESOURCE_KEYWORD values(?,?,?,?,current timestamp)", 
								new Object[]{nameLike.trim(),menuId,"报表",user.getId()});
					}else{
						_sqlSbf.append("and ucase(resource_name) like '%"+nameLike.trim().toUpperCase()+"%' ");
					}
				}
				_sqlSbf.append(" ) c) d where ROWSNUM between ");
				if (pageNumStr != null && IsNumber.isNumeric(pageNumStr)){
					int _pageNum = Integer.parseInt(pageNumStr);
					_pageNum = _pageNum>=1?_pageNum:1;
					_sqlSbf.append(((_pageNum-1)*6+1) + " and " + _pageNum*6);
				}else{
					_sqlSbf.append("1 and 6");
				}
				list = jdbcTemplate.queryForList(_sqlSbf.toString(), new Object[]{user.getId(),menuId,user.getId()});
			}
		} catch (Exception e) {
			logger.debug(e.getMessage());
		}
		return list;
	}
	public List<Map<String, Object>> getReportLevelChild(String menuId,User user, String reportName){
		List<Map<String,Object>> list = null ;
		try {
			StringBuffer sql =new StringBuffer().append("select a.RESOURCE_ID RID,A.RESOURCE_NAME RNAME,A.RESOURCE_URI RURI,A.IRS_RESOURCE_SORT_ID SID,B.NAME SNAME,1 LEVEL,value(A.RESOURCE_DESC,'') RDESC,value(DATA_LAST_UPD,'') LASTUPD,RESOURCE_CYCLE CYCLE,  ")
					.append("(select count(*) from FPF_IRS_FAVORITES where user_id=? and resource_id=a.resource_id and resource_type='报表') favsNum ")
					.append("from FPF_IRS_RESOURCE a,FPF_IRS_RESOURCE_SORT B WHERE a.STATE='在用' and (a.type_id in (select id from FPF_IRS_RESOURCETYPE where resource_name='报表') or a.type_id in (select id from FPF_IRS_RESOURCETYPE where resource_name='自定义报表')) and  B.ID = A.IRS_RESOURCE_SORT_ID AND B.MENU_ID = char(")
					.append(menuId)
					.append(") ")
					.append(" and a.menu_id = char(")
					.append(menuId)
					.append(") ");
			if(!StringUtils.isEmpty(reportName)){
				sql.append(" and a.resource_name like '%").append(reportName).append("%'");
			}
			sql.append(" order by A.IRS_RESOURCE_SORT_ID,A.sort");
			list = jdbcTemplate.queryForList(sql.toString(), new Object[]{user.getId()});
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
		return list;
	}
	public List<Map<String, Object>> getReportLevelMain(String menuId, String reportName){
		List<Map<String,Object>> list = null ;
		try {
			StringBuffer sql =new StringBuffer().append("SELECT A.ID,A.NAME,A.PID, VALUE(B.NUM,0) NUM ,0 level FROM FPF_IRS_RESOURCE_SORT A ")
					.append(" left JOIN (SELECT COUNT(*) NUM,IRS_RESOURCE_SORT_ID ID FROM FPF_IRS_RESOURCE where (type_id in (select id from FPF_IRS_RESOURCETYPE where resource_name='报表')  or  type_id in (select id from FPF_IRS_RESOURCETYPE where resource_name='自定义报表'))")
					.append(" and state='在用' and menu_id = char(")
					.append(menuId)
					.append(") ");
			if(!StringUtils.isEmpty(reportName)){
				sql.append(" and resource_name like '%");
				sql.append(reportName);
				sql.append("%'");
			}
			sql.append(" GROUP BY IRS_RESOURCE_SORT_ID )")
					.append(" B ON A.ID = B.ID ")
					.append(" where A.MENU_ID = char(")
					.append(menuId)
					.append(") ")
					.append(" and num!=0")//筛掉报表数为0的报表分类
					.append(" ORDER BY A.SORT");
			list = jdbcTemplate.queryForList(sql.toString());
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
		return list;
	}
	public  List<Map<String, Object>>  getHotReport(Integer menuId) {
		if (menuId == null) {
			return null;
		}
		String sql="select resource_id id,resource_uri uri,resource_name text from FPF_IRS_RESOURCE a , (select opername,count "
				+ " (*) num from FPF_VISITLIST where date(create_dt)>=(current date - 30 days) and date(create_dt)<=current date "
				+ " group by opername) b where  a.menu_id=? and state='在用' AND (type_id in (select id from FPF_IRS_RESOURCEtype "
				+ " where resource_type='报表')) AND resource_id=opername order by num desc FETCH FIRST 10 ROWS ONLY with ur";
		return jdbcTemplate.queryForList(sql, menuId);
	}
}
