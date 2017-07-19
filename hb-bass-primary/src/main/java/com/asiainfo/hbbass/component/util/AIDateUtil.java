package com.asiainfo.hbbass.component.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
/**
 * 日期帮助�?
 *
 */
public class AIDateUtil {
	
	private static Date date;
	
    /**
     * 按指定格式获取当前时�?
     * @param dateFormat "yyyy-MM-dd","yyyyMMdd","yyyy-MM-dd"
     * @return
     */
    public static String getDate(String dateFormat){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	date = new Date();
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	String strTime = sdf.format(date);
    	try {
			d = sdf.parse(strTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	return sdf.format(c.getTime());
    }
    
    /**
     * 按指定格式个指定年月日获得日�?
     * @param dateFormat "yyyy-MM-dd","yyyyMMdd","yyyy-MM-dd"
     * @param yearNum 相差几年,正数为当前日年之后，负数为当前年之前�?0为当前年
     * @param monthNum 相差几月,正数为当前月之后，负数为当前月之前，0为当前月
     * @param dayNum 相差几日,正数为当前日之后，负数为当前日之前，0为当前日
     * @return
     */
    public static String getDate(String dateFormat,int yearNum,int monthNum,int dayNum){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	date = new Date();
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	String strTime = sdf.format(date);
    	try {
			d = sdf.parse(strTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	c.add(Calendar.YEAR, yearNum);
    	c.add(Calendar.MONTH, monthNum);
    	c.add(Calendar.DATE, dayNum);
    	return sdf.format(c.getTime());
    }
    
    /**
     * 指定日期，获取特定时�?
     * @param dateFormat "yyyy-MM-dd","yyyyMMdd","yyyy-MM-dd"
     * @param date 指定日期，必须跟指定格式相同
     * @param yearNum 相差几年,正数为当前日年之后，负数为当前年之前�?0为当前年
     * @param monthNum 相差几月,正数为当前月之后，负数为当前月之前，0为当前月
     * @param dayNum 相差几日,正数为当前日之后，负数为当前日之前，0为当前日
     * @return
     */
    public static String getDate(String dateFormat,String date,int yearNum,int monthNum,int dayNum){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	try {
			d = sdf.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	c.add(Calendar.YEAR, yearNum);
    	c.add(Calendar.MONTH, monthNum);
    	c.add(Calendar.DATE, dayNum);
    	return sdf.format(c.getTime());
    }
    
    /**
     * 按指定格式获取当前日期相差N天的日期
     * @param dateFormat "yyyy-MM-dd","yyyyMMdd","yyyy-MM-dd"
     * @param dayNum 正数为当前日之后，负数为当前日之前，0为当前日
     * @return
     */
    public static String getDay(String dateFormat,int dayNum){
    	String temp = AIDateUtil.getDate(dateFormat,0, 0, dayNum);
    	return temp;
    }
    
    /**
     * 
     * @param dateFormat "yyyy-MM-dd","yyyyMMdd","yyyy-MM-dd"
     * @param date 指定日期，必须跟指定格式相同
     * @param dayNum 正数为指定日期日之后，负数为指定日期日之前，0为指定日期日
     * @return
     */
    public static String getDay(String dateFormat,String date,int dayNum){
    	String temp = AIDateUtil.getDate(dateFormat,date,0, 0, dayNum);
    	return temp;
    }
    
    
    /**
     * 
     * @param dateFormat "yyyy-MM-dd","yyyyMMdd","yyyy-MM-dd"
     * @param monthNum 正数为当前月之后，负数为当前月之前，0为当前月
     * @return
     */
    public static String getMonth(String dateFormat,int monthNum){
    	String temp = AIDateUtil.getDate(dateFormat,0, monthNum, 0);
    	return temp;
    }
    
    /**
     * 
     * @param dateFormat "yyyy-MM-dd","yyyyMMdd","yyyy-MM-dd"
     * @param date 指定日期，必须跟指定格式相同
     * @param dayNum 正数为指定日期月之后，负数为指定日期月之前，0为指定日期月
     * @return
     */
    public static String getMonth(String dateFormat,String date,int dayNum){
    	String temp = AIDateUtil.getDate(dateFormat,date,0, dayNum, 0);
    	return temp;
    }
    
    /**
     * 
     * @param dateFormat "yyyy-MM-dd","yyyyMMdd","yyyy-MM-dd"
     * @param yearNum 正数为当前年之后，负数为当前年之前，0为当前年
     * @return
     */
    public static String getYear(String dateFormat,int yearNum){
    	String temp = AIDateUtil.getDate(dateFormat,yearNum, 0, 0);
    	return temp;
    }
    
    /**
     * 
     * @param dateFormat "yyyy-MM-dd","yyyyMMdd","yyyy-MM-dd"
     * @param date 指定日期，必须跟指定格式相同
     * @param dayNum 正数为指定日期年之后，负数为指定日期年之前，0为指定日期年
     * @return
     */
    public static String getYear(String dateFormat,String date,int yearNum){
    	String temp = AIDateUtil.getDate(dateFormat,date,yearNum, 0, 0);
    	return temp;
    }
    
    /**
     * 日期格式转换
     * @param date �?要转换的日期
     * @param dateFormatOld 老的日期格式
     * @param dateFormatNew 新的日期格式
     * @return
     */
    public static String getChangeFormat(String date,String dateFormatOld,String dateFormatNew){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	SimpleDateFormat sdf_old = new SimpleDateFormat(dateFormatOld);
    	SimpleDateFormat sdf_new = new SimpleDateFormat(dateFormatNew);
    	try {
			d = sdf_old.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	return sdf_new.format(c.getTime());
    }
    
    /**
     * 两个日期计算日期�?
     * @param dateFormat 日期格式
     * @param date1 第一个日�?
     * @param date2 第二个日�?
     * @return
     */
    @SuppressWarnings("unused")
	public static String getTwoTimeSubtract(String dateFormat,String date1,String date2){
    	Calendar c = Calendar.getInstance();
    	Date d1 = null;
    	Date d2 = null;
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	try {
			d1 = sdf.parse(date1);
			d2 = sdf.parse(date2);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		
		return String.valueOf((d1.getTime() - d2.getTime())/1000/60/60/24);
    }
    
    /**
     * 获取当前日期当周的第�?�?
     * @param dateFormat
     * @return
     */
    public static String getWeekFisrtDay(String dateFormat){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	date = new Date();
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	String strTime = sdf.format(date);
    	try {
			d = sdf.parse(strTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	c.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
    	return sdf.format(c.getTime());
    }
    
    /**
     * 获取当前日期当周的最后一�?
     * @param dateFormat
     * @return
     */
    public static String getWeekLastDay(String dateFormat){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	date = new Date();
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	String strTime = sdf.format(date);
    	try {
			d = sdf.parse(strTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	c.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
    	return sdf.format(c.getTime());
    }
    
    /**
     * 获取指定日期当周第一�?
     * @param dateFormat
     * @param date
     * @return
     */
    public static String getWeekFisrtDay(String dateFormat,String date){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	try {
			d = sdf.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	c.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
    	return sdf.format(c.getTime());
    }
    
    /**
     * 获取指定日期当周�?后一�?
     * @param dateFormat
     * @param date
     * @return
     */
    public static String getWeekLastDay(String dateFormat,String date){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	try {
			d = sdf.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	c.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
    	return sdf.format(c.getTime());
    }
    
    /**
     * 获取指定日期当周第一�?
     * @param dateFormat
     * @param date
     * @return
     */
    public static String getWeekFisrtDayUSA(String dateFormat,String date){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	try {
			d = sdf.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	c.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
    	return sdf.format(c.getTime());
    }
    
    /**
     * 获取指定日期当周�?后一�?
     * @param dateFormat
     * @param date
     * @return
     */
    public static String getWeekLastDayUSA(String dateFormat,String date){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	try {
			d = sdf.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	c.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
    	return sdf.format(c.getTime());
    }
    
    /**
     * 获取当前日期当周的第�?�?
     * @param dateFormat
     * @return
     */
    public static String getWeekFisrtDayUSA(String dateFormat){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	date = new Date();
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	String strTime = sdf.format(date);
    	try {
			d = sdf.parse(strTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	c.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
    	return sdf.format(c.getTime());
    }
    
    /**
     * 获取当前日期当周的最后一�?
     * @param dateFormat
     * @return
     */
    public static String getWeekLastDayUSA(String dateFormat){
    	Calendar c = Calendar.getInstance();
    	Date d = null;
    	date = new Date();
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	String strTime = sdf.format(date);
    	try {
			d = sdf.parse(strTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	c.setTime(d);
    	c.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
    	return sdf.format(c.getTime());
    }
    
    public static int getWeekNumber(){
    	date = new Date();
    	
		Calendar calendar = Calendar.getInstance();

		calendar.setTime(date);
		
		calendar.setMinimalDaysInFirstWeek(4);
		
    	return calendar.get(Calendar.WEEK_OF_YEAR);
    }
    
    public static int getWeekNumber(String dateFormat,String date){
    	Calendar calendar = Calendar.getInstance();
    	Date d = null;
    	SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
    	
    	try {
			d = sdf.parse(date);
		} catch (ParseException e) {
			e.printStackTrace();
		}
    	
		calendar.setTime(d);
		
		calendar.setMinimalDaysInFirstWeek(4);
		
    	return calendar.get(Calendar.WEEK_OF_YEAR);
    }
    
    public static String getLastMDays(int year,int month,int day) {
        int[][] monthDays = {{ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 },{ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }};
        
        Calendar cal1 = Calendar.getInstance();
        
        setCurrentDate(year, month, day, cal1);// indicates 2008/03/31
        
        int leap = isLeapYear(cal1.get(Calendar.YEAR))? 1 : 0;
        int currentYear = cal1.get(Calendar.YEAR);
        int currentMonth = cal1.get(Calendar.MONTH);
        int currentDay = cal1.get(Calendar.DAY_OF_MONTH);
        int lastYear = currentYear;
        int lastMonth = (currentMonth - 1 + 12) % 12;
        int lastDay = monthDays[leap][lastMonth];
        String lastMDay = "";
        if(lastMonth == 11){
            if( currentDay <= lastDay){
                lastMDay = (lastYear - 1) + "-" + ((lastMonth + 1)<10?"0"+(lastMonth + 1):(lastMonth + 1) )+ "-" + ((currentDay<10)?("0"+currentDay):currentDay);
            } else {
                lastMDay = (lastYear - 1) + "-" + ((lastMonth + 1)<10?"0"+(lastMonth + 1):(lastMonth + 1) ) + "-" + ((lastDay<10)?("0"+lastDay):lastDay);
            }
        } else{
            if( currentDay <= lastDay){
                lastMDay = lastYear + "-" + ((lastMonth + 1)<10?"0"+(lastMonth + 1):(lastMonth + 1) ) + "-" + ((currentDay<10)?("0"+currentDay):currentDay);
            } else {
                lastMDay = lastYear + "-" + ((lastMonth + 1)<10?"0"+(lastMonth + 1):(lastMonth + 1) ) + "-" + ((lastDay<10)?("0"+lastDay):lastDay);
            }
        }
        return lastMDay.toString();
    }

    public static boolean isLeapYear(int year) {
        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
            return true;
        }
        return false;
    }
    
    public static void setCurrentDate(int year, int month, int day, Calendar cal){
        cal.set(year, month - 1, day); 
    }
    
    
    public static void main(String[] args) 
    { 
    	
    	System.err.println(AIDateUtil.getWeekNumber("yyyyMMdd","20110717"));
    	/**
    	 * 例一
    	 * 按指定日期格式获取当前日�?
    	 */
    	System.out.println(AIDateUtil.getDate("yyyy-MM-dd"));
    	System.err.println(AIDateUtil.getDate("yyyy-MM"));
    	/**
    	 * 例二
    	 * 按指定日期格式，指定相差年，指定相差约，指定相差日获取日�?
    	 * 例子为：�?"yyyy-MM-dd"格式显示，当前日期前�?年，当前月后�?个月，当前日后两天的日期
    	 * 当前日期�?:2010-11-01,结果�?:2009-12-03
    	 */
    	System.out.println(AIDateUtil.getDate("yyyy-MM-dd",-1,0,0));
    	
    	/**
    	 * 例三
    	 * 按指定日期格式，指定相差日获取日�?
    	 * 当前日期:2010-11-01,结果为：2010-11-03
    	 */
    	System.out.println(AIDateUtil.getDay("yyyy-MM-dd",2));
    	
    	/**
    	 * 例四
    	 * 按指定日期格式，指定相差月获取日�?
    	 * 当前日期:2010/11/01,结果�?:2010/10/01
    	 */
    	System.out.println(AIDateUtil.getMonth("yyyy/MM/dd",-1));
    	
    	/**
    	 * 例五
    	 * 按指定日期格式，指定相差年获取日�?
    	 * 当前日期:20101101,结果�?:20121101
    	 */
    	System.out.println(AIDateUtil.getYear("yyyyMMdd",2));
    	
    	/**
    	 * 例六
    	 * 按指定日期格式，指定计算日期，指定相差年，指定相差月，指定相差日获取日期
    	 * 例子为：�?"yyyy-MM-dd"格式显示�?"2010�?11�?1�?"为基�?的，前三年，后一个月，后两天的日�?
    	 * 当前日期:2010-11-01,结果�?:2007-11-03
    	 */
    	System.out.println(AIDateUtil.getDate("yyyy-MM-dd","2010-11-01",-3,1,2));
    	
    	/**
    	 * 例七
    	 * 按指定日期格式，指定计算日期，指定相差日获取日期
    	 * 当前日期:20101101,结果�?:20101102
    	 */
    	System.out.println(AIDateUtil.getDay("yyyyMMdd","20101101",1));
    	
    	/**
    	 * 例八
    	 * 按指定日期格式，指定计算日期，指定相差月获取日期
    	 * 当前日期:2010/11/01,结果�?:2011/01/01
    	 */
    	System.out.println(AIDateUtil.getMonth("yyyy/MM/dd","2010/11/01",2));
    	System.out.println("adsasd"+AIDateUtil.getMonth("yyyyMM","201011",-6));
    	System.err.println(AIDateUtil.getMonth("MM","11",2));
    	/**
    	 * 例九
    	 * 按指定日期格式，指定计算日期，指定相差年获取日期
    	 * 当前日期:2010-11-01,结果�?:2007-11-01
    	 */
    	System.out.println(AIDateUtil.getYear("yyyy-MM-dd","2010-11-01",-3));
    	
    	/**
    	 * 例十
    	 * 根据传入日期，旧的日期格式，新的日期格式，转换格�?
    	 * 旧日期："2010-11-01",新日期："2010/11/01"
    	 */
    	System.out.println(AIDateUtil.getChangeFormat("2010-11-01", "yyyy-MM-dd", "yyyy/MM/dd"));
    	
    	System.err.println(AIDateUtil.getTwoTimeSubtract("yyyy-MM-dd","2010-11-01", "2010-12-15"));
    	
    	System.out.println("====="+AIDateUtil.getWeekNumber("yyyyMMdd","20110721"));
    	System.out.println("====="+AIDateUtil.getLastMDays(2011, 12, 04));
    } 
}
