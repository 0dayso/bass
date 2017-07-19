package com.asiainfo.bass.apps.models;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.BeanFactoryA;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.bass.components.models.PageSqlGen;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.hb.web.models.UserDao;

/**
 * 
 * @author Mei Kefu
 * @date 2011-1-25
 */
@Repository
public class IssueDao {

	private JdbcTemplate jdbcTemplate;

	@SuppressWarnings("rawtypes")
	private RowMapper issueMapper = new IssueMapper();
	private static Logger m_log = Logger.getLogger(IssueDao.class);
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	@Autowired
	private PageSqlGen pageSqlGen;

	public Map<String, Object> getTypeInfo(String type){
		String sql = "select type, username, userid, mobile from fpf_irs_application_charge where type='" + type +"'";
		Map<String, Object> map = this.jdbcTemplate.queryForMap(sql);
		return map;
	}
	
	public long save(Issue t) {
		long result = 0;
		if (t.getReplyId() != null && t.getReplyId().length() > 0 && t.getContent().startsWith("@")) {
			t.setContent(t.getContent().substring(t.getContent().indexOf(" ") + 1));
		}

		if (t != null && t.getId() == null) {
//			long id = this.jdbcTemplate.queryForObject("select max(id) from FPF_IRS_TWITTER",Integer.class) + 1;
			int id = jdbcTemplate.queryForObject("values nextval for fpf_irs_twitter_id",Integer.class);
			t.setId(Long.valueOf(id));
			this.jdbcTemplate.update("insert into FPF_IRS_TWITTER (id ,pid ,user_id ,user_name ,reply_id ,reply ,state,content,file_name,telephone,end_time,responsible) values (? ,? ,? ,? ,? ,? ,? ,? ,?,?,?,? )", new Object[] { id, t.getPid(), t.getUser().getId(), t.getUser().getName(), t.getReplyId(), t.getReply(), t.getState(), t.getContent(), t.getFileName(),t.getTelephone(),t.getEndTime(), t.getResponsible() });
			result = id;
		} else {
			Long pid = t.getPid()==0?null:t.getPid();
			this.jdbcTemplate.update("update FPF_IRS_TWITTER set pid=? ,user_id=? ,user_name=? ,reply_id=? ,reply=? ,state=?,content=?,file_name=?,telephone=?,end_time=?,responsible=? where id=?", new Object[] { pid, t.getUser().getId(), t.getUser().getName(), t.getReplyId(), t.getReply(), t.getState(), t.getContent(), t.getFileName(), t.getTelephone(),t.getEndTime(), t.getResponsible(), t.getId()});
			result = t.getId();
		}
		return result;
	}

	public void updateIssueType(String id, String type) {

		this.jdbcTemplate.update("delete from FPF_IRS_TWITTER_EXT where tid=? and code='申告类型' ", new Object[] { Long.valueOf(id) });

		this.jdbcTemplate.update("insert into FPF_IRS_TWITTER_EXT values(?,?,?)", new Object[] { Long.valueOf(id), "申告类型", type });
	}

	@SuppressWarnings("rawtypes")
	private static final class IssueMapper implements RowMapper {

		public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

