package com.asiainfo.bass.apps.jinku;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.bass.apps.models.Report;
import com.asiainfo.bass.apps.models.ReportDao;
import com.asiainfo.bass.components.models.DesUtil;
import com.asiainfo.bass.components.models.Util;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;
import com.asiainfo.hbbass.ws.bo.DealBO;
import com.asiainfo.hbbass.ws.bo.LogBO;
import com.asiainfo.hbbass.ws.common.Constant;
import com.asiainfo.hbbass.ws.dto.StatusBodyInfoDTO;
import com.asiainfo.hbbass.ws.model.LogModel;

@Controller
@RequestMapping(value = "/jinku")
@SessionAttributes({"mvcPath", SessionKeyConstants.USER})
public class jinkuController {
	
	private static Logger LOG = Logger.getLogger(jinkuController.class);
	
	@Autowired
	private JinkuDao jinkuDao;
	@Autowired
	private JinkuService jinkuService;
	@Autowired
	private ReportDao reportDao;
	
	@RequestMapping(method = RequestMethod.GET)
	public String MMSConfig(@ModelAttribute("user") User user) {
		return "ftl/jinku/jinkuConfig";
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "rescind", method = RequestMethod.PUT)
	public @ResponseBody
	Map rescind() {
		Map msg = new HashMap();
		msg.put("status", "解除金库模式");
		try {
			jinkuDao.update4ACloseSwitch();
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "resume", method = RequestMethod.PUT)
	public @ResponseBody
	Map resume() {
		Map msg = new HashMap();
		msg.put("status", "恢复金库模式");
		try {
			jinkuDao.update4AOpenSwitch();
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}
	
	@SuppressWarnings({ "unused", "rawtypes", "unchecked" })
	@RequestMapping(value = "show",method = RequestMethod.GET)
	public String show(WebRequest request, HttpServletResponse response, @ModelAttribute("user") User user, Model model) {
		String userId = user.getId();
		String url = request.getParameter("url");
		String sceneid = request.getParameter("sceneid");
		String ip = request.getParameter("ip");
		String returnUrl = request.getParameter("returnUrl");
		String applyId = request.getParameter("applyId");
		String kind = request.getParameter("kind");
		String impowerFashion = "";
		String cooperate="";
		try {
			String isOpen = jinkuDao.get4ASwitch();
			if(!"".equals(isOpen) && isOpen.equals("0")){
				//查询4a帐号
				ArrayList<String> accounts = DealBO.getInstance().getAccount(userId, ip);
				StatusBodyInfoDTO bodyInfoDTO = DealBO.getInstance().getTreasuryStatus(userId, sceneid, Constant.getRandomMsgId(), ip, accounts.get(0));
				ArrayList relations = bodyInfoDTO.getRelations();
				ArrayList<String> fashionList = new ArrayList<String>();
				//获得金库认证的授权方式
				if(relations!=null && relations.size()>0){
					for(int i=0;i<relations.size();i++){
						HashMap hashMap = (HashMap)relations.get(0);
						impowerFashion = hashMap.get("policyAuthMethod").toString();
						fashionList.add(impowerFashion);
					}
				}
				//获得金库认证的审批人
				ArrayList approvers = bodyInfoDTO.getApprovers();
				//获得金库认证的有效时间
				String maxTime = bodyInfoDTO.getMaxTime();
				String result = bodyInfoDTO.getResult();
				//匹配全省金库审批员名单,如果审批人不是全省金库审批员名单则删除
				ArrayList<String> resultList = jinkuDao.getAccount(approvers);
				if(result!=null && resultList.size()>0){
					for(int i=0;i<resultList.size();i++){
						if(i==0){
							cooperate = resultList.get(i).toString();
						} else {
							cooperate = cooperate + "," + resultList.get(i); 
						}
					}
				}
				if("2".equals(result)){
					if("菜单".equals(kind) && url.length()==0){
						return "forward:" + url;
					}else {
						if(url.indexOf("report")>-1){
							model.addAttribute("flag", "1");
						}
						return "forward:" + url;
					}
				}
				String appSessionId = Constant.getRandomMsgId();
				//增加金库申请日志
//				jinkuDao.insertLogBefore(userId, ip, applyId, sceneid, String.valueOf(d));
				model.addAttribute("fashionList", fashionList);
				model.addAttribute("cooperate", cooperate);
				model.addAttribute("maxTime", maxTime);
				model.addAttribute("sceneId", sceneid);
				model.addAttribute("appSessionId", appSessionId);
				model.addAttribute("accounts", accounts.get(0));
				model.addAttribute("url", url);
				model.addAttribute("ip", ip);
				model.addAttribute("returnUrl", returnUrl);
				model.addAttribute("result", result);
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "redirect:/hbapp/cooperative/index.jsp";
	}
	
	@SuppressWarnings({ "rawtypes", "unused", "unchecked" })
	@RequestMapping(value = "kpiCheck",method = RequestMethod.POST)
	public String kpiCheck(HttpServletResponse response, ServletRequest request, @ModelAttribute("user") User user) {
		String date = request.getParameter("date");
	    HttpServletRequest req = (HttpServletRequest)request;
	    String ip = Util.getRemoteAddr(req);
	    HashMap msg = this.jinkuService.checkJinku(user.getId(), date, request, ip);
	    boolean flag = Boolean.parseBoolean(String.valueOf(msg.get("flag")));
	    LOG.info("flag=================" + flag);
	    if ((flag) && 
	      ("checkReport".equals(date))) {
	      String sid = request.getParameter("sid");
	      String sql = request.getParameter("sql");
	      sql = DesUtil.defaultStrDec(sql);
	      LOG.info("sql=" + sql);
	      Report rpt = this.reportDao.getReportById(Integer.valueOf(sid).intValue(), user.getCityId(), user, "", user.getCityId(),null);
	      String ds = rpt.getDs();
	      String fileName = rpt.getName();
	      Map _header = rpt.getDownHeader();
	      String fileType = "csv";
	      String userExcel = rpt.getUseExcel();
	      LOG.info("是否是EXCEL文件============" + userExcel);
	      if ((!("".equals(userExcel))) && (userExcel.equals("true")))
	        fileType = "xls";

	      File tempFile = this.jinkuService.createTempFile(ds, sql, fileName, _header, fileType);
	      LOG.info("tempFile.Name=========" + tempFile.getName());
	      
	      String status = "1";
	      String message = "未纳入金库模式，下载文件未加密";
	      String isOpen = jinkuDao.get4ASwitch();
	      if (!"".equals(isOpen) && isOpen.equals("Y")) {
	    	  Map map = this.jinkuDao.checkSensitive(sid);
	    	  LOG.info("是否需要上传云平台==============" + ((String)map.get("result")));
	    	  if (((String)map.get("result")).equals("1")) {
	    		  HashMap result = this.jinkuService.encryptFile(tempFile, req);
	    		  String downUrl = String.valueOf(result.get("downUrl"));
	    		  LOG.info("云平台路径：============" + downUrl);
	    		  LOG.info("云平台路径11111111111111：============" + ((String)result.get("downUrl")));
	    		  message = String.valueOf(result.get("msg"));
	    		  status = String.valueOf(result.get("flag"));
	    		  msg.put("downUrl", downUrl);
	    		  if (tempFile == null)
	    			  message = "文件生成失败，请重新下载。";
	    		  
	    	  }
	      }else{
	    	  message = "未开启金库模式，可直接下载";
	    	  status = "0";
	      }

	      msg.put("message", message);
	      msg.put("status", status);
	    }

	    String jsonStr = JsonHelper.getInstance().write(msg);
	    try {
	      PrintWriter out = response.getWriter();
	      out.print(jsonStr);
	    } catch (IOException e1) {
	      e1.printStackTrace();
	    }
	    return null;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked", "unused", "static-access" })
	@RequestMapping(value = "send",method = RequestMethod.POST)
	public void doSend(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		String optype = request.getParameter("optype"); 
		String clientIp = request.getParameter("clientIp");
		String appSessionId = request.getParameter("appSessionId"); 
		String approver = request.getParameter("approver");
		String caseDesc = request.getParameter("caseDesc"); 
		String account = request.getParameter("account"); 
		String sceneId = request.getParameter("sceneId");
		String time = request.getParameter("time"); 
		String pwCode = request.getParameter("pwCode");
		String operContent = request.getParameter("operContent"); 
		String workorderNO = request.getParameter("workorderNO");
		String nid = request.getParameter("nid");
		String result = "3";
//		String cerReason = request.getParameter("cerReason");
		HashMap msg = new HashMap();
		try {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.HOUR, Integer.valueOf(time));
			int hour = calendar.get(calendar.HOUR_OF_DAY);
			String beginTime = sdf.format(new Date());
			String endTime = sdf.format(calendar.getTime());
			boolean isPass = false;
			//增加金库申请日志
//			jinkuDao.insertLogApply(account, clientIp, sceneId, approver, caseDesc, operContent, optype);
			if ("remoteAuth".equals(optype)) {
				isPass = DealBO.getInstance().remoteFirstAuth(user.getId(),
						nid, appSessionId, approver, caseDesc, beginTime,
						endTime, clientIp, account, sceneId);
			}
			if ("remoteAuth2".equals(optype)) {
				isPass = DealBO.getInstance().remoteSecondAuth(user.getId(),
						nid, appSessionId, approver, pwCode, beginTime,
						endTime, clientIp, account, sceneId);
			}
			if ("siteAuth".equals(optype)) {
				isPass = DealBO.getInstance().siteAuth(user.getId(), nid,
						appSessionId, approver, pwCode, beginTime, endTime, clientIp,
						account, sceneId);
			}
			if ("workOrderAuth".equals(optype)) {
				isPass = DealBO.getInstance().workOrderAuth(user.getId(),
						nid, appSessionId, operContent, workorderNO,
						beginTime, endTime, caseDesc, clientIp, account, sceneId);
			}
			LOG.info(isPass);
			if (isPass) {
				msg.put("isPass", "Y");
				result = "2";
			} else {
				msg.put("isPass", "N");
			}
			//申请金库结果日志
			//jinkuDao.insertLogResult(account, clientIp, sceneId, approver, result, String.valueOf(d), "");
			String comment = "是敏感信息|审批";
			LogModel logModel = new LogModel();
			logModel.setUserID(user.getId());
			logModel.setClientIp(clientIp);
			logModel.setNid(nid);
			logModel.setOperate("D");
			logModel.setSceneId(sceneId); // 场景id缺省值
			logModel.setIsSensitive("Y"); // 敏感信息标识
			logModel.setVisitDateStr(Constant.getCurrentDate()); // 当前访问时间
			logModel.setComment(comment);
			logModel.setCooperate(approver);
			logModel.setApplyReason(caseDesc);
			logModel.setOperateContent(operContent);
			logModel.setImpowerFashion(optype);
			logModel.setImpowerCondition("");
			logModel.setImpowerResult("");
			logModel.setImpowerTime(time);
			logModel.setImpowerIdea("");
			logModel.setResult(result);
			LogBO.getInstance().insertLog(logModel);
			String jsonStr = JsonHelper.getInstance().write(msg);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 
	 * @param user
	 * @return
	 */
	@RequestMapping(value = "cooperation",method = RequestMethod.GET)
	public String cooperation(@ModelAttribute("user") User user) {
		return "ftl/jinku/cooperation";
	}
	
	/**
	 * 新增
	 * @param cityid		地市编码
	 * @param userid		4A帐号
	 * @param username		姓名
	 * @param mobile		手机号
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/save", method = RequestMethod.PUT)
	public @ResponseBody
	Map save(@RequestParam String cityid, @RequestParam String userid, @RequestParam String username, @RequestParam String mobile){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			jinkuDao.save(cityid, userid, username, mobile);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value="/delete" ,method=RequestMethod.DELETE)
	public @ResponseBody
	Map delete(@RequestParam String id){
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try{
			jinkuDao.delete(id);
		}catch(Exception e){
			msg.put("status", "操作失败");
			e.printStackTrace();
		}
		return msg;
	}
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/encryptFile",method=RequestMethod.POST)
	public @ResponseBody Map encryptFile(HttpServletRequest request,HttpServletResponse response){
		
		String ds = request.getParameter("ds");
		String sql = request.getParameter("sql");
		sql = DesUtil.defaultStrDec(sql);
		LOG.info("sql=" + sql);
		String fileName = request.getParameter("fileName");
		String _header = request.getParameter("header");
		String fileType = request.getParameter("fileKind");
		Map header = (Map) JsonHelper.getInstance().read(_header.toUpperCase());
		File tempFile = jinkuService.createTempFile(ds, sql, fileName, header, fileType);
//		File tempFile = new File("C:\\Users\\zml\\Downloads\\201401市场基础报表（二）.xls");
		return jinkuService.encryptFile(tempFile,request);
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/checkSensitive",method=RequestMethod.POST)
	public @ResponseBody Map checkSensitive(HttpServletRequest request){
		String sid = request.getParameter("sid");
		return jinkuDao.checkSensitive(sid);
	}
}
