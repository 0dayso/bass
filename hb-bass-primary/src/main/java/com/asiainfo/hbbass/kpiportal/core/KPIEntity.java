package com.asiainfo.hbbass.kpiportal.core;

import java.io.Serializable;
import java.text.MessageFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

import com.asiainfo.hbbass.component.util.Util;

/**
 * 这个类是KPI对象的实体类 这个类是一个树形结构
 * 
 * @author Mei Kefu
 * 
 *         2009-12-29日修改，增加Entity到KPIEntity的应用（能从子找到父）
 */
public class KPIEntity implements Serializable {
	// private static Logger LOG = Logger.getLogger(KPIEntity.class);

	private static final long serialVersionUID = 3045913201107173461L;

	/*************** KPI计算指标专有元信息 ********************/
	private KPIMetaData kpiMetaData = new KPIMetaData();

	/*************** KPI计算指标专有元信息 ********************/
	private KPIAppData kpiAppData = null;

	/*************** 加载器 ********************/
	private KPIEntityLoad kpiEntityLoad = null;

	/*************** KPIEntityValue的过滤器，来处理返回值2009-12-29 ********************/
	private KPIEntityValueFilter valueFilter = KPIEntityValueFilter.NULL;

	/*************** 该KPIEntity的时间 ********************/
	private String date;

	public KPIEntityLoad getKpiEntityLoad() {
		return kpiEntityLoad;
	}

