package com.asiainfo.hb.web.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.web.models.UserDao;

/**
 * 
 * @author Mei Kefu
 * @date 2012-7-19
 */
@Controller
@RequestMapping("/user")
public class UserController {
	
	@Autowired
	UserDao userDao;
	
	@RequestMapping(value="{id}/face",method=RequestMethod.PUT)
	public @ResponseBody Object saveUserFace(@PathVariable String id,@RequestParam String userFace){
		return userDao.saveUserFace(id, userFace);
	}
}

 