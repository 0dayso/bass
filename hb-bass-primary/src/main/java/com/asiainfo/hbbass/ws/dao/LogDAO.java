package com.asiainfo.hbbass.ws.dao;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hbbass.ws.model.LogModel;

@Repository
public class LogDAO {

	private static Logger LOG = Logger.getLogger(LogDAO.class);

	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSource;

	@SuppressWarnings("unused")
	@Autowired
	private DataSource dataSourceDw;

	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource,false);
	}
	
	@SuppressWarnings("unused")
	private JdbcTemplate jdbcTemplateDw;

	@Autowired
	public void setDataSourceDw(DataSource dataSourceDw) {
		this.jdbcTemplateDw = new JdbcTemplate(dataSourceDw,false);
	}

	private LogDAO() {
	}

	public void insertLog(LogModel logModel) {
		try {
			String insertSQL = " INSERT INTO FPF_SENSITIVE_LOG_4A(USERID,CLIENTIP,NID,SCENEID,OPERATE,ISSENSITIVE,VISITDATESTR,COMMENT,COOPERATE, APPLYREASON, OPERATECONTENT, IMPOWERFASHION, IMPOWERCONDITION, IMPOWERRESULT, IMPOWERTIME, IMPOWERIDEA, RESULT)" + " VALUES('" + logModel.getUserID() + "','" + logModel.getClientIp() + "','" + logModel.getNid() + "','" + logModel.getSceneId() + "','" + logModel.getOperate() + "','"
					+ logModel.getIsSensitive() + "','" + logModel.getVisitDateStr() + "','" + logModel.getComment() + "','" + logModel.getCooperate() + "','" + logModel.getApplyReason() + "','" + logModel.getOperateContent() + "','" + logModel.getImpowerFashion() + "','" + logModel.getImpowerCondition() + "','" + logModel.getImpowerResult() + "','" + logModel.getImpowerTime() + "','" + logModel.getImpowerIdea() + "','" + logModel.getResult() + "')";
			LOG.info("sql=================="+insertSQL);
			jdbcTemplate.execute(insertSQL);
		} catch (Exception e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}
	}
}
