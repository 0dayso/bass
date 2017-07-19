package com.asiainfo.hbbass.component.scheduler.job;

import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.asiainfo.hbbass.app.action.OperMonitorAction;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.msg.mail.SendMail;

/**
 * 收入预测的邮件
 * @author Mei Kefu
 * @date 2010-2-23
 */
@SuppressWarnings("rawtypes")
public class PushChargeForecastJob implements Job {

	private static Logger LOG = Logger.getLogger(PushChargeForecastJob.class);
	
	public void execute(JobExecutionContext context) throws JobExecutionException {
		LOG.info("收入预测调度开始");
		boolean succ = false;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar cal = Calendar.getInstance();
		
		cal.add(Calendar.DAY_OF_YEAR, -1);
		String today = sdf.format(cal.getTime());
		int hour = GregorianCalendar.getInstance().get(Calendar.HOUR_OF_DAY);
		LOG.info("收入预测时间===="+today);
		while(!succ&&hour<20){
			
			SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
			try{
				List list = (List)sqlQuery.querys("select 1 from kpi_total_daily where zb_code='K10001' and channel_code='HB' and time_id='"+today+"' with ur");
				if(list.size()>0){
					String[] to = {"zhaojing@hb.chinamobile.com","zhangtao2@hb.chinamobile.com","maojingjing@hb.chinamobile.com","xiatian@hb.chinamobile.com","gaowen@hb.chinamobile.com","guoxiaodong@hb.chinamobile.com","wanchun@hb.chinamobile.com","15926450672@139.com","13627225151@139.com","13607153889@139.com"};
					String content = "<DIV>&nbsp;&nbsp;&nbsp;&nbsp;"+today.substring(0,6)+"月全省预测收入：<FONT color=red>@charge@</FONT>(万元)</DIV>"
						+"<br><table width='230px' style='font-size:12px;' cellspacing='0' cellpadding='0' border='0'>"
						+"	<tr bgcolor='yellow' align='right'><td>地市</td><td>"+today.substring(0,6)+"预测收入</td><td>上月收入</td></tr>"
						+" @cityData@ "
						+"</table>";
					
					String[] sqls = OperMonitorAction.chargeForecastSQL();
					
					LOG.debug(sqls[1]);
					DecimalFormat df = new DecimalFormat("###,###.00");
					String sql2= sqls[1];
					List list2 = (List)sqlQuery.querys(sql2);
					StringBuilder cityData = new StringBuilder();
					for (int i = 0; i < list2.size(); i++) {
						String[] data = (String[])list2.get(i);
						
						cityData.append("	<tr align='right'><td>")
						.append(data[0])
						.append("</td><td >")
						.append(df.format(Double.valueOf(data[1])))
						.append("</td><td >")
						.append(df.format(Double.valueOf(data[2])))
						.append("</td></tr>");
						
					}
					
					content = content.replaceAll("@cityData@",cityData.toString());
					
					String sql3 = sqls[2] + " with ur";
					LOG.info("收入预测SQL====="+sql3);
					List list1 = (List)sqlQuery.querys(sql3);
					
					content = content.replaceAll("@charge@", df.format(Double.valueOf(((String[])list1.get(0))[1])));
					LOG.info("收入预测conten====="+content);
//					String host = "10.25.36.95";
					String host = "172.16.121.102";
					String from = "hbbass@hb.chinamobile.com";
					String username = "hbbass@hb.chinamobile.com";
					String pwd = "hbcmcc01";
					String[] cc = null;
					String[] bcc = null;
					SendMail.send(host, from, username, pwd, "经分系统"+today.substring(0,6)+"月收入预测", content, to, cc, bcc);
//					SendMailWrapper.send(to,  "经分系统"+today.substring(0,6)+"月收入预测", content);
					LOG.info("收入预测邮件发送完成====="+content);
					succ=true;
				}else{
					
					LOG.info("收入预测短信——没有完成,休眠10分钟");
					try{
						Thread.sleep(600000);
					}catch (InterruptedException e){
						e.printStackTrace();
					}
					hour = GregorianCalendar.getInstance().get(Calendar.HOUR_OF_DAY);
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}finally{
				sqlQuery.release();
			}
		}
	}
	
}
