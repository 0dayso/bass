package com.asiainfo.bass.apps.customerValue;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.hbbass.component.msg.mail.SendMail;
import com.asiainfo.hbbass.component.msg.sms.SendSMSWrapper;

@Repository
public class CustomerValueService {
	
	@Autowired
	private CustomerValueDao customerValueDao;
	
	private static Logger LOG = Logger.getLogger(CustomerValueController.class);
	
	public HashMap<String, String> getCustomerInfo(String start_time, String end_time, String zb_code){
		HashMap<String, String> result = new HashMap<String, String>();
		String header = "[{\"name\":\"地市\",\"dataIndex\":\"area_name\",\"cellStyle\":\"grid_row_cell\"},{\"name\":\""+start_time+"\",\"dataIndex\":\"value"+1+"\",\"cellStyle\":\"grid_row_cell\"}";
		String selectSql = "select a.code_name,area_name,a.city_code, a1.code_value value1  ";
		String fromSql = " from (select code_name, city_code,value(area_name,'湖北') area_name from nmk.market_all_view left join mk.bt_area on city_code = area_code where time_id = (select max(time_id) from nmk.market_all_view where code_id='"+zb_code+"') and code_id='"+zb_code+"' ) a  left join (select city_code, code_value from nmk.market_all_view where time_id = '"+start_time+"' and code_id = '"+zb_code+"' ) a1 on a.city_code = a1.city_code";
		int num = Integer.parseInt(end_time.substring(0,4))- Integer.parseInt(start_time.substring(0,4));
		int n = Integer.parseInt(end_time.substring(4,6));
		if(num>0){
			n = num*12-Integer.parseInt(start_time.substring(4,6))+n+1;
		}else{
			n = Integer.parseInt(end_time.substring(4,6)) - Integer.parseInt(start_time.substring(4,6)) + 1;
		}
		int time = Integer.parseInt(start_time);
		String para = start_time;
		for(int i=1;i<n;i++){
			if(num>0){
				int year = Integer.parseInt(para.substring(0,4));
				int month = Integer.parseInt(para.substring(4,6));
				if(month==12){
					year = year+1;
					month = 1;
					time = Integer.parseInt(year+"0"+month);
				}else{
					time = time + 1;
				}
			}else{
				time = time + 1;
			}
			para = String.valueOf(time);
			selectSql = selectSql + ", a"+(i+1)+".code_value value"+(i+1);
			fromSql = fromSql + " left join (select city_code, code_value from nmk.market_all_view where time_id = '"+time+"' and code_id='"+zb_code+"' ) a" + (i+1) +" on a.city_code = a" + (i+1) +".city_code";
			header = header + ",{\"name\":\""+time+"\",\"dataIndex\":\"value"+(i+1)+"\",\"cellStyle\":\"grid_row_cell\"}";
		}
		String sql = selectSql + fromSql + " order by a.city_code desc";
		header = header + "]";
		LOG.info("sql============="+sql);
		LOG.info("header=========="+header);
		result.put("sql", sql);
		result.put("header", header);
		return result;
	}
	
	public HashMap<String, Object> getReply(String fee_id, String time_id, String type, String area_code){
		HashMap<String, Object> result = new HashMap<String, Object>();
		ArrayList<HashMap<String, String>> list = customerValueDao.getReply(fee_id, time_id, type, area_code);
		Map<String, Object> hashMap = customerValueDao.getWarningInfo(fee_id, time_id, type, area_code);
		String area_name = String.valueOf(hashMap.get("AREA_NAME"));
		String act_type = "";
		if("1".equals(type)||"2".equals(type)){
			act_type = String.valueOf(hashMap.get("ACT_TYPE"));
		}
		String fee_name = String.valueOf(hashMap.get("FEE_NAME"));
		result.put("time_id", time_id);
		result.put("area_name", area_name);
		result.put("act_type", act_type);
		result.put("fee_id", fee_id);
		result.put("fee_name", fee_name);
		result.put("list", list);
		return result;
	}
	
	public HashMap<String, Object> getReplyForWarning(String fee_id, String time_id, String type, String area_code){
		HashMap<String, Object> result = new HashMap<String, Object>();
		ArrayList<HashMap<String, String>> list = customerValueDao.getReplyForWarning(fee_id, time_id, type, area_code);
		Map<String, Object> hashMap = customerValueDao.getWarningInfo(fee_id, time_id, type, area_code);
		String area_name = String.valueOf(hashMap.get("AREA_NAME"));
		String act_type = "";
		if("1".equals(type)||"2".equals(type)){
			act_type = String.valueOf(hashMap.get("ACT_TYPE"));
		}
		String fee_name = String.valueOf(hashMap.get("FEE_NAME"));
		result.put("time_id", time_id);
		result.put("area_name", area_name);
		result.put("act_type", act_type);
		result.put("fee_id", fee_id);
		result.put("fee_name", fee_name);
		result.put("list", list);
		return result;
	}
	
