package com.asiainfo.bass.apps.mmsreport;

import java.text.DateFormat;

import javax.sql.DataSource;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.components.models.FileManage;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hbbass.component.msg.mail.SendMailWrapper;
import com.asiainfo.hbbass.component.msg.mms.SendMMSWrapper;
import com.asiainfo.hbbass.component.msg.sms.SendSMSWrapper;

@Repository
public class MMSReportService {
	private static Logger LOG = Logger.getLogger(MMSReportService.class);
	@Autowired
	private MMSReportDao mmsReportDao;
	@Autowired
	private FileManage fileManage;
	
	@Autowired
	private DataSource dataSourceDw;
	
	@Autowired
	private DataSource dataSource;
	
	@SuppressWarnings("rawtypes")
	public String getTitle(List list){
		String title = "";
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				String code = map.get("code").toString();
				String value = map.get("value").toString();
				if(code.indexOf("title")>-1){
					title = value;
				}
			}
		}
		return title;
	}
	
	@SuppressWarnings("rawtypes")
	public String getTime(List list){
		String time = "";
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				String code = map.get("code").toString();
				String value = map.get("value").toString();
				if(code.indexOf("time")>-1){
					time = value;
				}
			}
		}
		return time;
	}
	
	@SuppressWarnings("rawtypes")
	public String getSender(List list){
		String sender = "";
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				String code = map.get("code").toString();
				String value = map.get("value").toString();
				if(code.indexOf("sender")>-1){
					sender = value;
				}
			}
		}
		return sender;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String getContent(List list){
		String content = "";
		if(list!=null && list.size()>0){
			String id = "";
			String time = "";	//时间
			List paraList = new ArrayList();
			List compareList = new ArrayList();
			Map onemap = (Map)list.get(0);
			id = onemap.get("id").toString();
			List sqlList = mmsReportDao.getSqlList(id);
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				Map paraMap = new HashMap();
				Map compareMap = new HashMap();
				String code = map.get("code").toString();
				String value = map.get("value").toString();
				content = map.get("content").toString();
				if(code.indexOf("time")>-1){
					time = value;
				}else if(code.indexOf("para")>-1){
					paraMap.put("code", code);
					paraMap.put("value", value);
					paraList.add(paraMap);
				}else if(code.indexOf("compare")>-1){
					if(sqlList!=null && sqlList.size()>0){
						for(int j=0;j<sqlList.size();j++){
							Map sqlMap = (Map)sqlList.get(j);
							String sqlCode = sqlMap.get("code").toString();
							String sqlValue = sqlMap.get("value").toString();
							if(code.substring(7, code.length()).equals(sqlCode.substring(7, sqlCode.length()))){
								compareMap.put("sql", sqlValue);
							}
						}
					}
					compareMap.put("code", code);
					compareMap.put("value", value);
					compareList.add(compareMap);
				}
			}
			//根据paraList得到para对应的内容
			if(paraList!=null && paraList.size()>0){
				List paraResult = getParaResult(paraList,time);
				//替换content中的para参数
				if(paraResult!=null && paraResult.size()>0){
					for(int k=0;k<paraResult.size();k++){
						Map parasMap = (Map)paraResult.get(k);
						String parameter = parasMap.get("code").toString();
						String parameterValue = parasMap.get("value").toString();
						
						content = content.replaceAll("\\{"+parameter+"\\}", parameterValue);
					}
				}
			}
			//根据compareList得到compare对应的内容
			if(compareList!=null && compareList.size()>0){
				List compareResult = getCompareResult(compareList,time);
				//替换content中的compare参数
				if(compareResult!=null && compareResult.size()>0){
					for(int k=0;k<compareResult.size();k++){
						Map comparesMap = (Map)compareResult.get(k);
						String compares = comparesMap.get("code").toString();
						String comparesValue = comparesMap.get("value").toString();
						content = content.replaceAll("\\{"+compares+"\\}", comparesValue);
					}
				}
			}
			content = content.replaceAll("\\{time\\}", time);
		}
		return content;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String getContentByTime(List list, String time){
		String content = "";
		if(list!=null && list.size()>0){
			String id = "";
			List paraList = new ArrayList();
			List compareList = new ArrayList();
			Map onemap = (Map)list.get(0);
			id = onemap.get("id").toString();
			List sqlList = mmsReportDao.getSqlList(id);
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				Map paraMap = new HashMap();
				Map compareMap = new HashMap();
				String code = map.get("code").toString();
				String value = map.get("value").toString();
				content = map.get("content").toString();
				if(code.indexOf("para")>-1){
					paraMap.put("code", code);
					paraMap.put("value", value);
					paraList.add(paraMap);
				}else if(code.indexOf("compare")>-1){
					if(sqlList!=null && sqlList.size()>0){
						for(int j=0;j<sqlList.size();j++){
							Map sqlMap = (Map)sqlList.get(j);
							String sqlCode = sqlMap.get("code").toString();
							String sqlValue = sqlMap.get("value").toString();
							if(code.substring(7, code.length()).equals(sqlCode.substring(7, sqlCode.length()))){
								compareMap.put("sql", sqlValue);
							}
						}
					}
					compareMap.put("code", code);
					compareMap.put("value", value);
					compareList.add(compareMap);
				}
			}
			//根据paraList得到para对应的内容
			if(paraList!=null && paraList.size()>0){
				List paraResult = getParaResult(paraList,time);
				//替换content中的para参数
				if(paraResult!=null && paraResult.size()>0){
					for(int k=0;k<paraResult.size();k++){
						Map parasMap = (Map)paraResult.get(k);
						String parameter = parasMap.get("code").toString();
						String parameterValue = parasMap.get("value").toString();
						
						content = content.replaceAll("\\{"+parameter+"\\}", parameterValue);
					}
				}
			}
			//根据compareList得到compare对应的内容
			if(compareList!=null && compareList.size()>0){
				List compareResult = getCompareResult(compareList,time);
				//替换content中的compare参数
				if(compareResult!=null && compareResult.size()>0){
					for(int k=0;k<compareResult.size();k++){
						Map comparesMap = (Map)compareResult.get(k);
						String compares = comparesMap.get("code").toString();
						String comparesValue = comparesMap.get("value").toString();
						content = content.replaceAll("\\{"+compares+"\\}", comparesValue);
					}
				}
			}
			content = content.replaceAll("\\{time\\}", time);
		}
		return content;
	}
	
	public boolean sendMMS(String title, String content, String sender, String time){
		boolean flag = false;
//		String host = "10.25.36.95";
		int length = 0;
		if(sender.indexOf("#")>-1){
			String[] str = sender.split("#");
			length = str.length;
		}else{
			length = 1;
		}
		String[] to = new String[length];
		if(sender.indexOf("#")>-1){
			to = sender.split("#");
		}else{
			to[0] = sender;
		}
		String strTo = to[0];
		for (int i = 1; i < to.length; i++) {
			strTo += ";"+ to[i];
		}
		title = time.substring(4, 6)+"月"+time.substring(6, 8)+"日"+title;
		flag = SendMMSWrapper.send(strTo, title, content);
		return flag;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getParaResult(List list, String time){
		List resultList = new ArrayList();
		String month = getMonth(time);
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			Map result = new HashMap();
			String code = map.get("code").toString();
			String sql = map.get("value").toString().replace("{time}", ""+time+"").replace("{lastMonth}", ""+month+"");
			if(!"".equals(sql) && sql!=""){
				String value = mmsReportDao.getResult(sql);
				result.put("value", value);
			}else{
				result.put("value", code);
			}
			result.put("code", code);
			resultList.add(result);
		}
		return resultList;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getCompareResult(List list, String time){
		List resultList = new ArrayList();
		for(int i=0;i<list.size();i++){
			Map map = (Map)list.get(i);
			Map result = new HashMap();
			String code = map.get("code").toString();
			String value = map.get("value").toString();
			String resultTime = mmsReportDao.getResultTime(value,time);
			String sql = map.get("sql").toString().replace("{time}", "'"+time+"'").replace("{comparetime}", "'"+resultTime+"'");
			if(!"".equals(sql) && sql!=""){
				String res = mmsReportDao.getResult(sql);
				result.put("value", res);
			}else{
				result.put("value", code);
			}
			result.put("code", code);
			resultList.add(result);
		}
		return resultList;
	}
	
	public void createMailContent(String id){
		String mailContent = getMailContent(id);
		mmsReportDao.insertMailContent(id, mailContent);
	}
	
	@SuppressWarnings({ "unchecked", "unused", "rawtypes" })
	public String getMailContent(String id){
		List list = mmsReportDao.getMailList(id);
		String mailContent = "";
		String content = "";
		if(list!=null && list.size()>0){
			String time = "";	//时间
			List paraList = new ArrayList();
			Map onemap = (Map)list.get(0);
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				Map paraMap = new HashMap();
				Map compareMap = new HashMap();
				String code = map.get("code").toString();
				String value = map.get("value").toString();
				content = map.get("content").toString();
				if(code.indexOf("time")>-1){
					time = value;
				}else if(code.indexOf("para")>-1){
					paraMap.put("code", code);
					paraMap.put("value", value);
					paraList.add(paraMap);
				}
			}
			//根据paraList得到para对应的内容
			if(paraList!=null && paraList.size()>0){
				List paraResult = getParaResult(paraList,time);
				//替换content中的para参数
				if(paraResult!=null && paraResult.size()>0){
					for(int k=0;k<paraResult.size();k++){
						Map parasMap = (Map)paraResult.get(k);
						String parameter = parasMap.get("code").toString();
						String parameterValue = parasMap.get("value").toString();
						content = content.replaceAll("\\{"+parameter+"\\}", parameterValue);
					}
				}
			}
			mailContent = content.replaceAll("\\{time\\}", time);
		}
		return mailContent;
	}
	
	@SuppressWarnings({ "unused", "unchecked", "rawtypes" })
	public HashMap getMailContentInfo(String id, String time){
		List list = mmsReportDao.getMailList(id);
		String mailContent = "";
		String content = "";
		String title = "";
		String mail = "";
		HashMap result = new HashMap();
		if(list!=null && list.size()>0){
			List paraList = new ArrayList();
			Map onemap = (Map)list.get(0);
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				Map paraMap = new HashMap();
				Map compareMap = new HashMap();
				String code = map.get("code").toString();
				String value = map.get("value").toString();
				content = map.get("content").toString();
				if(code.indexOf("para")>-1){
					paraMap.put("code", code);
					paraMap.put("value", value);
					paraList.add(paraMap);
				}else if(code.indexOf("title")>-1){
					title = value;
				}else if(code.indexOf("mail")>-1){
					mail = value;
				}
			}
			//根据paraList得到para对应的内容
			if(paraList!=null && paraList.size()>0){
				List paraResult = getParaResult(paraList,time);
				//替换content中的para参数
				if(paraResult!=null && paraResult.size()>0){
					for(int k=0;k<paraResult.size();k++){
						Map parasMap = (Map)paraResult.get(k);
						String parameter = parasMap.get("code").toString();
						String parameterValue = parasMap.get("value").toString();
						content = content.replaceAll("\\{"+parameter+"\\}", parameterValue);
					}
				}
			}
			try {
				String time1 = time.substring(4,6) + "月" + time.substring(6,8) + "日";
				DateFormat df = new SimpleDateFormat("yyyyMMdd");  
				java.util.Date d1 = df.parse(time);
				Calendar  g = Calendar.getInstance();  
				g.setTime(d1);
				String times = (g.get(Calendar.MONTH)+1) + "月第" + g.get(Calendar.DAY_OF_WEEK_IN_MONTH) + "周";
				mailContent = content.replaceAll("\\{time1\\}", time1);
				mailContent = mailContent.replaceAll("\\{time\\}", times);
			} catch (ParseException e) {
				e.printStackTrace();
			}   
			result.put("mailContent", mailContent);
			result.put("title", title);
			result.put("mail", mail);
		}
		return result;
	}
	
	public String getMonth(String time){
		String monthTime = "";
		Calendar calendar = Calendar.getInstance();
		int timeYear = Integer.valueOf(time.substring(0,4));
		int timeMonth = Integer.valueOf(time.substring(4,6))-1;
		int timeDay = Integer.valueOf(time.substring(6,8));
		calendar.set(timeYear, timeMonth, timeDay);
		calendar.add(Calendar.MONTH, -1);
		int year = calendar.get(Calendar.YEAR); 
		int month = calendar.get(Calendar.MONTH)+1; 
		if(month<10){
			monthTime = String.valueOf(year)+"0"+String.valueOf(month);
		}else{
			monthTime = String.valueOf(year)+String.valueOf(month);
		}
		return monthTime;
	}
	
	@SuppressWarnings({ "unused", "rawtypes" })
	public void sendSmsForStock(String time){
		List list = mmsReportDao.getSmsList(time);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = (HashMap)list.get(i);
				String dim2 = map.get("dim2").toString();//县域
				String dim3 = map.get("dim3").toString();//区域营销中心
				String dim4 = map.get("dim4").toString();//责任人
				String dim5 = map.get("dim5").toString();//联系电话
				String ind1 = map.get("ind1").toString();//存量拍照客户定则数
				String ind3 = map.get("ind3").toString();//拍照中高端客户定责数
				String content = dim4+"，你好，存量客户" + time.substring(0, 4) + "年" + time.substring(4, 6) + "月明细数据即将下发，请关注您的139邮箱";
				SendSMSWrapper.send(dim5, content);
//				SendSMSWrapper.send("13476228880;13871272007;15102782812", content);
			}
		}
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public HashMap getMailContentForAttachment(String time){
		HashMap result = new HashMap();
		HashMap map = mmsReportDao.getSender(time);
		if(!map.isEmpty()){
			String[] sender = (String[])map.get("senders");
			String[] managers = (String[])map.get("managers");
			String title = "目标存量客户" + time.substring(0, 4) + "年" + time.substring(4, 6) + "月明细数据下发";
			result.put("sender", sender);
			result.put("managers", managers);
			result.put("title", title);
			result.put("time", time);
		}
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public HashMap getMailContentForAttachments(String time){
		HashMap result = new HashMap();
		HashMap map = mmsReportDao.getSenders(time);
		if(!map.isEmpty()){
			String[] sender = (String[])map.get("senders");
			String[] managers = (String[])map.get("managers");
			String title = "目标存量客户" + time.substring(0, 4) + "年" + time.substring(4, 6) + "月" + time.substring(6, 8) + "日明细数据下发";
			result.put("sender", sender);
			result.put("managers", managers);
			result.put("title", title);
			result.put("time", time);
		}
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public boolean sendEmailForAttachment(HashMap map){
		boolean flag = false;
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSourceDw, false);
		if(!map.isEmpty()){
			String[] senders = (String[])map.get("sender");
			String[] managers = (String[])map.get("managers");
			String time = map.get("time").toString();
			HashMap header = new HashMap();
			header.put("MANAGER_COUNTY_NAME","县域：");
			header.put("MANAGER_ZONE_NAME","区域中心：");
			header.put("MANAGER_NAME","责任人：");
			header.put("MANAGER_ACCNBR","联系电话：");
			header.put("MANAGER_ACCNBR1","手机号码");
			header.put("ACC_NBR","客户手机号码");
			header.put("CUST_NAME","姓名（模糊化）");
			header.put("LIUSHI_P","客户稳定度得分（得分越低稳定度越差）");
			header.put("LIUSHI_CLASS","预警级别");
			header.put("REASON","预警原因");
			header.put("NBILLING_NAME","资费");
			header.put("NET_AGE","网龄");
			header.put("ZONE_NAME","近期通话区域");
			header.put("BUREAU_NAME","近期通话片区");
			header.put("RECORGID_NAME","近期常去渠道网点");
			header.put("IF_SNAPSHOT","是否拍照中高端");
			header.put("IS_SIGN_GROUP","是否打标集团成员");
			header.put("GROUPNAME","所属集团");
			header.put("ENT_STAFF_NAME","集团客户经理");
			header.put("MCUST_LID","VIP级别");
			header.put("BILL_CHARGE","上月消费（元）");
			header.put("DURA1","上月计费时长（分）");
			header.put("GPRS_DURA","上月流量（MB）");
			header.put("V_DURAL","上月V网时长（分）");
			header.put("HJH_DURAL","上月合家欢时长（分）");
			header.put("PROD","用户终端品牌");
			header.put("DEVICE_NAME","用户终端机型");
			header.put("CUR_BALANCE","最新话费余额（元）");
			header.put("REC_DATE","最近一次交费时间");
			header.put("HARDBIND_TYPE","硬捆绑类型");
			header.put("HARDBIND_EXP_DATE","硬捆绑到期时间");
			header.put("MONTH_MINI","保底消费金额（元）");
			header.put("LEAVE_FLAG", "目标存量用户流失状态");
			header.put("COUNTER","拍照中高端用户流失状态");
			header.put("ACT_TID","离网状态");
			header.put("STATE_TID","停机状态");
			header.put("EXP_DATE","状态变更时间");

			String fileKind = "excel";
			if(senders.length>0){
				for(int i=0;i<senders.length;i++){
					String sql = "select manager_county_name,manager_zone_name,manager_name ,manager_accnbr ,manager_accnbr manager_accnbr1,acc_nbr ,case when length(cust_name) = 4 then substr(cust_name,1,2)||'*' when length(cust_name) = 6 then substr(cust_name,1,2)||'**' when length(cust_name) >= 8 then substr(cust_name,1,2)||'***' end cust_name ,liushi_p ,liushi_class ,(case when reason_1 is null then reason_1 else reason_1||';' end || case when reason_2 is null then reason_2 else reason_2||';' end ||case when reason_3 is null then reason_3 else reason_3||';' end) reason ,NBILLING_NAME ,net_age ,ZONE_NAME ,BUREAU_NAME ,recorgid_NAME ,case when if_snapshot='1' then '是' else '否' end if_snapshot ,case when IS_SIGN_GROUP='1' then '是' else '否' end IS_SIGN_GROUP,GROUPNAME ,case when ENT_STAFF_NAME='0' then null else ENT_STAFF_NAME end ENT_STAFF_NAME ,MCUST_LID ,BILL_CHARGE ,dura1 ,GPRS_DURA ,V_DURAL ,hjh_DURAL ,PROD ,DEVICE_NAME ,CUR_BALANCE ,REC_DATE ,HARDBIND_TYPE ,HARDBIND_EXP_DATE ,MONTH_MINI,LEAVE_FLAG,COUNTER,ACT_TID,STATE_TID,EXP_DATE from nmk.snapshotpush_month_"+time+"_use where manager_accnbr = '"+senders[i]+"'";
					String title = map.get("title").toString();
					//生成附件
					title = title + "-" + senders[i];
					fileManage.executeNotDelete(jdbcTemplate, sql, title, header, fileKind, time+"用户信息");
					HashMap resultMap = new HashMap();
					StringBuffer content = new StringBuffer();
					content.append("<div id='content' style='font-size:12px;'>")
					.append("<DIV>"+managers[i]+"，您好：</DIV><br>")
					.append("1、您负责存量客户明细数据已经生成，请查看附件。<br>")
					.append("2、由于涉及客户资料信息，请务必注意信息安全管理规定。<br>")
					.append("3、如果有疑问、建议或者需求，请联系所在分公司或者省业务支撑中心。<br>")
					.append("</div>");
					LOG.info("mailContent====="+content.toString());
					resultMap.put("mailContent", content.toString());
//					resultMap.put("mail","13476228880@139.com;huangchao@asiainfo-linkage.com;13871272007@139.com");
					resultMap.put("mail", senders[i]+"@139.com");
					resultMap.put("title", title);
					resultMap.put("path", "/usr/WebServer/Node1/bin/"+title+".xls");
					//插入发送列表
					int result = mmsReportDao.insertSendMailJobForAttachment(resultMap);
					if(result==1){
						flag = true;
					}
				}
			}
			
		}
		return flag;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public boolean sendEmailForAttachments(HashMap map){
		boolean flag = false;
		JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource, false);
		if(!map.isEmpty()){
			String[] senders = (String[])map.get("sender");
			String[] managers = (String[])map.get("managers");
			String time = map.get("time").toString();
			HashMap header = new HashMap();
			header.put("COUNTY_NAME","县域：");
			header.put("ZONE_NAME","区域中心：");
			header.put("WXR_NAME","责任人：");
			header.put("WXR_TEL","责任人电话：");
			header.put("ACC_NBR","客户手机号码");
			header.put("IS_SNAPSHOT","是否存量拍照客户");
			header.put("IS_LEAVE","是否存量流失客户");
			header.put("IS_WILL_LEAVE","是否即将流失");
			header.put("IS_CHANGE","是否可携转");
			header.put("USER_STATE","用户状态（汉字标示）");
			header.put("CUST_NAME","姓名（模糊化）");
			header.put("USER_GRADE","星级");
			header.put("FEE_NAME","资费");
			header.put("NET_AGE","网龄");
			header.put("SCORE","积分数量");
			header.put("RECSITE_NAME","近三个月缴费网点");
			header.put("IS_HIGHSNAP","是否拍照中高端");
			header.put("IS_ENT_MARK","是否打标集团成员");
			header.put("ENT_NAME","所属集团");
			header.put("AVG_BILL_CHARGE","近三个月平均消费（元）");
			header.put("AVG_GPRS_FLOW","近三个月平均流量（MB）");
			header.put("DURA_ADD_PP","计费时长较上月同期增幅");
			header.put("IS_VPMN","是否V网订购");
			header.put("IS_HJH","是否合家欢订购");
			header.put("TERMINAL_TYPE","用户终端机型");
			header.put("TERMINAL_USED_MON","终端使用时长");
			header.put("IS_DEEP_BIND","是否深度合约");
			header.put("MIN_EXPDATE","深度合约最近到期时间");
			header.put("MAX_EXPDATE","深度合约最后到期时间");
			header.put("CHARGE_MINI","保底消费金额（元）");

			String fileKind = "excel";
			if(senders.length>0){
				for(int i=0;i<1;i++){
					String sql = "SELECT COUNTY_NAME ,ZONE_NAME ,WXR_NAME ,WXR_TEL ,ACC_NBR ,IS_SNAPSHOT ,IS_LEAVE ,IS_WILL_LEAVE ,IS_CHANGE ,USER_STATE ,CUST_NAME ,USER_GRADE ,FEE_NAME ,NET_AGE ,SCORE ,RECSITE_NAME ,IS_HIGHSNAP ,IS_ENT_MARK ,ENT_NAME ,AVG_BILL_CHARGE ,AVG_GPRS_FLOW ,DURA_ADD_PP ,IS_VPMN ,IS_HJH ,TERMINAL_TYPE ,TERMINAL_USED_MON ,IS_DEEP_BIND ,MIN_EXPDATE ,MAX_EXPDATE ,CHARGE_MINI FROM NMK.STOCK_KHFB_USERLIST_"+time+" WHERE AREA_NAME IN ('荆州','天门') and WXR_TEL = '"+senders[i]+"'";
					String title = map.get("title").toString();
					//生成附件
					title = title + "-" + senders[i];
					fileManage.executeNotDelete(jdbcTemplate, sql, title, header, fileKind, time+"用户信息");
					HashMap resultMap = new HashMap();
					StringBuffer content = new StringBuffer();
					content.append("<div id='content' style='font-size:12px;'>")
					.append("<DIV>"+managers[i]+"，您好：</DIV><br>")
					.append("1、您负责存量客户明细数据已经生成，请查看附件。<br>")
					.append("2、由于涉及客户资料信息，请务必注意信息安全管理规定。<br>")
					.append("3、如果有疑问、建议或者需求，请联系所在分公司或者省业务支撑中心。<br>")
					.append("</div>");
					LOG.info("mailContent====="+content.toString());
					resultMap.put("mailContent", content.toString());
//					resultMap.put("mail","13476228880@139.com;zhanmf@asiainfo-linkage.com;13871586699@139.com;13707100368@139.com;13607100122@139.com;13707100218@139.com;13659875376@139.com;13871586699@139.com");
					resultMap.put("mail", senders[i]+"@139.com");
					resultMap.put("title", title);
					resultMap.put("path", "/usr/WebServer/Node1/bin/"+title+".xls");
					//插入发送列表
					int result = mmsReportDao.insertSendMailJobForAttachment(resultMap);
					if(result==1){
						flag = true;
					}
				}
			}
			
		}
		return flag;
	}
	
	@SuppressWarnings("rawtypes")
	public boolean sendMMSForDay(String time){
		boolean flag = false;
		List list = mmsReportDao.getListForDay(time);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String contacts = map.get("dim5").toString();
//				contacts = "13476228880;15102782812;13871272007";
				String subject = "存量客户保有信息日报"+time;
				StringBuffer content = new StringBuffer();
				content.append("县域:  ").append(map.get("dim2").toString()).append("\r\n")
					   .append("区域中心:  ").append(map.get("dim3").toString()).append("\r\n")	
					   .append("责任人:  ").append(map.get("dim4").toString()).append("\r\n")	
					   .append("联系电话:  ").append(map.get("dim5").toString()).append("\r\n")	
					   .append("1、存量拍照客户定责数  ").append(map.get("ind1").toString()).append("\r\n")     
					   .append("1.1、截止上月仍保有的客户数  ").append(map.get("ind2").toString()).append("\r\n")
					   .append("  1.1.1、本月新增有效捆绑数  ").append(map.get("ind3").toString()).append("\r\n")
					   .append("  1.1.2、当日新增有效捆绑数  ").append(map.get("ind4").toString()).append("\r\n")
					   .append("2、拍照中高端客户定责数  ").append(map.get("ind5").toString()).append("\r\n")
					   .append("2.1、截止上月仍保有的客户数  ").append(map.get("ind6").toString()).append("\r\n")
					   .append("  2.1.1本月新增有效捆绑数   ").append(map.get("ind7").toString()).append("\r\n")	
					   .append("  2.1.2当日新增有效捆绑数  ").append(map.get("ind8").toString()).append("\r\n")	
					   .append("3、月预警客户数  ").append(map.get("ind9").toString()).append("\r\n")	
					   .append("  3.1、本月新增有效捆绑数  ").append(map.get("ind10").toString()).append("\r\n")     
					   .append("  3.2、当日新增有效捆绑数  ").append(map.get("ind11").toString()).append("\r\n")
					   .append("说明：该数据为系统自动发送，如果有疑义，请及时与荆州市公司业务支撑中心联系。").append("\r\n");
				flag = SendMMSWrapper.send(contacts, subject, content.toString());
				
			}
		}
		return flag;
	}
	
	@SuppressWarnings("rawtypes")
	public boolean sendMMSToWxrForDay(String time,String type){
		boolean flag = false;
		List list = mmsReportDao.getListToWxrForDay(time, type);
		if(list!=null && list.size()>0){
			for(int i=0;i<1;i++){
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String contacts = "";
				String subject = "营销彩信日通报"+time;
				StringBuffer content = new StringBuffer();
				if("1".equals(type)){
					contacts = map.get("WXR_TEL").toString();
					subject = subject +"（分包责任人）";
					content.append("地市:  ").append(map.get("AREA_NAME").toString()).append("\r\n")	
					.append("区县:  ").append(map.get("COUNTY_NAME").toString()).append("\r\n")
					.append("区域中心:  ").append(map.get("ZONE_NAME").toString()).append("\r\n")	
					.append("责任人:  ").append(map.get("WXR_TEL").toString()).append("\r\n")	
					.append("  目标存量拍照客户分包客户数  ").append(map.get("TARGET_CNT").toString()).append("\r\n")     
					.append("  其中：截止上月末仍保有的客户数  ").append(map.get("STOCK_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户保有率  ").append(map.get("STOCK_PP").toString()).append("\r\n")
					.append("  本月预计流失客户数  ").append(map.get("WILL_LEAVE_CNT").toString()).append("\r\n")
					.append("  本月预计流失比例  ").append(map.get("LEAVE_PP").toString()).append("\r\n")
					.append("1、深度合约办理情况  ").append("\r\n")
					.append("  日新增深度合约办理量  ").append(map.get("ADD_DEEPBIND").toString()).append("\r\n")	
					.append("  本月累计新增深度合约办理量  ").append(map.get("ADD_DEEPBIND_LJ").toString()).append("\r\n")	
					.append("  目标存量拍照客户中深度合约客户到达数  ").append(map.get("DEEPBIND_CNT").toString()).append("\r\n")	
					.append("  目标存量拍照客户的深度合约率  ").append(map.get("DEEPBIND_PP").toString()).append("\r\n")     
					.append("2、业务合约办理情况  ").append("\r\n")
					.append("  本月累计新增业务合约办理量  ").append(map.get("ADD_SERVBIND_CNT").toString()).append("\r\n")
					.append("  本月累计新增V网办理量  ").append(map.get("ADD_VPMN_CNT").toString()).append("\r\n")
					.append("  本月累计新增合家欢办理量  ").append(map.get("ADD_HJH_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户中业务合约客户到达数  ").append(map.get("SERVBIND_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户的业务合约率  ").append(map.get("SERVBIND_PP").toString()).append("\r\n")
					.append("  V网客户活跃率  ").append(map.get("VPMN_ACTIVE_PP").toString()).append("\r\n")
					.append("  合家欢客户活跃率  ").append(map.get("HJH_ACTIVE_PP").toString()).append("\r\n")
					.append("3、可携转客户情况  ").append("\r\n")
					.append("  分包客户中可携转用户数  ").append(map.get("FB_CHANGE").toString()).append("\r\n")
					.append("  分包客户中可携转用户占比  ").append(map.get("FB_CHANGE_PP").toString()).append("\r\n");
				}else if("2".equals(type)){
					contacts = map.get("TEAM_TEL").toString();
					subject = subject +"（组长）";
					content.append("地市:  ").append(map.get("AREA_NAME").toString()).append("\r\n")	
					.append("区县:  ").append(map.get("COUNTY_NAME").toString()).append("\r\n")
					.append("区域中心:  ").append(map.get("ZONE_NAME").toString()).append("\r\n")	
					.append("责任人:  ").append(map.get("TEAM_TEL").toString()).append("\r\n")	
					.append("  目标存量拍照客户维系客户数  ").append(map.get("TARGET_CNT").toString()).append("\r\n")
					.append("  其中：截止上月末仍保有的客户数  ").append(map.get("STOCK_CNT").toString()).append("\r\n")	
					.append("  目标存量拍照客户保有率  ").append(map.get("STOCK_PP").toString()).append("\r\n")	
					.append("  本月预计流失客户数  ").append(map.get("WILL_LEAVE_CNT").toString()).append("\r\n")     
					.append("  本月预计流失比例  ").append(map.get("LEAVE_PP").toString()).append("\r\n")
					.append("1、深度合约办理情况：  ").append("\r\n")
					.append("  日新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND").toString()).append("\r\n")
					.append("  本月累计新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND_LJ").toString()).append("\r\n")
					.append("  目标存量拍照客户中深度合约客户到达数：  ").append(map.get("DEEPBIND_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户的深度合约率：  ").append(map.get("DEEPBIND_PP").toString()).append("\r\n")	
					.append("2、业务合约办理情况：  ").append("\r\n")	
					.append("  本月累计新增业务合约办理量：  ").append(map.get("ADD_SERVBIND_CNT").toString()).append("\r\n")	
					.append("  本月累计新增V网办理量  ").append(map.get("ADD_VPMN_CNT").toString()).append("\r\n")
					.append("  本月累计新增合家欢办理量  ").append(map.get("ADD_HJH_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户中业务合约客户到达数  ").append(map.get("SERVBIND_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户的业务合约率  ").append(map.get("SERVBIND_PP").toString()).append("\r\n")
					.append("  V网客户活跃率  ").append(map.get("VPMN_ACTIVE_PP").toString()).append("\r\n")
					.append("  合家欢客户活跃率  ").append(map.get("HJH_ACTIVE_PP").toString()).append("\r\n")
					.append("3、可携转客户情况  ").append("\r\n")
					.append("  分包客户中可携转用户数  ").append(map.get("FB_CHANGE").toString()).append("\r\n")
					.append("  分包客户中可携转用户占比  ").append(map.get("FB_CHANGE_PP").toString()).append("\r\n");
				}else if("3".equals(type)){
					contacts = map.get("COUNTY_TEL").toString();
					subject = subject +"（区县市场部）";
					content.append("地市:  ").append(map.get("AREA_NAME").toString()).append("\r\n")	
					.append("区县:  ").append(map.get("COUNTY_NAME").toString()).append("\r\n")
					.append("责任人:  ").append(map.get("COUNTY_TEL").toString()).append("\r\n")	
					.append("  目标存量拍照客户维系客户数  ").append(map.get("TARGET_CNT").toString()).append("\r\n")	
					.append("  其中：截止上月末仍保有的客户数  ").append(map.get("STOCK_CNT").toString()).append("\r\n")	
					.append("  目标存量拍照客户保有率  ").append(map.get("STOCK_PP").toString()).append("\r\n")     
					.append("  本月预计流失客户数 ").append(map.get("WILL_LEAVE_CNT").toString()).append("\r\n")
					.append("  本月预计流失比例 ").append(map.get("LEAVE_PP").toString()).append("\r\n")
					.append("1、深度合约办理情况：  ").append("\r\n")
					.append("  日新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND").toString()).append("\r\n")
					.append("  本月累计新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND_LJ").toString()).append("\r\n")
					.append("  目标存量拍照客户中深度合约客户到达数：  ").append(map.get("DEEPBIND_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户的深度合约率：  ").append(map.get("DEEPBIND_PP").toString()).append("\r\n")	
					.append("2、业务合约办理情况：  ").append("\r\n")	
					.append("  本月累计新增业务合约办理量：  ").append(map.get("ADD_SERVBIND_CNT").toString()).append("\r\n")	
					.append("  本月累计新增V网办理量  ").append(map.get("ADD_VPMN_CNT").toString()).append("\r\n")
					.append("  本月累计新增合家欢办理量  ").append(map.get("ADD_HJH_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户中业务合约客户到达数  ").append(map.get("SERVBIND_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户的业务合约率  ").append(map.get("SERVBIND_PP").toString()).append("\r\n")
					.append("  V网客户活跃率  ").append(map.get("VPMN_ACTIVE_PP").toString()).append("\r\n")
					.append("  合家欢客户活跃率  ").append(map.get("HJH_ACTIVE_PP").toString()).append("\r\n")
					.append("3、可携转客户情况  ").append("\r\n")
					.append("  分包客户中可携转用户数  ").append(map.get("FB_CHANGE").toString()).append("\r\n")
					.append("  分包客户中可携转用户占比  ").append(map.get("FB_CHANGE_PP").toString()).append("\r\n");
				}else if("4".equals(type)){
					contacts = map.get("AREA_TEL").toString();
					subject = subject +"（市公司市场部）";
					content.append("地市:  ").append(map.get("AREA_NAME").toString()).append("\r\n")	
					.append("责任人:  ").append(map.get("AREA_TEL").toString()).append("\r\n")	
					.append("  目标存量拍照客户维系客户数  ").append(map.get("TARGET_CNT").toString()).append("\r\n")	
					.append("  其中：截止上月末仍保有的客户数  ").append(map.get("STOCK_CNT").toString()).append("\r\n")	
					.append("  目标存量拍照客户保有率  ").append(map.get("STOCK_PP").toString()).append("\r\n")     
					.append("  本月预计流失客户数 ").append(map.get("WILL_LEAVE_CNT").toString()).append("\r\n")
					.append("  本月预计流失比例 ").append(map.get("LEAVE_PP").toString()).append("\r\n")
					.append("1、深度合约办理情况：  ").append("\r\n")
					.append("  日新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND").toString()).append("\r\n")
					.append("  本月累计新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND_LJ").toString()).append("\r\n")
					.append("  目标存量拍照客户中深度合约客户到达数：  ").append(map.get("DEEPBIND_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户的深度合约率：  ").append(map.get("DEEPBIND_PP").toString()).append("\r\n")	
					.append("2、业务合约办理情况：  ").append("\r\n")	
					.append("  本月累计新增业务合约办理量：  ").append(map.get("ADD_SERVBIND_CNT").toString()).append("\r\n")	
					.append("  本月累计新增V网办理量  ").append(map.get("ADD_VPMN_CNT").toString()).append("\r\n")
					.append("  本月累计新增合家欢办理量  ").append(map.get("ADD_HJH_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户中业务合约客户到达数  ").append(map.get("SERVBIND_CNT").toString()).append("\r\n")
					.append("  目标存量拍照客户的业务合约率  ").append(map.get("SERVBIND_PP").toString()).append("\r\n")
					.append("  V网客户活跃率  ").append(map.get("VPMN_ACTIVE_PP").toString()).append("\r\n")
					.append("  合家欢客户活跃率  ").append(map.get("HJH_ACTIVE_PP").toString()).append("\r\n")
					.append("3、可携转客户情况  ").append("\r\n")
					.append("  分包客户中可携转用户数  ").append(map.get("FB_CHANGE").toString()).append("\r\n")
					.append("  分包客户中可携转用户占比  ").append(map.get("FB_CHANGE_PP").toString()).append("\r\n");
				}
//				contacts = "13476228880;13871586699;13707100368;13607100122;13707100218;13659875376;13871586699;18771921272;13807220009;13797396666";
				flag = SendMMSWrapper.send(contacts, subject, content.toString());
				
			}
		}
		return flag;
	}
	
	@SuppressWarnings("rawtypes")
	public boolean sendMMSForWeek(String time){
		boolean flag = false;
		List list = mmsReportDao.getListForWeek(time);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String contacts = map.get("dim5").toString();
//				contacts = "13476228880;15102782812;13871272007";
				String subject = "存量客户保有信息周报"+time;
				StringBuffer content = new StringBuffer();
				content.append("县域:  ").append(map.get("dim2").toString()).append("\r\n")
					   .append("区域中心:  ").append(map.get("dim3").toString()).append("\r\n")	
					   .append("责任人:  ").append(map.get("dim4").toString()).append("\r\n")	
					   .append("联系电话:  ").append(map.get("dim5").toString()).append("\r\n")	
					   .append("1、存量拍照客户定责数  ").append(map.get("ind1").toString()).append("\r\n")     
					   .append("1.1、截止上月末仍保有的客户数  ").append(map.get("ind2").toString()).append("\r\n")
					   .append("  1.1.1、本周内新增有效捆绑数  ").append(map.get("ind3").toString()).append("\r\n")
					   .append("  1.1.2、本月截止当天的客户接触率  ").append(map.get("ind4").toString()).append("\r\n")
					   .append("2、拍照中高端客户定责数  ").append(map.get("ind5").toString()).append("\r\n")
					   .append("2.1、截止上月末仍保有的客户数  ").append(map.get("ind6").toString()).append("\r\n")
					   .append("  2.1.1、本周内新增有效捆绑数  ").append(map.get("ind7").toString()).append("\r\n")	
					   .append("  2.1.2、当日新增有效捆绑数  ").append(map.get("ind8").toString()).append("\r\n")	
					   .append("3、月预警客户数  ").append(map.get("ind9").toString()).append("\r\n")	
					   .append("  3.1、本周内新增有效捆绑数  ").append(map.get("ind10").toString()).append("\r\n")     
					   .append("  3.2、本月截止当天的客户接触率  ").append(map.get("ind11").toString()).append("\r\n")
					   .append("说明：该数据为系统自动发送，如果有疑义，请及时与荆州市公司业务支撑中心联系。").append("\r\n");
				flag = SendMMSWrapper.send(contacts, subject, content.toString());
				
			}
		}
		return flag;
	}

	@SuppressWarnings("rawtypes")
	public boolean sendMMSForMonth(String time){
		boolean flag = false;
		List list = mmsReportDao.getListForMonth(time);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String contacts = map.get("dim5").toString();
//				contacts = "13476228880;15102782812;13871272007";
				String subject = "存量客户保有信息月报"+time;
				StringBuffer content = new StringBuffer();
				content.append("县域：  ").append(map.get("dim2").toString()).append("\r\n")
					   .append("区域中心：  ").append(map.get("dim3").toString()).append("\r\n")	
					   .append("责任人：  ").append(map.get("dim4").toString()).append("\r\n")	
					   .append("联系电话：  ").append(map.get("dim5").toString()).append("\r\n")	
					   .append("1、存量拍照客户定责数  ").append(map.get("ind1").toString()).append("\r\n")     
					   .append(" 1.1、其中：截止月末仍保有的客户数  ").append(map.get("ind2").toString()).append("\r\n")
					   .append("  1.1.1、本月流失客户数  ").append(map.get("ind3").toString()).append("\r\n")
					   .append("  1.1.2、其中本月收入流失客户数  ").append(map.get("ind4").toString()).append("\r\n")
					   .append(" 1.2、捆绑率  ").append(map.get("ind5").toString()).append("\r\n")
					   .append("  1.2.1、本月新增捆绑客户数（新增办理量）  ").append(map.get("ind6").toString()).append("\r\n")
					   .append("  1.2.1、1-2个月内捆绑即将到期的客户数  ").append(map.get("ind7").toString()).append("\r\n")	
					   .append("1.3、粘性业务活跃用户占比  ").append(map.get("ind8").toString()).append("\r\n")	
					   .append("1.3.1、V网活跃用户占比  ").append(map.get("ind9").toString()).append("\r\n")	
					   .append("  1.3.2、合家欢活跃用户占比  ").append(map.get("ind10").toString()).append("\r\n")     
					   .append(" 1.4、本月客户接触率  ").append(map.get("ind10s").toString()).append("\r\n")
					   .append("2、拍照中高端客户定责数  ").append(map.get("ind11").toString()).append("\r\n")
					   .append(" 2.1、截止目前仍保有的客户数  ").append(map.get("ind12").toString()).append("\r\n")
					   .append("  2.1.1、本月流失客户数  ").append(map.get("ind13").toString()).append("\r\n")
					   .append("  2.1.2、本月价值流失客户数  ").append(map.get("ind14").toString()).append("\r\n")
					   .append("  2.1.3、本年累计已2个月收入<50元的客户数  ").append(map.get("ind15").toString()).append("\r\n")
					   .append(" 2.2、捆绑率  ").append(map.get("ind16").toString()).append("\r\n")
					   .append("  2.2.1、本月新增捆绑客户数（新增办理量）  ").append(map.get("ind17").toString()).append("\r\n")
					   .append("  2.2.1、1-2个月内即将到期的客户数  ").append(map.get("ind18").toString()).append("\r\n")
					   .append("2.3、粘性业务活跃用户占比  ").append(map.get("ind19").toString()).append("\r\n")
					   .append("  2.3.1、V网活跃用户占比  ").append(map.get("ind20").toString()).append("\r\n")
					   .append("  2.3.2、合家欢活跃用户占比  ").append(map.get("ind21").toString()).append("\r\n")
					   .append("2.4、本月客户接触率  ").append(map.get("ind22").toString()).append("\r\n")
					   .append("3、月度预警客户数  ").append(map.get("ind22s").toString()).append("\r\n")
					   .append(" 3.1、本月新增捆绑客户数  ").append(map.get("ind23").toString()).append("\r\n")
					   .append(" 3.2、本月的客户接触率  ").append(map.get("ind24").toString()).append("\r\n")
					   .append("说明：该数据为系统自动发送，如果有疑义，请及时与荆州市公司业务支撑中心联系。").append("\r\n");
				flag = SendMMSWrapper.send(contacts, subject, content.toString());
				
			}
		}
		return flag;
	}
	
	@SuppressWarnings("unused")
	public void getContent(String para, String method){
		String content = "";
		if(!"".equals(method) && method.equals("sendMMSToWxrForDay")){
			sendMMSToWxrForDay1(para, "1");
		}else if(!"".equals(method) && method.equals("sendMMSToTEAMForDay")){
			sendMMSToTEAMForDay1(para, "2");
		}else if(!"".equals(method) && method.equals("sendMMSToCOUNTYForDay")){
			sendMMSToCOUNTYForDay1(para, "3");
		}else if(!"".equals(method) && method.equals("sendMMSToAREAForDay")){
			sendMMSToAREAForDay1(para, "4");
		}
		
	}
	
	@SuppressWarnings("rawtypes")
	public void sendMMSToWxrForDay1(String para,String type){
		List list = mmsReportDao.getListToWxrForDay(para, type);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				StringBuffer content = new StringBuffer();
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String subject = "营销彩信日通报"+para;
				String contacts = map.get("WXR_TEL").toString();
				subject = subject +"（分包责任人）";
				content.append("地市:  ").append(map.get("AREA_NAME").toString()).append("\r\n")	
				.append("区县:  ").append(map.get("COUNTY_NAME").toString()).append("\r\n")
				.append("区域中心:  ").append(map.get("ZONE_NAME").toString()).append("\r\n")	
				.append("责任人:  ").append(map.get("WXR_TEL").toString()).append("\r\n")	
				.append("  目标存量拍照客户分包客户数  ").append(map.get("TARGET_CNT").toString()).append("\r\n")     
				.append("  其中：截止上月末仍保有的客户数  ").append(map.get("STOCK_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户保有率  ").append(map.get("STOCK_PP").toString()).append("\r\n")
				.append("  本月预计流失客户数  ").append(map.get("WILL_LEAVE_CNT").toString()).append("\r\n")
				.append("  本月预计流失比例  ").append(map.get("LEAVE_PP").toString()).append("\r\n")
				.append("1、深度合约办理情况  ").append("\r\n")
				.append("  日新增深度合约办理量  ").append(map.get("ADD_DEEPBIND").toString()).append("\r\n")	
				.append("  本月累计新增深度合约办理量  ").append(map.get("ADD_DEEPBIND_LJ").toString()).append("\r\n")	
				.append("  目标存量拍照客户中深度合约客户到达数  ").append(map.get("DEEPBIND_CNT").toString()).append("\r\n")	
				.append("  目标存量拍照客户的深度合约率  ").append(map.get("DEEPBIND_PP").toString()).append("\r\n")     
				.append("2、业务合约办理情况  ").append("\r\n")
				.append("  本月累计新增业务合约办理量  ").append(map.get("ADD_SERVBIND_CNT").toString()).append("\r\n")
				.append("  本月累计新增V网办理量  ").append(map.get("ADD_VPMN_CNT").toString()).append("\r\n")
				.append("  本月累计新增合家欢办理量  ").append(map.get("ADD_HJH_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户中业务合约客户到达数  ").append(map.get("SERVBIND_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户的业务合约率  ").append(map.get("SERVBIND_PP").toString()).append("\r\n")
				.append("  V网客户活跃率  ").append(map.get("VPMN_ACTIVE_PP").toString()).append("\r\n")
				.append("  合家欢客户活跃率  ").append(map.get("HJH_ACTIVE_PP").toString()).append("\r\n")
				.append("3、可携转客户情况  ").append("\r\n")
				.append("  分包客户中可携转用户数  ").append(map.get("FB_CHANGE").toString()).append("\r\n")
				.append("  分包客户中可携转用户占比  ").append(map.get("FB_CHANGE_PP").toString()).append("\r\n");
				mmsReportDao.insertMMS(subject, contacts, "1", content.toString(), "1");
			}
		}
	}
	
	@SuppressWarnings("rawtypes")
	public void sendMMSToTEAMForDay1(String para,String type){
		List list = mmsReportDao.getListToWxrForDay(para, type);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				StringBuffer content = new StringBuffer();
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String subject = "营销彩信日通报"+ para +"（组长）";
				String contacts = map.get("TEAM_TEL").toString();
				content.append("地市:  ").append(map.get("AREA_NAME").toString()).append("\r\n")	
				.append("区县:  ").append(map.get("COUNTY_NAME").toString()).append("\r\n")
				.append("区域中心:  ").append(map.get("ZONE_NAME").toString()).append("\r\n")	
				.append("责任人:  ").append(map.get("TEAM_TEL").toString()).append("\r\n")	
				.append("  目标存量拍照客户维系客户数  ").append(map.get("TARGET_CNT").toString()).append("\r\n")
				.append("  其中：截止上月末仍保有的客户数  ").append(map.get("STOCK_CNT").toString()).append("\r\n")	
				.append("  目标存量拍照客户保有率  ").append(map.get("STOCK_PP").toString()).append("\r\n")	
				.append("  本月预计流失客户数  ").append(map.get("WILL_LEAVE_CNT").toString()).append("\r\n")     
				.append("  本月预计流失比例  ").append(map.get("LEAVE_PP").toString()).append("\r\n")
				.append("1、深度合约办理情况：  ").append("\r\n")
				.append("  日新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND").toString()).append("\r\n")
				.append("  本月累计新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND_LJ").toString()).append("\r\n")
				.append("  目标存量拍照客户中深度合约客户到达数：  ").append(map.get("DEEPBIND_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户的深度合约率：  ").append(map.get("DEEPBIND_PP").toString()).append("\r\n")	
				.append("2、业务合约办理情况：  ").append("\r\n")	
				.append("  本月累计新增业务合约办理量：  ").append(map.get("ADD_SERVBIND_CNT").toString()).append("\r\n")	
				.append("  本月累计新增V网办理量  ").append(map.get("ADD_VPMN_CNT").toString()).append("\r\n")
				.append("  本月累计新增合家欢办理量  ").append(map.get("ADD_HJH_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户中业务合约客户到达数  ").append(map.get("SERVBIND_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户的业务合约率  ").append(map.get("SERVBIND_PP").toString()).append("\r\n")
				.append("  V网客户活跃率  ").append(map.get("VPMN_ACTIVE_PP").toString()).append("\r\n")
				.append("  合家欢客户活跃率  ").append(map.get("HJH_ACTIVE_PP").toString()).append("\r\n")
				.append("3、可携转客户情况  ").append("\r\n")
				.append("  分包客户中可携转用户数  ").append(map.get("FB_CHANGE").toString()).append("\r\n")
				.append("  分包客户中可携转用户占比  ").append(map.get("FB_CHANGE_PP").toString()).append("\r\n");
				mmsReportDao.insertMMS(subject, contacts, "1", content.toString(), "1");
			}
		}
	}
	
	@SuppressWarnings("rawtypes")
	public void sendMMSToCOUNTYForDay1(String para,String type){
		List list = mmsReportDao.getListToWxrForDay(para, type);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				StringBuffer content = new StringBuffer();
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String subject = "营销彩信日通报"+para+"（区县市场部）";;
				String contacts = map.get("COUNTY_TEL").toString();
				content.append("地市:  ").append(map.get("AREA_NAME").toString()).append("\r\n")	
				.append("区县:  ").append(map.get("COUNTY_NAME").toString()).append("\r\n")
				.append("责任人:  ").append(map.get("COUNTY_TEL").toString()).append("\r\n")	
				.append("  目标存量拍照客户维系客户数  ").append(map.get("TARGET_CNT").toString()).append("\r\n")	
				.append("  其中：截止上月末仍保有的客户数  ").append(map.get("STOCK_CNT").toString()).append("\r\n")	
				.append("  目标存量拍照客户保有率  ").append(map.get("STOCK_PP").toString()).append("\r\n")     
				.append("  本月预计流失客户数 ").append(map.get("WILL_LEAVE_CNT").toString()).append("\r\n")
				.append("  本月预计流失比例 ").append(map.get("LEAVE_PP").toString()).append("\r\n")
				.append("1、深度合约办理情况：  ").append("\r\n")
				.append("  日新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND").toString()).append("\r\n")
				.append("  本月累计新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND_LJ").toString()).append("\r\n")
				.append("  目标存量拍照客户中深度合约客户到达数：  ").append(map.get("DEEPBIND_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户的深度合约率：  ").append(map.get("DEEPBIND_PP").toString()).append("\r\n")	
				.append("2、业务合约办理情况：  ").append("\r\n")	
				.append("  本月累计新增业务合约办理量：  ").append(map.get("ADD_SERVBIND_CNT").toString()).append("\r\n")	
				.append("  本月累计新增V网办理量  ").append(map.get("ADD_VPMN_CNT").toString()).append("\r\n")
				.append("  本月累计新增合家欢办理量  ").append(map.get("ADD_HJH_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户中业务合约客户到达数  ").append(map.get("SERVBIND_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户的业务合约率  ").append(map.get("SERVBIND_PP").toString()).append("\r\n")
				.append("  V网客户活跃率  ").append(map.get("VPMN_ACTIVE_PP").toString()).append("\r\n")
				.append("  合家欢客户活跃率  ").append(map.get("HJH_ACTIVE_PP").toString()).append("\r\n")
				.append("3、可携转客户情况  ").append("\r\n")
				.append("  分包客户中可携转用户数  ").append(map.get("FB_CHANGE").toString()).append("\r\n")
				.append("  分包客户中可携转用户占比  ").append(map.get("FB_CHANGE_PP").toString()).append("\r\n");
				mmsReportDao.insertMMS(subject, contacts, "1", content.toString(), "1");
			}
		}
	}
	
	@SuppressWarnings("rawtypes")
	public void sendMMSToAREAForDay1(String para,String type){
		List list = mmsReportDao.getListToWxrForDay(para, type);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				StringBuffer content = new StringBuffer();
				HashMap map = new HashMap();
				map = (HashMap)list.get(i);
				String subject = "营销彩信日通报"+para+"（市公司市场部）";
				String contacts = map.get("AREA_TEL").toString();
				content.append("地市:  ").append(map.get("AREA_NAME").toString()).append("\r\n")	
				.append("责任人:  ").append(map.get("AREA_TEL").toString()).append("\r\n")	
				.append("  目标存量拍照客户维系客户数  ").append(map.get("TARGET_CNT").toString()).append("\r\n")	
				.append("  其中：截止上月末仍保有的客户数  ").append(map.get("STOCK_CNT").toString()).append("\r\n")	
				.append("  目标存量拍照客户保有率  ").append(map.get("STOCK_PP").toString()).append("\r\n")     
				.append("  本月预计流失客户数 ").append(map.get("WILL_LEAVE_CNT").toString()).append("\r\n")
				.append("  本月预计流失比例 ").append(map.get("LEAVE_PP").toString()).append("\r\n")
				.append("1、深度合约办理情况：  ").append("\r\n")
				.append("  日新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND").toString()).append("\r\n")
				.append("  本月累计新增深度合约办理量：  ").append(map.get("ADD_DEEPBIND_LJ").toString()).append("\r\n")
				.append("  目标存量拍照客户中深度合约客户到达数：  ").append(map.get("DEEPBIND_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户的深度合约率：  ").append(map.get("DEEPBIND_PP").toString()).append("\r\n")	
				.append("2、业务合约办理情况：  ").append("\r\n")	
				.append("  本月累计新增业务合约办理量：  ").append(map.get("ADD_SERVBIND_CNT").toString()).append("\r\n")	
				.append("  本月累计新增V网办理量  ").append(map.get("ADD_VPMN_CNT").toString()).append("\r\n")
				.append("  本月累计新增合家欢办理量  ").append(map.get("ADD_HJH_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户中业务合约客户到达数  ").append(map.get("SERVBIND_CNT").toString()).append("\r\n")
				.append("  目标存量拍照客户的业务合约率  ").append(map.get("SERVBIND_PP").toString()).append("\r\n")
				.append("  V网客户活跃率  ").append(map.get("VPMN_ACTIVE_PP").toString()).append("\r\n")
				.append("  合家欢客户活跃率  ").append(map.get("HJH_ACTIVE_PP").toString()).append("\r\n")
				.append("3、可携转客户情况  ").append("\r\n")
				.append("  分包客户中可携转用户数  ").append(map.get("FB_CHANGE").toString()).append("\r\n")
				.append("  分包客户中可携转用户占比  ").append(map.get("FB_CHANGE_PP").toString()).append("\r\n");
				mmsReportDao.insertMMS(subject, contacts, "1", content.toString(), "1");
			}
		}
	}
	
	@SuppressWarnings("rawtypes")
	public boolean sendMailForTerminal(String time){
		String subject = time+"异常渠道";
		List senderList = mmsReportDao.getSenderList(time);
		if(senderList!=null && senderList.size()>0){
			for(int i=0;i<senderList.size();i++){
				HashMap map = new HashMap();
				map = (HashMap)senderList.get(i);
				String area_code = String.valueOf(map.get("area_code"));
				String mail = String.valueOf(map.get("mail"));
				List contentList = mmsReportDao.getContentList(time,area_code);
				if(contentList!=null && contentList.size()>0){
					StringBuffer content = new StringBuffer();
					for(int k=0;k<contentList.size();k++){
						HashMap contentMap = new HashMap();
						contentMap = (HashMap)contentList.get(k);
						content.append(String.valueOf(contentMap.get("stat"))).append("<br>");
					}
					String[] contacts = {mail};
					SendMailWrapper.send(contacts, subject, content.toString());
				}
			}
		}
		return true;
	}
	
	@SuppressWarnings("rawtypes")
	public void  getSMSContent(String time, String content, String sender){
		//得到短信内容配置信息
		List list = mmsReportDao.getSMSParaList(content);
		//生成短信内容
		if(list!=null && list.size()>0){
			String newContent = "";
			for(int i=0;i<list.size();i++){
				HashMap map = (HashMap)list.get(i);
				if(i==0){
					newContent = String.valueOf(map.get("sql"));
					newContent = newContent.replaceAll("\\{time\\}", time);
				}else{
					String paraSql = String.valueOf(map.get("sql"));
					String ds = String.valueOf(map.get("ds"));
					paraSql = paraSql.replaceAll("\\{time\\}", time);
					LOG.debug("paraSql=========="+paraSql);
					String value = mmsReportDao.getSMSValue(paraSql,ds);
					LOG.debug("para"+i+".value========="+value);
					newContent=newContent.replaceAll("para"+i, value);
					LOG.debug("短信发送内容："+newContent);
				}
			}
			//插入到短信任务表中
			if(sender.indexOf(";")>-1){
				String[] senders = sender.split(";");
				for(int i=0;i<senders.length;i++){
					mmsReportDao.insertSendMMSJob(senders[i],newContent,"2",time);
				}
			}else{
				mmsReportDao.insertSendMMSJob(sender,newContent,"2",time);
			}
		}
	}
}
