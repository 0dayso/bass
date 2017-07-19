package com.asiainfo.hbbass.common.persistence;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 定义数据库表的字段信息
 * 
 * @author Mei Kefu
 * @date 2009-8-19
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Column {

	/**
	 * 数据库字段
	 * 
	 * @return
	 */
	String name();

	/**
	 * 数据库类型,暂时支持string 和int
	 * 
	 * @return
	 */
	String type() default "string";

	/**
	 * 是否是主键,save,update,delete,query中定位对象用
	 * 
	 * @return
	 */
	boolean isPrimaryKey() default false;

	/**
	 * 是否是自增建,对应save中是否使用数据库来生成
	 * 
	 * @return
	 */
	boolean isIncrement() default false;

	/**
	 * 时间类型是否使用默认值
	 * 
	 * @return
	 */
	boolean currentDate() default false;

}