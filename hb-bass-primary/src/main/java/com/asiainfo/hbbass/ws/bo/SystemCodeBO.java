package com.asiainfo.hbbass.ws.bo;

import org.apache.commons.lang.StringUtils;
import org.dom4j.Element;

import com.asiainfo.bass.components.models.BeanFactoryA;
import com.asiainfo.hbbass.ws.common.Constant;
import com.asiainfo.hbbass.ws.dao.SystemCodeDAO;

public class SystemCodeBO {
	private SystemCodeBO() {
	}

	private static SystemCodeBO instance = null;

	public static SystemCodeBO getInstance() {
		if (instance == null) {
			instance = new SystemCodeBO();
		}
		return instance;
	}

	/**
	 * 设置经分系统当前金库模式开关值
	 */
	public void setIsOpen(String xml) {
		SystemCodeDAO systemCodeDAO = (SystemCodeDAO) BeanFactoryA.getBean("systemCodeDAO");
		Element root;
		try {
			root = MenuInfoBO.getInstance().parseStringToDocument(xml);
		} catch (Exception e) {
			throw new IllegalArgumentException("解析入参XML异常。");
		}
		Element element = (Element) root.selectSingleNode("/service/data_info");
		String password = ((Element) element.element("password")).getText();
		String value = ((Element) element.element("value")).getText();
		if (!Constant.REQUEST_PASSWORD.equals(password)) {
			throw new IllegalArgumentException("验证密码错误。");
		}
		if (StringUtils.isBlank(value) || value.length() != 1) {
			throw new IllegalArgumentException("参数value错误。");
		}
		if ("true".equals(value) || "Y".equals(value) || "1".equals(value)) {
			systemCodeDAO.setIsOpen("Y");
		}
		if ("false".equals(value) || "N".equals(value) || "0".equals(value)) {
			systemCodeDAO.setIsOpen("N");
		}
	}

	/**
	 * 获取经分系统当前金库模式开关值
	 */
	public boolean getIsOpen() {
		SystemCodeDAO systemCodeDAO = (SystemCodeDAO) BeanFactoryA.getBean("systemCodeDAO");
		return systemCodeDAO.getIsOpen();
	}
}
