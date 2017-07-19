package com.asiainfo.util;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

/**
 * 
 * @author  LiZhijian
 * @since   1.0
 * @version 1.0
 */
public class ExcelUtil {

	/**
	 * 将1~25*26间的整数转化为excel列名，比如27转为AA等
	 * @param intNumber
	 * @throws Exception
	 */
	public static String TransColIndexIntToStr(int intNumber) throws Exception {
		if (intNumber < 1)
			intNumber = 1;
		if (intNumber > (25 * 26))
			intNumber = 25 * 26;
		int i = intNumber;
		char[] digits = { 'Z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y' };

		char buf[] = new char[27];
		boolean negative = (i < 0);
		int charPos = 26;

		if (!negative) {
			i = -i;
		}

		while (i <= -26) {
			buf[charPos--] = digits[-(i % 26)];
			i = i / 26;
		}
		buf[charPos] = digits[-i];

		if (negative) {
			buf[--charPos] = '-';
		}

		String result = new String(buf, charPos, (27 - charPos));

		if (result.indexOf('Z') != -1) {
			if (result.charAt(0) == 'A') {
				result = "Z";
			} else {
				result = (char) (result.charAt(0) - 1) + "Z";
			}
		}
		return result;
	}

	public void downloadExcelFromByteArray(HttpServletResponse response, byte[] bytes, String fileName) {
		try {
			response.setContentType("application/x-msdownload");
			response.setHeader("Content-Disposition", "attachment;" + " filename=" + new String((fileName + ".xls").getBytes(), "ISO-8859-1"));
			OutputStream os = response.getOutputStream();// 取得输出流
			// response.reset();// 清空输出流
			os.write(bytes);
			os.flush();
		} catch (IOException e) {
			throw new RuntimeException("流写入失败");
		}
	}
}
