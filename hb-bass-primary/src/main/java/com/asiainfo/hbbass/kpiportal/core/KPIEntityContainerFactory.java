package com.asiainfo.hbbass.kpiportal.core;

import com.asiainfo.hb.core.models.Configuration;

public class KPIEntityContainerFactory {
	// 2010-4-15替换成cacheserver
	private static KPIEntityContainer container = null;

	static {
		String className = Configuration.getInstance().getProperty("com.asiainfo.hbbass.kpiportal.core.KPIEntityContainer");
		if (className == null || className.length() == 0) {
			className = "com.asiainfo.hbbass.kpiportal.cache.KPIEntityContainerEhCache";
		}

		try {
			Class<?> cls = Class.forName(className);
			container = (KPIEntityContainer) cls.newInstance();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
	}

	public static KPIEntityContainer getInstance() {
		return container;
	}
}
