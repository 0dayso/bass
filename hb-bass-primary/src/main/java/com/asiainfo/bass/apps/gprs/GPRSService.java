package com.asiainfo.bass.apps.gprs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


@Repository
public class GPRSService {
	
	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(GPRSService.class);
	
	@Autowired
	private GPRSDao gprsDao;
	
	public String getMaxTime(){
		String time = gprsDao.getMaxTime();
		return time;
	}
	
	public String getChannelCode(String cityid){
		return gprsDao.getChannelCode(cityid);
	}
	
	public String getNameByCode(String zb_code){
		return gprsDao.getNameByCode(zb_code);
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public HashMap createImage(String time, String zb_code){
		HashMap result = new HashMap();
		List list = gprsDao.getImageList(time, zb_code);
		if(list!=null && list.size()>0){
			String[] channel_codes = new String[list.size()];
			String[] area_names = new String[list.size()];
			double[] values = new double[list.size()];
			for(int i=0;i<list.size();i++){
				HashMap map = (HashMap)list.get(i);
				channel_codes[i] = map.get("channel_code").toString();
				area_names[i] = map.get("area_name").toString();
				values[i] = Double.parseDouble(map.get("value").toString());
			}
			result.put("date3", channel_codes);
			result.put("date1", area_names);
			result.put("date2", values);
		}
		return result;
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List getCityTree(String time){
		List<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
		List list = gprsDao.getCityTree(time);
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = new HashMap();
				HashMap<String, Object> resultMap = new HashMap<String, Object>();
				map = (HashMap)list.get(i);
				String pid = map.get("pid").toString();
				String channel_code = map.get("channel_code").toString();
				String area_name = map.get("area_name").toString();
				String ind1 = map.get("ind1").toString();
				String ind2 = map.get("ind2").toString();
				String ind3 = map.get("ind3").toString();
				String ind4 = map.get("ind4").toString();
				String ind5 = map.get("ind5").toString();
				String num = map.get("num").toString();
				List<HashMap<String, String>> childrenList = new ArrayList<HashMap<String, String>>();
				for(int j=0;j<list.size();j++){
					HashMap childrenMap = new HashMap();
					childrenMap = (HashMap)list.get(j);
					String childrenPid = childrenMap.get("pid").toString();
					String childrenChannel_code = childrenMap.get("channel_code").toString();
					String childrenArea_name = childrenMap.get("area_name").toString();
					String childrenInd1 = childrenMap.get("ind1").toString();
					String childrenInd2 = childrenMap.get("ind2").toString();
					String childrenInd3 = childrenMap.get("ind3").toString();
					String childrenInd4 = childrenMap.get("ind4").toString();
					String childrenInd5 = childrenMap.get("ind5").toString();
					String childrenNum = childrenMap.get("num").toString();
					if(channel_code.equals(childrenPid)){
						HashMap childrenmap = new HashMap();
						childrenmap.put("pid", childrenPid);
						childrenmap.put("channel_code", childrenChannel_code);
						childrenmap.put("area_name", childrenArea_name);
						childrenmap.put("ind1", childrenInd1);
						childrenmap.put("ind2", childrenInd2);
						childrenmap.put("ind3", childrenInd3);
						childrenmap.put("ind4", childrenInd4);
						childrenmap.put("ind5", childrenInd5);
						childrenmap.put("num", childrenNum);
						childrenList.add(childrenmap);
					}
				}
				resultMap.put("pid", pid);
				resultMap.put("channel_code", channel_code);
				resultMap.put("area_name", area_name);
				resultMap.put("ind1", ind1);
				resultMap.put("ind2", ind2);
				resultMap.put("ind3", ind3);
				resultMap.put("ind4", ind4);
				resultMap.put("ind5", ind5);
				resultMap.put("num", num);
				if(childrenList!=null && childrenList.size()>0){
					resultMap.put("childrenList", childrenList);
				}
				result.add(resultMap);
			}
		}
		return result;
	}

}