	public boolean sendsms(String time){
		boolean flag = false;
		List<Map<String, Object>> szyjList = customerValueDao.getSzyjList(time);
		List<Map<String, Object>> yxpgList = customerValueDao.getYxpgList(time);
		List<Map<String, Object>> qdjkList = customerValueDao.getQdjkList(time);
		List<Map<String, Object>> zfaList = customerValueDao.getZfaList(time);
		for(int i=0;i<szyjList.size();i++){
			Map<String, Object> map = (Map<String, Object>)szyjList.get(i);
			String count = String.valueOf(map.get("count"));
			String mobilephone = String.valueOf(map.get("mobilephone"));
			try {
				if(isMobileNumber(mobilephone)){
					String content = getContent(time, "1", count);
					SendSMSWrapper.send(mobilephone, content);
					flag = true;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		for(int i=0;i<yxpgList.size();i++){
			Map<String, Object> map = (Map<String, Object>)yxpgList.get(i);
			String count = String.valueOf(map.get("count"));
			String mobilephone = String.valueOf(map.get("mobilephone"));
			try {
				if(isMobileNumber(mobilephone)){
					String content = getContent(time, "2", count);
					SendSMSWrapper.send(mobilephone, content);
					flag = true;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		for(int i=0;i<qdjkList.size();i++){
			Map<String, Object> map = (Map<String, Object>)qdjkList.get(i);
			String count = String.valueOf(map.get("count"));
			String mobilephone = String.valueOf(map.get("mobilephone"));
			try {
				if(isMobileNumber(mobilephone)){
					String content = getContent(time, "3", count);
					SendSMSWrapper.send(mobilephone, content);
					flag = true;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		for(int i=0;i<zfaList.size();i++){
			Map<String, Object> map = (Map<String, Object>)zfaList.get(i);
			String count = String.valueOf(map.get("count"));
			String mobilephone = String.valueOf(map.get("mobilephone"));
			try {
				if(isMobileNumber(mobilephone)){
					String content = getContent(time, "4", count);
					SendSMSWrapper.send(mobilephone, content);
					flag = true;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return flag;
	}
	
	public boolean sendmail(String time){
		boolean flag = false;
//		List szyjAreaList = customerValueDao.getSzyjAreaListForMMS(time);
//		List yxpgAreaList = customerValueDao.getYxpgAreaListForMMS(time);
//		List zfaAreaList = customerValueDao.getZfaAreaListForMMS(time);
//		List qdjkAreaList = customerValueDao.getQdjkAreaListForMMS(time);
//		for(int i=0;i<szyjAreaList.size();i++){
//			HashMap map = new HashMap();
//			map = (HashMap)szyjAreaList.get(i);
//			String area_code = String.valueOf(map.get("AREA_CODE"));
//			List szyjList = customerValueDao.getSzyjListForMMS(time, area_code);
//			String mobilephone = String.valueOf(map.get("mobilephone"));
//			if(szyjList!=null && szyjList.size()>0){
//				try {
//					if(isMobileNumber(mobilephone)){
//						String content = getMMSContent("1", szyjList);
//						flag = SendMMSWrapper.send(mobilephone, "营销案（事中预警）全省前10", content);
//					}
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//			}
//		}
//		for(int i=0;i<yxpgAreaList.size();i++){
//			HashMap map = new HashMap();
//			map = (HashMap)yxpgAreaList.get(i);
//			String area_code = String.valueOf(map.get("AREA_CODE"));
//			List yxpgList = customerValueDao.getYxpgListForMMS(time, area_code);
//			String mobilephone = String.valueOf(map.get("mobilephone"));
//			if(yxpgList!=null && yxpgList.size()>0){
//				try {
//					if(isMobileNumber(mobilephone)){
//						String content = getMMSContent("2", yxpgList);
//						flag = SendMMSWrapper.send(mobilephone, "营销案（后评估）全省前10", content);
//					}
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//			}
//		}
//		for(int i=0;i<zfaAreaList.size();i++){
//			HashMap map = new HashMap();
//			map = (HashMap)zfaAreaList.get(i);
//			String area_code = String.valueOf(map.get("AREA_CODE"));
//			List zfaList = customerValueDao.getZfaListForMMS(time, area_code);
//			String mobilephone = String.valueOf(map.get("mobilephone"));
//			if(zfaList!=null && zfaList.size()>0){
//				try {
//					if(isMobileNumber(mobilephone)){
//						String content = getMMSContent("3", zfaList);
//						flag = SendMMSWrapper.send(mobilephone, "资费案全省前10", content);
//					}
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//			}
//		}
//		for(int i=0;i<qdjkAreaList.size();i++){
//			HashMap map = new HashMap();
//			map = (HashMap)qdjkAreaList.get(i);
//			String area_code = String.valueOf(map.get("AREA_CODE"));
//			List qdjkList = customerValueDao.getQdjkListForMMS(time, area_code);
//			String mobilephone = String.valueOf(map.get("mobilephone"));
//			if(qdjkList!=null && qdjkList.size()>0){
//				try {
//					if(isMobileNumber(mobilephone)){
//						String content = getMMSContent("4", qdjkList);
//						flag = SendMMSWrapper.send(mobilephone, "渠道监控全省前10", content);
//					}
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//			}
//		}
		//获得营销案（事中预警）、营销案（后评估）、渠道监控、资费案监控营销活动中按负价值占比排名前10的营销活动
		List<Map<String, Object>> szyjAreaList = customerValueDao.getAreaListForMMS(time,"1");
		List<Map<String, Object>> yxpgAreaList = customerValueDao.getAreaListForMMS(time,"2");
		List<Map<String, Object>> qdjkAreaList = customerValueDao.getAreaListForMMS(time,"3");
		List<Map<String, Object>> zfaAreaList = customerValueDao.getAreaListForMMS(time,"4");
		Calendar c = GregorianCalendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String pushDate=sdf.format(c.getTime());
		StringBuffer content = new StringBuffer();
		content.append("<div id='content' style='font-size:12px;'>")
		.append("<DIV>您好！</DIV>")
		.append("<DIV>    此邮件为：")
		.append(time+"客户价值预警"+"</DIV>");
		if(szyjAreaList!=null && szyjAreaList.size()>0){
			content.append(getMMSContent("1", szyjAreaList));
		}
		if(yxpgAreaList!=null && yxpgAreaList.size()>0){
			content.append(getMMSContent("2", yxpgAreaList));
		}
		if(qdjkAreaList!=null && qdjkAreaList.size()>0){
			content.append(getMMSContent("3", qdjkAreaList));
		}
		if(zfaAreaList!=null && zfaAreaList.size()>0){
			content.append(getMMSContent("4", zfaAreaList));
		}
		content.append("<div style='color:red'><br>本邮件由系统自动发出，发件人不会阅读此邮件，请不要直接回复此邮件</div><br>")
		.append("<div>&nbsp;&nbsp;&nbsp;&nbsp;致<br>礼!<br>湖北移动经营分析系统<br>")
		.append(pushDate)
		.append("</div></div>");
		if(!"".equals(content) && content!=null){
			String host = "172.16.121.102";
			String from = "hbbass@hb.chinamobile.com";
			String username = "hbbass@hb.chinamobile.com";
			String pwd = "hbcmcc01";
			String[] cc = null;
			String[] tos = getTo("A1");
			String[] bcc = null;
			if(tos!=null && tos.length>0){
				SendMail.send(host, from, username, pwd, time+"客户价值预警通报", content.toString(), tos, cc, bcc);
				flag = true;
			}
		}
		LOG.info("content===================="+content.toString());
		return flag;
	}
	
	public String getContent(String time, String type, String count){
		String month = time.substring(0,4);
		String day = time.substring(4, 6);
		String name = "";
		if("1".equals(type)){
			name = "营销案（事中预警）";
		}else if("2".equals(type)){
			name = "营销案（后评估）";
		}else if("3".equals(type)){
			name = "资费案";
		}else if("4".equals(type)){
			name = "渠道监控";
		}
		String content = month + "年" + day + "月有" + count + "条" + name + "代办，请于20天内登经分前台进行处理。";
		LOG.info("content==============="+content);
		return content;
	}
	
	public String getMMSContent(String type, List<Map<String, Object>> list){
		StringBuffer content = new StringBuffer();
		if("1".equals(type)){
			content.append("<div>")
			.append("营销案（事中预警）口径说明：最近2个月参与该营销案用户数在1000户以上，取直接成本占收前10名的数据情况<br>")
			.append("<table align='center' width='99%' border='1' cellpadding='0' cellspacing='0'>");
			content.append("<tr>")
			.append("<td align='center'>").append("归属").append("</td>")
			.append("<td align='center'>").append("营销案名称").append("</td>")
			.append("<td align='center'>").append("用户数").append("</td>")
			.append("<td align='center'>").append("直接成本占收比").append("</td>")
			.append("<td align='center'>").append("负价值用户占比").append("</td>")
			.append("<td align='center'>").append("预警次数").append("</td>")
			.append("</tr>");
			for(int i=0;i<list.size();i++){
				Map<String, Object> map = (Map<String, Object>)list.get(i);
				String area_name = String.valueOf(map.get("AREA_NAME"));
				String fee_name = String.valueOf(map.get("FEE_NAME"));
				String user_num = String.valueOf(map.get("USER_NUM"));
				String direct_cost_rate = String.valueOf(map.get("DIRECT_COST_RATE"));
				String low_value_rate = String.valueOf(map.get("LOW_VALUE_RATE"));
				String alert_total = String.valueOf(map.get("ALERT_TOTAL"));
				content
				.append("<tr><td align='center'>").append(area_name).append("</td>")
				.append("<td align='center'>").append(fee_name).append("</td>")
				.append("<td align='right'>").append(user_num).append("</td>")
				.append("<td align='right'>").append(direct_cost_rate).append("</td>")
				.append("<td align='right'>").append(low_value_rate).append("</td>")
				.append("<td align='right'>").append(alert_total).append("次").append("</td>")
				.append("</tr>");
			}
			content.append("</table>")
			.append("</div><br><br>");
			content.toString().intern();
		}else if("2".equals(type)){
			content.append("<div>")
			.append("营销案（后评估）口径说明：最近2个月参与该营销案用户数在1000户以上，取直接成本占收前10名的数据情况<br>")
			.append("<table align='center' width='99%' border='1' cellpadding='0' cellspacing='0'>");
			content.append("<tr>")
			.append("<td align='center'>").append("归属").append("</td>")
			.append("<td align='center'>").append("营销案名称").append("</td>")
			.append("<td align='center'>").append("用户数").append("</td>")
			.append("<td align='center'>").append("直接成本占收比").append("</td>")
			.append("<td align='center'>").append("负价值用户占比").append("</td>")
			.append("<td align='center'>").append("预警次数").append("</td>")
			.append("</tr>");
			for(int i=0;i<list.size();i++){
				Map<String, Object> map = (Map<String, Object>)list.get(i);
				String area_name = String.valueOf(map.get("AREA_NAME"));
				String fee_name = String.valueOf(map.get("FEE_NAME"));
				String user_num = String.valueOf(map.get("USER_NUM"));
				String direct_cost_rate = String.valueOf(map.get("DIRECT_COST_RATE"));
				String low_value_rate = String.valueOf(map.get("LOW_VALUE_RATE"));
				String alert_total = String.valueOf(map.get("ALERT_TOTAL"));
				content
				.append("<tr><td align='center'>").append(area_name).append("</td>")
				.append("<td align='center'>").append(fee_name).append("</td>")
				.append("<td align='right'>").append(user_num).append("</td>")
				.append("<td align='right'>").append(direct_cost_rate).append("</td>")
				.append("<td align='right'>").append(low_value_rate).append("</td>")
				.append("<td align='right'>").append(alert_total).append("次").append("</td>")
				.append("</tr>");
			}
			content.append("</table>")
			.append("</div><br><br>");
			content.toString().intern();
		}else if("3".equals(type)){
			content.append("<div>")
			.append("渠道监控口径说明：半年以放号在1000户以上用户，取直接成本占收前10名的数据情况")
			.append("<table align='center' width='99%' border='1' cellpadding='0' cellspacing='0'>");
			content.append("<tr>")
			.append("<td align='center'>").append("归属").append("</td>")
			.append("<td align='center'>").append("渠道名称名称").append("</td>")
			.append("<td align='center'>").append("放号数").append("</td>")
			.append("<td align='center'>").append("直接成本占收比").append("</td>")
			.append("<td align='center'>").append("负价值用户占比").append("</td>")
			.append("<td align='center'>").append("预警次数").append("</td>")
			.append("</tr>");
			for(int i=0;i<list.size();i++){
				Map<String, Object> map = (Map<String, Object>)list.get(i);
				String area_name = String.valueOf(map.get("AREA_NAME"));
				String fee_name = String.valueOf(map.get("FEE_NAME"));
				String user_num = String.valueOf(map.get("USER_NUM"));
				String direct_cost_rate = String.valueOf(map.get("DIRECT_COST_RATE"));
				String low_value_rate = String.valueOf(map.get("LOW_VALUE_RATE"));
				String alert_total = String.valueOf(map.get("ALERT_TOTAL"));
				content.append("<tr>")
				.append("<td align='center'>").append(area_name).append("</td>")
				.append("<td align='center'>").append(fee_name).append("</td>")
				.append("<td align='right'>").append(user_num).append("</td>")
				.append("<td align='right'>").append(direct_cost_rate).append("</td>")
				.append("<td align='right'>").append(low_value_rate).append("</td>")
				.append("<td align='right'>").append(alert_total).append("次").append("</td>")
				.append("</tr>");
			}
			content.append("</table>")
			.append("</div><br><br>");
			content.toString().intern();
		}else if("4".equals(type)){
			content.append("<div>")
			.append("资费案监控口径说明：在售，最近3个月连续使用该资费的用户，效益情况评估和直接成本构成用3个月的累计）取直接成本占收比前10名")
			.append("<table align='center' width='99%' border='1' cellpadding='0' cellspacing='0'>");
			content.append("<tr>")
			.append("<td align='center'>").append("归属").append("</td>")
			.append("<td align='center'>").append("资费案名称").append("</td>")
			.append("<td align='center'>").append("用户数").append("</td>")
			.append("<td align='center'>").append("直接成本占收比").append("</td>")
			.append("<td align='center'>").append("负价值用户占比").append("</td>")
			.append("<td align='center'>").append("预警次数").append("</td>")
			.append("</tr>");
			for(int i=0;i<list.size();i++){
				Map<String, Object> map = (Map<String, Object>)list.get(i);
				String area_name = String.valueOf(map.get("AREA_NAME"));
				String fee_name = String.valueOf(map.get("FEE_NAME"));
				String user_num = String.valueOf(map.get("USER_NUM"));
				String direct_cost_rate = String.valueOf(map.get("DIRECT_COST_RATE"));
				String low_value_rate = String.valueOf(map.get("LOW_VALUE_RATE"));
				String alert_total = String.valueOf(map.get("ALERT_TOTAL"));
				content.append("<tr>")
				.append("<td align='center'>").append(area_name).append("</td>")
				.append("<td align='center'>").append(fee_name).append("</td>")
				.append("<td align='right'>").append(user_num).append("</td>")
				.append("<td align='right'>").append(direct_cost_rate).append("</td>")
				.append("<td align='right'>").append(low_value_rate).append("</td>")
				.append("<td align='right'>").append(alert_total).append("次").append("</td>")
				.append("</tr>");
			}
			content.append("</table>")
			.append("</div><br><br>");
			content.toString().intern();
		}
		return content.toString();
	}
	
	/**
	 * 判断该手机号码是否是移动手机号段<br>
	 * 
	 * @param phone
	 * @return true or false
	 * @throws Exception
	 */
	private boolean isMobileNumber(String phone) throws Exception {
		boolean isExist = false;

		phone = phone.trim();
		if (phone == null || phone.length() < 7) {
			try {
				throw new Exception("wrong phone length");
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		String code = phone.substring(0, 7);// 暂时保留2009-01-16 16:30

		if (code.startsWith("134") || code.startsWith("135")
				|| code.startsWith("136") || code.startsWith("137")
				|| code.startsWith("138") || code.startsWith("139")
				|| code.startsWith("159") || code.startsWith("158")
				|| code.startsWith("150") || code.startsWith("157")
				|| code.startsWith("151") || code.startsWith("188")
				|| code.startsWith("189")) {
			isExist = true;
		}
		return isExist;

	}

	public Map<String,List<Map<String,Object>>> getTreeList() {
		Map<String,List<Map<String,Object>>> result = new HashMap<String,List<Map<String,Object>>>();
		List<Map<String,Object>> parentList = customerValueDao.getParentList();
		List<Map<String,Object>> subjectList = new ArrayList<Map<String,Object>>();
		if(parentList!=null && parentList.size()>0){
			for(int i=0;i<parentList.size();i++){
				Map<String,Object> elemMap = new HashMap<String,Object>();
				elemMap = (Map<String,Object>) parentList.get(i);
				elemMap.put("subjects", customerValueDao.getChildList(elemMap.get("id").toString()));
				subjectList.add(elemMap);
			}
		}
		result.put("elements", subjectList);
		return result;
	}
	
	/**
	 * 得到发送信息
	 * @param group	发送组
	 * @return 返回发送的数组
	 */
	public String[] getTo(String group){
		List<Map<String, Object>> list = customerValueDao.getListByGroupId(group);
		if(list!=null && list.size()>0){
			String[] mobilephones = new String[list.size()];
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> map = (Map<String, Object>) list.get(i);
				mobilephones[i] = String.valueOf(map.get("EMAIL"));
			}
			return mobilephones;
		}else{
			return null;
		}
	}

}
