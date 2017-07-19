package com.asiainfo.hbbass.component.msg.mail;

import java.util.Calendar;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

public class SendMail
{
	/**
	 * 
	 * @param subject 	主题
	 * @param content	文本
	 * @param to		发送人列表
	 * @param cc		抄送人列表
	 */
	public static void send(String host,String from, String username,String password,String subject,String content,String[] to,String[] cc,String[] bcc)
	{
		try
		{
			Properties props = System.getProperties();
			props.put("mail.transport.protocol", "smtp");
			props.put("mail.smtp.starttls.enable","true");
			props.put("mail.smtp.host", host);
			props.put("mail.smtp.auth", "true");
			
			final String fuser = username;
			final String fpwd = password;
			
			Authenticator auth = new javax.mail.Authenticator()
			{
				public PasswordAuthentication getPasswordAuthentication() {
					
					return new PasswordAuthentication(fuser, fpwd);
				}
			};
			Session session = Session.getInstance(props , auth);
			session.setDebug(true);
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(from));
			message.setText(content, "GBK");
			if(to != null && to.length > 0){
				InternetAddress[] addto = new InternetAddress[to.length];
				for (int i = 0; i < to.length; i++)
				{
					addto[i] = new InternetAddress(to[i]);
				}
				message.setRecipients(Message.RecipientType.TO, addto);
			}
			
			if(cc != null && cc.length > 0)
			{
				InternetAddress[] addcc = new InternetAddress[cc.length];
				for (int i = 0; i < cc.length; i++)
				{
					addcc[i] = new InternetAddress(cc[i]);
				}
				message.setRecipients(Message.RecipientType.CC, addcc);
			}
			
			if(bcc != null && bcc.length > 0)
			{
				InternetAddress[] addbcc = new InternetAddress[bcc.length];
				for (int i = 0; i < bcc.length; i++)
				{
					addbcc[i] = new InternetAddress(bcc[i]);
				}
				message.setRecipients(Message.RecipientType.BCC, addbcc);
			}
			message.setSubject(subject);
			MimeBodyPart mbp = new MimeBodyPart();
			mbp.setContent(content, "text/html; charset=gbk");
			//mbp.setText(content);
			Multipart mp = new MimeMultipart();
			mp.addBodyPart(mbp);
			message.setContent(mp);
			message.setSentDate(Calendar.getInstance().getTime());
			Transport transport = session.getTransport("smtp");
			transport.connect(host, username, password);
			Transport.send(message);
		}
		catch (MessagingException e)
		{
			e.printStackTrace();
		}
	}
	
	/**
	 * @author yulei3
	 * @see 2013-04-11新增邮件附件，override
	 * @param host
	 * @param from
	 * @param username
	 * @param password
	 * @param subject
	 * @param content
	 * @param attachments
	 * @param to
	 * @param cc
	 * @param bcc
	 */
	public static void send(String host,String from, String username,String password,String subject,String content,String[] attachments,String[] to,String[] cc,String[] bcc)
	{
		try
		{
			Properties props = System.getProperties();
			props.put("mail.transport.protocol", "smtp");
			props.put("mail.smtp.starttls.enable","true");
			props.put("mail.smtp.host", host);
			props.put("mail.smtp.auth", "true");
			
			final String fuser = username;
			final String fpwd = password;
			
			Authenticator auth = new javax.mail.Authenticator()
			{
				public PasswordAuthentication getPasswordAuthentication() {
					
					return new PasswordAuthentication(fuser, fpwd);
				}
			};
			Session session = Session.getInstance(props , auth);
			session.setDebug(true);
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(from));
			message.setText(content, "GBK");
			if(to != null && to.length > 0){
				InternetAddress[] addto = new InternetAddress[to.length];
				for (int i = 0; i < to.length; i++)
				{
					addto[i] = new InternetAddress(to[i]);
				}
				message.setRecipients(Message.RecipientType.TO, addto);
			}
			
			if(cc != null && cc.length > 0)
			{
				InternetAddress[] addcc = new InternetAddress[cc.length];
				for (int i = 0; i < cc.length; i++)
				{
					addcc[i] = new InternetAddress(cc[i]);
				}
				message.setRecipients(Message.RecipientType.CC, addcc);
			}
			
			if(bcc != null && bcc.length > 0)
			{
				InternetAddress[] addbcc = new InternetAddress[bcc.length];
				for (int i = 0; i < bcc.length; i++)
				{
					addbcc[i] = new InternetAddress(bcc[i]);
				}
				message.setRecipients(Message.RecipientType.BCC, addbcc);
			}
			
			message.setSubject(subject);
			MimeBodyPart mbp = new MimeBodyPart();
			mbp.setContent(content, "text/html; charset=gbk");
			//mbp.setText(content);
			Multipart mp = new MimeMultipart();
			
			mp.addBodyPart(mbp);
			
			//2013-04-11 yulei3新增附件判断,不能把附件加在内容前面，这样发送邮件会有问题 start
			try{
				if(attachments!=null && attachments.length>0){
					for(int i=0;i<attachments.length;i++){
						MimeBodyPart mbpFile = new MimeBodyPart();
						FileDataSource fds = new FileDataSource(attachments[i]);
						mbpFile.setDataHandler(new DataHandler(fds));
						mbpFile.setFileName(fds.getName());
						mp.addBodyPart(mbpFile);
					}
				}
			}catch(Exception ex){
				//防止附件路径不存在导致的发送邮件失败
				ex.printStackTrace();
			}
			//2013-04-11 新增附件判断 end
			message.setContent(mp);
			message.setSentDate(Calendar.getInstance().getTime());
			Transport transport = session.getTransport("smtp");
			transport.connect(host, username, password);
			Transport.send(message);
		}
		catch (MessagingException e)
		{
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args)
	{
		String host = "smtp.asiainfo.com";
		String from = "meikf@asiainfo.com";
		String username = "meikf";
		
		String content = "<div id='content' style='font-size:12px;'>"
			+"<DIV>大家好！</DIV>"
			+"<DIV>&nbsp;&nbsp;&nbsp;&nbsp;200912月全省预测收入：<FONT color=red>137,309.66</FONT>(万元)</DIV>"
			+"<br><table width='230px' style='font-size:12px;' cellspacing='0' cellpadding='0' border='0'>"
			+"	<tr bgcolor='yellow' align='right'><td>地市</td><td>200912预测收入</td><td>上月收入</td></tr>"
			+"	<tr align='right'><td>武汉</td><td >44,291.53</td><td >42,572.87</td></tr>"
			+"	<tr align='right'><td>荆州</td><td>12,304.61</td><td>12,028.57</td></tr>"
			+"	<tr align='right'><td>鄂州</td><td >2,361.70</td><td >2,310.64</td></tr>"
			+"</table>"
			+"<DIV style='color:red'><br>本邮件由系统自动发出，发件人不会阅读此邮件，请不要直接回复此邮件</DIV><br>"
			+"<div>&nbsp;&nbsp;&nbsp;&nbsp;致<br>礼!<br>湖北移动经营分析系统<br>2009-12-31</div>"
			+"</div>";
		
		String[] arr = {"meikf@asiainfo.com"};
		SendMail.send(host, from, username, "", "测试经分系统200912月收入预测",content,null,arr,new String[]{"meikf@asiainfo.com"});
		/*Runtime r = Runtime.getRuntime();
		
		try
		{
			Process p = r.exec("cmd.exe /c ipconfig");
			
			BufferedReader br = new BufferedReader(new InputStreamReader(p.getInputStream()));
			String line = null;
			String lastLine = null;
			while((line = br.readLine())!= null)
			{
				if(line.trim().startsWith("IP Address"))
					lastLine = line.trim();
			}
			System.out.println(lastLine);
			br.close();
			p.destroy();
		}
		catch (IOException e)
		{
			
			e.printStackTrace();
		}*/
	}
}
