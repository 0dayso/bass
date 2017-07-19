package com.asiainfo.hbbass.common.persistence;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

/**
 * 
 * @author Mei Kefu
 * @date 2009-8-25
 */
public final class PersistenceArray {

	@SuppressWarnings("rawtypes")
	private List persistences = null;

	private static Logger LOG = Logger.getLogger(PersistenceArray.class);

	/** 数据库连接 **/
	private Connection connection = null;

	public Connection getConnection() {
		return connection;
	}

	public void setConnection(Connection connection) {
		this.connection = connection;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static PersistenceArray parse(Class cls, HttpServletRequest request) {
		PersistenceArray array = null;
		if (request != null) {
			List result = new ArrayList();
			Field[] fields = cls.getDeclaredFields();

			for (int i = 0; i < fields.length; i++) {

				if (fields[i].isAnnotationPresent(Column.class)) {

					String[] values = request.getParameterValues(fields[i].getName());
					Column c = fields[i].getAnnotation(Column.class);

					for (int j = 0; values != null && j < values.length; j++) {
						String value = values[j];
						Object obj = null;
						if (result.size() - 1 < j) {
							try {
								obj = cls.newInstance();
							} catch (InstantiationException e) {
								e.printStackTrace();
							} catch (IllegalAccessException e) {
								e.printStackTrace();
							}
							result.add(obj);
						} else {
							obj = result.get(j);
						}

						setField(fields[i], obj, value, c.type());
					}

				}
			}
			array = new PersistenceArray();
			array.persistences = result;

		} else {
			LOG.warn("request对象为空，无法完成字段的数据填充");
		}

		return array;
	}

	protected static void setField(Field field, Object obj, String value, String type) {
		if (value != null && value.length() > 0) {
			field.setAccessible(true);

			try {
				if ("int".equalsIgnoreCase(type)) {

					field.setInt(obj, Integer.parseInt(value));
				} else {//  只判断String
					field.set(obj, value);
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

	public void save() throws SQLException {
		for (int i = 0; persistences != null && i < persistences.size(); i++) {

			Persistence persistence = (Persistence) persistences.get(i);
			persistence.setConnection(connection);
			persistence.save();
		}
	}
}
