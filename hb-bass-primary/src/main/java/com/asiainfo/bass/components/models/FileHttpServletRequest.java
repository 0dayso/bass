package com.asiainfo.bass.components.models;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Component;

/**
 * 上传文件的包装类，使用getFileParameterValues("fileNames")来得到文件的绝对路径(保存在usr.dir下面)
 * 1.如果需要导入到ftp服务器就调用ftpUpload();
 * 2.如果不需要导入ftp(主要是导入数据到库表中)，就需要手工调用clearFiles()来清理文件
 * 
 * @author Mei Kefu
 * @date 2009-7-28
 */
@Component
@SuppressWarnings({"rawtypes"})
public interface FileHttpServletRequest extends HttpServletRequest {

	/**
	 * 得到单个文件，如果是多个文件使用
	 * 
	 * @see #getFileParameterValues(String)
	 * @param key
	 * @return 返回文件名的绝对路径
	 */
	public String getFileParameter(String key);// 绝对路径

	/**
	 * 得到多个上传文件的绝对路径， {@link #getFileParameter(String) getFileParameter }
	 * 只是返回数组[0]
	 * 
	 * @return 返回文件名的绝对路径的数组
	 */
	public String[] getFileParameterValues(String key);// 绝对路径

	/**
	 * 得到所有上传文件的Map {@link #getFileParameter(String) getFileParameter }只是返回数组[0]
	 * 
	 * @param key
	 * @return 返回文件名的绝对路径的数组
	 */
	public Map getFileParameterMap();// 绝对路径

	/**
	 * 清理文件，清理上传到usr.dir目录下面的文件
	 */
	public void clearFiles();

	/**
	 * 上传到ftp服务器，上传完毕后会自动清理usr.dir目录下面的文件
	 * 
	 * @return 成功的文件列表
	 */
	public List uploadToFtp();// 上传文件到ftp服务器

}