	public void setKpiEntityLoad(KPIEntityLoad kpiEntityLoad) {
		this.kpiEntityLoad = kpiEntityLoad;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getId() {
		return kpiMetaData.getId();
	}

	public String getName() {
		return kpiMetaData.getName() + kpiMetaData.getUnit();
	}

	public String getKind() {
		return kpiMetaData.getKind();
	}

	public KPIMetaData getKpiMetaData() {
		return kpiMetaData;
	}

	public void setKpiMetaData(KPIMetaData kpiMetaData) {
		this.kpiMetaData = kpiMetaData;
	}

	public KPIAppData getKpiAppData() {
		return kpiAppData;
	}

	public void setKpiAppData(KPIAppData kpiAppData) {
		this.kpiAppData = kpiAppData;
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
	 * @author Mei Kefu
	 * 
	 */
	@SuppressWarnings("rawtypes")
	public static class Entity implements Comparable, Serializable {
		private static final long serialVersionUID = 3942363470205340470L;

		/** ****** 父KPIEntity ********* */
		// 不能都缓存这个值，因为使用PercentLoad的时候是会变更parentKPIEntity的应用，需要每个都变更，使用缓存rootEntity就行了
		// 只有root节点才缓存这个值，其他的都通过root来访问KPIEntity
		private KPIEntity parentKPIEntity;

		/** ****** KPI值对象 ********* */
		private KPIEntityValue value;

		/** ****** Cell的状态 ********* */
		// private KPIEntityValueState state = null;//这个字段不能有，会造成状态被缓存，影响以后的取值

		/** ****** 父 ********* */
		private Entity parent;

		/** ****** 子 ********* */
		private Map children;

		public KPIEntityValue getValue() {
			return value;
		}

		public void setValue(KPIEntityValue value) {
			this.value = value;
		}

		/*
		 * public KPIEntityValueState getState() { return state; }
		 * 
		 * public void setState(KPIEntityValueState state) { this.state = state;
		 * }
		 */

		public String getKey() {
			return getValue().getRegionId();
		}

		public String getName() {
			return getValue().getRegionName();
		}

		public double getCurrentValue() {
			return getValue().getCurrentValue(null).doubleValue();
		}

		public double getCurrentValue(KPIEntityValueState state) {
			return getValue().getCurrentValue(state).doubleValue();
		}

		/*
		 * public String getCurrent() { return
		 * KPIPortalContext.DECIMAL_FORMAT.format(getCurrentValue()); }
		 */

		public double getPreValue() {
			return getValue().getPreValue(null).doubleValue();
		}

		public double getPreValue(KPIEntityValueState state) {
			return getValue().getPreValue(state).doubleValue();
		}

		/*
		 * public String getPre() { return
		 * KPIPortalContext.DECIMAL_FORMAT.format(getPreValue()); }
		 */

		public double getBeforeValue() {
			return getValue().getBeforeValue(null).doubleValue();
		}

		public double getBeforeValue(KPIEntityValueState state) {
			return getValue().getBeforeValue(state).doubleValue();
		}

		/*
		 * public String getBefore() { return
		 * KPIPortalContext.DECIMAL_FORMAT.format(getBeforeValue()); }
		 */

		public double getYearValue() {
			return getValue().getYearValue(null).doubleValue();
		}

		public double getYearValue(KPIEntityValueState state) {
			return getValue().getYearValue(state).doubleValue();
		}

		/*
		 * public String getYear() { return
		 * KPIPortalContext.DECIMAL_FORMAT.format(getYearValue()); }
		 */

		public Double getTargetValue() {
			return value.getTargetValue();
		}

		public String getTarget() {
			if (getTargetValue().doubleValue() == 0)
				return "--";
			else
				return KPIPortalContext.DECIMAL_FORMAT.format(getTargetValue());
		}

		public void setParent(Entity parent) {
			this.parent = parent;
		}

		public void setChildren(Map children) {
			this.children = children;
		}

		public Entity getParent() {
			return parent;
		}

		public Map getChildren() {
			return children;
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
			double a = getCompareValue();

			Entity target = (Entity) o;

			double b = target.getCompareValue();

			if (a > b)
				return 1;
			else if (a < b)
				return -1;
			else
				return 0;
		}

		private String compareType;

		public void setCompareType(String compareType) {
			this.compareType = compareType;
		}

		/**
		 * 每次都排序不缓存排序结果 改造了这个方法,使用局部变量;
		 * 解决的问题是:多线程排序的时候我使用的orderChildren字段被不同的线程加载排序,造成错误 现在改成局部变量返回值的形式
		 * 
		 * @return
		 */
		public Entity[] getOrderChildren(String compareType) {
			if (children != null && children.size() > 0) {
				Entity[] entities = new Entity[children.size()];
				int i = 0;
				for (Iterator iterator = children.entrySet().iterator(); iterator.hasNext();) {
					Map.Entry type = (Map.Entry) iterator.next();
					entities[i] = (Entity) type.getValue();
					entities[i].setCompareType(compareType);
					i++;
				}
				Util.heapSort(entities);
				return entities;
			}
			return new Entity[0];
		}

		public double getCompareValue() {
			double compareValue;
			if ("pre".equalsIgnoreCase(compareType))
				compareValue = getPreValue();
			else if ("before".equalsIgnoreCase(compareType))
				compareValue = getBeforeValue();
			else if ("year".equalsIgnoreCase(compareType))
				compareValue = getYearValue();
			else if ("huanbi".equalsIgnoreCase(compareType))
				compareValue = getHuanBi();
			else if ("tongbi".equalsIgnoreCase(compareType))
				compareValue = getTongBi();
			else if ("yeartongbi".equalsIgnoreCase(compareType))
				compareValue = getYearTongBi();
			else if ("progress".equalsIgnoreCase(compareType))
				compareValue = getProgressNum();
			else
				compareValue = getCurrentValue();
			return compareValue;
		}

		// 2011-09-20针对高校选择品牌时同比环比不变的问题重载了3个方法，增加了KPIEntityValueState参数，测试通过
		public double getHuanBi(KPIEntityValueState state) {
			if (getPreValue() == 0)
				return 0D;
			// return getCurrentValue() / getPreValue() - 1.0D;
			return (getCurrentValue(state) - getPreValue(state)) / Math.abs(getPreValue(state));
		}

		public double getTongBi(KPIEntityValueState state) {
			if (getBeforeValue(state) == 0)
				return 0D;
			// return getCurrentValue() / getBeforeValue() - 1.0D;
			return (getCurrentValue(state) - getBeforeValue(state)) / Math.abs(getBeforeValue(state));
		}

		public double getYearTongBi(KPIEntityValueState state) {
			if (getYearValue(state) == 0)
				return 0D;
			// return getCurrentValue() / getYearValue() - 1.0D;
			return (getCurrentValue(state) - getYearValue(state)) / Math.abs(getYearValue(state));
		}

		public double getHuanBi() {
			if (getPreValue() == 0)
				return 0D;
			// return getCurrentValue() / getPreValue() - 1.0D;
			return (getCurrentValue() - getPreValue()) / Math.abs(getPreValue());
		}

		public double getTongBi() {
			if (getBeforeValue() == 0)
				return 0D;
			// return getCurrentValue() / getBeforeValue() - 1.0D;
			return (getCurrentValue() - getBeforeValue()) / Math.abs(getBeforeValue());
		}

		public double getYearTongBi() {
			if (getYearValue() == 0)
				return 0D;
			// return getCurrentValue() / getYearValue() - 1.0D;
			return (getCurrentValue() - getYearValue()) / Math.abs(getYearValue());
		}

		public String getProgress() {
			return (getTargetValue().doubleValue() != 0) ? String.valueOf(getCurrentValue() / getTargetValue().doubleValue()) : "--";
		}

		/**
		 * 进度差距
		 * 
		 * @return
		 */
		public String getProgressGap() {
			if (getTargetValue().doubleValue() != 0) {
				double target = 1d;
				String targetType = parentKPIEntity.getKpiMetaData().getTargetType();
				String date = parentKPIEntity.getDate();
				if ("increaseYear".equalsIgnoreCase(targetType)) {
					if (date.length() == 8) {
						Calendar c = new GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, Integer.parseInt(date.substring(6, 8)));
						c.get(Calendar.DAY_OF_YEAR);
						target = c.get(Calendar.DAY_OF_YEAR) / 365d;

					} else {
						target = Integer.parseInt(date.substring(4, 6)) / 12d;
					}
				} else if ("increase".equalsIgnoreCase(targetType)) {
					if (date.length() == 8) {
						Calendar c = new GregorianCalendar(Integer.parseInt(date.substring(0, 4)), Integer.parseInt(date.substring(4, 6)) - 1, 1);
						c.add(Calendar.MONTH, 1);
						c.add(Calendar.DATE, -1);
						target = Integer.parseInt(date.substring(6, 8)) * 1d / c.get(Calendar.DATE);
					} else {
						target = Integer.parseInt(date.substring(4, 6)) / 12d;
					}
				} else if ("percent".equalsIgnoreCase(targetType)) {
					target = parentKPIEntity.getKpiMetaData().getTargetValue() * 1d;
					return KPIPortalContext.DECIMAL_FORMAT.format(getCurrentValue() - getTargetValue());
				}
				return KPIPortalContext.DECIMAL_FORMAT.format(getProgressNum() - target);
			} else {
				return "--";
			}
		}

		public double getProgressNum() {
			return (getTargetValue().doubleValue() != 0) ? getCurrentValue() / getTargetValue().doubleValue() : 0d;
		}

		public String toString() {
			return "{" + getKey() + ":" + getName() + "[current:" + getCurrentValue() + "],[pre:" + getPreValue() + "],[before:" + getBeforeValue() + "]}";
		}

		public KPIEntity getParentKPIEntity() {
			return parentKPIEntity;
		}

		public void setParentKPIEntity(KPIEntity parentKPIEntity) {
			this.parentKPIEntity = parentKPIEntity;
		}

		/**
		 * 表达一个指标的内容 2010-6-13
		 * 
		 * @return
		 */
		@SuppressWarnings("unchecked")
		public String content() {
			Map constants = new HashMap();
			/*
			 * content=
			 * "全省累计出账收入为**万元，较去年同期增长**。增幅排名前三的地市是**（**%）、**（**%）和**（**%）；增幅排名后三的地市是**（**%）、**（**%）和**（**%）。"
			 * ;//月同比 content=
			 * "全省累计出账收入（不含SP）为**万元，较上月同期增长**。增幅排名前三的地市是**（**%）、**（**%）和**（**%）；增幅排名后三的地市是**（**%）、**（**%）和**（**%）。"
			 * ;//年同比 content=
			 * "全省MOU为**分钟。MOU排名前三的地市是**（**分钟）、**（**分钟）和**（**分钟）；增幅排名后三的地市是**（**分钟）、**（**分钟）和**（**分钟）。"
			 * ;//绝对值 content=
			 * "全省累计净增通话用户数**户。净增通话用户数前三的地市是**（**户）、**（**户）和**（**户）；增幅排名后三的地市是**（**户）、**（**户）和**（**户）。"
			 * ;//不排名
			 */
			constants.put("HB月同比", "{0}{1}为{2}，较{3}。增幅排名前三的地市是{7}、{8}和{9}；后三的地市是{10}、{11}和{12}。");
			constants.put("HB年同比", "{0}{1}为{2}，较{3}。增幅排名前三的地市是{7}、{8}和{9}；后三的地市是{10}、{11}和{12}。");
			constants.put("HB绝对值", "{0}{1}为{2}，{1}前三的地市是{7}、{8}和{9}；后三的地市是{10}、{11}和{12}。");
			constants.put("HB不排名", "{0}{1}为{2}，{1}前三的地市是{7}、{8}和{9}；后三的地市是{10}、{11}和{12}。");
			/*
			 * content="**累计出账收入为**万元，较去年同期增长**，增幅排名全省第*。同期全省增幅为**。";//月同比
			 * content="**累计出账收入（不含SP）为**万元，较上月同期增长**，增幅排名全省第*。同期全省增幅为**。";//年同比
			 * content="**MOU为**分钟，排名全省第*。同期全省MOU为**分钟。";//绝对值
			 * content="**累计净增通话用户数**户。同期全省净增通话用户数**户。";//不排名
			 */
			constants.put("月同比", "{0}{1}为{2}，较{3}，增幅排名全省第{4}。同期全省增幅为{5}。");
			constants.put("年同比", "{0}{1}为{2}，较{3}，增幅排名全省第{4}。同期全省增幅为{5}。");
			constants.put("绝对值", "{0}{1}为{2}，排名全省第{4}。同期全省{6}。");
			constants.put("不排名", "{0}{1}为{2}，同期全省{6}。");

			String expRules = getParentKPIEntity().getKpiMetaData().getExpRules();
			String content = (String) constants.get(("HB".equalsIgnoreCase(getKey()) ? "HB" : "") + expRules);
			// 全省/地市累计出账收入
			String _0 = getName().replaceAll("湖北", "全省");

			String _1 = getParentKPIEntity().getKpiMetaData().getName();

			// 值+单位
			String _2 = ("percent".equalsIgnoreCase(getParentKPIEntity().getKpiMetaData().getFormatType()) ? Util.percentFormat(getCurrentValue()) : KPIPortalContext.DIGIT2_DECIMAL_FORMAT.format(getCurrentValue())) + getParentKPIEntity().getKpiMetaData().getUnit();
			// 上月，去年 同期 增幅
			String _3 = "";
			if ("年同比".equalsIgnoreCase(expRules)) {
				_3 = "去年同期" + ((getYearTongBi() > 0 ? "增长" : "减少") + Util.percentFormat(Math.abs(getYearTongBi())));
			} else if ("月同比".equalsIgnoreCase(expRules)) {
				_3 = "上月同期" + ((getTongBi() > 0 ? "增长" : "减少") + Util.percentFormat(Math.abs(getTongBi())));
			}

			// 地市的排名
			String _4 = "0";

			// 年同比，月同比 增幅
			String _5 = "年同比".equalsIgnoreCase(expRules) ? Util.percentFormat(getParentKPIEntity().getRoot().getYearTongBi()) : Util.percentFormat(getParentKPIEntity().getRoot().getTongBi());

			// 地市的时候全省的值
			String _6 = getParentKPIEntity().getKpiMetaData().getName() + "为"
					+ ("percent".equalsIgnoreCase(getParentKPIEntity().getKpiMetaData().getFormatType()) ? Util.percentFormat(getParentKPIEntity().getRoot().getCurrentValue()) : KPIPortalContext.DIGIT2_DECIMAL_FORMAT.format(getParentKPIEntity().getRoot().getCurrentValue()));

			// 全省时，的前三后三
			String _7 = "";
			String _8 = "";
			String _9 = "";
			String _10 = "";
			String _11 = "";
			String _12 = "";

			String orderType = "tongbi";
			if ("年同比".equalsIgnoreCase(expRules)) {
				orderType = "yeartongbi";
			} else if ("绝对值".equalsIgnoreCase(expRules) || "不排名".equalsIgnoreCase(expRules)) {
				orderType = "current";
			}

			if ("HB".equalsIgnoreCase(getKey())) {
				Entity[] entities = getOrderChildren(orderType);

				int[] _idx = { 0, 1, 2, entities.length - 3, entities.length - 2, entities.length - 1 };
				String[] _value = new String[_idx.length];
				for (int i = 0; i < _idx.length; i++) {
					Entity aEntity = entities[_idx[i]];
					String value = "";
					if ("年同比".equalsIgnoreCase(expRules)) {
						value = Util.percentFormat(aEntity.getYearTongBi());
					} else if ("月同比".equalsIgnoreCase(expRules)) {
						value = Util.percentFormat(aEntity.getTongBi());
					} else {
						value = "percent".equalsIgnoreCase(getParentKPIEntity().getKpiMetaData().getFormatType()) ? Util.percentFormat(aEntity.getCurrentValue()) : KPIPortalContext.DIGIT2_DECIMAL_FORMAT.format(aEntity.getCurrentValue());
					}
					_value[i] = aEntity.getName() + "(" + value + ")";
				}

				_7 = _value[0];
				_8 = _value[1];
				_9 = _value[2];
				_10 = _value[3];
				_11 = _value[4];
				_12 = _value[5];
			} else {

				Entity[] entities = getParent().getOrderChildren(orderType);
				int i = 0;
				for (; i < entities.length; i++) {
					if (entities[i].getKey().equalsIgnoreCase(getKey()))
						break;
				}
				_4 = String.valueOf(i);
			}

			return MessageFormat.format(content, new Object[] { _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12 });
		}
	}

	public Object clone() {
		//  增加字段clone方法必需手工修改
		KPIEntity kpi = new KPIEntity();
		kpi.setKpiMetaData(this.getKpiMetaData());
		kpi.setKpiAppData(this.getKpiAppData());
		kpi.setValueFilter(this.valueFilter);
		kpi.setDate(this.getDate());
		try {
			kpi.setKpiEntityLoad((KPIEntityLoad) this.getKpiEntityLoad().getClass().newInstance());
			kpi.getKpiEntityLoad().setKpiEntity(kpi);
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		/*
		 * kpi=kpi.getKpiEntityLoad().load(); return kpi;
		 */
		return kpi.getKpiEntityLoad().load();
	}

	public String toString() {
		return "[" + getId() + ":" + getName() + ",index size: " + index.size() + "]";
	}

	public KPIEntityValueFilter getValueFilter() {
		return valueFilter;
	}

	public void setValueFilter(KPIEntityValueFilter valueFilter) {
		this.valueFilter = valueFilter;
	}

}
