package com.asiainfo.bass.apps.controllers;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.asiainfo.bass.apps.models.Report;
import com.asiainfo.bass.apps.models.ReportDao;
import com.asiainfo.bass.components.models.FileManage;
import com.asiainfo.bass.components.models.JdbcTemplate;
import com.asiainfo.hb.core.models.JsonHelper;
import com.asiainfo.hb.web.SessionKeyConstants;
import com.asiainfo.hb.web.models.User;

/**
 * 
 * 
 * @author Mei Kefu
 * @date 2009-12-21
 */
@Controller
@RequestMapping(value = "/rptNavi")
@SessionAttributes({SessionKeyConstants.USER})
public class RptNaviController {

	private static Logger LOG = Logger.getLogger(RptNaviController.class);

	@Autowired
	private DataSource dataSource;

	@Autowired
	private DataSource dataSourceDw;

	private JdbcTemplate jdbcTemplate;

	@Autowired
	private FileManage fileManage;

	@Autowired
	private ReportDao reportDao;

	@RequestMapping(value = "{mid}/main", method = RequestMethod.GET)
	public String main(@PathVariable String mid, Model model) {
		/*
		 * Map map = jdbcTemplate.queryForMap(
		 * "select url from FPF_SYS_MENU_ITEM where menuitemid="+sid); String url =
		 * (String)map.get("url"); //先取映射的irs_package_id String
		 * mid=url.substring(url.indexOf("pid=")+4,url.indexOf("pid=")+7);
		 */

		model.addAttribute("res", JsonHelper.getInstance().write(getSubjects(mid)));
		model.addAttribute("data", JsonHelper.getInstance().write(logStat(mid)));

		return "ftl/rptNavi/navi";
	}

	@RequestMapping(value = "{mid}", method = RequestMethod.GET)
	public String render(@PathVariable String mid, Model model) {

		jdbcTemplate = new JdbcTemplate(dataSource);

		@SuppressWarnings("rawtypes")
		Map map = jdbcTemplate.queryForMap("select url from FPF_SYS_MENU_ITEMS where menuitemid=" + mid);
		String url = (String) map.get("url");

		//  写死的部分 先判断是否需要容器，还没有想到好的实现方式
		if (url.indexOf("main.htm") > 0) {
			model.addAttribute("id", mid);
			return "ftl/rptNavi/main";
		} else if (url.startsWith("ftl")) {
			model.addAttribute("mid", mid);
			return url;
		} else {
			return main(mid, model);
		}
	}

	@RequestMapping(value = "{mid}/subs", method = RequestMethod.POST)
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public @ResponseBody
	Map getSubjects(@PathVariable String mid) {
		// {packageName:"",elements:[]}
		/*
		 * elements:[ {subject} ->
		 * {id:"subject_id",name:"",desc:"",kind:"动态,配置,手工",uri:""} ,{package}->
		 * {subjects:[{subject}],id:"package_id",name:"",desc:"",type:"平板"}
		 * ,{package}-> {type:"下拉框",id:"package_id",name:"",desc:""} ]
		 */
		Map result = new HashMap();

		// String
		// sql1="select id,name,desc,sort,type from FPF_IRS_PACKAGE where (PID="+mid+" or id="+mid+") and type!='下线' order by sort,id with ur";

		jdbcTemplate = new JdbcTemplate(dataSource);

		List elementMaps = jdbcTemplate.queryForList("select menuitemid id,menuitemtitle name,sortnum sort,url type from FPF_SYS_MENU_ITEMS where (parentid=? or menuitemid=?) order by sort,id with ur", new Object[] { Integer.valueOf(mid), Integer.valueOf(mid) });

		List elements = new ArrayList();
		// String sql
		// ="select a.id,a.name,value(a.desc,'') desc,uri,mt,kind,sort,a.status from FPF_IRS_SUBJECT a left join (select sid,max(case when code ='URI' then value end) uri,max(case when code ='MaxTime' then value end) mt from FPF_IRS_SUBJECT_EXT where code in ('MaxTime','URI') group by sid) c on a.id=c.sid where a.PID=@id and a.status !='下线' order by sort,id with ur";
		String sql = "select id,name,value(desc,'') desc,kind,value(sort,0) sort,status from FPF_IRS_SUBJECT,FPF_IRS_SUBJECT_MENU_MAP where ID=sid and mid=? and status !='下线' order by sort,id with ur";
		for (int i = 0; i < elementMaps.size(); i++) {
			Map elemMap = (Map) elementMaps.get(i);

			String packageId = String.valueOf(elemMap.get("id"));
			if (packageId.equalsIgnoreCase(mid)) {// 直接挂在顶级package下面的

				List topSubjects = jdbcTemplate.queryForList(sql, new Object[] { Integer.valueOf(packageId) });
				result.put("packageName", elemMap.get("name"));// 顶级package的Name
				for (int j = 0; j < topSubjects.size(); j++) {
					elements.add(topSubjects.get(j));
				}
				/*
				 * }else if("下拉框".equalsIgnoreCase(packageType) &&
				 * !packageId.equalsIgnoreCase(mid)){//下拉框类型
				 * elements.add(elemMap);
				 */
			} else if (!packageId.equalsIgnoreCase(mid)) {// 子package类型
				elemMap.put("subjects", jdbcTemplate.queryForList(sql, new Object[] { Integer.valueOf(packageId) }));
				elements.add(elemMap);
			}
		}

		// 对elements按照顶级packageId的sort来排序，就是挂在顶级package下面的subject和packge混合排序
		for (int i = 0; i < elements.size(); i++) {
			for (int j = elements.size() - 1; j > i; j--) {
				Map map1 = (Map) elements.get(j);
				Map map2 = (Map) elements.get(j - 1);
				int key1 = ((Integer) map1.get("sort")).intValue();
				int key2 = ((Integer) map2.get("sort")).intValue();
				if (key1 < key2) {
					elements.set(j, map2);
					elements.set(j - 1, map1);
				}
			}
		}

		result.put("elements", elements);

		return result;
	}