			Issue t = new Issue();
			t.setId(rs.getLong("id"));
			t.setPid(rs.getLong("pid"));
			String userId = rs.getString("user_id");
			UserDao userDao = (UserDao) BeanFactoryA.getBean("userDao");
			//by zhangds 2014-04-15 用户可能已经不存在了!
			User user = null;
			try {
				user = userDao.getUserById(userId);
			} catch (Exception e) {
			}
			//end 
			t.setUser(user);
			t.setCreateDt(rs.getTimestamp("create_dt"));
			t.setState("申告");
			t.setType(rs.getString("type"));
			t.setReplyType(rs.getString("reply_type"));
			t.setContent(rs.getString("content"));
			t.setTelephone(rs.getString("telephone"));
			t.setResponsible(rs.getString("responsible"));
			t.setFileName(rs.getString("file_name"));
			t.setEndTime(rs.getString("end_time"));
			t.setResponsiblePhone(rs.getString("mobile"));
			return t;
		}
	}

	/**
	 * 得到申告
	 * 
	 * @param appId
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List getIssues(int page, int pageSize, String kw, String issue_type, String username) {
		String sql = "select id,pid,user_id,user_name,create_dt,value(value,'应用申告') type,case when reply_type='已回复' " +
				" then reply_type when reply='已转数据质量组'  and reply_type is null then reply else '未回复' end reply_type,content, " +
				" file_name,value(telephone,'') telephone,value(responsible,'') responsible,value(end_time,'') end_time, value(mobile,'') mobile " +
				" from FPF_IRS_TWITTER a left join FPF_IRS_TWITTER_EXT on id=tid and code='申告类型' " +
				" left join (select distinct pid p_id,'已回复' reply_type from FPF_IRS_TWITTER where state='申告' and pid is not null) b on ID=p_id " +
				" left join (select username, mobile from fpf_irs_application_charge group by (username, mobile)) n on n.username=a.RESPONSIBLE " + 
				" where state='申告' and pid is null";
		if(!"".equals(kw) && kw!=null){
			int index = kw.indexOf("'");
			if(index>-1){
				kw = kw.replace("'", "");
			}
		}
		if (kw != null && kw.length() > 0) {
			sql += " and content like '%" + kw + "%'";
		}
		if (issue_type != null && issue_type.length() > 0) {
			sql += " and value = '" + issue_type + "'";
		}

		List<Issue> issues = this.jdbcTemplate.query(pageSqlGen.getLimitSQL(sql, pageSize, (page - 1) * pageSize + 1, " case when reply_type='未回复' and trim(responsible)='"+username+"' then 1 else 2 end, create_dt desc"), issueMapper);
		return issues;
	}

	public int getIssuesCount(String kw, String reply_type) {
		String sql = "select id,pid,user_id,user_name,create_dt,value(value,'应用申告') type,case when reply_type='已回复' then reply_type when reply='已转数据质量组' and reply_type is null then reply else '未回复' end reply_type,content,file_name,value(telephone,'') telephone,value(responsible,'') responsible from FPF_IRS_TWITTER a left join FPF_IRS_TWITTER_EXT on id=tid and code='申告类型' left join (select distinct pid p_id,'已回复' reply_type from FPF_IRS_TWITTER where state='申告' and pid is not null) b on ID=p_id where state='申告' and pid is null";
		if(!"".equals(kw) && kw!=null){
			int index = kw.indexOf("'");
			if(index>-1){
				kw = kw.replace("'", "");
			}
		}
		if (kw != null && kw.length() > 0) {
			sql += " and content like '%" + kw + "%'";
		}
		if(reply_type != null && reply_type.length() > 0){
			sql += " and value = '" + reply_type + "'";
		}
		return this.jdbcTemplate.queryForObject(pageSqlGen.getCountSQL(sql),Integer.class);
	}

	/**
	 * 得到申告
	 * 
	 * @param appId
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getIssuesById(String id) {
		m_log.info("id=" + id);
		try {
			Integer i = Integer.valueOf(id);
			List<Issue> issues = this.jdbcTemplate.query("select id,pid,user_id,user_name,create_dt,value(value,'应用申告') type," +
					" CASE WHEN reply_type='已回复' THEN reply_type ELSE '' END reply_type,content,file_name,value(telephone,'') telephone," +
					" value(responsible,'') responsible,value(end_time,'') end_time, value(mobile,'') mobile from FPF_IRS_TWITTER " +
					" left join FPF_IRS_TWITTER_EXT on id=tid and code='申告类型' " +
					" LEFT JOIN (SELECT DISTINCT pid p_id, '已回复' reply_type FROM FPF_IRS_TWITTER WHERE STATE='申告' AND pid IS NOT NULL) b ON ID=p_id" +
					" left join (select username, mobile from fpf_irs_application_charge group by (username, mobile)) n on n.username=RESPONSIBLE " +
					" where state='申告' and (id = ? or pid=?)  order by id fetch first 15 rows only", new Object[] { i, i },
					issueMapper);
			return issues;
		} catch (Exception e) {
			m_log.error("查询申告信息出现异常：" + e.getMessage());
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * 活跃用户
	 * 
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getActiveUsers(String userId) {
		List<User> users = this.jdbcTemplate.query("select user_id,user_name from FPF_IRS_TWITTER where user_id in(select distinct userid from fpf_user_user) and date(create_dt)>current_date - 2 months group by user_id,user_name order by count(*) desc fetch first 8 rows only", new RowMapper() {
			public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
				String userId = rs.getString("user_id");
				UserDao userDao = (UserDao) BeanFactoryA.getBean("userDao");
				return userDao.getUserById(userId);
			}
		});
		return users;
	}
	
	@SuppressWarnings("rawtypes")
	public int delete(Issue issue){
		int flag = 0;
		Long id = issue.getId();
		Long pid = issue.getPid();
		//如果pid==0表示是申告，删除申告首先删除此申告下的回复
		if(pid==0){
			List list = this.jdbcTemplate.queryForList("select id from FPF_IRS_TWITTER where pid=?  order by id fetch first 15 rows only", new Object[] { id });
			if(list!=null && list.size()>0){
				for(int i=0;i<list.size();i++){
					HashMap map = (HashMap)list.get(i);
					String Id = map.get("id").toString();
					//删除回复
					flag = jdbcTemplate.update("delete from FPF_IRS_TWITTER where id=? ", new Object[] { Id });
					jdbcTemplate.update("delete from FPF_IRS_TWITTER_EXT where tid=? ", new Object[] { Id });
				}
			}
		}
		//删除申告
		flag = jdbcTemplate.update("delete from FPF_IRS_TWITTER where id=? ", new Object[] { id });
		jdbcTemplate.update("delete from FPF_IRS_TWITTER_EXT where tid=? ", new Object[] { id });
		return flag;
	}
	
	public int addResponsble(int sid, String assignTo){
		int flag = 0;
		flag = jdbcTemplate.update("update FPF_IRS_TWITTER set responsible=? where id=? ", new Object[] { assignTo.trim(), sid });
		return flag;
	}
	
	@SuppressWarnings("rawtypes")
	public String getName(String telephone){
		String username = "";
		List list = this.jdbcTemplate.queryForList("select username from fpf_user_user where mobilephone=?", new Object[] {telephone});
		if(list!=null && list.size()>0){
			Map map = (Map)list.get(0);
			username = map.get("username").toString();
		}
		return username;
	}
	
	public int updateReplyTime(String sid){
		Date d= new Date();
		int flag = 0;
		flag = jdbcTemplate.update("update FPF_IRS_TWITTER set reply_time=? where id=? ", new Object[] { d, sid });
		return flag;
	}
	
	public List<Map<String, Object>> getTwitterType(){
		String sql = "select * from fpf_irs_application_charge order by sort";
		return this.jdbcTemplate.queryForList(sql);
	}
	
	public void saveReply(String issueId, String content, String bomcId, String userId, String userName, String type){
		
//		Long id = this.jdbcTemplate.queryForLong("select max(id) from FPF_IRS_TWITTER") + 1;
		int id = jdbcTemplate.queryForObject("values nextval for fpf_irs_twitter_id",Integer.class);
		String insertSql = "insert into FPF_IRS_TWITTER (id, pid, user_Id,user_Name,state,content, bomc_id) values (?,?,?,?,?,?,?)";
		this.jdbcTemplate.update(insertSql, new Object[]{id, Long.valueOf(issueId), userId, userName,"申告",content, bomcId});
		
		this.updateIssueType(String.valueOf(id), type);
	}
	
	public void changePrincipal(String issueId, String type, String userName){
		String sql1 = "update FPF_IRS_TWITTER set responsible=? where id=?";
		this.jdbcTemplate.update(sql1, new Object[]{userName, Long.valueOf(issueId)});
		
		this.updateIssueType(issueId, type);
	}
	
	public List<Issue> getIssueById(String issueId){
		String sql = "select id,pid,user_id,user_name,create_dt,value(value,'应用申告') type,'' reply_type, " +
				" content,file_name,value(telephone,'') telephone,value(responsible,'') responsible, " +
				" '' mobile ,value(end_time,'') end_time from FPF_IRS_TWITTER " +
				" left join FPF_IRS_TWITTER_EXT on ID=TID where id=? and state='申告' and pid is null";
		@SuppressWarnings("unchecked")
		List<Issue> issues = this.jdbcTemplate.query(sql, new Object[]{issueId}, issueMapper);
		return issues;
	}
	
}
