package com.asiainfo.bass.apps.controllers;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.bass.apps.models.Report;
import com.asiainfo.bass.apps.models.ReportDao;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * 配置报表
 * 
 * @author Mei Kefu
 * @date 2010-5-5
 */
@SuppressWarnings("unused")
@Controller
@RequestMapping(value = "/report")
@SessionAttributes({ "user", "mvcPath" })
public class ReportController {

	private static Logger LOG = Logger.getLogger(ReportController.class);

	@Autowired
	private ReportDao reportDao;

	@RequestMapping(value = "{sid}", method = RequestMethod.GET)
	public String render(ServletRequest requests, @PathVariable("sid") String sid, @ModelAttribute("mvcPath") String mvcPath, @ModelAttribute("user") User user, Model model) {
		long beginTime = System.currentTimeMillis();
		System.out.println(user.getName());
		String time = requests.getParameter("time");
		String city = requests.getParameter("city");
		String condition = requests.getParameter("condition");
		LOG.info("time=" + time + ",city=" + city + ",condition=" + condition + ",sid=" + sid);
		Report rpt = reportDao.getReportById(Integer.valueOf(sid), user.getCityId(), user,time,city, condition);
		LOG.info("reportDao.getReportById查询结果：" + rpt.getId());
//		Report rpt = reportDao.getReportById(Integer.valueOf(sid), user.getCityId(), user,time,city);
		model.addAttribute("sid", String.valueOf(rpt.getId()));
		model.addAttribute("header", rpt.getHeaderData());
		model.addAttribute("title", rpt.getName());
		model.addAttribute("dimension", rpt.getDimensionData());
		model.addAttribute("grid", rpt.getGrid());
		model.addAttribute("code", (rpt.getCodeData()==null?"":rpt.getCodeData()));
		model.addAttribute("cache", rpt.getIsCached()==null?"":rpt.getIsCached());
		model.addAttribute("ds", (rpt.getDs()==null?"":rpt.getDs()));
		model.addAttribute("useExcel", rpt.getUseExcel()==null?"":rpt.getUseExcel());
		model.addAttribute("useChart", rpt.getUseChart()==null?"":rpt.getUseChart());
		model.addAttribute("groupId", user.getGroupId().equals("") ? "26020" : user.getGroupId());
		model.addAttribute("timeline", JsonHelper.getInstance().write(reportDao.getTimeLine(rpt.getId(), user.getId())));
		String sql = rpt.getOriSQL().trim().replaceAll("\r\n", " ").replaceAll("\n", " ");
		if (sql.endsWith(";")) {
			sql = sql.substring(0, sql.length() - 1);
		}
		model.addAttribute("sql", sql.replaceAll("\\{condiPiece\\}", " \"+ aihb.AjaxHelper.parseCondition() +\" "));
		model.addAttribute("corReport", JsonHelper.getInstance().write(reportDao.getCorrealtiveReport(rpt)));
		String caliber = reportDao.getCaliber(Integer.valueOf(sid));
		String currentUser = JsonHelper.getInstance().write(user);	
		LOG.info("currentUser=" + currentUser);
		model.addAttribute("currentUser",currentUser);
		String caliber1 = JsonHelper.getInstance().write(caliber);
		model.addAttribute("caliber", caliber1);
		model.addAttribute("downPass", "N");
		long endTime = System.currentTimeMillis();
		LOG.info("render方法用时：" + (endTime - beginTime));
		return "ftl/report";
	}
	@RequestMapping(value = "insertvalue", method = RequestMethod.GET)
	public void insertvalue(ServletRequest requests,  @ModelAttribute("user") User user){
		String id = requests.getParameter("id");
		reportDao.inservalue(id,user.getId());
	}
	@RequestMapping(value = "{sid}/query", method = RequestMethod.POST)
	public String query(@PathVariable("sid") String sid, @ModelAttribute("mvcPath") String mvcPath) {
		return "forward:" + "/sqlQuery";
	}

	@RequestMapping(value = "{sid}/down", method = RequestMethod.POST)
	public String down(@PathVariable("sid") String sid, @ModelAttribute("mvcPath") String mvcPath) {
		return "forward:" + "/sqlQuery/down";
	}
	

