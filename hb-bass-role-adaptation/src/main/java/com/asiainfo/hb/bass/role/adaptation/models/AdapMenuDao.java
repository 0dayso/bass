/**
 * 
 */
package com.asiainfo.hb.bass.role.adaptation.models;

import com.asiainfo.hb.bass.role.adaptation.remote.RestRequest;
import com.asiainfo.hb.bass.role.adaptation.service.AdapMenuService;
import com.asiainfo.hb.bass.role.adaptation.util.ProClassUtil;
import com.asiainfo.hb.core.models.BaseDao;
import com.asiainfo.hb.core.models.BeanFactory;
import com.asiainfo.hb.core.util.IsNumber;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;
import org.springframework.util.StringUtils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Future;

/**
 * @author zhangds
 * @date 2015年11月13日
 */
@SuppressWarnings("unused")
@Repository
public class AdapMenuDao extends BaseDao implements AdapMenuService {

	
	private final static String CURRENT_MENU_ALL_SQL = "select ID, NAME, PID, DEEP, "
			+ "DAILY_CODE, DAILY_CUMULATE_CODE, MONTHLY_CODE, MONTHLY_CUMULATE_CODE,"
			+ " CATEGORY, BUREAU_DAILY_CODE, BUREAU_DAILY_CUMULATE_CODE, "
			+ "BUREAU_MONTHLY_CODE, BUREAU_MONTHLY_CUMULATE_CODE "
			+ " from BOC_INDICATOR_MENU where CATEGORY in ("
			+ "SELECT CATEGORY FROM BOC_INDICATOR_MENU where id=?) "
			+ "order by id,pid desc,deep asc";
	private final static String CURRENT_MENU_SQL = "SELECT ID, NAME, PID, DEEP,"
			+ " DAILY_CODE, DAILY_CUMULATE_CODE, MONTHLY_CODE, MONTHLY_CUMULATE_CODE, "
			+ "CATEGORY, BUREAU_DAILY_CODE, BUREAU_DAILY_CUMULATE_CODE, "
			+ "BUREAU_MONTHLY_CODE, BUREAU_MONTHLY_CUMULATE_CODE FROM "
			+ "BOC_INDICATOR_MENU where id =? or pid = ? order by pid desc";

	static final class AdapMenuQuery implements RowMapper<AdapMenu>{
		@Override
		public AdapMenu mapRow(ResultSet rst, int rowNum) throws SQLException {
			//默认都是没有下级
			AdapMenu _menu = new AdapMenu();
				_menu.setDeep(rst.getInt("DEEP"));
				_menu.setMenuId(rst.getString("ID"));
				_menu.setParentmenuId(rst.getString("PID"));
				_menu.setMenuName(rst.getString("NAME"));
				_menu.setDailyCode(rst.getString("DAILY_CODE"));
				_menu.setDailyCumulateCode(rst.getString("DAILY_CUMULATE_CODE"));
				_menu.setMonthlyCode(rst.getString("MONTHLY_CODE"));
				_menu.setMonthlyCumulateCode(rst.getString("MONTHLY_CUMULATE_CODE"));
				_menu.setCategory(rst.getString("CATEGORY"));
				_menu.setBureauDailyCode(rst.getString("BUREAU_DAILY_CODE"));
				_menu.setBureauDailyCumulateCode(rst.getString("BUREAU_DAILY_CUMULATE_CODE"));
				_menu.setBureauMonthlyCode(rst.getString("BUREAU_MONTHLY_CODE"));
				_menu.setBureauMonthlyCumulateCode(rst.getString("BUREAU_MONTHLY_CUMULATE_CODE"));
				_menu.setHasChild("N");
			return _menu;
		}
	}
	
	private List<AdapMenu> getAllMenu(String menuId,String type) {
		if (null != menuId && IsNumber.isNumeric(menuId)) {
			if (null == type){
				return jdbcTemplate.query(CURRENT_MENU_ALL_SQL,
						new Object[] { Integer.parseInt(menuId) },
						new AdapMenuQuery());
			}else{
				return jdbcTemplate.query(CURRENT_MENU_SQL,
						new Object[] { Integer.parseInt(menuId),Integer.parseInt(menuId) },
						new AdapMenuQuery());
			}
		}
		return null;
	}
	
