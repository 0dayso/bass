/**
 * 
 */
package com.asiainfo.hb.bass.role.adaptation.service;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.asiainfo.hb.bass.role.adaptation.models.AdapMenu;

/**
 * @author zhangds
 * @date 2015年11月15日
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
public class AdapMenuServiceTest {
	@Autowired
	AdapMenuService adapMService;
	
	@Test
	public void getOneMenus(){
		String menuId = "2000000";
		AdapMenu aMenu = adapMService.getOneMenus(menuId);
		Assert.assertNotNull(aMenu);
		menuId = "2110000";
		aMenu = adapMService.getCurrentMenu(menuId);
		Assert.assertNotNull(aMenu);
		Assert.assertNotNull(aMenu.getChildren());
		aMenu = adapMService.getAdapMenuAndKpiDate(aMenu, "HB", "20151012", "Channle", "yymmdd");
		
	}
}
