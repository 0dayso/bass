package com.asiainfo.bass.apps.kpi;

import java.io.Serializable;

import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;

/**
 * 这个类是KPI对象的实体类 这个类是一个树形结构
 * 
 * @author Mei Kefu
 * 
 *         2009-12-29日修改，增加Entity到KPIEntity的应用（能从子找到父）
 */
public class Kpi implements Serializable {
	// private static Logger LOG = Logger.getLogger(KPIEntity.class);

	private static final long serialVersionUID = 3045913201107173461L;

	/*************** KPI计算指标专有元信息 ********************/
	private KpiDef def = new KpiDef();

	/*************** 加载器 ********************/
	@SuppressWarnings("unused")
	private KpiLoader loader = null;

	/*************** 该KPIEntity的时间 ********************/
	private String date;

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getId() {
		return def.getId();
	}

	public String getName() {
		return def.getName();// +kpiMetaData.getUnit();
	}

	public String getKind() {
		// return kpiMetaData.getKind();
		return null;
	}

	/***************
	 * Entity
	 ********************/

	/*************** KPI的根节点 ********************/
	private Entity root;

	/*************** KPI的每个节点的索引；索引的Key是渠道编码，Value是Entity对象 ********************/
	@SuppressWarnings("rawtypes")
	private Map index = new HashMap()/*
									 * { public Object get(Object key){ Entity
									 * obj = (Entity)super.get(key);
									 * 
									 * if(obj!=null&&obj.getChildren()==null){
									 * kpiEntityLoad.loadNoCached((String)key);
									 * } return obj; } }
									 */;

	public Entity getRoot() {
		return root;
	}

	public void setRoot(Entity root) {
		this.root = root;
	}

	@SuppressWarnings("rawtypes")
	public void setIndex(Map index) {
		this.index = index;
	}

	@SuppressWarnings("rawtypes")
	public Map getIndex() {
		return index;
	}

	/**
	 * 本指标的每个渠道的数值
	 * 
	 * 估算Entity空间占用 5个引用类型20byte 2个字符串估算个20byte 5个double类型为 20byte chilren
	 * map中以10个为例 就是40byte 一个Entity大概为0.1k
	 * 
	 * @author Mei Kefu
	 * 
	 */
	@SuppressWarnings("rawtypes")
	public static class Entity implements Comparable, Serializable {
		private static final long serialVersionUID = 3942363470205340470L;

		/** ****** 父KPIEntity ********* */
		// 不能都缓存这个值，因为使用PercentLoad的时候是会变更parentKPIEntity的应用，需要每个都变更，使用缓存rootEntity就行了
		// 只有root节点才缓存这个值，其他的都通过root来访问KPIEntity
		private Kpi parentKpi;

		/** ****** 父 ********* */
		private Entity parent;

		/** ****** 子 ********* */
		private Map<String, Entity> children;

		/** ****** KPI值对象 ********* */
		private String
		/** ****** 地域编码 ********* */
		regionId,
		/** ****** 地域名称 ********* */
		regionName;

		private double
		/** ****** 目标值 ********* */
		target,
		/** ****** KPI值 ********* */
		current,
		/** ****** 环比值 ********* */
		yesterday,
		/** ****** 同比值 ********* */
		lastMonth,
		/** ****** 年同比值 ********* */
		lastYear;

		public Map getChildren() {
			return children;
		}

		public Kpi getParentKpi() {
			return parentKpi;
		}

		public void setParentKpi(Kpi parentKpi) {
			this.parentKpi = parentKpi;
		}

		public Entity getParent() {
			return parent;
		}

		public void setParent(Entity parent) {
			this.parent = parent;
		}

		public String getRegionId() {
			return regionId;
		}

		public void setRegionId(String regionId) {
			this.regionId = regionId;
		}

		public String getRegionName() {
			return regionName;
		}

		public void setRegionName(String regionName) {
			this.regionName = regionName;
		}

		public double getTarget() {
			return target;
		}

		public void setTarget(double target) {
			this.target = target;
		}

		public double getCurrent() {
			return current;
		}

		public void setCurrent(double current) {
			this.current = current;
		}

		public double getYesterday() {
			return yesterday;
		}

		public void setYesterday(double yesterday) {
			this.yesterday = yesterday;
		}

		public double getLastMonth() {
			return lastMonth;
		}

		public void setLastMonth(double lastMonth) {
			this.lastMonth = lastMonth;
		}

		public double getLastYear() {
			return lastYear;
		}

		public void setLastYear(double lastYear) {
			this.lastYear = lastYear;
		}

		/**
		 * 取深层的children，比如deep=1就是取children的children
		 * 
		 * @param deep
		 * @return
		 */
		public Map getChildren(int deep) {

			if (deep < 0) {
				return getChildren();
			} else {
				Map result = new LinkedHashMap();
				recursionChildren(result, children, deep);
				return result;
			}
		}

		/**
		 * 递归函数遍历子节点
		 */
		@SuppressWarnings("unchecked")
		protected void recursionChildren(Map result, Map map, int deep) {

			if (map != null && map.size() > 0) {
				for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext();) {
					Map.Entry obj = (Map.Entry) iterator.next();

					Entity entity = (Entity) obj.getValue();
					if (entity != null) {
						if (deep > 0 && entity.getChildren() != null && entity.getChildren().size() > 0) {
							recursionChildren(result, entity.getChildren(), deep - 1);
						} else {
							result.put(obj.getKey(), entity);
						}
					}
				}
			}

		}

		public int compareTo(Object o) {
			return 0;
		}
	}

	public String toString() {
		return "[" + getId() + ":" + getName() + ",index size: " + index.size() + "]";
	}
}