	private Map<String,List<AdapMenu>> getPidKeyMap(List<AdapMenu> list){
		if (null != list && 0<list.size()){
			Map<String,List<AdapMenu>> _map = new HashMap<String,List<AdapMenu>>();
			List<AdapMenu> _list = null;
			for (AdapMenu _menu : list){
				logger.debug("getPidKeyMap,循环list中的menu:"+_menu.getMenuId());
				if (0 == _map.size()){
					_list = new ArrayList<AdapMenu>();
					_list.add(_menu);
					_map.put(_menu.getParentmenuId(),_list);
					logger.debug("getPidKeyMap,循环list中的menu，往里面放的KEY:"+_menu.getParentmenuId());
				}else{
					logger.debug("getPidKeyMap,_menu.getParentmenuId():"+_menu.getParentmenuId());
					if (_map.containsKey(_menu.getParentmenuId())){
						_list = _map.get(_menu.getParentmenuId());
						_list.add(_menu);
					}else{
						_list = new ArrayList<AdapMenu>();
						_list.add(_menu);
						_map.put(_menu.getParentmenuId(),_list);
						logger.debug("getPidKeyMap,循环list中的menu，往里面放的KEY:"+_menu.getParentmenuId());
					}
				}
			}
			return _map;
		}
		return null;
	}
	
	private void recurrenceMenus(AdapMenu menu,Map<String,List<AdapMenu>> map){
		logger.debug("menu:"+menu);
		logger.debug("menu.getMenuId():"+menu.getMenuId());
		if (map.containsKey(menu.getMenuId())){
			menu.setHasChild("Y");
			menu.setChildren(map.get(menu.getMenuId()));
			for (AdapMenu _menu : map.get(menu.getMenuId())){
				logger.debug("从map中得到:"+_menu.getMenuId()+"的menu的对象");
				recurrenceMenus(_menu,map);
			}
		}
	}

	@Override
	//在这里
	public AdapMenu getOneMenus(String menuId) {
		List<AdapMenu> _list = getAllMenu(menuId,null);
		logger.debug("_list:"+_list.size());
		Map<String,List<AdapMenu>> _map = getPidKeyMap(_list);
		logger.debug("_map.get(null).size():"+_map.get(null).size());
		//根菜单默认pid为null
		AdapMenu _rootMenu = (null != _map && 0 < _map.size() && null != _map.get(null)
				&& 0 < _map.get(null).size())?_map.get(null).get(0):null;
		logger.debug("_rootMenu.getMenuId():"+_rootMenu.getMenuId());
		if (null != _rootMenu){
			recurrenceMenus(_rootMenu,_map);
		}
		return _rootMenu;
	}

