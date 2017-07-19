package com.asiainfo.bass.apps.terminal;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
/*代码真烂*/
@Repository
public class TerminalService {
	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(TerminalService.class);
	
	@Autowired
	private TerminalDao terminalDao;
	
	public String getCityId(String cityId) throws Exception{
		String city = "";
		if(!"".equals(cityId) && cityId.equals("0") || cityId.equals("HB")){
			city = "HB";
		}else if(!"".equals(cityId)){
			city = terminalDao.getAreaCode(cityId);
		}
		return city;
	}
	
	public List<Map<String,Object>> getCityList(String cityid) throws Exception{
		List<Map<String,Object>> list = null;
		if("HB".equals(cityid)){
			list = terminalDao.getCityList();
		}else{
			list = terminalDao.getCityList(cityid);
		}
		return list;
	}
	
	public String getMaxTime() throws Exception{
		return terminalDao.getMaxTime();
	}
	
	public String getMaxIndexTime() throws Exception{
		return terminalDao.getMaxIndexTime();
	}
	
	public String getMaxAfterTime() throws Exception{
		return terminalDao.getMaxAfterTime();
	}
	
	public String getMaxSalingTime() throws Exception{
		return terminalDao.getMaxSalingTime();
	}
	
	public List<Map<String,Object>> getList(String time, String cityId) throws Exception{
		return terminalDao.getTopList(time, cityId);
	}
	
