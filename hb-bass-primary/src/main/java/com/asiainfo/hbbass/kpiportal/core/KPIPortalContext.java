package com.asiainfo.hbbass.kpiportal.core;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.component.cache.CacheServerCache;
import com.asiainfo.hbbass.component.cache.CacheServerFactory;

/**
 * 程序执行的上下文,KPI指标的参数信息
 * 
 * @author Mei Kefu
 * 
 */
public class KPIPortalContext {

	private static Logger LOG = Logger.getLogger(KPIPortalContext.class);

	/**
	 * 不同KPI应用的时间参数 [appkey,AppTime]
	 */
	// public static Map KPI_APP = new HashMap();

	/**
	 * 不同KPI应用的元信息 [appkey,<list[KPIMetaData]>]
	 */
	@SuppressWarnings("rawtypes")
	public static Map KPI_META = new HashMap();

	static {
		LOG.info("iii");
		DAILY_FORMAT = new SimpleDateFormat("yyyyMMdd");
		MONTHLY_FORMAT = new SimpleDateFormat("yyyyMM");

		parse();// 这个要先与updateDate();
		updateDate();
	}

	public static void parse() {
		dbParse();
		// xmlParse();
		// System.out.println();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private static void xmlParse() {
		LOG.info("解析XML文件,KPI元数据");
		try {
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			InputStream in = KPIPortalContext.class.getClassLoader().getResourceAsStream("kpiportal.xml");
			Document doc = db.parse(in);
			NodeList apps = doc.getDocumentElement().getElementsByTagName("app");
			Class cls = KPIMetaData.class;
			Field[] fields = cls.getDeclaredFields();
			List list = null;
			Map kpiApp = getKpiApp();
			if (kpiApp == null) {
				kpiApp = new HashMap();
			}
			for (int i = 0; i < apps.getLength(); i++) {
				Element app = (Element) apps.item(i);

				String appName = app.getAttribute("name");
				String appType = app.getAttribute("type");

				KPIAppData kpiAppDate = (KPIAppData) kpiApp.get(appName);
				if (kpiAppDate != null) {
					kpiAppDate.setName(appName);
					kpiAppDate.setAppType(appType);
				} else {
					kpiAppDate = new KPIAppData(appName, appType);
				}
				kpiApp.put(appName, kpiAppDate);// 初始化时间参数

				KPI_META.put(appName, new ArrayList());// 初始化kpi元信息

				NodeList kpis = app.getElementsByTagName("kpi");

				for (int j = 0; j < kpis.getLength(); j++) {
					list = (List) KPI_META.get(appName);

					Element kpi = (Element) kpis.item(j);

					Object obj = null;
					try {
						obj = cls.newInstance();
					} catch (InstantiationException e) {
						e.printStackTrace();
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					}
					for (int m = 0; m < fields.length; m++) {
						try {
							fields[m].setAccessible(true);
							String value = null;
							if (fields[m].getType() == double.class) {
								value = (String) kpi.getAttribute(fields[m].getName());
								if (value.length() > 0) {
									fields[m].setDouble(obj, Double.valueOf(value).doubleValue());
								}
							} else if (fields[m].getType() == String.class) {
								value = (String) kpi.getAttribute(fields[m].getName());
								if (value != null && value.length() > 0)
									fields[m].set(obj, value);
							}
						} catch (NumberFormatException e) {
							e.printStackTrace();
						} catch (IllegalArgumentException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						}
					}
					list.add(obj);
				}
			}

			putKpiApp(kpiApp);
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	public static DecimalFormat DECIMAL_FORMAT = new DecimalFormat("0.####");

	public static DecimalFormat DIGIT2_DECIMAL_FORMAT = new DecimalFormat("0.##");

	public static SimpleDateFormat DAILY_FORMAT = new SimpleDateFormat("yyyyMMdd");

	public static SimpleDateFormat MONTHLY_FORMAT = new SimpleDateFormat("yyyyMM");

	private static Calendar calendar = null;

	/**
	 * 从缓存中取KPI_APP
	 * 
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static Map getKpiApp() {
		CacheServerCache cache = CacheServerFactory.getInstance().getCache("KPI_CONTEXT");
		/*
		 * Map map = cache.getKPIEntities("KPI_APP"); if(map==null){ map = new
		 * HashMap(); }
		 */
		Map map=new HashMap();
		try {
			map=(Map) cache.get("KPI_APP");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return map;
	}

	@SuppressWarnings("rawtypes")
	public static void putKpiApp(Map kpiApp) {
		CacheServerCache cache = CacheServerFactory.getInstance().getCache("KPI_CONTEXT");
		cache.put("KPI_APP", kpiApp);
		LOG.info("放入缓存服务器");
	}

	/**
	 * 重置应用的时间参数
	 * 
	 * @param appName
	 * @param date
	 */
	@SuppressWarnings("rawtypes")
	public synchronized static void resetDate(String appName, String date) {
		Map kpiApp = getKpiApp();
		KPIAppData appData = (KPIAppData) kpiApp.get(appName);
		appData.setCurrent(date);
		String[] dates = calDate(date);
		appData.setPre(dates[0]);
		appData.setBefroe(dates[1]);
		appData.setYear(dates[2]);
		LOG.warn("修改默认时间"+appData.getAppType()+"设置日期为："+date+" 类型为："+appData.getAppType());
		putKpiApp(kpiApp);
	}

	/**
	 * 得到应用的默认时间
	 * 
	 * @param appName
	 * @param date
	 */
	@SuppressWarnings("rawtypes")
	public static String getAppDefaultDate(String appName) {
		Map kpiApp = getKpiApp();
		KPIAppData appData = (KPIAppData) kpiApp.get(appName);
		return appData.getCurrent();
	}

	/**
	 * 只是本类调用，在启动的时候调用
	 */
	@SuppressWarnings("rawtypes")
	private synchronized static void updateDate() {
		Map kpiApp = getKpiApp();
		LOG.info("计算当天日期");
		for (Iterator iterator = kpiApp.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();

			KPIAppData param = (KPIAppData) entry.getValue();
			if (param.getCurrent() == null || param.getCurrent().length() == 0) {
				updateDate((String) entry.getKey());
			}
		}
	}

	/**
	 * 计算日期，如果有先前就有值，就不计算
	 * 
	 * @param appName
	 */
	@SuppressWarnings("rawtypes")
	public synchronized static void updateDate(String appName) {
		Map kpiApp = getKpiApp();
		KPIAppData param = (KPIAppData) kpiApp.get(appName);
		LOG.warn("修改默认时间"+param.getAppType()+"原来日期为："+param.getCurrent()+" 类型为："+param.getAppType());
		if ("monthly".equalsIgnoreCase(param.getAppType())) {
			calendar = GregorianCalendar.getInstance();
			calendar.add(Calendar.DATE, -3);
			calendar.add(Calendar.MONTH, -1);
			param.setCurrent(MONTHLY_FORMAT.format(calendar.getTime()));
			calendar.add(Calendar.YEAR, -1);
			param.setBefroe(MONTHLY_FORMAT.format(calendar.getTime()));

			calendar = GregorianCalendar.getInstance();
			calendar.add(Calendar.DATE, -3);
			calendar.add(Calendar.MONTH, -2);
			param.setPre(MONTHLY_FORMAT.format(calendar.getTime()));
		} else {
			calendar = GregorianCalendar.getInstance();
			calendar.add(Calendar.DATE, -1);
			param.setCurrent(DAILY_FORMAT.format(calendar.getTime()));
			int nYear = calendar.get(Calendar.YEAR);
			int nMonth = calendar.get(Calendar.MONTH) + 1;
			int nDate = calendar.get(Calendar.DATE);
			if (nDate == 30 && (nMonth == 4 || nMonth == 6 || nMonth == 9 || nMonth == 11)) {
				calendar.add(Calendar.MONTH, -1);
				calendar.add(Calendar.DATE, 1);
				param.setBefroe(DAILY_FORMAT.format(calendar.getTime()));
			} else if (nMonth == 2 && ((nDate == 29) || ((!(nYear % 4 == 0 && nYear % 100 != 0 || nYear % 400 == 0))) && nDate == 28)) {
				param.setBefroe(new SimpleDateFormat("yyyy").format(calendar) + "0131");
			} else {
				calendar.add(Calendar.MONTH, -1);
				param.setBefroe(DAILY_FORMAT.format(calendar.getTime()));
			}
			calendar = GregorianCalendar.getInstance();
			calendar.add(Calendar.DATE, -2);
			param.setPre(DAILY_FORMAT.format(calendar.getTime()));
			calendar.add(Calendar.DATE, 1);
			calendar.add(Calendar.YEAR, -1);
			param.setYear(DAILY_FORMAT.format(calendar.getTime()));
		}
		LOG.warn("修改后的默认时间为："+param.getCurrent()+" 类型为："+param.getAppType());
		putKpiApp(kpiApp);
	}

	public static String[] calDate(String date) {
		String[] dates = { "0", "0", "0" };
		if (date.length() == 8) {
			Calendar c = new GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, Integer.parseInt(date.substring(6, 8)));

			c.add(Calendar.DATE, -1);
			dates[0] = DAILY_FORMAT.format(c.getTime());
			c.add(Calendar.DATE, 1);
			c.add(Calendar.YEAR, -1);
			dates[2] = DAILY_FORMAT.format(c.getTime());

			c = new GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, Integer.parseInt(date.substring(6, 8)));
			int nYear = c.get(Calendar.YEAR);
			int nMonth = c.get(Calendar.MONTH) + 1;
			int nDate = c.get(Calendar.DATE);
			if (nDate == 30 && (nMonth == 4 || nMonth == 6 || nMonth == 9 || nMonth == 11)) {
				c.add(Calendar.MONTH, -1);
				c.add(Calendar.DATE, 1);
				dates[1] = DAILY_FORMAT.format(c.getTime());
			} else if (nMonth == 2 && ((nDate == 29) || ((!(nYear % 4 == 0 && nYear % 100 != 0 || nYear % 400 == 0))) && nDate == 28)) {
				dates[1] = date.substring(0, 4) + "0131";
			} else {
				c.add(Calendar.MONTH, -1);
				dates[1] = DAILY_FORMAT.format(c.getTime());
			}
		} else if (date.length() == 6) {
			Calendar c = new GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, 1);
			c.add(Calendar.MONTH, -1);
			dates[0] = MONTHLY_FORMAT.format(c.getTime());

			c = new GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, 1);
			c.add(Calendar.YEAR, -1);
			dates[1] = MONTHLY_FORMAT.format(c.getTime());
			dates[2] = "0";
		}
		return dates;
	}

	public static void main(String[] args) {
		new KPIPortalContext();
		xmlParse();
	}

	/**
	 * 从数据库解析FPF_IRS_INDICATOR 2010-3-7
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static void dbParse() {

		LOG.info("从数据库解析FPF_IRS_INDICATOR,KPI元数据");
		String sql = "select id,name,appName,instruction,kind,unit,division,targetvalue,targettype,comptargetvalue,loadclassname,formattype,arithmetic,originids,filterclassname,expRules from FPF_IRS_INDICATOR where state!='作废' order by appName,sort,id with ur";
	
		KPI_META.clear();
		Connection conn = null;
		try {
			conn = ConnectionManage.getInstance().getWEBConnection();
			Statement stat = conn.createStatement();

			ResultSet rs = stat.executeQuery(sql);

			Class cls = KPIMetaData.class;
			Field[] fields = cls.getDeclaredFields();
			Map kpiApp = getKpiApp();
			if (kpiApp == null) {
				kpiApp = new HashMap();
			}
			while (rs.next()) {

				String appName = rs.getString("appName");
				String appType = appName.endsWith("D") ? "daily" : "monthly";

				List appList = null;
				if (KPI_META.containsKey(appName)) {
					appList = (List) KPI_META.get(appName);
				} else {
					appList = new ArrayList();
					KPI_META.put(appName, appList);

				}

				KPIAppData kpiAppDate = (KPIAppData) kpiApp.get(appName);
				if (kpiAppDate != null) {
					kpiAppDate.setName(appName);
					kpiAppDate.setAppType(appType);
				} else {
					kpiAppDate = new KPIAppData(appName, appType);
				}
				kpiApp.put(appName, kpiAppDate);// 初始化时间参数

				KPIMetaData obj = new KPIMetaData();

				for (int m = 0; m < fields.length; m++) {
					if (fields[m].getModifiers() == 2)
						try {
							fields[m].setAccessible(true);
							String value = null;
							if (fields[m].getType() == double.class) {
								value = (String) rs.getString(fields[m].getName());
								if (value.length() > 0) {
									fields[m].setDouble(obj, Double.valueOf(value).doubleValue());
								}
							} else if (fields[m].getType() == String.class) {
								value = (String) rs.getString(fields[m].getName());
								if (value != null && value.length() > 0)
									fields[m].set(obj, value);
							}
						} catch (NumberFormatException e) {
							e.printStackTrace();
						} catch (IllegalArgumentException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						}
				}
				appList.add(obj);
			}

			putKpiApp(kpiApp);

		} catch (SQLException e) {
			LOG.info("错误"+e);
			e.printStackTrace();
		} finally {
			LOG.info("永远都执行");
			ConnectionManage.getInstance().releaseConnection(conn);
		}
	}

}