	// 增加执行sql的方法
	@RequestMapping(value = "/sqlExec", method = RequestMethod.POST)
	public String exec(@ModelAttribute("mvcPath") String mvcPath) {
		return "forward:" + "/sqlExec";
	}

	@RequestMapping(value = "conf", method = RequestMethod.GET)
	public String confMain() {
		LOG.info("conf:ftl/conf/main");
		return "ftl/conf/main";
	}

	@RequestMapping(value = "conf/{sid}", method = RequestMethod.GET)
	public String conf(@PathVariable("sid") String sid, Model model) {
		LOG.info("ftl/conf/confInst，sid=" + sid);
		model.addAttribute("sid", sid);
		return "ftl/conf/confInst";
	}

	/**
	 * 界面显示jsCode
	 * 
	 * @param sid
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "{sid}/code", method = RequestMethod.GET)
	public String getCode(@PathVariable("sid") String sid, Model model) {
		Report r = reportDao.getReportById(Integer.parseInt(sid));
		LOG.info(r);
		model.addAttribute("code", (r.getCodeData()==null?"":r.getCodeData()));
		model.addAttribute("sid", String.valueOf(r.getId()));
		return "ftl/conf/instCode";
	}

	/**
	 * 保存修改的jsCode
	 * 
	 * @param sid
	 * @param code
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "{sid}/code", method = RequestMethod.PUT)
	public @ResponseBody
	Map saveCode(@PathVariable("sid") Integer sid, @RequestParam String code) {
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try {
			reportDao.saveCode(sid, code);
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}

	/**
	 * 界面显示sql
	 * 
	 * @param sid
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "{sid}/sql", method = RequestMethod.GET)
	public String getSQL(@PathVariable("sid") String sid, Model model) {
		Report rpt = reportDao.getReportById(Integer.parseInt(sid));
		model.addAttribute("sid", String.valueOf(rpt.getId()));
		model.addAttribute("sql", rpt.getOriSQL());
		model.addAttribute("grid", rpt.getGrid());
		model.addAttribute("maxTime", rpt.getMaxTime());
		model.addAttribute("cache", (rpt.getIsCached()==null?"":rpt.getIsCached()));
		model.addAttribute("ds", (rpt.getDs()==null?"":rpt.getDs()));
		model.addAttribute("excel", (rpt.getUseExcel()== null?"":rpt.getUseExcel()));
		model.addAttribute("chart", (rpt.getUseChart()== null?"":rpt.getUseChart()));
		model.addAttribute("areaAll", (rpt.getIsAreaAll()== null?"":rpt.getIsAreaAll()));
		return "ftl/conf/instSQL";
	}

	/**
	 * 保存sql及相关属性
	 * 
	 * @param sid
	 * @param sql
	 * @param grid
	 * @param maxTime
	 * @param cache
	 * @param ds
	 * @param excel
	 * @param chart
	 * @param areaAll
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "{sid}/sql", method = RequestMethod.PUT)
	public @ResponseBody
	Map saveSQL(@PathVariable("sid") int sid, @RequestParam String sql, @RequestParam String grid, @RequestParam String maxTime, @RequestParam String cache, @RequestParam String ds, @RequestParam String excel, @RequestParam String chart, @RequestParam String areaAll) {
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try {
			reportDao.saveSQL(sid, sql, grid, maxTime, cache, ds, excel, chart, areaAll);
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}

	@SuppressWarnings("rawtypes")
	@RequestMapping(value = "/dim", method = RequestMethod.GET)
	public @ResponseBody
	List getDim() {
		List list = reportDao.getDim();
		LOG.info(list.toString());
		return list;
	}

	/**
	 * 跳转查询条件页面
	 */
	@RequestMapping(value = "{sid}/dim", method = RequestMethod.GET)
	public String getDim(@PathVariable("sid") String sid, Model model) {
		model.addAttribute("sid", sid);
		return "ftl/conf/instCondi";
	}

