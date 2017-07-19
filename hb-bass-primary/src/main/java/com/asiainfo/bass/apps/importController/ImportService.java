package com.asiainfo.bass.apps.importController;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.asiainfo.bass.apps.log.LogActionService;

@Repository
public class ImportService {

	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(LogActionService.class);
	
	@Autowired
	private ImportDao importDao;
	
	/**
	 * 得到本次导入临时表的内容
	 * @param ds
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public List getInfo(String ds){
		List list = importDao.getTempListByMonthId(ds);
		return list;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap importText(List list, String ds){
		//根据当前月份得到本月导入
		Calendar c = GregorianCalendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		String monthId=sdf.format(c.getTime());
		int insertCount=0;
		int updateCount=0;
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = (HashMap)list.get(i);
				String feeId = map.get("FEE_ID").toString();
				String feeName = map.get("FEE_NAME").toString();
				if(importDao.checkInfo(feeId, monthId, ds)){
					importDao.update(feeId, feeName, monthId, ds);
					updateCount++;
				}else{
					importDao.insert(feeId, feeName, monthId, ds);
					insertCount++;
				}
			}
		}
		HashMap map = new HashMap();
		map.put("insertCount", insertCount);
		map.put("updateCount", updateCount);
		importDao.deleteTemp(ds);
		return map;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map checkForStock(String ds,String userid){
		Map map = new HashMap();
		//清空未导入显示表中
		importDao.deleteViewTmp(ds, userid);
		//把临时表中重复数据移到临时未导入显示表中
		importDao.updateTmpForRepeat(ds);
		//得到临时表所有数据
		List list = importDao.getTmpList(ds);
		//查询临时表中不是湖北移动的号码
		String numbers = checkNumber(ds, list, "acc_nbr");
		//把临时表中不是湖北移动的号码移到临时未导入显示表中
		if(!"".equals(numbers) && numbers!=null){
			importDao.updateTmpForExption(ds, numbers);
		}
		//未导入成功记录条数
		int cnt = importDao.getExptionCount(ds);
		//导入成功记录数
		int count = importDao.getImportCount(ds);
		map.put("cnt", cnt);
		map.put("count", count);
		return map;
	}	
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map checkForStockRegion(String ds,String userid){
		Map map = new HashMap();
		//清空未导入显示表中
		importDao.deleteViewRegionTmp(ds, userid);
		//把临时表中重复数据移到临时未导入显示表中
		importDao.updateRegionTmpForRepeat(ds);
		//得到临时表所有数据
		List list = importDao.getRegionTmpList(ds);
		//查询临时表中不是湖北移动的号码
		String numbers = checkNumber(ds, list,"manager_accnbr");
		//把临时表中不是湖北移动的号码移到临时未导入显示表中
		if(!"".equals(numbers) && numbers!=null){
			importDao.updateRegionTmpForExption(ds, numbers);
		}
		//未导入成功记录条数
		int cnt = importDao.getRegionExptionCount(ds);
		//导入成功记录数
		int count = importDao.getRegionImportCount(ds);
		map.put("cnt", cnt);
		map.put("count", count);
		return map;
	}	
	
	@SuppressWarnings("rawtypes")
	public String checkNumber(String ds, List list, String value){
		String result = "";
		if(list!=null && list.size()>0){
			for(int i=0;i<list.size();i++){
				HashMap map = (HashMap)list.get(i);
				String acc_nbr = map.get(""+value+"").toString();
				boolean flag = true;
				//判断手机号码是否是11位
				if(acc_nbr.length()!=11){
					flag = false;
				}else{
					//判断是否是数字类型
					if(!isNumeric(acc_nbr)){
						flag = false;
					}else{
						//判断是否是湖北移动号码
						flag = isMobileNumber(acc_nbr.substring(0, 7));
						if(!flag){
							result = result.equals("")?"'"+acc_nbr+"'":result+",'"+acc_nbr+"'";
						}
					}
				}
			}
		}
		return result;
	}
	
	public static boolean isNumeric(String str){ 
	    Pattern pattern = Pattern.compile("[0-9]*"); 
	    return pattern.matcher(str).matches();    
	 }  
	
	 public static boolean isMobileNumber(String phone) {
	        boolean isExist = false;

	        phone = phone.trim();
	        if (phone == null || phone.length() < 7) {
	            try {
	                throw new Exception("wrong phone length");
	            } catch (Exception ex) {
	                ex.printStackTrace();
	            }
	        }
	        String code = phone.substring(0, 7);// 暂时保留2009-01-16 16:30

	        if (code.startsWith("134") || code.startsWith("135")
	                || code.startsWith("136") || code.startsWith("137")
	                || code.startsWith("138") || code.startsWith("139")
	                || code.startsWith("159") || code.startsWith("158")
	                || code.startsWith("150") || code.startsWith("157")
	                || code.startsWith("151") || code.startsWith("188")
	                || code.startsWith("189")) {
	            isExist = true;
	        }
	        return isExist;

	    }
}
