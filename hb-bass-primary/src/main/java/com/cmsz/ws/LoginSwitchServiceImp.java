package com.cmsz.ws;

import javax.jws.WebService;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.asiainfo.bass.apps.models.LogDao;
import com.asiainfo.hb.web.models.ResultVO;

@WebService(endpointInterface="com.cmsz.ws.LoginSwitchService",targetNamespace="http://impl.ws.com")
@Service("loginSwitchServiceImp")
public class LoginSwitchServiceImp implements LoginSwitchService {
	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(LoginSwitchServiceImp.class);
	@Autowired
	private LogDao logDao;
	
	public LogDao getLogDao() {
		return logDao;
	}

	public void setLogDao(LogDao logDao) {
		this.logDao = logDao;
	}

	@Override
	public ResultVO loginModChg(String flag) {
		ResultVO rv = new ResultVO();
		try {
			logDao.loginModChg(flag);
			rv.setResult("0");
			rv.setResultDesc("操作成功");
		} catch (Exception e) {
			rv.setResult("1");
			rv.setResultDesc(e.getMessage());
			e.printStackTrace();
		}
		logDao.writeLog("4A", Integer.parseInt(rv.getResult()), "loginModChg", rv.getResultDesc());
		return rv;
	}

}

