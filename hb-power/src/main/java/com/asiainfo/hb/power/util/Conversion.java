package com.asiainfo.hb.power.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Conversion {

	public static Date strConvertToDate(String datestr,String dateFormdate) throws ParseException{
		SimpleDateFormat sdf  =   new  SimpleDateFormat(dateFormdate); 
		Date date = sdf.parse(datestr);
		return date;
	}
	
	public static String creteSql(int size){
		String sql = "( ? ";
		if(size>1){
			for(int i = 1;i<size;i++){
				sql = sql+", ? ";
			}
		}
		return sql+")";
	}
	
	public static void main(String[] args) throws ParseException {
		String date =  Conversion.creteSql(3);
		System.out.println(date);
	}
}
