package com.asiainfo.hbbass.common.persistence;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

/**
 * 对象持久化类
 * 
 * @author Mei Kefu
 * @date 2009-8-20
 * 
 */
public abstract class Persistence {

	/** 数据库连接 **/
	private Connection connection = null;

	private static String dailect = "DB2";

	private static Logger LOG = Logger.getLogger(Persistence.class);

	/**
	 * 解析request并自动生成对象
	 * 
	 * @param cls
	 *            : 解析的返回的Class类
	 * @param request
	 *            ：HTTPRequest请求包含字段的数据
	 * @return ：cls参数的对象并填充了字段数据
	 */
	@SuppressWarnings("rawtypes")
	public static Object parse(Class cls, HttpServletRequest request) {
		return parse(cls, request, null, null);
	}

	/**
	 * 
	 * 解析request并自动生成对象
	 * 
	 * @param cls
	 *            : 解析的返回的Class类
	 * @param request
	 *            ：HTTPRequest请求包含字段的数据
	 * @param charset
	 *            : 转换前的字符集
	 * @param charset1
	 *            ：转换后的字符集
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static Object parse(Class cls, HttpServletRequest request, String charset, String charset1) {

		/*
		 * 用别的方法调用的时候有问题不能实现 Class cls = Reflection.getCallerClass(2); String
		 * className = new Throwable().getStackTrace()[1].getClassName();
		 * System.out.println(className); System.out.println(cls);
		 */
		Object obj = null;
		try {
			obj = cls.newInstance();
		} catch (InstantiationException e) {
			LOG.error(e.getMessage() + "创建对象失败", e);
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			LOG.error(e.getMessage() + "创建对象失败", e);
			e.printStackTrace();
		}

