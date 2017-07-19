package com.asiainfo.hb.bass.data;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.asiainfo.hb.bass.data.model.Kpi;
import com.asiainfo.hb.bass.data.service.KpiService;
import com.asiainfo.hb.core.models.JsonHelper;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/conf/spring/*.xml" })
public class KpiTest {

	public Logger logger = LoggerFactory.getLogger(KpiTest.class);

	@Autowired
	KpiService kpiService;

	String kpiId = "ACD005L00715";
	String op_time = "20160811";
	String dimId = "PROV_ID";
	String dimValue = "HB";

	// @Test
	// public void testKpiDef() {
	// String kpiId = "DCD005L01500";
	// String op_time = "20170228";
	// String dimId = "PROV_ID";
	// String dimValue = "HB";
	//// String dimId = "CITY_ID";
	//// String dimValue = "HB.WH";
	// List<KpiDef> kpiDefList = kpiService.getDefAll();
	// if (kpiDefList != null && kpiDefList.size() > 0) {
	// logger.debug("kpiDefList:" + kpiDefList.size());
	// logger.debug(JsonHelper.getInstance().write(kpiDefList.get(0)));
	// }
	//
	// KpiDef kpiDef = kpiService.getKpiDefById(kpiId);
	// logger.debug("kpiDef:" + kpiDef);
	//
	// }

	@SuppressWarnings("unused")
	@Test
	public void testGetKpi() {
		String kpiCode = "MCD005L01500";
		//String kpiCode = "MCD005L00001";
		
		String opTime = "201703";
		String dimCode = "PROV_ID";
		String dimVal = "HB";
		// String dimCode = "CITY_ID";
		// String dimVal = "HB.WH";
		// String dimCode = "COUNTY_ID";
		// String dimVal = "HB.WH.02";

		List<Kpi> kpiList = null;
		try {
			kpiList = kpiService.getKpiByIndicatorMenuId("2113000", opTime, dimCode, dimVal);
			if (kpiList != null) {
				System.out.println(kpiList.get(0).getSql());
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		logger.debug("查到的KPI数据是:" + JsonHelper.getInstance().write(kpiList));
	}

}
