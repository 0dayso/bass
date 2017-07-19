package com.asiainfo.hbbass.ws.client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;
import org.dom4j.XPath;

import com.asiainfo.hbbass.ws.common.Constant;

public class SOAPProtocolHandler implements ProtocolHandler {
	private static Logger LOG = Logger.getLogger(SOAPProtocolHandler.class);

	private String createURLString(SoapConfig SoapConfig) {
		return "http://" + SoapConfig.getIp() + ":" + SoapConfig.getPort()
				+ (SoapConfig.getUri().startsWith("/") ? SoapConfig.getUri() : "/" + SoapConfig.getUri());
	}

	private ResponseMessage parseSoapResponse(String soapResponse, RequestContext context) {
		// 解析soap响应
		Document doc = null;
		try {
			doc = DocumentHelper.parseText(soapResponse);
			LOG.debug("---------------SOAP响应原文---------------");
			LOG.debug(soapResponse);
			LOG.debug("----------------------------------------");
		} catch (DocumentException e) {
			return WsClient.buildExceptivelyResponseMessage("SOAP-0020", "接口异常", context);
		}
		Map<String, String> xmlMap = new HashMap<String, String>();
		xmlMap.put("soap", SOAP11_NS);
		xmlMap.put("ns1", Constant.TARGET_NAMESPACE_4A);
		String soap_xpath = "/soap:Envelope/soap:Body/ns1:"
				+ context.getRequestMessage().getServiceResponse() + "/"
				+ context.getRequestMessage().getServiceResult();
		XPath x = doc.createXPath(soap_xpath);
		x.setNamespaceURIs(xmlMap);
		Element reqElement = (Element) x.selectSingleNode(doc);
		if (reqElement != null) {
			try {
				// // 解密代码
				// ThreeDesBase64 des = new ThreeDesBase64();// 实例化一个对像
				// String key = "bsb";
				// return ResponseMessage.newInstance(des.decode(reqElement
				// .getText(), key));
				return ResponseMessage.newInstance(reqElement.getText());
			} catch (ResponseMessageException e) {
				return WsClient.buildExceptivelyResponseMessage("SOAP-0020", "接口异常", context);
			}
		} else {
			return WsClient.buildExceptivelyResponseMessage("SOAP-0020", "接口异常", context);
		}
	}

	private ResponseMessage http(RequestContext context) {
		SoapConfig SOAPConfig = context.getSoapConfig();
		if (StringUtils.isBlank(SOAPConfig.getIp()) || SOAPConfig.getPort() == 0
				|| StringUtils.isBlank(SOAPConfig.getUri())) {
			return WsClient.buildExceptivelyResponseMessage("SOAP-0010", "客户端异常，接口访问参数没有正确配置", context);
		}
		HttpURLConnection con = null;
		URLConnection connection = null;
		OutputStream out = null;
		URL url = null;
		String strUrl = createURLString(SOAPConfig);
		try {
			url = new URL(strUrl);
			connection = url.openConnection();
		}catch (MalformedURLException e) {
			return WsClient.buildExceptivelyResponseMessage("SOAP-0010",String.format("配置地址%s不正确",strUrl),context);
		}catch (IOException e2) {
			String faultString = String.format("无法创建到达%s的连接，请检查接口是否正常运行。", strUrl);
			return WsClient.buildExceptivelyResponseMessage("SOAP-0010", faultString, context);
		}
		try {
			// 构建soap消息
			String soapMessage = buildSoapMessage(context);
			byte[] b = soapMessage.getBytes();
			con = (HttpURLConnection) connection;
			con.setRequestProperty("Content-Length", String.valueOf(b.length));
			con.setRequestProperty("Content-Type", "text/xml; charset=ISO-8859-1");
			con.setRequestMethod("POST");
			// 设置选项
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setConnectTimeout(SOAPConfig.getConnectionTimeout());
			con.setReadTimeout(SOAPConfig.getReceiveTimeout());

			// 发送soap消息
			out = con.getOutputStream();
			out.write(b);
		} catch (Exception e) {
			return WsClient.buildExceptivelyResponseMessage("SOAP-0010", "接口连接失败，以下是异常堆栈信息：\n"
					+ e.getMessage(), context);
		} finally {
			try {
				if (con != null) {
					con.disconnect();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if (out != null) {
					con.disconnect();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		BufferedReader in = null;
		InputStreamReader isr = null;
		StringBuffer result = new StringBuffer();
		try {
			// 读取soap响应
			if (200 == con.getResponseCode()) {
				isr = new InputStreamReader(con.getInputStream());
			} else {
				isr = new InputStreamReader(con.getErrorStream());
			}
			in = new BufferedReader(isr);
			String inputLine = null;
			while ((inputLine = in.readLine()) != null) {
				result.append(inputLine).append("\n");
			}
			return parseSoapResponse(result.toString(), context);
		} catch (Exception e) {
			return WsClient.buildExceptivelyResponseMessage("SOAP-0020", "接口连接失败，以下是异常堆栈信息：\n"
					+ e.getMessage(), context);
		} finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if (isr != null) {
					isr.close();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {
				if (con != null) {
					con.disconnect();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private String buildSoapMessage(RequestContext context) {
		StringBuffer soapMessage = new StringBuffer();
		soapMessage.append("<soap:Envelope xmlns:soap=\"" + SOAP11_NS + "\">");
		soapMessage.append("<soap:Body>");
		soapMessage.append("<").append(context.getRequestMessage().getServiceName());
		soapMessage.append(" xmlns=\"" + Constant.TARGET_NAMESPACE_4A + "\">");
		soapMessage.append("<").append(context.getRequestMessage().getParameterName());
		soapMessage.append(" xmlns=\"\">");
		// // 加密代码
		// ThreeDesBase64 des = new ThreeDesBase64();// 实例化一个对像
		// String key = "bsb";
		// soapMessage.append(des.encode(StringEscapeUtils.escapeXml(context
		// .getRequestMessage().toString()), key));
		soapMessage.append(StringEscapeUtils.escapeXml(context.getRequestMessage().toString()));
		soapMessage.append("</").append(context.getRequestMessage().getParameterName()).append(">");
		soapMessage.append("</").append(context.getRequestMessage().getServiceName()).append(">");
		soapMessage.append("</soap:Body>");
		soapMessage.append("</soap:Envelope>");
		LOG.debug("---------------SOAP请求原文---------------");
		LOG.debug(soapMessage.toString());
		LOG.debug("----------------------------------------");
		return soapMessage.toString();
	}

	public ResponseMessage execute(RequestContext context) {
		return http(context);
	}
}
