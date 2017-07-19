package com.asiainfo.hb.bass.hb_webservice.service;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.jws.soap.SOAPBinding;
import javax.jws.soap.SOAPBinding.ParameterStyle;
import javax.jws.soap.SOAPBinding.Style;
import javax.jws.soap.SOAPBinding.Use;
import javax.xml.ws.BindingType;
import javax.xml.ws.RequestWrapper;
import javax.xml.ws.ResponseWrapper;

import com.asiainfo.hb.bass.hb_webservice.common.Constant;

@WebService(name = "AccountWebServicePort", wsdlLocation = "WEB-INF/wsdl/AccountWebService.wsdl", targetNamespace = Constant.TARGET_NAMESPACE_JF)
@SOAPBinding(parameterStyle = ParameterStyle.WRAPPED, style = Style.DOCUMENT, use = Use.LITERAL)
@BindingType(javax.xml.ws.soap.SOAPBinding.SOAP11HTTP_BINDING)
public interface AccountWebService {
	
	@WebMethod(operationName = "queryAccount", action = Constant.TARGET_NAMESPACE_JF + "/queryAccount")
	@WebResult(name = "responseXml")
	@RequestWrapper(localName = "queryAccount", targetNamespace = Constant.TARGET_NAMESPACE_JF)
	@ResponseWrapper(localName = "queryAccountResponse", targetNamespace = Constant.TARGET_NAMESPACE_JF)
	public String queryAccount(@WebParam(name = "requestXml")String requestXml);
	
	
	@WebMethod(operationName = "delAccount", action = Constant.TARGET_NAMESPACE_JF + "/delAccount")
	@WebResult(name = "responseXml")
	@RequestWrapper(localName = "delAccount", targetNamespace = Constant.TARGET_NAMESPACE_JF)
	@ResponseWrapper(localName = "delAccount", targetNamespace = Constant.TARGET_NAMESPACE_JF)
	public String delAccount(@WebParam(name = "requestXml")String requestXml);

}
