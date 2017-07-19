package com.asiainfo.hbbass.common.persistence;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 定义数据库表的一对多关系子对象关系
 * 
 * @author Mei Kefu
 * @date 2009-8-24
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Children {

	/**
	 * 子对象的类名
	 * 
	 * @return
	 */
	String className();

	/**
	 * 子对象对应的表名
	 * 
	 * @return
	 */
	String tableName();

	/**
	 * 子数据库表中字段名称
	 * 
	 * @return
	 */
	String key();

	/**
	 * 父对象字段名称与类型
	 * 
	 * @return
	 */
	Column parent() default @Column(name = "", isPrimaryKey = true);
}
