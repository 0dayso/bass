package com.asiainfo.hb.bass.hb_webservice.service;

import java.util.Map;

import javax.jws.WebService;

import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.springframework.stereotype.Service;

import com.asiainfo.hb.bass.hb_webservice.common.Constant;
import com.asiainfo.hb.bass.hb_webservice.dao.AccountDao;
import com.asiainfo.hb.core.models.BeanFactory;

@WebService(endpointInterface = "com.asiainfo.hb.bass.hb_webservice.service.AccountWebService", serviceName = "AccountWebService", portName = "AccountWebServiceSOAP", targetNamespace = Constant.TARGET_NAMESPACE_JF)
@Service("accountWebServiceImp")
public class AccountWebServiceImp {

	private static Logger mLog = Logger.getLogger(AccountWebServiceImp.class);
	
	public String queryAccount(String requestXml){
		mLog.info("-----------------------------------------");
		mLog.info(requestXml);
		mLog.info("-----------------------------------------");
		
		try {
			Document doc = DocumentHelper.parseText(requestXml);
			Element request = doc.getRootElement();
			Element head = request.element("head");
			Element eMethod = head.element("method");
			Element eAppId = head.element("appId");
			Element eSysFlag = head.element("sysFlag");
			String method = eMethod.getText();
			String appId = eAppId.getText();
			String sysFlag = eSysFlag.getText();
			
			Element body = request.element("body");
			Element eAccount = body.element("account");
			String account = eAccount.getText();
			
			mLog.info("method=" + method + ";appId=" + appId + ";account=" + account);
			AccountDao accountDao = (AccountDao) BeanFactory.getBean("accountDao");
			Map<String, Object> map = accountDao.getUserInfo(account);
			
			String userName = "";
			String status = "";
			
			if(null != map){
				mLog.info("查到指定用户");
				userName = (String) map.get("userName"); 
				status = String.valueOf(map.get("status"));
				mLog.info("userName=" + userName + ";status=" + status);
				status = "1".equals(status)? "01":"02";
				
				return joinQueryResp(sysFlag, appId, account, userName, status, false);
			}else{
				mLog.info("未查到指定用户");
				return joinQueryResp(sysFlag, appId, account, userName, status, true);
			}
		} catch (DocumentException e) {
			mLog.error("解析requestXml出问题");
			e.printStackTrace();
			return joinQueryResp("", "", "", "", "", true);
		}
	}
	
	/**
	 * 拼接查询账号信息返回结果
	 * @param sysFlag
	 * @param appId
	 * @param account
	 * @param userName
	 * @param status
	 * @return
	 */
	private String joinQueryResp(String sysFlag, String appId, String account, String userName, String status, boolean isNull){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		strBuf.append("<response>");
		strBuf.append("<head>");
		strBuf.append("<method>").append("queryAccount").append("</method>");
		strBuf.append("<responseTime>").append(Constant.getCurrentDate()).append("</responseTime>");
		strBuf.append("<sysFlag>").append(sysFlag).append("</sysFlag>");
		strBuf.append("<appId>").append(appId).append("</appId>");
		strBuf.append("</head>");	
		strBuf.append("<body>");
		if(isNull){
			strBuf.append("<resultCode>02</resultCode>");
		}else{
			strBuf.append("<resultCode>01</resultCode>");
			strBuf.append("<account>").append(account).append("</account>");	
			strBuf.append("<accountName>").append(userName).append("</accountName>");	
			strBuf.append("<accountStatus>").append(status).append("</accountStatus>");	
		}
		strBuf.append("</body>");	
		strBuf.append("</response>");
		return strBuf.toString();
	}
	
	public String delAccount(String requestXml){
		mLog.info("-----------------------------------------");
		mLog.info(requestXml);
		mLog.info("-----------------------------------------");
		
		try {
			Document doc = DocumentHelper.parseText(requestXml);
			Element request = doc.getRootElement();
			Element head = request.element("head");
			Element eMethod = head.element("method");
			Element eAppId = head.element("appId");
			Element eSysFlag = head.element("sysFlag");
			
			Element body = request.element("body");
			Element eAccount = body.element("account");
			
			String method = eMethod.getText();
			String appId = eAppId.getText();
			String sysFlag = eSysFlag.getText();
			String account = eAccount.getText();
			
			mLog.info("method=" + method + ";appId=" + appId + ";sysFlag=" + sysFlag + ";account=" + account);
			
			AccountDao accountDao = (AccountDao) BeanFactory.getBean("accountDao");
			accountDao.delAccount(account);
			
			return joinDelResp(sysFlag, appId, "01", "成功");
		} catch (DocumentException e) {
			mLog.error("解析requestXml出问题");
			e.printStackTrace();
			return joinDelResp("", "", "02", "解析requestXml出问题");
		}
	}
	
	/**
	 * 拼接注销账号接口返回结果
	 * @param sysFlag
	 * @param appId
	 * @param resultCode
	 * @param result
	 * @return
	 */
	private String joinDelResp(String sysFlag, String appId, String resultCode, String result){
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		strBuf.append("<response>");
		strBuf.append("<head>");
		strBuf.append("<method>").append("delAccount").append("</method>");
		strBuf.append("<responseTime>").append(Constant.getCurrentDate()).append("</responseTime>");
		strBuf.append("<sysFlag>").append(sysFlag).append("</sysFlag>");
		strBuf.append("<appId>").append(appId).append("</appId>");
		strBuf.append("</head>");	
		
		strBuf.append("<body>");	
		strBuf.append("<resultCode>").append(resultCode).append("</resultCode>");	//01:成功，02:失败
		strBuf.append("<result>").append(result).append("</result>");	
		strBuf.append("</body>");	
		strBuf.append("</response>");	
		return strBuf.toString();
	}
	
}