package com.asiainfo.hbbass.ws.sensitive;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SensitiveFilter implements Filter {
//	private static Logger LOG = Logger.getLogger(SensitiveFilter.class);
//	private final static String FORWARD_PAGE = "/hbapp/cooperative/index.jsp";
//	private final static String ERROR_PAGE = "/hbapp/cooperative/error.jsp";

	public void destroy() {
	}
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
//		boolean flag = false;
//		if(uri.indexOf("action.jsp")>-1){
//			String url = req.getContextPath();  
//			url = url + req.getServletPath();  
//			url = url + "?" + req.getQueryString();  
//			if(url.indexOf("down")>-1){
//				flag = true;
//			}
//		}
//		
//		String reg = "/mvc/(report|menu)/[0-9]*/*(down)*";
//		if (uri.matches(reg) || flag) {
//			LOG.info(uri+"匹配了金库正则表达式");
//			// 验证本次会话是否为第一次查询金库访问开关
//			String isOpen = (String) req.getSession().getAttribute("SENSITIVE_4A_IS_OPEN");
//			if (StringUtils.isBlank(isOpen)) {
//				if (SystemCodeBO.getInstance().getIsOpen()) {
//					isOpen = Constant.TRUE;
//					req.getSession().setAttribute("SENSITIVE_4A_IS_OPEN", Constant.TRUE);
//				} else {
//					isOpen = Constant.FALSE;
//					req.getSession().setAttribute("SENSITIVE_4A_IS_OPEN", Constant.FALSE);
//				}
//			}
//			try{
//
//			// 经分系统是否开启金库访问模式
//			if (Constant.TRUE.equals(isOpen)) {
//
//				String userId = ((com.asiainfo.bass.apps.models.User) req.getSession().getAttribute("user")).getId();
//				String ip = Util.getRemoteAddr(req);
//				String filterFlag = (String) req.getSession().getAttribute("filterFlag");
//				// 排除审核通过请求
//				if (!Constant.TRUE.equals(filterFlag)) {
//					String nid = "";
//					String typeOp = "";
//
//					// 报表下载
//					if (uri.indexOf("down") >= 0 && uri.indexOf("report") >= 0) {
//						nid = "S" + uri.substring(uri.indexOf("report") + 7, uri.indexOf("down") - 1);
//						typeOp = "D";
//					}
//
//					// 报表查询
//					if (uri.indexOf("report") >= 0 && uri.indexOf("down") == -1) {
//						nid = "S" + uri.substring(uri.indexOf("report") + 7);
//						typeOp = "Q";
//					}
//
//					// 菜单查询
//					if (uri.indexOf("menu") >= 0 && uri.indexOf("down") == -1) {
//						nid = "M" + uri.substring(uri.indexOf("menu") + 5);
//						typeOp = "Q";
//					}
//					
//					// KPI下载
//					if (uri.indexOf("action") >= 0 ) {
//						nid = "S7336";
//						typeOp = "D";
//					}
//
//					LOG.info("根据URL查找菜单是否为金库菜单：" + nid);
//					MenuInfoModel menuInfoModel = DealBO.getInstance().isLocaltionCheck(nid, typeOp);
//					LogModel logModel = new LogModel();
//					
//					String sceneId = "";
//					String isSensitive = "";
//					String visitDateStr = Constant.getCurrentDate();
//					String comment = "";
//					String impowerFashion = "";
//					String cooperate = "";
//					
//					if (menuInfoModel == null || StringUtils.isBlank(menuInfoModel.getSceneId()) || Constant.FALSE.equals(menuInfoModel.getStatus())) {
//						// 本地访问日志记录
//						sceneId= Constant.DEFAULT_CODE; // 场景id缺省值
//						isSensitive = Constant.FALSE; // 敏感信息标识
//						comment = "无敏感信息|通过";
//						
//						logModel.setUserID(userId);
//						logModel.setClientIp(ip);
//						logModel.setNid(nid);
//						logModel.setOperate(typeOp);
//						logModel.setSceneId(sceneId); // 场景id缺省值
//						logModel.setIsSensitive(isSensitive); // 敏感信息标识
//						logModel.setVisitDateStr(visitDateStr); // 当前访问时间
//						logModel.setComment(comment);
//						logModel.setCooperate(cooperate);
//						logModel.setImpowerFashion(impowerFashion);
//						LogBO.getInstance().insertLog(logModel);
//
//					} else {
//						// 验证本次会话是否为第一次主账号查询
//						ArrayList<String> accounts = (ArrayList<String>) req.getSession().getAttribute("accounts");
//						if (accounts == null || accounts.size() == 0) {
//							accounts = DealBO.getInstance().getAccount(userId, ip);
//							req.getSession().setAttribute("accounts", accounts);
//						}
//						StatusBodyInfoDTO bodyInfoDTO = DealBO.getInstance().getTreasuryStatus(userId, menuInfoModel.getSceneId(), Constant.getRandomMsgId(), ip, accounts.get(0));
//						ArrayList relations = bodyInfoDTO.getRelations();
//						if(relations!=null && relations.size()>0){
//							for(int i=0;i<relations.size();i++){
//								HashMap hashMap = (HashMap)relations.get(0);
//								impowerFashion = hashMap.get("policyAuthMethod").toString();
//							}
//						}
//						ArrayList approvers = bodyInfoDTO.getApprovers();
//						if(approvers!=null && approvers.size()>0){
//							for(int i=0;i<approvers.size();i++){
//								if(i==0){
//									cooperate = approvers.get(i).toString();
//								} else {
//									cooperate = cooperate + "," + approvers.get(i); 
//								}
//							}
//						}
//						sceneId = menuInfoModel.getSceneId(); // 场景id值
//						isSensitive = Constant.TRUE; // 敏感信息标识
//						comment = "是敏感信息|申请";
//						logModel.setUserID(userId);
//						logModel.setClientIp(ip);
//						logModel.setNid(nid);
//						logModel.setOperate(typeOp);
//						logModel.setSceneId(sceneId); // 场景id缺省值
//						logModel.setIsSensitive(isSensitive); // 敏感信息标识
//						logModel.setVisitDateStr(visitDateStr); // 当前访问时间
//						logModel.setComment(comment);
//						logModel.setCooperate(cooperate);
//						logModel.setApplyReason(bodyInfoDTO.getApplyReason());
//						logModel.setOperateContent(bodyInfoDTO.getOperateContent());
//						logModel.setImpowerFashion(impowerFashion);
//						logModel.setImpowerCondition(bodyInfoDTO.getImpowerCondition());
//						logModel.setImpowerResult(bodyInfoDTO.getImpowerResult());
//						logModel.setImpowerTime(bodyInfoDTO.getMaxTime());
//						logModel.setImpowerIdea(bodyInfoDTO.getImpowerIdea());
//						logModel.setResult(bodyInfoDTO.getResult());
//						LogBO.getInstance().insertLog(logModel);
//						
//						req.getSession().setAttribute("bodyInfoDTO", bodyInfoDTO);
//						req.setAttribute("lastUri", uri);
//						req.setAttribute("clientIp", ip);
//						req.setAttribute("sceneId", menuInfoModel.getSceneId());
//						if(StringUtils.isNotBlank(bodyInfoDTO.getResult()) && Constant.RESULT_STATUS_NONAML.equals(bodyInfoDTO.getResult())){
//							req.getRequestDispatcher(FORWARD_PAGE).forward(req, res);
//							return ;
//						}
//					}
//				} else {
//					req.getSession().setAttribute("filterFlag", Constant.FALSE);
//				}
//			}
//			}catch(Exception e){
//				LOG.info(e.getStackTrace().toString());
//				req.setAttribute("msg", e.getStackTrace().toString());
//			}
//		}
		chain.doFilter(req, res);
	}

	public void init(FilterConfig arg0) throws ServletException {
	}
}