	@Override
	public AdapMenu getCurrentMenu(String menuId) {
		List<AdapMenu> _list = getAllMenu(menuId,"");
		Map<String,List<AdapMenu>> _map = getPidKeyMap(_list);
		AdapMenu _currentMenu = null;
		if (null != _map && 0 < _map.size() ){
			for (String key : _map.keySet()){
				List<AdapMenu> _sublist = _map.get(key);
				if (null != _sublist && 0 < _sublist.size() 
						&& menuId.equals(_sublist.get(0).getMenuId())){
					_currentMenu = _sublist.get(0);
					_currentMenu.setHasChild(null != _map.get(menuId)?"Y":"N");
					_currentMenu.setChildren(null != _map.get(menuId)?_map.get(menuId): null);
					break;
				}
			}
		}
		return _currentMenu;
	}

//	@Override
//	public AdapMenu getAdapMenuAndKpiDate(AdapMenu menu, String regionId,String date,String viewType,String timeType) {
//		List<String> dimColumName = new ArrayList<String>();
//		if ("Bureau".equalsIgnoreCase(viewType)){
//			//bureauDailyCode,bureauDailyCumulateCode, bureauMonthlyCode, bureauMonthlyCumulateCode
//			if ("yymm".equalsIgnoreCase(timeType)){
//				dimColumName.add("bureauMonthlyCode");
//				dimColumName.add("bureauMonthlyCumulateCode");
//			}else{
//				dimColumName.add("bureauDailyCode");
//				dimColumName.add("bureauDailyCumulateCode");
//			}
//		}else{
//			//dailyCode,dailyCumulateCode,monthlyCode,monthlyCumulateCode
//			if ("yymm".equalsIgnoreCase(timeType)){
//				dimColumName.add("monthlyCode");
//				dimColumName.add("monthlyCumulateCode");
//			}else{
//				dimColumName.add("dailyCode");
//				dimColumName.add("dailyCumulateCode");
//			}
//		}
//		if (dimColumName.size()==2){
//			menu = getKpiData(menu,dimColumName,regionId,date);
//		}
//		return menu;
//	}
	
	public AdapMenu getAdapMenuAndKpiDate(AdapMenu menu,String timeType,String time,String dimType,String dimValue){
		List<String> dimColumName = new ArrayList<String>();
		timeType = timeType.replaceAll("-", "");
		time = time.replaceAll("-", "");
		if ("yymm".equalsIgnoreCase(timeType)){
			dimColumName.add("monthlyCode");
			dimColumName.add("monthlyCumulateCode");
		}else{
			dimColumName.add("dailyCode");
			dimColumName.add("dailyCumulateCode");
		}
		if (dimColumName.size()==2){
			menu = getKpiData(menu,dimColumName,time,dimType,dimValue);
		}
		return menu;
	}
	
//	private AdapMenu getKpiData(AdapMenu menu,List<String> list,String regionId,String date){
//		menu = getKpiDataByOneMenu(menu,list,regionId,date);
//		if (null != menu.getChildren()){
//			List<AdapMenu> _childMenu = menu.getChildren();
//			for (AdapMenu _menu :_childMenu){
//				getKpiDataByOneMenu(_menu,list,regionId,date);
//			}
//		}
//		return menu;
//	}
	
	/**
	 * 
	 * @param menu
	 * @param list 维度列名集合
	 * @param time
	 * @param dimType 维度类型
	 * @param dimValue 维度值
	 * @return
	 */
	private AdapMenu getKpiData(AdapMenu menu,List<String> list,String time,String dimType,String dimValue) {
		long start = System.currentTimeMillis();
		menu = getKpiDataByOneMenu(menu,list,time,dimType,dimValue);
		/*if (null != menu.getChildren()){
			List<AdapMenu> _childMenu = menu.getChildren();
			List<Future> futrues = new ArrayList<Future>();
			//for (AdapMenu _menu :_childMenu){
			//	getKpiDataByOneMenu(_menu, list, time, dimType, dimValue);
			//}
			AdapMenuAsyncService adapMenuAsyncService = (AdapMenuAsyncService)BeanFactory.getBean("adapMenuAsyncService");
			for (AdapMenu _menu :_childMenu){
				logger.debug(_menu.getMenuName());
				Future future = adapMenuAsyncService.getKpiDataByOneMenuAsync(_menu, list, time, dimType, dimValue);
				futrues.add(future);
			}
			for (Future future : futrues) {
				try {
					while (true) {
						if (future.isDone()) {
							break;
						} else {
							Thread.sleep(100);
						}
					}
				}catch (InterruptedException e1){
					e1.printStackTrace();
				}
			}
		}*/
		logger.debug("封装好KPI数据的指标内容："+menu);
		return menu;
	}
	
//	private AdapMenu getKpiDataByOneMenu(AdapMenu menu,List<String> list,String regionId,String date){
//		List<String> kpiIds = getKpiId(menu,list);
//		if (null != kpiIds){
//			for (int i=0;i<kpiIds.size();i++){
//				Map<String,Object> map = new ConcurrentHashMap<String,Object>();
//				String kpiId = null!=kpiIds.get(i)?kpiIds.get(i):null;
//				map.put("id", kpiId);
//				if (null != kpiId){
//					Kpi kpi = kpiService.loadKpi(kpiId, date, "PROV_ID","HB");
//					if (null != kpi){
//						map.putAll(kpiService.getKpiToMap(kpi));
//					}
//				}
//				if (0==i){
//					menu.setValueD(map);
//				}else{
//					menu.setValueAD(map);
//				}
//			}
//		}
//		return menu;
//	}

