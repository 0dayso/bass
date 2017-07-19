package com.asiainfo.bass.apps.log;

import java.util.List;

import javax.sql.DataSource;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import com.asiainfo.bass.components.models.JdbcTemplate;

@Repository
public class LogActionDao {
	
	private static Logger LOG = Logger.getLogger(LogActionDao.class);
	
	@Autowired
	private DataSource dataSource;

	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSourceDw;

	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSourceNl;
	
	public int inserLogAction(String userid,String ip, String app_serv, String opertype, String opername, String app_code, String app_name, String mod_code, String mod_name, String opercontent, String operresult){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.update("insert into FPF_ACTION_LOG(USERID, IP, APP_SERV, OPERTYPE, OPERNAME, APP_CODE, APP_NAME, MOD_CODE, MOD_NAME, OPERCONTENT, OPERRESULT) values(?,?,?,?,?,?,?,?,?,?,?)", new Object[] { userid, ip, app_serv, opertype, opername, app_code, app_name, mod_code, mod_name, opercontent, operresult });
	}
	
	//上传下载文档服务器日志
	public void insertFileLog(String userid, String sid, String type){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update("insert into FPF_FILE_LOG(USERID, SID, TYPE) values(?,?,?)", new Object[] { userid, sid, type });
	}
	
	@SuppressWarnings("rawtypes")
	public List getNextLevel(String userid){
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		return jdbcTemplate.queryForList("select parentuserid from level_config where userid=? ", new Object[] { userid });
	}
	
	public void dele(String loginname, String date1, String date2){
		String userid = "";
		int index = loginname.indexOf("#");
		if(index>-1){
			String[] str = loginname.split("#");
			for(int i=0;i<str.length;i++){
				if(i==0){
					userid = str[i];
				}else{
					userid = userid + "','" + str[i];
				}
			}
		}else{
			userid = loginname;
		}
		String sql = "delete from FPF_VISITLIST where loginname in ('"+userid+"') and date(create_dt) >= '"+date1+"' and date(create_dt)<='"+date2+"'";
		LOG.info(sql);
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		jdbcTemplate.update(sql);
	}

}
