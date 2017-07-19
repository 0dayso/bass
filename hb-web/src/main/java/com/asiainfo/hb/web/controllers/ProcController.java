package com.asiainfo.hb.web.controllers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Writer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.asiainfo.hb.core.models.Configuration;

/**
 * 
 * @author Mei Kefu
 */
@Controller
public class ProcController {
	@RequestMapping("/procexec")
	public void handleRequest(HttpServletRequest request,HttpServletResponse response) throws Exception {
		System.out.println(".....执行程序.......");
		String procname = request.getParameter("procname"); 
		String taskid = request.getParameter("taskid"); 
		String startstep = request.getParameter("startstep"); 
		String dbname = request.getParameter("dbname"); 
		Writer out = response.getWriter();
		String para ="-f "+procname+" -t "+taskid;
		if(startstep!=null) para+=" -i "+startstep;
		execute(out,para,dbname);
	}
	
	public void execute(Writer out,String para,String dbname) throws IOException{
		String cmdPath  = "";
		try{
			cmdPath = Configuration.getInstance().getPropFromDB("procpath");
		}catch(Exception e){
			e.printStackTrace();
		}
		if(cmdPath==null || "".equals(cmdPath)){
			out.append("无法获取可执行程序,请先在系统配置表中配置参数 :procpath");
			out.flush();
			out.close();
			return;
		};
		String cmd = cmdPath +" \""+ para+"\"";
		out.append("开始执行,执行数据库:"+dbname+",命令:"+cmd);
		Runtime runtime = Runtime.getRuntime();
		
		Process process = runtime.exec(cmd);
		
		PrintThread thread1 = new PrintThread(out, new BufferedReader(new InputStreamReader(process.getInputStream(),"gbk")));
		PrintThread thread2 = new PrintThread(out, new BufferedReader(new InputStreamReader(process.getErrorStream(),"gbk")));
		
		new Thread(thread1).start();
		new Thread(thread2).start();
		try {
			if(process.waitFor()==0){
				process.destroy();
				out.append("<br/><br/>------   测试执行完毕!  -------");
				out.close();
			}
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
}

class PrintThread implements Runnable {

	Writer out;
	BufferedReader br;

	public PrintThread(Writer out, BufferedReader br) {
		super();
		this.out = out;
		this.br = br;
	}

	@Override
	public void run() {
		String line = null;
		try {
			while ((line = br.readLine()) != null) {
				out.append(line).append("<br/>");
				out.append("<script>scrollBy(0,999999)</script>");
				out.flush();
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
 