	@SuppressWarnings("unchecked")
	public AdapMenu getKpiDataByOneMenu(AdapMenu menu,List<String> list,String time,String dimType,String dimValue){

		logger.debug("步骤2：根据menu和维度类型字段查找对应的kpicode");
		List<String> kpiCodeList = new ArrayList<String>();
		if (null != menu && null != list){
			for (String _string : list ){
				if (null != ProClassUtil.getFieldValueByName(_string, menu)){
					String kpiCode = (String)ProClassUtil.getFieldValueByName(_string, menu);
					kpiCodeList.add(kpiCode);
					logger.debug("维度类型字段:"+_string+"对应的kpi_code:"+kpiCode);
				}
			}
		}
		if (null != kpiCodeList){
			boolean isSetUnit = false;
			for (int i=0;i<kpiCodeList.size();i++){
				Map<String,Object> map = new HashMap<String,Object>();
				String kpiCode = null!=kpiCodeList.get(i)?kpiCodeList.get(i):null;
				map.put("id", kpiCode);
				if (!StringUtils.isEmpty(kpiCode)){
					//通过REST方式调用
					Map<String,Object> restParam = new HashMap<String, Object>();
					restParam.put("date", time);
					restParam.put("dimId", dimType);
					restParam.put("dimValue", dimValue);
					logger.debug("步骤3：REST方式调用，根据kpicode："+kpiCode+"，日期："+time+"，地域类型："+dimType+"，地域值："+dimValue+"的维度查找对应的kpi");
					Map<String, ?> kpiData = RestRequest.getObjectFromRest("/server/kpi/"+kpiCode, restParam, Map.class);
					//logger.debug("REST查询后返回的结果为：" + kpiData);
					if (kpiData != null) {
						logger.debug("REST查询后返回的结果size为：" + kpiData.size());
					} else {
						logger.debug("REST查询后返回的结果为null");
					}
			
					if(kpiData != null)map.putAll(kpiData);
					if(map.get("unit") !=  null && !"null".equalsIgnoreCase(map.get("unit").toString()) && !isSetUnit){
						//修改指标名称，加上单位
						menu.setMenuName(menu.getMenuName()+"("+map.get("unit").toString()+")");
						isSetUnit = true;
					}
				}
				if (0==i){
					//设置直接来源的数据
					menu.setValueD(map);
				}else{
					//设置计算指标的数据
					menu.setValueAD(map);
				}
			}
		}
		//logger.debug("要返回的menu为:"+menu);
		return menu;
	}

	@Override
	public List<Map<String, Object>> getRepCenter(String name) {
		List<Object> list = new ArrayList<Object>();
		String sql="SELECT id, NAME FROM BOC_INDICATOR_MENU where pid is null  ";
		if(name!=null&&name.length()>0){
			sql=sql+" and NAME like ? ";
			list.add("%"+name+"%");
		}
		sql=sql+"ORDER BY ID";
		return jdbcTemplate.queryForList(sql,list.toArray());
	}

	@Override
	public String getTitle(int menuId) {
		String sql="SELECT id, NAME FROM BOC_INDICATOR_MENU where pid is null and id="+menuId+"  ";
		String name="";
		for(Map<String,Object> m:jdbcTemplate.queryForList(sql)){
			name=(String) m.get("name");
			System.out.println(m.get("name"));
		}
		return name;
	}

	

}
