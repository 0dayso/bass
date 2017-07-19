package com.asiainfo.bass.components.models;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadBase.SizeLimitExceededException;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;

/**
 * FileHttpServletRequest wrapperRequest =
 * FileHttpServletRequestHandler.parse(request);
 * 
 * @author Mei Kefu
 * @date 2009-7-28
 */
public class FileHttpServletRequestHandler implements InvocationHandler {

	private static Logger LOG = Logger.getLogger(FileHttpServletRequestHandler.class);

	private HttpServletRequest request = null;

	private static int MAX_SIZE = 100;

	@SuppressWarnings("rawtypes")
	private Map fileItems = null;

	@SuppressWarnings("rawtypes")
	private Map parameterMap = null;

	public FileHttpServletRequestHandler(HttpServletRequest request) {
		this.request = request;
		process();
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	protected void process() {
		String path = System.getProperty("user.dir") + "/";

		LOG.info("tempPath:" + path);
		// String path = "c:/";
		// DiskFileItemFactory factory = new
		// com.scand.fileupload.ProgressMonitorFileItemFactory(request,
		// request.getParameter("sessionId").toString().trim());
		DiskFileItemFactory factory = new DiskFileItemFactory(1024 * 1024, new File(path));
		factory.setSizeThreshold(1024 * 1024);
		ServletFileUpload sfu = new ServletFileUpload(factory);
		// sfu.setHeaderEncoding("gbk");
		sfu.setHeaderEncoding("utf-8");
		sfu.setSizeMax(MAX_SIZE * 1024 * 1024);

		try {
			List fileList = sfu.parseRequest(request);

			fileItems = new HashMap();
			parameterMap = new HashMap();

			for (int i = 0; i < fileList.size(); i++) {

				FileItem fileItem = (FileItem) fileList.get(i);

				if (fileItem != null && !fileItem.isFormField() && fileItem.getName() != null && fileItem.getName().length() > 0 && fileItem.getSize() > 0) {

					String fileName = fileItem.getName();

					LOG.info("fileName:" + fileName);

					fileName = fileName.substring(fileName.lastIndexOf("\\") + 1);

					File file = new File(path + fileName);

					while (file.exists()) {
						String dup = fileName.substring(0, fileName.lastIndexOf(".")) + "_dup" + fileName.substring(fileName.lastIndexOf("."));
						file = new File(path + dup);
						LOG.info(fileName + "存在重复文件名,系统自动重命名");
						fileName = dup;
					}

					try {
						fileItem.write(file);
					} catch (Exception e) {
						e.printStackTrace();
						LOG.error(e.getMessage(), e);
					}
					LOG.info("文件上传成功. 已保存为:" + fileName + " &nbsp;&nbsp;文件大小: " + fileItem.getSize() + "字节");

					if (!fileItems.containsKey(fileItem.getFieldName())) {
						fileItems.put(fileItem.getFieldName(), new ArrayList());
					}
					((List) fileItems.get(fileItem.getFieldName())).add(file.getAbsolutePath());

					// 不是上传完毕就事务完成的
					// request.getSession().setAttribute("FileUpload.Progress."+fileId,"-1");

				} else if (fileItem.isFormField()) {

					if (!parameterMap.containsKey(fileItem.getFieldName())) {
						parameterMap.put(fileItem.getFieldName(), new ArrayList());
					}
					String str = "";
			
					try {
						str = fileItem.getString("utf-8");
						// str = fileItem.getString();
						// str = new String(str.getBytes("iso-8859-1"),"gbk");
						// System.out.println(str);
					} catch (UnsupportedEncodingException e) {
						e.printStackTrace();
						LOG.error(e.getMessage(), e);
						str = fileItem.getString();
					}
					((List) parameterMap.get(fileItem.getFieldName())).add(str);
				}
			}

			Map oriParam = request.getParameterMap();

			for (Iterator iterator = oriParam.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();

				if (!parameterMap.containsKey(entry.getKey())) {
					parameterMap.put(entry.getKey(), new ArrayList());
				}

				String[] params = (String[]) entry.getValue();
				List list = (List) parameterMap.get(entry.getKey());
				for (int j = 0; j < params.length; j++) {
					list.add(params[j]);
				}
			}

		} catch (SizeLimitExceededException e) {
			LOG.warn("文件尺寸超过规定大小：" + MAX_SIZE + "M");
		} catch (FileUploadException e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		}

	}

	@SuppressWarnings("rawtypes")
	public void clearFiles() {
		if (fileItems != null && fileItems.size() > 0) {
			for (Iterator iterator = fileItems.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();

				List fileNames = (List) entry.getValue();

				for (int i = 0; i < fileNames.size(); i++) {
					String fileName = (String) fileNames.get(i);
					File file = new File(fileName);
					LOG.info("删除文件：" + file.getAbsolutePath() + " " + (file.delete() ? "成功" : "失败"));
				}
			}
		}
		// 清理完成时，才是整个事务完成
		// String fileId = request.getParameter("sessionId").toString().trim();
		String fileId = request.getSession().getId();
		request.getSession().setAttribute("FileUpload.Progress." + fileId, "-1");
		fileItems = null;
	}

	@SuppressWarnings({ "rawtypes", "unused" })
	public void uploadToFtp() {

		String remotePath = getParameter("remotePath");
		LOG.info("上传文件到FTP服务器" + remotePath);
		List result = new ArrayList();
		FtpHelper ftp = new FtpHelper();
		ftp.setChartset("utf-8");
		// if(remotePath!=null)
		// ftp.setRemotePath(remotePath);
		try {
			ftp.connect();

			for (Iterator iterator = fileItems.entrySet().iterator(); iterator.hasNext();) {
				Map.Entry entry = (Map.Entry) iterator.next();

				List fileNames = (List) entry.getValue();

				for (int i = 0; i < fileNames.size(); i++) {
					String fileName = (String) fileNames.get(i);
					// result.add(ftp.upload(new File(fileName)));
					ftp.upload(new File(fileName));
				}
			}

		} catch (SocketException e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} catch (IOException e) {
			e.printStackTrace();
			LOG.error(e.getMessage(), e);
		} finally {
			try {
				ftp.disconnect();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		clearFiles();
		// return result;
	}

	@SuppressWarnings("rawtypes")
	public String getParameter(String key) {
		if (!parameterMap.containsKey(key))
			return null;
		return (String) (((List) parameterMap.get(key)).get(0));
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String[] getParameterValues(String key) {
		if (!parameterMap.containsKey(key))
			return null;
		List list = (List) parameterMap.get(key);
		return (String[]) list.toArray(new String[list.size()]);
	}

	@SuppressWarnings("rawtypes")
	public String getFileParameter(String key) {
		if (!fileItems.containsKey(key))
			return null;
		return (String) (((List) fileItems.get(key)).get(0));
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public String[] getFileParameterValues(String key) {
		List list = (List) fileItems.get(key);
		return (String[]) list.toArray(new String[list.size()]);
	}

	/**
	 * 返回所有的文件
	 * 
	 * @param key
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public Map getFileParameterMap() {
		return fileItems;
	}

	public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {

		if ("getParameter".endsWith(method.getName())) {
			return getParameter((String) args[0]);
		} else if ("getParameterValues".endsWith(method.getName())) {
			return getParameterValues((String) args[0]);
		} else if ("getFileParameter".endsWith(method.getName())) {
			return getFileParameter((String) args[0]);
		} else if ("getFileParameterValues".endsWith(method.getName())) {
			return getFileParameterValues((String) args[0]);
		} else if ("getFileParameterMap".endsWith(method.getName())) {
			return getFileParameterMap();
		} else if ("uploadToFtp".endsWith(method.getName())) {
			// return uploadToFtp();
			uploadToFtp();
			return null;
		} else if ("clearFiles".endsWith(method.getName())) {
			clearFiles();
			return null;
		}
		return method.invoke(request, args);
	}

	public static FileHttpServletRequest parse(HttpServletRequest request) {

		FileHttpServletRequestHandler handler = new FileHttpServletRequestHandler(request);

		FileHttpServletRequest requestWrapper = (FileHttpServletRequest) Proxy.newProxyInstance(FileHttpServletRequestHandler.class.getClassLoader(), new Class[] { FileHttpServletRequest.class }, handler);

		return requestWrapper;
	}

	public static void main(String[] args) {
		// File f = new File("c:/abc.txt");

		// System.out.println(f.getAbsolutePath());
		System.out.println(System.getProperty("user.dir"));

		System.out.println("m128".matches("[0-9]+"));

	}

}
