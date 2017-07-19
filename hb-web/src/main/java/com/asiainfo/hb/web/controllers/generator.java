package com.asiainfo.hb.web.controllers;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.web.util.MD5Utils;
/**
 * 用于密码加密
 * @author Administrator
 *
 */
@Controller
public class generator {
	private static Logger LOG = Logger.getLogger(generator.class);
	@RequestMapping(value="/Password") 
	public @ResponseBody List<String> Password(HttpServletRequest request){
		String path="D:\\1.txt";
		generator gt=new generator();
		return gt.md5password(gt.user(path));
	}
	//将读取的用户都放在list 传进来的是路径 注意写法 如D:\\1.txt文件每一个用户换一行
	@SuppressWarnings("unused")
	public List<String> user(String path){
		List<String > list=new ArrayList<String>();
		FileInputStream fis = null;
		InputStreamReader isr = null;
		BufferedReader br = null; //用于包装InputStreamReader,提高处理性能。因为BufferedReader有缓冲的，而InputStreamReader没有。
		String str = "";
		String str1 = "";
		try {
			fis = new FileInputStream("D:\\1.txt");
			isr = new InputStreamReader(fis);// InputStreamReader 是字节流通向字符流的桥梁,
			br = new BufferedReader(isr);// 从字符输入流中读取文件中的内容,封装了一个new InputStreamReader的对象
			try {
				while ((str = br.readLine()) != null) {
					    str1 += str + "\n";
					    list.add(str);
				}
				
			} catch (IOException e) {
				LOG.info("找不到指定文件");
				e.printStackTrace();
			}
		} catch (FileNotFoundException e) {
			LOG.info("读取文件失败");
			e.printStackTrace();
		}finally {
			 try {
				// 关闭的时候最好按照先后顺序关闭最后开的先关闭所以先关s,再关n,最后关m
				br.close();
				isr.close();
			    fis.close();
			} catch (IOException e) {
				
				e.printStackTrace();
			}
		     
		}
		return list;
		
	}
	//加密处理 本处理使用md5进行加密、
	public List<String> md5password(List<String> list){
		MD5Utils md5=new MD5Utils();
		List<String > listpass=new ArrayList<String>();
		for(int i=0;i<list.size();i++){
			String a=list.get(i).toString()+"Jfqt@2017";
			String sql="update FPF_USER_USER set pwd='"+md5.md5Encode(a)+"' where userid ='"+list.get(i)+"'";
			listpass.add(sql);
		}
		return listpass;
		
	}
	public static void main(String[] args) {
		String path="D:\\1.txt";
		generator gt=new generator();
		gt.md5password(gt.user(path));
	}
}
