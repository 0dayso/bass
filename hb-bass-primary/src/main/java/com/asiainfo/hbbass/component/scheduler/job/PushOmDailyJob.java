package com.asiainfo.hbbass.component.scheduler.job;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.msg.mms.SendMMSWrapper;

public class PushOmDailyJob implements Job {
	private static Logger LOG = Logger.getLogger(PushOmDailyJob.class);
	
	@SuppressWarnings("rawtypes")
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		boolean succ = false;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar cal = Calendar.getInstance();
		
		cal.add(Calendar.DAY_OF_YEAR, -1);
		String today = sdf.format(cal.getTime());
		int hour = GregorianCalendar.getInstance().get(Calendar.HOUR_OF_DAY);
		String contacts = "18207144852";//联系人
		String subject = "市场运营信息日报";//主题
		String content = "";
		while(!succ&&hour<20){
			
			SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
			try{
				List list = (List)sqlQuery.querys("select content from FPF_OM_MMSREPORT where  time_id='"+today+"' with ur");
				if(list.size()>0){
					HashMap map = (HashMap) list.get(0);
					content = map.get("content").toString();
					SendMMSWrapper.send(contacts, subject, content);
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
