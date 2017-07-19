package com.asiainfo.bass.apps.importController;

import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;

import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;


@Controller
@RequestMapping(value = "/import")
@SessionAttributes({SessionKeyConstants.USER , "mvcPath", "contextPath" })
public class ImportController {
	
	private static Logger LOG = Logger.getLogger(ImportController.class);
	
	@Autowired
	private ImportService importService;
	
	@RequestMapping(method = RequestMethod.GET)
	public String logAction(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("currentUser", user.getId());
		return "ftl/telephoneImport/telephoneImport";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "importDate",method = RequestMethod.POST)
	public void importDate(WebRequest request, HttpServletResponse response){
		String ds = request.getParameter("ds");
		List list = importService.getInfo(ds);
		Map map = new HashMap();
		try{
			map = importService.importText(list, ds);
			String insertCount = map.get("insertCount").toString();
			String updateCount = map.get("updateCount").toString();
			String msg = "本次导入条数为:"+list.size()+",新增条数为:"+insertCount+",修改条数为:"+updateCount;
			String jsonStr = JsonHelper.getInstance().write(msg);
			LOG.info("jsonStr : " + jsonStr);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "checkForStock",method = RequestMethod.POST)
	public void checkForStock(WebRequest request, HttpServletResponse response, @ModelAttribute("user") User user){
		String ds = request.getParameter("ds");
		Map map = new HashMap();
		try{
			map = importService.checkForStock(ds, user.getId());
			String jsonStr = JsonHelper.getInstance().write(map);
			LOG.info("jsonStr : " + jsonStr);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("rawtypes")
	public void checkForStockRegion(WebRequest request, HttpServletResponse response, @ModelAttribute("user") User user){
		String ds = request.getParameter("ds");
		Map map = new HashMap();
		try{
			map = importService.checkForStockRegion(ds, user.getId());
			String jsonStr = JsonHelper.getInstance().write(map);
			LOG.info("jsonStr : " + jsonStr);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	
}