	/**
	 * 保存查询条件信息
	 * 
	 * @param sid
	 * @param name
	 * @param label
	 * @param dbname
	 * @param datasource
	 * @param seq
	 * @param opertype
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "{sid}/dim", method = RequestMethod.PUT)
	public @ResponseBody
	Map saveDim(@PathVariable("sid") int sid, @RequestParam String name, @RequestParam String label, @RequestParam String dbname, @RequestParam String datasource, @RequestParam int seq, @RequestParam String opertype) {
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try {
			reportDao.saveDim(sid, label, name, dbname, opertype, "", datasource, seq);
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}

	/**
	 * 删除查询条件
	 * 
	 * @param sid
	 * @param name
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "{sid}/dim", method = RequestMethod.DELETE)
	public @ResponseBody
	Map deleteDim(@PathVariable("sid") int sid, @RequestParam String name) {
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try {
			reportDao.delDim(sid, name);
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}

	/**
	 * 获取表头
	 * 
	 * @param sid
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "{sid}/header", method = RequestMethod.GET)
	public String getHeader(@PathVariable("sid") int sid, Model model) {
		Report rpt = reportDao.getReportById(sid);
		model.addAttribute("sid", String.valueOf(sid));
		model.addAttribute("headerData", rpt.getHeaderData());
		LOG.debug("headerData==========" + rpt.getHeaderData());
		return "ftl/conf/headerDesign/main";
	}

	/**
	 * 保存表头
	 * 
	 * @param sid
	 * @param headerStr
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "{sid}/header", method = RequestMethod.PUT)
	public @ResponseBody
	Map saveHeader(@PathVariable("sid") int sid, @RequestParam String headerStr) {
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try {
			JsonHelper helper = JsonHelper.getInstance();
			List list = (List) helper.read(headerStr);
			reportDao.saveHeader(sid, list);
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}

	/**
	 * 新增报表
	 * 
	 * @param name
	 * @param desc
	 * @param user
	 * @param proc
	 * @param source_table
	 * @param caliber_descript
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@RequestMapping(value = "/save", method = RequestMethod.PUT)
	public @ResponseBody
	Map save(@RequestParam String name, @RequestParam String desc, @RequestParam String user, @RequestParam String proc, @RequestParam String resp, @RequestParam String source_table, @RequestParam String caliber_descript) {
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try {
			// source_table,caliber_description不能为空
			if (!"".equals(source_table.trim()) && source_table.trim() != null) {
				if (!"".equals(caliber_descript.trim()) && caliber_descript.trim() != null) {
					reportDao.save(name, desc, user, proc, resp, source_table, caliber_descript);
				} else {
					msg.put("status", "统计口径说明");
				}
			} else {
				msg.put("status", "源表不能为空");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}

	/**
	 * 修改报表
	 * 
	 * 
	 * @param sid
	 * @param name
	 * @param desc
	 * @param user
	 * @param proc
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "{id}", method = RequestMethod.PUT)
	public @ResponseBody
	Map update(@RequestParam int sid, @RequestParam String name, @RequestParam String desc, @RequestParam String user, @RequestParam String proc, @RequestParam String resp, @RequestParam String source_table, @RequestParam String caliber_descript) {
		Map msg = new HashMap();
		msg.put("status", "操作成功");
		try {
			// source_table不能为空
			if (!"".equals(source_table.trim()) && source_table.trim() != null) {
				if (!"".equals(caliber_descript.trim()) && caliber_descript.trim() != null) {
					if (!"".equals(proc.trim()) && proc.trim() != null) {
						reportDao.update(sid, name, desc, user, proc, resp, source_table, caliber_descript);
					} else {
						msg.put("status", "后台程序不能为空");
					}
				} else {
					msg.put("status", "统计口径说明不能为空");
				}
			} else {
				msg.put("status", "源表不能为空");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.put("status", "操作失败");
		}
		return msg;
	}

	public static void main(String[] args) {
		String sql = "select    ZB_NAME ZB, ZB_UNIT UNIT,HB, EZ, ES, HG, HS, JH;";
		System.out.println(sql.substring(0, sql.length()));
	}

}