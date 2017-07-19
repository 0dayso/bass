package com.asiainfo.hbbass.common.persistence;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 定义数据库表的信息
 * 
 * @author Mei Kefu
 * @date 2009-8-20
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Table {
	/**
	 * 实体对应的数据库表名
	 * 
	 * @return
	 */
	String name();

}
