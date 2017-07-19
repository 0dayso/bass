/*
 * Copyright (c) 2009 AsiaInfo Software Foundation. All Rights Reserved.
 * This software is published under the terms of the AsiaInfo Software
 * License version 1.0, a copy of which has been included with this
 * distribution in the LICENSE.txt file.
 */

package com.asiainfo.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

import org.apache.commons.lang.time.DateUtils;

/**
 * <p>Title: 日期、时间工具类</p>
 * <p>Date: Feb 19, 2009 3:02:49 PM </p>
 * @author 李志坚
 * @version 1.0
 */
public class DateUtil extends DateUtils {

	private static String defaultFormat = "yyyy-MM-dd";

	/**
	 * 查询系统当前时间，时区为中国标准时间,返回类型为String
	 * @param format 格式如：yyyy-MM-dd HH:mm:ss
	 * @return 返回类型为String
	 */
	public static String getCurrentDate(String format) {
		SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.SIMPLIFIED_CHINESE);
		Date date = new Date();
		String currentDate = sdf.format(date);
		return currentDate;
	}

	/**
	 * 返回前一天日期
	 * @param format
	 * @return
	 */
	public static String getPreDate(String format) {
		if (format == null) {
			format = "yyyy-MM-dd";
		}
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.DATE, -1);
		SimpleDateFormat sdf = new SimpleDateFormat(format, Locale.SIMPLIFIED_CHINESE);
		return sdf.format(calendar.getTime());
	}

	/**
	 * 将String类型的日期转换成指定格式的Date类型
	 * 
	 * @param dateOfString
	 *            传入的时间字符串，例如2009-10-22 09:43:36
	 * @param targetFormat
	 *            目标日期格式，例如yyyy-MM-dd HH:mm:ss
	 * @return 以传入的格式返回日期类型(如yyyy-MM-dd HH:mm:ss格式)
	 */
	public static Date parseDate(String dateOfString, String targetFormat) {
		if (dateOfString == null || dateOfString.trim().equals("")) {
			return null;
		}
		if (dateOfString != null && dateOfString.length() > 19) {
			dateOfString = dateOfString.substring(0, 19);
		}
		String format = DateUtil.getPattern(targetFormat);
		if (format == null) {
			return null;
		}
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
		Date date = null;
		try {
			date = simpleDateFormat.parse(dateOfString);
			simpleDateFormat = new SimpleDateFormat(targetFormat);
			date = simpleDateFormat.parse(simpleDateFormat.format(date));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return date;
	}

	/**
	 * 将一个日期字符串转化成另一种日期格式的字符串
	 * @param dateOfString 传入的日期字符串，例如2009-10-22 09:43:36
	 * @param targetFormat 目标日期格式，例如yyyy-MM-dd HH:mm:ss
	 * @return
	 */
	public static String parseDateToString(String dateOfString, String targetFormat) {
		if (dateOfString == null || dateOfString.trim().equals("")) {
			return null;
		}
		if (dateOfString != null && dateOfString.length() > 19) {
			dateOfString = dateOfString.substring(0, 19);
		}
		String format = DateUtil.getPattern(dateOfString);
		if (format == null) {
			return null;
		}
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
		Date date = null;
		try {
			date = simpleDateFormat.parse(dateOfString);
			simpleDateFormat = new SimpleDateFormat(targetFormat);
			return simpleDateFormat.format(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 将Date类型的日期转换成String类型
	 * 
	 * @param date
	 *            传入的时间
	 * @param format
	 *            格式，例如yyyy-MM-dd
	 * @return 以"yyyy-MM-dd"格式返回日期类型
	 */
	public static String date2String(java.util.Date date, String format) {
		if (date == null) {
			return null;
		}
		if (format == null || "".equals(format)) {
			format = defaultFormat;
		}
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
		String dateOfStr = "";
		try {
			dateOfStr = simpleDateFormat.format(date);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dateOfStr;
	}

	/**
	 * 传入两个日期，计算这两个日期的差值天数(日期值小的参数在前)
	 * 
	 * @param startDate
	 *            前一个日期值
	 * @param endDate
	 *            后一个日期值
	 * @return 传入两个日期，计算这两个日期的差值天数(日期值小的参数在前)
	 */
	public static int getIntervalDays(java.util.Date startDate, java.util.Date endDate) {
		long startdate = startDate.getTime();
		long enddate = endDate.getTime();
		long interval = enddate - startdate;
		int intervaldays = (int) (interval / (1000 * 60 * 60 * 24));
		return intervaldays;
	}
	
	/**
	 * 传入两个日期，计算这两个日期的差值分钟数(日期值小的参数在前)
	 * 
	 * @param startDate
	 *            前一个日期值
	 * @param endDate
	 *            后一个日期值
	 * @return 传入两个日期，计算这两个日期的差值分钟数(日期值小的参数在前)
	 */
	public static int getIntervalMins(java.util.Date startDate, java.util.Date endDate) {
		long startdate = startDate.getTime();
		long enddate = endDate.getTime();
		long interval = enddate - startdate;
		int intervalMins = (int) (interval / (1000 * 60));
		return intervalMins;
	}


	/**
	 * 根据与一个日期的相差天数得到一个新的日期
	 * 
	 * @param date
	 * @param intervalDays
	 * @return
	 */
	public static java.util.Date getDateByIntervalDays(Date date, int intervalDays) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DAY_OF_YEAR, intervalDays);
		return new java.util.Date(calendar.getTime().getTime());
	}

	/**
	 * 根据与一个日期的相差月数得到一个新的日期
	 * 
	 * @param date
	 * @param intervalDays
	 * @return
	 */
	public static java.util.Date getDateByIntervalMonths(Date date, int intervalMonths) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.MONTH, intervalMonths);
		return new java.util.Date(calendar.getTime().getTime());
	}

	/**
	 * 根据与一个日期的相差年数得到一个新的日期
	 * 
	 * @param date
	 * @param intervalDays
	 * @return
	 */
	public static java.util.Date getDateByIntervalYears(Date date, int intervalYears) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.YEAR, intervalYears);
		return new java.util.Date(calendar.getTime().getTime());
	}

	/**
	 * 获得当前日期的上一个月，返回格式如"200808"
	 * 
	 * @return
	 */
	public static String getLastMonth() {
		Date date = new Date();
		String year = DateUtil.getYear(date);
		String month = DateUtil.getMonth(date);
		String lastYear = String.valueOf(Integer.valueOf(year).intValue() - 1);
		String lastMonth = String.valueOf(Integer.valueOf(month).intValue() - 1);
		if (lastMonth.length() == 1) {
			lastMonth = "0" + lastMonth;
		}
		if ("01".equals(month)) {
			return (lastYear + "12");
		} else {
			return (year + lastMonth);
		}
	}
	
	/**
	 * 获得当前日期的上一个月，返回格式如"200808"
	 * 
	 * @return
	 */
	public static String getLastDay() {
		Date date=new Date();//取时间
		Calendar calendar = new GregorianCalendar();
		calendar.setTime(date);
		calendar.add(Calendar.DATE,1);//把日期往后增加一天.整数往后推,负数往前移动
		date=calendar.getTime(); //这个时间就是日期往后推一天的结果 
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
		String dateString = formatter.format(date);
		return dateString;
	}

	/**
	 * 获得当前日期的上一个月，返回格式如"2009-07"
	 * 
	 * @return
	 */
	public static String getLastMonth2() {
		Date date = new Date();
		String opTime = "";
		String year = DateUtil.getYear(date);
		String month = DateUtil.getMonth(date);
		String lastYear = String.valueOf(Integer.valueOf(year).intValue() - 1);
		String lastMonth = String.valueOf(Integer.valueOf(month).intValue() - 1);
		if (lastMonth.length() == 1) {
			lastMonth = "0" + lastMonth;
		}
		if ("01".equals(month)) {
			opTime = lastYear + "-12";
		} else {
			opTime = year + "-" + lastMonth;
		}
		return opTime;
	}

	/**
	 * 由年份和月份构造日期对象
	 * 
	 * @return Date
	 */
	public static Date getDate(int year, int month) {
		// 如果年份或月份小于1，那么显然是不可能的，返回 null
		if (year < 1 || month < 1)
			return null;
		Date date = null;
		SimpleDateFormat yearMonthFormat = new SimpleDateFormat("yyyy-MM");
		// 按照 yearMonthFormat 定义的格式把参数传化成字符串
		String dateStr = new Integer(year).toString() + "-" + new Integer(month).toString();
		try {
			// 把字符串类型的时间转化成日期类型
			date = yearMonthFormat.parse(dateStr);
		} catch (ParseException e) {
			date = null;
		}
		return date;
	}

	/**
	 * 由年份、月份、日期构造日期对象
	 * 
	 * @param year
	 *            the year like 1900.
	 * @param month
	 *            the month between 1-12.
	 * @param day
	 *            the day of the month between 1-31.
	 * @return Date
	 */
	public static Date getDate(int year, int month, int day) {
		// 如果年份、月份或日期小于1，那么显然是不可能的，返回 null
		if (year < 1 || month < 1 || day < 1)
			return null;
		Date date = null;
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		// 按照 dateFormat 定义的格式把参数传化成字符串
		String dateStr = new Integer(year).toString() + "-" + new Integer(month).toString() + "-" + new Integer(day).toString();
		try {
			// 把字符串类型的时间转化成日期类型
			date = dateFormat.parse(dateStr);
		} catch (ParseException e) {
			date = null;
		}
		return date;
	}

	/**
	 * 获得某月最后一天的日期
	 * 
	 * @param date
	 * @return
	 */
	public static Date getLastDayDateOfTheMonth(Date date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
//		final int lastDay = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
//		Date lastDate = calendar.getTime();
//		lastDate.setDate(lastDay);
		calendar.add(Calendar.MONTH, 1);    //加一个月
        calendar.set(Calendar.DATE, 1);     //设置为该月第一天
        calendar.add(Calendar.DATE, -1);    //再减一天即为上个月最后一天
		return calendar.getTime();
	}

	/**
	 * 获得某月的天数
	 * 
	 * @param dateOfString
	 * @return
	 */
	public static int getLastDayOfTheMonth(String dateOfString) {
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat yearMonthFormat = new SimpleDateFormat("yyyy-MM");
		Date date = null;
		try {
			date = yearMonthFormat.parse(dateOfString);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		calendar.setTime(date);
		final int lastDay = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		return lastDay;
	}

	/**
	 * 获得某日期的年份
	 * 
	 * @param date
	 * @return
	 */
	public static String getYear(Date date) {
		if (null == date) {
			return null;
		}
		SimpleDateFormat yearFormat = new SimpleDateFormat("yyyy");
		return yearFormat.format(date);
	}

	/**
	 * 获得某日期的月份
	 * 
	 * @param date
	 * @return
	 */
	public static String getMonth(Date date) {
		if (null == date) {
			return null;
		}
		SimpleDateFormat yearFormat = new SimpleDateFormat("MM");
		return yearFormat.format(date);
	}

	/**
	 * 获得某日期的年份月份
	 * 
	 * @param date
	 * @return
	 */
	public static String getYearMonth(Date date) {
		if (null == date) {
			return null;
		}
		SimpleDateFormat yearFormat = new SimpleDateFormat("yyyyMM");
		return yearFormat.format(date);
	}

	/**
	 * 获得某日期是几号
	 * 
	 * @param date
	 * @return
	 */
	public static String getDay(Date date) {
		if (null == date) {
			return null;
		}
		SimpleDateFormat yearFormat = new SimpleDateFormat("dd");
		return yearFormat.format(date);
	}

	/**
	 * 取得传入的日期字符串的日期格式
	 * @param dateOfString 传入的日期字符串
	 * @return
	 */
	public static String getPattern(String dateOfString) {
		if (dateOfString == null) {
			return null;
		}
		if (dateOfString.matches("[1-9][0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9]")) {
			return "yyyy-MM-dd";
		}
		if (dateOfString.matches("[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]")) {
			return "yyyyMMdd";
		}
		if (dateOfString.matches("[1-9][0-9][0-9][0-9][-][0-9][0-9]")) {
			return "yyyy-MM";
		}
		if (dateOfString.matches("[1-9][0-9][0-9][0-9][0-9][0-9]")) {
			return "yyyyMM";
		}
		if (dateOfString.matches("[1-9][0-9][0-9][0-9]")) {
			return "yyyy";
		}
		if (dateOfString.matches("[1-9][0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9][\\s][0-9][0-9][:][0-9][0-9][:][0-9][0-9]")) {
			return "yyyy-MM-dd HH:mm:ss";
		}
		if (dateOfString.matches("[1-9][0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9][\\s][0-9][0-9][-][0-9][0-9][-][0-9][0-9]")) {
			return "yyyy-MM-dd HH-mm-ss";
		}
		return null;
	}

	//========================================add by wangjunrui=================================
	// 取得某个时间前n天,格式为yyyy-mm-dd
	public static String getStringBeforeNDay(String str, int n) {
		Calendar ca = parseStringToCalendar(str);
		if (ca == null) {
			return null;
		}
		ca.add(Calendar.DATE, -n);
		String strDate = ca.get(Calendar.YEAR) + "-";
		int intMonth = ca.get(Calendar.MONTH) + 1;
		if (intMonth < 10) {
			strDate += "0" + intMonth + "-";
		} else {
			strDate += intMonth + "-";
		}
		int intDay = ca.get(Calendar.DATE);
		if (intDay < 10) {
			strDate += "0" + intDay;
		} else {
			strDate += intDay;
		}
		return strDate;
	}

	//取得某个时间后n天,格式为yyyy-mm-dd
	public static String getStringAfterNDay(String str, int n) {
		Calendar ca = parseStringToCalendar(str);
		if (ca == null) {
			return null;
		}
		ca.add(Calendar.DATE, n);
		String strDate = ca.get(Calendar.YEAR) + "-";
		int intMonth = ca.get(Calendar.MONTH) + 1;
		if (intMonth < 10) {
			strDate += "0" + intMonth + "-";
		} else {
			strDate += intMonth + "-";
		}
		int intDay = ca.get(Calendar.DATE);
		if (intDay < 10) {
			strDate += "0" + intDay;
		} else {
			strDate += intDay;
		}
		return strDate;
	}

	//将一个日期字符串转化成Calendar
	// 字符串格式为yyyy-MM-dd
	public static Calendar parseStringToCalendar(String strDate) {
		java.util.Date date = parseStringToUtilDate(strDate);
		if (date == null) {
			return null;
		}
		Calendar ca = Calendar.getInstance();
		ca.setTime(date);
		return ca;
	}

	//将一个日期字符串转化成java.util.Date日期
	// 字符串格式为yyyy-MM-dd
	public static java.util.Date parseStringToUtilDate(String strDate) {

		java.util.Date date = null;
		try {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			date = df.parse(strDate);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return date;
	}
	
	//======================================add malinfei======================================================
	/**
	 * 
	 * @param date     时间字符串
	 * @param  n       对date 月份的操作月数  为正数 就是向后加N个月   为负数就是向前+n个月
	 * @return  返回月份格式为yyyyMM
	 */
	@SuppressWarnings("null")
	public static String getStringOperMonth(String date, int n){
		if(date==null&&date.equals("")){
			return null;
		}
		date =date.replaceAll("-", "");
		StringBuffer sb = new StringBuffer(date);
		sb.insert(4,"-");
		date = date.length()==6?sb.append("-01").toString():sb.insert(7, "-").toString();
		Calendar calendar =parseStringToCalendar(date);
		calendar.add(Calendar.MONTH, n);  
		Date  theDate = calendar.getTime();   
		String  time = new SimpleDateFormat("yyyyMM").format(theDate); 
		return time;
	}
	
	/**
	 * 日期值小的参数在前
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public static int getIntervalMonths(String startDate, String endDate){
		startDate =startDate.replaceAll("-", "");
		StringBuffer sb = new StringBuffer(startDate);
		sb.insert(4,"-");
		startDate = startDate.length()==6?sb.append("-01").toString():sb.insert(7, "-").toString();
		endDate =endDate.replaceAll("-", "");
		StringBuffer sb1 = new StringBuffer(endDate);
		sb1.insert(4,"-");
		endDate = endDate.length()==6?sb1.append("-01").toString():sb1.insert(7, "-").toString();

		Date st = parseStringToUtilDate(startDate);
		Date et = parseStringToUtilDate(endDate);
		
		String sy= getYear(st);
		String ey = getYear(et);
		 
		 int MonthByYear = 0;
		 int reVal = Integer.valueOf(getMonth(et)).intValue()-Integer.valueOf(getMonth(st)).intValue();
		 
		 if(!sy.equals("ey")){
			 MonthByYear = (Integer.valueOf(ey).intValue()-Integer.valueOf(sy).intValue())*12;
		 }
		 return MonthByYear+reVal;
	}
	
	
	/**
	 * @param args
	 */
	@SuppressWarnings("unused")
	public static void main(String[] args) {
//		System.out.println("1:" + DateUtil.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
//		System.out.println("2:" + DateUtil.date2String(new Date(), "yyyy-MM-dd HH:mm:ss"));
//		System.out.println("3:" + DateUtil.parseDate("2009-02-18 15:10:09", "yyyyMM"));
//		System.out.println("4:" + DateUtil.parseDateToString("2009-12-03", "yyyyMM"));
//		System.out.println("----"+getStringOperMonth("20080312",-3));
//		System.out.println("----"+getIntervalDays(DateUtil.parseStringToUtilDate("2009-08-03"),DateUtil.parseStringToUtilDate("2009-08-07")));
		Date date=new Date();
		String s="2017-06-12";
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		try {
			date=sdf.parse(s);
		} catch (ParseException e) {
			
			e.printStackTrace();
		}
		System.out.println(getLastDayDateOfTheMonth(date));
		long startdate = DateUtil.parseStringToUtilDate("2009-06-01").getTime();
		long enddate = DateUtil.parseStringToUtilDate("2009-08-01").getTime();
		
		
		System.out.println("--------"+getIntervalMonths("2008-09","2009-12"));
		//System.out.println(DateUtil.getIntervalDays(DateUtil.parseDate("2009-05-30", "yyyy-MM-dd HH:mm:ss"),DateUtil.parseDate("2009-07-30", "yyyy-MM-dd HH:mm:ss")));
	}

}