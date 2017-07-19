package com.asiainfo.hb.web.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import com.asiainfo.hb.web.controllers.generator;

@SuppressWarnings("unused")
public class MD5Utils {
	public  String md5Encode(String inStr){  
        MessageDigest md5 = null;  
        try{  
            md5 = MessageDigest.getInstance("MD5");  
        }catch(Exception e){  
            System.out.println(e.toString());  
            e.printStackTrace();  
            return "";  
        }  
        byte[] byteArray = null;  
        try {  
            byteArray = inStr.getBytes("UTF-8");  
        } catch (UnsupportedEncodingException e) {  
            e.printStackTrace();  
        }  
        byte[] md5Bytes = md5.digest(byteArray);  
        StringBuffer hexValue = new StringBuffer();  
        for(int i=0;i<md5Bytes.length;i++){  
            int val = md5Bytes[i] & 0xff;  
            if(val<16){  
                hexValue.append("0");  
            }  
            hexValue.append(Integer.toHexString(val));  
        }  
        return hexValue.toString();  
    }  
//    public static void main(String[] args) {
//    	System.out.println(md5Encode("123").equals("202cb962ac59075b964b07152d234b70"));
//	}
	
}
