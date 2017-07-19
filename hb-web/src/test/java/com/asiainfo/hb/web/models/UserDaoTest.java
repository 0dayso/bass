package com.asiainfo.hb.web.models;

import static junit.framework.Assert.*;
import static org.easymock.EasyMock.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.activemq.console.Main;
import org.junit.Test;

import com.asiainfo.hb.core.models.JdbcTemplate;

@SuppressWarnings("unused")
public class UserDaoTest {
	public String timer(String timeStart,String timeEnd){
		 Date date1=new Date();  
//       Date date2=new Date(); 
		 
		 SimpleDateFormat format =  new SimpleDateFormat(" yyyy-MM-dd HH:mm:ss ");  
		 String time=" 1970-01-06 11:45:55 ";//注：改正后这里前后也加了空格  
		 //Date date = format.parse(time);  
		// System.out.print("Format To times:"+date.getTime()); 
//       SimpleDateFormat format=new SimpleDateFormat("yy/MM/dd hh:mm:ss");  
//       try {  
//           date1=format.parse("12/07/20 08:40:28");  
//           date2=format.parse("12/07/20 08:40:15");  
//           long time1=date1.getTime();  
//           long time2=date2.getTime();  
//           long test=Math.abs(time2-time1);  
//           Date result=new Date();  
//           result.setTime(test/1000);  
//           System.out.println(time1);  
//       } catch (ParseException e) {  
//             
//           e.printStackTrace();         }  
		return timeEnd;
	}
}
