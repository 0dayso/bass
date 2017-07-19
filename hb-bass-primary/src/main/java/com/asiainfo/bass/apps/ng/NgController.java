package com.asiainfo.bass.apps.ng;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

@Controller
@RequestMapping(value = "/ng")
@SessionAttributes({ "mvcPath", "contextPath", SessionKeyConstants.USER})
public class NgController {
	
	@Autowired
	private NgService ngService;
	
	@Autowired
	private NgDao ngDao;

	@RequestMapping(method = RequestMethod.GET)
	public String index(@ModelAttribute("user") User user, Model model) {
		List<Map<String,Object>> list = ngDao.getInd();
		if(list!=null && list.size()>0){
			Map<String, Object> map = list.get(0);
			double ind1 = Double.parseDouble(String.valueOf(map.get("IND1")));
			double ind2 = Double.parseDouble(String.valueOf(map.get("IND2")));
			double ind3 = Double.parseDouble(String.valueOf(map.get("IND3")));
			double ind4 = Double.parseDouble(String.valueOf(map.get("IND4")));
			double ind5 = Double.parseDouble(String.valueOf(map.get("IND5")));
			double ind6 = Double.parseDouble(String.valueOf(map.get("IND6")));
			double ind7 = Double.parseDouble(String.valueOf(map.get("IND7")));
			double ind8 = Double.parseDouble(String.valueOf(map.get("IND8")));
			double ind9 = Double.parseDouble(String.valueOf(map.get("IND9")));
			double ind10 = Double.parseDouble(String.valueOf(map.get("IND10")));
			model.addAttribute("ind1",ind1);
			model.addAttribute("ind2",ind2);
			model.addAttribute("ind3",ind3);
			model.addAttribute("ind4",ind4);
			model.addAttribute("ind5",ind5);
			model.addAttribute("ind6",ind6);
			model.addAttribute("ind7",ind7);
			model.addAttribute("ind8",ind8);
			model.addAttribute("ind9",ind9);
			model.addAttribute("ind10",ind10);
		}else{
			model.addAttribute("ind1","0");
			model.addAttribute("ind2","0");
			model.addAttribute("ind3","0");
			model.addAttribute("ind4","0");
			model.addAttribute("ind5","0");
			model.addAttribute("ind6","0");
			model.addAttribute("ind7","0");
			model.addAttribute("ind8","0");
			model.addAttribute("ind9","0");
			model.addAttribute("ind10","0");
		}
		return "ftl/ng/index";
	}
	
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public void addReply(HttpServletResponse response, @ModelAttribute("user") User user, @RequestParam double ind1, @RequestParam double ind2, @RequestParam double ind3, @RequestParam double ind4, @RequestParam double ind5, @RequestParam double ind6, @RequestParam double ind7, @RequestParam double ind8, @RequestParam double ind9, @RequestParam double ind10){
		String result = "修改成功";
		try{
			ngService.save(ind1,ind2,ind3,ind4,ind5,ind6,ind7,ind8,ind9,ind10);
		}catch(Exception e){
			result = "修改失败";
			e.printStackTrace();
		}
		try {
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
