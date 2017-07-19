/*
 * Copyright 2002-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.asiainfo.hb.web;

import javax.servlet.ServletContext;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;

import org.springframework.beans.BeansException;

/**
 * 原来使用org.springframework.web.servlet.view.freemarker.
 * FreeMarkerView是可以在架包中找到ftl，现在不知道怎么找不到了，所以写了这个类，ftl的架包路径是写死的
 * 
 * @author Mei Kefu
 * 
 */
public class FreeMarkerView extends org.springframework.web.servlet.view.freemarker.FreeMarkerView {

	@Override
	protected void initServletContext(ServletContext servletContext) throws BeansException {
		super.initServletContext(servletContext);
		ClassTemplateLoader ctl = new ClassTemplateLoader(this.getClass(),"/resources/views/");
		TemplateLoader tl = getConfiguration().getTemplateLoader();
		TemplateLoader[] loaders = new TemplateLoader[] { tl, ctl };
		MultiTemplateLoader mtl = new MultiTemplateLoader(loaders);
		getConfiguration().setTemplateLoader(mtl);
	}
}
