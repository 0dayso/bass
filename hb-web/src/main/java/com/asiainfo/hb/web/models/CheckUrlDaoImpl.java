package com.asiainfo.hb.web.models;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.RowMapper;

import com.asiainfo.hb.core.models.JdbcTemplate;
import com.asiainfo.hb.core.util.IdGen;

/**
 * 访问错误的url
 * @author ice
 *
 */
public class CheckUrlDaoImpl implements CheckUrlDao{

	private JdbcTemplate jdbcTemplate;
	
	public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	@Autowired
    public void setDataSource(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }
	
	/**
	 * 查询URL菜单中所有不为空并且启用的URL
	 */
	public List<String> getAllUrl(){
		return jdbcTemplate.queryForList("SELECT URL FROM ST.FPF_SYS_MENU_ITEMS WHERE URL !='' AND STATE = '0'", String.class);
	}
	
	/**
	 * 新增访问错误的url记录
	 */
	public int[] insertErrorUrl(final List<ErrorPageInfoVO> checkUrl){
		return jdbcTemplate.batchUpdate("insert into ST.FPF_ERROR_PAGE_INFO(errorPageId,menuItemId,menuItemTitle,url,errorCode,errorMessage,errorDate,sendPhoneNum,sendState) "
				+ "values(?,?,?,?,?,?,?,?,?)", new BatchPreparedStatementSetter(){

					@Override
					public int getBatchSize() {
						return checkUrl.size();
					}

					@Override
					public void setValues(PreparedStatement ps, int i) throws SQLException {
						ErrorPageInfoVO check = checkUrl.get(i);
						ps.setString(1, IdGen.genId());
						ps.setString(2, check.getMenuItemId());
						ps.setString(3, check.getMenuItemTitle());
						ps.setString(4, check.getUrl());
						ps.setInt(5, check.getErrorCode());
						ps.setString(6, check.getErrorMessage());
						ps.setTimestamp(7, check.getErrorDate());
						ps.setString(8, check.getSendPhoneNum());
						ps.setString(9, check.getSendState());
					}
				});
	}
	
	/**
	 * 查询URL菜单中所有不为空的菜单信息
	 */
	@SuppressWarnings("unchecked")
	public List<ErrorPageInfoVO> getUrlVO(){
		String sql = "SELECT MENUITEMID,MENUITEMTITLE,URL FROM ST.FPF_SYS_MENU_ITEMS WHERE URL !=''";
		return (List<ErrorPageInfoVO>)jdbcTemplate.query(sql, new String[]{},new CheckUrlVOMapper());
	}
	
	@SuppressWarnings("rawtypes")
	private static  class CheckUrlVOMapper implements RowMapper {
		public Object mapRow(ResultSet rs, int rowNum) throws SQLException {
			ErrorPageInfoVO checkUrl = new ErrorPageInfoVO(rs.getString("menuItemId"),rs.getString("menuItemTitle"),rs.getString("url"));
			checkUrl.setMenuItemId(rs.getString("menuItemId"));
			checkUrl.setMenuItemTitle(rs.getString("menuItemTitle"));
			checkUrl.setUrl(rs.getString("url"));
			return checkUrl;
		}
	}
}
