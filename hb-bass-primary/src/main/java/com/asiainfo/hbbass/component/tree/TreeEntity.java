package com.asiainfo.hbbass.component.tree;

import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.HashMap;

import org.apache.log4j.Logger;

/**
 * 初始化的List必须是树查询出来的List
 * 
 * @author Mei Kefu
 * 
 */
public class TreeEntity {

	private Entity head = new Entity();

	@SuppressWarnings("rawtypes")
	private Map index = new HashMap();

	private Process process;

	private final static Logger LOG = Logger.getLogger(TreeEntity.class);

	public Entity getHead() {
		return head;
	}

	@SuppressWarnings("rawtypes")
	public Map getIndex() {
		return index;
	}

	public void setProcess(Process process) {
		this.process = process;
	}

	public Process getProcess() {
		return process;
	}

	/**
	 * List格式是 key ,value ,parent,必须是树查询的结果
	 * 
	 * @param list
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void init(List list) {
		for (int i = 0; i < list.size(); i++) {
			try {
				String[] arr = (String[]) list.get(i);
				String key = arr[0];
				String parent = arr[2];
				Entity entity = null;
				if (getIndex().containsKey(parent)) {
					entity = (Entity) getIndex().get(parent);
				} else {
					entity = getHead();
				}
				Map children = entity.getChildren();
				if (children == null) {
					children = new TreeMap();
					entity.setChildren(children);
				}
				Entity newentry = new Entity(key, arr[1], entity);
				children.put(key, newentry);
				getIndex().put(key, newentry);
			} catch (Exception e) {
				LOG.error(e.getMessage(), e);
				e.printStackTrace();
			}
		}
	}

	public void useExtreeProcess() {
		process = new TreeEntity.Process() {
			public StringBuffer sb = new StringBuffer();

			public void process(TreeEntity.Entity entity) {
				sb.append("var ").append("el_").append(entity.getKey().replace("-", "_")).append(" = new WebFXTreeItem(").append("'").append(entity.getKey()).append("',").append("'").append(entity.getValue()).append("',");
				sb.append("\"\",");
				if (entity.getParent() != null && entity.getParent().getKey() != null)
					sb.append("el_").append(entity.getParent().getKey()).append("");
				else
					sb.append("tree");
				sb.append(");\r\n");
			}

			public Object getObject() {
				return sb;
			}

			public void setObject(Object object) {
			}
		};
	}

	public void useExtreeCheckboxProcess() {
		process = new TreeEntity.Process() {
			public StringBuffer sb = new StringBuffer();
			@SuppressWarnings("rawtypes")
			public java.util.Set set = null;

			public void process(TreeEntity.Entity entity) {
				sb.append("var ").append("el_").append(entity.getKey().replace("-", "_")).append(" = new WebFXCheckBoxTreeItem(").append("'").append(entity.getKey()).append("',").append("'").append(entity.getValue()).append("',").append("'").append(entity.getKey()).append("',");
				if (entity.getParent() != null && entity.getParent().getKey() != null)
					sb.append("el_").append(entity.getParent().getKey()).append("");
				else
					sb.append("tree");
				sb.append(",'res'");
				if (set != null && set.contains(entity.getKey())) {
					sb.append(",true");
				}
				sb.append(");\r\n");
			}

			public Object getObject() {
				return sb;
			}

			@SuppressWarnings("rawtypes")
			public void setObject(Object object) {
				set = (java.util.Set) object;
			}
		};
	}

	public void iterator() {
		nestedIterator(getHead().getChildren());
	}

	@SuppressWarnings("rawtypes")
	public void nestedIterator(Map children) {
		for (Iterator iterator = children.entrySet().iterator(); iterator.hasNext();) {
			Map.Entry entry = (Map.Entry) iterator.next();
			TreeEntity.Entity treeentry = (TreeEntity.Entity) entry.getValue();

			if (process != null)
				process.process(treeentry);
			// System.out.println(treeentry);
			if (treeentry.getChildren() != null)
				nestedIterator(treeentry.getChildren());
		}
	}

	public static interface Process {
		public Object getObject();

		public void setObject(Object object);

		public void process(Entity entity);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static void main(String[] args) {
		List list = new java.util.ArrayList();

		String[] arr0 = { "0", "0", "" };
		list.add(arr0);
		String[] arr1 = { "2", "2", "0" };
		list.add(arr1);
		String[] arr = { "1", "1", "0" };
		list.add(arr);

		String[] arr4 = { "21", "21", "2" };
		list.add(arr4);
		String[] arr2 = { "11", "11", "1" };
		list.add(arr2);

		String[] arr3 = { "12", "12", "1" };
		list.add(arr3);

		TreeEntity tree = new TreeEntity();
		tree.init(list);

		System.out.println(tree);

		Process p = new Process() {
			public StringBuffer sb = new StringBuffer();
			public java.util.Set set = null;

			public void process(Entity entity) {
				// sb.append(entry);

				sb.append("var ").append("el_").append(entity.getKey().replace("-", "_")).append(" = new WebFXCheckBoxTreeItem('").append(entity.getValue()).append("','").append(entity.getKey()).append("',");
				if (entity.getParent() != null && entity.getParent().getKey() != null)
					sb.append("el_").append(entity.getParent().getKey()).append("");
				else
					sb.append("tree");
				if (set != null && set.contains(entity.getKey())) {
					sb.append(",null,null,true");
				}
				sb.append(");\r\n");
			}

			public Object getObject() {
				return sb;
			}

			public void setObject(Object object) {
				set = (java.util.Set) object;
			}
		};
		java.util.Set set = new java.util.HashSet();
		set.add("12");
		p.setObject(set);
		tree.setProcess(p);
		tree.iterator();
		StringBuffer sb = (StringBuffer) p.getObject();

		System.out.println(sb.toString());
	}

	public static class Entity {
		private String key;
		private String value;
		private Entity parent;
		@SuppressWarnings("rawtypes")
		private Map children;

		public Entity() {
			super();
		}

		public Entity(String key, String value) {
			super();
			this.key = key;
			this.value = value;
		}

		public Entity(String key, String value, Entity parent) {
			super();
			this.key = key;
			this.value = value;
			this.parent = parent;
		}

		public String getKey() {
			return key;
		}

		public void setKey(String key) {
			this.key = key;
		}

		public String getValue() {
			return value;
		}

		public void setValue(String value) {
			this.value = value;
		}

		public Entity getParent() {
			return parent;
		}

		public void setParent(Entity parent) {
			this.parent = parent;
		}

		@SuppressWarnings("rawtypes")
		public Map getChildren() {
			return children;
		}

		@SuppressWarnings("rawtypes")
		public void setChildren(Map children) {
			this.children = children;
		}

		public String toString() {
			return "{" + key + "=" + value + "}";
		}
	}
}
