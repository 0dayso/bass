package com.asiainfo.hbbass.kpiportal.service;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.chart.FusionChartHelper;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.irs.action.ActionMethod;
import com.asiainfo.hbbass.kpiportal.core.KPIAppData;
import com.asiainfo.hbbass.kpiportal.core.KPICustomize;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValue;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueState;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;

/**
 * 目前是BIR用到，这个在重构KPI的View层时，需要修改
 * 
 * @author Mei Kefu
 * @date 2010-3-2
 */
public class KPIPortalAction extends Action {

	private static Logger LOG = Logger.getLogger(KPIPortalAction.class);

	// private static JSONWriter writer = new JSONWriter(false);

	/**
	 * 根据条件查询KPI的属性值，细到一个地域的值，没有传area就是全省的值 根据相同的appName和date查询多个Kpi
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 * 
	 * @date 2010-8-23 修改kpiVal方法名
	 */
	@SuppressWarnings("rawtypes")
	public void getKpisUseAppName(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String appName = request.getParameter("appName");
		String area = request.getParameter("area");
		String date = request.getParameter("date");
		String zbCodes = request.getParameter("zbcode");

		if ("default".equalsIgnoreCase(zbCodes)) {
			String userid = (String) request.getSession().getAttribute("loginname");
			zbCodes = KPICustomize.getUserCustomizeKpiToString(userid, appName);
		}

		KPIEntityValueState state = (KPIEntityValueState) KPIEntityValueState.parse(KPIEntityValueState.class, request);
		LOG.debug("appName" + appName + " zbCodes" + zbCodes + " date" + date + " area" + area + " state" + state);
		List list = KPIPortalViewJsonService.getKpisUseAppName(appName, zbCodes, date, area, state);

		String res = JsonHelper.getInstance().write(list);
		LOG.debug(res);
		response.getWriter().print(res);
	}

	@SuppressWarnings("rawtypes")
	@ActionMethod(isLog = false)
	public void customizeKpis(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT);

		String userid = (String) request.getSession().getAttribute("loginname");

		List kpis = (List) sqlQuery.query("select kpiid zbcode,kpiapplication appname from KPIPORTAL_CUSTOMIZE where USERID='" + userid + "' with ur");
		KPIEntityValueState state = (KPIEntityValueState) KPIEntityValueState.parse(KPIEntityValueState.class, request);
		List result = oriGetKpis(kpis, state);

