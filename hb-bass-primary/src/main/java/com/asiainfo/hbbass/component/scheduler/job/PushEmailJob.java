package com.asiainfo.hbbass.component.scheduler.job;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.component.msg.mail.SendMailWrapper;

/**
 *
 * @author Mei Kefu
 * @date 2010-2-23
 */
@SuppressWarnings("rawtypes")
public class PushEmailJob extends PushJob {

	private static Logger LOG = Logger.getLogger(PushEmailJob.class);
	
	public void push(List list, Map context) {
		String contacts = (String)context.get("contacts");
		
		String[] arrConts=contacts.split(";");
		String[] to = new String[arrConts.length];
		for (int i = 0; i < arrConts.length; i++) {
			to[i] = arrConts[i].intern();
		}
		
		String subject = (String)context.get("subject");
		String[] dates = calDate();
		subject = subject.replaceAll("@month", dates[1]).replaceAll("@date", dates[0]);
		
		LOG.debug("contacts:"+contacts+" subject:"+subject);
		
		String result =dynamicPiece(list, context);
		
		LOG.debug("Email Content:\r\n"+result);
		
		if(result.length()>0){
			SendMailWrapper.send(to, subject, result);
		}
	}
	
	/**
	 * 动态拼接部分，可以覆盖
	 * @param list
	 * @param context
	 * @return
	 */
	public String dynamicPiece(List list, Map context){
		
		if(list.size()==1){//如果只有表头，没有数据就返回空字符串，然后不发送邮件
			String[] data = (String[])list.get(0);
			for (int i = 0; i < data.length; i++) {
				if(data[0].matches(".*@title.*"))
				return "";
			}
		}
		
		StringBuilder full = new StringBuilder();
		int width = 0;
		String[] data = (String[])list.get(0);
		width = data.length*80;
		
		full.append("<br><table width='"+width+"' style='font-size:12px;' cellspacing='1' cellpadding='0' border='0' bgcolor='#bbbbbb'>");
		
		StringBuilder piece = new StringBuilder();
		for (int i = 0; i < list.size(); i++) {
			data = (String[])list.get(i);
			
			if(data.length>0&&data[0].matches(".*@title.*")){
				full.append("	<tr bgcolor='yellow' align='right'>").append("<td>").append(data[0].replaceAll("@title","")).append("</td>");
				for (int j = 1; j < data.length; j++) {
					full.append("<td>").append(data[j]).append("</td>");
				}
				full.append("</tr>");
			}else{
				piece.append("	<tr bgcolor='#FFFFFF' align='right'>");
				for (int j = 0; j < data.length; j++) {
					piece.append("<td>").append(data[j]).append("</td>");
				}
				piece.append("</tr>");
			}
		}
		full.append(piece);
		full.append("</table>");
		
		return full.toString();
	}
	
	
}
