package com.asiainfo.hbbass.component.scheduler.job;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.component.msg.mms.SendMMSWrapper;

/**
 *
 * @author Mei Kefu
 * @date 2010-6-16
 */
@SuppressWarnings("rawtypes")
public class PushMmsJob extends PushJob {

	private static Logger LOG = Logger.getLogger(PushMmsJob.class);

	public void push(List list, Map context) {
		String[] textArr = ((String[])list.get(0));
		String text = textArr[0];
		for (int i = 1; i < textArr.length; i++) {
			text +=","+textArr[i];
		}
		
		String subject = (String)context.get("subject");
		String contacts = (String)context.get("contacts");
		LOG.debug("contacts:"+contacts+" content:"+text+" subject:"+subject);
		
		SendMMSWrapper.send(contacts,subject, text);
	}
	
	public static void main(String[] args){
		
	}
}
