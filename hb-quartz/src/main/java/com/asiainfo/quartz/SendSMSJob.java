package com.asiainfo.quartz;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.bass.apps.mmsreport.MMSReportService;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hbbass.component.msg.sms.SendSMSWrapper;
import com.asiainfo.util.DateUtil;

/**
 * 
 * @author zhangwei
 * @date 2015-02-04
 * @see 彩信自动发送需求
 */
//@Component
public class SendSMSJob {
	private static Logger LOG = Logger.getLogger(SendSMSJob.class);
	
	@Autowired
	private MMSReportService mmsReportService;
	
	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource, false);
	}

	// 每天8点至22点执行，每隔5分钟扫描一次
	//@Scheduled(cron = "0 0/5 8-22 * * ?")
	@SuppressWarnings({ "unused", "unchecked", "rawtypes" })
	public void defaultFunction() {

		// 每行结果集是否发送标志
		boolean rowFlag = true;

		// 发送彩信的日志
		String msg = null;

		//1132,截取头3位，如果精确到分钟的话，怕漏发
		int compareTime = Integer.parseInt(DateUtil.getCurrentDate("HHmm")
				.substring(0, 3));

		String sql = "select * from FPF_SENDSMSJOB where status='1'";

		List<Map<String, Object>> list = jdbcTemplate.queryForList(sql);

		LOG.info("需生成短信程序数：" + list.size());

		for (int i = 0; i < list.size(); i++) {
			HashMap<String, Object> resultMap = new HashMap();

			resultMap = (HashMap<String, Object>)list.get(i);
			String id = String.valueOf(resultMap.get("ID"));
			String content = String.valueOf(resultMap.get("content"));
			String para = String.valueOf(resultMap.get("para"));
			String sender = String.valueOf(resultMap.get("SENDER"));
			if (!"".equals(sender) && sender != null) {
				mmsReportService.getSMSContent(para, content, sender);
				LOG.info("状态更新为短信生成完毕");
				updateStatus("5","发送短信生成完毕",id);
			}
		}
		
		String senderSql = "select * from FPF_SENDSMSJOB where status='2'";
		List<Map<String, Object>> senderList = jdbcTemplate.queryForList(senderSql);
		LOG.info("需发送彩信条数：" + list.size());
		for (int i = 0; i < senderList.size(); i++) {
			HashMap<String, Object> resultMap = (HashMap<String, Object>)senderList.get(i);
			String id = String.valueOf(resultMap.get("ID"));
			String sender = String.valueOf(resultMap.get("sender"));
			String content = String.valueOf(resultMap.get("content"));
			if(!"".equals(sender) && sender!=null){
				try{
					LOG.info("开始发送短信============"+sender);
					if(isMobileNumber(sender)){
						SendSMSWrapper.send(sender, content);
						msg = "短信发送成功";
						updateStatus("5", msg, id);
					}else{
						msg = "联系人号码未通过验证,此次不发送,请核实.";
						updateStatus("4", msg, id);
					}
				}catch (Exception e) {
					LOG.warn("联系人号码未通过验证,此次不发送,请核实.", e);
					e.printStackTrace();
				}
			}else {
				LOG.info("收件人为空,此次不发送,请核实.");
				msg = "联系人为空,此次不发送,请核实.";
				updateStatus("3", msg, id);
			}
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
					.update("update FPF_SENDSMSJOB set status=?,SENDDATE=current timestamp,SENDINFO=? where id=?",
							new Object[] { status, msg, id });
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
