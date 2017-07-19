package com.asiainfo.hbbass.ws.bo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;
import org.dom4j.Element;

import com.asiainfo.bass.components.models.BeanFactoryA;
import com.asiainfo.hbbass.ws.common.Constant;
import com.asiainfo.hbbass.ws.dao.MenuInfoDAO;
import com.asiainfo.hbbass.ws.dto.StatusBodyInfoDTO;
import com.asiainfo.hbbass.ws.interfaceclient.InterfaceClient;
import com.asiainfo.hbbass.ws.model.MenuInfoModel;

public class DealBO {
	private static Logger LOG = Logger.getLogger(DealBO.class);
	private DealBO() {
	}

	private static DealBO instance = null;

	public static DealBO getInstance() {
		if (instance == null) {
			instance = new DealBO();
		}
		return instance;
	}

	public MenuInfoModel isLocaltionCheck(String nid, String typeOp) throws Exception {
		MenuInfoModel pInfoModel = new MenuInfoModel();
		pInfoModel.setId(nid);
		pInfoModel.setTypeOp(typeOp);
		MenuInfoDAO menuInfoDAO = (MenuInfoDAO) BeanFactoryA.getBean("menuInfoDAO");
		return menuInfoDAO.menuInfoByKey(pInfoModel);
	}

