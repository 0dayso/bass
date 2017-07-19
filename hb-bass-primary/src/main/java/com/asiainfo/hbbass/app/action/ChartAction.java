package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValue;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityValueState;
import com.asiainfo.hbbass.kpiportal.service.KPIPortalService;

@SuppressWarnings("unused")
public class ChartAction extends Action {
	private static Logger LOG = Logger.getLogger(ChartAction.class);

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void getDataMonth(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		/* 计算出开始和结束日期 */
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, -1);
		DateFormat formater = new SimpleDateFormat("yyyyMM");
		String endDate = formater.format(calendar.getTime());
		calendar.add(Calendar.MONTH, -5);
		String startDate = formater.format(calendar.getTime());

		// SQLQuery sqlQuery =
		// SQLQueryContext.getInstance().getSQLQuery("json","web",false);
		// 不判断zbcode为空的情况,但应该判断
		String[] zbcodes = request.getParameter("zbcode").split(",");

		List finalList = new ArrayList();
		for (int i = 0; i < zbcodes.length; i++) {
			KPIEntity kpiEntity = KPIPortalService.getKPI("CollegeM", null, zbcodes[i]);
			Map map = kpiEntity.getKpiEntityLoad().loadDuring("'HB'", null, startDate, endDate);
			System.out.println(map);
			Map zbcodeInfo = new HashMap();
			zbcodeInfo.put("zbcode", zbcodes[i]);
			List valuesList = new ArrayList();
			for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();
				Map innerMap = (Map) entry.getValue();
				KPIEntityValue value = (KPIEntityValue) innerMap.get("全省");

				Map values = new HashMap();

				values.put("key", entry.getKey());
				values.put("value", value.getCurrentValue(null));
				valuesList.add(values);

			}
			zbcodeInfo.put("values", valuesList);
			finalList.add(zbcodeInfo);
		}
		String result = JsonHelper.getInstance().write(finalList);
		LOG.debug(result);
		response.getWriter().print(result);

	}

	public static void main(String[] args) throws Exception {
		// String[] a = "abcde".split("z");
		// System.out.println(a.length); // 1 是我想要的
	}

	@SuppressWarnings("rawtypes")
	public void testKPI(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String zbcode = "CMC001";
		String startDate = "201001";
		String endDate = "201006";
		KPIEntity kpiEntity = KPIPortalService.getKPI("CollegeM", null, zbcode);
		Map map = kpiEntity.getKpiEntityLoad().loadDuring("'HB'", null, startDate, endDate);
		System.out.println(map);
	}
}