	@SuppressWarnings("rawtypes")
	public HashMap<String,Object> getInventoryMap(String time, String cityId, String type, int status) throws Exception{
		HashMap<String,Object> resultMap = new HashMap<String,Object>();
		List<Map<String,Object>> list = terminalDao.getInventory(time, cityId, type, status);
		if(list!=null && list.size()>0){
			double[] date1 = new double[list.size()];
			double[] date2 = new double[list.size()];
			String[] columns = new String[list.size()];
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				columns[i] = map.get("dim2").toString();
				date1[i] = Double.parseDouble(map.get("ind1").toString());
				date2[i] = Double.parseDouble(map.get("ind3").toString());
			}
			resultMap.put("date1", date1);
			resultMap.put("date2", date2);
			resultMap.put("columns", columns);
		}
		return resultMap;
	}
	
	public HashMap<String,Object> getUsingMap(String time, String cityId, String type, int status) throws Exception{
		HashMap<String,Object> resultMap = new HashMap<String,Object>();
		List<Map<String,Object>> list = terminalDao.getUsing(time, cityId, type, status);
		if(list!=null && list.size()>0){
			double[] date1 = new double[list.size()];//销售量
			double[] date2 = new double[list.size()];//激活量
			double[] date3 = new double[list.size()];//激活率
			String[] columns = new String[list.size()];
			for(int i=0;i<list.size();i++){
				Map<String,Object> map = (Map<String,Object>)list.get(i);
				columns[i] = map.get("area_name").toString();
				date1[i] = Double.parseDouble(map.get("ind1").toString());
				date2[i] = Double.parseDouble(map.get("ind2").toString());
				date3[i] = Double.parseDouble(map.get("ind3").toString());
			}
			resultMap.put("date1", date1);
			resultMap.put("date2", date2);
			resultMap.put("date3", date3);
			resultMap.put("columns", columns);
		}
		return resultMap;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getAnalysisListMap(String time, String cityId, int status) throws Exception{
		HashMap resultMap = new HashMap();
		List<Map<String,Object>> list = terminalDao.AnalysisList(time, cityId, status);
		if(list!=null && list.size()>0){
			double[] date1 = new double[list.size()];//终端户均补贴
			double[] date2 = new double[list.size()];//终端户均产出
			double[] date3 = new double[list.size()];//投入产出比
			String[] columns = new String[list.size()];
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				columns[i] = map.get("area_name").toString();
				date1[i] = Double.parseDouble(map.get("ind1").toString());
				date2[i] = Double.parseDouble(map.get("ind2").toString());
				date3[i] = Double.parseDouble(map.get("ind3").toString());
			}
			resultMap.put("date1", date1);
			resultMap.put("date2", date2);
			resultMap.put("date3", date3);
			resultMap.put("columns", columns);
		}
		return resultMap;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getSalingListMap(String beginTime, String endTime, String cityId, String status,String type) throws Exception{
		HashMap result = new HashMap();
		List<Map<String,Object>> list = null;
		if(!"".equals(type) && "1".equals(type)){
			list = terminalDao.getSalingListMap(beginTime, endTime, cityId, status, type);
		}else if(!"".equals(type) && "2".equals(type)){
			try {
				DateFormat df = new SimpleDateFormat("yyyyMMdd");
				java.util.Date d1 = df.parse(endTime);
				Calendar  g = Calendar.getInstance();
				g.setTime(d1);
	            int month = g.get(Calendar.MONTH)+1;
				String times = endTime;
				for(int i=1;i<month;i++){
					g.add(Calendar.MONTH, -1);
					String year = String.valueOf(g.get(Calendar.YEAR));
					String Month = String.valueOf(g.get(Calendar.MONTH)+1);
					if(Month.length()==1){
						Month = "0"+Month;
					}
					String day = String.valueOf(g.get(Calendar.DAY_OF_MONTH));
					if(day.length()==1){
						day = "0"+day;
					}
					String time = year + Month + day;
					times = times + "," + time;
				}
				list = terminalDao.getSalingListMapByType(times, cityId, status, type);
			} catch (ParseException e) {
				e.printStackTrace();
			}  
		}
		if(list!=null && list.size()>0){
			double[] date1 = new double[list.size()];//终端销售量
			double[] date2 = new double[list.size()];//环比增长
			String[] columns = new String[list.size()];
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				if(!"".equals(type) && "1".equals(type)){
					columns[i] = map.get("time_id").toString()+"号";
				}else if(!"".equals(type) && "2".equals(type)){
					columns[i] = map.get("time_id").toString()+"月";
				}
				date1[i] = Double.parseDouble(map.get("ind1").toString());
				date2[i] = Double.parseDouble(map.get("ind2").toString());
			}
			result.put("date1", date1);
			result.put("date2", date2);
			result.put("columns", columns);
		}
		return result;
	}
	
	@SuppressWarnings({ "rawtypes", "unused", "unchecked" })
	public HashMap getSalingByCityListMap(String beginTime, String endTime, String cityId, String status,String type) throws Exception{
		HashMap result = new HashMap();
		List list = terminalDao.getSalingByCityListMap(beginTime, endTime, cityId, status, type);
		if(list!=null && list.size()>0){
			double[] date1 = new double[list.size()];//终端销售量
			double[] date2 = new double[list.size()];//环比增长
			String[] columns = new String[list.size()];
			for(int i=0;i<list.size();i++){
				Map map = (Map)list.get(i);
				columns[i] = map.get("area_name").toString();
				date1[i] = Double.parseDouble(map.get("ind1").toString());
			}
			result.put("date1", date1);
			result.put("columns", columns);
		}
		return result;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getTurnover(String time, String cityId, String type) throws Exception{
		HashMap map = new HashMap();
		Map turnoverMap = terminalDao.getTurnover(time, cityId, type, 4);
		if(!turnoverMap.isEmpty()){
			String inStorage = turnoverMap.get("ind1").toString();//入库数量
			String outStorage = turnoverMap.get("ind2").toString();//出库数量
			String turnover = turnoverMap.get("ind3").toString(); //实际库存
			String sales = turnoverMap.get("ind4").toString(); //前15天日均销量
			String num = turnoverMap.get("ind5").toString(); //可支撑天数
			String status = turnoverMap.get("alert").toString();//库存状态
			List citylist = terminalDao.getWarningCity(time, cityId, type, "5");
			String warningCity = "";//预警地区
			if(citylist!=null && citylist.size()>0){
				for(int i=0;i<citylist.size();i++){
					HashMap cityMap = (HashMap)citylist.get(i);
					if(i==0){
						warningCity = cityMap.get("areaname").toString();
					}else{
						warningCity = warningCity + "&nbsp;&nbsp;&nbsp;" + cityMap.get("areaname").toString();
					}
				}
			}else{
				warningCity = "无预警地区";
			}
			List warningTypeList = terminalDao.getWarningType(time, cityId, type, "6");
			String warningType = "";//预警终端型号
			if(warningTypeList!=null && warningTypeList.size()>0){
				for(int i=0;i<warningTypeList.size();i++){
					HashMap warningTypeMap = (HashMap)warningTypeList.get(i);
					if(i==0){
						warningType = warningTypeMap.get("dim2").toString();
					}else{
						warningType = warningType + "&nbsp;&nbsp;&nbsp;" + warningTypeMap.get("dim2").toString();
					}
				}
			}else{
				warningType = "无预警机型";
			}
			map.put("inStorage", inStorage);
			map.put("outStorage", outStorage);
			map.put("turnover", turnover);
			map.put("sales", sales);
			map.put("num", num);
			map.put("status", status);
			map.put("warningCity", warningCity);
			map.put("warningType", warningType);
		}else{
			map.put("inStorage", "-");
			map.put("outStorage", "-");
			map.put("turnover", "-");
			map.put("sales", "-");
			map.put("num", "-");
			map.put("status", "");
			map.put("warningCity", "-");
			map.put("warningType", "-");
		}
		return map;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getWarningMap(String cityId, String time, String status, String type) throws Exception{
		String rate = "";
		String citys = "";
		double rate1=0;
		HashMap  result = new HashMap();
		List list = terminalDao.getWarningList(cityId,time,status,type);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = (HashMap)list.get(i);
				rate1 = Double.parseDouble(map.get("ind1").toString());
				int index = map.get("dim3").toString().indexOf("预警");
				if(index>-1){
					citys = citys.equals("")?map.get("dim2").toString():citys+"、"+map.get("dim2").toString();
				}
			}
			BigDecimal bigDecimal = new BigDecimal(rate1);
			rate = bigDecimal.setScale(2, BigDecimal.ROUND_HALF_UP)+"%";
			result.put("rate", rate);
			result.put("citys", citys);
		}else{
			result.put("rate", "-");
			result.put("citys", "无预警地区");
		}
		return result;
	}
	
	public List<Map<String,Object>> getMarketingList(String cityId, String time, int status, String type, String type1) throws Exception{
		return terminalDao.getMarketingList(cityId,time,status,type,type1);
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getAnalysisMap(String cityId, String time, String status) throws Exception{
		HashMap result = new HashMap();
		Map map = terminalDao.getAnalysisMap(cityId,time,status);
		if(!map.isEmpty()){
			double money = Double.parseDouble(map.get("ind1").toString());
			double rate1 = Double.parseDouble(map.get("ind2").toString());
			BigDecimal bigDecimal = new BigDecimal(rate1);
			String rate = bigDecimal.setScale(2, BigDecimal.ROUND_HALF_UP)+"%";
			result.put("rate", rate);
			result.put("money", money);
		}else{
			result.put("rate", "-");
			result.put("money", "-");
		}
		return result;
	}
	
	public List<Map<String,Object>> getSaleList(String status, String time, String type, String cityid) throws Exception{
		return terminalDao.getSaleList(status, time, type, cityid);
	}
	
	public List<Map<String,Object>> getChannelSaleList(String status, String time, String type, String cityid) throws Exception{
		return terminalDao.getChannelSaleList(status, time, type, cityid);
	}
	
	@SuppressWarnings({ "unused", "rawtypes" })
	public Map getSaleByCityMap(String status, String time, String cityid) throws Exception{
		HashMap result = new HashMap();
		return terminalDao.getSaleByCityMap(status, time, cityid);
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getSaleStructureMap(String status, String time, String type, String cityid) throws Exception{
		HashMap result = new HashMap();
		double isBare = terminalDao.getIsValue(status, time, type, cityid, "是否裸机");
		double isStock = terminalDao.getIsValue(status, time, type, cityid, "库存类型");
		double isIntelligent = terminalDao.getIsValue(status, time, type, cityid, "智能机");
		double bare = 100-isBare;
		double stock = 100-isStock;
		double intelligent = 100-isIntelligent;
		result.put("isBare", isBare);
		result.put("isStock", isStock);
		result.put("isIntelligent", isIntelligent);
		result.put("bare", bare);
		result.put("stock", stock);
		result.put("intelligent", intelligent);
		return result;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getPaulInfoMap(String status, String time, String type, String cityid) throws Exception{
		HashMap result = new HashMap();
		String ind1 = "";
		String ind2 = "";
		String areaName = "";
		List list = terminalDao.getPaulInfoMap(status, time, type, cityid);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = (HashMap)list.get(i);
				double double1 = Double.parseDouble(map.get("ind1").toString());
				double double2 = Double.parseDouble(map.get("ind2").toString());
				double double3 = Double.parseDouble(map.get("ind3").toString());
				String area_name = map.get("area_name").toString();
				if(double3==0){
					areaName = areaName.equals("")?area_name:areaName+"、"+area_name;
				}
				ind1 = String.valueOf(double1);
				ind2 = String.valueOf(double2);
			}
		}
		result.put("ind1", ind1);
		result.put("ind2", ind2);
		result.put("areaName", areaName);
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public Map<String,List<Map<String,Object>>> getMenuMap(String menuitemid) throws Exception{
		Map<String,List<Map<String,Object>>> result = new HashMap();
		//得到所有菜单
		List list = terminalDao.getMenuList(menuitemid);
		List subjectList = new ArrayList();
		if(list!=null && list.size()>0){
			for (int i = 0; i < list.size(); i++) {
				Map elemMap = (Map) list.get(i);
				elemMap.put("subjects", terminalDao.getChildList(elemMap.get("id").toString()));
				subjectList.add(elemMap);
			}
		}
		result.put("elements", subjectList);
		return result;
	}
	
	@SuppressWarnings({ "unused", "rawtypes" })
	public List<Map<String,Object>> getIndexInfo(String cityid, String time)throws Exception{
		HashMap result = new HashMap();
		return terminalDao.getIndexInfo(cityid, time);
	}
	
	@SuppressWarnings({ "rawtypes", "unused" })
	public List<Map<String,Object>> getIndexInfo2(String cityid, String time)throws Exception{
		HashMap result = new HashMap();
		return terminalDao.getIndexInfo2(cityid, time);
	}
	
	@SuppressWarnings({ "unused", "rawtypes" })
	public List<Map<String,Object>> getIndexInfoPreAndSal(String cityid, String time)throws Exception{
		HashMap result = new HashMap();
		return terminalDao.getIndexInfoPreAndSal(cityid, time);
	}
	
	@SuppressWarnings({ "rawtypes", "unused" })
	public List<Map<String,Object>> getIndexInfoAfter(String cityid, String time)throws Exception{
		HashMap result = new HashMap();
		return terminalDao.getIndexInfoAfter(cityid, time);
	}
	
	@SuppressWarnings({ "unused", "rawtypes" })
	public List<Map<String,Object>> getSalAndOneSeason(String cityid, String time)throws Exception{
		HashMap result = new HashMap();
		return terminalDao.getSalAndOneSeason(cityid, time);
	}
	
	@SuppressWarnings({ "rawtypes", "unused" })
	public List<Map<String,Object>> getAfte2GChange(String cityid, String time)throws Exception{
		HashMap result = new HashMap();
		return terminalDao.getAfte2GChange(cityid, time);
	}
	
	public List<Map<String,Object>> getChannelCode(String cityid) throws Exception{
		return terminalDao.getChannelCode(cityid);
	}
	
	public List<Map<String,Object>> getRectimestampsale(String time) throws Exception{
		return terminalDao.getRectimestampsale(time);
	}
	
	public List<Map<String,Object>> getTime() throws Exception{
		return terminalDao.getTime();
	}
	
	public List<Map<String,Object>> getTimeWithDay() throws Exception{
		return terminalDao.getTimeWithDay();
	}
	
	public boolean isSpecial(String groupId){
		boolean flag = false;
		String[] groupIds = {"18015", "20002", "26082", "18015_qj", "18015_tm", "27", "28", "14", "12", "26", "17", "16", "24", "13", "20", "18", "11", "19", "25", "15", "23", "8a99fcf33ee9100e013f513a5fda0003", "26006", "26007", "26008", "26010", "26011", "26012", "26013", "26014", "26015", "26016", "26017", "26018", "26019", "12001", "14001", "16001", "17001", "26009", "19001", "23001", "24001", "26009_qj", "26009_tm"};
		for(int i=0;i<groupIds.length;i++){
			String group_id = groupIds[i];
			if(group_id.equals(groupId)){
				flag = true;
				break;
			}
		}
		return flag;
	}

}
