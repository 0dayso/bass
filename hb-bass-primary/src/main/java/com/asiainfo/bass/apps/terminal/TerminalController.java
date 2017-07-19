package com.asiainfo.bass.apps.terminal;

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
@RequestMapping(value = "/terminal")
@SessionAttributes({SessionKeyConstants.USER , "mvcPath", "contextPath" })
public class TerminalController {

	private static Logger LOG = Logger.getLogger(TerminalController.class);
	
	@Autowired
	private TerminalDao terminalDao;
	
	@Autowired
	private TerminalService terminalService;
	
	@RequestMapping(method = RequestMethod.GET)
	public String terminal(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("cityId", user.getCityId());
		return "ftl/terminal/terminalIndex";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "index", method = RequestMethod.GET)
	public String index(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user, Model model) {
		try {
			String cityId = terminalService.getCityId(user.getCityId());
			if(!"".equals(user.getCityId())){
				String time = terminalDao.getMaxIndexTime();;//最新数据日期
				List list = null ;
				List list2 = null;
				try {
					list = terminalService.getIndexInfo(cityId,time);
					list2 = terminalService.getIndexInfo2(cityId,time);
				} catch (Exception e) {
					LOG.error(e.getMessage());
					model.addAttribute("errorMsg", e.getMessage());
				}
				if(list!=null && list.size()>0){
					HashMap map = (HashMap)list.get(0);
					model.addAttribute("a1", (map.get("a1")==null?"0":map.get("a1")));	
					model.addAttribute("a2", (map.get("a2")==null?"0":map.get("a2")));	
					model.addAttribute("a3", (map.get("a3")==null?"0":map.get("a3")));
					model.addAttribute("a4", (map.get("a4")==null?"0":map.get("a4")));
					model.addAttribute("a5", (map.get("a5")==null?"0":map.get("a5")));
					model.addAttribute("a6", (map.get("a6")==null?"0":map.get("a6")));
					model.addAttribute("a7", (map.get("a7")==null?"0":map.get("a7")));
					model.addAttribute("a8", (map.get("a8")==null?"0":map.get("a8")));
					model.addAttribute("a9", (map.get("a9")==null?"0":map.get("a9")));
					model.addAttribute("b1", (map.get("b1")==null?"0":map.get("b1")));	
					model.addAttribute("b2", (map.get("b2")==null?"0":map.get("b2")));	
					model.addAttribute("b3", (map.get("b3")==null?"0":map.get("b3"))); 
					model.addAttribute("b31",(map.get("b31")==null?"0":map.get("b31")));	
					model.addAttribute("b4", (map.get("b4")==null?"0":map.get("b4")));	
					model.addAttribute("b6", (map.get("b6")==null?"0":map.get("b6")));	
					model.addAttribute("b7", (map.get("b7")==null?"0":map.get("b7")));	
					model.addAttribute("b8", (map.get("b8")==null?"0":map.get("b8")));	
					model.addAttribute("b9", (map.get("b9")==null?"0":map.get("b9")));	
					model.addAttribute("c1", (map.get("c1")==null?"0":map.get("c1")));	
					model.addAttribute("c2", (map.get("c2")==null?"0":map.get("c2"))); 
					model.addAttribute("c3", (map.get("c3")==null?"0":map.get("c3"))); 
					model.addAttribute("c4", (map.get("c4")==null?"0":map.get("c4"))); 
					model.addAttribute("c5", (map.get("c5")==null?"0":map.get("c5"))); 
				}else{
					model.addAttribute("a1", "0");	
					model.addAttribute("a2", "0");	
					model.addAttribute("a3", "0");	
					model.addAttribute("a4", "0");
					model.addAttribute("a5", "0");
					model.addAttribute("a6", "0");
					model.addAttribute("a7", "0");
					model.addAttribute("a8", "0");
					model.addAttribute("a9", "0");
					model.addAttribute("b1", "0");	
					model.addAttribute("b2", "0");	
					model.addAttribute("b3", "0"); 
					model.addAttribute("b31", "0");	
					model.addAttribute("b4", "0");	
					model.addAttribute("b6", "0");	
					model.addAttribute("b7", "0");	
					model.addAttribute("b8", "0");	
					model.addAttribute("b9", "0");	
					model.addAttribute("c1", "0");	
					model.addAttribute("c2", "0"); 
					model.addAttribute("c3", "0"); 
					model.addAttribute("c4", "0"); 
					model.addAttribute("c5", "0"); 
				}
				
				if(list2!=null && list2.size()>0){
					HashMap map = (HashMap)list2.get(0);
					model.addAttribute("a10", (map.get("a10")==null?"0":map.get("a10")));	
					model.addAttribute("a11", (map.get("a11")==null?"0":map.get("a11")));	
					model.addAttribute("a12", (map.get("a12")==null?"0":map.get("a12")));
				}else{
					model.addAttribute("a10", "0");	
					model.addAttribute("a11", "0");	
					model.addAttribute("a12", "0");	
				}
				model.addAttribute("cityid",cityId);
				model.addAttribute("time",time);
			}
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/index";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "showIndex", method = RequestMethod.GET)
	public String showIndex(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user, Model model){
		try {
			String cityid = request.getParameter("city");
			String time = request.getParameter("time");//批次月
			if(!"".equals(user.getCityId())){
				List<Map<String,Object>> list = null;
				List<Map<String,Object>> list2 = null;
				try {
					list = terminalService.getIndexInfo(cityid,time);
					list2 = terminalService.getIndexInfo2(cityid,time);
				} catch (Exception e) {
					LOG.error(e.getMessage());
					model.addAttribute("errorMsg", e.getMessage());
				}
				if(list!=null && list.size()>0){
					HashMap map = (HashMap)list.get(0);
					model.addAttribute("a1", (map.get("a1")==null?"0":map.get("a1")));	
					model.addAttribute("a2", (map.get("a2")==null?"0":map.get("a2")));	
					model.addAttribute("a3", (map.get("a3")==null?"0":map.get("a3")));
					model.addAttribute("a4", (map.get("a4")==null?"0":map.get("a4")));
					model.addAttribute("a5", (map.get("a5")==null?"0":map.get("a5")));
					model.addAttribute("a6", (map.get("a6")==null?"0":map.get("a6")));
					model.addAttribute("a7", (map.get("a7")==null?"0":map.get("a7")));
					model.addAttribute("a8", (map.get("a8")==null?"0":map.get("a8")));
					model.addAttribute("a9", (map.get("a9")==null?"0":map.get("a9")));
					model.addAttribute("b1", (map.get("b1")==null?"0":map.get("b1")));	
					model.addAttribute("b2", (map.get("b2")==null?"0":map.get("b2")));	
					model.addAttribute("b3", (map.get("b3")==null?"0":map.get("b3"))); 
					model.addAttribute("b31",(map.get("b31")==null?"0":map.get("b31")));	
					model.addAttribute("b4", (map.get("b4")==null?"0":map.get("b4")));	
					model.addAttribute("b6", (map.get("b6")==null?"0":map.get("b6")));	
					model.addAttribute("b7", (map.get("b7")==null?"0":map.get("b7")));	
					model.addAttribute("b8", (map.get("b8")==null?"0":map.get("b8")));	
					model.addAttribute("b9", (map.get("b9")==null?"0":map.get("b9")));	
					model.addAttribute("c1", (map.get("c1")==null?"0":map.get("c1")));	
					model.addAttribute("c2", (map.get("c2")==null?"0":map.get("c2"))); 
					model.addAttribute("c3", (map.get("c3")==null?"0":map.get("c3"))); 
					model.addAttribute("c4", (map.get("c4")==null?"0":map.get("c4"))); 
					model.addAttribute("c5", (map.get("c5")==null?"0":map.get("c5"))); 
				}else{
					model.addAttribute("a1", "0");	
					model.addAttribute("a2", "0");	
					model.addAttribute("a3", "0");
					model.addAttribute("a4", "0");
					model.addAttribute("a5", "0");
					model.addAttribute("a6", "0");
					model.addAttribute("a7", "0");
					model.addAttribute("a8", "0");
					model.addAttribute("a9", "0");
					model.addAttribute("b1", "0");	
					model.addAttribute("b2", "0");	
					model.addAttribute("b3", "0"); 
					model.addAttribute("b31", "0");	
					model.addAttribute("b4", "0");	
					model.addAttribute("b6", "0");	
					model.addAttribute("b7", "0");	
					model.addAttribute("b8", "0");	
					model.addAttribute("b9", "0");	
					model.addAttribute("c1", "0");	
					model.addAttribute("c2", "0"); 
					model.addAttribute("c3", "0"); 
					model.addAttribute("c4", "0"); 
					model.addAttribute("c5", "0"); 
				}
				
				if(list2!=null && list2.size()>0){
					HashMap map = (HashMap)list2.get(0);
					model.addAttribute("a10", (map.get("a10")==null?"0":map.get("a10")));	
					model.addAttribute("a11", (map.get("a11")==null?"0":map.get("a11")));	
					model.addAttribute("a12", (map.get("a12")==null?"0":map.get("a12")));
				}else{
					model.addAttribute("a10", "0");	
					model.addAttribute("a11", "0");	
					model.addAttribute("a12", "0");	
				}
				
				model.addAttribute("cityid",cityid);
				model.addAttribute("time",time);
			}
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/index";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "indexDay", method = RequestMethod.GET)
	public String indexDay(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user, Model model){
		try {
			String cityId = terminalService.getCityId(user.getCityId());
			if(!"".equals(user.getCityId())){
				List<Map<String,Object>> listPreSal = null;
				List<Map<String,Object>> listAfter = null;
				List<Map<String,Object>> listSalAndOneSeason = null;
				List<Map<String,Object>> listAfte2GChange = null;
				String time = terminalDao.getMaxTimeIndexDay();
				try {
					listPreSal = terminalService.getIndexInfoPreAndSal(cityId,time);
					listAfter = terminalService.getIndexInfoAfter(cityId,time);
					listSalAndOneSeason = terminalService.getSalAndOneSeason(cityId,time);
					listAfte2GChange = terminalService.getAfte2GChange(cityId,time);
				} catch (Exception e) {
					LOG.error(e.getMessage());
					model.addAttribute("errorMsg", e.getMessage());
				}
				if(listPreSal!=null && listPreSal.size()>0){
					HashMap map = (HashMap)listPreSal.get(0);
					model.addAttribute("a1", (map.get("a1")==null?"0":map.get("a1")));	
					model.addAttribute("a2", (map.get("a2")==null?"0":map.get("a2")));	
					model.addAttribute("a3", (map.get("a3")==null?"0":map.get("a3")));
					model.addAttribute("a4", (map.get("a4")==null?"0":map.get("a4")));
					model.addAttribute("a5", (map.get("a5")==null?"0":map.get("a5")));
					model.addAttribute("a6", (map.get("a6")==null?"0":map.get("a6")));
					model.addAttribute("a7", (map.get("a7")==null?"0":map.get("a7")));
					model.addAttribute("a8", (map.get("a8")==null?"0":map.get("a8")));
					model.addAttribute("a9", (map.get("a9")==null?"0":map.get("a9")));
					model.addAttribute("a10", (map.get("a10")==null?"0":map.get("a10")));
					model.addAttribute("a11", (map.get("a11")==null?"0":map.get("a11")));
					model.addAttribute("a12", (map.get("a12")==null?"0":map.get("a12")));
					model.addAttribute("b1", (map.get("b1")==null?"0":map.get("b1")));	
					model.addAttribute("b2", (map.get("b2")==null?"0":map.get("b2")));	
					model.addAttribute("b3", (map.get("b3")==null?"0":map.get("b3"))); 
					model.addAttribute("b4", (map.get("b4")==null?"0":map.get("b4")));
					model.addAttribute("b5", (map.get("b5")==null?"0":map.get("b5")));
					model.addAttribute("b6", (map.get("b6")==null?"0":map.get("b6")));	
					model.addAttribute("b7", (map.get("b7")==null?"0":map.get("b7")));	
					model.addAttribute("b8", (map.get("b8")==null?"0":map.get("b8")));	
					model.addAttribute("b9", (map.get("b9")==null?"0":map.get("b9")));	
					model.addAttribute("b10", (map.get("b10")==null?"0":map.get("b10")));	
					model.addAttribute("b11", (map.get("b11")==null?"0":map.get("b11")));	
					model.addAttribute("b12", (map.get("b12")==null?"0":map.get("b12")));
				}else{
					model.addAttribute("a1", "0");	
					model.addAttribute("a2", "0");	
					model.addAttribute("a3", "0");
					model.addAttribute("a4", "0");
					model.addAttribute("a5", "0");
					model.addAttribute("a6", "0");
					model.addAttribute("a7", "0");
					model.addAttribute("a8", "0");
					model.addAttribute("a9", "0");
					model.addAttribute("a10", "0");
					model.addAttribute("a11", "0");
					model.addAttribute("a12", "0");
					model.addAttribute("b1", "0");	
					model.addAttribute("b2", "0");	
					model.addAttribute("b3", "0"); 
					model.addAttribute("b4", "0");
					model.addAttribute("b5", "0");
					model.addAttribute("b6", "0");	
					model.addAttribute("b7", "0");	
					model.addAttribute("b8", "0");	
					model.addAttribute("b9", "0");
					model.addAttribute("b10", "0");	
					model.addAttribute("b11", "0");	
					model.addAttribute("b12", "0");
				}
				
				if(listAfter!=null && listAfter.size()>0){
					HashMap map = (HashMap)listAfter.get(0);
					model.addAttribute("c1", (map.get("c1")==null?"0":map.get("c1")));	
					model.addAttribute("c2", (map.get("c2")==null?"0":map.get("c2")));	
					model.addAttribute("c3", (map.get("c3")==null?"0":map.get("c3")));
					model.addAttribute("c4", (map.get("c4")==null?"0":map.get("c4")));
					model.addAttribute("c5", (map.get("c5")==null?"0":map.get("c5")));
					model.addAttribute("c6", (map.get("c6")==null?"0":map.get("c6")));
					model.addAttribute("c7", (map.get("c7")==null?"0":map.get("c7")));
					model.addAttribute("c8", (map.get("c8")==null?"0":map.get("c8")));
				}else{
					model.addAttribute("c1", "0");	
					model.addAttribute("c2", "0");	
					model.addAttribute("c3", "0");
					model.addAttribute("c4", "0");
					model.addAttribute("c5", "0");
					model.addAttribute("c6", "0");
					model.addAttribute("c7", "0");
					model.addAttribute("c8", "0");
				}
				
				if(listSalAndOneSeason!=null && listSalAndOneSeason.size()>0){
					HashMap map = (HashMap)listSalAndOneSeason.get(0);
					model.addAttribute("b13", (map.get("b13")==null?"0":map.get("b13")));	
					model.addAttribute("b14", (map.get("b14")==null?"0":map.get("b14")));
				}else{
					model.addAttribute("b13", "");
					model.addAttribute("b14", "");
				}
				
				if(listAfte2GChange!=null && listAfte2GChange.size()>0){
					HashMap map = (HashMap)listAfte2GChange.get(0);
					model.addAttribute("c9", (map.get("c9")==null?"0":map.get("c9")));	
					model.addAttribute("c10", (map.get("c10")==null?"0":map.get("c10")));
				}else{
					model.addAttribute("c9", "");
					model.addAttribute("c10", "");
				}
				
				model.addAttribute("cityid",cityId);
				model.addAttribute("time",time);
			}
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/indexDay";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "showIndexWithDay", method = RequestMethod.GET)
	public String showIndexWithDay(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user, Model model){
		try {
			String cityid = request.getParameter("city");
			String time = request.getParameter("time");//批次月
			if(!"".equals(user.getCityId())){
				List<Map<String,Object>> listPreSal = null;
				List<Map<String,Object>> listAfter = null;
				List<Map<String,Object>> listSalAndOneSeason = null;
				List<Map<String,Object>> listAfte2GChange = null;
				try {
					listPreSal = terminalService.getIndexInfoPreAndSal(cityid,time);
					listAfter = terminalService.getIndexInfoAfter(cityid,time);
					listSalAndOneSeason = terminalService.getSalAndOneSeason(cityid,time);
					listAfte2GChange = terminalService.getAfte2GChange(cityid,time);
				} catch (Exception e) {
					LOG.error(e.getMessage());
					model.addAttribute("errorMsg", e.getMessage());
				}
				if(listPreSal!=null && listPreSal.size()>0){
					HashMap map = (HashMap)listPreSal.get(0);
					model.addAttribute("a1", (map.get("a1")==null?"0":map.get("a1")));	
					model.addAttribute("a2", (map.get("a2")==null?"0":map.get("a2")));	
					model.addAttribute("a3", (map.get("a3")==null?"0":map.get("a3")));
					model.addAttribute("a4", (map.get("a4")==null?"0":map.get("a4")));
					model.addAttribute("a5", (map.get("a5")==null?"0":map.get("a5")));
					model.addAttribute("a6", (map.get("a6")==null?"0":map.get("a6")));
					model.addAttribute("a7", (map.get("a7")==null?"0":map.get("a7")));
					model.addAttribute("a8", (map.get("a8")==null?"0":map.get("a8")));
					model.addAttribute("a9", (map.get("a9")==null?"0":map.get("a9")));
					model.addAttribute("a10", (map.get("a10")==null?"0":map.get("a10")));
					model.addAttribute("a11", (map.get("a11")==null?"0":map.get("a11")));
					model.addAttribute("a12", (map.get("a12")==null?"0":map.get("a12")));
					model.addAttribute("b1", (map.get("b1")==null?"0":map.get("b1")));	
					model.addAttribute("b2", (map.get("b2")==null?"0":map.get("b2")));	
					model.addAttribute("b3", (map.get("b3")==null?"0":map.get("b3"))); 
					model.addAttribute("b4", (map.get("b4")==null?"0":map.get("b4")));
					model.addAttribute("b5", (map.get("b5")==null?"0":map.get("b5")));
					model.addAttribute("b6", (map.get("b6")==null?"0":map.get("b6")));	
					model.addAttribute("b7", (map.get("b7")==null?"0":map.get("b7")));	
					model.addAttribute("b8", (map.get("b8")==null?"0":map.get("b8")));	
					model.addAttribute("b9", (map.get("b9")==null?"0":map.get("b9")));	
					model.addAttribute("b10", (map.get("b10")==null?"0":map.get("b10")));	
					model.addAttribute("b11", (map.get("b11")==null?"0":map.get("b11")));	
					model.addAttribute("b12", (map.get("b12")==null?"0":map.get("b12")));
				}else{
					model.addAttribute("a1", "0");	
					model.addAttribute("a2", "0");	
					model.addAttribute("a3", "0");
					model.addAttribute("a4", "0");
					model.addAttribute("a5", "0");
					model.addAttribute("a6", "0");
					model.addAttribute("a7", "0");
					model.addAttribute("a8", "0");
					model.addAttribute("a9", "0");
					model.addAttribute("a10", "0");
					model.addAttribute("a11", "0");
					model.addAttribute("a12", "0");
					model.addAttribute("b1", "0");	
					model.addAttribute("b2", "0");	
					model.addAttribute("b3", "0"); 
					model.addAttribute("b4", "0");
					model.addAttribute("b5", "0");
					model.addAttribute("b6", "0");	
					model.addAttribute("b7", "0");	
					model.addAttribute("b8", "0");	
					model.addAttribute("b9", "0");
					model.addAttribute("b10", "0");	
					model.addAttribute("b11", "0");	
					model.addAttribute("b12", "0");
				}
				if(listAfter!=null && listAfter.size()>0){
					HashMap map = (HashMap)listAfter.get(0);
					model.addAttribute("c1", (map.get("c1")==null?"0":map.get("c1")));	
					model.addAttribute("c2", (map.get("c2")==null?"0":map.get("c2")));	
					model.addAttribute("c3", (map.get("c3")==null?"0":map.get("c3")));
					model.addAttribute("c4", (map.get("c4")==null?"0":map.get("c4")));
					model.addAttribute("c5", (map.get("c5")==null?"0":map.get("c5")));
					model.addAttribute("c6", (map.get("c6")==null?"0":map.get("c6")));
					model.addAttribute("c7", (map.get("c7")==null?"0":map.get("c7")));
					model.addAttribute("c8", (map.get("c8")==null?"0":map.get("c8")));
				}else{
					model.addAttribute("c1", "0");	
					model.addAttribute("c2", "0");	
					model.addAttribute("c3", "0");
					model.addAttribute("c4", "0");
					model.addAttribute("c5", "0");
					model.addAttribute("c6", "0");
					model.addAttribute("c7", "0");
					model.addAttribute("c8", "0");
				}
				
				if(listSalAndOneSeason!=null && listSalAndOneSeason.size()>0){
					HashMap map = (HashMap)listSalAndOneSeason.get(0);
					model.addAttribute("b13", (map.get("b13")==null?"0":map.get("b13")));	
					model.addAttribute("b14", (map.get("b14")==null?"0":map.get("b14")));
				}else{
					model.addAttribute("b13", "");
					model.addAttribute("b14", "");
				}
				
				if(listAfte2GChange!=null && listAfte2GChange.size()>0){
					HashMap map = (HashMap)listAfte2GChange.get(0);
					model.addAttribute("c9", (map.get("c9")==null?"0":map.get("c9")));	
					model.addAttribute("c10", (map.get("c10")==null?"0":map.get("c10")));
				}else{
					model.addAttribute("c9", "");
					model.addAttribute("c10", "");
				}
				model.addAttribute("cityid",cityid);
				model.addAttribute("time",time);
			}
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/indexDay";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "preSale", method = RequestMethod.GET)
	public String preSale(@ModelAttribute("user") User user, Model model) {
		try {
			String cityId = terminalService.getCityId(user.getCityId());
			if(!"".equals(user.getCityId())){
				List cityList = terminalService.getCityList(cityId);//地市情况
				String time = terminalService.getMaxTime();//最新数据日期
				List list = null;
				HashMap selfTurnoverMap = null;
				Map result = null;
				String res = null;
				try {
					list = terminalService.getList(time, cityId);//手机终端销售排名前10库存
					selfTurnoverMap = terminalService.getTurnover(time, cityId, "自有资源");//自有库存周转情况及预警
					result = terminalService.getMenuMap("98090911");
					res = JsonHelper.getInstance().write(result);
					res = res.replaceAll("\\/", "/");
				} catch (Exception e) {
					LOG.error(e.getMessage());
					model.addAttribute("errorMsg", e.getMessage());
				}
				model.addAttribute("res", res);
				model.addAttribute("cityList", cityList);
				model.addAttribute("time", time);
				model.addAttribute("list", list);
				model.addAttribute("type", "1");
				model.addAttribute("selfTurnoverMap", selfTurnoverMap);
				model.addAttribute("cityid", terminalService.getCityId(user.getCityId()));
			}
		} catch (Exception e) {
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/preSale";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/showPreSale", method = RequestMethod.GET)
	public String showPreSale(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user, Model model){
		try {
			String time = request.getParameter("time");
			String cityid = request.getParameter("city");
			String type = request.getParameter("type");
			String typeValue = "";
			if("1".equals(type)){
				typeValue = "自有资源";
			}else if("2".equals(type)){
				typeValue = "代理商资源";
			}
			if(!"".equals(user.getCityId())){
				List cityList = terminalService.getCityList(cityid);//地市情况
				List list = terminalService.getList(time, cityid);
				HashMap selfTurnoverMap = terminalService.getTurnover(time, cityid, typeValue);
				HashMap proxyTurnoverMap = terminalService.getTurnover(time, cityid, typeValue);
				Map result = terminalService.getMenuMap("98090911");
				String res = JsonHelper.getInstance().write(result);
				res = res.replaceAll("\\/", "/");
				model.addAttribute("res", res);
				model.addAttribute("cityList", cityList);
				model.addAttribute("time", time);
				model.addAttribute("type", type);
				model.addAttribute("list", list);
				model.addAttribute("selfTurnoverMap", selfTurnoverMap);
				model.addAttribute("proxyTurnoverMap", proxyTurnoverMap);
				model.addAttribute("cityid", cityid);
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/preSale";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "afterSale", method = RequestMethod.GET)
	public String afterSale(@ModelAttribute("user") User user, Model model) {
		try {
			String cityId = terminalService.getCityId(user.getCityId());
			if(!"".equals(user.getCityId())){
				List cityList = terminalService.getCityList(cityId);//地市情况
				String time = terminalService.getMaxAfterTime();//最新数据月份
				HashMap map = terminalService.getWarningMap(cityId,time,"2","1");//预警情况
				List marketingList = terminalService.getMarketingList(cityId,time,3,"1","1");//营销活动数据最后一个参数的值为：1、营销活动，2、终端型号，3、渠道类型
				List modelList = terminalService.getMarketingList(cityId,time,3,"1","2");//终端数据最后一个参数的值为：1、营销活动，2、终端型号，3、渠道类型
				List channelList = terminalService.getMarketingList(cityId,time,3,"1","3");//渠道类型
				HashMap analysisMap = terminalService.getAnalysisMap(cityId,time,"4");//终端投入产出分析
				Map result = null;
				result = terminalService.getMenuMap("98090910");
				String res = JsonHelper.getInstance().write(result);
				res = res.replaceAll("\\/", "/");
				//*月TD换机客户价值提升情况
				model.addAttribute("cityList", cityList);
				model.addAttribute("type", "1");
				model.addAttribute("time", time);
				model.addAttribute("map", map);
				model.addAttribute("marketingList", marketingList);
				model.addAttribute("modelList", modelList);
				model.addAttribute("channelList", channelList);
				model.addAttribute("analysisMap",analysisMap);
				model.addAttribute("cityid", terminalService.getCityId(user.getCityId()));
				model.addAttribute("res", res);
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/afterSale";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "showAfterSale", method = RequestMethod.GET)
	public String showAfterSale(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user, Model model) {
		String time = request.getParameter("time");
		String cityid = request.getParameter("city");
		String type = request.getParameter("type");
		try {
			if(!"".equals(user.getCityId())){
				List cityList = terminalService.getCityList(cityid);//地市情况
				HashMap map = terminalService.getWarningMap(cityid,time,"2",type);//预警情况
				List marketingList = terminalService.getMarketingList(cityid,time,3,type,"1");//营销活动数据最后一个参数的值为：1、营销活动，2、终端型号，3、渠道类型
				List modelList = terminalService.getMarketingList(cityid,time,3,type,"2");//终端数据最后一个参数的值为：1、营销活动，2、终端型号，3、渠道类型
				List channelList = terminalService.getMarketingList(cityid,time,3,type,"3");//渠道类型
				HashMap analysisMap = terminalService.getAnalysisMap(cityid,time,"4");//终端投入产出分析
				Map result = null;
				try {
					result = terminalService.getMenuMap("98090910");
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				String res = JsonHelper.getInstance().write(result);
				res = res.replaceAll("\\/", "/");
				model.addAttribute("res", res);
				//*月TD换机客户价值提升情况
				model.addAttribute("cityList", cityList);
				model.addAttribute("type", type);
				model.addAttribute("time", time);
				model.addAttribute("map", map);
				model.addAttribute("marketingList", marketingList);
				model.addAttribute("modelList", modelList);
				model.addAttribute("channelList", channelList);
				model.addAttribute("analysisMap",analysisMap);
				model.addAttribute("cityid", cityid);
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/afterSale";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "showSaling", method = RequestMethod.GET)
	public String showSaling(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user, Model model) {
		String cityid = request.getParameter("city");
		String type = request.getParameter("type");
		try {
			if(!"".equals(user.getCityId())){
				List cityList = terminalService.getCityList(cityid);//地市情况
				String time = terminalService.getMaxSalingTime();//最新数据日期
				List channelList = terminalService.getChannelSaleList("4", time, type, cityid);//渠道销售排名前5
				List saleList = terminalService.getSaleList("3", time, type, cityid);//网点终端销售排名前5
				Map saleByCityMap = terminalService.getSaleByCityMap("5", time, cityid);//地区终端销售量
				HashMap saleStructureMap = terminalService.getSaleStructureMap("6", time, type, cityid);//终端销售结构
				HashMap paulInfoMap = terminalService.getPaulInfoMap("7", time, type, cityid);//全省保底销售情况
				Map result = null;
				try {
					result = terminalService.getMenuMap("98090912");
				
				} catch (Exception e) {
					e.printStackTrace();
				}
				String res = JsonHelper.getInstance().write(result);
				res = res.replaceAll("\\/", "/");
				model.addAttribute("res", res);
				model.addAttribute("cityList", cityList);
				model.addAttribute("time", time);
				model.addAttribute("channelList", channelList);
				model.addAttribute("saleList", saleList);
				model.addAttribute("saleByCityMap", saleByCityMap);
				model.addAttribute("saleStructureMap", saleStructureMap);
				model.addAttribute("paulInfoMap", paulInfoMap);
				model.addAttribute("type", type);
				model.addAttribute("cityid", cityid);
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/saling";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "saling", method = RequestMethod.GET)
	public String saling(@ModelAttribute("user") User user, Model model) {
		try {
			String cityId = terminalService.getCityId(user.getCityId());
			if(!"".equals(user.getCityId())){
				List cityList = terminalService.getCityList(cityId);//地市情况
				String time = terminalService.getMaxSalingTime();//最新数据日期
				List channelList = terminalService.getChannelSaleList("4", time, "1", cityId);//渠道销售排名前5
				List saleList = terminalService.getSaleList("3", time, "1", cityId);//网点终端销售排名前5
				Map saleByCityMap = terminalService.getSaleByCityMap("5", time, cityId);//地区终端销售量
				HashMap saleStructureMap = terminalService.getSaleStructureMap("6", time, "1", cityId);//终端销售结构
				HashMap paulInfoMap = terminalService.getPaulInfoMap("7", time, "1", cityId);//全省保底销售情况
				Map result = terminalService.getMenuMap("98090912");
				String res = JsonHelper.getInstance().write(result);
				res = res.replaceAll("\\/", "/");
				model.addAttribute("res", res);
				model.addAttribute("cityList", cityList);
				model.addAttribute("time", time);
				model.addAttribute("channelList", channelList);
				model.addAttribute("saleList", saleList);
				model.addAttribute("saleByCityMap", saleByCityMap);
				model.addAttribute("saleStructureMap", saleStructureMap);
				model.addAttribute("paulInfoMap", paulInfoMap);
				model.addAttribute("type", "1");
				model.addAttribute("cityid", terminalService.getCityId(user.getCityId()));
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/saling";
	}
	
	@RequestMapping(value = "jxcgl",method = RequestMethod.GET)
	public String jxcgl(WebRequest request, @ModelAttribute("user") User user, Model model) {
		model.addAttribute("cityId", user.getCityId());
		String checkIE = request.getParameter("checkIE");
		if(checkIE.equals("1")){
			return "ftl/terminal/jxcgl";
		}else if(checkIE.equals("2")){
			return "ftl/terminal/message";
		}
		return null;
	}
	
	@RequestMapping(value = "kczc",method = RequestMethod.GET)
	public String kczc(@ModelAttribute("user") User user, Model model) {
		try {
			model.addAttribute("cityId", user.getCityId());
			if(!"".equals(user.getCityId()) && user.getCityId().equals("0")){
				model.addAttribute("cityCode", "HB");
			}else if(!"".equals(user.getCityId()) && !user.getCityId().equals("0")){
				model.addAttribute("cityCode", terminalDao.getAreaCode(user.getCityId()));
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/kczc";
	}
	
	@RequestMapping(value = "kczzl",method = RequestMethod.GET)
	public String kczzl(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("cityId", user.getCityId());
		return "ftl/terminal/kczzl";
	}
	
	@RequestMapping(value = "kczx",method = RequestMethod.GET)
	public String kczx(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("cityId", user.getCityId());
		return "ftl/terminal/kczx";
	}
	
	@RequestMapping(value = "zdyx",method = RequestMethod.GET)
	public String zdyx(WebRequest request, @ModelAttribute("user") User user, Model model) {
		model.addAttribute("cityId", user.getCityId());
		String checkIE = request.getParameter("checkIE");
		if(checkIE.equals("1")){
			return "ftl/terminal/zdyx";
		}else if(checkIE.equals("2")){
			return "ftl/terminal/message";
		}
		return null;
	}
	
	@RequestMapping(value = "eddb",method = RequestMethod.GET)
	public String eddb(@ModelAttribute("user") User user, Model model) {
		try {
			model.addAttribute("cityId", user.getCityId());
			if(!"".equals(user.getCityId()) && user.getCityId().equals("0")){
				model.addAttribute("cityCode", "HB");
			}else if(!"".equals(user.getCityId()) && !user.getCityId().equals("0")){
				model.addAttribute("cityCode", terminalDao.getAreaCode(user.getCityId()));
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			model.addAttribute("errorMsg", e.getMessage());
		}
		return "ftl/terminal/eddb";
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "getCity", method = RequestMethod.POST)
	public void getCity(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String cityId = terminalService.getCityId(user.getCityId());
			boolean flag = terminalService.isSpecial(user.getGroupId());
			if(flag){
				cityId = "HB";
			}
			List list = terminalService.getCityList(cityId);		
			String jsonStr = JsonHelper.getInstance().write(list);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/getArea", method = RequestMethod.POST)
	public void getArea(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			List list = null;
			String cityId = request.getParameter("cityId");
			if("".equals(cityId) && cityId==null){
				cityId = user.getCityId();
				list = terminalDao.getArea(cityId);		
			}else{
				list = terminalDao.getAreaByCode(cityId);		
			}
			String jsonStr = JsonHelper.getInstance().write(list);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/createImage", method = RequestMethod.POST)
	public void image(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String sql = request.getParameter("sql");
			String averageSql = request.getParameter("sql1");
			String isCity = request.getParameter("isCity");
			HashMap result = new HashMap();
			if (sql != null) {
				List list = terminalDao.getList(sql);
				if(list!=null && list.size()>0){
					String[] city = new String[list.size()];
					double[] date1 = new double[list.size()];
					double[] date2 = new double[list.size()];
					for(int i=0;i<list.size();i++){
						HashMap map = new HashMap();
						map = (HashMap)list.get(i);
						String area_name = map.get("area_name").toString();
						double instore = Double.parseDouble(map.get("instore").toString());
						double num = Double.parseDouble(map.get("num").toString());
						city[i] = area_name;
						date1[i] = instore;
						date2[i] = num;
					}
					double average = terminalDao.getAverage(averageSql);
					result.put("city", city);
					result.put("date1", date1);
					result.put("date2", date2);
					result.put("average", average);
					if("HB".equals(isCity)){
						result.put("isCity", "1");
					}
				}
			}
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
		
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/createImageEddl", method = RequestMethod.POST)
	public void createImageEddl(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String date = request.getParameter("date");
			HashMap result = new HashMap();
			double average = terminalDao.getAverageEddl(date);
			List list = terminalDao.getDateEddl(date);
			if(list!=null && list.size()>0){
				String[] city = new String[list.size()];
				double[] date1 = new double[list.size()];
				double[] date2 = new double[list.size()];
				for(int i=0;i<list.size();i++){
					HashMap map = new HashMap();
					map = (HashMap)list.get(i);
					String area_name = map.get("area_name").toString();
					double sell_rate = Double.parseDouble(map.get("sell_rate").toString());
					double cost_rate = Double.parseDouble(map.get("cost_rate").toString());
					city[i] = area_name;
					date1[i] = sell_rate;
					date2[i] = cost_rate;
				}
				result.put("city", city);
				result.put("date1", date1);
				result.put("date2", date2);
				result.put("average", average);
			}
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
		
	}
	
	@RequestMapping(value = "chl",method = RequestMethod.GET)
	public String chl(@ModelAttribute("user") User user, Model model) {
		model.addAttribute("cityId", user.getCityId());
		return "ftl/terminal/chl";
	}
	
	@RequestMapping(value = "sjch",method = RequestMethod.GET)
	public String sjch(WebRequest request, @ModelAttribute("user") User user, Model model) {
		model.addAttribute("cityId", user.getCityId());
		try {
			if(!"".equals(user.getCityId()) && user.getCityId().equals("0")){
				model.addAttribute("cityCode", "HB");
			}else if(!"".equals(user.getCityId()) && !user.getCityId().equals("0")){
				model.addAttribute("cityCode", terminalDao.getAreaCode(user.getCityId()));
			}
		} catch (Exception e) {
			LOG.error(e.getMessage());
			model.addAttribute("errorMsg", e.getMessage());
		}
		String checkIE = request.getParameter("checkIE");
		if(checkIE.equals("1")){
			return "ftl/terminal/sjch";
		}else if(checkIE.equals("2")){
			return "ftl/terminal/message";
		}
		return null;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/createImageChl", method = RequestMethod.POST)
	public void createImageChl(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user){
		try {
			String date = request.getParameter("date");
			String type = request.getParameter("type");
			String cityId = request.getParameter("city_id");
			String areaCode ="";
			if("".equals(cityId)){
				cityId = user.getCityId();
				if(!"".equals(cityId) && cityId.equals("0")){
					areaCode = "HB";
				}else{
					areaCode = terminalDao.getAreaCode(cityId);
				}
			}else{
				areaCode = cityId;
			}
			HashMap result = new HashMap();
			List list = terminalDao.getDateChl(date,type,areaCode);
			if(list!=null && list.size()>0){
				String[] city = new String[list.size()];
				double[] date1 = new double[list.size()];
				double[] date2 = new double[list.size()];
				for(int i=0;i<list.size();i++){
					HashMap map = new HashMap();
					map = (HashMap)list.get(i);
					String area_name = map.get("area_name").toString();
					double po_rate = Double.parseDouble(map.get("po_rate").toString());
					double po_cycle_rate = Double.parseDouble(map.get("po_cycle_rate").toString());
					city[i] = area_name;
					date1[i] = po_rate;
					date2[i] = po_cycle_rate;
				}
				result.put("city", city);
				result.put("date1", date1);
				result.put("date2", date2);
			}
			String jsonStr = JsonHelper.getInstance().write(result);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/createImageByType", method = RequestMethod.POST)
	public void createImageByType(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String time = request.getParameter("time");
			String cityId = request.getParameter("city");
			String type = request.getParameter("type");
			String ziyuanType = "";
			if(type.equals("1")){
				ziyuanType = "自有资源";
			}else{
				ziyuanType="代理商资源";
			}
			if("".equals(cityId) || cityId==null){
				cityId = terminalService.getCityId(user.getCityId());
			}
			HashMap selfByTerminalMap = terminalService.getInventoryMap(time, cityId, ziyuanType,2);//终端库存可支撑天数
			String jsonStr = JsonHelper.getInstance().write(selfByTerminalMap);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
		
	}
	
	@SuppressWarnings({ "rawtypes", "unused" })
	@RequestMapping(value = "/createImageByCity", method = RequestMethod.POST)
	public void createImageByCity(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String time = request.getParameter("time");
			String cityId = request.getParameter("city");
			String type = request.getParameter("type");
			String ziyuanType = "";
			if(type.equals("1")){
				ziyuanType = "自有资源";
			}else if(type.equals("2")){
				ziyuanType="代理商资源";
			}
			if("".equals(cityId) || cityId==null){
				cityId = terminalService.getCityId(user.getCityId());
			}
			HashMap selfByCityMap = terminalService.getInventoryMap(time, cityId, ziyuanType,3);//地市库存可支撑天数
			HashMap result = new HashMap();
			String jsonStr = JsonHelper.getInstance().write(selfByCityMap);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
		
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes", "unused" })
	@RequestMapping(value = "/createImageUsing", method = RequestMethod.POST)
	public void createImageUsing(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String time = request.getParameter("time");
			String cityId = request.getParameter("city");
			String type = request.getParameter("type");
			if("".equals(cityId) || cityId==null){
				cityId = terminalService.getCityId(user.getCityId());
			}
			HashMap usingMap = terminalService.getUsingMap(time, cityId, type,1);
			usingMap.put("type", type);
			HashMap result = new HashMap();
			String jsonStr = JsonHelper.getInstance().write(usingMap);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
		
	}
	
	@SuppressWarnings({ "rawtypes", "unused" })
	@RequestMapping(value = "/createImageAnalysis", method = RequestMethod.POST)
	public void createImageAnalysis(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String time = request.getParameter("time");
			String cityId = request.getParameter("city");
			String type = request.getParameter("type");
			if("".equals(cityId) || cityId==null){
				cityId = terminalService.getCityId(user.getCityId());
			}
			HashMap usingMap = terminalService.getAnalysisListMap(time, cityId, 4);
			HashMap result = new HashMap();
			String jsonStr = JsonHelper.getInstance().write(usingMap);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
		
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked", "unused" })
	@RequestMapping(value = "/createImageSaling", method = RequestMethod.POST)
	public void createImageSaling(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String endTime = terminalService.getMaxSalingTime();
			String timeYear = endTime.substring(0,4);
			String timeMonth = endTime.substring(4,6);
			String timeDay = endTime.substring(6,8);
			String beginTime = timeYear+timeMonth+"01";
			String cityId = request.getParameter("city");
			String type = request.getParameter("type");
			if("".equals(cityId) || cityId==null){
				cityId = terminalService.getCityId(user.getCityId());
			}
			HashMap salingMap = terminalService.getSalingListMap(beginTime, endTime, cityId, "1", type);
			if(!"".equals(type) && "2".equals(type)){
				timeDay = timeMonth + "月";
			}else if(!"".equals(type) && "1".equals(type)){
				timeDay = timeDay + "日";
			}
			salingMap.put("endDay", timeDay);
			HashMap result = new HashMap();
			String jsonStr = JsonHelper.getInstance().write(salingMap);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked", "unused" })
	@RequestMapping(value = "/createImageSalingByCity", method = RequestMethod.POST)
	public void createImageSalingByCity(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String endTime = terminalService.getMaxSalingTime();
			String timeYear = endTime.substring(0,4);
			String timeMonth = endTime.substring(4,6);
			String timeDay = endTime.substring(6,8);
			String beginTime = timeYear+timeMonth+"01";
			String cityId = request.getParameter("city");
			String type = request.getParameter("type");
			if("".equals(cityId) || cityId==null){
				cityId = terminalService.getCityId(user.getCityId());
			}
			HashMap salingMap = terminalService.getSalingByCityListMap(beginTime, endTime, cityId, "2", type);
			if(!"".equals(type) && "2".equals(type)){
				timeDay = timeMonth + "月";
			}else if(!"".equals(type) && "1".equals(type)){
				timeDay = timeDay + "日";
			}
			salingMap.put("endDay", timeDay);
			HashMap result = new HashMap();
			String jsonStr = JsonHelper.getInstance().write(salingMap);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
		
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "getChannelCode", method = RequestMethod.POST)
	public void getChannelCode(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String cityId = request.getParameter("city");
			if("".equals(cityId) || cityId==null){
				cityId = terminalService.getCityId(user.getCityId());
			}
			List list = terminalService.getChannelCode(cityId);		
			String jsonStr = JsonHelper.getInstance().write(list);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "getRectimestampsale", method = RequestMethod.POST)
	public void getRectimestampsale(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			String time = request.getParameter("time");
			if("".equals(time) || time==null){
				time = terminalDao.getMaxIndexTime();
			}
			List list = terminalService.getRectimestampsale(time);		
			String jsonStr = JsonHelper.getInstance().write(list);
			jsonStr = jsonStr.replaceAll("20130531", "\"全部\"");
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "getTime", method = RequestMethod.POST)
	public void getTime(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			List list = terminalService.getTime();		
			String jsonStr = JsonHelper.getInstance().write(list);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
	}
	
	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "getTimeWithDay", method = RequestMethod.POST)
	public void getTimeWithDay(HttpServletResponse response, WebRequest request, @ModelAttribute("user") User user) {
		try {
			List list = terminalService.getTimeWithDay();		
			String jsonStr = JsonHelper.getInstance().write(list);
			PrintWriter out = response.getWriter();
			out.print(jsonStr);
		} catch (Exception e) {
			LOG.error(e.getMessage());
		}
	}
}