		String res = result != null ? JsonHelper.getInstance().write(result) : "[]";
		LOG.debug(res);
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(res);
	}

	@SuppressWarnings("rawtypes")
	@ActionMethod(isLog = false)
	protected List oriGetKpis(List kpis, KPIEntityValueState state) {
		return KPIPortalViewJsonService.getKpis(kpis, state);
	}

	/**
	 * 返回多个KPIEntity，支持不同的appName，
	 * 以前的不支持不同的appName和date，现在改成每个KPIEntity的有独立的appName与date
	 * 
	 * @param : request.kpis 多个KPIEntity的取值属性 的字符串
	 *        [{appname:"",zbcode:"",date:""}] appname 和 zbcode 都小写
	 * @param ：request.appName 共同的appName如果单独的kpi中有这个属性就用独立的，没用使用通用的
	 * @param ：request.date 共同的date如果单独的kpi中有这个属性就用独立的，没用使用通用的
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void getKpis(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String appName = request.getParameter("appName");
		String area = request.getParameter("area");
		String date = request.getParameter("date");
		KPIEntityValueState state = (KPIEntityValueState) KPIEntityValueState.parse(KPIEntityValueState.class, request);
		String kpiStr = request.getParameter("kpis");

		Object obj = JsonHelper.getInstance().read(kpiStr);
		List result = null;
		if (obj instanceof List) {
			List kpis = (List) obj;

			for (int i = 0; i < kpis.size(); i++) {

				Map map = (Map) kpis.get(i);

				if (appName != null && appName.length() > 0) {// 把默认值赋上
					String _appName = (String) map.get("appname");

					if (_appName == null || _appName.length() == 0) {
						map.put("appname", appName);
					}
				}

				if (date != null && date.length() > 0) {// 把默认值赋上
					String _date = (String) map.get("date");

					if (_date == null || _date.length() == 0) {
						map.put("date", _date);
					}
				}

				if (area != null && area.length() > 0) {// 把默认值赋上
					String _area = (String) map.get("area");

					if (_area == null || _area.length() == 0) {
						map.put("area", _area);
					}
				}

			}
			result = oriGetKpis(kpis, state);
		}

		String res = result != null ? JsonHelper.getInstance().write(result) : "[]";
		LOG.debug(res);
		response.getWriter().print(res);
	}

	/**
	 * 返回的是xml(fusionChart约定的格式)
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void chartCompare(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String appName = request.getParameter("appName");
		String zbCode = request.getParameter("zbcode");
		String regionIds = request.getParameter("area");
		String timeStart = request.getParameter("durafrom");
		String timeEnd = request.getParameter("durato");
		String zoomin = request.getParameter("zoomin");

		KPIEntity kpiEntity = KPIPortalService.getKPI(appName, KPIPortalService.getKPIAppData(appName).getCurrent(), zbCode);
		KPIEntityValueState state = (KPIEntityValueState) KPIEntityValueState.parse(KPIEntityValueState.class, request);

		// List list =
		// KPIPortalViewJsonService.getOrginCompareList(kpi,area,state,durafrom,durato);
		Map map = kpiEntity.getKpiEntityLoad().loadDuring(regionIds, state, timeStart, timeEnd);
		List list = new ArrayList();// 比较图形 ，返回的是fusionChartHelper约定的list格式
		for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();
			Map innerMap = (Map) entry.getValue();
			String[] lines = new String[innerMap.size() * 2 + 1];
			lines[0] = (String) entry.getKey();
			int j = 0;
			for (Iterator iterator2 = innerMap.entrySet().iterator(); iterator2.hasNext();) {
				Map.Entry innerEntry = (Map.Entry) iterator2.next();
				lines[j * 2 + 1] = (String) innerEntry.getKey();
				// lines[j*2+2]=KPIPortalContext.DECIMAL_FORMAT.format(((Double)innerEntry.getValue()).doubleValue());
				KPIEntityValue value = (KPIEntityValue) innerEntry.getValue();
				lines[j * 2 + 2] = KPIPortalContext.DECIMAL_FORMAT.format(value.getCurrentValue(state));// 20091229修改，
				j++;
			}
			list.add(lines);
		}

		FusionChartHelper.Options options = new FusionChartHelper.Options();
		options.setCaption(kpiEntity.getName());
		options.setValueType(kpiEntity.getKpiMetaData().getFormatType());
		if ("true".equalsIgnoreCase(zoomin)) {
			options.setShowValues("1");
			options.setShowNames("1");
		}
		String result = FusionChartHelper.chartMultiCol(list, options);
		LOG.debug(result);

		response.getWriter().print(result);
	}

	/**
	 * 返回一类KPI的默认当前时间
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	public void currentDate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String appName = request.getParameter("appName");

		KPIAppData kpiAppData = KPIPortalService.getKPIAppData(appName);

		response.getWriter().print(kpiAppData.getCurrent());
	}

	/**
	 * 返回fusionChart用的柱状图
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings("rawtypes")
	public void chartView(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String appName = request.getParameter("appName");
		String area = request.getParameter("area");
		String date = request.getParameter("date");
		if (date == null || date.length() == 0)// 如果传来的date为空就默认为current
			date = KPIPortalService.getKPIAppData(appName).getCurrent();
		String zbcode = request.getParameter("zbcode");
		String valuetype = request.getParameter("valuetype");
		String link = request.getParameter("link");
		KPIEntityValueState state = (KPIEntityValueState) KPIEntityValueState.parse(KPIEntityValueState.class, request);
		boolean detailoffice = Boolean.valueOf(request.getParameter("detailoffice")).booleanValue();

		String userid = (String) request.getSession().getAttribute("loginname");

		String cum = zbcode;
		if ("default".equalsIgnoreCase(zbcode))
			cum = KPICustomize.getUserCustomizeKpiToString(userid, appName);

		KPIEntity kpiEntity = (KPIEntity) KPIPortalService.getFirstKPI(appName, date, cum);
		if (kpiEntity == null) {
			cum = KPICustomize.getUserCustomizeKpiToString(userid, appName);
			kpiEntity = (KPIEntity) KPIPortalService.getFirstKPI(appName, date, cum);
		}
		if (kpiEntity == null)
			return;
		String namepostfix = "";
		String nameprefix = "";
		String result = null;

		if ("pre".equalsIgnoreCase(valuetype))
			nameprefix = date.length() == 8 ? "前日 " : "上月 ";
		else if ("before".equalsIgnoreCase(valuetype))
			nameprefix = date.length() == 8 ? "上月同期 " : "去年同期 ";
		else if ("year".equalsIgnoreCase(valuetype))
			nameprefix = "去年同期 ";
		else if ("huanbi".equalsIgnoreCase(valuetype))
			namepostfix = " 环比增长";
		else if ("tongbi".equalsIgnoreCase(valuetype))
			namepostfix = date.length() == 8 ? " 月同比增长" : " 同比增长";
		else if ("yeartongbi".equalsIgnoreCase(valuetype))
			namepostfix = " 年同比增长";
		else if ("progress".equalsIgnoreCase(valuetype)) {
			nameprefix = date.length() == 8 ? "当日 " : "当月 ";
			namepostfix = " 的进度";
		} else
			nameprefix = date.length() == 8 && !"K10001".equalsIgnoreCase(zbcode) ? "当日 " : "当月 ";

		// TODO在网格化中屏蔽
		// if(area.length()>5)namepostfix += " 前10名";

		DecimalFormat DECIMAL_FORMAT = new DecimalFormat("0.#");

		FusionChartHelper.Options options = new FusionChartHelper.Options();
		options.setCaption(nameprefix + kpiEntity.getName() + namepostfix);
		options.setShowNames(area.length() > 5 ? "0" : "1");
		options.setValueType(kpiEntity.getKpiMetaData().getFormatType());
		if ("progress".equalsIgnoreCase(valuetype)) {
			String sTarget = "100";
			if ("percent".equalsIgnoreCase(kpiEntity.getKpiMetaData().getFormatType())) {
				sTarget = String.valueOf(kpiEntity.getKpiMetaData().getTargetValue() * 100);
			} else if ("increase".equalsIgnoreCase(kpiEntity.getKpiMetaData().getTargetType())) {
				double target = 0d;
				if (date.length() == 8) {
					Calendar c = new GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, 1);
					c.add(Calendar.MONTH, 1);
					c.add(Calendar.DATE, -1);
					target = Integer.parseInt(date.substring(6, 8)) * 100d / c.get(Calendar.DATE);
				} else {
					target = Integer.parseInt(date.substring(4, 6)) * 100d / 12;
				}
				sTarget = DECIMAL_FORMAT.format(target);
				options.setTrendlinesDisplayValue("时间进度");
			} else if ("increaseYear".equalsIgnoreCase(kpiEntity.getKpiMetaData().getTargetType())) {
				double target = 0d;
				if (date.length() == 8) {
					Calendar c = new GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, Integer.parseInt(date.substring(6, 8)));
					c.get(Calendar.DAY_OF_YEAR);
					target = c.get(Calendar.DAY_OF_YEAR) * 100d / 365;
					sTarget = DECIMAL_FORMAT.format(target);
				} else {
					target = Integer.parseInt(date.substring(4, 6)) * 100d / 12;
				}
				sTarget = DECIMAL_FORMAT.format(target);
				options.setTrendlinesDisplayValue("时间进度");
			} else if ("KCT001".equalsIgnoreCase(kpiEntity.getId())) {// 开门红收入写死
				double target = Integer.parseInt(date.substring(6, 8));
				if ("02".equalsIgnoreCase(date.substring(4, 6))) {
					target += 31;
				}

				if ("01".equalsIgnoreCase(date.substring(4, 6))) {
					target += 31;
				}

				if (Integer.parseInt(kpiEntity.getId()) >= 20100228) {
					target = 100;
				} else {
					target = target * 100d / 90;
				}
				sTarget = DECIMAL_FORMAT.format(target);
				options.setTrendlinesDisplayValue("时间进度");
			}

			options.setValueType("percent");
			options.setNumDivLines("2");
			options.setColorStyle("order");
			options.setTrendlinesValue(sTarget);
			result = FusionChartHelper.chartNormal(getChartList(kpiEntity, area, date, state, valuetype, null), options);
		} else if (valuetype.endsWith("bi")) {
			options.setValueType("percent");
			// 20091224增加同环比的考核目标
			if (kpiEntity.getKpiMetaData().getCompTargetValue() != 0) {
				options.setTrendlinesValue(String.valueOf(kpiEntity.getKpiMetaData().getCompTargetValue() * 100));
			}

			if (detailoffice) {
				options.setShowNames("0");
			} else {
				options.setColorStyle("order");
				List list = getChartList(kpiEntity, area, date, state, valuetype, link);
				if (link != null && link.length() > 0) {
					options.setShowValues("1");
					if ("HB".equalsIgnoreCase(area)) {
						options.setSetElement(new String[] { "name", "value", "defaultColor", "link" });
						for (int i = 0; i < list.size(); i++) {
							String[] line = (String[]) list.get(i);
							line[3] = "JavaScript:linkCity(\"" + line[3] + "\")";
						}
					}
				}
				result = FusionChartHelper.chartNormal(list, options);
			}
		} else {
			List list = null;
			if (detailoffice) {
			
				options.setShowNames("0");
			} else
				list = getChartList(kpiEntity, area, date, state, valuetype, null);

			result = FusionChartHelper.chartColLineDY(list, options);
		}
		LOG.debug(result);
		response.getWriter().print(result);
	}

	/**
	 * 图形用生成fusionchart使用的list
	 * 
	 * @param kpiEntity
	 * @param area
	 * @param date
	 * @param valuetype
	 * @param link
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static List getChartList(KPIEntity kpiEntity, String area, String date, KPIEntityValueState state, String valuetype, String link) {

		List list = new ArrayList();

		/*
		 * if (area.length() > 5) { String[] zbcode = {kpiEntity.getId()};
		 * KpiEntryContainer.updateOffice(area, zbcode, date); }
		 */
		if (kpiEntity == null) {
			LOG.warn("kpiEntity 为空");
			return list;
		}
		KPIEntity.Entity entity = KPIPortalService.getKPIEntity(kpiEntity, area);
		if (entity == null) {
			LOG.warn("entity 为空");
			return list;
		}
		KPIEntity.Entity[] newlist = entity.getOrderChildren(valuetype);

		String[] arr = null;

		for (int i = 0; newlist != null && i < newlist.length; i++) {
			KPIEntity.Entity entry = (KPIEntity.Entity) newlist[i];
			// entry.setState(state);
			if (link != null && link.length() > 0) {
				arr = new String[4];
				arr[3] = entry.getKey();
			} else
				arr = new String[3];
			arr[0] = entry.getName();
			arr[2] = "--".equalsIgnoreCase(entry.getTarget()) ? null : entry.getTarget();
			if ("pre".equalsIgnoreCase(valuetype))
				arr[1] = KPIPortalContext.DECIMAL_FORMAT.format(entry.getPreValue(state));
			else if ("before".equalsIgnoreCase(valuetype))
				arr[1] = KPIPortalContext.DECIMAL_FORMAT.format(entry.getBeforeValue(state));
			else if ("year".equalsIgnoreCase(valuetype))
				arr[1] = KPIPortalContext.DECIMAL_FORMAT.format(entry.getYearValue(state));
			else if ("huanbi".equalsIgnoreCase(valuetype))
				arr[1] = entry.getHuanBi() + "";
			else if ("tongbi".equalsIgnoreCase(valuetype))
				arr[1] = entry.getTongBi() + "";
			else if ("yeartongbi".equalsIgnoreCase(valuetype))
				arr[1] = entry.getYearTongBi() + "";
			// 20091223如果类型是占比的直接返回当前的值
			else if ("progress".equalsIgnoreCase(valuetype) && !"percent".equalsIgnoreCase(kpiEntity.getKpiMetaData().getFormatType()))
				arr[1] = entry.getProgress();
			else
				arr[1] = KPIPortalContext.DECIMAL_FORMAT.format(entry.getCurrentValue(state));
			list.add(arr);
		}

		return list;
	}
	
	/**
	 * @date 2013-05-20
	 * @author yulei3
	 * @see 适应新版kpi改造定制kpi
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@ActionMethod(isLog = false)
	public void customizeKpisNew(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON, "web", false);
		String userid = (String) request.getSession().getAttribute("loginname");
		
		String groupName=request.getParameter("groupName");
		
		Object kpis = sqlQuery.query("select kpi_id id from kpi_customize where user_id='"+userid+"' and kpi_id in (select id from FPF_IRS_INDICATOR where appname='"+groupName+"')");
		
		response.setCharacterEncoding("UTF-8");
		response.getWriter().print(kpis);
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		

	}

}
