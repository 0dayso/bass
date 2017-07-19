package com.asiainfo.hbbass.irs.report.core;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.dimension.BassDimCache;
import com.asiainfo.hbbass.component.dimension.BassDimHelper;
import com.asiainfo.hbbass.component.json.JsonHelper;

/**
 * 报表的元数据信息
 * 
 * @author Mei Kefu
 * @date 2009-7-24
 * @date 2010-7-16 增加编程功能，添加JS Code块
 */
@SuppressWarnings("serial")
public class Report implements Serializable {
	
	private String 
		key = "0", /*报表的唯一ID*/
		name = "",/*报表的名称 Title*/
		grid="",/*Grid的类型 Ajax Simple*/
		maxTime="",/*数据的最大时间*/
		useChart="",/*是否开启图形*/
		useExcel="",/*下载为Excel*/
		isAreaAll="",/*数据权限为全省*/
		proc ="",
		ds="",/*数据的最大时间*/
		isCached="",/*数据的最大时间*/
		template = "",/*报表的调用模板*/
		tableName = "",/*对应的数据库表名*/
		cityId="0";
	
	@SuppressWarnings("rawtypes")
	private Map timeLine;
	/*private Dimension[] dimensions = null;
	
	private Header[] headers = null;
	
	private SQLParse parse = null;//SQL解析器
	
	//layout
	public static class Dimension{
		public String 
			name = "",//前台映射选择维度的名称
			dbName = "",//映射SQL的字段
			dbType = "",//映射SQL的字段类型
			dataSource = "",//该维度的数据源
			value = "",//该维度的值
			dbParseType = "";//判断该维度是否参入输出
	}
	
	public static class Header{
		public String 
			name = "",//Grid表头的名称
			dataIndex = "",//Grid引用数据，引用dbName名或者dbName别名
			cellFunc = "",//Grid的cell回调函数
			cellStyle = "",//Grid的cell的css样式
			dbName = "",//生成SQL的colmn维度用 如果是计算就需要起别名 
			dimMapping = "";//维表映射name
	}*/
	
	private SQLQuery sqlQuery = null;
	
	private String dimensionData = "";//查询维度的HTML
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Report(String key,String cityId) {
		this.cityId=cityId;
		if(key!=null && key.length()>0)
			this.key=key;
		sqlQuery=SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, "web", false);
		
		try {
			List list = (List)sqlQuery.querys("select name,desc from FPF_IRS_SUBJECT where id="+key+" and KIND='配置' with ur");
			if(list.size()>0){
				Map map = (Map)list.get(0);
				name=(String)map.get("name");
			}
			
			list = (List)sqlQuery.querys("select code,value from FPF_IRS_SUBJECT_EXT where sid="+key+" and code!='SQL' with ur");
			for (int i = 0; i < list.size(); i++) {
				Map map = (Map)list.get(i);
				
				if("Grid".equalsIgnoreCase((String)map.get("code"))){
					grid=(String)map.get("value");
				}else if("DS".equalsIgnoreCase((String)map.get("code"))){
					ds=(String)map.get("value");
				}else if("Cache".equalsIgnoreCase((String)map.get("code"))){
					isCached=(String)map.get("value");
				}else if("UseExcel".equalsIgnoreCase((String)map.get("code"))){
					useExcel=(String)map.get("value");
				}else if("UseChart".equalsIgnoreCase((String)map.get("code"))){
					useChart=(String)map.get("value");
				}else if("Proc".equalsIgnoreCase((String)map.get("code"))){
					proc=(String)map.get("value");
				}else if("MaxTime".equalsIgnoreCase((String)map.get("code"))){
					maxTime=(String)map.get("value");
				}else if("AreaAll".equalsIgnoreCase((String)map.get("code"))){
					isAreaAll=(String)map.get("value");
				}
			}
			
			list = (List)sqlQuery.querys("select value responsible,mobilephone contact from FPF_IRS_SUBJECT_EXT,FPF_USER_USER where value=username and cityid='0' and sid="+key+" and code='Resp' with ur");
			if(list!=null && list.size()==1){
				timeLine = (Map)list.get(0);
			}else{
				timeLine = new HashMap();
			}
			
			SQLQuery sqlQuery1=SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT);
			List list1 = (List)sqlQuery1.query("select etl_cycle_id task,dest_time from nwh.dp_etl_com where etl_progname='"+proc+"' with ur");
			if(list1!=null && list1.size()==1){
				Map map1 = (Map)list1.get(0);
				String task = String.valueOf(map1.get("task"));
				String dest_time = String.valueOf(map1.get("dest_time"));
				String text = "";
				if(dest_time!=null && dest_time.length()>0){
					if(task.length()==6){
						text+="每月"+dest_time+"号"+ "24点";
					}else if(task.length()==8){
						text+="每日"+(Integer.valueOf(dest_time.split(":")[0])+1) + "点 "+(Integer.valueOf(dest_time.split(":")[1]))+"分";
					}
				}
				timeLine.put("timeline", text);
				
			}
			
			
			//初始化
			getDimensionPiece();
			getHeaderPiece();
			getSQLPiece();
			getCodePiece();
			
