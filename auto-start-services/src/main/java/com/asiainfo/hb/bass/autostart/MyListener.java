package com.asiainfo.hb.bass.autostart;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.log4j.Logger;
import com.asiainfo.hb.bass.autostart.utils.Configuration;
import com.asiainfo.hb.bass.autostart.utils.Constants;

public class MyListener implements ServletContextListener {
	
	private static Logger mLog = Logger.getLogger(MyListener.class);
	
	private Thread myThread;
	
	private String ipAddress;
	private String userName;
	private String password;
	private String checkPath;
	private String cmdPath;
	private String startCmd;
	private int timeOut = 10;
	private int timeInterval = 10;

	public void contextDestroyed(ServletContextEvent arg0) {
		if (myThread != null && myThread.isInterrupted()) {
			myThread.interrupt();
		}
	}

	public void contextInitialized(ServletContextEvent arg0) {
		mLog.info("MyListener启动……");
		
		initServiceInfo();
		
		myThread = new Thread(new Runnable() {
			public void run() {
				int i = 0;
				while (!myThread.isInterrupted()) {
					try {
						Thread.sleep(timeInterval * 1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}

					HttpClient client = new HttpClient();
					GetMethod method = new GetMethod(checkPath);
					client.getHttpConnectionManager().getParams().setSoTimeout(timeOut * 1000);
					try {
						client.executeMethod(method);
						mLog.debug("验证返回状态码：" + method.getStatusCode());
						if(method.getStatusCode() != 200){
							mLog.warn("服务异常，状态码：" + method.getStatusCode());
							restartServer(++i);
						}
					} catch (Exception e) {
						e.printStackTrace();
						mLog.error(e.toString());
						restartServer(++i);
					} finally {
						method.releaseConnection();
					}
				}
			}
		});
		myThread.start();
	}
	
	/**
	 * 初始化服务相关信息
	 */
	private void initServiceInfo(){
		ipAddress = getProperty(Constants.IP_ADDRESS);
		userName = getProperty(Constants.USERNAME);
		password = getProperty(Constants.PASSWORD);
		checkPath = getProperty(Constants.CHECK_PATH);
		cmdPath = getProperty(Constants.CMD_PATH);
		startCmd = getProperty(Constants.START_CMD);
		String timeOutStr = getProperty(Constants.TIME_OUT).trim();
		if(timeOutStr != null && timeOutStr.length()>0){
			timeOut = Integer.valueOf(timeOutStr);
		}

		String timeIntervalStr = getProperty(Constants.TIME_INTERVAL).trim();
		if(timeIntervalStr != null && timeIntervalStr.length()>0){
			timeInterval = Integer.valueOf(timeIntervalStr);
		}
		
		mLog.info("服务相关信息：ipAddress=" + ipAddress + ";userName=" + userName + ";password=" + password
				+ ";checkPath=" + checkPath + ";cmdPath=" + cmdPath + ";startCmd=" + startCmd
				+ ";timeOut=" + timeOut + ";timeInterval=" + timeInterval);
	}
	
	private String getProperty(String key){
		return Configuration.getInstance().getProperty(key);
	}
	
	private void restartServer(int times){
		mLog.info("第" + times + "次出现异常。");
		try {
			try {
				SSHUtil searchPidSSH = new SSHUtil(ipAddress, userName, password);
				String pid = searchPidSSH.exec("ps -ef | grep '" + cmdPath + "'| grep -v grep |awk '{print $2}'\n");
				Thread.sleep(5*1000);
				searchPidSSH.close();

				mLog.info("进程号：" + pid);
				if(pid != null && pid.length()>0){
					pid = pid.replace("\n","").trim();
					SSHUtil killPidSSH = new SSHUtil(ipAddress, userName, password);
					String killPidResp = killPidSSH.runShell("kill -9 " + pid + "\n", "utf-8");
					Thread.sleep(10*1000);
					killPidSSH.close();
					mLog.info("杀进程返回结果:" + killPidResp);
				}
				
			} catch (Exception e1) {
				e1.printStackTrace();
				mLog.error("杀进程出现异常：" + e1.toString());
			}
			
			SSHUtil startupSSH = new SSHUtil(ipAddress, userName, password);
			String startupResp = startupSSH.runShell(startCmd + "\n", "utf-8");
			Thread.sleep(30*1000);
			startupSSH.close();
			mLog.info("启动服务返回结果:" + startupResp);
			
		} catch (Exception e1) {
			e1.printStackTrace();
			mLog.error("重启服务出现异常：" + e1.toString());
		}
	}
	
	
	
}
