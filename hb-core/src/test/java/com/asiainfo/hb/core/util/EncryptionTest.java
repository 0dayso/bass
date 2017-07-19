package com.asiainfo.hb.core.util;

import junit.framework.Assert;

import org.junit.Test;

public class EncryptionTest {
	
	@Test
	public void test(){
		Assert.assertEquals("F5A9AAEF50CF6EC5D8AF9B27947F5CC8", Encryption.encrypt("jfqt2011"));
		Assert.assertEquals("jfqt2011",Encryption.decrypt("F5A9AAEF50CF6EC5D8AF9B27947F5CC8"));
		System.out.println(Encryption.encrypt("112"));
		System.out.println(Encryption.decrypt("823F1AC1A67E71E5"));
	}
}
