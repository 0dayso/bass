package com.asiainfo.hbbass.irs.report.core;

/**
*
* @author Mei Kefu
* @date 2009-7-25
*/
public class ReportContext {
	
	private static ReportContext context = new ReportContext();
	
	private ReportContainer container = null;
	
	private ReportContext(){
		container = new ReportContainerImpl();
	}
	
	public static ReportContext getInstance(){
		return context;
	}

	public ReportContainer getContainer() {
		return container;
	}

	public void setContainer(ReportContainer container) {
		this.container = container;
	}
	
	
	
}