		if (request != null) {
			List fields = process(cls);

			for (int i = 0; i < fields.size(); i++) {

				Field field = (Field) fields.get(i);

				if (field.isAnnotationPresent(Column.class)) {

					String value = request.getParameter(field.getName());

					Column c = field.getAnnotation(Column.class);

					if (value != null) {

						field.setAccessible(true);

						try {
							if ("int".equalsIgnoreCase(c.type())) {
								field.setInt(obj, Integer.parseInt(value));
							} else if ("number".equalsIgnoreCase(c.type())) {
								field.setDouble(obj, Double.parseDouble(value));
							} else if ("string".equalsIgnoreCase(c.type())) {
																				// 只判断String
								if (charset != null) {
									try {
										value = new String(value.getBytes(charset), charset1);
									} catch (UnsupportedEncodingException e1) {
										e1.printStackTrace();
									}
								}
								field.set(obj, value);
							} else if ("date".equalsIgnoreCase(c.type())) {
								GregorianCalendar cal = null;
								if (c.currentDate()) {
									cal = new GregorianCalendar();
								} else {
									String[] date = value.split("-");

									if (date.length == 3) {
										int year = Integer.parseInt(date[0]);
										int month = Integer.parseInt(date[1]);
										int day = Integer.parseInt(date[2]);
										cal = new GregorianCalendar(year, month, day);
									}
								}

								if (cal != null)
									field.set(obj, new Date(cal.getTimeInMillis()));

							} else if ("timestamp".equalsIgnoreCase(c.type())) {
								GregorianCalendar cal = null;
								if (c.currentDate()) {
									cal = new GregorianCalendar();
								} else {

									String[] split = value.split(" ");

									if (split.length == 2) {
										String[] date = split[0].split("-");

										String[] time = split[1].split(":");

										if (date.length == 3 && time.length == 3) {
											int year = Integer.parseInt(date[0]);
											int month = Integer.parseInt(date[1]);
											int day = Integer.parseInt(date[2]);

											int hour = Integer.parseInt(time[0]);
											int min = Integer.parseInt(time[1]);
											int sec = Integer.parseInt(time[2]);

											cal = new GregorianCalendar(year, month, day, hour, min, sec);
										}
									}
								}

								if (cal != null)
									field.set(obj, new Timestamp(cal.getTimeInMillis()));
							}

						} catch (IllegalArgumentException e) {
							e.printStackTrace();
							LOG.error(e.getMessage() + "绑定参数失败", e);
						} catch (IllegalAccessException e) {
							e.printStackTrace();
							LOG.error(e.getMessage() + "绑定参数失败", e);
						}
					}
				}
			}

		} else {
			LOG.warn("request对象为空，无法完成字段的数据填充");
		}
		return obj;
	}

	/**
	 * 处理父类问题
	 * 
	 * @param cls
	 * @return
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected static List process(Class cls) {

		Class superCls = cls;
		List list = new ArrayList();
		do {
			Field[] fields = superCls.getDeclaredFields();

			for (int i = 0; i < fields.length; i++) {
				list.add(fields[i]);
			}

		} while ((superCls = cls.getSuperclass()) != Persistence.class);

		return list;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void save() throws SQLException {

		StringBuffer sql = new StringBuffer("insert into ");
		StringBuffer sb = new StringBuffer();
		Class cls = this.getClass();

		if (cls.isAnnotationPresent(Table.class)) {

			String tableName = ((Table) cls.getAnnotation(Table.class)).name();

			sql.append(tableName).append("(");

			List fields = process(cls);

			for (int i = 0; i < fields.size(); i++) {
				Field field = (Field) fields.get(i);
				if (field.isAnnotationPresent(Column.class)) {

					Column c = field.getAnnotation(Column.class);

					if (!c.isIncrement()) {

						try {
							field.setAccessible(true);

							Object obj = field.get(this);
							if (obj != null) {
								sql.append(c.name()).append(",");
								sb.append("?,");
							}
						} catch (IllegalArgumentException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						}
					}
				}
			}

			sql.delete(sql.length() - 1, sql.length());
			sb.delete(sb.length() - 1, sb.length());

			sql.append(") values (").append(sb).append(")");

			LOG.debug("SQL:" + sql);

			if (connection != null) {
				try {
					PreparedStatement ps = connection.prepareStatement(sql.toString());
					int j = 1;
					for (int i = 0; i < fields.size(); i++) {
						Field field = (Field) fields.get(i);
						if (field.isAnnotationPresent(Column.class)) {
							Column c = field.getAnnotation(Column.class);

							if (!c.isIncrement()) {
								j = setPreparedParam(ps, field, c, j);
							}
						}
					}
					ps.execute();
					ps.close();

				} catch (SQLException e) {
					e.printStackTrace();
					LOG.error(e.getMessage() + "保存对象失败", e);
					throw e;
				}
			}

		}
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void update() throws SQLException {
		StringBuffer sql = new StringBuffer("update ");
		StringBuffer sb = new StringBuffer();
		Class cls = this.getClass();

		if (cls.isAnnotationPresent(Table.class)) {

			String tableName = ((Table) cls.getAnnotation(Table.class)).name();

			sql.append(tableName).append(" set ");

			int lastSeq = 1;// 记录主键的序号
			List fields = process(cls);
			for (int i = 0; i < fields.size(); i++) {
				Field field = (Field) fields.get(i);
				if (field.isAnnotationPresent(Column.class)) {

					Column c = field.getAnnotation(Column.class);

					if (c.isPrimaryKey()) {
						sb.append(" where ").append(c.name()).append("=?");
					} else {

						try {
							field.setAccessible(true);
							Object obj = field.get(this);
							if (obj != null) {
								sql.append(c.name()).append("=?,");
								lastSeq++;
							}

						} catch (IllegalArgumentException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						}

					}

				}
			}
			sql.delete(sql.length() - 1, sql.length());
			sql.append(sb);
			LOG.debug("SQL:" + sql);

			if (connection != null) {
				try {
					PreparedStatement ps = connection.prepareStatement(sql.toString());
					int j = 1;
					for (int i = 0; i < fields.size(); i++) {
						Field field = (Field) fields.get(i);
						if (field.isAnnotationPresent(Column.class)) {
							Column c = field.getAnnotation(Column.class);

							if (c.isPrimaryKey()) {
								setPreparedParam(ps, field, c, lastSeq);
							} else {
								j = setPreparedParam(ps, field, c, j);
							}
						}
					}
					ps.execute();
					ps.close();

				} catch (SQLException e) {
					e.printStackTrace();
					LOG.error(e.getMessage() + "更新对象失败", e);
					throw e;
				}
			}

		}
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void delete() throws SQLException {
		StringBuffer sql = new StringBuffer("delete from ");

		Class cls = this.getClass();

		if (cls.isAnnotationPresent(Table.class)) {

			String tableName = ((Table) cls.getAnnotation(Table.class)).name();

			sql.append(tableName);

			Field[] fields = cls.getDeclaredFields();
			Field field = null;
			Column c = null;
			for (int i = 0; i < fields.length; i++) {
				if (fields[i].isAnnotationPresent(Column.class)) {

					c = fields[i].getAnnotation(Column.class);

					if (c.isPrimaryKey()) {
						sql.append(" where ").append(c.name()).append("=?");
						field = fields[i];
						break;
					}
				}
			}
			LOG.debug("SQL:" + sql);

			if (connection != null) {
				try {
					PreparedStatement ps = connection.prepareStatement(sql.toString());
					setPreparedParam(ps, field, c, 1);
					ps.execute();
					ps.close();

				} catch (SQLException e) {
					e.printStackTrace();
					LOG.error(e.getMessage() + "删除对象失败", e);
					throw e;
				}
			}
		}
	}

	/**
	 * 指定Primary Key 来查询对象
	 * 
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void query() throws SQLException {

		StringBuffer sql = new StringBuffer("select * from ");

		Class cls = this.getClass();

		if (cls.isAnnotationPresent(Table.class)) {

			String tableName = ((Table) cls.getAnnotation(Table.class)).name();

			sql.append(tableName);

			Field[] fields = cls.getDeclaredFields();
			Field field = null;
			Column c = null;
			for (int i = 0; i < fields.length; i++) {
				if (fields[i].isAnnotationPresent(Column.class)) {

					c = fields[i].getAnnotation(Column.class);

					if (c.isPrimaryKey()) {
						sql.append(" where ").append(c.name()).append("=?");
						field = fields[i];
						break;
					}
				}
			}

			if ("DB2".equalsIgnoreCase(dailect)) {
				sql.append(" with ur");
			}
			LOG.debug("SQL:" + sql);

			if (connection != null) {
				try {
					PreparedStatement ps = connection.prepareStatement(sql.toString());
					setPreparedParam(ps, field, c, 1);
					ResultSet rs = ps.executeQuery();
					if (rs.next()) {
						for (int i = 0; i < fields.length; i++) {
							if (fields[i].isAnnotationPresent(Column.class)) {

								c = fields[i].getAnnotation(Column.class);

								if (!c.isPrimaryKey()) {
									setField(this, rs, fields[i], c);
								}
							}
						}
					}

					rs.close();
					ps.close();

				} catch (SQLException e) {
					e.printStackTrace();
					LOG.error(e.getMessage() + "删除对象失败", e);
					throw e;
				}
			}
		}
	}

	/**
	 * 查询一对多关系中的子节点
	 * 
	 * @throws SQLException
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void queryChild() throws SQLException {

		String sql = "select * from ";

		Class cls = this.getClass();

		if (cls.isAnnotationPresent(Table.class)) {

			Field[] oriFields = cls.getDeclaredFields();

			Children children = null;
			for (int k = 0; k < oriFields.length; k++) {

				if (oriFields[k].isAnnotationPresent(Children.class)) {
					List result = new ArrayList();
					children = oriFields[k].getAnnotation(Children.class);

					Field field = null;
					Column keyColumn = null;
					if (children.parent().isPrimaryKey()) {
						for (int m = 0; m < oriFields.length; m++) {
							if (oriFields[m].isAnnotationPresent(Column.class)) {
								keyColumn = oriFields[m].getAnnotation(Column.class);
								if (keyColumn.isPrimaryKey()) {
									field = oriFields[m];
									break;
								}
							}
						}
					} else {
						keyColumn = children.parent();
						for (int m = 0; m < oriFields.length; m++) {
							if (oriFields[m].isAnnotationPresent(Column.class)) {
								Column tempColumn = oriFields[m].getAnnotation(Column.class);
								if (keyColumn.name().equalsIgnoreCase(tempColumn.name())) {
									field = oriFields[m];
									break;
								}
							}
						}

					}

					StringBuffer tempSql = new StringBuffer();

					tempSql.append(sql).append(children.tableName()).append(" where ").append(children.key()).append("=?");

					if ("DB2".equalsIgnoreCase(dailect)) {
						tempSql.append(" with ur");
					}

					LOG.debug("SQL:" + tempSql);

					if (connection != null) {
						try {
							PreparedStatement ps = connection.prepareStatement(tempSql.toString());
							setPreparedParam(ps, field, keyColumn, 1);
							ResultSet rs = ps.executeQuery();

							while (rs.next()) {
								try {
									Class newCls = Class.forName(children.className());
									Object obj = newCls.newInstance();
									Column column = null;
									Field[] fields = newCls.getDeclaredFields();
									for (int i = 0; i < fields.length; i++) {
										if (fields[i].isAnnotationPresent(Column.class)) {
											column = fields[i].getAnnotation(Column.class);
											setField(obj, rs, fields[i], column);
										} else if (fields[i].isAnnotationPresent(Parent.class)) {
											fields[i].setAccessible(true);
											fields[i].set(obj, this);
										}
									}
									result.add(obj);
								} catch (IllegalArgumentException e) {
									e.printStackTrace();
								} catch (IllegalAccessException e) {
									e.printStackTrace();
								} catch (InstantiationException e) {
									e.printStackTrace();
								} catch (ClassNotFoundException e) {
									e.printStackTrace();
								}
							}
							rs.close();
							ps.close();

						} catch (SQLException e) {
							e.printStackTrace();
							LOG.error(e.getMessage() + " ", e);
							throw e;
						}

					}
					if (result.size() > 0) {
						try {
							oriFields[k].setAccessible(true);
							oriFields[k].set(this, result);
						} catch (IllegalArgumentException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
	}

	protected void setField(Object obj, ResultSet rs, Field field, Column c) throws SQLException {
		try {
			field.setAccessible(true);
			if ("int".equalsIgnoreCase(c.type())) {
				int value = rs.getInt(c.name());
				field.setInt(obj, value);
				LOG.debug("name:" + field.getName() + " Value =" + value);
			} else if ("number".equalsIgnoreCase(c.type())) {
				double value = rs.getDouble(c.name());
				field.setDouble(obj, value);
				LOG.debug("name:" + field.getName() + " Value =" + value);
			} else if ("string".equalsIgnoreCase(c.type())) {
				String value = (String) rs.getString(c.name());
				if (value == null)
					value = "";
				field.set(obj, value);
				LOG.debug("name:" + field.getName() + " Value =" + value);
			} else if ("date".equalsIgnoreCase(c.type())) {
				Date date = rs.getDate(c.name());
				field.set(obj, date);
				LOG.debug("name:" + field.getName() + " Value =" + date);
			} else if ("timestamp".equalsIgnoreCase(c.type())) {
				Timestamp date = rs.getTimestamp(c.name());
				field.set(obj, date);
				LOG.debug("name:" + field.getName() + " Value =" + date);
			}
		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 为PreparedStatement绑定变量
	 * 
	 * @param ps
	 * @param field
	 * @param columnType
	 * @param seq
	 * @throws SQLException
	 */
	protected int setPreparedParam(PreparedStatement ps, Field field, Column c, int seq) throws SQLException {
		try {

			field.setAccessible(true);
			Object obj = field.get(this);
			if (obj != null) {
				if ("int".equalsIgnoreCase(c.type())) {
					int value = ((Integer) obj).intValue();
					ps.setInt(seq, value);
					LOG.debug("Bind Var{" + seq + ":" + value + "}");
				} else if ("number".equalsIgnoreCase(c.type())) {
					double value = ((Double) obj).doubleValue();
					ps.setDouble(seq, value);
					LOG.debug("Bind Var{" + seq + ":" + value + "}");
				} else if ("string".equalsIgnoreCase(c.type())) {
					String value = (String) obj;
					ps.setString(seq, value);
					LOG.debug("Bind Var{" + seq + ":" + value + "}");
				} else if ("date".equalsIgnoreCase(c.type())) {
					Date value = (Date) obj;
					ps.setDate(seq, value);
					LOG.debug("Bind Var{" + seq + ":" + value + "}");
				} else if ("timestamp".equalsIgnoreCase(c.type())) {
					Timestamp value = (Timestamp) obj;
					ps.setTimestamp(seq, value);
					LOG.debug("Bind Var{" + seq + ":" + value + "}");
				}
				seq++;
			}

		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		return seq;
	}

	public Connection getConnection() {
		return connection;
	}

	public void setConnection(Connection connection) {
		if (this.connection != null) {
			releaseConnection();
		}
		this.connection = connection;
	}

	public void releaseConnection() {
		if (connection != null) {
			try {
				connection.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public static void main(String[] args) {
		// PersistenceObject obj = new PersistenceObject();

		// obj.save();
	}

}
