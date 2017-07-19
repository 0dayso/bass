package com.asiainfo.hb.core.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 日志打印工具
 * 
 * @author 李志坚
 *
 */
public class LogUtil {

	/**
	 * 获得异常中的堆栈错误信息
	 * 
	 * @param e
	 * @return
	 */
	public static String getExceptionMessage(Exception e) {
		StringWriter sw = null;
		PrintWriter pw = null;
		try {
			sw = new StringWriter();
			pw = new PrintWriter(sw);
			// 将出错的栈信息输出到printWriter中
			e.printStackTrace(pw);
			pw.flush();
			sw.flush();
		} finally {
			if (sw != null) {
				try {
					sw.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
			}
			if (pw != null) {
				pw.close();
			}
		}
		return sw.toString();
	}

	/**
	 * 打印空行
	 * 
	 * @param logger
	 * @param n
	 *            行数
	 */
	public static void println(Logger logger, int n) {
		for (int i = 0; i < n; i++) {
			logger.info("");
		}
	}

	/**
	 * 打印分段日志分隔信息
	 * 
	 * @param logger
	 * @param keyWord
	 *            关键信息
	 * @param flow
	 *            阶段，分为开始，结束等
	 */
	public static void printDivision(Logger logger, String keyWord, String flow) {
		String msg = "";
		String star = "";
		for (int i = 0; i < 50; i++) {
			star += "*";
		}
		msg = star + keyWord + "_" + flow + star;
		logger.info(msg);
	}

	public static void printBegin(Logger logger, String keyWord) {
		String msg = "";
		String star = "";
		for (int i = 0; i < 50; i++) {
			star += "*";
		}
		msg = star + keyWord + "_" + "开始" + star;
		LogUtil.println(logger, 3);
		logger.info(msg);
	}

	public static void printEnd(Logger logger, String keyWord) {
		String msg = "";
		String star = "";
		for (int i = 0; i < 50; i++) {
			star += "*";
		}
		msg = star + keyWord + "_" + "结束" + star;
		logger.info(msg);
		LogUtil.println(logger, 3);
	}

	public static void main(String[] args) {
		Logger logger = LoggerFactory.getLogger(LogUtil.class);
		LogUtil.println(logger, 3);
		LogUtil.printDivision(logger, "查询KPI", "开始");
		LogUtil.println(logger, 10);
		LogUtil.printDivision(logger, "查询KPI", "结束");

		LogUtil.printBegin(logger, "查询KPI");
		LogUtil.printEnd(logger, "查询KPI");
	}

}
