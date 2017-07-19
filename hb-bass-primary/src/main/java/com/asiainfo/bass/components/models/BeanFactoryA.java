package com.asiainfo.bass.components.models;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.BeanFactoryAware;
import org.springframework.stereotype.Component;

/**
 * 
 * @author Mei Kefu
 * @date 2011-6-2
 */
@Component
public class BeanFactoryA implements BeanFactoryAware {

	private static org.springframework.beans.factory.BeanFactory beanFactory;

	@SuppressWarnings("static-access")
	public void setBeanFactory(org.springframework.beans.factory.BeanFactory beanFactory) throws BeansException {
		this.beanFactory = beanFactory;
	}

	public static Object getBean(String name) {
		return beanFactory.getBean(name);
	}

}
