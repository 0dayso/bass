/*
 * 创建日期 2006-3-22
 *
 * 
 * 
 */
package bass.message;

import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author wangbt
 * 
 *         
 * 
 */
public class WriteLog {

	public WriteLog() {
		try {
			File f = new File("log/", "sendmessage.log");
			if (!f.exists()) {
				f.createNewFile();
			}
			FileOutputStream err = new FileOutputStream(f, true);
			PrintStream errPrintStream = new PrintStream(err);
			System.err.close();
			System.setErr(errPrintStream);
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public static void log(String logs) {
		SimpleDateFormat myDateformat = new SimpleDateFormat("yyyy-mm-dd HH:mm:ss");
		StringBuffer myLog = new StringBuffer();
		myLog.append(myDateformat.format(new Date()).toString());
		myLog.append(" 发送至短信网关信息 >> ");
		myLog.append(logs);
		System.err.println(myLog);
	}

	@SuppressWarnings("static-access")
	public static void main(String[] args) {
		WriteLog ss = new WriteLog();
		ss.log("这是个测试程序");
		System.out.println("ddd");
	}
}
