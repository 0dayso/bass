package com.asiainfo.hbbass.ws.bo;

import com.asiainfo.bass.components.models.BeanFactoryA;
import com.asiainfo.hbbass.ws.dao.LogDAO;
import com.asiainfo.hbbass.ws.model.LogModel;

public class LogBO {
	private LogBO() {
	}

	private static LogBO instance = null;

	public static LogBO getInstance() {
		if (instance == null) {
			instance = new LogBO();
		}
		return instance;
	}

	public void insertLog(LogModel logModel) throws Exception {
		LogDAO logDAO = (LogDAO) BeanFactoryA.getBean("logDAO");
		logDAO.insertLog(logModel);
	}
}
