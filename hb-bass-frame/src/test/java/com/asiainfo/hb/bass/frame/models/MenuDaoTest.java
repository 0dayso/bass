/**
 * 
 */
package com.asiainfo.hb.bass.frame.models;

import java.util.List;

import static junit.framework.Assert.*;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * @author zhangds
 * @date 2015年7月23日
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"/conf/spring/*.xml"})
public class MenuDaoTest {

	@Autowired
	MenuDao menuDao;
	
	@Test
	public void getSysMenu(){
		List<MenuBean> list = menuDao.getSysMenu("");
		assertNotNull("菜单为空了!", list);
	}
}
