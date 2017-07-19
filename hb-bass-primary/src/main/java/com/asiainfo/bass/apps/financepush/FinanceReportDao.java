package com.asiainfo.bass.apps.financepush;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hbbass.common.jdbc.ConnectionManage;

@Repository
@SuppressWarnings({"rawtypes"})
public class FinanceReportDao {
	
	private static Logger LOG = Logger.getLogger(FinanceReportDao.class);
	
	
	@Autowired
	private DataSource dataSource;

	@Autowired
	private DataSource dataSourceDw;

	@Autowired
	private DataSource dataSourceNl;
	
	/**
	 * 根据SQL和数据库名称得到结果
	 * @param sql			
	 * @param dateSource	数据库名称
	 * @return
	 */
	public List getList(String sql,String dateSource){
		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(dateSource))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(dateSource)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}
		return jdbcTemplate.queryForList(sql);
	}
	
	/**
	 * 根据SQL和数据库名称得到结果
	 * @param sql			
	 * @param dateSource	数据库名称
	 * @return
	 */
	public SqlRowSet getRowSet(String sql, String dateSource){
		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(dateSource))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(dateSource)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}
		return jdbcTemplate.queryForRowSet(sql);
	}
	
	/**
	 * 邮件发送表中增加日志
	 * @param strTo 	发送人
	 * @param fileName	发送文件名称
	 * @return
	 */
	public boolean insertVISITLIST(String strTo, String fileName){
		boolean flag = false;
		String insertSql = "insert into FPF_VISITLIST(loginname,area_id,track,opertype,opername) values(?,?,?,?,?)";
		Connection  conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			PreparedStatement ps = conn.prepareStatement(insertSql);
			ps.setString(1, "sender");
			ps.setInt(2, 0);
			ps.setString(3, "信息推送-邮件");
			ps.setString(4, strTo);
			ps.setString(5, fileName);
			
			flag = ps.execute();
			LOG.info("邮件发送插入日志结果===="+flag);
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			ConnectionManage.getInstance().releaseConnection(conn);
		}
		return flag;
	}
	
	public List getListByGroupId(String sql, String dateSource, String groupId){
		JdbcTemplate jdbcTemplate = null;
		if ("web".equalsIgnoreCase(dateSource))
			jdbcTemplate = new JdbcTemplate(dataSource, false);
		else if ("nl".equalsIgnoreCase(dateSource)) {
			jdbcTemplate = new JdbcTemplate(dataSourceNl, false);
		} else {
			jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		}
		return jdbcTemplate.queryForList(sql, new Object[] { groupId });
	}
	
	public List getHeader(String sid){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select name,data_index from FPF_IRS_SUBJECT_INDICATOR where sid=? order by seq", new Object[] { sid });
	}
}
