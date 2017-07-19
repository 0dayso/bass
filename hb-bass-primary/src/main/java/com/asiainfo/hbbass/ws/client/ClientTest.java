package com.asiainfo.hbbass.ws.client;

import com.asiainfo.hbbass.ws.common.Constant;

public class ClientTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		// StringBuffer buf = new StringBuffer();
		// buf.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		// buf.append("<request>\r\n");
		// buf.append("<head>\r\n");
		// buf.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		// buf.append("<requestTime>").append(Constant.getCurrentDate()).append(
		// "</requestTime>\r\n");
		// buf.append("<method>").append("CertificationStatusQuery").append(
		// "</method>\r\n");
		// buf.append("<clientIp>").append("127.0.0.1").append("</clientIp>\r\n");
		// buf.append("</head>\r\n");
		// buf
		// .append("<body> <resType>app</resType> <account>xiaojun_hb</account>
		// <subAccount>xiaojun</subAccount>
		// <sceneId>8a9915e635c8696b0135c8696b360000</sceneId>
		// <sceneName>经分测试场景</sceneName> <sensitiveData>kpi1</sensitiveData>
		// <sensitiveOperate>query</sensitiveOperate>
		// <appSessionId>xiaojun|S7320|Q</appSessionId> </body>\r\n");
		// buf.append("</request>\r\n");
		// RequestMessage requestMessage = new RequestMessage(buf.toString(),
		// "getTreasuryStatus", "reqMsg", "getTreasuryStatusResponse",
		// "treasuryManagerResult");

		StringBuffer stringBuffer = new StringBuffer();
//		buf.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
//		buf.append("<request>\r\n");
//		buf.append("<head>\r\n");
//		buf.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
//		buf.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
//		buf.append("<method>").append("ApproverQuery").append("</method>\r\n");
//		buf.append("<clientIp>").append("10.31.81.217").append("</clientIp>\r\n");
//		buf.append("</head>\r\n");
//		buf.append("<body><subAccount>lizj</subAccount></body>\r\n");
//		buf.append("</request>\r\n");
		
		
		stringBuffer.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n");
		stringBuffer.append("<request>\r\n");
		stringBuffer.append("<head>\r\n");
		stringBuffer.append("<requestTime>").append(Constant.getCurrentDate()).append("</requestTime>\r\n");
		stringBuffer.append("<method>").append("CertificationStatusQuery").append("</method>\r\n");
		stringBuffer.append("<appId>").append(Constant.APP_ID).append("</appId>\r\n");
		stringBuffer.append("<clientIp>").append("10.31.81.217").append("</clientIp>\r\n");
		stringBuffer.append("</head>\r\n");
		stringBuffer.append("<body>");
		stringBuffer.append("<resType>app</resType>");
		stringBuffer.append("<account>").append("lizhijian").append("</account>");
		stringBuffer.append("<subAccount>").append("lizj").append("</subAccount>");
		stringBuffer.append("<sceneId>").append("8a998b262cab3d0f012cab3d0fec0000").append("</sceneId>");
		stringBuffer.append("<sceneName>").append("").append("</sceneName>");
		stringBuffer.append("<sensitiveData>").append("").append("</sensitiveData>");
		stringBuffer.append("<sensitiveOperate>").append("").append("</sensitiveOperate>");
		stringBuffer.append("<appSessionId>").append(Constant.getRandomMsgId()).append("</appSessionId>");
		stringBuffer.append("</body>");
		stringBuffer.append("</request>\r\n");
		RequestMessage requestMessage = new RequestMessage(stringBuffer.toString(), "getAccount", "reqMsg",
				"getAccountResponse", "accountResult");
		WsClient wsClient = WsClient.getInstance();
		wsClient.call(requestMessage);
	}
}
