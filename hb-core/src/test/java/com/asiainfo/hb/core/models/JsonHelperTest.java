/**
 * 
 */
package com.asiainfo.hb.core.models;

import java.util.List;
import java.util.Map;

import org.junit.Assert;
import org.junit.Test;

/**
 * @author Mei Kefu
 *
 */
public class JsonHelperTest {
	@SuppressWarnings({ "rawtypes" })
	@Test
	public void test(){
		
		String str="{params:{command:'update',table:'MD.DEVREQ',key:'REQCODE',records:[{REQCODE:'R010010',REQNAME:''},{REQCODE:'R010010',REQNAME:''}]}}";
		Map data = (Map)JsonHelper.getInstance().read(str);	
		System.out.println(JsonHelper.getInstance().write(data));
		
		
		Assert.assertTrue(data.containsKey("params"));
		
		String str1 = "[{id:11,name:'123',date:'2011-9-20 12:00:00.0'},{id:12,name:'456',date:'2011-7-12 12:00:00.0'}]";
		
		List list = (List)JsonHelper.getInstance().read(str1);	
		
		Assert.assertEquals(2, list.size());
		
		
		
	}
}
