package com.asiainfo.hbbass.ws.dao;

import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
public class SystemCodeDAO {

	private static Logger LOG = Logger.getLogger(SystemCodeDAO.class);

	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSource;
	
	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	private SystemCodeDAO() {
	}

	/**
	 * 更新经分系统当前金库模式开关值
	 */
	public void setIsOpen(String value) {
		try {
			if (StringUtils.isNotBlank(value)) {
				String updateSQL = "UPDATE FPF_SYS_PARAMETERS SET PARAMETERVALUE = '" + value.trim() + "' WHERE PARAMETERID = 'SENSITIVE_4A_IS_OPEN'";
				jdbcTemplate.execute(updateSQL);
			}
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
	}

	/**
	 * 查询经分系统当前金库模式开关值
	 */
	@SuppressWarnings({"rawtypes"})
	public boolean getIsOpen() {
		boolean isOpen = false;
		try {
			String querySQL = "SELECT PARAMETERVALUE from FPF_SYS_PARAMETERS WHERE PARAMETERID = 'SENSITIVE_4A_IS_OPEN'";
			List list = this.jdbcTemplate.queryForList(querySQL);
			if (list != null && list.size() > 0) {
				Map map = (Map) list.get(0);
				String value = (String) map.get("PARAMETERVALUE");
				if (StringUtils.isNotBlank(value) && "Y".equals(value)) {
					isOpen = true;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
		return isOpen;
	}
}
