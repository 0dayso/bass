package com.asiainfo.hb.bass.log.visit.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.asiainfo.hb.bass.test.dao.FpfReqMapper;
import com.asiainfo.hb.bass.test.model.FpfReq;
import com.asiainfo.hb.bass.test.model.FpfReqExample;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

@Controller
public class TestMabatisController {

	{
		System.out.println(
				"<<<<<<<<<<<<<<<<<<<<<<===============0000000000000000000==============<<<<<<<<<<<<<<<<<<<<<<");
	}
	@Autowired(required = false)
	private FpfReqMapper fpfReqMapper;

	@RequestMapping(value = { "/mybatisPage" })
	@ResponseBody
	public Object page(@RequestParam(value = "page", defaultValue = "1") Integer page) {
		System.out
				.println("<<<<<<<<<<<<<<<<<<<<<<===============111111111111111111==============<<<<<<<<<<<<<<<<<<<<<<");
		FpfReqExample example = new FpfReqExample();
		example.createCriteria().andReqChargeIdIsNotNull();
		PageHelper.startPage(page, 1);
		List<FpfReq> list = fpfReqMapper.selectByExample(example);
		// 获取分页信息
		PageInfo<FpfReq> pageInfo = new PageInfo<FpfReq>(list);
		long total = pageInfo.getTotal(); // 获取总记录数
		System.out.println("<<<<<<<<<<<<<<<<<<<<<<===============111111111111111111==============<<<<<<<<<<<<<<<<<<<<<<total=" + total);
		return list;
	}
}
