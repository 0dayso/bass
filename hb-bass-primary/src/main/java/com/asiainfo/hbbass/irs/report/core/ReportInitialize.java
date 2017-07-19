package com.asiainfo.hbbass.irs.report.core;

import org.apache.log4j.Logger;

/**
*
* @author Mei Kefu
* @date 2009-7-25
*/
public class ReportInitialize {
	
	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(ReportInitialize.class);
	
	public static void initialize(){
		
		/*Report report = new Report();
		
		report.setKey("1101");
		report.setName("电信C网189发展情况");
		report.setTableName("pt.report_fact");
		
		Report.Dimension[] dimensions = new Report.Dimension[3];
		
		Report.Dimension dimension = new Report.Dimension();
		
		dimension.dbName="col1";
		dimension.dbType="varchar";
		dimension.name="地市";
		dimension.dataSource="component:city";
		dimension.dbParseType="condition";
		
		dimensions[0]=dimension;
		
		dimension = new Report.Dimension();
		dimension.dbName="time_id";
		dimension.dbType="int";
		dimension.name="统计周期";
		dimension.dataSource="component:date";
		dimension.dbParseType="condition";
		
		dimensions[1]=dimension;
		
		dimension = new Report.Dimension();
		dimension.dbName="reportcode";
		dimension.dbType="varchar";
		dimension.name="";
		dimension.value="HOT-RIVAL-189";
		dimension.dbParseType="condition";
		
		dimensions[2]=dimension;
		
		report.setDimensions(dimensions);
		
		Report.Header[] headers = new Report.Header[5];
		
		Report.Header header = new Report.Header();
		header.name = "地域";
		header.dbName = "substr(col1,1,5) as city";
		header.dataIndex = "city";
		header.dimMapping="city";
		
		headers[0]=header;
		
		header = new Report.Header();
		header.name = "新增用户数";
		header.dbName = "sum(int(col3)) as nu";
		header.dataIndex = "nu";
		
		headers[1]=header;
		
		header = new Report.Header();
		header.name = "累计新增用户数";
		header.dbName = "sum(int(col4)) as ljnu";
		header.dataIndex = "ljnu";
		
		headers[2]=header;
		
		header = new Report.Header();
		header.name = "通话用户数";
		header.dbName = "sum(int(col5)) as u";
		header.dataIndex = "u";
		
		headers[3]=header;
		
		header = new Report.Header();
		header.name = "累计通话用户数";
		header.dbName = "sum(int(col6)) as lju";
		header.dataIndex = "lju";
		
		headers[4]=header;
		
		report.setHeaders(headers);
		ReportContext.getInstance().getContainer().put(report.getKey(), report);*/
	}
}
