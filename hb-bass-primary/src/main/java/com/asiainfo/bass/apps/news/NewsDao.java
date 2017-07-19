package com.asiainfo.bass.apps.news;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
public class NewsDao {
	
	private static Logger LOG = Logger.getLogger(NewsDao.class);
	
	@Autowired
	private DataSource dataSource;
	
	public void save(String title, String content, String begindate, String enddate, String issend, String userid){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		int newsid = getNewsId()+1;
		Date now = new Date(); 
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//可以方便地修改日期格式

		String time = dateFormat.format( now ); 
		System.out.println(time); 
		
		if("".equals(begindate) || begindate==null){
			begindate = "2009-01-01";
		}
		if("".equals(enddate) || enddate==null){
			enddate = "2020-01-01";
		}
		String sql = "insert into FPF_USER_NEWS(NEWSID, NEWSDATE, NEWSTITLE, STATUS, ISSEND, NEWSMSG,  VALID_BEGIN_DATE, VALID_END_DATE, CREATOR) values("+newsid+",'"+ time +"','"+title+"','0','"+issend+"','"+content+"','"+begindate+"','"+enddate+"','"+userid+"')";
		LOG.info(sql);
		jdbcTemplate.update(sql);
	}
	
	public void update(String newsid, String title, String content, String begindate, String enddate, String issend, String userid){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		Date d = new Date();
		String sql = "update FPF_USER_NEWS set NEWSDATE = ?, NEWSTITLE = ?, ISSEND = ?, NEWSMSG = ?,  VALID_BEGIN_DATE = ?, VALID_END_DATE = ?, CREATOR = ? where NEWSID = ? ";
		jdbcTemplate.update(sql,new Object[] { d, title,  issend, content, begindate, enddate, userid, Integer.parseInt(newsid) });
	}
	
	public void auditing(String newsid){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "update FPF_USER_NEWS set STATUS = ? where NEWSID = ? ";
		jdbcTemplate.update(sql,new Object[] { "1", newsid });
	}
	
	public void delete(String newsid){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "delete from FPF_USER_NEWS where NEWSID = ? ";
		jdbcTemplate.update(sql,new Object[] { newsid });
	}
	
	public int getNewsId(){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		String sql = "select max(newsid) newsid from FPF_USER_NEWS ";
		return jdbcTemplate.queryForObject(sql,Integer.class);
	}
	
	@SuppressWarnings("rawtypes")
	public List getNews(String newsid){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select NEWSID, NEWSDATE, NEWSTITLE, NEWSMSG, VALID_BEGIN_DATE, VALID_END_DATE, CREATOR, USERNAME CREATORNAME  from FPF_USER_NEWS INNER JOIN FPF_USER_USER ON CREATOR=USERID WHERE NEWSID = ? ", new Object[] { newsid });
	}
}
