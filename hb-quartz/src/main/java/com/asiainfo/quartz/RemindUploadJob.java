package com.asiainfo.quartz;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.bass.components.models.JdbcTemplate;

/**
 * 提醒指定用户上传附件
 * @author Administrator
 *
 */
//@Component
@SuppressWarnings("rawtypes")
public class RemindUploadJob {
	private static Logger m_log = Logger.getLogger(RemindUploadJob.class);
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dataSource){
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	
	//@Scheduled(cron="0 0 9 1-5 * ?")
	public void execute(){
		m_log.info("提醒用户上传三表合一附件");
		try {
			if(!hasUpload()){
				m_log.info("用户未上传附件，提醒……");
				//张江号码
				String contact = "15926450672";
				String content = "请上传本月的三表合一附件";
				String smsSql = "insert into websendsms (tele, msg, flag) values ('" + contact +"', '" + content + "','N')";
				this.jdbcTemplate.update(smsSql);
			}else{
				m_log.info("用户已经上传过三表合一附件");
			}
		} catch (Exception e) {
			m_log.info("三表合一附件上传提醒出现异常，异常信息：" + e.getMessage());
			e.printStackTrace();
		}
	}
	
	private boolean hasUpload(){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		String sql = "select * from three_forms_audit where month='" + sdf.format(new Date()) + "'";
		List list = this.jdbcTemplate.queryForList(sql);
		return list != null && list.size()>0;
	}
	
}
