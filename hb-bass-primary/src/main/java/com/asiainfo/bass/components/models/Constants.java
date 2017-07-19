package com.asiainfo.bass.components.models;

import java.io.File;

public class Constants {
	public static final String SESSION_CUR_USER = "$CUR_USER$";

	public static final String SESSION_CUR_THEME = "$CUR_THEME$";

	public static final Integer VALID = 1;// 有效

	public static final Integer INVALID = -1;// 无效

	public static final String DEFAULT_DS = "jdbc/WEBDB";// 默认的数据源
	public static final String WEB_DS = "jdbc/WEBDB";// 前台数据库的数据源
	public static final String DW_DS = "jdbc/DWDB";// 仓库的数据源

	public static final String WEB_DB_NAME = "wbdb";// 前台数据库别名
	public static final String WEB_DB_USER = "pt";// 前台数据库用户名
	public static final String WEB_DB_PASS = "pt";// 前台数据库密码

	public static final String DW_DB_NAME = "hbdwdb";// 仓库数据库别名
	public static final String DW_DB_USER = "pt";// 仓库用户名
	public static final String DW_DB_PASS = "pt";// 仓库密码

	public static final int DEFAULT_PAGINATION_ROWS = 15;// 默认分页条数

	public static final String USER_NOT_LOGIN = "error";// 没有登陆

	public static final String PAGE_FORBIDDEN = "error";// 禁止访问

	public static final String UPLOAD_FILE_DIR = "D:" + File.separator + "upload" + File.separator;

	public static final String SESSION_NAME = "$SESSION_NAME$";// session名称

	public static final String CUR_USER_ID = "loginname";// 当前用户ID

	public static final String CUR_USER_NAME = "username";// 当前用户名

	public static final String CUR_USER_CITY = "area_id";// 当前用户cityId

	public static final String SEPERATOR = "~@~";// 页面上两个sql语句之间的分隔符

	public static final String DEFAULT_TABLESPACE = "BAS_MK";// 默认的tablespace

}
