package com.asiainfo.hbbass.component.msg.mail;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.msg.mail.SendMail;

/**
 *
 * @author Mei Kefu
 * @date 2010-2-24
 * @see yulei3 2013-04-11新增邮件附件方法，重载
 */
public class SendMailWrapper {
	
	public static void send(String[] to,String subject,String dynamicPiece){
		//String host = "10.25.36.95";
		String host = "172.16.121.102";
		String from = "hbbass@hb.chinamobile.com";
		String username = "hbbass@hb.chinamobile.com";
		String pwd = "hbcmcc01";
		
		/*host = "219.238.94.6";
		from = "meikf@asiainfo.com";
		username = "meikf";
		pwd="";*/
		SendMail.send(host, from, username, pwd, subject,genContent(dynamicPiece),to,null,null);
		
		String strTo = to[0];
		for (int i = 1; i < to.length; i++) {
			strTo += ";"+ to[i];
		}
		
		String sql = "insert into FPF_VISITLIST(loginname,area_id,track,opertype,opername) values(?,?,?,?,?)";
		Connection  conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "sender");
			ps.setInt(2, 0);
			ps.setString(3, "信息推送-邮件");
			ps.setString(4, strTo);
			ps.setString(5, subject);
			
			ps.execute();
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			ConnectionManage.getInstance().releaseConnection(conn);
		}
	}
	
	/**
	 * @author yulei3
	 * @date 2013-04-11
	 * @see 发送邮件新增附件 attchments为包含文件的绝对路径 数组
	 * @param to
	 * @param subject
	 * @param dynamicPiece
	 * @param attachments
	 */

	@SuppressWarnings("null")
	public static void send(String[] to,String subject,String dynamicPiece,String[] attachments){
//		String host = "10.25.36.95";
		String host = "172.16.121.102";
		String from = "hbbass@hb.chinamobile.com";
		String username = "hbbass@hb.chinamobile.com";
		String pwd = "hbcmcc01";
		
		/*host = "219.238.94.6";
		from = "meikf@asiainfo.com";
		username = "meikf";
		pwd="";*/
		if(attachments ==null&&attachments.length==0){
			SendMail.send(host, from, username, pwd, subject,genContent(dynamicPiece),to,null,null);
		}else{
			SendMail.send(host, from, username, pwd, subject,genContent(dynamicPiece),attachments,to,null,null);
		}
		String strTo = to[0];
		for (int i = 1; i < to.length; i++) {
			strTo += ";"+ to[i];
		}
		
		String sql = "insert into FPF_VISITLIST(loginname,area_id,track,opertype,opername) values(?,?,?,?,?)";
		Connection  conn = ConnectionManage.getInstance().getWEBConnection();
		try {
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, "sender");
			ps.setInt(2, 0);
			ps.setString(3, "信息推送-邮件");
			ps.setString(4, strTo);
			ps.setString(5, subject);
			
			ps.execute();
			ps.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			ConnectionManage.getInstance().releaseConnection(conn);
		}
	}
	
	/**
	 * 固定部分
	 * @param list
	 * @param context
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	public static String genContent(String dynamicPiece) {
		
		Calendar c = GregorianCalendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String pushDate=sdf.format(c.getTime());
		StringBuilder content = new StringBuilder();
		content.append("<div id='content' style='font-size:12px;'>")
			.append("<DIV>您好！</DIV>")
			.append(dynamicPiece)
			.append("<DIV style='color:red'><br>本邮件由系统自动发出，发件人不会阅读此邮件，请不要直接回复此邮件</DIV><br>")
			.append("<div>&nbsp;&nbsp;&nbsp;&nbsp;致<br>礼!<br>湖北移动经营分析系统<br>")
			.append(pushDate)
			.append("</div></div>");
		
		return content.toString().intern();
	}
	
	public static void main(String[] args){
		
/*		try {
			System.out.println(genContent("测试圣诞节啊开发"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		send(new String[]{"meikf@asiainfo.com"}, "测试","测试圣诞节啊开发");*/
		
		System.out.println("啊a啊".substring(0, 2));
	}
}
