package com.asiainfo.hbbass.component.scheduler.job;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;

/**
 * 推送的抽象类
 * 
 * 主要的数据是从context.getContent取得
 * Content中的内容
 * 1.contacts：可以是邮件和手机号码
 * 2.sql:有该字段从数据库查询
 * 3.ds：与sql配合指定数据源
 * 4.msg：没有指定sql的时候直接发送的消息
 * 5.subject：发送邮件的时候的标题
 * 
 * 6.proc : 依赖后台批次表的程序
 * 
 * @author Mei Kefu
 * @date 2010-2-23
 */
public abstract class PushJob implements Job  {

	private static Logger LOG = Logger.getLogger(PushJob.class);
	
	private static long sleepTime=1200000;
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void execute(JobExecutionContext context) throws JobExecutionException {
		
		int count=60;
		Object object = context.getJobDetail().getJobDataMap().get("jsonObject");
		Map result = null;
		
		boolean isProcDone=true;
		
		if(object instanceof Map){
			result = (Map)object;
			
			String proc = (String)result.get("proc");
			
			String[] dates = calDate();
			
			if(proc!=null && proc.length()>0){
				
				while(!isProcDone && count>0){
					
					SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list");
				
					List list = (List) sqlQuery.query("select case when length(etl_cycle_id)=8 then replace(substr(char(date(insert(etl_cycle_id||'-01',5,0,'-')) - 1 month),1,7),'-','') else replace(substr(char(date(insert(etl_cycle_id||'-01',5,0,'-')) - 1 month),1,7),'-','') end from nwh.dp_etl_com end where etl_progname='"+proc+"'");
					
					if(list !=null && list.size()>0){
						
						String[] line = (String[])list.get(0);
						String date = line[0];
						if ((date.length()==6 && date.equalsIgnoreCase(dates[1])) || (date.length()==8 && date.equalsIgnoreCase(dates[0]))){
							isProcDone=true;
						}
					}
					count--;
					try {
						Thread.sleep(sleepTime);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				
			}
			
			String sql=(String)result.get("sql");
			//需要数据库查询
			if(sql!=null && sql.length()>0){
				String ds = (String)result.get("ds");
				
				if("text".equalsIgnoreCase(ds)){
					List list = new ArrayList();
					String content = (String)result.get("sql");
					list.add(new String[]{content});
					push(list,result);
				}else{
					sql=sql.replaceAll("@month", dates[1]).replaceAll("@date", dates[0]);
					LOG.debug("sql:"+sql);
					SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list",ds);
					
					while(count>0){
						List list = (List)sqlQuery.query(sql);
						
						if(list.size()>0){
							push(list,result);
							break;
						}else{
							count--;
							try {
								Thread.sleep(sleepTime);
							} catch (InterruptedException e) {
								e.printStackTrace();
							}
						}
					}
				}
			}else{
				List list = new ArrayList();
				String content = (String)result.get("msg");
				list.add(new String[]{content});
				push(list,result);
			}
		}else{
			LOG.error("没有相关的推送数据");
		}
	}
	
	@SuppressWarnings("rawtypes")
	public abstract void push(List list,Map context);
	
	public String[] calDate(){
		String[] result = new String[2];
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar calendar = GregorianCalendar.getInstance();
		
		calendar.add(Calendar.DATE, -1);
		
		result[0]=sdf.format(calendar.getTime());
		
		calendar.add(Calendar.DATE, -2);
		calendar.add(Calendar.MONTH, -1);
		result[1]=sdf.format(calendar.getTime()).substring(0, 6);
		
		return result;
	}
}