	@SuppressWarnings("rawtypes")
	protected List logStat(String mid) {

		String sql = " select opername id" + " ,count(case when opertype in ('query','render') and substr(char(create_dt),1,7)=substr(char(current_date),1,7) then loginname else null end) qum"
				+ " ,count(case when opertype='down' and substr(char(create_dt),1,7)=substr(char(current_date),1,7) then loginname else null end) dwm" + " ,count(distinct case when substr(char(create_dt),1,7)=substr(char(current_date),1,7) then loginname else null end) lgm"
				+ " ,count(case when opertype in ('query','render') then loginname else null end) qu,count(case when opertype='down' then loginname else null end)dw" + " ,count(distinct loginname) lg " + " from FPF_VISITLIST inner join FPF_USER_GROUP_MAP on loginname=userid " + " where (track_mid like '%-" + mid + "' or track_mid like '%-" + mid
				+ "-%') and opertype in ('query','render','down') and value(opername,'')!='' and group_id<>'26020'" + " group by opername with ur ";

		LOG.debug("SQL:" + sql);
		jdbcTemplate = new JdbcTemplate(dataSource);
		return jdbcTemplate.queryForList(sql);
	}

	/*
	 *  这个方法应该异步实现 自动注入的userDao和 fileManage和dataSourceDw都可以去掉
	 */
	@RequestMapping(value = "{mid}/down", method = RequestMethod.POST)
	@SuppressWarnings("rawtypes")
	public void down(HttpServletResponse response, @PathVariable String mid, @ModelAttribute("user") User user) {

		Map result = getSubjects(mid);
		String fileName = (String) result.get("packageName");
		List subjects = (List) result.get("elements");
		// String path = System.getProperty("user.dir")+"/";
		// File tempFile = new File(path+fileName+"_打包.xls");
		File tempFile = null;
		try {
			for (int i = 0; i < subjects.size(); i++) {
				Map sub = (Map) subjects.get(i);

				Integer sid = (Integer) sub.get("id");
				try {
					Report report = reportDao.getReportById(sid, user.getCityId(), user);

					String ds = "";
					String fileKind = "excel";

					JdbcTemplate jt = null;
					if ("web".equalsIgnoreCase(ds))
						jt = new JdbcTemplate(dataSource, false);
					else {
						jt = new JdbcTemplate(dataSourceDw, false);
					}
					tempFile = fileManage.executeNotDelete(jt, report.getSql(), fileName, report.getDownHeader(), fileKind, report.getName());

					report = null;

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} finally {
			try {
				fileManage.outFile(response, tempFile);
			} catch (IOException e) {
				e.printStackTrace();
			}
			tempFile.delete();
		}
	}

	@RequestMapping(value = "{mid}/down", method = RequestMethod.GET)
	@SuppressWarnings("rawtypes")
	public void packdown(HttpServletResponse response, @PathVariable String mid, @ModelAttribute("user") User user) {
		Map result = getSubjects(mid);
		String fileName = (String) result.get("packageName");
		List subjects = (List) result.get("elements");
		// String path = System.getProperty("user.dir")+"/";
		// File tempFile = new File(path+fileName+"_打包.xls");
		File tempFile = null;
		try {
			for (int i = 0; i < subjects.size(); i++) {
				Map sub = (Map) subjects.get(i);

				Integer sid = (Integer) sub.get("id");
				try {
					Report report = reportDao.getReportById(sid, user.getCityId(), user);

					String ds = "";
					String fileKind = "excel";

					JdbcTemplate jt = null;
					if ("web".equalsIgnoreCase(ds))
						jt = new JdbcTemplate(dataSource, false);
					else {
						jt = new JdbcTemplate(dataSourceDw, false);
					}
					tempFile = fileManage.executeNotDelete(jt, report.getSql(), fileName, report.getDownHeader(), fileKind, report.getName());

					report = null;

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} finally {
			try {
				fileManage.outFile(response, tempFile);
			} catch (IOException e) {
				e.printStackTrace();
			}
			tempFile.delete();
		}
	}

	/**
	 * 打包下载的job用到该方法
	 * 
	 * @param mid
	 */
	@SuppressWarnings("rawtypes")
	public File down(String mid, String fileName) {

		Map result = getSubjects(mid);
		// String fileName = (String)result.get("packageName");
		List subjects = (List) result.get("elements");
		// String path = System.getProperty("user.dir")+"/";
		// File tempFile = new File(path+fileName+"_打包.xls");
		File tempFile = null;
		try {
			for (int i = 0; i < subjects.size(); i++) {
				Map sub = (Map) subjects.get(i);

				Integer sid = (Integer) sub.get("id");
				try {
					Report report = reportDao.getReportById(sid, "0", null);

					String ds = "";
					String fileKind = "excel";

					JdbcTemplate jt = null;
					if ("web".equalsIgnoreCase(ds))
						jt = new JdbcTemplate(dataSource, false);
					else {
						jt = new JdbcTemplate(dataSourceDw, false);
					}
					tempFile = fileManage.executeNotDelete(jt, report.getSql(), fileName, report.getDownHeader(), fileKind, report.getName());

					report = null;

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} finally {
			// try {
			// fileManage.outFile(response, tempFile);
			// } catch (IOException e) {
			// e.printStackTrace();
			// }
			// tempFile.delete();
		}
		return tempFile;
	}
	
	public File downReport(String sid, String fileName, String time) {

		// String fileName = (String)result.get("packageName");
		// String path = System.getProperty("user.dir")+"/";
		// File tempFile = new File(path+fileName+"_打包.xls");
		File tempFile = null;
		try {

				try {
					Report report = reportDao.getReportById(Integer.parseInt(sid), "0", null);

					String ds = "";
					String fileKind = "excel";

					JdbcTemplate jt = null;
					if ("web".equalsIgnoreCase(ds))
						jt = new JdbcTemplate(dataSource, false);
					else {
						jt = new JdbcTemplate(dataSourceDw, false);
					}
					String sql = report.getSql();
					sql = sql.replaceAll("\\{time\\}", time);
					LOG.info("sql===================="+sql);
					tempFile = fileManage.executeNotDelete(jt, sql, fileName, report.getDownHeader(), fileKind, report.getName());

					report = null;

				} catch (Exception e) {
					e.printStackTrace();
				}
		} finally {
			// try {
			// fileManage.outFile(response, tempFile);
			// } catch (IOException e) {
			// e.printStackTrace();
			// }
			// tempFile.delete();
		}
		return tempFile;
	}

	/*
	 * @RequestMapping(value="{mid}/down",method=RequestMethod.POST) public void
	 * down(HttpServletRequest request,HttpServletResponse
	 * response,@PathVariable String mid,@ModelAttribute("user") User user){
	 * LOG.debug("进入打包下载"); final AsyncContext ctx =
	 * request.startAsync(request,response); ctx.setTimeout(1000*60*60); new
	 * Thread(new
	 * Executor(ctx,reportDao,fileManage,jdbcTemplate,user,mid)).start();
	 * LOG.debug("完成打包下载"); }
	 */
}
/*
 * class Executor implements Runnable { private AsyncContext ctx = null;
 * 
 * private ReportDao reportDao;
 * 
 * private FileManage fileManage;
 * 
 * private JdbcTemplate jdbcTemplate;
 * 
 * private User user;
 * 
 * private String mid;
 * 
 * public Executor(AsyncContext ctx, ReportDao reportDao, FileManage fileManage,
 * JdbcTemplate jdbcTemplate, User user, String mid) { super(); this.ctx = ctx;
 * this.reportDao = reportDao; this.fileManage = fileManage; this.jdbcTemplate =
 * jdbcTemplate; this.user = user; this.mid = mid; }
 * 
 * public void run(){
 * 
 * Map result = getSubjects(mid); String fileName =
 * (String)result.get("packageName"); List subjects =
 * (List)result.get("elements"); //String path =
 * System.getProperty("user.dir")+"/"; //File tempFile = new
 * File(path+fileName+"_打包.xls"); File tempFile = null; try{ for (int i = 0; i <
 * subjects.size(); i++) { Map sub = (Map)subjects.get(i);
 * 
 * Integer sid = (Integer)sub.get("id"); try{ Report report =
 * reportDao.getReportById(sid,user.getRegionId());
 * 
 * String ds = ""; String fileKind = "excel";
 * 
 * tempFile = fileManage.executeNotDelete(report.getSql(),
 * fileName,report.getDownHeader() , ds, fileKind,report.getName());
 * 
 * report=null;
 * 
 * }catch(Exception e){ e.printStackTrace(); } } }finally{ try {
 * fileManage.outFile((HttpServletResponse)ctx.getResponse(), tempFile); } catch
 * (IOException e) { e.printStackTrace(); } ctx.complete(); tempFile.delete(); }
 * }
 * 
 * protected Map getSubjects(String mid){ Map result = new HashMap();
 * 
 * //String
 * sql1="select id,name,desc,sort,type from FPF_IRS_PACKAGE where (PID="+mid
 * +" or id="+mid+") and type!='下线' order by sort,id with ur";
 * 
 * List elementMaps = jdbcTemplate.queryForList(
 * "select menuitemid id,menuitemtitle name,sortnum sort from FPF_SYS_MENU_ITEM where (parentid=? or menuitemid=?) and kind='资源包' order by sort,id with ur"
 * ,new Object[]{Integer.valueOf(mid),Integer.valueOf(mid)});
 * 
 * List elements = new ArrayList(); //String sql =
 * "select a.id,a.name,value(a.desc,'') desc,uri,mt,kind,sort,a.status from FPF_IRS_SUBJECT a left join (select sid,max(case when code ='URI' then value end) uri,max(case when code ='MaxTime' then value end) mt from FPF_IRS_SUBJECT_EXT where code in ('MaxTime','URI') group by sid) c on a.id=c.sid where a.PID=@id and a.status !='下线' order by sort,id with ur"
 * ; String sql =
<<<<<<< .mine
 * "select id,name,value(desc,'') desc,kind,value(sort,0) sort,status from FPF_IRS_SUBJECT,FPF_IRS_SUBJECT_MENU_MAP where ID=sid and mid=? and status !='下线' order by sort,id with ur"
=======
 * "select id,name,value(desc,'') desc,kind,value(sort,0) sort,status from FPF_IRS_SUBJECT,FPF_IRS_SUBJECT_MENU_MAP where ID=sid and mid=? and status !='下线' order by sort,id with ur"
>>>>>>> .r1182
 * ; for (int i = 0; i < elementMaps.size(); i++) { Map elemMap =
 * (Map)elementMaps.get(i);
 * 
 * String packageId=String.valueOf(elemMap.get("id")); //String
 * packageType=(String)elemMap.get("type");
 * if(packageId.equalsIgnoreCase(mid)){//直接挂在顶级package下面的
 * 
 * List topSubjects = jdbcTemplate.queryForList(sql,new
 * Object[]{Integer.valueOf(packageId)}); result.put("packageName",
 * elemMap.get("name"));//顶级package的Name for (int j = 0; j < topSubjects.size();
 * j++) { elements.add(topSubjects.get(j)); } }else
 * if(!packageId.equalsIgnoreCase(mid)){//子package类型 elemMap.put("subjects",
 * jdbcTemplate.queryForList(sql,new Object[]{Integer.valueOf(packageId)}));
 * elements.add(elemMap); } }
 * 
 * //对elements按照顶级packageId的sort来排序，就是挂在顶级package下面的subject和packge混合排序 for(int
 * i=0;i<elements.size();i++){ for(int j=elements.size()-1;j>i;j--){ Map
 * map1=(Map)elements.get(j); Map map2=(Map)elements.get(j-1); int key1 =
 * ((Integer)map1.get("sort")).intValue(); int key2 =
 * ((Integer)map2.get("sort")).intValue(); if(key1<key2){ elements.set(j, map2);
 * elements.set(j-1, map1); } } }
 * 
 * result.put("elements", elements);
 * 
 * return result; } }
 */

