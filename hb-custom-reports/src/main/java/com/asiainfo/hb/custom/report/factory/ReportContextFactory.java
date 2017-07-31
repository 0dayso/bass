package com.asiainfo.hb.custom.report.factory;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

import com.asiainfo.hb.custom.report.models.ReportInfo;
import com.asiainfo.hb.custom.report.service.CustomReportService;

public class ReportContextFactory {
	
	private static Logger logger = Logger.getLogger(ReportContextFactory.class);
	
	private static String REPORT_ID;
	
	private List<ReportInfo> reportList;

	@Autowired
	private CustomReportService customReportService;
	public static Map<String, String> indicatorMenuMap = null;
	
	//select * from st.KPI_COMP_CD005_D_VERTICAL d where d.dim_code='city_id';
	//select * from st.KPI_COMP_CD005_M_VERTICAL m where m.DIM_CODE ='CITY_ID';
	public void init() {
		//查询所有的指标id与name
		getAllIndicatorMenuInfo();
		
		getReportInfo();
		logger.info("本次共加载了:" +indicatorMenuMap.size()+"条指标配置数据" );
	}
	
	private void getReportInfo() {
		reportList = customReportService.getReportList(REPORT_ID);
	}

	/**
	 * 查询所有的指标id与name
	 */
	private void getAllIndicatorMenuInfo() {
		if(indicatorMenuMap==null || indicatorMenuMap.size()==0) {
			indicatorMenuMap = customReportService.getIndicatorMenus();
		}
	}


	public static ReportContextFactory getInstance(String reportId) {
		
		if(StringUtils.isNotBlank(reportId)) {
			REPORT_ID = reportId;
		}else {
			throw new RuntimeException("The reportId is not allow null");
		}
		return ReportContextInner.instance;
	}
	
	private static class ReportContextInner{
		private static ReportContextFactory instance = new ReportContextFactory();
	}
	private ReportContextFactory() {
	
	}
}
