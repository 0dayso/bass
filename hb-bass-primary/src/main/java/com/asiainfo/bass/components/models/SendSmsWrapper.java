package com.asiainfo.bass.components.models;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import bass.message.Client;

/**
 * 
 * @author Mei Kefu
 * @date 2010-5-28
 */
@Component
public class SendSmsWrapper {

	private static Logger LOG = Logger.getLogger(SendSmsWrapper.class);

	private JdbcTemplate jdbcTemplate;

	@Autowired
	public void setDataSource(DataSource dataSource) {
		jdbcTemplate = new JdbcTemplate(dataSource);
	}

	/**
	 * 发送短信，支持多个联系人发送，间隔500毫秒
	 * 
	 * @param contacts
	 *            ： 联系人用;分隔
	 * @param content
	 */
	public void send(String contacts, String content) {
		String res = "";
		if (content != null && content.length() > 0) {
			String[] arrConts = contacts.split(";");

			for (int i = 0; i < arrConts.length; i++) {
				try {
					oriSend(arrConts[i], content);
				} catch (Exception e) {
					res = "失败";
					e.printStackTrace();
					LOG.error("发送失败:" + arrConts[i] + content + e.getMessage(), e);
				}
				try {
					Thread.sleep(500);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		}

		content = res + content;

		String sql = "insert into FPF_VISITLIST(loginname,area_id,track,opertype,opername) values(?,?,?,?,?)";
		try {
			jdbcTemplate.update(sql, new Object[] { "sender", Integer.valueOf(0), "信息推送-短信", contacts, content.length() > 64 ? content.substring(0, 64) : content });
		} catch (Exception e) {
			e.printStackTrace();

		}
	}

	/**
	 * 原始发短信的方法
	 * 
	 * @param phone
	 * @param message
	 */
	public static void oriSend(String phone, String message) throws Exception {
		phone = phone.trim();

		if (phone.matches("[0-9]{11}")) {

			String host = "10.25.124.217";
			int port = 8000;

			// String host = "10.25.124.45";
			// int port = 8081;

			int len = message.length();
			int size = 64;
			if (len > 70) {// 长短信拆分发送
				int loop = len / size;
				loop = loop < 4 ? loop : 4;// 最多5条短信
				for (int i = 0; i <= loop; i++) {
					String str = message.substring(i * size, (i + 1) * size < len ? (i + 1) * size : len) + "(" + (i + 1) + "/" + (loop + 1) + ")";
					new Client(host, port, phone, str);
					try {
						Thread.sleep(500);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}

			} else {
				new Client(host, port, phone, message);
			}
		} else {
			throw new RuntimeException("手机号码不正确");
		}
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// new Client("10.25.124.45", 8081,"13697339119", "测试");
		try {
			oriSend("13697339119", "测试");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
