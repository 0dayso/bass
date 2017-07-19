package com.asiainfo.hbbass.common.persistence;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.sql.Date;
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
public abstract class RequestParse {

	private static Logger LOG = Logger.getLogger(RequestParse.class);

	/**
	 * 解析request并自动生成对象
	 * 
	 * @param cls
	 *            : 解析的返回的Class类
	 * @param request
	 *            ：HTTPRequest请求包含字段的数据
	 * @return ：cls参数的对象并填充了字段数据
	 */
	public static Object parse(Class<?> cls, HttpServletRequest request) {
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
	public static Object parse(Class<?> cls, HttpServletRequest request, String charset, String charset1) {

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
			@SuppressWarnings("rawtypes")
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

	@SuppressWarnings("rawtypes")
	protected static List process(Class<?> cls) {

		Class<?> superCls = cls;
		List<Field> list = new ArrayList<Field>();
		do {
			Field[] fields = superCls.getDeclaredFields();

			for (int i = 0; i < fields.length; i++) {
				list.add(fields[i]);
			}

		} while ((superCls = cls.getSuperclass()) != RequestParse.class);

		return list;
	}

	public static void main(String[] args) {
		// PersistenceObject obj = new PersistenceObject();

		// obj.save();
	}

}
