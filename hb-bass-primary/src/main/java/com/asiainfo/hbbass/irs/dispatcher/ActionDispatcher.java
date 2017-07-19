package com.asiainfo.hbbass.irs.dispatcher;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.cglib.reflect.FastClass;
import net.sf.cglib.reflect.FastMethod;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.irs.action.Action;

/**
 *
 * @author Mei Kefu
 * @date 2009-9-15
 */
@SuppressWarnings("unchecked")
public class ActionDispatcher extends BaseDispatcher {

	private static Logger LOG = Logger.getLogger(ActionDispatcher.class);
	
	@SuppressWarnings("rawtypes")
	private static Map actionClasses = new HashMap();
	
	static{
		try {
			actionClasses.put("chartdata", FastClass.create(Class.forName("com.asiainfo.hbbass.common.action.ChartDataAction")));
			actionClasses.put("jsondata", FastClass.create(Class.forName("com.asiainfo.hbbass.common.action.JsonDataAction")));
			actionClasses.put("dynamicrpt", FastClass.create(Class.forName("com.asiainfo.hbbass.kpiportal.report.DynamicReportAction")));
			actionClasses.put("staticrpt", FastClass.create(Class.forName("com.asiainfo.hbbass.kpiportal.report.StaticReportAction")));
			actionClasses.put("filemanage", FastClass.create(Class.forName("com.asiainfo.hbbass.common.action.FileManageAction")));
			actionClasses.put("frame", FastClass.create(Class.forName("com.asiainfo.hbbass.frame.FrameAction")));
			actionClasses.put("scheduler", FastClass.create(Class.forName("com.asiainfo.hbbass.component.scheduler.SchedulerAction")));
			actionClasses.put("rptNavi", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.RptNaviAtion")));
			//actionClasses.put("log", FastClass.create(Class.forName("com.asiainfo.hbbass.common.action.LogService")));
			actionClasses.put("operMonitor", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.OperMonitorAction")));
			actionClasses.put("credit", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.CreditWeightAction")));
			actionClasses.put("bir", FastClass.create(Class.forName("com.asiainfo.hbbass.bir.BIRAction")));
			actionClasses.put("kpi", FastClass.create(Class.forName("com.asiainfo.hbbass.kpiportal.service.KPIPortalAction")));
			actionClasses.put("watermark", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.WatermarkAction")));
			actionClasses.put("sqlExec", FastClass.create(Class.forName("com.asiainfo.hbbass.common.action.SQLExecAction")));
			actionClasses.put("indiToPpt", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.IndiToPptAction")));
			actionClasses.put("areaSaleManage", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.AreaSaleManageAction")));
			actionClasses.put("confReport", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.ConfReportAction")));
			actionClasses.put("feeInfo", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.FeeInfoAction")));
			actionClasses.put("kpiCustomize", FastClass.create(Class.forName("com.asiainfo.hbbass.kpiportal.customize.KPICustomizeAction")));
			actionClasses.put("collegeChart", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.ChartAction")));
			actionClasses.put("updateDB", FastClass.create(Class.forName("com.asiainfo.hbbass.common.action.AjaxUpdateAction")));
			actionClasses.put("autoComplete", FastClass.create(Class.forName("com.asiainfo.hbbass.common.action.AutoCompleteAction")));
			actionClasses.put("town", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.TownInfoAction")));
			actionClasses.put("countyCfg", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.CountyCfgAction")));
			actionClasses.put("entGrid", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.EntGridAction")));
			actionClasses.put("roamMonitor", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.RoamMonitorAction")));
			actionClasses.put("recChannel", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.RecChannelAction")));
			actionClasses.put("spcode", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.SpCodeAction")));
			//****杨亮******
			actionClasses.put("flowPagAction", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.FlowPackageMaintainAction")));
			actionClasses.put("gprsAssessment", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.GprsAssessmentAction")));
			actionClasses.put("warnUsercfg", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.WarningUserinfoConfgAction")));
			actionClasses.put("wlanAssessment", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.WlanAssessmentAction")));
			//*****袁巍巍*****
			actionClasses.put("stFlowproduct", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.StFlowproductAction")));
			//*****谢良松*****
			actionClasses.put("baseSet", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.BaseSetEditAction")));
			actionClasses.put("csvmanage", FastClass.create(Class.forName("com.asiainfo.hbbass.common.action.CSVManageAction")));
			
			//*****余磊*****
			actionClasses.put("college", FastClass.create(Class.forName("com.asiainfo.hbbass.app.action.CollegeManageAction")));
			
			actionClasses.put("portalMain", FastClass.create(Class.forName("com.asiainfo.hbbass.frame.PortalMainAction")));
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	public void dispatch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String path = request.getPathInfo();
		
		String[] arr = path.split("/");
		
		String methodValue = request.getParameter("method");
		
		if(methodValue==null || methodValue.length()==0){
			methodValue = request.getMethod();
		}
		
		LOG.info(path+" methodValue="+methodValue);
		
		try {
			FastClass cls = (FastClass)actionClasses.get(arr[2]);
			FastMethod method = null;
			try{
				method = cls.getMethod(methodValue,new Class[]{HttpServletRequest.class,HttpServletResponse.class});
			}catch(NoSuchMethodError e){
				//e.printStackTrace();
				//LOG.debug(e.getMessage(),e);
				//LOG.info("methodValue:"+methodValue+",不存在，运行excute方法");
			}
			/* 2010-12-27取消这里的日志记录，改由filter统一记录
			LogProxy proxy = new LogProxy(request,(method!=null)?methodValue:"execute",arr[2]);
			Action action = (Action)proxy.createProxy(cls.getJavaClass());
			*/
			Action action = (Action)cls.newInstance();
			if(method!=null){
				method.invoke(action, new Object[]{request,response});
			} else {
				action.execute(request, response);
			}
		} catch (SecurityException e) {
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
}
