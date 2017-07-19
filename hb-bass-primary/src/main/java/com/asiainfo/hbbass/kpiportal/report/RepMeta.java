package com.asiainfo.hbbass.kpiportal.report;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;

import com.asiainfo.hbbass.common.jdbc.ConnectionManage;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQuery;
import com.asiainfo.hbbass.common.jdbc.wrapper.SQLQueryContext;
import com.asiainfo.hbbass.component.dimension.BassDimHelper;
import com.asiainfo.hbbass.component.json.JsonHelper;
import com.asiainfo.hbbass.kpiportal.core.KPIAppData;
import com.asiainfo.hbbass.kpiportal.core.KPIEntity;
import com.asiainfo.hbbass.kpiportal.core.KPIEntityInitialize;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;
import com.asiainfo.hbbass.kpiportal.service.KPIPortalService;

/**
 * 报表的元数据信息 持久化到数据库
 * 
 * @author Mei Kefu
 * 
 */
public class RepMeta {

	private String key = "";

	private String name = "";

	private String time = "";

	private String timeFrom = "";

	private String timeDetail = "";

	private String cityId = "0";// 2010-7-8 增加权限判断

	private String appName = "";

	private boolean isPre = false;

	private boolean isBefore = false;

	private boolean isYear = false;

	private boolean isProgress = false;

	@SuppressWarnings("rawtypes")
	private List zbCodes = null;

	private String dimensionData = "";

	private int deep = 0;
	private int column = 0;
	private String areaValue = "";

	// private JSONWriter jsonWriter = new JSONWriter(false);

	@SuppressWarnings("unused")
	private static Logger LOG = Logger.getLogger(RepMeta.class);

	public Area root = null;

	public RepMeta(String key) {
		this.key = key;
	}

	public static class Indicator {
		public String key = "", dataIndex = "", cellFunc = "", cellStyle = "", title = "", appName = "";