	/**
	 * 获取场景状态信息
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public StatusBodyInfoDTO getTreasuryStatus(String userId, String sceneId, String appSessionId, String ip,
			String account) throws Exception {
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("CertificationStatusQuery").append("</method>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<resType>app</resType>");
		stringBuffer.append("<account>").append(account).append("</account>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("<sceneId>").append(sceneId).append("</sceneId>");
		stringBuffer.append("<sceneName>").append("").append("</sceneName>");
		stringBuffer.append("<sensitiveData>").append("").append("</sensitiveData>");
		stringBuffer.append("<sensitiveOperate>").append("").append("</sensitiveOperate>");
		stringBuffer.append("<appSessionId>").append(appSessionId).append("</appSessionId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		LOG.info("stringBuffer = "+stringBuffer.toString());
		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(),
				"getTreasuryStatus", "reqMsg", "getTreasuryStatusResponse", "treasuryManagerResult");
		LOG.info("returnXml = "+returnXml);
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();								//场景状态
		String resultDesc = ((Element) element.element("resultDesc")).getText();						//原因
		String historyAppSessionId = ((Element) element.element("historyAppSessionId")).getText();		//历史有效应用sessionid
		//授权条件（必填属性）：当为0时，为单次授权；否则为时间段授权即允许以当前时间为开始时间，开始时间+maxTime时间为最大结束时间，允许用户在此范围选择
		String maxTime = ((Element) element.element("maxTime")).getText();								
		//多值授权方式与访问方式关系其中节点policyAuthMethod:授权方式 policyAccessMethod:访问方式
		List elementRelationList = root.selectNodes("/response/body/relation");							
		Iterator<Element> iter = elementRelationList.iterator();
		ArrayList<HashMap<String, String>> relations = new ArrayList<HashMap<String, String>>();
		while (iter.hasNext()) {
			Element relationInfo = (Element) iter.next();
			if (relationInfo != null) {
				relations.add(this.parseRelationInfo(relationInfo));
				@SuppressWarnings({ "unused" })
				HashMap map = this.parseRelationInfo(relationInfo);
			}
		}

		List elementApproverList = root.selectNodes("/response/body/approvers/approver");
		iter = elementApproverList.iterator();
		ArrayList<String> approver = new ArrayList<String>();
		while (iter.hasNext()) {
			String str = (String)iter.next().getText();
			approver.add(str);
		}
		StatusBodyInfoDTO bodyInfoDTO = new StatusBodyInfoDTO();
		bodyInfoDTO.setResult(result);
		bodyInfoDTO.setResultDesc(resultDesc);
		bodyInfoDTO.setRelations(relations);
		bodyInfoDTO.setApprovers(approver);
		if(!"".equals(historyAppSessionId) && historyAppSessionId != null){
			bodyInfoDTO.setHistoryAppSessionId(historyAppSessionId);
		}
		bodyInfoDTO.setMaxTime(maxTime);			
//		private String cooperate;//协同操作人
//		private String applyReason;//申请原因
//		private String operateContent;//操作内容
//		private String impowerResult;//授权结果
//		private String impowerTime;//授权时间
//		private String impowerIdea;//授权意见
		return bodyInfoDTO;
	}

	/**
	 * 获取4A主账号
	 */
	@SuppressWarnings("unchecked")
	public ArrayList<String> getAccount(String userId, String ip) throws Exception {
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("ApproverQuery").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		LOG.info("stringBuffer = "+stringBuffer);
		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "getAccount",
				"reqMsg", "getAccountResponse", "accountResult");
		LOG.info("returnXml = "+returnXml);
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);

		@SuppressWarnings("rawtypes")
		List elementAccountList = root.selectNodes("/response/body/account");
		Iterator<Element> iter = elementAccountList.iterator();
		ArrayList<String> accounts = new ArrayList<String>();
		while (iter.hasNext()) {
			accounts.add(iter.next().getText());
		}
		return accounts;
	}

	/**
	 * 现场授权认证
	 */
	public boolean siteAuth(String userId, String nid, String appSessionId, String approverAccount,
			String authCode, String beginTimeStr, String endTimeStr, String ip, String account, String sceneId)
			throws Exception {
		boolean isPass = false;
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("authent_type_static").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<account>").append(account).append("</account>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("<approverAccount>").append(approverAccount).append("</approverAccount>");
		stringBuffer.append("<beginTime>").append(beginTimeStr).append("</beginTime>");
		stringBuffer.append("<endTime>").append(endTimeStr).append("</endTime>");
		stringBuffer.append("<authCode>").append(authCode).append("</authCode>");
		stringBuffer.append("<moreMsg>").append("").append("</moreMsg>");
		stringBuffer.append("<appSessionId>").append(appSessionId).append("</appSessionId>");
		stringBuffer.append("<sceneId>").append(sceneId).append("</sceneId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		LOG.info("stringBuffer = " +stringBuffer.toString());

		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "siteAuth",
				"reqMsg", "siteAuthResponse", "siteAuthResult");
		LOG.info("returnXml = " +returnXml);
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();
		if ("1".equals(result)) {
			isPass = true;
		}
		return isPass;
	}

	/**
	 * 远程授权第一次认证
	 */
	public boolean remoteFirstAuth(String userId, String nid, String appSessionId, String approverAccount,
			String cerReason, String beginTimeStr, String endTimeStr, String ip, String account,
			String sceneId) throws Exception {
		boolean isPass = false;
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("RemoteAuthorization").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<resType>app</resType>");
		stringBuffer.append("<account>").append(account).append("</account>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("<approverAccount>").append(approverAccount).append("</approverAccount>");
		stringBuffer.append("<beginTime>").append(beginTimeStr).append("</beginTime>");
		stringBuffer.append("<endTime>").append(endTimeStr).append("</endTime>");
		stringBuffer.append("<cerReason>").append(cerReason).append("</cerReason>");
		stringBuffer.append("<appSessionId>").append(appSessionId).append("</appSessionId>");
		stringBuffer.append("<sceneId>").append(sceneId).append("</sceneId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		LOG.info("stringBuffer = " +stringBuffer.toString());
		
		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "remoteFirstAuth", "reqMsg",
				"remoteFirstAuthResponse", "remoteFirstAuthResult");
		LOG.info("returnXml = " +returnXml);
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();
		if ("1".equals(result)) {
			isPass = true;
		}
		return isPass;
	}

	/**
	 * 远程授权第二次认证
	 */
	public boolean remoteSecondAuth(String userId, String nid, String appSessionId, String approverAccount,
			String dynamicCode, String beginTimeStr, String endTimeStr, String ip, String account,
			String sceneId) throws Exception {
		boolean isPass = false;
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("RemoteSecondAuthorization").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<resType>app</resType>");
		stringBuffer.append("<account>").append(account).append("</account>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("<approverAccount>").append(approverAccount).append("</approverAccount>");
		stringBuffer.append("<beginTime>").append(beginTimeStr).append("</beginTime>");
		stringBuffer.append("<endTime>").append(endTimeStr).append("</endTime>");
		stringBuffer.append("<dynamicCode>").append(dynamicCode).append("</dynamicCode>");
		stringBuffer.append("<appSessionId>").append(appSessionId).append("</appSessionId>");
		stringBuffer.append("<sceneId>").append(sceneId).append("</sceneId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		
		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "remoteSecondAuth",
				"reqMsg", "remoteSecondAuthResponse", "remoteSecondAuthResult");
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();
		if ("1".equals(result)) {
			isPass = true;
		}
		return isPass;
	}
	
	/**
	 * 工单认证
	 */

	public boolean workOrderAuth(String userId, String nid, String appSessionId, String operContent,
			String workorderNO, String beginTimeStr, String endTimeStr,String cerReason, String ip, String account,
			String sceneId) throws Exception {
		boolean isPass = false;
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("RemoteSecondAuthorization").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<resType>app</resType>");
		stringBuffer.append("<account>").append(account).append("</account>");
		stringBuffer.append("<subAccount>").append(userId).append("</subAccount>");
		stringBuffer.append("<operContent>").append(operContent).append("</operContent>");
		stringBuffer.append("<workorderNO>").append(workorderNO).append("</workorderNO>");
		stringBuffer.append("<beginTime>").append(beginTimeStr).append("</beginTime>");
		stringBuffer.append("<endTime>").append(endTimeStr).append("</endTime>");
		stringBuffer.append("<cerReason>").append(cerReason).append("</cerReason>");
		stringBuffer.append("<appSessionId>").append(appSessionId).append("</appSessionId>");
		stringBuffer.append("<sceneId>").append(sceneId).append("</sceneId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		LOG.info("stringBuffer = " +stringBuffer.toString());
		
		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(), "workOrderAuth", "reqMsg",
				"workOrderAuthResponse", "workOrderAuthResult");
		LOG.info("returnXml = " +returnXml);
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();
		if ("1".equals(result)) {
			isPass = true;
		}
		return isPass;
	}

	/**
	 * 切换金库场景
	 */
	public boolean getCertificationSwitch(String ip, String certificationStatus) throws Exception {
		boolean isPass = false;
		StringBuffer stringBuffer = new StringBuffer();
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("CertificationSwitch").append("</method>\r\n");
		stringBuffer.append("<clientIp>").append(ip).append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<certificationStatus>").append(certificationStatus).append(
				"</certificationStatus>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");

		String returnXml = InterfaceClient.getInstance().execute(stringBuffer.toString(),
				"getCertificationSwitch", "reqMsg", "getCertificationSwitchResponse",
				"getCertificationSwitchResult");
		Element root = MenuInfoBO.getInstance().parseStringToDocument(returnXml);
		Element element = (Element) root.selectSingleNode("/response/body");
		String result = ((Element) element.element("result")).getText();
		if ("1".equals(result)) {
			isPass = true;
		}
		return isPass;
	}

	public HashMap<String, String> parseRelationInfo(Element relationInfo) {
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("policyAuthMethod", relationInfo.element("policyAuthMethod").getText());
		hashMap.put("policyAccessMethod", relationInfo.element("policyAccessMethod").getText());
		return hashMap;
	}
}
