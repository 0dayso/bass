<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.asiainfo.bass.components.models.Util"%>
<%@page import="com.asiainfo.hbbass.ws.bo.DealBO"%>
<%@page import="com.asiainfo.hbbass.ws.bo.LogBO"%>
<%@page import="com.asiainfo.hbbass.ws.bo.SystemCodeBO"%>
<%@page import="com.asiainfo.hbbass.ws.common.Constant"%>
<%@page import="com.asiainfo.hbbass.ws.dto.StatusBodyInfoDTO"%>
<%@page import="com.asiainfo.hbbass.ws.model.LogModel"%>
<%@page import="com.asiainfo.hbbass.ws.model.MenuInfoModel"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>处理金库模式请求</title>
		<%

final Logger LOG = Logger.getLogger("jinku.jsp");
final String FORWARD_PAGE = "${mvcPath}/hbapp/cooperative/index.jsp";
final String ERROR_PAGE = "${mvcPath}/hbapp/cooperative/error.jsp";

String redirectUrl = request.getParameter("redirectUrl");

Map<String,String[]> map = (Map<String,String[]>)request.getParameterMap();

StringBuilder sb = new StringBuilder();
for (Iterator<Map.Entry<String,String[]>> iterator = map.entrySet().iterator(); iterator.hasNext();) {
	Map.Entry<String,String[]> entry = (Map.Entry<String,String[]>) iterator.next();
	if(!"redirectUrl".equals(entry.getKey())){
		sb.append("&").append(entry.getKey()).append("=").append(entry.getValue()[0]);
	}
}

String fullRedirectUrl = redirectUrl+sb.toString();
	if(fullRedirectUrl.indexOf("?")>0){
				fullRedirectUrl+="&";
			}else{
				fullRedirectUrl+="?";
			}
			fullRedirectUrl+="jinkuAuth=true";
			
//处理逻辑
// 验证本次会话是否为第一次查询金库访问开关

			String userId = ((com.asiainfo.hb.web.models.User) request.getSession().getAttribute("user")).getId();
			String ip = Util.getRemoteAddr(request);

				String filterFlag = (String) request.getSession().getAttribute("filterFlag");

				// 排除审核通过请求
				if (!Constant.TRUE.equals(filterFlag)) {
					String nid = "S4982";
					String typeOp = "Q";

					LOG.debug("根据URL查找菜单是否为金库菜单："+nid);
					MenuInfoModel menuInfoModel = DealBO.getInstance().isLocaltionCheck(nid, typeOp);
					LogModel logModel = new LogModel();
					
					String sceneId = "";
					String isSensitive = "";
					String visitDateStr = Constant.getCurrentDate();
					String comment = "";
					String impowerFashion = "";
					String cooperate = "";
					if (menuInfoModel == null || StringUtils.isBlank(menuInfoModel.getSceneId()) || Constant.FALSE.equals(menuInfoModel.getStatus())) {

						// 本地访问日志记录
						sceneId= Constant.DEFAULT_CODE; // 场景id缺省值
						isSensitive = Constant.FALSE; // 敏感信息标识
						comment = "无敏感信息|通过";
						
						logModel.setUserID(userId);
						logModel.setClientIp(ip);
						logModel.setNid(nid);
						logModel.setOperate(typeOp);
						logModel.setSceneId(sceneId); // 场景id缺省值
						logModel.setIsSensitive(isSensitive); // 敏感信息标识
						logModel.setVisitDateStr(visitDateStr); // 当前访问时间
						logModel.setComment(comment);
						logModel.setCooperate(cooperate);
						logModel.setImpowerFashion(impowerFashion);
						LogBO.getInstance().insertLog(logModel);

					} else {

						// 验证本次会话是否为第一次主账号查询
						ArrayList<String> accounts = (ArrayList<String>) request.getSession().getAttribute("accounts");
						if (accounts == null || accounts.size() == 0) {
							accounts = DealBO.getInstance().getAccount(userId, ip);
							request.getSession().setAttribute("accounts", accounts);
						}

						StatusBodyInfoDTO bodyInfoDTO = DealBO.getInstance().getTreasuryStatus(userId, menuInfoModel.getSceneId(), Constant.getRandomMsgId(), ip, accounts.get(0));

						ArrayList relations = bodyInfoDTO.getRelations();
						if(relations!=null && relations.size()>0){
							for(int i=0;i<relations.size();i++){
								HashMap hashMap = (HashMap)relations.get(0);
								impowerFashion = hashMap.get("policyAuthMethod").toString();
							}
						}
						ArrayList approvers = bodyInfoDTO.getApprovers();
						if(approvers!=null && approvers.size()>0){
							for(int i=0;i<approvers.size();i++){
								if(i==0){
									cooperate = approvers.get(i).toString();
								} else {
									cooperate = cooperate + "," + approvers.get(i); 
								}
							}
						}
						sceneId = menuInfoModel.getSceneId(); // 场景id值
						isSensitive = Constant.TRUE; // 敏感信息标识
						comment = "是敏感信息|申请";
						logModel.setUserID(userId);
						logModel.setClientIp(ip);
						logModel.setNid(nid);
						logModel.setOperate(typeOp);
						logModel.setSceneId(sceneId); // 场景id缺省值
						logModel.setIsSensitive(isSensitive); // 敏感信息标识
						logModel.setVisitDateStr(visitDateStr); // 当前访问时间
						logModel.setComment(comment);
						logModel.setCooperate(cooperate);
						logModel.setApplyReason(bodyInfoDTO.getApplyReason());
						logModel.setOperateContent(bodyInfoDTO.getOperateContent());
						logModel.setImpowerFashion(impowerFashion);
						logModel.setImpowerCondition(bodyInfoDTO.getImpowerCondition());
						logModel.setImpowerResult(bodyInfoDTO.getImpowerResult());
						logModel.setImpowerTime(bodyInfoDTO.getMaxTime());
						logModel.setImpowerIdea(bodyInfoDTO.getImpowerIdea());
						logModel.setResult(bodyInfoDTO.getResult());
						LogBO.getInstance().insertLog(logModel);

						request.getSession().setAttribute("bodyInfoDTO", bodyInfoDTO);
						request.setAttribute("lastUri", fullRedirectUrl);
						request.setAttribute("clientIp", ip);
						request.setAttribute("sceneId", menuInfoModel.getSceneId());
						if(StringUtils.isNotBlank(bodyInfoDTO.getResult()) && Constant.RESULT_STATUS_NONAML.equals(bodyInfoDTO.getResult())){
							request.getRequestDispatcher(FORWARD_PAGE).forward(request, response);
						}
						return;
					}
				} else {
					request.getSession().setAttribute("filterFlag", Constant.FALSE);
				}
%>
	</head>
	<body>
	</body>
</html>