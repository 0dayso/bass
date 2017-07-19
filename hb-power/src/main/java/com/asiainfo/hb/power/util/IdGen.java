/*
 * Copyright (c) 2009 AsiaInfo Software Foundation. All Rights Reserved.
 * This software is published under the terms of the AsiaInfo Software
 * License version 1.0, a copy of which has been included with this
 * distribution in the LICENSE.txt file.
 */

package com.asiainfo.hb.power.util;

import java.util.Date;

import org.apache.log4j.Logger;

/**
 * <p>
 * Title:产生ID的工具类
 * </p>
 * <p>
 * Date: Feb 25, 2009 1:50:56 PM
 * </p>
 * 
 * @author 李志坚
 * @version 1.0
 */
@SuppressWarnings("unused")
public class IdGen {

	private static Logger log = Logger.getLogger(IdGen.class);

	private static long suff = 1000000;

	private static int idLength = 18;

	public static synchronized String genId() {

		String id = DateUtil.date2String(new java.util.Date(), "yyyyMMddHHmmssSSS");
		return id + (10 + (int) (Math.random() * 90));
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// System.out.println(IdGen.genId());
		// System.out.println(IdGen.genId());
		for (int i = 0; i < 1000; i++) {
			System.out.println(IdGen.genId());
		}
		for (int i = 0; i < 1000; i++) {
			// System.out.println(IdGen.genId()+(100+(int)(Math.random()*900)));
		}
	}

}
