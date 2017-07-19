package com.asiainfo.bass.apps.models;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
public class LogDao {

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	/**
	 * 
	 * @param userId
	 * @param result
	 *            ������
	 * @param operName�ӿ����
	 * @param operType�������
	 */
	public void writeLog(String userId, int result, String operName, String operType) {
		this.jdbcTemplate.update("insert into FPF_VISITLIST(loginname,track,area_id,opertype,opername,create_dt) values(?,'4A',?,?,?,current timestamp)", new Object[] { userId, result, operType, operName });
	}

	public String getLoginMod() {
		return this.jdbcTemplate.queryForList("select parametervalue from FPF_SYS_PARAMETERS where parameterid='LoginSwitch' with ur").get(0).get("parametervalue").toString();
	}

	public void loginModChg(String flag) throws Exception {
		this.jdbcTemplate.update("update FPF_SYS_PARAMETERS set parametervalue=? where parameterid='LoginSwitch'", new Object[] { flag });
	}
}
