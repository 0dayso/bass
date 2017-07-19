package com.asiainfo.hbbass.kpiportal.core;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

import com.asiainfo.hbbass.common.persistence.Column;
import com.asiainfo.hbbass.common.persistence.RequestParse;

/**
 * 
 * 每个Cell的状态
 * 
 * @author Mei Kefu
 * @date 2009-8-17
 */
public class KPIEntityValueState extends RequestParse implements Serializable {

	private static final long serialVersionUID = 7299365306897506003L;

	@DimensionEnum(dimensions = { "1", "2", "3", "-1" })
	@Column(name = "brand_id")
	private String brand = "";

	public KPIEntityValueState() {
		super();
	}

	public KPIEntityValueState(String brand) {
		super();
		this.brand = brand;
	}

	public String getBrand() {
		return brand;
	}

	public void setBrand(String brand) {
		this.brand = brand;
	}

	public boolean equals(Object obj) {

		boolean result = false;
		if (obj != null && obj instanceof KPIEntityValueState) {

			KPIEntityValueState newEntity = (KPIEntityValueState) obj;
			if (brand.equalsIgnoreCase(newEntity.getBrand())) {
				result = true;
			}
		}

		return result;
	}

	public String toPredication() {

		StringBuffer sb = new StringBuffer();
		Class<?> cls = this.getClass();
		Field[] fields = cls.getDeclaredFields();

		for (int i = 0; i < fields.length; i++) {

			if (fields[i].isAnnotationPresent(Column.class)) {

				Column c = fields[i].getAnnotation(Column.class);
				String value = "";
				try {
					fields[i].setAccessible(true);
					value = (String) fields[i].get(this);
				} catch (IllegalArgumentException e) {
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					e.printStackTrace();
				}

				if (value != null && value.length() > 0) {
					sb.append(" and ").append(c.name()).append("=");
					if ("string".equalsIgnoreCase(c.type()))
						sb.append("'");

					sb.append(value);

					if ("string".equalsIgnoreCase(c.type()))
						sb.append("'");
				}
			}
		}

		return sb.toString();
	}

	/**
	 * 计算出所有的State状态
	 * 
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public static List getAllState() {

		List<KPIEntityValueState> result = new ArrayList<KPIEntityValueState>();

		Class<?> cls = KPIEntityValueState.class;
		Field[] fields = cls.getDeclaredFields();
		for (int i = 0; i < fields.length; i++) {
			Field field = fields[i];
			if (field.isAnnotationPresent(DimensionEnum.class)) {
				DimensionEnum dim = field.getAnnotation(DimensionEnum.class);
				for (int j = 0; j < dim.dimensions().length; j++) {
					result.add(new KPIEntityValueState(dim.dimensions()[j]));
				}

			}
		}
		return result;
	}

	public static void main(String[] args) {
		KPIEntityValueState state = new KPIEntityValueState();

		state.setBrand("009");

		System.out.println(state.getBrand());
	}
}