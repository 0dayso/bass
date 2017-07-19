package com.asiainfo.hbbass.component.util;

import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.asiainfo.hbbass.kpiportal.core.KPIMetaData;
import com.asiainfo.hbbass.kpiportal.core.KPIPortalContext;

public class Util {
	/**
	 * 根据大根堆，对堆排序
	 */
	@SuppressWarnings("rawtypes")
	public static void heapSort(Comparable[] arr) {
		// 把顺序表构建成为一个大根堆
		for (int i = arr.length / 2 - 1; i >= 0; --i) {
			heapAdjust(arr, i, arr.length);
		}

		for (int j = arr.length - 1; j > 0; --j) {
			Comparable temp = arr[0];
			arr[0] = arr[j];
			arr[j] = temp;
			heapAdjust(arr, 0, j);
		}
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static void heapAdjust(Comparable[] arr, int s, int m) {
		Comparable temp = arr[s];
		for (int j = 2 * s + 1; j < m; j = j * 2 + 1) {
			if (j + 1 < m && arr[j].compareTo(arr[j + 1]) > 0) {
				++j;
			}
			if (temp.compareTo(arr[j]) < 0) {
				break;
			}
			arr[s] = arr[j];
			s = j;
			arr[s] = temp;
		}
	}

	public static void main(String[] args) {
		// xmlMapping();
		// System.out.println(percentFormat(0.10445));
		System.out.println(Util.getTime(-2, "月"));

	}

	public static DecimalFormat PERCETN_FOTMAT = new DecimalFormat("0.00%");

	public static String percentFormat(double number) {
		return PERCETN_FOTMAT.format(number);
	}

	public static Connection getConnection() {
		Connection conn = null;
		try {
			Class.forName("COM.ibm.db2.jdbc.app.DB2Driver");
			conn = DriverManager.getConnection("jdbc:db2:wbdb", "pt", "pt");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return conn;
	}

	public static void releaseConnection(Connection conn) {
		if (conn != null)
			try {
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
	}

	@SuppressWarnings("rawtypes")
	public static void xmlMapping() {
		Connection conn = null;
		try {
			conn = getConnection();

			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			InputStream in = KPIPortalContext.class.getClassLoader().getResourceAsStream("kpiportal.xml");
			Document doc = db.parse(in);
			NodeList apps = doc.getDocumentElement().getElementsByTagName("app");
			Class cls = KPIMetaData.class;
			Field[] fields = cls.getDeclaredFields();

			PreparedStatement ps = conn.prepareStatement("insert into FPF_IRS_INDICATOR(id,name,appName,appType,instruction,kind,unit,division,targetValue,targetType,compTargetValue,loadClassName,formatType,arithmetic,originIds,filterClassName) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");

			for (int i = 0; i < apps.getLength(); i++) {
				Element app = (Element) apps.item(i);

				String appName = app.getAttribute("name");
				String appType = app.getAttribute("type");

				NodeList kpis = app.getElementsByTagName("kpi");

				for (int j = 0; j < kpis.getLength(); j++) {

					Element kpi = (Element) kpis.item(j);

					KPIMetaData obj = null;
					try {
						obj = (KPIMetaData) cls.newInstance();
					} catch (InstantiationException e) {
						e.printStackTrace();
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					}
					for (int m = 0; m < fields.length; m++) {
						try {
							fields[m].setAccessible(true);
							String value = null;
							if (fields[m].getType() == double.class) {
								value = (String) kpi.getAttribute(fields[m].getName());
								if (value.length() > 0) {
									fields[m].setDouble(obj, Double.valueOf(value).doubleValue());
								}
							} else if (fields[m].getType() == String.class) {
								value = (String) kpi.getAttribute(fields[m].getName());
								if (value != null && value.length() > 0)
									fields[m].set(obj, (String) kpi.getAttribute(fields[m].getName()));
							}
						} catch (NumberFormatException e) {
							e.printStackTrace();
						} catch (IllegalArgumentException e) {
							e.printStackTrace();
						} catch (IllegalAccessException e) {
							e.printStackTrace();
						}
					}
					System.out.println(obj.getId());
					ps.setString(1, obj.getId());
					ps.setString(2, obj.getName());
					ps.setString(3, appName);
					ps.setString(4, appType);
					ps.setString(5, obj.getInstruction());
					ps.setString(6, obj.getKind());
					ps.setString(7, obj.getUnit());
					ps.setString(8, KPIPortalContext.DECIMAL_FORMAT.format(obj.getDivision()));
					ps.setString(9, KPIPortalContext.DECIMAL_FORMAT.format(obj.getTargetValue()));
					ps.setString(10, obj.getTargetType());
					ps.setString(11, KPIPortalContext.DECIMAL_FORMAT.format(obj.getCompTargetValue()));
					ps.setString(12, obj.getLoadClassName());
					ps.setString(13, obj.getFormatType());
					ps.setString(14, obj.getArithmetic());
					ps.setString(15, obj.getOriginIds());
					ps.setString(16, obj.getFilterClassName());
					// ps.addBatch();
					ps.execute();

				}
			}
			// ps.executeBatch();
			conn.commit();
			ps.close();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			releaseConnection(conn);
		}
	}

	static char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

	public static String md5(String string) {
		try {
			MessageDigest digest = MessageDigest.getInstance("MD5");
			byte[] md = digest.digest(string.getBytes());
			int j = md.length;
			char str[] = new char[j * 2];
			int k = 0;
			for (int i = 0; i < j; i++) {
				byte byte0 = md[i];
				str[k++] = hexDigits[byte0 >>> 4 & 0xf];
				str[k++] = hexDigits[byte0 & 0xf];
			}
			return String.valueOf(str);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return "";
	}

	public static String getRemoteAddr(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null) {
			ip = request.getRemoteAddr();
		}
		return ip;
	}

	/**
	 * 
	 * @param index
	 *            0当前，1下一个，-1上一个
	 * @param type
	 *            年，月，日
	 * @return
	 */
	public static String getTime(int index, String type) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		Calendar calendar = GregorianCalendar.getInstance();

		if (type.equals("年")) {
			calendar.add(Calendar.YEAR, index);
			return sdf.format(calendar.getTime()).substring(0, 4);
		} else if (type.equals("月")) {
			calendar.add(Calendar.MONTH, index);
			return sdf.format(calendar.getTime()).substring(0, 6);
		} else if (type.equals("日")) {
			calendar.add(Calendar.DATE, index);
			return sdf.format(calendar.getTime());
		} else {
			return "";
		}
	}
}
