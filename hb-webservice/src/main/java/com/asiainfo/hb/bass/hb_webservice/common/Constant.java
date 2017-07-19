package com.asiainfo.hb.bass.hb_webservice.common;

import java.text.SimpleDateFormat;
import java.util.Date;

public final class Constant {

	/**
	 * WebService命名空间
	 */
	public static final String TARGET_NAMESPACE_JF = "http://www.asiainfo-linkage.com/jfxt2017";
	
	public static String getCurrentDate() {
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return f.format(new Date());
	}
	
}
