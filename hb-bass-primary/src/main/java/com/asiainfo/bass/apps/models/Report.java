package com.asiainfo.bass.apps.models;

import java.io.Serializable;
import java.util.Map;

import org.springframework.stereotype.Service;

/**
 * 报表的元数据信息
 * 
 * @author Mei Kefu
 * @date 2009-7-24
 * @date 2010-7-16 增加编程功能，添加JS Code块
 */
@Service
@SuppressWarnings({ "rawtypes", "serial" })
public class Report implements Serializable {

	private int id;

	private String name = "",/* 报表的名称 Title */
	grid = "",/* Grid的类型 Ajax Simple */
	maxTime = "",/* 数据的最大时间 */
	useChart = "",/* 是否开启图形 */
	useExcel = "",/* 下载为Excel */
	isAreaAll = "",/* 数据权限为全省 */
	ds = "",/* 数据源 */
	isCached = "",/* 是否开启缓存 */
	oriSQL = "",// 原始的SQL
			codeData = "",// 2010-7-16增加JS代码片段
			regionId = "0";

	private String dimensionData = "";// 查询维度的HTML
	private String headerData = "";// JS需要表头信息数据


	private Map downHeader;
	private String sql;

	/*
	 * public String render(){
	 * 
	 * String result = "";
	 * 
	 * try { StringBuilder sb = new StringBuilder(); BufferedReader br = new
	 * BufferedReader(new
	 * InputStreamReader(Thread.currentThread().getContextClassLoader()
	 * .getResourceAsStream
	 * ("com/asiainfo/hbbass/resources/template/default.htm")));
	 * 
	 * //.getResourceAsStream("default.htm")));
	 * 
	 * String contextPath
	 * =Thread.currentThread().getContextClassLoader().getResource
	 * ("").toString(); contextPath =
	 * contextPath.substring(0,contextPath.indexOf("/WEB-INF/")); contextPath =
	 * contextPath.substring(contextPath.lastIndexOf("/"));
	 * if(contextPath.toLowerCase().indexOf("root")>0){ contextPath=""; }
	 * 
	 * String line = ""; while((line=br.readLine())!=null){
	 * sb.append(line).append("\r\n"); } br.close();
	 * 
	 * result= sb.toString().replaceAll("\\$\\{dimension\\}",
	 * replaceSpecialChar(dimensionData) ) .replaceAll("\\$\\{contextPath\\}",
	 * contextPath) .replaceAll("\\$\\{grid\\}", grid)
	 * .replaceAll("\\$\\{title\\}", name) .replaceAll("\\$\\{cache\\}",
	 * isCached) .replaceAll("\\$\\{ds\\}", ds) .replaceAll("\\$\\{useExcel\\}",
	 * useExcel) .replaceAll("\\$\\{useChart\\}", useChart)
	 * .replaceAll("\\$\\{header\\}", replaceSpecialChar(headerData))
	 * .replaceAll("\\$\\{code\\}", replaceSpecialChar(codeData))
	 * .replaceAll("\\$\\{sql\\}", replaceSpecialChar( oriSQL.replaceAll("\r\n",
	 * " ").replaceAll("\\{condiPiece\\}",
	 * " \"+ aihb.AjaxHelper.parseCondition() +\" ") ));
	 * 
	 * } catch (FileNotFoundException e) { e.printStackTrace(); } catch
	 * (IOException e) { e.printStackTrace(); }
	 * 
	 * return result; }
	 */
	/**
	 * 替换特殊字符
	 * 
	 * @param oriStr
	 * @return
	 */
	protected String replaceSpecialChar(String oriStr) {
		// 替换$为\$
		String str = new String(oriStr).intern();
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
		return sb.length() > 0 ? sb.toString() : oriStr;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getGrid() {
		return grid;
	}

	public void setGrid(String grid) {
		this.grid = grid;
	}

	public String getMaxTime() {
		return maxTime;
	}

	public void setMaxTime(String maxTime) {
		this.maxTime = maxTime;
	}

	public String getUseChart() {
		return useChart;
	}

	public void setUseChart(String useChart) {
		this.useChart = useChart;
	}

	public String getUseExcel() {
		return useExcel;
	}

	public void setUseExcel(String useExcel) {
		this.useExcel = useExcel;
	}

	public String getIsAreaAll() {
		return isAreaAll;
	}

	public void setIsAreaAll(String isAreaAll) {
		this.isAreaAll = isAreaAll;
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

	public String getRegionId() {
		return regionId;
	}

	public void setRegionId(String regionId) {
		this.regionId = regionId;
	}

	public String getDimensionData() {
		return dimensionData;
	}

	public void setDimensionData(String dimensionData) {
		this.dimensionData = dimensionData;
	}

	public String getHeaderData() {
		return headerData;
	}

	public void setHeaderData(String headerData) {
		this.headerData = headerData;
	}

	public String getOriSQL() {
		return oriSQL;
	}

	public void setOriSQL(String oriSQL) {
		this.oriSQL = oriSQL;
	}

	public String getCodeData() {
		return codeData;
	}

	public void setCodeData(String codeData) {
		this.codeData = codeData;
	}

	public Map getDownHeader() {
		return downHeader;
	}

	public void setDownHeader(Map downHeader) {
		this.downHeader = downHeader;
	}

	public String getSql() {
		return sql;
	}

	public void setSql(String sql) {
		this.sql = sql;
	}
}
