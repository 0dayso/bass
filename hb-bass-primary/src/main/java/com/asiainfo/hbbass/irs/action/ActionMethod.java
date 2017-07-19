package com.asiainfo.hbbass.irs.action;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 *Action方法的标记是否记录日志等
 * @author Mei Kefu
 * @date 2010-3-10
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ActionMethod {
	/**
	 * 实体对应的数据库表名
	 * @return
	 */
	boolean isLog() default false;
}
