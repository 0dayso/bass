package com.asiainfo.bass.apps.models;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

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
public class TwitterDao {

	private JdbcTemplate jdbcTemplate;

	@SuppressWarnings("rawtypes")
	private RowMapper twitterMapper = new TwitterMapper();

	@Autowired
	private PageSqlGen pageSqlGen;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	public void save(Twitter t) {
		if (t.getReplyId() != null && t.getReplyId().length() > 0 && t.getContent().startsWith("@")) {
			t.setContent(t.getContent().substring(t.getContent().indexOf(" ") + 1));
		}

		if (t != null && t.getId() == null) {
			long id = this.jdbcTemplate.queryForObject("values nextval for IRS_TWITTER_id",Integer.class);
			t.setId(Long.valueOf(id));
			this.jdbcTemplate.update("insert into FPF_IRS_TWITTER (id ,pid ,user_id ,user_name ,reply_id ,reply ,state,content) values (? ,? ,? ,? ,? ,? ,? ,? )", new Object[] { id, t.getPid(), t.getUser().getId(), t.getUser().getName(), t.getReplyId(), t.getReply(), t.getState(), t.getContent() });
		} else {
			this.jdbcTemplate.update("update FPF_IRS_TWITTER pid=? ,user_id=? ,user_name=? ,reply_id=? ,reply=? ,state=?,content=? where id=?", new Object[] { t.getPid(), t.getUser().getId(), t.getUser().getName(), t.getReplyId(), t.getReply(), t.getState(), t.getContent(), t.getId() });
		}
	}

	@SuppressWarnings("rawtypes")
	static final class TwitterMapper implements RowMapper {

		public Object mapRow(ResultSet rs, int rowNum) throws SQLException {

			Twitter t = new Twitter();
			t.setId(rs.getLong("id"));
			t.setPid(rs.getLong("pid"));
			String userId = rs.getString("user_id");
			UserDao userDao = (UserDao) BeanFactoryA.getBean("userDao");
			t.setUser(userDao.getUserById(userId));
			t.setReplyId(rs.getString("reply_id"));
			t.setReply(rs.getString("reply"));
			t.setCreateDt(rs.getTimestamp("create_dt"));
			t.setState(rs.getString("state"));
			t.setContent(rs.getString("content"));
			return t;
		}
	}

	@SuppressWarnings("unchecked")
	public Twitter getTwitterById(Long id) {

		Twitter t = (Twitter) this.jdbcTemplate.queryForObject("select id,pid,user_id,user_name,reply_id,reply,create_dt,state,content from FPF_IRS_TWITTER where id = ?", new Object[] { id }, twitterMapper);
		return t;
	}

	public String feed(String userId, String fUserId) {

		this.jdbcTemplate.update("insert into IRS_TWITTER_feed(user_id ,f_user_id) values (? ,?)", new Object[] { userId, fUserId });

		return "成功";
	}

	/**
	 * 得到所有喳喳
	 * 
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getTwitters(int page, int pageSize) {
		String sql = "select id,pid,user_id,user_name,reply_id,reply,create_dt,state,content from FPF_IRS_TWITTER";

		List<Twitter> twitters = this.jdbcTemplate.query(pageSqlGen.getLimitSQL(sql, pageSize, (page - 1) * pageSize + 1, " create_dt desc"), twitterMapper);
		return twitters;
	}

	public int getTwittersCount() {
		String sql = "select id,pid,user_id,user_name,reply_id,reply,create_dt,state,content from FPF_IRS_TWITTER";
		return this.jdbcTemplate.queryForObject(pageSqlGen.getCountSQL(sql),Integer.class);
	}

	/**
	 * 得到某人的喳喳
	 * 
	 * @param userId
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getUserTwitters(String userId) {
		List<Twitter> twitters = this.jdbcTemplate.query("select id,pid,user_id,user_name,reply_id,reply,create_dt,state,content from FPF_IRS_TWITTER where user_id=?  order by create_dt desc fetch first 15 rows only", new Object[] { userId }, twitterMapper);
		return twitters;
	}

	/**
	 * 得到@我的喳喳
	 * 
	 * @param userId
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getAtUserTwitters(String userId) {
		List<Twitter> twitters = this.jdbcTemplate.query("select id,pid,user_id,user_name,reply_id,reply,create_dt,state,content from FPF_IRS_TWITTER where reply_id=?  order by create_dt desc fetch first 15 rows only", new Object[] { userId }, twitterMapper);
		return twitters;
	}

	/**
	 * 得到@app的评论
	 * 
	 * @param appId
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public List getComments(String appId, int page, int pageSize) {
		String sql = "select id,pid,user_id,user_name,reply_id,reply,create_dt,state,content from FPF_IRS_TWITTER where reply_id=? and state='评论' ";
		@SuppressWarnings("unchecked")
		List<Twitter> twitters = this.jdbcTemplate.query(pageSqlGen.getLimitSQL(sql, pageSize, (page - 1) * pageSize + 1, " create_dt desc"), new String[] { appId }, twitterMapper);

		return twitters;
	}

	public int getCommentsCount(String appId) {
		String sql = "select id,pid,user_id,user_name,reply_id,reply,create_dt,state,content from FPF_IRS_TWITTER where reply_id=? and state='评论' ";
		return this.jdbcTemplate.queryForObject(pageSqlGen.getCountSQL(sql), new String[] { appId },Integer.class);
	}

	/**
	 * 关注的人
	 * 
	 * @param userId
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getFeed(String userId) {

		List<Twitter> twis = this.jdbcTemplate.query("select id,pid,b.user_id,b.user_name,reply_id,reply,b.create_dt,state,content from IRS_TWITTER_feed a " + " left join (select * from FPF_IRS_TWITTER where id in (select max(id) from FPF_IRS_TWITTER group by user_id)) b on b.user_id=a.f_user_id" + " where a.user_id=?",
				new Object[] { userId }, twitterMapper);
		return twis;
	}

	/**
	 * 被关注的人
	 * 
	 * @param userId
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getFed(String userId) {
		List<Twitter> twis = this.jdbcTemplate.query("select id,pid,b.user_id,b.user_name,reply_id,reply,b.create_dt,state,content from IRS_TWITTER_feed a " + " left join (select * from FPF_IRS_TWITTER where id in (select max(id) from FPF_IRS_TWITTER group by user_id)) b on b.user_id=a.user_id" + " where a.f_user_id=?",
				new Object[] { userId }, twitterMapper);
		return twis;
	}

	/**
	 * 活跃用户
	 * 
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getActiveUsers(String userId) {
		List<User> users = this.jdbcTemplate.query("select user_id,user_name from FPF_IRS_TWITTER where create_dt>current_date- 15 days group by user_id,user_name having user_id not in (select f_user_id from IRS_TWITTER_feed where user_id=?) and user_id!=? order by count(*) desc fetch first 12 rows only", new Object[] {
				userId, userId }, new RowMapper() {
			public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
				String userId = rs.getString("user_id");
				UserDao userDao = (UserDao) BeanFactoryA.getBean("userDao");
				return userDao.getUserById(userId);
			}
		});
		return users;
	}
}
