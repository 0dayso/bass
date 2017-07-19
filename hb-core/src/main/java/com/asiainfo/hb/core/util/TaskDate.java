package com.asiainfo.hb.core.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

/**
*
* @author wqs
* @date 2011-8-30
* 时间参数处理类
*/
public class TaskDate {
	
	public static String getTaskID(String inTaskID,String formatType,Integer addNum){
		return getTaskID(inTaskID,formatType,addNum,"yyyyMMdd");
	}
	
	@SuppressWarnings("deprecation")
	public static String getTaskID(String taskid,String formatType,Integer addNum,String resultFormat){
		  ///format:'d','m','mfirst','mlast'
			String inTaskID =taskid+ "01000000";

			Integer year = Integer.valueOf(inTaskID.substring(0, 4));
			Integer month = Integer.valueOf(inTaskID.substring(4, 6));
			Integer date = Integer.valueOf(inTaskID.substring(6, 8));
			Integer hour = Integer.valueOf(inTaskID.substring(8, 10));
			Integer minute = Integer.valueOf(inTaskID.substring(10, 12));
			Integer second = Integer.valueOf(inTaskID.substring(12, 14));

			if ("mfirst".equals(formatType)) {
				date = 1;
			} else if ("mlast".equals(formatType)) {
				date = 1;
			} else if ("wlast".equals(formatType)){
				Calendar newDate1 = new GregorianCalendar(year, month - 1, date);
				int i = 7 - newDate1.getTime().getDay();
				//System.out.println(i);
				inTaskID = getTaskID(inTaskID,"d",i,resultFormat);
				year = Integer.valueOf(inTaskID.substring(0, 4));
				month = Integer.valueOf(inTaskID.substring(4, 6));
				date = Integer.valueOf(inTaskID.substring(6, 8));
			}
			Calendar newDate = new GregorianCalendar(year, month - 1, date,hour,minute,second);
			if("minute".equals(formatType)){
				newDate.add(Calendar.MINUTE, addNum);
			}else if("h".equals(formatType)){
				newDate.add(Calendar.HOUR_OF_DAY, addNum);
			}else if ("d".equals(formatType)) {
				newDate.add(Calendar.DATE, addNum);
			} else if ("m".equals(formatType)) {
				newDate.add(Calendar.MONTH, +addNum);
			}else if ("y".equals(formatType)) {
				newDate.add(Calendar.YEAR, +addNum);
			} else if ("mfirst".equals(formatType)) {
				newDate.add(Calendar.DATE, addNum);
			} else if ("mlast".equals(formatType)) {
				newDate.add(Calendar.MONTH, 1);
				newDate.add(Calendar.DATE, -1 - addNum);
			}
			// System.out.println("newDate:"+newDate.toString());
			SimpleDateFormat df = new SimpleDateFormat(resultFormat);
			// System.out.println("kkkkkkk:"+newDate.YEAR+","+newDate.MONTH+","+newDate.DAY_OF_MONTH);
            String result=df.format(newDate.getTime());
			if(taskid.length()==6){
				result= result.substring(0, 6);
            }
			// System.out.println("kkk:"+newDate.getTime().getYear()+','+newDate.getTime().getMonth()+','+newDate.getTime().getDate());
			return result;
	  }
	
	public static Date getStringToDate(String dateString,String format){
		try {
			if (dateString != null && format != null){
				SimpleDateFormat df = new SimpleDateFormat(format);
				return df.parse(dateString);
			}
		} catch (ParseException e) {
			
			return null;
		}
		return null;
	}
	
	/**
	 * 查询系统当前时间，时区为中国标准时间,返回类型为String
	 * @param format 格式如：yyyy-MM-dd HH:mm:ss
	 * @return 返回类型为String
	 */
	public static String getCurrentDate(String format) {
		SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.SIMPLIFIED_CHINESE);
		return sdf.format(GregorianCalendar.getInstance().getTime());
	}
}
