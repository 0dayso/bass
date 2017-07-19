package com.asiainfo.hbbass.app.action;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.component.ppt.ConstForPptDownload;
import com.asiainfo.hbbass.irs.action.Action;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.service.KPIPortalService;

/**
 * 
 * 指标导出成PPT
 * 
 * @author lizhijian
 * @date 2010-03-22
 */
public class IndiToPptAction extends Action {

	private static Logger LOG = Logger.getLogger(IndiToPptAction.class);

	@SuppressWarnings("unused")
	private JsonHelper jsonHelper = JsonHelper.getInstance();

	/**
	 * 批量指标导出成PPT
	 * 
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked", "unused" })
	public void transfer(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		LOG.info("指标导出PPT开始!");
		String appName = request.getParameter("appName");
		String date = request.getParameter("date");
		String ids = request.getParameter("ids");

		String fileName = ConstForPptDownload.fileFolder + System.currentTimeMillis() + ".ppt";

		if (appName == null || "".equals(appName)) {
			appName = "ChannelD";
		}
		if (date == null || "".equals(date)) {
			date = "20100316";
		}
		if (ids == null || "".equals(ids)) {
			ids = "K10005,K11006,KC0001,K10006,K10002";
		}

		String zbCode = "";

		String[] idArrs = new String[1];
		if (ids != null && !"".equals(ids.trim())) {
			idArrs = ids.split(",");
		}

		List<KPIEntity> kpiList = new ArrayList();
		for (int i = 0; i < idArrs.length; i++) {
			zbCode = idArrs[i];

			// 取得KPIEntity
			KPIEntity kpi = KPIPortalService.getKPI(appName, date, zbCode);

			kpiList.add(kpi);
		}

		try {
			//DownloadPpt.download(fileName, kpiList, response);
		} catch (Exception e) {
			e.printStackTrace();
		}

		LOG.info("指标导出PPT成功!");
	}

}
