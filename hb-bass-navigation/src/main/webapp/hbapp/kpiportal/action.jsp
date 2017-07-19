<%@ page contentType="text/html; charset=utf-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.asiainfo.hbbass.common.jdbc.ConnectionManage"%>
<%@page import="com.asiainfo.hbbass.component.chart.FusionChartHelper"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIEntity"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPICustomize"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIPortalContext"%>
<%@page import="com.asiainfo.hbbass.kpiportal.service.KPIPortalService"%>
<%@page import="com.asiainfo.hbbass.kpiportal.service.KPIPortalViewService"%>
<%@page import="com.asiainfo.hbbass.kpiportal.core.KPIEntityValueState"%>
<%@page import="java.text.DecimalFormat"%>
<%!

static org.apache.log4j.Logger log = org.apache.log4j.Logger.getLogger("JSPKpiAction");
static DecimalFormat DECIMAL_FORMAT = new DecimalFormat("0.#");

static Map appNameMap = new java.util.HashMap();
static{
appNameMap.put("ChannelD","日KPI");
appNameMap.put("ChannelM","月KPI");
appNameMap.put("BureauD","区域化日KPI");
appNameMap.put("BureauM","区域化月KPI");
appNameMap.put("GroupcustD","集团日KPI");
appNameMap.put("GroupcustM","集团月KPI");
appNameMap.put("CollegeD","高校日KPI");
appNameMap.put("CollegeM","高校月KPI");
}
%>
<%

String apprM="K20076,K20111,K20114";
String apprD="K10001,K10076,KC0001,KC0005";

String chlD="";
String chlM="CHM0002,CHM0003,CHM0004,CHM0006";