		@SuppressWarnings("rawtypes")
		public List name = new ArrayList();
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	private void processRowSpan(List names, int nameLength) {
		for (int i = 0; i < nameLength - 1; i++) {
			names.add("#rspan");
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void processColSpan(List names, int nameLength) {
		for (int i = 0; i < nameLength - 1; i++) {
			names.add("#cspan");
		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void initialize() {
		root = new Area();
		root.name = "city";
		root.text = "地市";
		root.value = "HB";

		SQLQuery sqlQuery = SQLQueryContext.getInstance().getSQLQuery("list", "web", false);

		List list = (List) sqlQuery.query("select a.name,a.data_index,b.value,c.name from FPF_IRS_SUBJECT_INDICATOR a,FPF_IRS_SUBJECT_EXT b,FPF_IRS_SUBJECT c where c.id=a.sid and  a.sid=b.sid and b.code='100' and a.sid=" + key + " order by a.seq with ur");
		int nameLength = 1;
		if (list.size() > 0) {
			nameLength = ((String[]) list.get(0))[0].split(",").length;
		}

		zbCodes = new LinkedList();
		Indicator indicator = new Indicator();
		indicator.name.add("统计周期");
		processRowSpan(indicator.name, nameLength);
		indicator.dataIndex = "time";
		zbCodes.add(indicator);

		indicator = new Indicator();
		indicator.name.add("地市");
		processRowSpan(indicator.name, nameLength);
		indicator.dataIndex = "city";
		zbCodes.add(indicator);

		String[] lines = null;

		for (int i = 0; i < list.size(); i++) {
			lines = (String[]) list.get(i);
			indicator = new Indicator();
			indicator.key = lines[1];
			// indicator.name="["+lines[0]+"]";

			String[] lineNames = lines[0].split(",");

			for (int j = 0; j < lineNames.length; j++) {
				indicator.name.add(lineNames[j]);
			}

			indicator.dataIndex = lines[1];
			appName = lines[2];
			name = lines[3];
			indicator.cellStyle = "grid_row_cell_number";

			zbCodes.add(indicator);

			Indicator pre = new Indicator();
			// pre.name="环比增长";
			processColSpan(pre.name, nameLength);
			pre.name.add("环比增长");

			pre.dataIndex = "pre" + lines[1];
			pre.cellStyle = "grid_row_cell_number";
			pre.cellFunc = "aihb.Util.percentFormat";

			zbCodes.add(pre);

			Indicator before = new Indicator();
			// before.name="同比增长";
			processColSpan(before.name, nameLength);
			before.name.add("同比增长");

			before.dataIndex = "before" + lines[1];
			before.cellStyle = "grid_row_cell_number";
			before.cellFunc = "aihb.Util.percentFormat";

			zbCodes.add(before);

			if (appName.endsWith("D")) {// 如果是日指标就有年同比
				Indicator year = new Indicator();
				// year.name="年同比增长";
				processColSpan(year.name, nameLength);
				year.name.add("年同比增长");

				year.dataIndex = "year" + lines[1];
				year.cellStyle = "grid_row_cell_number";
				year.cellFunc = "aihb.Util.percentFormat";
				zbCodes.add(year);
			}
			Indicator progress = new Indicator();
			// progress.name="完成进度";
			processColSpan(progress.name, nameLength);
			progress.name.add("完成进度");

			progress.dataIndex = "progress" + lines[1];
			progress.cellStyle = "grid_row_cell_number";
			progress.cellFunc = "aihb.Util.percentFormat";
			zbCodes.add(progress);
		}
		Map map = KPIPortalService.getAKPIMap(appName);

		for (int i = 0; i < zbCodes.size(); i++) {
			indicator = (Indicator) zbCodes.get(i);
			if (indicator.key != null && indicator.key.length() > 0) {
				KPIEntity kpiEntity = (KPIEntity) map.get(indicator.key);

				if (kpiEntity != null) {
					if ("percent".equalsIgnoreCase(kpiEntity.getKpiMetaData().getFormatType()))
						indicator.cellFunc = "aihb.Util.percentFormat";
					else
						indicator.cellFunc = "aihb.Util.numberFormat";
					indicator.title = kpiEntity.getKpiMetaData().getInstruction();
					indicator.appName = appName;
				}
			}
		}

		if (appName.startsWith("Bureau")) {
			Area child = new Area();
			root.child = child;
			child.parent = root;
			child.name = "county_bureau";
			child.text = "县市";

			Area child1 = new Area();
			child.child = child1;
			child1.parent = child;
			child1.name = "marketing_center";
			child1.text = "营销中心";

			indicator = new Indicator();
			// indicator.name="[县市"+postFix+"]";

			indicator.name.add("县市");
			processRowSpan(indicator.name, nameLength);

			indicator.cellStyle = "grid_row_cell_text";
			indicator.dataIndex = "county_bureau";
			zbCodes.add(1, indicator);

			indicator = new Indicator();
			// indicator.name="[营销中心"+postFix+"]";

			indicator.name.add("营销中心");
			processRowSpan(indicator.name, nameLength);

			indicator.cellStyle = "grid_row_cell_text";
			indicator.dataIndex = "marketing_center";
			zbCodes.add(2, indicator);
		} else if (appName.startsWith("EntGrid")) {
			Area child = new Area();
			root.child = child;
			child.parent = root;
			child.name = "ent_grid_main";
			child.text = "主网格";

			Area child1 = new Area();
			child.child = child1;
			child1.parent = child;
			child1.name = "ent_grid_sub";
			child1.text = "子网格";

			indicator = new Indicator();
			// indicator.name="主网格";

			indicator.name.add("主网格");
			processRowSpan(indicator.name, nameLength);

			indicator.cellStyle = "grid_row_cell_text";
			indicator.dataIndex = "ent_grid_main";
			zbCodes.add(1, indicator);

			indicator = new Indicator();
			// indicator.name="子网格";

			indicator.name.add("子网格");
			processRowSpan(indicator.name, nameLength);

			indicator.cellStyle = "grid_row_cell_text";
			indicator.dataIndex = "ent_grid_sub";
			zbCodes.add(2, indicator);
		} else if (appName.startsWith("College")) {
			Area child = new Area();
			root.child = child;
			child.parent = root;
			child.name = "college";
			child.text = "高校";

			indicator = new Indicator();
			// indicator.name="高校";

			indicator.name.add("高校");
			processRowSpan(indicator.name, nameLength);

			indicator.cellStyle = "grid_row_cell_text";
			indicator.dataIndex = "college";
			zbCodes.add(1, indicator);
		} else if (appName.startsWith("Groupcust")) {
			Area child = new Area();
			root.child = child;
			child.parent = root;
			child.name = "entCounty";
			child.text = "县市";

			Area child1 = new Area();
			child.child = child1;
			child1.parent = child;
			child1.name = "custmgr";
			child1.text = "客户经理";

			indicator = new Indicator();
			// indicator.name="县市";

			indicator.name.add("县市");
			processRowSpan(indicator.name, nameLength);

			indicator.cellStyle = "grid_row_cell_text";
			indicator.dataIndex = "entCounty";
			zbCodes.add(1, indicator);

			indicator = new Indicator();
			// indicator.name="客户经理";

			indicator.name.add("客户经理");
			processRowSpan(indicator.name, nameLength);

			indicator.cellStyle = "grid_row_cell_text";
			indicator.dataIndex = "custmgr";
			zbCodes.add(2, indicator);
		} else {
			Area child = new Area();
			root.child = child;
			child.parent = root;
			child.name = "county";
			child.text = "县市";

			indicator = new Indicator();
			// indicator.name="县市";

			indicator.name.add("县市");
			processRowSpan(indicator.name, nameLength);

			indicator.cellStyle = "grid_row_cell_text";
			indicator.dataIndex = "county";
			zbCodes.add(1, indicator);
		}

		if (time.length() == 0) {
			time = KPIPortalContext.getAppDefaultDate(appName);
		}
	}

	public void delete() {
		Connection conn = null;
		try {
			int id = Integer.parseInt(key);
			conn = ConnectionManage.getInstance().getWEBConnection();

			PreparedStatement ps = conn.prepareStatement("delete from FPF_IRS_SUBJECT where id=?");
			ps.setInt(1, id);
			ps.execute();
			ps.close();

			ps = conn.prepareStatement("delete from FPF_IRS_SUBJECT_INDICATOR where sid=?");
			ps.setInt(1, id);
			ps.execute();
			ps.close();

			ps = conn.prepareStatement("delete from FPF_IRS_SUBJECT_EXT where sid=?");
			ps.setInt(1, id);
			ps.execute();
			ps.close();

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			ConnectionManage.getInstance().releaseConnection(conn);
		}
	}

	public static class Area {
		public String value = "", // 映射form的值
				detail = "",// 映射form的值是否细分
				name,// 统一使用名称
				text;// title的文字

		public Area parent;

		public Area child;
	}

	public String getHeaderData() {
		return JsonHelper.getInstance().write(zbCodes);
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String query() {

		processState();

		if (timeFrom == null || timeFrom.length() == 0) {// 表示是时间点
			Map map = KPIPortalService.getKPIMap(appName, time);

			List list = new ArrayList();
			Object obj1 = null;
			for (int i = 0; i < zbCodes.size(); i++) {
				Indicator indicator = (Indicator) zbCodes.get(i);
				if (indicator.key.length() > 0) {
					obj1 = map.get(indicator.key);
					if (obj1 != null)
						list.add(obj1);
				}
			}

			List data = new ArrayList();

			for (int i = 0; i < list.size(); i++) {

				KPIEntity kpiEntity = (KPIEntity) list.get(i);

				KPIEntity.Entity rootEntity = (KPIEntity.Entity) kpiEntity.getIndex().get(areaValue);

				Map childrenMap = null;// 有序的map
				// 遍历出来后
				if (deep == -1) {
					childrenMap = new LinkedHashMap();
				} else {
					childrenMap = rootEntity.getChildren(deep);// 遍历出来后都是先县市
				}
				childrenMap.put(rootEntity.getKey(), rootEntity);// 加上全省到最后一个

				int seq = 0;// 列的数量，加载指标
				for (Iterator iterator = childrenMap.entrySet().iterator(); iterator.hasNext();) {

					Map.Entry obj = (Map.Entry) iterator.next();
					KPIEntity.Entity entity = (KPIEntity.Entity) obj.getValue();

					Map tempMap = null;
					if (data.size() == seq) {// 第一个指标初始化data
						tempMap = new LinkedHashMap();
						switch (column) {
						case 0:
							tempMap.put(root.name, entity.getName());
							break;
						case 1:
							if (deep != -1 && seq + 1 == childrenMap.size()) {
								tempMap.put(root.name, "合计");
								tempMap.put(root.child.name, "合计");
							} else {
								tempMap.put(root.name, entity.getParent().getName());
								tempMap.put(root.child.name, entity.getName());
							}
							break;
						case 2:
							if (deep != -1 && seq + 1 == childrenMap.size()) {
								tempMap.put(root.name, "合计");
								tempMap.put(root.child.name, "合计");
								tempMap.put(root.child.child.name, "合计");
							} else {
								tempMap.put(root.name, entity.getParent().getParent().getName());
								tempMap.put(root.child.name, entity.getParent().getName());
								tempMap.put(root.child.child.name, entity.getName());
							}
							break;
						}
						data.add(tempMap);
					} else {// 从第二个指标开始走这里
						tempMap = (Map) data.get(seq);
					}
					seq++;
					tempMap.put(kpiEntity.getId(), entity.getCurrentValue());
					if (isPre)
						tempMap.put("pre" + kpiEntity.getId(), entity.getHuanBi());
					if (isBefore)
						tempMap.put("before" + kpiEntity.getId(), entity.getTongBi());
					if (isYear)
						tempMap.put("year" + kpiEntity.getId(), entity.getYearTongBi());
					if (isProgress && kpiEntity.getRoot().getTargetValue() != 0)
						tempMap.put("progress" + kpiEntity.getId(), entity.getProgressNum());
				}
			}

			Map result = new HashMap();// 20091227重新修改数据结构，把合计独立出来
			Map amountElement = (Map) data.get(data.size() - 1);// 记录最后一个，为合计值
			data.remove(data.size() - 1);
			result.put("data", data);
			result.put("dataAmount", amountElement);
			return JsonHelper.getInstance().write(result);
		} else {// 时间段
				// 使用SQL来处理，时间段分为两种1.时间分组，2.时间聚合

			if ("true".equalsIgnoreCase(timeDetail)) {// 1.时间段的实现

				Map map = KPIPortalService.getKPIMap(appName, null);

				Map timeMap = new LinkedHashMap();
				List times = times();
				for (int i = 0; i < zbCodes.size(); i++) {
					Indicator indicator = (Indicator) zbCodes.get(i);
					if (indicator.key.length() > 0) {
						KPIEntity kpiEntity = (KPIEntity) map.get(indicator.key);
						if (kpiEntity != null) {
							for (int j = 0; j < times.size(); j++) {
								String tempTime = (String) times.get(j);
								Map kpisMap = null;
								if (!timeMap.containsKey(time)) {
									kpisMap = new HashMap();
									timeMap.put(tempTime, kpisMap);
								}
								kpisMap = (Map) timeMap.get(tempTime);
								KPIEntity newKpiEntity = KPIEntityInitialize.loadKPIEntity(tempTime, appName, indicator.key);
								kpisMap.put(newKpiEntity.getId(), newKpiEntity);
							}

						}

					}
				}
				List data = new ArrayList();

				for (Iterator iterator = timeMap.entrySet().iterator(); iterator.hasNext();) {
					Map.Entry entry = (Map.Entry) iterator.next();

					Map tempMap = new HashMap();

					tempMap.put("time", entry.getKey());

					Map kpisMap = (Map) entry.getValue();

					for (Iterator iterator2 = kpisMap.entrySet().iterator(); iterator2.hasNext();) {
						Map.Entry entry2 = (Map.Entry) iterator2.next();
						KPIEntity kpiEntity = (KPIEntity) entry2.getValue();
						KPIEntity.Entity entity = (KPIEntity.Entity) kpiEntity.getIndex().get(areaValue);
						tempMap.put(kpiEntity.getId(), entity.getCurrentValue());
						if (isPre)
							tempMap.put("pre" + kpiEntity.getId(), entity.getHuanBi());
						if (isBefore)
							tempMap.put("before" + kpiEntity.getId(), entity.getTongBi());
						if (isYear)
							tempMap.put("year" + kpiEntity.getId(), entity.getYearTongBi());
						if (isProgress && kpiEntity.getRoot().getTargetValue() != 0)
							tempMap.put("progress" + kpiEntity.getId(), entity.getProgressNum());
					}
					data.add(tempMap);
				}

				Map result = new HashMap();
				result.put("data", data);
				return JsonHelper.getInstance().write(result);
			} else {// 2.时间聚合
					// 聚合不支持日累计型指标与特殊计算指标，当是这些指标的时候直接返回空数据

				Map map = KPIPortalService.getKPIMap(appName, null);

				String newDate = timeFrom + "-" + time;

				List list = new ArrayList();
				for (int i = 0; i < zbCodes.size(); i++) {
					Indicator indicator = (Indicator) zbCodes.get(i);
					if (indicator.key.length() > 0) {
						KPIEntity kpiEntity = (KPIEntity) map.get(indicator.key);
						boolean canAggre = canAggre(kpiEntity);
						if (kpiEntity != null) {
							if (canAggre) {// 可以聚合指标，加载数据
								KPIEntity newKpiEntity = KPIEntityInitialize.loadKPIEntity(newDate, appName, indicator.key);
								list.add(newKpiEntity);
							} else {// 是日累计指标，把现在kpiEntity放进去主要是为了计算isAcc
								list.add(kpiEntity);
							}
						}
					}
				}

				List data = new ArrayList();

				for (int i = 0; i < list.size(); i++) {

					KPIEntity kpiEntity = (KPIEntity) list.get(i);

					KPIEntity.Entity rootEntity = (KPIEntity.Entity) kpiEntity.getIndex().get(areaValue);

					boolean canAggre = canAggre(kpiEntity);// 可以聚合指标

					Map childrenMap = null;// 有序的map
					// 遍历出来后
					if (deep == -1) {
						childrenMap = new LinkedHashMap();
					} else {
						childrenMap = rootEntity.getChildren(deep);// 遍历出来后都是先县市
					}
					childrenMap.put(rootEntity.getKey(), rootEntity);// 加上全省到最后一个

					int seq = 0;// 列的数量，加载指标
					for (Iterator iterator = childrenMap.entrySet().iterator(); iterator.hasNext();) {

						Map.Entry obj = (Map.Entry) iterator.next();
						KPIEntity.Entity entity = (KPIEntity.Entity) obj.getValue();

						Map tempMap = null;
						if (data.size() == seq) {// 第一个指标初始化data
							tempMap = new LinkedHashMap();
							switch (column) {
							case 0:
								tempMap.put(root.name, entity.getName());
								break;
							case 1:
								if (deep != -1 && seq + 1 == childrenMap.size()) {
									tempMap.put(root.name, "合计");
									tempMap.put(root.child.name, "合计");
								} else {
									tempMap.put(root.name, entity.getParent().getName());
									tempMap.put(root.child.name, entity.getName());
								}
								break;
							case 2:
								if (deep != -1 && seq + 1 == childrenMap.size()) {
									tempMap.put(root.name, "合计");
									tempMap.put(root.child.name, "合计");
									tempMap.put(root.child.child.name, "合计");
								} else {
									tempMap.put(root.name, entity.getParent().getParent().getName());
									tempMap.put(root.child.name, entity.getParent().getName());
									tempMap.put(root.child.child.name, entity.getName());
								}
								break;
							}
							data.add(tempMap);
						} else {// 从第二个指标开始走这里
							tempMap = (Map) data.get(seq);
						}
						seq++;
						/*
						 * tempMap.put(kpiEntity.getId(),
						 * entity.getCurrentValue());
						 * if(isPre)tempMap.put("pre"+kpiEntity.getId(),
						 * entity.getHuanBi());
						 * if(isBefore)tempMap.put("before"+kpiEntity.getId(),
						 * entity.getTongBi());
						 * if(isYear)tempMap.put("year"+kpiEntity.getId(),
						 * entity.getYearTongBi());
						 * if(isProgress&&kpiEntity.getRoot
						 * ().getTargetValue()!=0
						 * )tempMap.put("progress"+kpiEntity.getId(),
						 * entity.getProgressNum());
						 */
						tempMap.put(kpiEntity.getId(), canAggre ? entity.getCurrentValue() : "--");
					}
				}

				Map result = new HashMap();// 20091227重新修改数据结构，把合计独立出来
				Map amountElement = (Map) data.get(data.size() - 1);// 记录最后一个，为合计值
				data.remove(data.size() - 1);
				result.put("data", data);
				result.put("dataAmount", amountElement);
				return JsonHelper.getInstance().write(result);
			}
		}
	}

	/**
	 * 是否是不能聚合的指标
	 * 
	 * 不是特殊计算指标和不是日累计指标
	 * 
	 * ?* 当为PercentLoad的时候，依赖的指标为特殊指标没有判断 比如净增市场占有率
	 * 
	 * @param kpiEntity
	 * @return
	 */
	protected boolean canAggre(KPIEntity kpiEntity) {
		return kpiEntity.getKpiMetaData().getLoadClassName().matches("(com.asiainfo.hbbass.kpiportal.load.DefaultLoad|com.asiainfo.hbbass.kpiportal.load.PercentLoad)")
				&& !("daily".equalsIgnoreCase(kpiEntity.getKpiAppData().getAppType()) && (kpiEntity.getName().indexOf("累计") > 0 || kpiEntity.getKpiMetaData().getInstruction().indexOf("累计") > 0));
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected List times() {
		List list = new ArrayList();

		if (timeFrom != null && timeFrom.length() > 0 && Integer.valueOf(timeFrom) <= Integer.valueOf(time)) {
			Calendar cal = GregorianCalendar.getInstance();
			String dmf = null;
			int field = 0;
			if (time.length() == 6) {
				dmf = "yyyyMM";
				field = Calendar.MONTH;
				cal = new GregorianCalendar(Integer.parseInt(timeFrom.substring(0, 4)), Integer.parseInt(timeFrom.substring(4, 6)) - 1, 1);
			} else if (time.length() == 8) {
				dmf = "yyyyMMdd";
				field = Calendar.DATE;
				cal = new GregorianCalendar(Integer.parseInt(timeFrom.substring(0, 4)), Integer.parseInt(timeFrom.substring(4, 6)) - 1, Integer.parseInt(timeFrom.substring(6, 8)));
			}
			SimpleDateFormat sdf = new SimpleDateFormat(dmf);

			String tempTime = timeFrom;

			do {
				list.add(tempTime);
				cal.add(field, 1);
				tempTime = sdf.format(cal.getTime());
			} while (!tempTime.equalsIgnoreCase(time));
		}
		list.add(time);

		return list;
	}

	/*
	 * public String down(){
	 * 
	 * processState();
	 * 
	 * Map map = KPIPortalService.getKPIMap(appName, date);
	 * 
	 * List list = new ArrayList();
	 * 
	 * for (int i = 0; i < zbCodes.size(); i++) { Indicator indicator =
	 * (Indicator)zbCodes.get(i); if(indicator.key.length()>0){ Object
	 * obj1=map.get(indicator.key); if(obj1!=null) list.add(obj1); } }
	 * 
	 * List result = new ArrayList();
	 * 
	 * Set titleSet = new LinkedHashSet();
	 * 
	 * for (int i = 0; i < list.size(); i++) {
	 * 
	 * KPIEntity kpiEntity = (KPIEntity) list.get(i);
	 * 
	 * KPIEntity.Entity rootEntity =
	 * (KPIEntity.Entity)kpiEntity.getIndex().get(areaValue);
	 * 
	 * Map childrenMap = null;
	 * 
	 * if(deep==-1){ childrenMap = new HashMap();
	 * 
	 * childrenMap.put(rootEntity.getKey(), rootEntity); }else { childrenMap =
	 * rootEntity.getChildren(deep); }
	 * 
	 * int seq = 0; for (Iterator iterator = childrenMap.entrySet().iterator();
	 * iterator.hasNext();) {
	 * 
	 * Map.Entry obj = (Map.Entry) iterator.next(); KPIEntity.Entity entity =
	 * (KPIEntity.Entity) obj.getValue();
	 * 
	 * StringBuffer tempMap = null; if(result.size()==seq){ tempMap = new
	 * StringBuffer(); switch (column) { case 0: tempMap.append(
	 * entity.getName()).append(",");
	 * if(!titleSet.contains(root.name))titleSet.add(root.name); break; case 1:
	 * tempMap.append(entity.getParent().getName()).append(",");
	 * tempMap.append(entity.getName()).append(",");
	 * 
	 * if(!titleSet.contains(root.name))titleSet.add(root.name);
	 * if(!titleSet.contains(root.child.name))titleSet.add(root.child.name);
	 * 
	 * break; case 2:
	 * tempMap.append(entity.getParent().getParent().getName()).append(",");
	 * tempMap.append( entity.getParent().getName()).append(",");
	 * tempMap.append( entity.getName()).append(",");
	 * 
	 * if(!titleSet.contains(root.name))titleSet.add(root.name);
	 * if(!titleSet.contains(root.child.name))titleSet.add(root.child.name);
	 * if(!
	 * titleSet.contains(root.child.child.name))titleSet.add(root.child.child
	 * .name); break; }
	 * 
	 * result.add(tempMap); }else { tempMap = (StringBuffer)result.get(seq); }
	 * seq++; tempMap.append(entity.getCurrentValue()).append(",");
	 * if(!titleSet.
	 * contains(kpiEntity.getKpiMetaData().getId()))titleSet.add(kpiEntity
	 * .getKpiMetaData().getId()); if(isPre){ tempMap.append(
	 * entity.getHuanBi()).append(",");
	 * if(!titleSet.contains("pre"+kpiEntity.getKpiMetaData
	 * ().getId()))titleSet.add("pre"+kpiEntity.getKpiMetaData().getId()); }
	 * if(isBefore){ tempMap.append(entity.getTongBi()).append(",");
	 * if(!titleSet
	 * .contains("before"+kpiEntity.getKpiMetaData().getId()))titleSet
	 * .add("before"+kpiEntity.getKpiMetaData().getId()); } if(isYear){
	 * tempMap.append(entity.getYearTongBi()).append(",");
	 * if(!titleSet.contains(
	 * "year"+kpiEntity.getKpiMetaData().getId()))titleSet.
	 * add("year"+kpiEntity.getKpiMetaData().getId()); }
	 * if(isProgress&&entity.getTargetValue()!=0){
	 * tempMap.append(entity.getProgressNum()).append(",");
	 * if(!titleSet.contains
	 * ("progress"+kpiEntity.getKpiMetaData().getId()))titleSet
	 * .add("progress"+kpiEntity.getKpiMetaData().getId()); } } }
	 * 
	 * StringBuffer sbResult = new StringBuffer();
	 * 
	 * Map titleMap = new HashMap();
	 * 
	 * 
	 * for (int i = 0; i < zbCodes.size(); i++) { Indicator indicator =
	 * (Indicator)zbCodes.get(i); titleMap.put(indicator.dataIndex,
	 * indicator.name); }
	 * 
	 * 
	 * for (Iterator iterator2 = titleSet.iterator(); iterator2.hasNext();) {
	 * String setKey = (String) iterator2.next();
	 * sbResult.append(titleMap.get(setKey)).append(","); }
	 * 
	 * sbResult.delete(sbResult.length()-1,sbResult.length());
	 * 
	 * for (int i = 0; i < result.size(); i++) { StringBuffer tempSb =
	 * (StringBuffer)result.get(i); if(tempSb.length()>0){
	 * sbResult.append("\r\n").append(tempSb.substring(0, tempSb.length()-1)); }
	 * }
	 * 
	 * return sbResult.toString(); }
	 */

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List down() {

		processState();

		Map map = KPIPortalService.getKPIMap(appName, time);

		List showZb = new ArrayList();

		for (int i = 0; i < zbCodes.size(); i++) {
			Indicator indicator = (Indicator) zbCodes.get(i);
			if (indicator.key.length() > 0) {
				Object obj1 = map.get(indicator.key);
				if (obj1 != null)
					showZb.add(obj1);
			}
		}

		List data = new ArrayList();

		Set titleSet = new LinkedHashSet();

		for (int i = 0; i < showZb.size(); i++) {

			KPIEntity kpiEntity = (KPIEntity) showZb.get(i);

			KPIEntity.Entity rootEntity = (KPIEntity.Entity) kpiEntity.getIndex().get(areaValue);

			Map childrenMap = null;

			if (deep == -1) {
				childrenMap = new HashMap();

				childrenMap.put(rootEntity.getKey(), rootEntity);
			} else {
				childrenMap = rootEntity.getChildren(deep);
			}

			int seq = 0;
			for (Iterator iterator = childrenMap.entrySet().iterator(); iterator.hasNext();) {

				Map.Entry obj = (Map.Entry) iterator.next();
				KPIEntity.Entity entity = (KPIEntity.Entity) obj.getValue();

				List<String> tempMap = null;
				if (data.size() == seq) {
					tempMap = new ArrayList();
					switch (column) {
					case 0:
						tempMap.add(entity.getName());
						if (!titleSet.contains(root.name))
							titleSet.add(root.name);
						break;
					case 1:
						tempMap.add(entity.getParent().getName());
						tempMap.add(entity.getName());

						if (!titleSet.contains(root.name))
							titleSet.add(root.name);
						if (!titleSet.contains(root.child.name))
							titleSet.add(root.child.name);

						break;
					case 2:
						tempMap.add(entity.getParent().getParent().getName());
						tempMap.add(entity.getParent().getName());
						tempMap.add(entity.getName());

						if (!titleSet.contains(root.name))
							titleSet.add(root.name);
						if (!titleSet.contains(root.child.name))
							titleSet.add(root.child.name);
						if (!titleSet.contains(root.child.child.name))
							titleSet.add(root.child.child.name);
						break;
					}

					data.add(tempMap);
				} else {
					tempMap = (List) data.get(seq);
				}
				seq++;
				tempMap.add(String.valueOf(entity.getCurrentValue()));
				if (!titleSet.contains(kpiEntity.getKpiMetaData().getId()))
					titleSet.add(kpiEntity.getKpiMetaData().getId());
				if (isPre) {
					tempMap.add(String.valueOf(entity.getHuanBi()));
					if (!titleSet.contains("pre" + kpiEntity.getKpiMetaData().getId()))
						titleSet.add("pre" + kpiEntity.getKpiMetaData().getId());
				}
				if (isBefore) {
					tempMap.add(String.valueOf(entity.getTongBi()));
					if (!titleSet.contains("before" + kpiEntity.getKpiMetaData().getId()))
						titleSet.add("before" + kpiEntity.getKpiMetaData().getId());
				}
				if (isYear) {
					tempMap.add(String.valueOf(entity.getYearTongBi()));
					if (!titleSet.contains("year" + kpiEntity.getKpiMetaData().getId()))
						titleSet.add("year" + kpiEntity.getKpiMetaData().getId());
				}
				if (isProgress && entity.getTargetValue() != 0) {
					tempMap.add(String.valueOf(entity.getProgressNum()));
					if (!titleSet.contains("progress" + kpiEntity.getKpiMetaData().getId()))
						titleSet.add("progress" + kpiEntity.getKpiMetaData().getId());
				}
			}
		}

		List result = new ArrayList();

		// 处理表头部分
		/*
		 * Map titleMap = new HashMap();
		 * 
		 * for (int i = 0; i < zbCodes.size(); i++) { Indicator indicator =
		 * (Indicator)zbCodes.get(i); titleMap.put(indicator.dataIndex,
		 * indicator.name); }
		 * 
		 * String[] titleArr = new String[titleSet.size()]; int j=0; for
		 * (Iterator iterator2 = titleSet.iterator(); iterator2.hasNext();) {
		 * String setKey = (String) iterator2.next();
		 * titleArr[j]=titleMap.get(setKey).toString(); j++; }
		 * result.add(titleArr);
		 */

		Map header = new HashMap();
		int headRows = 1;
		for (int i = 0; i < zbCodes.size(); i++) {
			Indicator indicator = (Indicator) zbCodes.get(i);
			header.put(indicator.dataIndex, indicator.name);
			headRows = indicator.name.size();
		}

		int size = titleSet.size();
		String[] line = null;
		for (int j = 0; j < headRows; j++) {
			line = new String[size];
			int k = 0;
			for (Iterator iterator2 = titleSet.iterator(); iterator2.hasNext();) {
				// for (int i = 0; i < size; i++) {

				String columnName = (String) iterator2.next();

				if (headRows == 1) {
					String value = "";
					Object obj = header.get(columnName);

					if (obj instanceof List) {
						value = (String) ((List) obj).get(0);
					} else if (obj instanceof String) {
						value = (String) obj;
					} else {
						value = columnName;
					}

					value = (value == null ? "" : value);
					line[k] = value;

				} else {
					List list = (List) header.get(columnName);
					if (list == null) {
						continue;
					}

					line[k] = (String) list.get(j);

				}
				k++;
			}
			result.add(line);
		}

		// 处理数据部分
		for (int i = 0; i < data.size(); i++) {
			List tempList = (List) data.get(i);
			result.add(tempList.toArray(new String[tempList.size()]));
		}

		return result;
	}

	protected void processState() {
		areaValue = root.value;
		deep = 0;
		column = 0;

		if (root.child.value.length() > 0) {
			areaValue = root.child.value;
		}

		if (root.child.child != null && root.child.child.value.length() > 0) {
			areaValue = root.child.child.value;
		}

		if ("HB".equalsIgnoreCase(areaValue)) {
			if (root.child.child != null && root.child.child.detail.length() > 0) {
				deep = 2;
			} else if (root.child.detail.length() > 0) {
				deep = 1;
			}
		} else {
			if (root.child.child != null && root.child.child.detail.length() > 0) {
				deep = 1;
			}

			if ((root.child.child != null && root.child.child.value.length() > 0) || (root.child.child == null && root.child.value.length() > 0)) {
				deep = -1;
			}
		}

		if (root.child.child == null) {
			if (!"HB".equalsIgnoreCase(areaValue) || root.child.detail.length() > 0) {
				column = 1;
			}
		} else if (root.child.child != null) {
			if (root.child.value.length() > 0) {
				column = 2;
			} else if (!"HB".equalsIgnoreCase(areaValue)) {
				if (root.child.child.detail.length() > 0) {
					column = 2;
				} else {
					column = 1;
				}
			} else {
				if (root.child.child.detail.length() > 0) {
					column = 2;
				} else if (root.child.detail.length() > 0) {
					column = 1;
				}
			}
		}

	}

	public String getDimensionData() {
		if (dimensionData.length() == 0) {
			StringBuffer sb = new StringBuffer();

			sb.append("<table align='center' width='99%' class='grid-tab-blue' cellspacing='1' cellpadding='0' border='0'>");
			sb.append("<tr class='dim_row'>");

			sb.append("<td class='dim_cell_title'><span onclick='swichDate()' title='点击切换时间类型' style='cursor:hand;'>统计周期</span> <span style='display:none;'><input id='timeDetail' type='checkbox' checked='checked'>细分 </span></td>");

			/*
			 * if(appName.endsWith("M")){
			 * sb.append("<td class='dim_cell_content'><ai:dim name='date'>"
			 * +BassDimHelper.monthHtml("date")+"</ai:dim></td>"); } else {
			 * sb.append(
			 * "<td class='dim_cell_content'><ai:dim name='date'><input type=\"text\" style=\"width:160px;\" class=\"Wdate\" id=\"date\" name=\"date\" onfocus=\"WdatePicker()\"/></ai:dim></td>"
			 * ); }
			 */

			sb.append("<td class='dim_cell_content'><ai:dim name='time'>");
			String df = "yyyyMMdd";
			if (appName.endsWith("M")) {
				df = "yyyyMM";
			}
			sb.append(BassDimHelper.time("time", df, time));
			sb.append("</ai:dim></td>");

			sb.append("<td class='dim_cell_title'>地市</td>");
			sb.append("<td class='dim_cell_content'><ai:dim name='city'>" + BassDimHelper.areaCodeHtml("city", cityId, "areacombo('1')") + "</ai:dim></td>");

			if (appName.startsWith("Bureau")) {
				sb.append("<td class='dim_cell_title'>县市<ai:dim name='detailCounty'><input type=checkbox name=detailCounty value=1>细分</ai:dim></td>");
				sb.append("<td class='dim_cell_content'><ai:dim name='county_bureau'>" + BassDimHelper.comboSeleclHtml("county_bureau", "areacombo('2')") + "</ai:dim></td>");
				sb.append("</tr><tr class='dim_row'>");
				sb.append("<td class='dim_cell_title'>营销中心<ai:dim name='detailMarketing'><input type=checkbox name=detailMarketing value=1>细分</ai:dim></td>");
				sb.append("<td class='dim_cell_content'><ai:dim name='marketing_center'>" + BassDimHelper.comboSeleclHtml("marketing_center") + "</ai:dim></td>");
				sb.append("<td class='dim_cell_title'></td><td class='dim_cell_content'></td><td class='dim_cell_title'></td><td class='dim_cell_content'></td>");
			} else if (appName.startsWith("E")) {
				sb.append("<td class='dim_cell_title'>主网格<ai:dim name='detail_main'><input type=checkbox name=detail_main value=1>细分</ai:dim></td>");
				sb.append("<td class='dim_cell_content'><ai:dim name='ent_grid_main'>" + BassDimHelper.comboSeleclHtml("ent_grid_main", "areacombo('2')") + "</ai:dim></td>");
				sb.append("</tr><tr class='dim_row'>");
				sb.append("<td class='dim_cell_title'>子网格<ai:dim name='detail_sub'><input type=checkbox name=detail_sub value=1>细分</ai:dim></td>");
				sb.append("<td class='dim_cell_content'><ai:dim name='ent_grid_sub'>" + BassDimHelper.comboSeleclHtml("ent_grid_sub", "areacombo('3')") + "</ai:dim></td>");
				sb.append("<td class='dim_cell_title'></td><td class='dim_cell_content'></td><td class='dim_cell_title'></td><td class='dim_cell_content'></td>");
			} else if (appName.startsWith("College")) {
				sb.append("<td class='dim_cell_title'>高校<ai:dim name='detailCollege'><input type=checkbox name=detailCollege value=1>细分</ai:dim></td>");
				sb.append("<td class='dim_cell_content'><ai:dim name='college'>" + BassDimHelper.comboSeleclHtml("college") + "</ai:dim></td>");
			} else if (appName.startsWith("Groupcust")) {
				sb.append("<td class='dim_cell_title'>县市<ai:dim name='detailCounty'><input type=checkbox name=detailCounty value=1>细分</ai:dim></td>");
				sb.append("<td class='dim_cell_content'><ai:dim name='entCounty'>" + BassDimHelper.comboSeleclHtml("entCounty", "areacombo('2')") + "</ai:dim></td>");
				sb.append("</tr><tr class='dim_row'>");
				sb.append("<td class='dim_cell_title'>客户经理<ai:dim name='detailCustmgr'><input type=checkbox name=detailCustmgr value=1>细分</ai:dim></td>");
				sb.append("<td class='dim_cell_content'><ai:dim name='custmgr'>" + BassDimHelper.comboSeleclHtml("custmgr") + "</ai:dim></td>");
				sb.append("<td class='dim_cell_title'></td><td class='dim_cell_content'></td><td class='dim_cell_title'></td><td class='dim_cell_content'></td>");
			} else {
				sb.append("<td class='dim_cell_title'>县市<ai:dim name='detailCounty'><input type=checkbox name=detailCounty value=1>细分</ai:dim></td>");
				sb.append("<td class='dim_cell_content'><ai:dim name='county'>" + BassDimHelper.comboSeleclHtml("county") + "</ai:dim></td>");
			}
			sb.append("</tr></table>");
			dimensionData = sb.toString();
		}

		return dimensionData;
	}

	public String render() {

		StringBuffer sb = null;

		try {
			sb = new StringBuffer();
			BufferedReader br = new BufferedReader(new InputStreamReader(Thread.currentThread().getContextClassLoader().getResourceAsStream("com/asiainfo/hbbass/kpiportal/report/default.htm")));
			// .getResourceAsStream("default.htm")));
			String line = "";
			while ((line = br.readLine()) != null) {
				sb.append(line).append("\r\n");
			}
			br.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		String str = getDimensionData();
		String sReturn = "";
		if (str.indexOf('$', 0) > -1) {
			while (str.length() > 0) {
				if (str.indexOf('$', 0) > -1) {
					sReturn += str.subSequence(0, str.indexOf('$', 0));
					sReturn += "\\$";
					str = str.substring(str.indexOf('$', 0) + 1, str.length());
				} else {
					sReturn += str;
					str = "";
				}
			}
		} else {
			sReturn = str;
		}
		return sb.toString().replaceAll("@dimension", sReturn).replaceAll("@title", name).replaceAll("@header", getHeaderData()).replaceAll("@urlDown", "\"/hbirs/action/dynamicrpt?method=down&sid=" + key + "\"").replaceAll("@url", "\"/hbirs/action/dynamicrpt?method=query&sid=" + key + "\"");
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static void main(String[] args) {
		Map map = new LinkedHashMap();
		map.put("e2", "124");
		map.put("e1", "124");

		List list = new ArrayList();

		list.add(new KPIAppData("1", "2"));
		list.add(new KPIAppData("3", "4"));
		list.add(map);
		// JSONWriter json = new JSONWriter(false);

		/*
		 * json.put("totalCount", "123"); json.put("traces",map );
		 * 
		 * json.put("datas",list );
		 */

		java.util.UUID uuid = java.util.UUID.randomUUID();
		System.out.println(uuid.toString().replaceAll("-", ""));

		System.out.println(JsonHelper.getInstance().write(list));

		StringBuffer sb = new StringBuffer();

		sb.append("1afdaf").append(",");

		System.out.println(sb.substring(1, sb.length() - 1));

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

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
	}

	public String getTimeFrom() {
		return timeFrom;
	}

	public void setTimeFrom(String timeFrom) {
		this.timeFrom = timeFrom;
	}

	public String getTimeDetail() {
		return timeDetail;
	}

	public void setTimeDetail(String timeDetail) {
		this.timeDetail = timeDetail;
	}

	public String getAppName() {
		return appName;
	}

	public void setAppName(String appName) {
		this.appName = appName;
	}

	@SuppressWarnings("rawtypes")
	public List getZbCodes() {
		return zbCodes;
	}

	@SuppressWarnings("rawtypes")
	public void setZbCodes(List zbCodes) {
		this.zbCodes = zbCodes;
	}

	public Area getRoot() {
		return root;
	}

	public void setRoot(Area root) {
		this.root = root;
	}

	public void setDimensionData(String dimensionData) {
		this.dimensionData = dimensionData;
	}

	public boolean isPre() {
		return isPre;
	}

	public void setPre(boolean isPre) {
		this.isPre = isPre;
	}

	public boolean isBefore() {
		return isBefore;
	}

	public void setBefore(boolean isBefore) {
		this.isBefore = isBefore;
	}

	public boolean isYear() {
		return isYear;
	}

	public void setYear(boolean isYear) {
		this.isYear = isYear;
	}

	public boolean isProgress() {
		return isProgress;
	}

	public void setProgress(boolean isProgress) {
		this.isProgress = isProgress;
	}

	public String getCityId() {
		return cityId;
	}

	public void setCityId(String cityId) {
		this.cityId = cityId;
	}

}
