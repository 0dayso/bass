package com.asiainfo.hbbass.common.persistence;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * 定义数据库表的一对多关系中的父对象
 * 
 * @author Mei Kefu
 * @date 2009-8-24
 */
@Target(ElementType.FIELD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Parent {

}
