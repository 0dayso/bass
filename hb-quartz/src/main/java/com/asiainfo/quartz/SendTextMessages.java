package com.asiainfo.quartz;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import bass.message.PhoneException;
import bass.message.ShortMessage;

@Component
public class SendTextMessages {
	/**
	 * 定时发短信
	 */
	private static Logger logger = Logger.getLogger(SendTextMessages.class);

	@Scheduled(cron = "0 10 9 ? * *")
	public void reFrsehLast() {
		SendTextMessages stm = new SendTextMessages();
		int week = 0;
		SimpleDateFormat format = new SimpleDateFormat("dd");
		Date date = new Date();
		try {
			week = stm.dayForWeek();
			String day = format.format(date);
			if (day.equals("06") || day.equals("07") || day.equals("08")) {
				if (day.equals("06") && week == 5) {
					stm.send();
				} else if (day.equals("07") && week == 5) {
					stm.send();
				} else if (day.equals("08") && week >= 1 && week <= 5) {
					stm.send();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void send() throws PhoneException {
		Properties prop = new Properties();
		InputStream in = SendTextMessages.class.getResourceAsStream("/quartz.properties");
		try {
			prop.load(in);
			Iterator<String> it = prop.stringPropertyNames().iterator();
			while (it.hasNext()) {
				ShortMessage sm = new ShortMessage(prop.getProperty("customer.remind.sendto.phone"), prop.getProperty("customer.remind.sendto.content"));
				sm.sendShortMessage();
				logger.debug("发送短信给：" + prop.getProperty("customer.remind.sendto.phone"));
			}
			in.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	public int dayForWeek() throws Exception {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Calendar c = Calendar.getInstance();
		Date data = new Date();
		c.setTime(format.parse(format.format(data)));
		int dayForWeek = 0;
		if (c.get(Calendar.DAY_OF_WEEK) == 1) {
			dayForWeek = 7;
		} else {
			dayForWeek = c.get(Calendar.DAY_OF_WEEK) - 1;
		}
		return dayForWeek;
	}

}