			genSQL();//这东西放这里不是很合理
			genDownHeader();
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			sqlQuery.release();
		}
	}
	
	public Report(String key) {
		this(key, "0");
	}
	
	@SuppressWarnings("rawtypes")
	public String getDimensionPiece() throws SQLException {
		//SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, "web", false);
		if(dimensionData.length()==0){
			List list = (List)sqlQuery.querys("select label,name,dbname,opertype,datasource,defval from FPF_IRS_SUBJECT_DIM where sid="+key+" order by seq with ur");
			int num=3;
			StringBuilder sb = new StringBuilder();
			if(list!=null && list.size()>0){
				sb.append("<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>");
				
				int count=list.size()%num==0?list.size():(list.size()/num+1)*num;
				
				for (int i = 0; i < count; i++) {
					if(i%num==0){
						sb.append("<tr class='dim_row'>");
					}
					
					if(i>=list.size()){
						sb.append("<td class='dim_cell_title'></td>").append("<td class='dim_cell_content'></td>");
					}else{
						Map map = (Map)list.get(i);
						String content = "";
						String detail = "";
						String datasource=(String)map.get("datasource");
						String label = (String)map.get("label");
						String name = (String)map.get("name");
						String dbname = (String)map.get("dbname");
						String operType = (String)map.get("opertype");
						String defval = (String)map.get("defval");
						
						if(("comp:date".equalsIgnoreCase(datasource) || "comp:month".equalsIgnoreCase(datasource)) &&maxTime.length()>0){
							SQLQuery sqlQuery1 = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.LIST);
							
							List _list=(List)sqlQuery1.query(maxTime);
							if(_list!=null && _list.size()>0){
								String[] line = (String[])_list.get(0);
								defval = line[0];
							}
						}
						
						if("between".equalsIgnoreCase(operType)){
							content="<input class=form_input_between id=from_"+name+"> 到 <input class=form_input_between name="+name+">";
						}else if("range".equalsIgnoreCase(operType)){
							content="<select class=form_input_between id=range_"+name+"><option selected value='='>等于</option><option value='>'>大于</option><option value='<'>小于</option><option value='>='>大于等于</option><option value='<='>小于等于</option></select> <input style='padding-left:5px;' class=form_input_between name="+name+">";
						}else if("comp:date".equalsIgnoreCase(datasource)){
							content=BassDimHelper.time(name,"yyyyMMdd",defval);
						}else if("comp:month".equalsIgnoreCase(datasource)) {
							content=BassDimHelper.time(name,"yyyyMM",defval);
						}else if("comp:city".equalsIgnoreCase(datasource)) {
							
							if("true".equalsIgnoreCase(isAreaAll)){
								content=BassDimHelper.areaCodeHtml(name,cityId, "areacombo(1)",true);
							}else{
								content=BassDimHelper.areaCodeHtml(name,cityId, "areacombo(1)");
							}
							
							
						}else if("comp:county".equalsIgnoreCase(datasource)) {
							content=BassDimHelper.comboSeleclHtml(name);
							detail = " <input id='countyDetail' type='checkbox'>细分";
						}else if("comp:county_bureau".equalsIgnoreCase(datasource)) {
							content=BassDimHelper.comboSeleclHtml(name,"areacombo(2)");
							detail = " <input id='countyDetail' type='checkbox'>细分";
						}else if("comp:marketing_center".equalsIgnoreCase(datasource)) {
							content=BassDimHelper.comboSeleclHtml(name,"areacombo(3)");
							detail = " <input id='mcDetail' type='checkbox'>细分";
						}else if("comp:town".equalsIgnoreCase(datasource)) {
							content=BassDimHelper.comboSeleclHtml(name,"areacombo(4)");
							detail = " <input id='townDetail' type='checkbox'>细分";
						}else if("comp:cell".equalsIgnoreCase(datasource)) {
							content=BassDimHelper.comboSeleclHtml(name);
							detail = " <input id='cellDetail' type='checkbox'>细分";
						}else if("comp:college".equalsIgnoreCase(datasource)) {
							content=BassDimHelper.comboSeleclHtml(name);
							detail = " <input id='collegeDetail' type='checkbox'>细分";
						}else if("comp:entCounty".equalsIgnoreCase(datasource)) {
							content=BassDimHelper.comboSeleclHtml(name,"areacombo(2)");
							detail = " <input id='entCountyDetail' type='checkbox'>细分";
						}else if("comp:custmgr".equalsIgnoreCase(datasource)) {
							content=BassDimHelper.comboSeleclHtml(name,"areacombo(3)");
							detail = " <input id='custmgrDetail' type='checkbox'>细分";
						}else if(datasource.startsWith("comp:")){
							content=BassDimHelper.selectHtml(datasource.replace("comp:", ""));
						}else if(datasource.startsWith("select:")){
							String tem=datasource.replaceAll("select:", "");
							Object obj = JsonHelper.getInstance().read(tem);
							
							if(obj instanceof List){
								List options = (List)obj;
								if(options.size()>0)
									content=BassDimHelper.renderSelect(name,options);
							}
							
							
						}else if(datasource.startsWith("input:")){
							
							content="<input type='text' name='"+name+"'>";
							
						}else if(datasource.startsWith("sql:")){
							String tem=datasource.replaceAll("sql:", "");
							SQLQuery sqlQuery1=SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.JSON_OBJECT, null, false);
							List options = (List)sqlQuery1.query(tem);
							if(options.size()>0)
								content=BassDimHelper.renderSelect(name,options);
						}
						
						if("comp:date".equalsIgnoreCase(datasource)||"comp:month".equalsIgnoreCase(datasource)){
							sb.append("<td class='dim_cell_title'><span onclick='swichDate()' title='点击切换时间类型' style='cursor:hand;'>"+label+detail+"</span> <span style='display:none;'><input id='timeDetail' type='checkbox' checked='checked'>细分 </span></td>");
						}else{
							sb.append("<td class='dim_cell_title'>"+label+detail+"</td>");
						}
						
						sb.append("<td class='dim_cell_content'><ai:dim id='aidim_"+name+"' name='"+name+"' dbName=\""+dbname+"\" operType=\""+operType+"\">"+content+"</ai:dim></td>");
						
					}
					
					if(i%num==(num-1)){
						sb.append("</tr>");
					}
				}
				
				sb.append("</table>");
			}
			dimensionData=sb.toString();
		}
		
		return dimensionData;
	}
	
	private String headerData = "";//JS需要表头信息数据
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String getHeaderPiece(){
		if(headerData.length()==0){
			headerData="[]";
			List list=null;
			try {
				list = (List)sqlQuery.querys("select name,data_index,value(cell_func,'') cell_func,value(cell_style,'') cell_style,value(title,'')title from FPF_IRS_SUBJECT_INDICATOR where sid="+key +" order by seq");
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			for (int i = 0; i < list.size(); i++) {
				Map map = (Map)list.get(i);
				
				List names = new ArrayList();
				
				String[] arrName = ((String)map.get("name")).split(",");
				
				for (int j = 0; j < arrName.length; j++) {
					names.add(arrName[j]);
				}
				
				map.put("name", names);
				
				Object obj = map.get("data_index");
				map.put("dataIndex", obj);
				map.remove("data_index");
				
				obj = map.get("cell_func");
				map.put("cellFunc", obj);
				map.remove("cell_func");
				
				obj = map.get("cell_style");
				map.put("cellStyle", obj);
				map.remove("cell_style");
			}
			
			headerData=JsonHelper.getInstance().write(list);
		}
		return headerData;
	}
	
	//2010-7-16增加JS代码片段
	private String codeData="";
	
	@SuppressWarnings("rawtypes")
	public String getCodePiece(){
		if(codeData.length()==0){
			List list=null;
			try {
				list = (List)sqlQuery.querys("select value from FPF_IRS_SUBJECT_EXT where code='Code' and sid="+key);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			if(list!=null && list.size()==1){
				codeData = (String)((Map)list.get(0)).get("value");
			}
		}
		return codeData;
	}
	
	private String oriSQL="";
	
	@SuppressWarnings("rawtypes")
	public String getSQLPiece(){
		if(oriSQL.length()==0){
			List list=null;
			try {
				list = (List)sqlQuery.querys("select value from FPF_IRS_SUBJECT_EXT where code='SQL' and sid="+key);
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			if(list!=null && list.size()==1){
				oriSQL = (String)((Map)list.get(0)).get("value");
			}
		}
		
		return oriSQL.replaceAll("\r\n", " ")
		.replaceAll("\\{condiPiece\\}", " \"+ aihb.AjaxHelper.parseCondition() +\" ");
		//.replaceAll("\\{colPiece\\}", " \"+ colPiece +\" ")
		//.replaceAll("\\{groupPiece\\}", " \"+ groupPiece +\" ");
	}
	
	public static void main(String[] args){
		String id = "time";
		
		String sql ="\r\nfrom report_fact where reportcode = 'REPORT_SNSC_001' and time_id <= {time} ";
		System.out.println(111111);
		
		System.out.println(sql.matches(".*\\{"+id+"\\}.*"));
		//System.out.println(code.replaceAll("\\$\\{code\\}", path1));
	}
	
	public String render(){
		
		String result = "";
		
		try {
			StringBuilder  sb = new StringBuilder();
			BufferedReader br = new BufferedReader(new InputStreamReader(Thread.currentThread().getContextClassLoader()
					.getResourceAsStream("com/asiainfo/hbbass/irs/report/core/default.htm")));
			
					//.getResourceAsStream("default.htm")));
			String line = "";
			while((line=br.readLine())!=null){
				sb.append(line).append("\r\n");
			}
			br.close();
			
			result= sb.toString().replaceAll("\\$\\{dimension\\}", replaceSpecialChar(getDimensionPiece()) )
			.replaceAll("\\$\\{grid\\}", grid)
			.replaceAll("\\$\\{title\\}", name)
			.replaceAll("\\$\\{cache\\}", isCached)
			.replaceAll("\\$\\{ds\\}", ds)
			.replaceAll("\\$\\{useExcel\\}", useExcel)
			.replaceAll("\\$\\{useChart\\}", useChart)
			.replaceAll("\\$\\{header\\}", replaceSpecialChar(getHeaderPiece()))
			.replaceAll("\\$\\{code\\}", replaceSpecialChar(getCodePiece()))
			.replaceAll("\\$\\{timeline\\}", replaceSpecialChar(JsonHelper.getInstance().write(timeLine)))
			.replaceAll("\\$\\{sql\\}", replaceSpecialChar(getSQLPiece()) );
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}finally{
			sqlQuery.release();
		}
		
		return result;
	}
	
	/**
	 * 替换特殊字符
	 * @param oriStr
	 * @return
	 */
	protected String replaceSpecialChar(String oriStr){
		//替换$为\$
		String str=new String(oriStr).intern();
		StringBuilder sb = new StringBuilder();
		if (str.indexOf('$', 0) > -1) {
			while (str.length() > 0) {
				if (str.indexOf('$', 0) > -1) {
					sb.append(str.subSequence(0, str.indexOf('$', 0)));
					sb.append("\\$");
					str = str.substring(str.indexOf('$', 0) + 1, str.length());
				} else {
					sb.append(str);
					str = "";
				}
			}
		}
		return sb.length()>0?sb.toString():oriStr;
	}
	
	/**
	 * 该报表实体对象的下载方法
	 * 
	 * 这个更加符合OO的理念，但是现在实现的逻辑在js中由客户端来运算拼接SQL，不是很合理
	 * 
	 * 现在增加这个方法是为了一组报表打包下载使用，使用一个扭曲的方式来实现，只解析简单的SQL语句，因为真正的业务逻辑是写在js端的，以后要考虑把业务迁移到java端
	 * 2010-8-30
	 * 
	 */
	public void down(){
		
	}
	/**
	 * 生成可执行的SQL
	 * @return
	 */
	private String sql="";
	
	@SuppressWarnings("rawtypes")
	public String genSQL(){
		
		//1.处理  {condiPiece}  aihb.AjaxHelper.parseCondition()，这个还比较简单，应为默认有数据的就只有时间和地域（省或地市） 
		//2.处理{colPiece} 只处理地市
		//3.处理{groupPiece} 只处理地市
		//4.处理{orderPiece} 暂时不处理
		if(sql.length()==0){
			sql=oriSQL.replaceAll("\r\n", " ");
			String condiPiece="";
			String colPiece=null;
			String groupPiece=null;
			String orderPiece=" order by 1";
			try {
				List list = (List)sqlQuery.querys("select label,name,dbname,opertype,datasource,defval from FPF_IRS_SUBJECT_DIM where sid="+key+" order by seq with ur");
				
				for (int i = 0; i < list.size(); i++) {
					
					Map map = (Map)list.get(i);
					String datasource=(String)map.get("datasource");
					String dbname = (String)map.get("dbname");
					String operType = (String)map.get("opertype");
					
					if("comp:date".equalsIgnoreCase(datasource) || "comp:month".equalsIgnoreCase(datasource)){
						String defaultTime=BassDimHelper.calDefDate("comp:date".equalsIgnoreCase(datasource)?"yyyyMMdd":"yyyyMM")[0];
						if(maxTime.length()>0){
							SQLQuery sqlQuery1 = SQLQueryContext.getInstance().getSQLQuery(SQLQueryContext.SQLQueryName.LIST);
							
							List _list=(List)sqlQuery1.query(maxTime);
							String[] line = (String[])_list.get(0);
							defaultTime = line[0];
						}else{
							defaultTime=BassDimHelper.calDefDate("comp:date".equalsIgnoreCase(datasource)?"yyyyMMdd":"yyyyMM")[0];
						}
						
						if(dbname!=null && dbname.length()>0){
						
							condiPiece += " and "+ dbname+"=";
							if(!"int".equalsIgnoreCase(operType)){
								condiPiece += "'";
							}
							
							condiPiece +=defaultTime;
							
							if(!"int".equalsIgnoreCase(operType)){
								condiPiece += "'";
							}
							
						}
						
						//处理如{time}这样的问题
						String name = (String)map.get("name");
						if(sql.matches(".*\\{"+name+"\\}.*")){
							
							sql=sql.replaceAll("\\{"+name+"\\}",defaultTime);
						}
						
					}else if( "comp:city".equalsIgnoreCase(datasource)){
						
						if(!"0".equalsIgnoreCase(cityId)){
							Map areaIdMap = BassDimCache.getInstance().get("area_id");
							condiPiece += " and " + dbname + "='"+areaIdMap.get(cityId)+"'";
						}
						
						colPiece="value((select alias_area_name from (select area_code alias_area_code,area_name alias_area_name from mk.bt_area) alias_t1 where alias_area_code="+dbname+"),'总计') city";
						groupPiece="rollup("+dbname+")";
					}
				}
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			sql =  sql
			.replaceAll("\\{condiPiece\\}", condiPiece)
			.replaceAll("\\{colPiece\\}", colPiece)
			.replaceAll("\\{groupPiece\\}", groupPiece)
			.replaceAll("\\{orderPiece\\}", orderPiece);
		}																				
		return sql;
	}
	
	@SuppressWarnings("rawtypes")
	private Map downHeader=null;
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map genDownHeader(){
		if(downHeader==null){
			try {
				List list = (List)sqlQuery.querys("select name,data_index from FPF_IRS_SUBJECT_INDICATOR where sid="+key +" order by seq");
				
				downHeader = new HashMap();
				
				for (int i = 0; i < list.size(); i++) {
					Map map = (Map)list.get(i);
					String dataIndex=((String)map.get("data_index")).toUpperCase();
					String name=(String)map.get("name");
					String[] arrName = name.split(",");
					if(arrName.length>1){
						
						List names = new ArrayList(); 
						
						for (int j = 0; j < arrName.length; j++) {
							names.add(arrName[j]);
						}
						downHeader.put(dataIndex, names);
					}else{
						downHeader.put(dataIndex, name);
					}
					
						
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return downHeader;
	}
	
	
	public String getUseChart() {
		return useChart;
	}

	public void setUseChart(String useChart) {
		this.useChart = useChart;
	}

	public String getIsAreaAll() {
		return isAreaAll;
	}

	public void setIsAreaAll(String isAreaAll) {
		this.isAreaAll = isAreaAll;
	}

	public String getUseExcel() {
		return useExcel;
	}

	public void setUseExcel(String useExcel) {
		this.useExcel = useExcel;
	}

	public String getDs() {
		return ds;
	}

	public void setDs(String ds) {
		this.ds = ds;
	}

	public String getIsCached() {
		return isCached;
	}

	public void setIsCached(String isCached) {
		this.isCached = isCached;
	}

	public String getMaxTime() {
		return maxTime;
	}

	public void setMaxTime(String maxTime) {
		this.maxTime = maxTime;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTemplate() {
		return template;
	}

	public void setTemplate(String template) {
		this.template = template;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getCityId() {
		return cityId;
	}

	public void setCityId(String cityId) {
		this.cityId = cityId;
	}

	public String getGrid() {
		return grid;
	}

	public void setGrid(String grid) {
		this.grid = grid;
	}

	public String getOriSQL() {
		return oriSQL;
	}

	public void setOriSQL(String oriSQL) {
		this.oriSQL = oriSQL;
	}

	/*public Dimension[] getDimensions() {
		return dimensions;
	}

	public void setDimensions(Dimension[] dimensions) {
		this.dimensions = dimensions;
	}

	public Header[] getHeaders() {
		return headers;
	}

	public void setHeaders(Header[] headers) {
		this.headers = headers;
	}

	public String parse() {
		
		if(parse==null){
			parse = new SimpleReportParse();
		}
		return parse.parse(this);
	}
*/
}
