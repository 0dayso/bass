package com.asiainfo.hb.web.models;

import static org.junit.Assert.*;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@ContextConfiguration(locations={"/conf/spring/*.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class LoginServiceTest {
	
	@Autowired
	LoginService loginService;
	
	@Test
	public void testSuccess(){
		
		String userId="meikefu";
		String originPwd = "let me pass";
		String areacode = "";
		String ipAddr = "123";
		String sessionUserStr = "user";
		MockHttpServletResponse response = new MockHttpServletResponse();
		MockHttpSession session = new MockHttpSession();
		
		LoginStateVo loginStateVo= loginService.login(userId, originPwd, areacode, ipAddr, sessionUserStr, session,response);
		
		assertEquals(true, loginStateVo.isSuccess());
		assertEquals("登录成功", loginStateVo.getMsg());
		
		assertEquals(userId,((User)session.getAttribute(sessionUserStr)).getId());
	}
	
	@Test
	public void testFaild(){
		
		String userId="meikefu";
		String originPwd = "abcd";
		String areacode = "";
		String ipAddr = "123";
		String sessionUserStr = "user";
		MockHttpServletResponse response = new MockHttpServletResponse();
		MockHttpSession session = new MockHttpSession();
		
		LoginStateVo loginStateVo= loginService.login(userId, originPwd, areacode, ipAddr, sessionUserStr, session,response);
		
		assertEquals(false, loginStateVo.isSuccess());
		assertEquals("密码不正确", loginStateVo.getMsg());
		
		assertNull(session.getAttribute(sessionUserStr));
	}
}
