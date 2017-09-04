package com.asiainfo.quartz;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import com.asiainfo.bass.apps.mmsreport.MMSReportService;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hbbass.component.msg.mms.SendMMSWrapper;
import com.asiainfo.util.DateUtil;

/**
 * 
 * @author zhangwei
 * @date 2014-05-28
 * @see 彩信自动发送需求
 */
//@Component
public class SendMMSJob {
	private static Logger LOG = Logger.getLogger(SendMMSJob.class);
	
	@Autowired
	private MMSReportService mmsReportService;
	
	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	// 每天8点至22点执行，每隔5分钟扫描一次
	//@Scheduled(cron = "0 0/5 8-22 * * ?")
	public void defaultFunction() {

		// 每行结果集是否发送标志
		boolean rowFlag = true;

		// 发送彩信的日志
		String msg = null;

		// 1132,截取头3位，如果精确到分钟的话，怕漏发
		Integer.parseInt(DateUtil.getCurrentDate("HHmm")
				.substring(0, 3));

		String sql = "select * from SENDMMSJOB where status='1'";

		List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);

		LOG.info("====this time the job 's size is:" + list.size() + "=====");

		Map<String, Object> resultMap = null;
		for (int i = 0; i < list.size(); i++) {
			rowFlag = true;

			msg = "发送成功";

			resultMap = list.get(i);

			String type = (String) resultMap.get("type");
			
			String id = String.valueOf(resultMap.get("id"));

			if ("2".equals(type)) {
				String method = (String)resultMap.get("content");
				String para = (String)resultMap.get("para");
				mmsReportService.getContent(para,method);
				msg = "彩信内容更新完成，等待发送彩信";
//				updateContent(content,"1",msg,id);
			} else if("1".equals(type)){
				String sender = String.valueOf(resultMap.get("sender"));
				String content = String.valueOf(resultMap.get("content"));
				String subject = String.valueOf(resultMap.get("subject"));
				sender(sender, msg, id, content, subject, rowFlag);
			}

			
		}
	}
	
	public void sender(String tempSender, String msg, String id, String content, String subject, boolean rowFlag){
		String senders = "";

		if (null == tempSender || tempSender.length() == 0) {
			LOG.info("收件人为空,此次不发送,请核实.");
			msg = "联系人为空,此次不发送,请核实.";
			updateStatus("2", msg, id);
		}

		List<String> senderList = new ArrayList<String>();

		for (int j = 0; j < tempSender.split(";").length; j++) {
			String phoneNum = tempSender.split(";")[j];
			try {
				if (isMobileNumber(phoneNum)) {
					senderList.add(tempSender.split(";")[j]);
				}
			} catch (Exception e) {
				LOG.warn("彩信发送失败", e);
				e.printStackTrace();
			}
		}

		if (senderList.size() == 0) {
			LOG.info("联系人号码未通过验证,此次不发送,请核实.");
			msg = "联系人号码未通过验证,此次不发送,请核实.";
			updateStatus("4", msg, id);
		} else {
			// senders=senderList.toArray(new String[]{});
			if (senderList.size() == 1) {
				senders = senderList.get(0);
			} else if (senderList.size() > 1) {
				for (int m = 0; m < senderList.size(); m++) {
					senders = senders.equals("") ? senderList.get(m)
							: senders + senderList.get(m);
				}
			}
		}

		if (rowFlag) {
			try {
				boolean flag = SendMMSWrapper.send(senders, subject, content);
				LOG.info("彩信发送结果===============" + flag);
			} catch (Exception ex) {
				LOG.warn("邮件发送失败", ex);
				msg = "邮件发送失败";
			}

			updateStatus(msg.equals("发送成功") ? "2" : "4", msg,
					id);
		} else {
			updateStatus("4", msg, id);
		}

	}

	/**
	 * @see 更新SENDMAILJOB状态、日志
	 * @param status
	 * @param msg
	 * @param id
	 */
	public void updateStatus(String status, String msg, String id) {
		try {
			jdbcTemplate
					.update("update SENDMMSJOB set status='"+status+"',SENDDATE=current timestamp,SENDINFO='"+msg+"' where id='"+id+"'");
		} catch (Exception ex) {
			LOG.warn("更新日志失败", ex);
		}
	}
	
	public void updateContent(String content ,String status,String msg,String id){
		try {
			jdbcTemplate
					.update("update SENDMMSJOB set status='"+status+"',SENDDATE=current timestamp,SENDINFO='"+msg+"',content='"+content+"' where id='"+id+"'");
		} catch (Exception ex) {
			LOG.warn("更新日志失败", ex);
		}
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
		LOG.info("phone==========="+phone);
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
}
