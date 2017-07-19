package com.asiainfo.bass.apps.log;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.apache.log4j.Logger;
import com.asiainfo.bass.apps.models.LogBass;
import com.asiainfo.bass.components.models.JdbcTemplate;

/**
 * @author mei xianxin
 * @date 2013-1-9
 * 
 */
@Repository
public class LogBassDao {
	private final static Logger log = Logger.getLogger(LogBassDao.class);

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	public void addLog(LogBass logBass) {
		String userId = logBass.getUserId();
		String operTime = logBass.getOperTime();
		String operType = logBass.getOperType();
		String operName = logBass.getOperName();
		String appCode = logBass.getAppCode();
		String appName = logBass.getAppName();
		String modCode = logBass.getModCode();
		String modName = logBass.getModName();
		String operContent = logBass.getOperContent();
		String operResult = logBass.getOperResult();
		String ip = logBass.getIp();
		String appServ = logBass.getAppServ();

		String sql = "insert into FPF_ACTION_LOG(userid,opertime,ip,app_serv,opertype,opername,app_code,app_name,mod_code,mod_name,opercontent,operresult) values(?,?,?,?,?,?,?,?,?,?,?,?)";
		log.debug("userid:" + userId + ",opertime:" + operTime + ",ip:" + ip
				+ ",app_serv:" + appServ + ",opertype:" + operType
				+ ",opername:" + operName + ",app_code:" + appCode
				+ ",app_name:" + appName + ",mod_code:" + modCode
				+ ",mod_name:" + modName + ",opercontent:" + operContent
				+ ",operresult:" + operResult);
		log.debug("添加后台日志SQL：" + sql);
		jdbcTemplate.update(sql, new Object[] { userId, operTime, ip, appServ,
				operType, operName, appCode, appName, modCode, modName,
				operContent, operResult });

	}

}
