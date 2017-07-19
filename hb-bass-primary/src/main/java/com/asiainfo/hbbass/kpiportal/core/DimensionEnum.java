package com.asiainfo.hbbass.kpiportal.core;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 维度的枚举
 * 
 * @author Mei Kefu
 * @date 2009-8-31
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface DimensionEnum {
	String[] dimensions();
}
