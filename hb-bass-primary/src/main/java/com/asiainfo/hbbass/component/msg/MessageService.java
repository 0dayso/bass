package com.asiainfo.hbbass.component.msg;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.component.msg.sms.SendSMSWrapper;
import com.asiainfo.hbbass.irs.service.Service;

/**
 * 
 * @author Mei Kefu
 * @date 2010-9-26
 */
public class MessageService extends Service {

	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(MessageService.class);

	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String contacts = request.getParameter("contacts");
		String content = request.getParameter("content");

		SendSMSWrapper.send(contacts, content);
	}
}
