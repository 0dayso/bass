package com.asiainfo.hb.core.util;

import junit.framework.Assert;

import org.junit.Test;

public class TaskDateTest {
	
	@Test
	public void testGetTaskID(){
		Assert.assertEquals("201202",TaskDate.getTaskID("201203", "m", -1,"yyyyMMdd"));
		Assert.assertEquals(TaskDate.getTaskID("201203", "m", -1),TaskDate.getTaskID("201203", "m", -1,"yyyyMMdd"));
		Assert.assertEquals("20120325",TaskDate.getTaskID("20120320", "wlast", 0));
	}
	
	@Test
	public void testGetStringToDate(){
		Assert.assertNotNull(TaskDate.getStringToDate("201203", "yyyyMM"));
	}

}