try{
	String method = request.getParameter("method");
	String userid = (String)session.getAttribute("loginname");
	String appName = request.getParameter("appName");
	
	if(userid==null||userid.length()==0)userid="default";
	if("kpiview".equalsIgnoreCase(method)){
		String kind = request.getParameter("kind");
		String area = request.getParameter("area");
		String date = request.getParameter("date");
		String zbcode = request.getParameter("zbcode");
		
		if("default".equalsIgnoreCase(zbcode) ){
			if("chlrec".equals(kind)){
				if(appName.startsWith("ChannelD")){
					zbcode=chlD;
				}else if(appName.startsWith("ChannelM")){
					zbcode=chlM;
				}
			}else{
				if(appName.startsWith("ChannelD")){
					zbcode=apprD;
				}else if(appName.startsWith("ChannelM")){
					zbcode=apprM;
				}else{
					zbcode=KPICustomize.getUserCustomizeKpiToString(userid,appName);
				}
			}
		}else if("appraisal".equalsIgnoreCase(zbcode)){
			if(appName.startsWith("ChannelD")){
				zbcode=apprD;
			}else if(appName.startsWith("ChannelM")){
				zbcode=apprM;
			}
		}
		
		
		KPIEntityValueState state = (KPIEntityValueState)KPIEntityValueState.parse(KPIEntityValueState.class,request);
		
		List list = KPIPortalViewService.getGridList(appName,date,area,zbcode,state);
		
		request.setAttribute("resultList",list);
		request.getRequestDispatcher("../resources/old/translateGridData.jsp").forward(request,response);
		
	}else if("kpiviewDetail".equalsIgnoreCase(method)){
		String area = request.getParameter("area");
		String date = request.getParameter("date");
		String zbcode = request.getParameter("zbcode");
		String kind = request.getParameter("kind");
		KPIEntityValueState state = (KPIEntityValueState)KPIEntityValueState.parse(KPIEntityValueState.class,request);
		
		List list = KPIPortalViewService.getDetailGridList(appName,date,area,zbcode,state);
		
		request.setAttribute("resultList",list);
		request.getRequestDispatcher("../resources/old/translateGridData.jsp").forward(request,response);
		
	}else if("kpiprogress".equalsIgnoreCase(method)){
		
		String area = request.getParameter("area");
		String date = request.getParameter("date");
		String zbcode = request.getParameter("zbcode");
		boolean detailoffice = Boolean.valueOf(request.getParameter("detailoffice")).booleanValue();
		
		KPIEntityValueState state = (KPIEntityValueState)KPIEntityValueState.parse(KPIEntityValueState.class,request);
		
		List list = KPIPortalViewService.getProgressList(appName,date,zbcode,area,state,detailoffice,"2000");
		
		request.setAttribute("resultList",list);
		request.getRequestDispatcher("../resources/old/translateGridData.jsp").forward(request,response);
		
	}else if ("kpicompare".equalsIgnoreCase(method)){
		
		String zbcode = request.getParameter("zbcode");
		String area = request.getParameter("area");
		String durafrom = request.getParameter("durafrom");
		String durato = request.getParameter("durato");
		KPIEntity kpi = KPIPortalService.getKPI(appName,KPIPortalService.getKPIAppData(appName).getCurrent(),zbcode);
		KPIEntityValueState state = (KPIEntityValueState)KPIEntityValueState.parse(KPIEntityValueState.class,request);
		List list = KPIPortalViewService.getCompareList(kpi,area,state,durafrom,durato);
		request.setAttribute("resultList",list);
		request.getRequestDispatcher("../resources/old/translateGridData.jsp").forward(request,response);
		
	}else if ("chartkpicompare".equalsIgnoreCase(method)){
		
		String zbcode = request.getParameter("zbcode");
		String area = request.getParameter("area");
		String durafrom = request.getParameter("durafrom");
		String durato = request.getParameter("durato");
		String zoomin = request.getParameter("zoomin");
		
		KPIEntity kpi = KPIPortalService.getKPI(appName,KPIPortalService.getKPIAppData(appName).getCurrent(),zbcode);
		KPIEntityValueState state = (KPIEntityValueState)KPIEntityValueState.parse(KPIEntityValueState.class,request);
		List list = KPIPortalViewService.getOrginCompareList(kpi,area,state,durafrom,durato);
		
		FusionChartHelper.Options options = new FusionChartHelper.Options();
		options.setCaption(kpi.getName());
		options.setValueType(kpi.getKpiMetaData().getFormatType());
		if("true".equalsIgnoreCase(zoomin)){
			options.setShowValues("1");
			options.setShowNames("1");
		}
		String result = FusionChartHelper.chartMultiCol(list,options);
		log.debug(result);
		request.setAttribute("result",result);
		request.getRequestDispatcher("../resources/old/translateData.jsp").forward(request,response);
		
	}else if ("chartkpiview".equalsIgnoreCase(method)){
		
		String area = request.getParameter("area");
		String date = request.getParameter("date");
		if(date==null||date.length()==0)//如果传来的date为空就默认为current
			date=KPIPortalService.getKPIAppData(appName).getCurrent();
		String zbcode = request.getParameter("zbcode");
		String valuetype = request.getParameter("valuetype");
		String link = request.getParameter("link");
		KPIEntityValueState state = (KPIEntityValueState)KPIEntityValueState.parse(KPIEntityValueState.class,request);
		boolean detailoffice = Boolean.valueOf(request.getParameter("detailoffice")).booleanValue();
		
		String cum=zbcode;
		if("default".equalsIgnoreCase(zbcode))
			cum =KPICustomize.getUserCustomizeKpiToString(userid,appName);
		
		KPIEntity kpiEntity = (KPIEntity)KPIPortalService.getFirstKPI(appName,date,cum);
		if(kpiEntity==null)
		{
			cum =KPICustomize.getUserCustomizeKpiToString(userid,appName);
			kpiEntity = (KPIEntity)KPIPortalService.getFirstKPI(appName,date,cum);
		}
		if(kpiEntity==null)return;
		String namepostfix = "";
		String nameprefix = "";
		String result = null;
		
		if("pre".equalsIgnoreCase(valuetype))nameprefix=date.length()==8?"前日 ":"上月 ";
		else if ("before".equalsIgnoreCase(valuetype))nameprefix=date.length()==8?"上月同期 ":"去年同期 ";
		else if ("year".equalsIgnoreCase(valuetype))nameprefix="去年同期 ";
		else if ("huanbi".equalsIgnoreCase(valuetype))namepostfix=" 环比增长";
		else if ("tongbi".equalsIgnoreCase(valuetype))namepostfix=date.length()==8?" 月同比增长":" 同比增长";
		else if ("yeartongbi".equalsIgnoreCase(valuetype))namepostfix=" 年同比增长";
		else if("progress".equalsIgnoreCase(valuetype)){nameprefix=date.length()==8?"当日 ":"当月 ";namepostfix=" 的进度";}
		else nameprefix=date.length()==8&&!"K10001".equalsIgnoreCase(zbcode)?"当日 ":"当月 ";
		
		if(area.length()>5)namepostfix += " 前10名";
		
		FusionChartHelper.Options options = new FusionChartHelper.Options();
		options.setCaption(nameprefix + kpiEntity.getName() +namepostfix);
		options.setShowNames(area.length()>5?"0":"1");
		options.setValueType(kpiEntity.getKpiMetaData().getFormatType());
		if("progress".equalsIgnoreCase(valuetype)){
			String sTarget = "100";
			if("percent".equalsIgnoreCase(kpiEntity.getKpiMetaData().getFormatType())){
				sTarget=String.valueOf(kpiEntity.getKpiMetaData().getTargetValue()*100);
			}else if("increase".equalsIgnoreCase(kpiEntity.getKpiMetaData().getTargetType())){
				double target = 0d;
				if(date.length()==8){
					Calendar c = new GregorianCalendar(Integer.parseInt(date.substring(0,4)),Integer.parseInt(date.substring(4,6))-1,1);
					c.add(Calendar.MONTH, 1);
					c.add(Calendar.DATE, -1);
					target = Integer.parseInt(date.substring(6,8))*100d/c.get(Calendar.DATE);
				}else{
					target = Integer.parseInt(date.substring(4,6))*100d/12;
				}
				sTarget = DECIMAL_FORMAT.format(target);
				options.setTrendlinesDisplayValue("时间进度");
			}else if("increaseYear".equalsIgnoreCase(kpiEntity.getKpiMetaData().getTargetType())){
				double target = 0d;
				if(date.length()==8){
					Calendar c = new GregorianCalendar(Integer.parseInt(date.substring(0,4)),Integer.parseInt(date.substring(4,6))-1,Integer.parseInt(date.substring(6,8)));
					c.get(Calendar.DAY_OF_YEAR);
					target = c.get(Calendar.DAY_OF_YEAR)*100d/365;
					sTarget = DECIMAL_FORMAT.format(target);
				}else{
					target = Integer.parseInt(date.substring(4,6))*100d/12;
				}
				sTarget = DECIMAL_FORMAT.format(target);
				options.setTrendlinesDisplayValue("时间进度");
			}else if("KCT001".equalsIgnoreCase(kpiEntity.getId())){//开门红收入写死
				double target = Integer.parseInt(date.substring(6,8));
				if("02".equalsIgnoreCase(date.substring(4,6))){
					target +=31;
				}
				
				if("01".equalsIgnoreCase(date.substring(4,6))){
					target +=31;
				}
				
				if(Integer.parseInt(kpiEntity.getId())>=20100228){
					target = 100;
				}else{
					target = target*100d/90;
				}
				sTarget = DECIMAL_FORMAT.format(target);
				options.setTrendlinesDisplayValue("时间进度");
			}
			
			options.setValueType("percent");
			options.setNumDivLines("2");
			options.setColorStyle("order");
			options.setTrendlinesValue(sTarget);
			result = FusionChartHelper.chartNormal(KPIPortalViewService.getChartList(kpiEntity,area,date,state,valuetype),options);
		}else if (valuetype.endsWith("bi")){
			options.setValueType("percent");
			//20091224增加同环比的考核目标
			if(kpiEntity.getKpiMetaData().getCompTargetValue()!=0){
				options.setTrendlinesValue(String.valueOf(kpiEntity.getKpiMetaData().getCompTargetValue()*100));
			}
			
			if(detailoffice){
				options.setShowNames("0");
				//result = FusionChartHelper.chartNormal(KPIPortalViewService.getOfficeChartList(zbcode,area,date,valuetype),options);
			}else{
				options.setColorStyle("order");
				List list = KPIPortalViewService.getChartList(kpiEntity,area,date,state,valuetype,link);
				if(link!=null&&link.length()>0)
				{
					options.setShowValues("1");
					if("HB".equalsIgnoreCase(area)){
						options.setSetElement(new String[]{"name","value","defaultColor","link"});
						for(int i=0; i<list.size();i++){
							String[] line = (String[])list.get(i);
							line[3]= "JavaScript:linkCity(\""+line[3]+"\")";
						}
					}
				}
				result = FusionChartHelper.chartNormal(list,options);
			}
		}else{
			List list = null;
			if(detailoffice){
				//list = KPIPortalViewService.getOfficeChartList(zbcode,area,date,valuetype);
				options.setShowNames("0");
			}else
				list = KPIPortalViewService.getChartList(kpiEntity,area,date,state,valuetype);
			
			result = FusionChartHelper.chartColLineDY(list,options);
		}
		log.debug(result);
		request.setAttribute("result",result);
		request.getRequestDispatcher("../resources/old/translateData.jsp").forward(request,response);
		
	}else if ("customeize".equalsIgnoreCase(method)){
		String zbcode = request.getParameter("zbcode");
		String custom = request.getParameter("custom");
		
		KPICustomize.updateUserCustomizeKpi(userid,appName,"true".equalsIgnoreCase(custom)?"add":"del",zbcode);
		
		out.write(KPICustomize.getUserCustomizeKpiToString(userid,appName));
		
	}else if ("down".equalsIgnoreCase(method)){
		String area = request.getParameter("area");
		String date = request.getParameter("date");
		String zbcode = request.getParameter("zbcode");
		boolean detailoffice = Boolean.valueOf(request.getParameter("detailoffice")).booleanValue();
		KPIEntityValueState state = (KPIEntityValueState)KPIEntityValueState.parse(KPIEntityValueState.class,request);
		List list = KPIPortalViewService.getProgressList(appName,date,zbcode,area,state,detailoffice,null);
		request.setAttribute("resultList",list);
		request.getRequestDispatcher("commonDown.jsp").forward(request,response);
		
	} else if ("wave".equalsIgnoreCase(method)) {
		
		String zbcode = request.getParameter("zbcode");
		String current = request.getParameter("date");
		String area = request.getParameter("area");
		String valuetype = request.getParameter("valuetype");
		String dim = request.getParameter("dim");
		String mappingTagName = request.getParameter("mappingTagName");
		String condition = request.getParameter("condition");
		String compareDate = "";
		String table="daily";
		String region = "";
		
		if(area!=null ){
			if(area.length()==5)
				region = " and substr(channel_code,1,5)='"+area+"' ";
			else if(area.length()==8)
				region = " and substr(channel_code,1,8)='"+area+"' ";
		}
		
		if ("huanbi".equalsIgnoreCase(valuetype))compareDate=KPIPortalContext.calDate(current)[0];
		else if ("tongbi".equalsIgnoreCase(valuetype))compareDate=KPIPortalContext.calDate(current)[1];
		else if ("yeartongbi".equalsIgnoreCase(valuetype))compareDate=KPIPortalContext.calDate(current)[2];
		
		if(current.length()==6)table="monthly";
		String sql = "";
		if("K11002".equalsIgnoreCase(zbcode)||"K11004".equalsIgnoreCase(zbcode)||"K11006".equalsIgnoreCase(zbcode)
				||"K22011".equalsIgnoreCase(zbcode)||"K22012".equalsIgnoreCase(zbcode)||"K22013".equalsIgnoreCase(zbcode)||"K22014".equalsIgnoreCase(zbcode))
		{
			if("NET_TYPE".equalsIgnoreCase(dim))
				sql = "select @dim@,value(decimal(sum(case when time_id ='@current@' then value else 0 end),16,2)/(select sum(value) from nmk.KPI_WAVE_@table@ where zb_code ='@zbcode@' and time_id ='@current@' @condition@),0) as data,value(decimal(sum(case when time_id ='@compareDate@' then value else 0 end),16,2)/(select sum(value) from nmk.KPI_WAVE_@table@ where zb_code ='@zbcode@' and time_id ='@compareDate@' @condition@),0) as data1 from nmk.KPI_wave_@table@ where zb_code ='@zbcode@' and time_id in ('@current@','@compareDate@') @condition@ group by @dim@ order by case when data1 =0 then 0 else decimal(data,16,6)/data1 end desc with ur";
			else{
				String operator = "YD";
				if(condition.length()>0&& condition.toUpperCase().matches(".*NET_TYPE='(LT|DX|YD)'.*")){
					if(condition.toUpperCase().matches(".*LT.*"))operator = "LT";
					else if(condition.toUpperCase().matches(".*DX.*"))operator = "DX";
					condition = condition.toUpperCase().replaceAll("NET_TYPE='(LT|DX|YD)'"," 1=1");
				}
				sql = "select @dim@,value(decimal(sum(case when net_type='@operator@' and time_id ='@current@' then value else 0 end),16,2)/sum(case when time_id ='@current@' then value else 0 end),0) as data,value(decimal(sum(case when net_type='@operator@' and time_id ='@compareDate@' then value else 0 end),16,2)/sum(case when time_id ='@compareDate@' then value else 0 end),0) as data1 from nmk.KPI_wave_@table@ where zb_code ='@zbcode@' and time_id in ('@current@','@compareDate@') @condition@ group by @dim@ order by case when data1 =0 then 0 else decimal(data,16,6)/data1 end desc with ur";
				sql = sql.replaceAll("@operator@",operator);
			}
		}else
			sql = "select @dim@,value(decimal(sum(case when time_id ='@current@' then value else 0 end),16,2)/@division@,0) as data,value(decimal(sum(case when time_id ='@compareDate@' then value else 0 end),16,2)/@division@,0) as data1 from nmk.KPI_wave_@table@ where zb_code ='@zbcode@' and time_id in ('@current@','@compareDate@') @condition@ @region@ group by @dim@ order by case when data1 =0 then 0 else decimal(data,16,6)/data1 end desc with ur";
		
		String division = "1";
		
		KPIEntity kpiEntity = (KPIEntity)((Map)KPIPortalService.getAKPIMap(appName)).get(zbcode);
		
		if(kpiEntity!=null && kpiEntity.getKpiMetaData().getDivision()>Double.parseDouble(division))
			division = KPIPortalContext.DECIMAL_FORMAT.format(kpiEntity.getKpiMetaData().getDivision());
			
		
		sql = sql.replaceAll("@dim@",dim).replaceAll("@zbcode@",zbcode).replaceAll("@condition@",condition).replaceAll("@division@",division).replaceAll("@region@",region).replaceAll("@compareDate@",compareDate).replaceAll("@current@",current).replaceAll("@table@",table);
		log.info(zbcode+" 波动分析：SQL="+sql);
		request.setAttribute("result",KPIPortalViewService.getWaveString(sql,mappingTagName));
		request.getRequestDispatcher("../resources/old/translateData.jsp").forward(request,response);
	}
	else if ("logger".equalsIgnoreCase(method)){
		
		String sql = "insert into FPF_VISITLIST(LOGINNAME,IPADDR,AREA_ID,FUNCCODE,THEMECODE,opertype,opername,CATACODE) values( ?,?,?,'966','运营管理监控',?,?,?)";
		String zbcode = request.getParameter("zbcode");
		String oper = request.getParameter("oper");
		//sql = sql.replaceAll("@oper@",oper).replaceAll("@zbcode@",zbcode).replaceAll("@ipadd@",).replaceAll("@loginname@",(String)session.getAttribute("loginname")).replaceAll("@area@",(String)session.getAttribute("area_id"));
		java.sql.Connection conn = null;
		try{
			conn = ConnectionManage.getInstance().getWEBConnection();
			log.debug("sql="+sql);
			java.sql.PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1,(String)session.getAttribute("loginname"));
			ps.setString(2,request.getRemoteAddr());
			ps.setInt(3,Integer.parseInt((String)session.getAttribute("area_id")));
			ps.setString(4,oper);
			ps.setString(5,zbcode);
			ps.setString(6,(String)appNameMap.get(appName));
			ps.execute();
			ps.close();
			conn.commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error(e.getMessage(),e);
		}finally{
			if(conn!=null)conn.close();
		}
		
	} else if ("tree".equalsIgnoreCase(method)){
		String date = request.getParameter("date");
		String area = request.getParameter("area");
		String kind = request.getParameter("kind");
		Map map = (Map)KPIPortalService.getKPIMap(appName, date);
		
		StringBuffer result = new StringBuffer("[");
		
		String[][] main = {{"K10001","K1G003","K10002","K1G102"}};
		String[][] user = {{"K10003","K1GC03","K1GC04","K10005"},{"K10009","K10008","K10010","K11010"},{"K11001","K11001","K11002","K11003","K11004","K11005","K11006"}};
		
		String[][] traffic = {{"K10006","K1GC06","K1GC05","K1GC08","K1GC09"},{"K11007","K1GC10","K11008","K1GC13","K11014","K1GC15"}};
		
		String[][] income = {{"K10029","K10030"},{"K10032"},{"K10033"},{"K10034"},{"K10035"},{"K10036"}};
		
		String[][] arr = main;
		
		if("user".equalsIgnoreCase(kind))arr=user;
		else if("traffic".equalsIgnoreCase(kind))arr=traffic;
		else if("income".equalsIgnoreCase(kind))arr=income;
		
		for (int i = 0; i < arr.length; i++) {
			if(result.length()>1)result.append(",");
			result.append("[");
			for (int j = 0; j < arr[i].length; j++) {
				KPIEntity kpiEntity =(KPIEntity)map.get(arr[i][j]);
				if( kpiEntity!=null ){
					KPIEntity.Entity entity = (KPIEntity.Entity)kpiEntity.getIndex().get(area);
					if(entity!=null){
						if(j != 0)result.append(",");
						result.append("['").append(kpiEntity.getName())
						.append("','").append(entity.getValue())
						.append("','").append(kpiEntity.getId())
						.append("','").append(entity.getYearTongBi())
						.append("','").append(kpiEntity.getKpiMetaData().getFormatType())
						.append("','").append(entity.getTongBi())
						.append("']");
					}
				}
			}
			result.append("]");
		}
		result.append("]");
		
		request.setAttribute("result",result.toString());
		request.getRequestDispatcher("../resources/old/translateData.jsp").forward(request,response);
	}else if ("instruction".equalsIgnoreCase(method)){
		String zbcode = request.getParameter("zbcode");
		
		KPIEntity kpiEntity = (KPIEntity)KPIPortalService.getAKPIMap(appName).get(zbcode);
		
		out.clear();
		out.print(kpiEntity.getKpiMetaData().getName());
		out.print("：\r\n");
		out.print(kpiEntity.getKpiMetaData().getInstruction());
	}
	
}catch(Exception e){
	e.printStackTrace();
	throw e;
}
%>